Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78E28409102;
	Tue, 13 Oct 2026 08:15:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791879319; cv=fail; b=QFEBLHwaI3gMGapQ2/p/1itX0JFeSCRqkSO2bjLCiFFBoM7eCI1qWlA838RgLKfz0WNYI//TvlC002dUxbXNYEiSZSjrxDG21VOj/TKsU67X7iz60WUPfZk3EOiAxbeCI4UJNSVMGbwWEOjaiLVgwKcrFhIZDo3zyzw1HtLCNPo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791879319; c=relaxed/simple;
	bh=HgsTudX65gsjehdyfMpPtyLnVAS1FPqxubYZ80AqjoQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=tOHSj4JSUag/9tMHALd4Aat5Mnw1UoWUi1it+UODszu0rQuamJDM/lq9QEyT5Zt8kQlaoWTPbRU4OOe7Go3rlomU2KEFGKYsZGYYqPpX3s+Uc3tBCiznTCmNENFkXkxVXwT7NTDqJ91lRygcVTkxUhRxEa/lvO2lM+TC0ydAix0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=FsuUDoEy; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=WmbaeFzy; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="FsuUDoEy";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="WmbaeFzy"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69D373Bi3288508;
	Tue, 13 Oct 2026 08:15:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=kpsrONGlD+pVtWEvFHnn6M9sh1ZuLVMm0g/GEsjqelg=; b=
	FsuUDoEyaWJoexmmjH/QGD2bkQAbffR9qquJWG2kzVNj5EJesfHBGzbtC3BHS5/v
	n8DodvgoYp5Mqqcb0dHvDr2ub+mdzskFi7y/eUt4gR3VnzDGmb2dhV87vngZBotX
	sS/V2+pr8wSfgga49jxkDXGHWUU2VbQlKv2Yh9proftHLrljhjXnFCNNwO9b96kH
	e86aDfGBCci2z40V/lyHb2gvKrgzynQJGqqa1PMKWEbJQMT94C/4ihASP8BY0s96
	0m+FqEIPHBGjCqkrJXJyoMtR/MwNfYAzUo+q/qvlhGRNoYK/jqYu+2sHi1euEbuU
	ALVB6t0poJlsl0yPFfj0pQ==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4h7dcsbkwn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 Oct 2026 08:15:12 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 69D86hxr020816;
	Tue, 13 Oct 2026 08:15:11 GMT
Received: from ph8pr06cu001.outbound.protection.outlook.com (mail-westus3azon11012039.outbound.protection.outlook.com [40.107.209.39])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4h7btjsg15-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 13 Oct 2026 08:15:11 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=N2z5j+F4lM/+mlCYWdpkBEA0k+1ZF8YFWwTbj+3Z2i9MYtnByJdMgeKSNdj9GaICfBAso5vbt4uMPdGSKeeF6U7dcBI/tDIWyQsKfyNVjR/xOfJaDzs1otpdmezgk+/Q09IbeA6azBrDopQ97nXfVNYhBCyZIx1VI2aKZueLn2a/Wo/DAikR2C37M+zIgIkPA/jDrOhA8y84LT155JbWx6y56XNC4RoNY5g/jrTqea/wYq/5QjhyXzdb9j8ghybDUEquSvRP9t2yRm7Xl4fBJYQcPxWVDcalSADDr63AQfRL+zGAHrUTAsvQtOIs8ndtI0dFUNkCtPWe2E06mPL+zQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kpsrONGlD+pVtWEvFHnn6M9sh1ZuLVMm0g/GEsjqelg=;
 b=qP8x+5CVUBD4JNAFijVck2Hut9xe9cATdYb/Kw/jfyGjWqkVwS3PkeHOEqzJxQjlEM8tGGT3iktZ5PkKBUgZPkQv6kN8twjFE/SLK8+72FEShUqu7ow7kj7Nv4HgSLP0Nhe6KC65ZERheZzJ89SJ3w6oYAGXEE4w3Ss49YNHSYIJtnB9bCb8OyJa9HzA3bFhhmmkdrg7xWiAmOrLZkL10hbu9IB9DhK9Zqr9c+xMU0cDny/zpLF+xCh6KL675YN5CBdYNMNTrGKzLK4R5jFT8PPTJUCGeTfSL4M4TfbB2rYruXNhKqVvv1It4xBRPSJdVAryasPoQaogeHz0JJVqhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kpsrONGlD+pVtWEvFHnn6M9sh1ZuLVMm0g/GEsjqelg=;
 b=WmbaeFzywWFpHMelqqElXdvEtpotR5IO2Qlz0nkZHntfZaX6rO7lV8icnR8f9x7ZR3t7o8XJgXdy078Dn6bQ4sFiyPJW+GrfBswzYwISehuby7ZHiK6mK4iIZFAvH9m9Pj7Lme6Kqc4L3jTVphwJ9qyEBZKiqIcItg317RNd778=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oracle.com;
Received: from DM4PR10MB7505.namprd10.prod.outlook.com (2603:10b6:8:18a::7) by
 LV8PR10MB7992.namprd10.prod.outlook.com (2603:10b6:408:1fd::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.7; Tue, 13 Oct
 2026 08:15:07 +0000
Received: from DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::f14:5389:d117:967c]) by DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::f14:5389:d117:967c%4]) with mapi id 15.21.0522.011; Tue, 13 Oct 2026
 08:15:07 +0000
From: Siddh Raman Pant <siddh.raman.pant@oracle.com>
To: "Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org
Cc: Dave Chinner <dchinner@redhat.com>, linux-kernel@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 v2 00/19] Backport of XFS umount hang fixes
Date: Tue, 13 Oct 2026 13:44:44 +0530
Message-ID: <cover.1791877866.git.siddh.raman.pant@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <2026-10-01-1-daily-reply-0012-re-xfs-umount-hang-backports@kernel.org>
References: <2026-10-01-1-daily-reply-0012-re-xfs-umount-hang-backports@kernel.org>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2P153CA0033.APCP153.PROD.OUTLOOK.COM (2603:1096:4:c7::20)
 To DM4PR10MB7505.namprd10.prod.outlook.com (2603:10b6:8:18a::7)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB7505:EE_|LV8PR10MB7992:EE_
X-MS-Office365-Filtering-Correlation-Id: fb93e97f-2d4e-4f93-f97b-08df290217df
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|10070799003|366016|376014|56012099006|261009223027099003|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	UWQ9DAWVs0czvPTsaYjGpyoXxOPUM7C1vmdgEjB7BsmoyL9g4qv/40ZeKfddNEdrBBoEMC9R8ZHXGvyqmTg+yRy8BkqJ+KkCSxZVpDiVeHkj7PCDHiYjnKrK5jHc9vHcNXh6KZvebj/VVAB2FDqiXsdkAwouRSTDkXeatlrkKlGkvjFREcA7zSblFY1I2z/OhGHaE21Y5y+nYPMq/UGCxDYKecLbiNpS5ox1nWdhK6FhafLKmF3d78NJKqvVF9QlsVkOmbtMytFL2e7omounKfD1fCFSGi+ojiQkw6Uu2TOi2zbIpQPQZco2WPiJyoMfthhd5bVTA0Vhp52L7+yuzECi7xFbcUcDyV69VPwHqpRHNi17LcZkQSahWtlRp0rd7whmZsN2uW8+IhBtSNqCaA4OUCG7G2QQ5jV6InuxWTdTHp7mO9f8JMWHoDicE6FZToHlCsBnuYxQ2FGU5RYcPD4XPqj+jCdmHDvCOjVINtYZatl3f4X/BeTCUYi4rbLJNf6dBqm41tv2Vr3Xpp3oqeVs2VrV/IDEJskmk/4rC7LM9VnazI3cswtUHrYzXQhgNqxHU5Rdq2S05l33Z++i0JqkVFM0Sn8uZ0OKc46tPdzgjicX+hwV3k4Jt0jQZtJ+jwoLMQPuj8fWnpxNi6FTd+sZ0PENCuTOcHsdeRyhoY0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB7505.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(10070799003)(366016)(376014)(56012099006)(261009223027099003)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?6w6b96jSkUbS8NDL7O9JtQm2THHPr8CQUaQfSJw2AllKR+XgL3gAhu3K2n3u?=
 =?us-ascii?Q?cwDb354H6Aw8LlCpvvh9rl9ENCxWAh4RpBn8UNnBqcVQN3JjE2o+vkzJ2DQs?=
 =?us-ascii?Q?r50RTMNLxCYpI6lVtOtlxSo3OBuT/ruU9heHkvIUXBZuIQszkS1tRT/AjG8C?=
 =?us-ascii?Q?ogSLL0mqgMQDNqLJs5Wea40MUHxyl3dKo9cxc8sACQJoP/6GRESE0AJX42rz?=
 =?us-ascii?Q?fXDlidfPXq9FRckKgGsFhcUiE0WA9toYpgLy4pVAfaVqGhqCRYF/uhrWtrY1?=
 =?us-ascii?Q?D5al+qKTJVFn6NtcqTbxs14tD7pCDqBsHjVlSJp47lEzZydWqmch3Unb8ARt?=
 =?us-ascii?Q?kihgDmk8GTeY5ZYQsNBY+UqJ3DLTn0GHOob/zwO/z5g5Xs/EpN8E/ZXIhNNJ?=
 =?us-ascii?Q?+NLpXs+Ee28NDx21SFzop6njbTDsyvkcvaOoC2OFhpyfAQmiiCatT7vSCdDK?=
 =?us-ascii?Q?RuU2i32QQHsVq+nCIJyJ+AjOuAx0f9mDOuVvNgme0l+Hcg4fY40veWus2lBy?=
 =?us-ascii?Q?PZVyvR2dbqhAI02+AbT3W2mJXcWuAh6IFb6BUfi1AKHf7vqB4WQN5rDzqHv6?=
 =?us-ascii?Q?RQQ05Gm9fCboHcvB1tdcU8ct0DFY/i19jYY4i7+CuxbLNQZR4ikG6Bkhn6md?=
 =?us-ascii?Q?f9oOUvGl+je3+n9Lf67Pus4DBOTngSHV14vYQyItLIYk+1w6b90xXP9K0uKc?=
 =?us-ascii?Q?na2dkoe8TzDdGMjjBZghdVAFwhCeYtj/WED7s6hTIKls/jrpzYU888Xiz/Uq?=
 =?us-ascii?Q?eHcGCEYS2KZEl7pDYJ9BAbfShNgN407xcch7D9wnhRFyWVuz4LYi275peQnp?=
 =?us-ascii?Q?x9HKwab8pC7wF+fAnYZLER19CgpbtodIMzW6YJqtIXgMpal188o+BTNM7RYM?=
 =?us-ascii?Q?3Ez8ZatgwfcUg6nooSIEK+cHxCca7eY8DXwW5s8P7qmypUaSJqqtwscGrK2q?=
 =?us-ascii?Q?8TnF8hhTDuaZvdeN0KN6ZQ4TdFnItFnXBBPdJJuN90Qr0U48CISVEZ9VGGnD?=
 =?us-ascii?Q?n07SLWQdUtVnaUxR5rOPb8E1Tw5uU0/1OHLejH2uvVQYBwxSQYsNt2AGnIZp?=
 =?us-ascii?Q?ta0BfC4mTMYZGoC3G2GrB5UNlO4HSCVA2manwLWgT3+XeP8DYNT8/OJpZ+uh?=
 =?us-ascii?Q?3hdeqLn5PM+o4TkLZjz5gs25DaHBOBfI/QEhKdE2+zKfiSIoJ2aOyiw1xyLk?=
 =?us-ascii?Q?ZlBPgpuLK2qJqrjRmAmKqbNl7lgPtEyMBBx6EHUQicwLoZ7Cq51yyBH5HZE4?=
 =?us-ascii?Q?JhhX31thuL/CJuPRu06JsWvc9I2T2RfbV9dZk6mdjo21XIxTMgDlaKlr4z0P?=
 =?us-ascii?Q?SQNpUSK1iz0STlpGNn4P+Nv977DrkGu3JVIPqOAcDI8LXxXpP+4Syb0y9pps?=
 =?us-ascii?Q?ZJAL7OXaBI1Ic2Aogf/XEKoH+2kQT3x4tb2cim2oTLeHuGp+xXR4OvKZ6pOB?=
 =?us-ascii?Q?zG0NXZXjjKuv6oih74aeR4etJe3th1UBRwATAAPuO5VHWnuDOScXZI6KGRnB?=
 =?us-ascii?Q?fw+eU4yAaGeM7issOWKZ+dnyxWkG2Y6NqYfbNG61LvWm3g+0XG8LWhOPexJ+?=
 =?us-ascii?Q?XLgT9ABz8cmnquFSKY+qgGscd5J7/KoaPpZ78HYCtLQ29ZHtiV7d044GZZal?=
 =?us-ascii?Q?Cq6XET8VzO39Nj7wq/sL3oVpQ4JnRStG1AjEJqtQWRZrSpDcKPg6uWZrDXEd?=
 =?us-ascii?Q?Bh/KxnNAjvYYWg1EMEtLkXnEJ27RdolkSuc2Mj/UYLlv+x67a4K8SY4S0+Zc?=
 =?us-ascii?Q?mLUS0NXiyGzGNjuBZjjOI/EHgK08m7gVWzZ0N7UNnqcXxh3qwAhnw0oQFQfV?=
X-MS-Exchange-AntiSpam-MessageData-1: +Z9lzebGS6sK89OIZqoZ7a1MexDWjgD1kC8=
X-Exchange-RoutingPolicyChecked:
	uC68wQ+XUpZaTcNcn/9zHK1uwFnC9NW0IszIHnihBsgMw4WapVkfosV6UM3u3nMStISg0N5blCK7bMaHIvOcswKu+N80zUZ7uMKYYJNv9Zjrpoeo3VOmCL0poqP97x6P9FhPve6izFGhXr6iPpPxx+IMg7GMF9DuiAgK9CfJVWALAdS647jFq/6Wc65d/rXVZqbzcFYvHyaiIEve5aqdO6J2DdVARaonydDLAmBrRrw61PhZk5YZUPXVK98n9S/perb6kF9VhvGlG989FzWhiQth5bT0new8dGqgvqGursodVayoWM1Jr5RDn3lFCVJ+pVn4eoooSPmay9BfHiiVng==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	eszok60Nqiq98AQCRIF+qVQiJpMTgG5bLgS0jc0683nBwIyjAf2i78zPTu0t0BlxOdUVE8CdL2B8gXF+9c+QMzsg5pxyA7L9iydLf5KggK1Ycws2ZeEfSIDipYTs51AqT/FLPUmAyjMBRc4tZxGF1+6JCbHViP5wmHE3Exb2qWD1U6wSWn0wTdfMeh/EUEg7bP1QbBpmPH9pcGGro8aAnstO0+0lxgfcUpSJoiaPhKTT7uNxh84e6AbPstd7AL1/6ibK22k7wENgyFbkSQ65/Acns+oarIgC1jCd61pZrUmxoPZLNYS6VnkqV6ROV6zRtoNT3267Al3kezmtiuFMLzzgRqV+LEy2WzwKv6VVAbK7f+lHQWg2Rpwj9INVIj62OEW9bZcx6o1J+Om/icx1hZG5of2J2WmVuHri9khc0KgJRwOHl3+iD7SFDoJd2OmBZRl5InoflS+N1Y+hwSQguzya6pImTxi7axUtMyq1BALUrmMr5/t2SNVLrcgYlZ32P7a/y7QGCXW9kEHnu1pCFAXNwHGJQ4H8VUVhxwfiePDrCHdHI0MKYjN1ExukHMKsZUNgmk7e04KSjgBLLhqz5JpWhVsecVBhodCQXs8XYLc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fb93e97f-2d4e-4f93-f97b-08df290217df
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB7505.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2026 08:15:07.8852
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 85W+ayDa9gYkXMIlCeIA26o9yMCNa94m0DHOcg7GNt2h57KaFOKeNNFKcU49ocv/dAgaJGLmAVEpmuSVu6s5QFse53Q84a1Knl7nathS5nY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR10MB7992
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-13_01,2026-10-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
 adultscore=0 mlxscore=0 mlxlogscore=999 bulkscore=0 lowpriorityscore=0
 spamscore=0 suspectscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2610020000 definitions=main-2610130032
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDEzMDAzMiBTYWx0ZWRfX/pQtOJfqS9Q0
 DTxXN1mvRJUWQ7CGkxP9fU1CXLGUV479sm3e3lgB0btevok1VQaStaZzRY3SWCn/+TAOjDCUslt
 X60lCrt9s9puVD488chDYqA7m6P2UDuHP2TDfbT1L/PF5VF1bS1Y
X-Proofpoint-GUID: uEoIx2gBfuxMOFzzIOLSecdboywoFtMV
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDEzMDAzMiBTYWx0ZWRfXyn1XBJ5j8UUQ
 7TtEhoJi6JkCXDe8R/cMexcYCNwErM6bApHpbFDoP6T7n9Onhw2JdKWhlXm+o9wRhGYacg8dqpG
 VKMiSiDNXx4LGURQIICE0o8JOXepKfF4aetmz5t+GklwoxMoPPkxR+ixihlKVX7KLp53E/TQt3b
 2q1SDWoTDcHPCu0xuG2rHBb2yrO3jc0Q8flwaU1NsNLZRujyj7gIgdoxP4h4Pks8G54WcEOrtgm
 f3u5lyMwMR+M298UY2vT3X6cKWcdfC1coC+9KHZ3pY9Q/zKBswbvtXF9IoDF+Y0h4uK3premt7G
 Sk/YQIGta3GbyuxySBIr9LVE2cK+hegve6x97m8GJHaz51rfhd3e2lIeNYV8Ba0dXWmYdVwZQQe
 CznmFYhEKWaZ4EWRVuLrehr4BXwZaHe6gfGjNZliaLXaWnMt01zBStGz1zPNSQkBgXe4qDxDp2v
 KiTUm7Htmi46HQFQYqrQOWTruoAuRrpkJAz7sP1U=
X-Proofpoint-ORIG-GUID: uEoIx2gBfuxMOFzzIOLSecdboywoFtMV
X-Authority-Analysis: v=2.4 cv=EdZd0/mC c=1 sm=1 tr=0 ts=6acde890 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=660iZSQnnn4A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=o5oIOnhZENCTenyL_yNV:22 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
 a=ONJcZ18tqKTzyd6mlaMA:9 a=biEYGPWJfzWAr4FL6Ov7:22 a=5yU3S35YU4bGjq-dph-N:22
 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:12108
Message-ID: <20261013081444.Eydga2f1WYOxgNbb8hg9py_tgZ_tthJdzJ4mda-SLSE@z>

Backport of this series:
https://lore.kernel.org/all/20250625224957.1436116-1-david@fromorbit.com/

I have added information in commit message upon conflict resolutions.

v2: Address Sasha's comments to v1 in the below mail:
https://lore.kernel.org/stable/2026-10-01-1-daily-reply-0012-re-xfs-umount-hang-backports@kernel.org/

Thanks,
Siddh

Darrick J. Wong (7):
  xfs: hoist recovered bmap intent checks out of xfs_bui_item_recover
  xfs: improve the code that checks recovered bmap intent items
  xfs: hoist recovered rmap intent checks out of xfs_rui_item_recover
  xfs: improve the code that checks recovered rmap intent items
  xfs: hoist recovered refcount intent checks out of
    xfs_cui_item_recover
  xfs: improve the code that checks recovered refcount intent items
  xfs: fix intermittent hang during quotacheck

Dave Chinner (11):
  xfs: don't nest icloglock inside ic_callback_lock
  xfs: convert XLOG_FORCED_SHUTDOWN() to xlog_is_shutdown()
  xfs: log items should have a xlog pointer, not a mount
  xfs: aborting inodes on shutdown may need buffer lock
  xfs: remove xfs_buf_t typedef
  xfs: buffer pins need to hold a buffer reference
  xfs: xfs_ifree_cluster vs xfs_iflush_shutdown_abort deadlock
  xfs: catch stale AGF/AGF metadata
  xfs: rearrange code in xfs_buf_item.c
  xfs: factor out stale buffer item completion
  xfs: fix unmount hang with unflushable inodes stuck in the AIL

Guo Xuenan (1):
  xfs: fix super block buf log item UAF during force shutdown

 fs/xfs/libxfs/xfs_alloc.c    |  61 ++++--
 fs/xfs/libxfs/xfs_bmap.c     |   6 +-
 fs/xfs/libxfs/xfs_btree.c    |  10 +-
 fs/xfs/libxfs/xfs_ialloc.c   |  38 +++-
 fs/xfs/libxfs/xfs_rtbitmap.c |  22 +-
 fs/xfs/xfs_bmap_item.c       |  76 ++++---
 fs/xfs/xfs_buf.c             |  24 +--
 fs/xfs/xfs_buf.h             |  14 +-
 fs/xfs/xfs_buf_item.c        | 384 ++++++++++++++++++++++-------------
 fs/xfs/xfs_buf_item.h        |   3 +-
 fs/xfs/xfs_dquot_item.c      |   5 +-
 fs/xfs/xfs_extfree_item.c    |   2 +-
 fs/xfs/xfs_fsops.c           |   2 +-
 fs/xfs/xfs_icache.c          |  10 +-
 fs/xfs/xfs_inode.c           |   9 +-
 fs/xfs/xfs_inode_item.c      | 164 ++++++++++++---
 fs/xfs/xfs_inode_item.h      |   1 +
 fs/xfs/xfs_log.c             |  50 ++---
 fs/xfs/xfs_log_cil.c         |  12 +-
 fs/xfs/xfs_log_priv.h        |   7 +-
 fs/xfs/xfs_log_recover.c     |  17 +-
 fs/xfs/xfs_qm.c              |   7 +
 fs/xfs/xfs_refcount_item.c   |  60 ++++--
 fs/xfs/xfs_rmap_item.c       |  75 ++++---
 fs/xfs/xfs_rtalloc.c         |  20 +-
 fs/xfs/xfs_rtalloc.h         |   4 +-
 fs/xfs/xfs_symlink.c         |   4 +-
 fs/xfs/xfs_trace.h           |   4 +-
 fs/xfs/xfs_trans.c           |   6 +-
 fs/xfs/xfs_trans.h           |   3 +-
 fs/xfs/xfs_trans_buf.c       |  16 +-
 31 files changed, 723 insertions(+), 393 deletions(-)

-- 
2.53.0

