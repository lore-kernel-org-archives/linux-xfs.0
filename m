Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47F9A43F8B5;
	Tue, 13 Oct 2026 09:39:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791884359; cv=fail; b=T9SahIPzv3AVKCEoKfEpyhJ25dj6syhcqG+1080xLQnnx7Xi/NIJ2V1JUkN9P2YR6xgPUO3+/c6TacwMnlhAeUt6wcqYQbceBt9p9TNBIqbRWtaFgcm75/LLJVCDbaixV6Gy/HYdQktnqsAfzNvZsZTUfppye/odGC+eLiZg8gA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791884359; c=relaxed/simple;
	bh=DIaCO8pDH1t1mCpKWoWzYFl3/Cr6ehKGYJLOV4pmrVI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=CBGtGf+HWovRPHRMQ9GmNqGtoozi632AIbFeVJ/q12r0AIKA6Cm8q1yfln0VoaXICOfdKSGds64HFvr2j++sZlRvngF9LsIfIfqOR4W5fA/LvwVeTEtvvmBFNj6mFijgT/r4VDnNoIDNXFA+UbOYqdOCutdO4GRQSb/rUQ+r470=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=RGHvhohK; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=hC+XCGjh; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="RGHvhohK";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="hC+XCGjh"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69D2D5bO3033679;
	Tue, 13 Oct 2026 09:39:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=vu+jL9Le6Hqz2uyn0IN7wqWDEuwddl1A6y0rDIhKmuk=; b=
	RGHvhohKHcDVUt72qFljoNAbToCyyKnsF6yym1aQY/SVYNOn2pS55h1+jplehlw5
	EEtAs5Qgn/e2bflTijQQN5CO/mKpKVma3AVupXVRhExktv0gII0n4UFuPdP829JZ
	v5gxW0Wh4OW4GCEUaBf9jCH1fmoPVjnqJK0CVTdvSeh02HZg01O0eBrWgcoV+tvv
	xcTFnqmr7+jy/LDW/JKeGBTo/RufiFpo75AeZFlNOVPv6lHtgstVRGnFjBXsqC31
	vDxsEiCMmzlRT+yrW/uyizEsCtFz7/BYOnN77eNAqwqk0DiDAq1vJzpJMwE57un7
	aBRi7dL8jdjH7z7q2dGEmA==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4h7dwtbpap-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 Oct 2026 09:39:12 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 69D9agEd016159;
	Tue, 13 Oct 2026 09:39:11 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11010038.outbound.protection.outlook.com [52.101.56.38])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4h7btp15w7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 13 Oct 2026 09:39:11 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qOcWzjk9ohREc9z+QXroB70FU6mp8svuSI4VpJf/utfungRXBOVpPsWm9TL6mZxLBgGTdpUg607rsQn6AuJZGh7D/cSTuUN46xn7A7fEIngd16B8vTVCzQrpfAk447xGlRLpns7Pv/1GawCjKOnSIM94F2QteTcKak30rwZA275pKuBkHpOfpZazJc3QQ/R1ttIh0jYySila93iTZJ+AbM9Uzb4rkskIlOvSXguY/wJzV1D9FbNcc4k2TWCGAx4Ic3HGCfhq/bYk3/77YOONrjwmEpvoMk+teSmLKqdDX4FayhrJ3kMvzVaUlJnAbhTejmy1OzAI5DUWsl3DuBrrMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vu+jL9Le6Hqz2uyn0IN7wqWDEuwddl1A6y0rDIhKmuk=;
 b=kMijJEPNOjn61eM4AGBqCELjLCVGpXAIkn4bdvceJTsCKFEc82W4ZzUJPXJjG5gm3fl9le8YfC1zf8Y9+qp6DRmAFWOCHwewy4SE7gmgVMmypsRSmKYjJBcJdllFD9lNmLnWW15l+b65cVvpPXJ8P5LEWytYoYKBbU0+o2fpLJmk0cZ+JaRfA4EHUKCw4JcLIKgRq4dA3ocKHsZPG8KkbpX58RVyB2OrObU8ZF0dN51n7zgMLrjzI46acEimAtLHvudF0+I7gpt0jN0tIQPPFvuLT+MuiSLbL5fEmleBrNjvkulOa57mATM5mURmx5z5/b4eTdYXc0c5H2kAhXl7qA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vu+jL9Le6Hqz2uyn0IN7wqWDEuwddl1A6y0rDIhKmuk=;
 b=hC+XCGjhObtuteC5Sjb9SWERQb+YNGyIUowK0TABcO3A0Iryr26WfRwG0h+bRgz8ZC+399JfamgYUwmQwkkgJTOAcAU6W8wUoEXqDFMzP4/WvO/1M/ThWgSkN/g1XJzNaMjDoloC5zWN53ae7/gEw8hKWKnv1umZP2aZEthSySY=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oracle.com;
Received: from DM4PR10MB7505.namprd10.prod.outlook.com (2603:10b6:8:18a::7) by
 CH0PR10MB4938.namprd10.prod.outlook.com (2603:10b6:610:c4::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.496.9; Tue, 13 Oct 2026 09:39:09 +0000
Received: from DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::f14:5389:d117:967c]) by DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::f14:5389:d117:967c%4]) with mapi id 15.21.0522.011; Tue, 13 Oct 2026
 09:39:08 +0000
From: Siddh Raman Pant <siddh.raman.pant@oracle.com>
To: "Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org
Cc: Dave Chinner <dchinner@redhat.com>, linux-kernel@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>,
        Mark Tinguely <mark.tinguely@oracle.com>
Subject: [PATCH RESEND 5.15 v2 1/9] xfs: log items should have a xlog pointer, not a mount
Date: Tue, 13 Oct 2026 15:08:52 +0530
Message-ID: <4cbf229c1031b04c940f36321403ebd6c2065210.1791883295.git.siddh.raman.pant@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1791883295.git.siddh.raman.pant@oracle.com>
References: <cover.1791883295.git.siddh.raman.pant@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR01CA0002.apcprd01.prod.exchangelabs.com
 (2603:1096:4:191::21) To DM4PR10MB7505.namprd10.prod.outlook.com
 (2603:10b6:8:18a::7)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB7505:EE_|CH0PR10MB4938:EE_
X-MS-Office365-Filtering-Correlation-Id: b17da9fd-8d57-4eed-2185-08df290dd468
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|1800799024|10070799003|366016|22082099003|18002099003|261009223027099003|10067099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	vsw8mKE4DaLSiyhBSCwGBU48/t4/21ACTdSMUWdyBzMs6jcfxAiLTp5dgxdPk+UsXwD+4qEyg810VWAD0tfiz+nQr6y4BVOMI6dUycn4k51QJV9WZ99aafANlm++kfGpb5uPu6YaIzgr1qWVuUXiWtYQ5Xye1gF0C7XOvKVzUXgHBc/7Wb8qDvNdyL9Kn70mx8DroyuwxoQ3FS7Ad2F9W/TJLA/mXFAMBl/Qpa9uRmfKS899rkXTgj8ilN2NbLoMBRBAlX05ul924SfrlzhPq3yJ6kKOjRmbqFNb5N6l8gBStGC8eibO6G6if59uLBiIrYJHZ50d6fwCDl4WVMUjweEy2GHaVjEa7lgH1z2LixASEm/3ouSw4RsBZpCl0bczxoQa+U5w7HSS5a2gZ2J1N/lGkwdDLqGi9Ayy/i7bW1pX+w3Q6vjlHueIawHzXeIstxhcr5lSo4qn36LQdPuJq0Vm0Ln0Pk3RgPVzbYbVM6ze6omZIM0dkJIx4s/yHjnXG5fyNKSZ14AKF3Kx1p00hdXc18KEudcOHXRU2yhF7VDZqMhCIJ4nar9QTWgAiQEp8xqJkGUrVmtpwQ1kFKLwIDUbTSSrjttuLU+XBmX228nzWjhVeaZU69vGL0CYpa/jjDTNaRasmELjs5YY61xLpkKMcTQs+8Y6CswWnuheCp8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB7505.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(1800799024)(10070799003)(366016)(22082099003)(18002099003)(261009223027099003)(10067099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?vSeXXvC3bmsNAGSwMI1dT6civs/MSaynaJw3i1X/h43b+2koTtndKhfbybqh?=
 =?us-ascii?Q?fDkHTXxAQ83bUJkBqAW4Ozuqt26khhvCMOBBfk5EqqInQq/ks4Rnp2JHZPvD?=
 =?us-ascii?Q?dsmxwFpKoFXRWM92CewtNAesBy6H5w+2EiJRGP4db8HaGdoItvbU0nWzR4XS?=
 =?us-ascii?Q?FM2xbY1VAAgsSBvuLYidZJyRnNtGPRRdk8buAPcVyw/KKvl8P401MjMzvnIx?=
 =?us-ascii?Q?m7XU+QJTIxt6l6aNplMacRAVmi+xxmkWoOyYN1/7WsT50I9madzClIdZzWKP?=
 =?us-ascii?Q?A1s+Y69uLDceagrfLe0R0aKuYHNpNt6XA2TkE/08ixh9lkRDV5PRGfoW77Vx?=
 =?us-ascii?Q?ruwldPQeIDEkGAvzL4IeGRRbAziYHpllrGynAeWTEmMWOBAVL7dT2XjdYEi3?=
 =?us-ascii?Q?pGbo0oAS9ecvRfzpAF0pI7lm8arHIroH/MTcqx9DO4QYYjhFrz/isW+N94pI?=
 =?us-ascii?Q?9eiivJyyDHeG2E4ElgA6Fi4xbrZMq7e/f5H6ZA41Q+B3qIwUQ3W3AA94hhwT?=
 =?us-ascii?Q?FaIfNV5nVcFbxUdpgwSnazu214hK5VaLqOTbdd8KNF3oWKreuXPMeETkUQV0?=
 =?us-ascii?Q?IxozxsiolGFg53Kz3pzWUd1YYgLtbPL47vfB/yfqHvwXUKBc3N0fzOoJy+SP?=
 =?us-ascii?Q?Q4s1hw4Ceky0dChwVzaXF2Oj1yXGefl9Z6mAcUqMb1mYLh1zS9SE5kw65FwU?=
 =?us-ascii?Q?Jk+UovU4Cd56o7SuhnN1hALMK/q2FN812SWkPHRt2dBb4e0wBbWAjIUBgTu6?=
 =?us-ascii?Q?qCHIjafhYjja4wRZZT7/gFjUW+TnEfcf3NTeg9ig8IYYDzO8yHzoyuPT2wiZ?=
 =?us-ascii?Q?qwGKeyRVbqriVYomO/5EFDz80mCdU0IbtsMlSNpQ9CWp+BFUR/6Lao9whrba?=
 =?us-ascii?Q?QuWTyMCE8qeZw1MgaC36b2xDI1FPjANTRL+HIAEVEkjune3YdTHf61j2YUEz?=
 =?us-ascii?Q?TG5ZiMvFoQZ6hp8yJjB0fOeTOYUsuZkSwNOUl40olGbzCno/3TyoJl6LhsTH?=
 =?us-ascii?Q?NChmt1KndqHtHYaiY0Y+bCklm3UD/SZnvErLwYBCmcMigB4PHN0vB2CG5GuV?=
 =?us-ascii?Q?/HuyBE1+pH/+vppHS9kXfQ5DI8AYKcLj7RM6Ln83nAvqd794QA83Ldryk7zd?=
 =?us-ascii?Q?oL+gOkUYm9Iso5PCeuheCj0RqOXJgcq4zN03gHfPtwj+aGUwgd8fm+CIgvYG?=
 =?us-ascii?Q?6OTKVhs8dllWxuNPCxdCAMNmI8puhQHdwoYFew9xlf3HCa7VoBg+cF08Rzq6?=
 =?us-ascii?Q?WrGZRHQ+JjSG4n7fAqsBj0wS5WcH7Ctm64BZR4e7jntmdNWNu+2Y/D117gx7?=
 =?us-ascii?Q?7CN7ca9zkviNvXBdSLBaEKKgACkmZlD4Qygq/KsTFA1WQygOnHl1roeEY59F?=
 =?us-ascii?Q?+yBfT7L1N5cOGrfJAGxOxuEQmsFRsb/9WAbAm96jwRyj98idSv9cxu4FtVLn?=
 =?us-ascii?Q?z8xperok/0mpApBZuet2hNcyxrP9/XIQfcrCg+DeV7bIlMNfYQ0ZAq+Ek53a?=
 =?us-ascii?Q?HrKnMz81VkkVYIGPy5RUlFb4hjyWx63dxzhifg0Cg7Ra1bfctbgYmKL+9/CH?=
 =?us-ascii?Q?WL+1QP5C5ZOo2lxkqkgeyE6tnUqrP7XVE6Govy5taw+TA4rQ3RjPryILnahp?=
 =?us-ascii?Q?M3OES2yPDhufYvAlUE87Ucuy1b0BJG2UWN/7LkJgk2ztaEaPTQMpbM9jdyn8?=
 =?us-ascii?Q?9X54+NWapHryJAzaaFWiRcfxRz1fCtCNbyfiE127vifhWeAFrtgAlVwQJ7YV?=
 =?us-ascii?Q?fjRiEQAq7l5J/+oYthra6PvQB6xRBHrsjvWGHpvKqryB6YD+8hc6c8av+9kL?=
X-MS-Exchange-AntiSpam-MessageData-1: g5o95jia8GfQ6DRKj+PoSETthaX/u/pIe54=
X-Exchange-RoutingPolicyChecked:
	bi6XKIoRIOQFhSTfi3qhfvKBHZYsmijK8MoEb+UKYgLElhfwj0jTp5Zly9WMlYsNlKPZwEMDigTzodaaZsgP9CaAFgIe+0JY2QY7kOfAh1NQI0iOfI8bG7xOVEOOmTTtOD6M+ggJJZZQR7Lz5zDSpXFJwCpK2f67YIz+Vlpg+RyYMotyfm/TSblXX8g5zHmnIrSSyPAV/Gx+COy72D0gttRt0dkU84AeO1v79qH54hDY9jkRKc/9A3LIqPrsdRlqnKtElCiJsYj+BNv1NPtHgykdpZ7CjOuqNMCCAkyXru39HhhH/tLfBhrvjIlyaJ/hS5PI4BkJnBMyvqC2/WRlzQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	hruBsGKl1VRcME+Ip66rh/9Utiaytr0f6w8b8oZv9rcZw1/JtHtq9b9IOQfFMzcGy6aBJlk6JzAElKy2pyAfm/nwZTuJ5AQ9RDc6I3SZySO3QACvD1C4jk9w+vSaPyg6rsj4G7DfTh6PhY8V7xMHHebpU1GV4l5a5JzWjCH7Jv5xj285XJDuknZGx4944e+onkk1EA5TH/aqL2Cu8LgRB4Tvh8dhcOPqqjoLTlNtM3Doyxdxmw2JDOFz518eSKK+UCfQAJnXx5QnJjRIIVR4agEGo9cCS7yDBYBxuAJf9sojBHTLeie7u8AbeKQeqp606eJmlYecnn9a1TVkDT4s8kXQksKQZBu14zN0DeOfA3YSF9gaJDdCkNPZfV29nSU+wXgTlXjENx/LGRh2kxaA/YI/tzuxVZStRNk/Emargwxw9mYNgYA+eQTaefIa4TKnIhtnMnMHzZBny+wFe13f1tBXZIJzYD8WR5/OS8YwPuEbaSEHnx4eVTCqCLSKosy2cfY4bGPh62fPse23NK8NAXAAziI8X3g+6GjtRv8mg85LWLzPKZTClr+xKO4V8nbVqnDBq6MiHFhh/B7FF4ksJLdWIVOWwrwr+kceem1TBAY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b17da9fd-8d57-4eed-2185-08df290dd468
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB7505.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2026 09:39:08.8080
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: J+eRu4fK3p5RlzveBE2Lb7J4ro2V/yCSisM8F2mqNe/+aowPhlFKwZg8pE/bUV3MfTSjlUuq+X8A+UTqZuvjloQYLjhEVI/yKqUh+aJw/j0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB4938
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-13_01,2026-10-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999
 lowpriorityscore=0 adultscore=0 bulkscore=0 malwarescore=0 mlxscore=0
 phishscore=0 spamscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2610020000 definitions=main-2610130038
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDEzMDAzOCBTYWx0ZWRfX46PHRUzp0mtB
 UE3MdmzagTe+siuSd+MzVGOPaivCsYADQolSFW5Ac5PgdrtQt70o+jGS/h1bFm6P6w2A9xrfoff
 FLxL+pIM1mFz8pIqEstz5CJyYkyUrdaWTRH7/lrOCWwd3aYZTHNgDmSgs2Dv9svbjLIRDzKL2dH
 M+nQW3t8kvDanMmd6htMav8tNo1DVPfGtK/05jjpx6S5F8CeVH1mrhcBeMHs3n+eA3cpr84PbYF
 XSUbeWW1OKeNFKdRsQLI5JOk8FKby+E7fvO0NuuaxuODDA+qYfkmIs4RKldrZD0FdQqpfEVq+Ax
 Sr4UCzk2c0y6vA2pueOj14wKzdvvC6oJ2WcJfGz3KgymPXbkERSeQVBaaOaIHUhV3FfVBIJ7OVW
 Fh6e08q6nc1rzAIr/LHKwU49LGLF6AP+bEXTfn4hGsYe+NtcNR13mIBluG5acTT6trwrC5Ghvga
 MxLRocWGQvZTIEzZZI5Tez4ZLco4q4NOLba60qQw=
X-Authority-Analysis: v=2.4 cv=Kp7YSmWN c=1 sm=1 tr=0 ts=6acdfc41 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=660iZSQnnn4A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=7Gl3-_t3PgB9XO-mQDs3:22 a=20KFwNOVAAAA:8 a=yPCof4ZbAAAA:8 a=VwQbUJbxAAAA:8
 a=eK9uUbcZqazOid2N2AkA:9 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22
 cc=ntf awl=host:13537
X-Proofpoint-ORIG-GUID: 1g1GECEVCQYc8NHkHS6_DszH4g6blHhr
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDEzMDAzOCBTYWx0ZWRfX3X/d3Ebwtz3u
 I2pOOmQbM19HoB5IN4uf23nHXKpFvCoR9DzF1xkRahVj4zQqsRcSlcdIfg3w/bggRkua3amEyiH
 dBndGH593miS0CX2b/sJklrsGqmsGpr5Posa5HJcnbCxOE1RSn5J
X-Proofpoint-GUID: 1g1GECEVCQYc8NHkHS6_DszH4g6blHhr

From: Dave Chinner <dchinner@redhat.com>

Log items belong to the log, not the xfs_mount. Convert the mount
pointer in the log item to a xlog pointer in preparation for
upcoming log centric changes to the log items.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Chandan Babu R <chandan.babu@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
(cherry picked from commit d86142dd7c4e10e50bdb3679b405d748214b2c28)
Stable-dep-of: 7b5f775be14a ("xfs: fix unmount hang with unflushable inodes stuck in the AIL")
Signed-off-by: Siddh Raman Pant <siddh.raman.pant@oracle.com>
---
 fs/xfs/xfs_bmap_item.c     | 2 +-
 fs/xfs/xfs_buf_item.c      | 5 +++--
 fs/xfs/xfs_extfree_item.c  | 2 +-
 fs/xfs/xfs_log.c           | 2 +-
 fs/xfs/xfs_log_cil.c       | 2 +-
 fs/xfs/xfs_refcount_item.c | 2 +-
 fs/xfs/xfs_rmap_item.c     | 2 +-
 fs/xfs/xfs_trace.h         | 4 ++--
 fs/xfs/xfs_trans.c         | 2 +-
 fs/xfs/xfs_trans.h         | 3 ++-
 10 files changed, 14 insertions(+), 12 deletions(-)

diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index 51ffdec5e4fa..631dbf945310 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -465,7 +465,7 @@ xfs_bui_item_recover(
 	struct xfs_bui_log_item		*buip = BUI_ITEM(lip);
 	struct xfs_trans		*tp;
 	struct xfs_inode		*ip = NULL;
-	struct xfs_mount		*mp = lip->li_mountp;
+	struct xfs_mount		*mp = lip->li_log->l_mp;
 	struct xfs_map_extent		*bmap;
 	struct xfs_bud_log_item		*budp;
 	xfs_filblks_t			count;
diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index 9f8225ed234e..5eb6d787ed4e 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -21,6 +21,7 @@
 #include "xfs_dquot.h"
 #include "xfs_trace.h"
 #include "xfs_log.h"
+#include "xfs_log_priv.h"
 
 
 kmem_zone_t	*xfs_buf_item_zone;
@@ -428,7 +429,7 @@ xfs_buf_item_format(
 	 * occurs during recovery.
 	 */
 	if (bip->bli_flags & XFS_BLI_INODE_BUF) {
-		if (xfs_has_v3inodes(lip->li_mountp) ||
+		if (xfs_has_v3inodes(lip->li_log->l_mp) ||
 		    !((bip->bli_flags & XFS_BLI_INODE_ALLOC_BUF) &&
 		      xfs_log_item_in_current_chkpt(lip)))
 			bip->__bli_format.blf_flags |= XFS_BLF_INODE_BUF;
@@ -616,7 +617,7 @@ xfs_buf_item_put(
 	 * that case, the bli is freed on buffer writeback completion.
 	 */
 	aborted = test_bit(XFS_LI_ABORTED, &lip->li_flags) ||
-		  xfs_is_shutdown(lip->li_mountp);
+			xlog_is_shutdown(lip->li_log);
 	dirty = bip->bli_flags & XFS_BLI_DIRTY;
 	if (dirty && !aborted)
 		return false;
diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index a4b8caa2c601..8833b1590310 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -597,7 +597,7 @@ xfs_efi_item_recover(
 	struct list_head		*capture_list)
 {
 	struct xfs_efi_log_item		*efip = EFI_ITEM(lip);
-	struct xfs_mount		*mp = lip->li_mountp;
+	struct xfs_mount		*mp = lip->li_log->l_mp;
 	struct xfs_efd_log_item		*efdp;
 	struct xfs_trans		*tp;
 	struct xfs_extent		*extp;
diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 68473e51593f..e65bbbde6e37 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1072,7 +1072,7 @@ xfs_log_item_init(
 	int			type,
 	const struct xfs_item_ops *ops)
 {
-	item->li_mountp = mp;
+	item->li_log = mp->m_log;
 	item->li_ailp = mp->m_ail;
 	item->li_type = type;
 	item->li_ops = ops;
diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index eafe30843ff0..af91ea1025c0 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -1428,7 +1428,7 @@ bool
 xfs_log_item_in_current_chkpt(
 	struct xfs_log_item	*lip)
 {
-	struct xfs_cil		*cil = lip->li_mountp->m_log->l_cilp;
+	struct xfs_cil		*cil = lip->li_log->l_cilp;
 
 	if (list_empty(&lip->li_cil))
 		return false;
diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
index 8ef842d17916..cc9bda6b6277 100644
--- a/fs/xfs/xfs_refcount_item.c
+++ b/fs/xfs/xfs_refcount_item.c
@@ -459,7 +459,7 @@ xfs_cui_item_recover(
 	struct xfs_cud_log_item		*cudp;
 	struct xfs_trans		*tp;
 	struct xfs_btree_cur		*rcur = NULL;
-	struct xfs_mount		*mp = lip->li_mountp;
+	struct xfs_mount		*mp = lip->li_log->l_mp;
 	xfs_fsblock_t			new_fsb;
 	xfs_extlen_t			new_len;
 	unsigned int			refc_type;
diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
index 15e7b01740a7..06d86a6fa128 100644
--- a/fs/xfs/xfs_rmap_item.c
+++ b/fs/xfs/xfs_rmap_item.c
@@ -512,7 +512,7 @@ xfs_rui_item_recover(
 	struct xfs_rud_log_item		*rudp;
 	struct xfs_trans		*tp;
 	struct xfs_btree_cur		*rcur = NULL;
-	struct xfs_mount		*mp = lip->li_mountp;
+	struct xfs_mount		*mp = lip->li_log->l_mp;
 	enum xfs_rmap_intent_type	type;
 	xfs_exntst_t			state;
 	int				i;
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index ebd17ddba024..3682dd11581a 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -1309,7 +1309,7 @@ DECLARE_EVENT_CLASS(xfs_log_item_class,
 		__field(xfs_lsn_t, lsn)
 	),
 	TP_fast_assign(
-		__entry->dev = lip->li_mountp->m_super->s_dev;
+		__entry->dev = lip->li_log->l_mp->m_super->s_dev;
 		__entry->lip = lip;
 		__entry->type = lip->li_type;
 		__entry->flags = lip->li_flags;
@@ -1362,7 +1362,7 @@ DECLARE_EVENT_CLASS(xfs_ail_class,
 		__field(xfs_lsn_t, new_lsn)
 	),
 	TP_fast_assign(
-		__entry->dev = lip->li_mountp->m_super->s_dev;
+		__entry->dev = lip->li_log->l_mp->m_super->s_dev;
 		__entry->lip = lip;
 		__entry->type = lip->li_type;
 		__entry->flags = lip->li_flags;
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 95c183072e7a..5eec011841b9 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -648,7 +648,7 @@ xfs_trans_add_item(
 	struct xfs_trans	*tp,
 	struct xfs_log_item	*lip)
 {
-	ASSERT(lip->li_mountp == tp->t_mountp);
+	ASSERT(lip->li_log == tp->t_mountp->m_log);
 	ASSERT(lip->li_ailp == tp->t_mountp->m_ail);
 	ASSERT(list_empty(&lip->li_trans));
 	ASSERT(!test_bit(XFS_LI_DIRTY, &lip->li_flags));
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index faba74d4c702..d655abb5c235 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -8,6 +8,7 @@
 
 /* kernel only transaction subsystem defines */
 
+struct xlog;
 struct xfs_buf;
 struct xfs_buftarg;
 struct xfs_efd_log_item;
@@ -31,7 +32,7 @@ struct xfs_log_item {
 	struct list_head		li_ail;		/* AIL pointers */
 	struct list_head		li_trans;	/* transaction list */
 	xfs_lsn_t			li_lsn;		/* last on-disk lsn */
-	struct xfs_mount		*li_mountp;	/* ptr to fs mount */
+	struct xlog			*li_log;
 	struct xfs_ail			*li_ailp;	/* ptr to AIL */
 	uint				li_type;	/* item type */
 	unsigned long			li_flags;	/* misc flags */
-- 
2.53.0

