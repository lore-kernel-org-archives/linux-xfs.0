Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9694113B58C;
	Tue, 13 Oct 2026 08:13:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791879204; cv=fail; b=iNH1uhG+7M9ECWTPrJXdqhjDfvozialJ3Fj+6v5T23B17ElipVKOJ2dDZFG18PxU3pBzrEFShJUX0BLKn0Embc3dVyulUQ29QppmFKyk0W4shzpx6sqr4pQLoFM86g43UWQ9D5ABA2sJGK9CNz3HaKBjGAjwMbPor0QDHUEYGoI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791879204; c=relaxed/simple;
	bh=N4sFKjJTzF/ujxtaq5jV7HhgtObxGRY+UETOir7W8gc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=MOmEWZIW8XRLZrmTxmgdVxFD+BN6XuIdT2SaU3HlnIkOn4BCB9LpdlYdKLGUiFOSx1RV0+KEPEq0GzKYWucmc+VkHbJ/L+dF+AeXpNGBMosR80qfIC8dcWa+I1d+K/mgZA/CddwYVVEooKgXP7iUhceYsE9QqcFlkMfya9YQHV4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ALD/c+/h; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=F/BIewiI; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ALD/c+/h";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="F/BIewiI"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69D2CXoc3434603;
	Tue, 13 Oct 2026 08:13:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=i66nFE/3stomT3hiXygtbbWR/swB2TUQrDP+noR5ZhI=; b=
	ALD/c+/h9wdgPKi5JwrFjPBKnldhTOxncEMGgyJI87OLx02nSVZtGomeNfA6jo2L
	PMfPtwb67e7bSjlHWBwtZ/Nc2ztYePFivahh6fgmPySSLThCR3VzPbphm9i8TmYQ
	Q7AHsPmy+3D1Gvkiv17mSZaZsR2/WL7ssX1ypu4ywVTwEYyXFUyOv1PQusAAelbg
	cMKRtOgtLYBVkARy3/Wy2RlMnD8p8pBiHJhJ/KKGMSh1j337FOLvQ+Ct2325L++j
	2hJiOVVrsYIsV0imTO/wOU7C4Xt+QhOGuVPuWR7OdPyvytwthkQGwToFGLY4azwH
	YDbsm2XBe++5eyl0IoIzFg==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4h7de1kjgp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 Oct 2026 08:13:19 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 69D86iS0020852;
	Tue, 13 Oct 2026 08:13:18 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11010012.outbound.protection.outlook.com [52.101.56.12])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4h7btjsekx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 13 Oct 2026 08:13:18 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vVdC6w7txvpcf9Ronf5tLA/BLdlvSisYEArCZTQvadA4XCQ62xpfn99f4M926C+2T0Q+Iw3lE2quX1XlI8vIPM+8H/kaB2uzoAqertJ+GHwUQBOJtzemKtAH3qkoPb9mDWvWhanrNN6KWIkvhNVrfRgJUXT1nIcNk37XEdN0jAPM9vtbURPbhWRgw8CPUT4l+6VdQ5geUUg36SXiwnsKQG/TWOIB661LP0ydRO7FTMRFnAzSJqunWK1NpgZOWvDI2vLTCGqg3+gFZgiOx/kl4UfF/IrT0aGUMTudaaFt2UPNMU5hJgOkitteiTuSBrAMq0OoBBtmbo6IgqN+MMIB+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i66nFE/3stomT3hiXygtbbWR/swB2TUQrDP+noR5ZhI=;
 b=neYIUmPS/EXTfH/NPOCcLCEc39/MGh/Tgy/Hkf18kbapl8wEEmVE4vVpzn3xuY1dAvLcw95smUDWLu0mqqTMfAzRqtfkP1UfftzmpJdDmdNRPCAhodpQTRvI51YuJdHhOcSu/SJnXNa3jmi4V5+qAoNSbD36fBQMzWoxXf0yFNmIMDqOhYsQNt/a+qI2JImRIEsUN5Ar2/t3HmKWQWdevpBq6LE5PPavuNhVWi6DNL466ZqSsb9bUhEG5zgh1+PWA8crzny8jl72mgQ0g6mCcYLivHu+68t1SJ1aLDL79n7fqjnAmonZ+QGT9/Wu2YQkEZXRhNuguMt2lUJKjfSuRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i66nFE/3stomT3hiXygtbbWR/swB2TUQrDP+noR5ZhI=;
 b=F/BIewiIFkum8QCQf0MuCR6VuGircvqWNCkvC+O855BMsQ+qzmdAokKGQbqFlQolDpxRTbRLvyY2kAxtvbaZ0tK5LC4lYqOJ2wK3a+MlixNa5pxwkxPZU7eUyu/RJSKQ6b9IeAM7TbGZzYyc5BYwnwvJl/MTAsKUVzkftcrbfO8=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oracle.com;
Received: from DM4PR10MB7505.namprd10.prod.outlook.com (2603:10b6:8:18a::7) by
 PH7PR10MB7851.namprd10.prod.outlook.com (2603:10b6:510:30d::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.12; Tue, 13 Oct
 2026 08:13:16 +0000
Received: from DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::f14:5389:d117:967c]) by DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::f14:5389:d117:967c%4]) with mapi id 15.21.0522.011; Tue, 13 Oct 2026
 08:13:15 +0000
From: Siddh Raman Pant <siddh.raman.pant@oracle.com>
To: "Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org
Cc: Dave Chinner <dchinner@redhat.com>, linux-kernel@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 v2 5/6] xfs: factor out stale buffer item completion
Date: Tue, 13 Oct 2026 13:42:45 +0530
Message-ID: <6e5d8c0bb75cfa49044d7d5c5535c40e27cf7da2.1791877865.git.siddh.raman.pant@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1791877865.git.siddh.raman.pant@oracle.com>
References: <2026-10-01-1-daily-reply-0012-re-xfs-umount-hang-backports@kernel.org> <cover.1791877865.git.siddh.raman.pant@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR04CA0211.apcprd04.prod.outlook.com
 (2603:1096:4:187::19) To DM4PR10MB7505.namprd10.prod.outlook.com
 (2603:10b6:8:18a::7)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB7505:EE_|PH7PR10MB7851:EE_
X-MS-Office365-Filtering-Correlation-Id: 60a4963c-2089-4051-a307-08df2901d4a6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|23010399003|376014|10070799003|56012099006|4143699003|261009223027099003|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	vb3S55tDqgk2Fa9nTba6zISJWWY5/ahyUIX3beZTR499QyurHWiUD1u6ZkW+u04L0LNO1rIePAesRPaVJLr2dSfPf5um5JDEI9aN5T90BLWrD9gEV4Rj1Dc62BGk/le2RNA9bdGr3A1kGwo3cj6ipurTm6jX9Ijf9VhCnW93r7TRUD1Uneficlzan0t6YrAUVjQOdGYzjtdl6xdRoq3IV+iN504OZ81f50mX1DNebReP+2gPkHR1/IVjrnumwBNmeywM3OVZxnYX+Z6BYBFMYdOa8kMpSv97wkR0E9GoSwHbsYoTyKo+qkLb2HqsEYxUOOxOrtzzKtQJp7o+HetRp8D+7wgqzpj9l98KpTaLrlLHXxJUpyiCCqciEn5vCJqYEXnaOyHaxmt/MCIO53WRFQ4PtgRaG4AsN+ICQCtSJNpT93+9dVvuM9BDMjJl4mkHgkx87vOBBVSTCX3AEDT1BkkaVz7ojEHs0pA8Jwld/mM9W54Hxis9c5NngWkBMCrGv0alXGJgdYu3W6AgAoQTknbhxBSYtlEWDu0SBse1J0dMvz0Rq42NN+qWTNUfCssRjrIC+y6EPYam4uIw2hirtmnimlrbHh3KZd0GEBDV2XleljckFKAtM68zihjEzzJlA2DARXweYhwTkJ6626D3R5uB55uANqa5AQ9KpELCP90=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB7505.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(376014)(10070799003)(56012099006)(4143699003)(261009223027099003)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?xIRVpcUypvva0WfqaeWTGOqtngSFKpqo0qcqC17qeAuuuOB+I013VK5o5XzP?=
 =?us-ascii?Q?BiX5Kv+WXNsEP0HaDsVD+3rqHjza98NtG4i1H33M8uXO3gcLLYdjVIv6O2Hi?=
 =?us-ascii?Q?ICrD/6JYU6J6vB1HfK3/gTpUh23IL0zITxQfQBfir0jkCW8aW8inBv4DXg/d?=
 =?us-ascii?Q?ySAms9zTcI/LgnL3F89Rr6SoG6t4fbTFuVrTKE05ij3tImddWgTydkC6S8BV?=
 =?us-ascii?Q?TvnaH6zQgYxmJ8qIzkqoqb9+baOQpFuUc3EVEqa0RmyTM8PuAoeDojV/PyQ2?=
 =?us-ascii?Q?ZqPlyegg1UlWX9ymLdH9NuYhFwSniA7haZkHpdOhh3fG8mp4qLGJRQE7F/xv?=
 =?us-ascii?Q?zL08wJit7kTcC3MFC/Kc4dciyVayXuhuqtCMrsZn2Ss7SkzlbYAcTkK6kbwg?=
 =?us-ascii?Q?PTaa8P0DitVaucTylw2rbij98n61TQ6SSwcB2fa9sG+BGTqUGm+kZ5XTt39E?=
 =?us-ascii?Q?VsBCQw09Z5Bl4iY1Fw8I4REUxErwk7gn4KyNEb7opd1xLWwlNN8bo45/CQpg?=
 =?us-ascii?Q?a1OvP7/1Ko7IIcy1QFuEn1ftHpYd1KudYz9Tnx4lDPWXMO4DJv3K+pqXEeOW?=
 =?us-ascii?Q?MJYJRrGE4JCyE2bSkEONVxbkb6rUTGTcGGJ8l9aQOkYEMf3ytQ3Y7eGzh8fe?=
 =?us-ascii?Q?hzQH7x+4lK9sqqNlNHhTbb2ur15usOvPz/YntBMmo1FMmRmT6yox6F556dOe?=
 =?us-ascii?Q?L4UzwvgTxdnjYzeJmdVF6tzijodO0ehDSLkk9OwFRcBaaAvNzmumafKmp3O2?=
 =?us-ascii?Q?rDU6ZFIX4YvDDwRh1liqa1Fkz7uQn9nsAFl2DsJigXdmR5hRf/PS5Qa5ReGj?=
 =?us-ascii?Q?8JybkjtEX2sYWOsHL0V2BHvHjOd0j8ZK3YJ6xsnXrhZp5vwnGtWMc9ohrQfn?=
 =?us-ascii?Q?yCqMxr954EiZxqgVdLF/nkS8TX/Z9NvVNBGIkJP8GEdaI4VWTiPnhinRa9LR?=
 =?us-ascii?Q?Y+GTyuJEUg9BF50qJMqzwnHGTWOKqdI3Rsb0tYWtEUCjiqW4i7+9YlVb4PS+?=
 =?us-ascii?Q?Mfq8dwjRcSL89lltakLhNL8nZd4WFG4XIDQDu6L4/0fEQh8uI6NPKtE6L4L0?=
 =?us-ascii?Q?6W6hoA09QFRTrxZmBpMMRdROG5v8gS4Xo0GlNtTk4vh+34/nZX9P1BDvgCXx?=
 =?us-ascii?Q?h9R7aLeI6gw20meqsRHM6efNKDnmfIioLyOXe67A7djZaCvm2bXDtgEsn48J?=
 =?us-ascii?Q?wl4nPD5D3Uvpq3KWUkbzw5WiggJL73tupO/rtIZdg/7phDPoQq1J4+M0zS2U?=
 =?us-ascii?Q?JiyCyZqGlzY7rJtKmn52l/TxLAzZgjuVAktOfa0GZyog5Dqj/hAUbohUMgcK?=
 =?us-ascii?Q?zb+lVvIrieoyeafTcPtaj4Nj3pD7Wzk1wpDAz+CbIwlajhkSZBA+1joyYsEA?=
 =?us-ascii?Q?eKtgS7PWBsNcdXTWkYBlTiu+i5kCacCL3a/vHXNr9mltKhJziWOBMlRZfMQj?=
 =?us-ascii?Q?GlmkHe0JPQT2fl/m22zpCljHSxjZnNAMkiefENFw1LXwwAB7S00rI+9hjlcK?=
 =?us-ascii?Q?JiNWn4nPkWR+G9vmSmgvixOamAbLgYwsCmilvQLr431r2d/3R8+jTI7f39d6?=
 =?us-ascii?Q?adNKDBg5pRY8h+ormDOyjHIcYqfIaGsiWhfR+ioOnr1OIu6ntx0pUXsWNKM4?=
 =?us-ascii?Q?MpegApB88j9o0wj8TRNotoocbzdTwWAGoDS8nDBqxTbIV7jAZJSw/zD7r4kR?=
 =?us-ascii?Q?vH+KAkeQdWPykATfF7RTAW++mLwJx7OZS20Ty3bduO0NqTFuEJsWOcBrGCvp?=
 =?us-ascii?Q?fcKdmdFZidOZKwBwtctjzTt8XpfAtTi2EeJB9rOmBzVHy4HX3nfibdPOhXst?=
X-MS-Exchange-AntiSpam-MessageData-1: kGv9bwTa5uEDVdVrCYGZ2rdeY813ALh9jus=
X-Exchange-RoutingPolicyChecked:
	QUzQgg61kbKPu3j1CE4dP974RvnHLoOy1Nj4oUjxuFO3CwCTm97GKv5SDfmNcnQhEQM47QOyXymugvQEdVzUD8OdiCqkuBVeXim0AFsJQIIViThOuuUjwFwf9sD5BULNwv078euoeVWLNq8ypBGlR0C0UROYc7wQq4l5HrVF1hI/IlKlrgx8YCV41KMtTmF6cExoCbPO48eRfhATpwWr8+Xd4auEvnCvUfTewikhNYK95zsUDiZITHwGrt8wtz16mbuGV8hdlCTb7dTlm68cKU20V2TmqixcfRmqva3KfOzsS/VaLGN6kFJs8bjYyD0/LRF/z1yTO61w6sfeuN4HUg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	eg5TzbNw+WrYOGy0KWnpzYwiYDAGbu2Qio58cjkpJvvBe/tGEMqpgbkPoj4B1BwatpIGkkrsp35ZgakVhr7izOTL16tm5egUi25Qeb05QzB4HdMPs3rt21CHpXgIOQI2+fy67esQ67b8GPV5EGQ0XZLSJWS82wWtMQpldSGK+er+0HcYx/x4AcRGg2Biuoczo23LmYoX3naTQiDz/aTf4PTSEH/Vmq1OmrvbiZN0yBgIkJbeLZcJdXJkGAQiOuM2kSTI1LGPp8Dg4H4m696WM1vCRoJoAo46QxJkdxom8mzDiEWadgU6Pdx9CbQHV+HVShQuxD7y/NJVcWCQn36vJziBT5/wqCJRqbZ7hw9KdrtxaIHrUB9LL1jAEN/1QkPUFCM2fnzVvwwB9ZB/0PXRi6Pr28zXYGfRoMlRvWbvD/HVH1lkfIixYZWUZjC0gPmuCZMUy4COCjqXORO+hQI/W2KBsn34/Md/9XWdjFJV8yk8MoYN3ZYuqz9LYwHv+mVlbVlXMPOm6+kh3eKwsz9JWHj2JA1QpiZFp3OuEzbAGNB97BZKeBLgb3q9QRN2o+ww+8A4pHkkERXOY3OXrMos1eeBylxa+RDCfHgVrp4Elds=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 60a4963c-2089-4051-a307-08df2901d4a6
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB7505.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2026 08:13:15.2552
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4e8kI1/rLtQymWAx44fNQ1tAEu05kerFwxUj2/WjFrtfS7u71grGmm0u4zUdZSAExjQVD93Xln0cmTsezGvKqlKnaPULZCT53gFZSJ7CJww=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB7851
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-13_01,2026-10-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
 adultscore=0 mlxscore=0 mlxlogscore=999 bulkscore=0 lowpriorityscore=0
 spamscore=0 suspectscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2610020000 definitions=main-2610130032
X-Authority-Analysis: v=2.4 cv=O9SsLx9W c=1 sm=1 tr=0 ts=6acde81f b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=660iZSQnnn4A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=EIcjfB9IiI4px24ztqRk:22 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
 a=HRhzHcoIBzGTXiVGymcA:9 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22
 cc=ntf awl=host:12108
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDEzMDAzMiBTYWx0ZWRfX6IHVErnW660r
 X5AmGATZ9Zx1bxtgbO2+a0BO5n/tSSGdtEdwz3e7WRxiGY6bZAqTz0OVf6skpryAMJcZBpE1l8M
 V4RSCWXBHAkBG2OBY5loBTkf1/Lc174GjMs3i/UkuZAtMW1U1Qlf
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDEzMDAzMiBTYWx0ZWRfX3S2rA7WV06dR
 uuo1CiWFieJ5cqySrRX/uXoRPKCEMfRE8SNqrRXj5044UZC2vvfi/ho0iPKbww8IytcuH8/DdKW
 6G+zv+tBpUYJqX/QnMLoj6SCm+TFF0vQhY/+UJ6u1tn3paMy/j6RaIwRqzLw8GDSTmk7F2W1j04
 7+pfGi64wkoQcF2zkZPpAkREb44IxG5wTglrQ24E6aOtYmMHwKIXewIRoaS82gFJfRLucvKon4e
 mlsCRjBvv+QvUka3Zoac30Qa7Nb8NJwEa5ffh7ZXzTm9LTmllHv7VI5oadigBeu9/gSA27/6uaj
 hCO+wW928D8KtXjlxluDqF+NdesaQZgek9OThq9E8lE/ML04HSB4Wxija8FrU0z0Cc42f813x0J
 bhkOgx3wWE8gwNAnMwkoju63wq3QO+bBn2c6DcjUBArS8ZyKhgEk8Ii1tabRCX7t7Av5bnFkT/P
 1D9k/iWyZnwFM31vA9D8lKRb74g7ffa/nOrvkRCQ=
X-Proofpoint-GUID: hegCm6whUkzxSoKWvdca_au_m4x9MYoC
X-Proofpoint-ORIG-GUID: hegCm6whUkzxSoKWvdca_au_m4x9MYoC

From: Dave Chinner <dchinner@redhat.com>

The stale buffer item completion handling is currently only done
from BLI unpinning. We need to perform this function from where-ever
the last reference to the BLI is dropped, so first we need to
factor this code out into a helper.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
(cherry picked from commit 816c330b605c3f4813c0dc0ab5af5cce17ff06b3)
Signed-off-by: Siddh Raman Pant <siddh.raman.pant@oracle.com>
---
 fs/xfs/xfs_buf_item.c | 60 ++++++++++++++++++++++++++-----------------
 1 file changed, 37 insertions(+), 23 deletions(-)

diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index 042282a08216..9e6a68367ca9 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -539,6 +539,42 @@ xfs_buf_item_pin(
 	atomic_inc(&bip->bli_buf->b_pin_count);
 }
 
+/*
+ * For a stale BLI, process all the necessary completions that must be
+ * performed when the final BLI reference goes away. The buffer will be
+ * referenced and locked here - we return to the caller with the buffer still
+ * referenced and locked for them to finalise processing of the buffer.
+ */
+static void
+xfs_buf_item_finish_stale(
+	struct xfs_buf_log_item	*bip)
+{
+	struct xfs_buf		*bp = bip->bli_buf;
+	struct xfs_log_item	*lip = &bip->bli_item;
+
+	ASSERT(bip->bli_flags & XFS_BLI_STALE);
+	ASSERT(xfs_buf_islocked(bp));
+	ASSERT(bp->b_flags & XBF_STALE);
+	ASSERT(bip->__bli_format.blf_flags & XFS_BLF_CANCEL);
+	ASSERT(list_empty(&lip->li_trans));
+	ASSERT(!bp->b_transp);
+
+	if (bip->bli_flags & XFS_BLI_STALE_INODE) {
+		xfs_buf_item_done(bp);
+		xfs_buf_inode_iodone(bp);
+		ASSERT(list_empty(&bp->b_li_list));
+		return;
+	}
+
+	/*
+	 * We may or may not be on the AIL here, xfs_trans_ail_delete() will do
+	 * the right thing regardless of the situation in which we are called.
+	 */
+	xfs_trans_ail_delete(lip, SHUTDOWN_LOG_IO_ERROR);
+	xfs_buf_item_relse(bip);
+	ASSERT(bp->b_log_item == NULL);
+}
+
 /*
  * This is called to unpin the buffer associated with the buf log item which was
  * previously pinned with a call to xfs_buf_item_pin().  We enter this function
@@ -588,13 +624,6 @@ xfs_buf_item_unpin(
 	}
 
 	if (stale) {
-		ASSERT(bip->bli_flags & XFS_BLI_STALE);
-		ASSERT(xfs_buf_islocked(bp));
-		ASSERT(bp->b_flags & XBF_STALE);
-		ASSERT(bip->__bli_format.blf_flags & XFS_BLF_CANCEL);
-		ASSERT(list_empty(&lip->li_trans));
-		ASSERT(!bp->b_transp);
-
 		trace_xfs_buf_item_unpin_stale(bip);
 
 		/*
@@ -605,22 +634,7 @@ xfs_buf_item_unpin(
 		 * processing is complete.
 		 */
 		xfs_buf_rele(bp);
-
-		/*
-		 * If we get called here because of an IO error, we may or may
-		 * not have the item on the AIL. xfs_trans_ail_delete() will
-		 * take care of that situation. xfs_trans_ail_delete() drops
-		 * the AIL lock.
-		 */
-		if (bip->bli_flags & XFS_BLI_STALE_INODE) {
-			xfs_buf_item_done(bp);
-			xfs_buf_inode_iodone(bp);
-			ASSERT(list_empty(&bp->b_li_list));
-		} else {
-			xfs_trans_ail_delete(lip, SHUTDOWN_LOG_IO_ERROR);
-			xfs_buf_item_relse(bip);
-			ASSERT(bp->b_log_item == NULL);
-		}
+		xfs_buf_item_finish_stale(bip);
 		xfs_buf_relse(bp);
 		return;
 	}
-- 
2.53.0

