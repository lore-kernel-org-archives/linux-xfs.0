Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1F744B95C2;
	Tue, 13 Oct 2026 09:41:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791884492; cv=fail; b=cVOJ2z3b/fJrC5aXlqoniFiGJ6RsMEhGn3i5pafmRZ2svCMJeYWRfuEPvmFIzKALuBajXroeBeSM2FEf9eDfWh4ZKL1FPWvbYaEGFtnhmvdgKeE9s/VWe1uiUgFAlkNGESjKFBa8MImBP3nBhe/Svi32jCma3gN2bKxOziI8TKM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791884492; c=relaxed/simple;
	bh=aoE4z7mrIG+VYx0AXaN+MMFeFXr08Okye1x7UB152/g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=jEIfZk09Swq3KDXfd6VD0bTyWJ098DDEsFiKu/dsAtAf6bgru6vK+MoKj7ZHEk9N84XZatbGwk3d+5voCPDoq8PqCQFzikZAmJRRIP2bSL22nfkTUbY4trcG0uWsq5phptjhuIVMjOD2Qi2WAlSZYIVoZ23zkAox+quYMVyGctM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=m7ExLX8b; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=MLuASOCW; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="m7ExLX8b";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="MLuASOCW"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69D2Eg794066079;
	Tue, 13 Oct 2026 09:41:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=CoHvOTW192irl/rAMFnXJELl5aPdanZ8jdEmfVC+OTo=; b=
	m7ExLX8bgno+1faZI9h5ftmS26n5ttYfb+1y1SKy6bBrFZ3kKsBLEO9O/B9G0jA9
	Fi8uA7nUyQTbyPBqZXjIQKprzTD0n2YguPqpTHqMnCUy4/vKmt8ZqhiK0wX9Whkp
	KrsmeO6gH7gq+8lvQWYrZ6F3Ohfiofkv7ugDIQiJxj7dteTPwfX4ig880yrASpnM
	651mafhr0YXFEipwpdLM6nJWM1Sk8rpG4f8BqxzB7vdDepGJz4eFEQ9z2BpEZkb9
	NdelSLQgrHJz19Rb77YYHJZI6iVEGL/NlXNJb+AT4Vb0aHrslYXZZ0GtMyl6lYlW
	1nveiQwnp3OUgxAKyjII7A==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4h7dbkkqdn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 Oct 2026 09:41:25 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 69D9aeQR002169;
	Tue, 13 Oct 2026 09:41:24 GMT
Received: from bl0pr03cu003.outbound.protection.outlook.com (mail-eastusazon11012070.outbound.protection.outlook.com [52.101.53.70])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4h7btjuw9u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 13 Oct 2026 09:41:24 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nLCTYlSkmexceSr0oZjPZIY74m1GP3Mpf/ikpTZBn89t0bTrIlolScrTrTc7D3/hJxAB2UNo53wdEn8ESfK2rbqzUIu2omnwcOMdiwlIwlP4qSUQ74z96AEP4XQa5pJJeUDzs8iDOYPybXGFsN0Cu2flZDgkoQIjw8KIIZ3fY3TfVCiEc39EEICowWBKztd7BCB9EwJYg83LyKZva+7InefyehFAfBGdM3JeS7o0RUXi50JdVVbtBpyB+KnVVC2w1xZpWvHAg0S9GnA6il0I6Ro0Llm37nsM9x5ZCSp7YidoxLG2l+3nAnJ1qJEyHvRfurI+ww3XMCiT3TCeKi1sPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CoHvOTW192irl/rAMFnXJELl5aPdanZ8jdEmfVC+OTo=;
 b=L5+aLpowsskNEM9mipDwaIUWsQWqGa10UXNKjRdPjKwrhGiFlK1unOsu5u0yG32QfaHBcZ6mrFtN+/C+NJIGqS+QuXh66TQoTwnw10SDQUdtJ2A6VZn1SvMUK8wB80qAWEGhcCDjwqdEYxew7egN+p4Pyz1Jopf407+Q89Hgu3oW8QzmVOJqW637tQCzsRodbHon8Nc2iHejmJGFAuPQjLzK3QW/aD/FFY+2SS0U4l4BDMW6KuJWmjmc+N0tcuwA3SyhI+wK3T5dq6IMRdj4E2mXyN2GPOimTqzyvdBvOmDA1wZL9CcHNEhebN9X8HepGXK/7LWbUQ2Sf4EWaao6KQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CoHvOTW192irl/rAMFnXJELl5aPdanZ8jdEmfVC+OTo=;
 b=MLuASOCWzFce7/Le4IpTY4qud9YCs67j9YyghGrZS6rx47G2858NGV+xR/knmYOUx1QoJUX5fgq0wLqIpRskXOMwyZpCgdkxVRw89zwBDxlNmnJ/9aVdO/QzimMqWc3OVPrrSk0NMLtkV6BAsu1Rvi5Ea8dT+/TrTtEOAKLN16E=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oracle.com;
Received: from DM4PR10MB7505.namprd10.prod.outlook.com (2603:10b6:8:18a::7) by
 DS4PR10MB075839.namprd10.prod.outlook.com (2603:10b6:8:3ec::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.12; Tue, 13 Oct
 2026 09:41:22 +0000
Received: from DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::f14:5389:d117:967c]) by DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::f14:5389:d117:967c%4]) with mapi id 15.21.0522.011; Tue, 13 Oct 2026
 09:41:22 +0000
From: Siddh Raman Pant <siddh.raman.pant@oracle.com>
To: "Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org
Cc: Dave Chinner <dchinner@redhat.com>, linux-kernel@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>,
        Mark Tinguely <mark.tinguely@oracle.com>
Subject: [PATCH RESEND 5.10 v2 17/19] xfs: rearrange code in xfs_buf_item.c
Date: Tue, 13 Oct 2026 15:09:46 +0530
Message-ID: <308d53fdb1acca14d32b86f6224c9d0febc7d7a2.1791883301.git.siddh.raman.pant@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1791883301.git.siddh.raman.pant@oracle.com>
References: <cover.1791883301.git.siddh.raman.pant@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PN3PR01CA0138.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:bf::10) To DM4PR10MB7505.namprd10.prod.outlook.com
 (2603:10b6:8:18a::7)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB7505:EE_|DS4PR10MB075839:EE_
X-MS-Office365-Filtering-Correlation-Id: 43cb1a57-a358-495a-305f-08df290e2403
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|10070799003|23010399003|376014|366016|10067099003|261009223027099003|6133799003|18002099003|56012099006|22082099003;
X-Microsoft-Antispam-Message-Info:
	AsYXqvJUjSvZD4kbGbgmrjRv8DHF2eLZsI8y9jNA+lxkATknql8B03oqnTPni4+BiyJGIpYe3kGvW4/TTs+hIc79NCcoR5YrRF64wb0KhmbDrjk1ONdXEMu+uXXxR8npMpSlnx4av0uFb1Bocva3cHkp0ecUWSMXb0sDyim6nFjFyf5vCsVIjzay76cuhFU3IqbIChVMIYdcj3EByChWpSo2egZrl30vDAgYQIidOWUAb50fRNA6JMyHZQ+n1zd7ScvAfFhn5DjXUBeTNoz9LkoLJGbbyxDbeagsRym260Ak9QDRcx2B2xEAGr0iLd+tg1qAlYiH0r+0nXIxVnnbmrP/NE/pdvxXaABOqOQXPVokoV04PyAe3Bm9PDy0IWTLlbWew9QCLIcd3Jj86X3lM/Epkzu0w77GNTeB4Rpg61mT5rxVT2W5Om4nKqdOLksi98XjM4eqMcqrRk6npteAISEWD4V1PqJjrOHDkr3zP2FtKPUFYJa0zC5GQh20VWBqCZK3FMzC397nsxzl0GlEB94fSlb00/GjmIm2osXW/aAqoRgfmdQUDsogy8g//uSvu+mbKpm7OWOZ4X2jrYGwb2h20aDzgHJlHdnRPNZBSrkXg0R443pW5IaBU+c/iRoX2wzZOXnXbPE6vhUf/4K0+IWibgDoKzwIVFxuUKE4s/g=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB7505.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(10070799003)(23010399003)(376014)(366016)(10067099003)(261009223027099003)(6133799003)(18002099003)(56012099006)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?U7B3vHpEB288EK1GXwXWxaMmeo24zkWF29Y4qU48CdD5G2A8Q8ZgEtiW1X6K?=
 =?us-ascii?Q?pg9lBIq6ilUlgPjYJxccRogQNKpOJ+1TM2OOACuuNghh4yLWOwpHOt81naCC?=
 =?us-ascii?Q?0CO0P2Ig3FxUZNGGIwf1GFTEuG418j6eJB+pDBUkPxCdCxjJUfo0CvQfoheL?=
 =?us-ascii?Q?VSnhHgwPc2fw/AYQEkJMz9ZY2of24/ApsErqhFo1w+MILRsF8ICEvwqCvcST?=
 =?us-ascii?Q?tE3LOTfGfdwcY0wkdslEoPkmvE+83F+If3TdpONf+HgzY3i3PUY5y9AQafj8?=
 =?us-ascii?Q?cAFqUhy051lS7O9d8q38VbO8NWigWfimS31kJlRZVS2WqXYuxua5aPw/Omrs?=
 =?us-ascii?Q?xPKoxt/KzNP4EjyfZQpl5nbvy6Slbki2CEPMtYAe6GtNbzDL3/s7Q1BhAQvJ?=
 =?us-ascii?Q?bbpvxKRWRoAGlrMGHE1YzrzyWSonEzI6E2VnjNMOuVIAXR+I5YLaYA8bJSzb?=
 =?us-ascii?Q?gd3i4iLvvzXMtzhTOke0pSDOGPo06JlEXXdQrpxmtd/x4xljIGnGwSKhot5u?=
 =?us-ascii?Q?4Nixam/K/3wHwx34mNEXNqXzgdODho9SWySMshJoMafxrJehV1a6TeEg/k6A?=
 =?us-ascii?Q?b0/8KLwskGvjGXx8lWVP7Merm1Sa7DaiWIrW1uMAM10GnuREthWVa1AoAhcW?=
 =?us-ascii?Q?a0qU79fLZVksvF8hZTfpyK/BkKzPmFhp9AI+3Ssu4U9vYpQrvZORms1t8yFY?=
 =?us-ascii?Q?ZBVP76cbxo4M4n6aKqL7UIMAX838vhGthCtMqe59xpSmyWPsKqM2ay3zVLDa?=
 =?us-ascii?Q?qn4+DuAS6eOhU6k6pSPS2CGC7fHAFgNlpPnD0Bk/05qj6/0TQRhLtxLgJKhd?=
 =?us-ascii?Q?kphu4tAHarWbhBSacQSaVZlowk20VCaIVs68jE2CG9B8CTn5JY5WbG9bICzD?=
 =?us-ascii?Q?EVvp/0dkqXMQtVDiGdtzorIZmbs372yndJH6d3aj9WJklApaSc2ZIkqQ+J3v?=
 =?us-ascii?Q?Xc4kNEu6TXCsuJn+ugTnfPrXrE08x3M62oVr8Lzd94HHqtpfcrQzFTANjpN5?=
 =?us-ascii?Q?Sp0Aq8JSW+dID1EO6N3BZO6wD0gEegc4tHjXqaACsZGerr9fLGxXJXbTqNAS?=
 =?us-ascii?Q?taNCaxNSWAwCRh883uP9T/vOwjQhvmqXUtyTDOjH5zdoL6NvuanNDTfhGY72?=
 =?us-ascii?Q?BFePuhXzoLh87TYBJpoIDIQ1H8h3AAOM98qMBe8mCu4XEOwfCNs4SBb57ynH?=
 =?us-ascii?Q?FXymI3oMV3VljwYtyBQ2ReBA57RYC7rVlxBbj4bTMnhmwH7FiB4/yOH6OBhq?=
 =?us-ascii?Q?Fd5gQ8CXuHiPAoG7gd4cha4buefiPDMsryfRRPbWoW7XnHZZm5WwjaMStdTL?=
 =?us-ascii?Q?qdxnyWu3nUdYXi7opK1WQP3oXMO2a8ExBKIlLia0NyOwKUu1qfdSA3iWywBV?=
 =?us-ascii?Q?PeTgcLW4fyZIsrdTPFsCBatEmS4/XCW3qh6W3y4ut+BVSgQSq1lZb5qU+7l1?=
 =?us-ascii?Q?IOjEM0ynvFYdyf6qokb2as9eKAPUxUmpHigyJ5tkOwl8VJua4UfR0ZcaQogZ?=
 =?us-ascii?Q?9S95qdxwCDz5KEpbaSVeVwMOywNwe8Z4MssasuBNbCh1+GHtLHV+yDwt0EkD?=
 =?us-ascii?Q?4GbvpR6WyFrovSG+prCs5fsyYHnYS5muJk/wZY2FMp4lRot1WNGkyQKM/VJI?=
 =?us-ascii?Q?xXE/mSgrhtTCEbTI1dI0CHJkFa5ubcFpKtOTK3amp8WX1Exl7FDDL/6Ni33e?=
 =?us-ascii?Q?8wHMqTVOx5TIlIdUBRNz1XGn1UenWBxDp/I/JoYMxj73IiQ6cC13zE9VV/Ae?=
 =?us-ascii?Q?yonSyC5H6wotJd9tc4p/xCvCjw9iJYndtX0u13vG08xdWbCnbv7WPEenjoDL?=
X-MS-Exchange-AntiSpam-MessageData-1: zsVubv8NeRqDMIVR3bdWbE1SdZ7WdYlPU7s=
X-Exchange-RoutingPolicyChecked:
	dt53uW9NYkS88+gy2mV5qktVfVP6nuJau92UAn4QJARz90NGpVTenXKvDKGNCS43datuWwQTwZQgHv85IlviFC/dwoFoSCUJ/p3QMwN0JTe6PjWZUJEmNZ56E4ihNRlnWqsoLYqEBcENiOHdrD8MLo66KRqxUXgobPTywdKcDIQWKk4dZMAbodb90H1AHPhs07zQUe8Ub5Pj1Ibvb+QihS8Kyqw+iKmE3oqLPQtLf3Uj2EJhGxA6UvH7IyBYWA3+BHkf1Krmp1Yej6QCPMRqkXQ7+JIjxRnVBLXvhXaNl7XcAYfCSUEYK6n8CCYINl3Bf4c/EYjQQWw+59FElmfWEg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	KIY5mR9Np4um6H3O7viL+NveR+LoKHX2iUJGdylKDq39WoZBSwmCHcs1cXym/Wr2C92px6CUpaJnernYZlDQXeARdpQXFXpFxP8IXzYvHwRhifNJDpnNiWhxerI9JkYFjQyfZOyakTDTvi3uqWbCZHSW2oRWfWdyZ1FQM+2tusaVoWwCNltZxRP8/pktTcVAg565iCjkNyZKh+DiPMSugBjXidasVZ4cr6M2SfBHyR3e0WDVlvxPkWsqu2sBUN1HFtO2oPNBdhNxT3IAMbN5MxfJMOrbGCLmIxKwge85FjKi5l3JLyTsSJZUNDVdagNcRkw6SQMgjppf5sjlP3+Od6OwBopTjje/1UHXtqcqPx2db00lITWlsysNLZzjQxvqmtSEvFI5OhQn97Elp0/TM52J5RlXcHqSSCYYVhyptXd5v+mCDD8aB1yCM2mquf3+H+/yJzGgMb7PhSid7qx1m/YjDEqyjbJelTNeULVmQzL0xy0lz8Gl0qbS+QWWAxGBK1ueAo9MQ6iCIZep0rni6Fme/+8eaPiKN//vwP6HJARlbItiv4FEj2WddPY2nb/homGXHq723Ui9x0+H7mNayZv52G9K0n0J1hxbXUX6pVg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 43cb1a57-a358-495a-305f-08df290e2403
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB7505.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2026 09:41:22.3774
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4ltxL1FCyjomn+O4Zx+MfRYVH4HSo7E4vcxKUXhwR2YtZOKHgDiOOqSs2X9tifjydXJIlYV0AWVAk6eU8B3cvD/8mfGcGE5rNWTlwlg5kYc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PR10MB075839
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-13_01,2026-10-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
 adultscore=0 mlxscore=0 mlxlogscore=999 bulkscore=0 lowpriorityscore=0
 spamscore=0 suspectscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2610020000 definitions=main-2610130038
X-Authority-Analysis: v=2.4 cv=Ra0FmFtv c=1 sm=1 tr=0 ts=6acdfcc5 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=660iZSQnnn4A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=x0eKOSpe3m1H3M0S9YoZ:22 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
 a=-BFCJ2bJgao7vN__fc8A:9 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22
 cc=ntf awl=host:12108
X-Proofpoint-GUID: s5XRp1oIC1HYUnuwnFsZqkTWHadFAZR6
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDEzMDAzOCBTYWx0ZWRfXxkUO5h0EFTO9
 F0A/pY+TBXuaNfL/FEPQmOpQN7NT79RflKtq7wmATuD5xT4XRcuoYyPaatwt7tqrkztwA5rvJ/G
 ORqE0xTIKZHd9H17xghct7lXb9Fl8ZYhZjCTdjsyqfwsYT0AGgyXvBGm/YMLoL+Nfmu+myDY4En
 zBVQJ47eN8JkxkgFdHTHDEWBIT/PQHc4gt66UZ+6TJurbqNId3YeSagcfqcquChJk5LmVwWgHQt
 TdrG3KO+oVt+Hnob4ptfTypLnBiMM0GVvuIYhgYK0uNCO0HvgKRyjAkftpM3+dxjmZQDFqCGv+2
 QpvMBjGVJ3aLra5bVCClhqvBukhQb51nMamg6tWjt61mzk8AUXL+DSUXX7xzZJEmoS67G7niVU3
 uOQ0W1PzRwZG6GmJ2IBGRz9uX0/IF5XU1ey7gY9BenKDGmHXzo2bducn0Cy0r853kBPT/ac0cNC
 fHHYZDS6Hj8HyhYWqftu1ZQttohx9hEk0cuNThFs=
X-Proofpoint-ORIG-GUID: s5XRp1oIC1HYUnuwnFsZqkTWHadFAZR6
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDEzMDAzOCBTYWx0ZWRfX7i64aYeXLr5O
 1ts+ghiI4huHIvpNgsYcUwkx74vVBeJY0UawSMB6k1DBSktIRKYcb9ty5UWMP/IiyW+7NxQ1rXr
 klU4XFZ7/LNq1dHQ1jhkslnBs4a8hVEOJG+HRoLd/KyD0aitQJtc

From: Dave Chinner <dchinner@redhat.com>

The code to initialise, release and free items is all the way down
the bottom of the file. Upcoming fixes need to these functions
earlier in the file, so move them to the top.

There is one code change in this move - the parameter to
xfs_buf_item_relse() is changed from the xfs_buf to the
xfs_buf_log_item - the thing that the function is releasing.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
(cherry picked from commit d2fe5c4c8d25999862d615f616aea7befdd62799)

6.6:

Fixed conflict due to the following missing commits:
	[Continuous range: 10634530f7ba^..d4c75a1b40cd]
	d4c75a1b40cd ("xfs: convert remaining kmem_free() to kfree()")
	49292576136f ("xfs: convert kmem_free() for kvmalloc users to kvfree()")
	afdc115559c5 ("xfs: move kmem_to_page()")
	f078d4ea8276 ("xfs: convert kmem_alloc() to kmalloc()")
	10634530f7ba ("xfs: convert kmem_zalloc() to kzalloc()")

Removed ASSERT in favour of existing atomic_read-and-return in
xfs_buf_item_relse() due to the following missing commit:
	3762113b597f ("xfs: don't lose solo superblock counter update transactions")

5.15:

Fixed conflict due to the following missing commit:
	182696fb021f ("xfs: rename _zone variables to _cache")

Signed-off-by: Siddh Raman Pant <siddh.raman.pant@oracle.com>
---
 fs/xfs/xfs_buf_item.c | 118 +++++++++++++++++++++---------------------
 fs/xfs/xfs_buf_item.h |   1 -
 2 files changed, 60 insertions(+), 59 deletions(-)

diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index f864e0b8a805..3124f96ad6b3 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -31,6 +31,63 @@ static inline struct xfs_buf_log_item *BUF_ITEM(struct xfs_log_item *lip)
 	return container_of(lip, struct xfs_buf_log_item, bli_item);
 }
 
+static void
+xfs_buf_item_get_format(
+	struct xfs_buf_log_item	*bip,
+	int			count)
+{
+	ASSERT(bip->bli_formats == NULL);
+	bip->bli_format_count = count;
+
+	if (count == 1) {
+		bip->bli_formats = &bip->__bli_format;
+		return;
+	}
+
+	bip->bli_formats = kmem_zalloc(count * sizeof(struct xfs_buf_log_format),
+				0);
+}
+
+static void
+xfs_buf_item_free_format(
+	struct xfs_buf_log_item	*bip)
+{
+	if (bip->bli_formats != &bip->__bli_format) {
+		kmem_free(bip->bli_formats);
+		bip->bli_formats = NULL;
+	}
+}
+
+static void
+xfs_buf_item_free(
+	struct xfs_buf_log_item	*bip)
+{
+	xfs_buf_item_free_format(bip);
+	kmem_free(bip->bli_item.li_lv_shadow);
+	kmem_cache_free(xfs_buf_item_zone, bip);
+}
+
+/*
+ * xfs_buf_item_relse() is called when the buf log item is no longer needed.
+ */
+static void
+xfs_buf_item_relse(
+	struct xfs_buf_log_item	*bip)
+{
+	struct xfs_buf		*bp = bip->bli_buf;
+
+	trace_xfs_buf_item_relse(bp, _RET_IP_);
+
+	ASSERT(!test_bit(XFS_LI_IN_AIL, &bip->bli_item.li_flags));
+
+	if (atomic_read(&bip->bli_refcount))
+		return;
+
+	bp->b_log_item = NULL;
+	xfs_buf_rele(bp);
+	xfs_buf_item_free(bip);
+}
+
 /* Is this log iovec plausibly large enough to contain the buffer log format? */
 bool
 xfs_buf_log_check_iovec(
@@ -481,7 +538,7 @@ xfs_buf_item_unpin(
 			ASSERT(list_empty(&bp->b_li_list));
 		} else {
 			xfs_trans_ail_delete(lip, SHUTDOWN_LOG_IO_ERROR);
-			xfs_buf_item_relse(bp);
+			xfs_buf_item_relse(bip);
 			ASSERT(bp->b_log_item == NULL);
 		}
 		xfs_buf_relse(bp);
@@ -591,7 +648,7 @@ xfs_buf_item_put(
 	 */
 	if (aborted)
 		xfs_trans_ail_delete(lip, 0);
-	xfs_buf_item_relse(bip->bli_buf);
+	xfs_buf_item_relse(bip);
 	return true;
 }
 
@@ -711,33 +768,6 @@ static const struct xfs_item_ops xfs_buf_item_ops = {
 	.iop_push	= xfs_buf_item_push,
 };
 
-STATIC void
-xfs_buf_item_get_format(
-	struct xfs_buf_log_item	*bip,
-	int			count)
-{
-	ASSERT(bip->bli_formats == NULL);
-	bip->bli_format_count = count;
-
-	if (count == 1) {
-		bip->bli_formats = &bip->__bli_format;
-		return;
-	}
-
-	bip->bli_formats = kmem_zalloc(count * sizeof(struct xfs_buf_log_format),
-				0);
-}
-
-STATIC void
-xfs_buf_item_free_format(
-	struct xfs_buf_log_item	*bip)
-{
-	if (bip->bli_formats != &bip->__bli_format) {
-		kmem_free(bip->bli_formats);
-		bip->bli_formats = NULL;
-	}
-}
-
 /*
  * Allocate a new buf log item to go with the given buffer.
  * Set the buffer's b_log_item field to point to the new
@@ -959,34 +989,6 @@ xfs_buf_item_dirty_format(
 	return false;
 }
 
-STATIC void
-xfs_buf_item_free(
-	struct xfs_buf_log_item	*bip)
-{
-	xfs_buf_item_free_format(bip);
-	kmem_free(bip->bli_item.li_lv_shadow);
-	kmem_cache_free(xfs_buf_item_zone, bip);
-}
-
-/*
- * xfs_buf_item_relse() is called when the buf log item is no longer needed.
- */
-void
-xfs_buf_item_relse(
-	struct xfs_buf	*bp)
-{
-	struct xfs_buf_log_item	*bip = bp->b_log_item;
-
-	trace_xfs_buf_item_relse(bp, _RET_IP_);
-	ASSERT(!test_bit(XFS_LI_IN_AIL, &bip->bli_item.li_flags));
-
-	if (atomic_read(&bip->bli_refcount))
-		return;
-	bp->b_log_item = NULL;
-	xfs_buf_rele(bp);
-	xfs_buf_item_free(bip);
-}
-
 void
 xfs_buf_item_done(
 	struct xfs_buf		*bp)
@@ -1006,5 +1008,5 @@ xfs_buf_item_done(
 	xfs_trans_ail_delete(&bp->b_log_item->bli_item,
 			     (bp->b_flags & _XBF_LOGRECOVERY) ? 0 :
 			     SHUTDOWN_CORRUPT_INCORE);
-	xfs_buf_item_relse(bp);
+	xfs_buf_item_relse(bp->b_log_item);
 }
diff --git a/fs/xfs/xfs_buf_item.h b/fs/xfs/xfs_buf_item.h
index 50aa0f5ef959..e3ccbf3ca801 100644
--- a/fs/xfs/xfs_buf_item.h
+++ b/fs/xfs/xfs_buf_item.h
@@ -51,7 +51,6 @@ struct xfs_buf_log_item {
 
 int	xfs_buf_item_init(struct xfs_buf *, struct xfs_mount *);
 void	xfs_buf_item_done(struct xfs_buf *bp);
-void	xfs_buf_item_relse(struct xfs_buf *);
 bool	xfs_buf_item_put(struct xfs_buf_log_item *);
 void	xfs_buf_item_log(struct xfs_buf_log_item *, uint, uint);
 bool	xfs_buf_item_dirty_format(struct xfs_buf_log_item *);
-- 
2.53.0

