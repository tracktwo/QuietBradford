class UITacticalHUD_ScreenListener_QuietBradford extends UIScreenListener config (QuietBradford);

var config array<String> NarrativesToRemove;

// Hook the tactical HUD to modify the narrative moments template to strip out the 
// narratives we don't want to see. Ideally these would be replaced with empty ones,
// but this is not yet working. Instead, just replace them with bad narrative moments,
// which appears to work.
event OnInit(UIScreen Screen)
{
	local XComTacticalMissionManager MissionManager;
	local X2MissionNarrativeTemplateManager TemplateManager;
	local X2MissionNarrativeTemplate NarrativeTemplate;
	local string narrative;
	//local XComNarrativeMoment DummyMoment;

	MissionManager = `TACTICALMISSIONMGR;

	// Ok, we're in a retaliation mission. Now hack up the narratives template to replace the ones we don't want
	TemplateManager = class'X2MissionNarrativeTemplateManager'.static.GetMissionNarrativeTemplateManager();
	NarrativeTemplate = TemplateManager.FindMissionNarrativeTemplate(MissionManager.ActiveMission.sType, MissionManager.MissionQuestItemTemplate);

	foreach NarrativesToRemove(narrative)
	{
		ReplaceNarrative(NarrativeTemplate, narrative);
	}

	// Using a real replacement narrative moment not yet working...
	//DummyMoment = XComNarrativeMoment(DynamicLoadObject("QuietBradford_NarrativeMoments.DummyNarrativeMoment_X2", class'X2NarrativeMoment'));
	//`HQPRES.UIPreloadNarrative(DummyMoment);
	return;
}

function ReplaceNarrative(X2MissionNarrativeTemplate NarrativeTemplate, string Narrative)
{
	local int i;
	i = NarrativeTemplate.NarrativeMoments.Find(Narrative);
	if (i >= 0) 
	{
		// Just use an empty string to strip out the narrative moment. This is super hacky, but appears
		// to work. I'd rather use a real narrative moment with an empty audio stream but so far no luck getting
		// it to work.
		NarrativeTemplate.NarrativeMoments[i] = "";
	}
}

defaultProperties
{
    ScreenClass = UITacticalHUD
}