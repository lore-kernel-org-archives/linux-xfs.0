Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D54644B04AD
	for <linux-xfs@vger.kernel.org>; Tue, 15 Sep 2026 11:48:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789472917; cv=fail; b=TKVfji6/qGNmdRxAX4TPSk4QoVMQ/i1lALQPT+Fnx6audavlS36Pq1OnX04NX55dKASKTeBrbR73VKYelqL0UKpWYzyIyGyWkSbTn35UHMBNS2FZzdKatKajGWWChxXzfCY4jzj2DiFIMUOhwwEcaksrhXeuIQENi86LYUytOGg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789472917; c=relaxed/simple;
	bh=ioa6iSFp2tnCWfCzyKKzHnmpcdxmubzvMt7t/BRhz08=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=eq2thbgC498Q7r6NXob3mJnhRFZRn9HlmAGD3qlgXOUWu7b/IFWC2P6gFtjMnrgeZwkplsYHvGPxNiAbkDLFc1GJTmtwttntVw1WEC4EJYzOrUYHOC28YMHrdcTeTLQri8Ntp2As2qzvS60nWJNd/rMvUAZ0jMX2tZgIcuyJXsk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=fYhr1p8w; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=wDzQWahe; arc=fail smtp.client-ip=216.71.154.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="fYhr1p8w";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="wDzQWahe"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1789472915; x=1821008915;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=ioa6iSFp2tnCWfCzyKKzHnmpcdxmubzvMt7t/BRhz08=;
  b=fYhr1p8wZyAvfj0qtu4J58xehudr+1Lh19yP4R6BYVJVASVmriXuw5Uc
   LhTpWkts6Qd5AlXwPdy7FwFGakLw6qVo9RZX8apRLKb3xjOAgYWrrNRjS
   G6Y9xSsSbKG0oiWMmq0wWASSurNqU/u7aV/Own5dry01N4580Kj9xqxlg
   QfzrhfWTLHsni6MRihKj4T8IY2Qh0R44jblo/AZz1RdMFQaf8CNLvDS/A
   wmU/NJ6ZaO9dzH/qtx/0ih44/fZhJxGf/+ukZ0L8Xs393kliYZHoD+OD8
   hQYuDS+XuUCxCSMgDUVctDyablSc8UlwajmobcLBJ0HWlSTPeINMGJYAv
   A==;
X-CSE-ConnectionGUID: EkDBM+S6SVmr9cTbVzfR+g==
X-CSE-MsgGUID: RHg7GxbCSxyh0lNVETvEOw==
X-IronPort-AV: E=Sophos;i="6.27,103,1786982400"; 
   d="scan'208";a="151501498"
Received: from mail-southcentralusazon11011067.outbound.protection.outlook.com (HELO SN4PR0501CU005.outbound.protection.outlook.com) ([40.93.194.67])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 15 Sep 2026 19:48:29 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fL/tiJJTt2Jaa+aIojJVRhKepVzI0TYF/luUpRf/gdxVR6fJZMOOtVaSAmSzA76kDm+dyKyrr+LFwysyZZen94ihFIhZcZ3o7ysRtGvj8O0/L47Nbj5jIenSm6TWK9GaAx/L9dNDmxX9wXSm6lEVKRREny0/G3FVn4u6oORuwhoaQbqbcmCCFJ5UXseABQcQdtBr1xB5Is37MZne/hXkRH4sZXkjOTQv5GDRxWPZhY1cNRkhHaV0mViuJgwoF5i6Tn0HYeuMQR9V/w56wONDuWyLZOqwzIQ6R8x+Z25zWcaVEt6rHHXBb+LiRAHIuThzxG2xitFzUg+a3EE+D80++w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=alJO1NlFSk1XIuDBiOt1OlprXY7EldIQTzYAgMH243Y=;
 b=Rz9MPsLnD+ThnwpveXgFJZrMGRBu0p+gYkVKrBNt7h6eYKiBAfuJ2Pu+ajsIs1v4H3lwgByxuDqUD0KEmeZh1ydctdUmrFbFXE9WILH4u68HV9pED0dEQTiUx1gRDamc+Jalz/n1y6LT8w8qVElMT1BY/ieVaSd21fLfmg1y/wHWFswYwkfDyXRzv16XQD4qSMefZs48mwsWxmVapJAL/whG3d4ICw+Selpe2fXvj/vMZA2w9gV/2lKXll35Y/UF5evhAEKelH5uTEMxsjY7cfZu/r0bkKWaMgENyRfmrcxoAcFqltnKOEW43QEThXDgJ9lvjP1gQg5giu0zNbMQYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=alJO1NlFSk1XIuDBiOt1OlprXY7EldIQTzYAgMH243Y=;
 b=wDzQWaheq7hNx9cfpoQ5jzXj0vR7lKLurAOQkGdAaxWchByCTH2j2FbwoxFsEk7tk7qZlr8yfSgTb4EtbrhyckkHSgFSwjm1SusZBQ5GQI5xGs04543lJmC76HRq0X5p6AcWe9LMia6W6gi3IFWixJDtImF9vJ2y7uE8EM18XP8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA1PR04MB10065.namprd04.prod.outlook.com
 (2603:10b6:806:4dd::14) by SJ0PR04MB7343.namprd04.prod.outlook.com
 (2603:10b6:a03:295::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.9; Tue, 15 Sep
 2026 11:48:26 +0000
Received: from SA1PR04MB10065.namprd04.prod.outlook.com
 ([fe80::9b98:bf8a:b0b1:ef85]) by SA1PR04MB10065.namprd04.prod.outlook.com
 ([fe80::9b98:bf8a:b0b1:ef85%4]) with mapi id 15.21.0406.007; Tue, 15 Sep 2026
 11:48:26 +0000
Date: Tue, 15 Sep 2026 20:48:21 +0900
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: John Garry <john.garry@linux.dev>
Cc: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, 
	"Darrick J. Wong" <djwong@kernel.org>
Subject: Re: [bug report] fstests generic/774 hang again
Message-ID: <aqkv-2opTlWD6bzU@shinmob>
References: <aqkP9CTUvlC2YCIb@shinmob>
 <98190f62-ccc3-49df-934d-f168e293c485@linux.dev>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <98190f62-ccc3-49df-934d-f168e293c485@linux.dev>
X-ClientProxiedBy: TYCP286CA0134.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:2b6::16) To SA1PR04MB10065.namprd04.prod.outlook.com
 (2603:10b6:806:4dd::14)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR04MB10065:EE_|SJ0PR04MB7343:EE_
X-MS-Office365-Filtering-Correlation-Id: aedeb673-91fc-4872-ee3c-08df131f40e7
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|19092799006|23010399003|366016|10067099003|22082099003|18002099003|4143699003|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info:
	tVU6vjoOBzmlT3VhhOTHYvF79eg9cdrLVsdccVanl776r0V/rhQ0A3pg9Swv0D3ppQKpIc38SAdZNdxG+7ZIyjadLXV8KwqLi02AGAlB614zJEANJldPH9I+A0veAj58GXFqlHCKsUmBb7gxlYYM1ASMRcPWAa5sy7Xewqz7IBxeK30jjdVg/s11au+94EQHLLEPp4ArHvVpmjwm6db9joKXYaL91aoOuwbF5VY/UCgFUK6wUag1wzRAdaq/nh3SZnaNaIQ8u9NW/hJ76ZB2PHxNcHVP3OuQcMg6zeX7ypLIuAVmeI4dG/HhX5mWPjNChb35vhc5w0oKYaC73SiDpHofJJloIuXQvY80OKJhxMbbGczUgkQp2warbkWAFax4CZyXCR4APveFqlysdpmKhKhPH0aqtLWR8bL/NGm4q2kE6CFKLPNZpVdHAeFwwsdnQGBQ4nRkczwKnA7+cJjxNH52vTI7JyDRngHRZ/XTnahwdcL/oxwXm2q43a9pN62JXP0pZT1ULXKMn561NW9BcvBSg+TeACh89AP1i/uJQoy+GG4GeFmCGXaoTxL6hOp5dXS/UT3L2UIyJoRY7m6zX/JQjF+2j2IJq0vzqlL3vCM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR04MB10065.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(19092799006)(23010399003)(366016)(10067099003)(22082099003)(18002099003)(4143699003)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?f0XuQWyYrguGKFh1rXYYuZZleTZoCoEm5LMwOexeBEDYm9avSSf6fJNNIjWS?=
 =?us-ascii?Q?iiPJgdv5DJ6hby8ls6pC8GDufUdjhGM9gTqrZXCTn+oMNQ1xhmARGHlKJoXE?=
 =?us-ascii?Q?mnEmwxwH/1u+JMDxyEIfGlkcsUloYFo1gchnjj4uaiEZ5hA4+bciFYrMw/M8?=
 =?us-ascii?Q?bTaMsGbEkZYWdhSPNrOjWeaDvDBL/p4XrkIBSA3ce6pej29jwJW8iWid4NPG?=
 =?us-ascii?Q?g3JI719lx5gfhv1W2tKRSASoYcJ2S718wqYM3A1vtAt/Zx98lKgyXHnCeRH6?=
 =?us-ascii?Q?2a9V65JdsBueE+VBdnJgtitFP/KlM1S0koTEcVMTKiQyT8LX4AMrnibhii/u?=
 =?us-ascii?Q?tYYNmZJC5KtDvJEYk9GfPSI2XRCVfNvqPtHKlhhZR5M5ERXdfZMBv5hU2Czz?=
 =?us-ascii?Q?mR7LhYXs8vGWAeIcvSQBFZUJlOs2HKITH2U7Y2M01X38LtIAE1G86ZRNWZXN?=
 =?us-ascii?Q?+xGfVTIw42S88uUTjwL1A6m7Uvl1tE6DmP6lvYPBVTr9IPF27CeGHLpK0MwZ?=
 =?us-ascii?Q?4+Y+WFf2LA0XY7vJJKMfw/CpG9px4LBoo+KvboEoMZn/cp5sZMALQeiQp6jc?=
 =?us-ascii?Q?N7PesbkAvHyE5kvxuC1KOv7+Udfz3kxxTTpfTY0zDHxt16Z7LH79fCC8A+bO?=
 =?us-ascii?Q?T0Pk+O0PtupFbQI3LcrdLz3Cgjcd+vxM/DPP1fr0uTm+tLqoZVDTLKWtptjd?=
 =?us-ascii?Q?+Jzt1UFYTkCBCvkQVb1V9r9QOX8QGIPgW8HIo9k5wUSZmACpVZDJqgjbMLoB?=
 =?us-ascii?Q?H3aEIaUOQoBo8OGP97JLfJYxWBvSMfNUfcpGLSs9zSJDqQhwalUIcZj30J18?=
 =?us-ascii?Q?z8HY/n2wY1I58ASy20T7SkjrVwxfM4PfBbZyboxeCdJKWBwMZlXkQEY0PWuy?=
 =?us-ascii?Q?uhz71zwJ8xoRrXVO3iZTJTlz/OtVWP8K/fYiKOIj98cUa90tJdZY9RBnBnu8?=
 =?us-ascii?Q?uURK0el7ZgnJo4gRBMigl2p33DnIb5W/6YAFQrU5yHweLz0mXkN0IRxE96gs?=
 =?us-ascii?Q?uWqG1V+OAiMtagzSaIxhUIWaQ2p6FPumfXsgtxieV3RjwHQf4ha0o8s8/UsA?=
 =?us-ascii?Q?oYo48WZPQr2W2AMP694Tf38Uhq0r0kJ+/5sdPjIipBkfZRyMgpE1ezeEP8Be?=
 =?us-ascii?Q?fHxzcReOmkA4WUM2x40QARP14EmiQ3gxHYQTyZC9hG+lFc1kNzhtRJsr77Fh?=
 =?us-ascii?Q?OeABMzwNG+wJ4P2+3wDFsVRiAonLpQI38/n0rCgF84DSDzcdNflgBQNVF7q/?=
 =?us-ascii?Q?8WFaiNfMMRKiDHJKNTbvHMCuH3MSKYix+ZBFWDvlvscrK3sT+hQdqZzwW5FG?=
 =?us-ascii?Q?jU6CueN345241IDPc+HKAV+e+VR/wtED7m2MdNlAfvC+WMfPf4sp3zgCUevi?=
 =?us-ascii?Q?ECVfVprLo1H+LljR+YZGcRGKazHBQw1NhY+n0DVdPfdIV/gAlyNqq6Om07b6?=
 =?us-ascii?Q?taERqOAKR4Z+bNgvwELfk1dxO5RdUz6U4loVBe17SHUrOK8QFDi4m+KwxF/1?=
 =?us-ascii?Q?eizBeZMST0El4kGboo8B5RLYi2s9mYTCGvhsgy4L3nb45UgHakMRxhjtCTeR?=
 =?us-ascii?Q?0/+8jHxjMGs1ZJnOnMKbbmz7yboe2WPNR4Zu+pXf5bGgU8lTIui+8Tz8BuWu?=
 =?us-ascii?Q?ARCNsVed8KL+OjHiK1uvh/BotQF5fs2n20KQEMhb3pyElOjqE7PouGJZzgBQ?=
 =?us-ascii?Q?OkV2wzd0vL1ZYdv3i4KJR0efap9LMa+DgwrIk177a9z4s3b8pwvthok3jaJM?=
 =?us-ascii?Q?aB4G4ffh2S+9gXzJSypwltvZKoBslc0=3D?=
X-Exchange-RoutingPolicyChecked:
	SsxMDDbslNF62E5M7HFGwv9i5bo+ki9KcTVIjFW7Gg+/Y1bOgPwopS8uuYhEmDOTAiY9KMGyEj63OhoCYdSYUCfqg00IjjgRpyNPzQ+KIBjDZrbCjLOSAHJT7cwofhOaJhxyDKCTy7i1GRL4/8hAHf/HsRKutgg5cA/DJ7obLDwLVHNJJkfs3QLHMx1rxwlnP7w+RxPpnxAsRv74PklY+WLWDuhIjgtFb19LPD7/leIg5AFWe4iGQiJ9SIjkezp6WdtkAOV/5bWQ4p0Npc5rNgg3yk+aWoXS7iCEbf4HHYt5hYoM5rR/NxIGR7yfJkxDuWSg5NORPwTbgt7Fjbgvww==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Rk61G+sIog43uTjRVpc5Dngxe6lXw3tks+Vb2a7sNDEG/lczDw/uvvL8ajIxDvTMN3zJuOSNID3AldMvNAgK2VMeOveDUyryqHqJY55+PBQV126GN54M7ij8kFbVN7LoiNELqt7cNpo5TPWHQKpvzlHMvTZ2NwLKiiMagF4G7zf5fomwT7iS9uDetXeeExxKyhXq7ORV4T5g+tEuX7TMJ/tJem0KTYuwW+ZqJ987+YyqByM/ymIu4GXIPp3rqIdm1X+mZq1owPsNZoyXUJSYB4DuVCUi4BeNYFxvdwibAWEdQIlveaeFs+VPBBWoE5mdkMr+iT2W20if0fJbsXnMfcuCGfM+iiBNTpXjs0zWyP1juAzxbHKJy5sEPvsp/zE7ePpPOTE64Sf62R9xUkpAlODGZfLzYp9evvuJkOLiAEDPTcO4dM17I9Ts9aeyPDQqoX4dGcgAyTHPtSShaGbkWBjK2D5OulSL8Za/7rTvDUd1R+2fOm4yG0JwsfBTW9OOewxq9eDE0X5dcQHUa0N4cxD4zbdEpJCTlEcfugm+PLKhODkTvihuewEjI4b1t8P06w4lAOrnfJeCvlup+GP/FEdZY35ZvjD+BvhEIJFkQVpRTHbhQ3g8lt7AFHVpVrsv
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aedeb673-91fc-4872-ee3c-08df131f40e7
X-MS-Exchange-CrossTenant-AuthSource: SA1PR04MB10065.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2026 11:48:26.4981
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cOiQJTRcXgV5LSmi+oG/EfaR9qhupigYPEXlC5rmc8cVu0tdYWAPiUL1fT/TjfsmnuGHWpE/U3ujnbhX5Xo/Gw54ObTRXKN87qQgdJBD9CI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR04MB7343

On Sep 15, 2026 / 11:00, John Garry wrote:
> On 9/15/26 10:34, Shin'ichiro Kawasaki wrote:
> > I observe the fstests test case generic/774 hangs, when I run it for xfs on 8GiB
> > TCMU fileio devices. Actually I once reported this hang symptom in last October,
> > and Darrick and John kindly took some actions [1]. Since then, the hang
> > disappeared and I have not observed the hang almost one year. However, my test
> > system started reporting the hang again last week.
> > 
> > [1] https://lore.kernel.org/linux-xfs/cmk52aqexackyz65phxgme55a3tdrermo3o4skr4lo4pwvvvcp@jmcblnfikbp2/#t
> 
> This was the series to resolve, I think:
> https://lore.kernel.org/fstests/176279908967.605950.2192923313361120314.stgit@frogsfrogsfrogs/T/#t
> 
> As an experiment, can you reduce the file size further, like:
> 
> --- a/tests/generic/774
> +++ b/tests/generic/774
> @@ -29,7 +29,7 @@ aw_bsize=$(_max "$awu_min_write" "$((awu_max_write/4))")
>  fsbsize=$(_get_block_size $SCRATCH_MNT)
> 
>  threads=$(_min "$(($(nproc) * 2 * LOAD_FACTOR))" "100")
> -filesize=$((aw_bsize * threads * 10))
> +filesize=$((aw_bsize * threads))
>  depth=$threads
>  aw_io_size=$((filesize / threads))
>  aw_io_inc=$aw_io_size

Thanks for the response. I repeated the test case 100 times with the change
above, and I did not observe the hang. The change looks avoiding the hang.

> 
> > 
> > FYI, here I attache the kernel message [2].
> 
> Is mainline baseline hanging, i.e. v7.3-rc2?

I will try this out tomorrow.
