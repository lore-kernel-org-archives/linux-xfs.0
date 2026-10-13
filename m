Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B008456DE9;
	Tue, 13 Oct 2026 09:39:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791884375; cv=fail; b=TFzAbPjv9jKFkEGnLMHoidOWpikrneQ/ehpgN7hJZ9nG3RBTV64v08WuWtY5FwSQvlp/5cC7f4h4WLfleHNrH6PRIEzR+WYkebpfHb5+FqPehNksxBBiPHCO2BqAD6n782GTVgEOGRlp8O8alG1NRrYa5rWBOSR1WnkUhFK/yo0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791884375; c=relaxed/simple;
	bh=neV5s8/EEE57Zfh0A9h+HcClqKGAaL2RN8QL5HjC3Y0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=UV3ZUHQ6hGFMNl3SUw7RuI1lKdHD7sma7lKWJVspSE/MPum0v7dMsLoOVq+9tv+xc+f6vkQhp3Lv/NwPNAHGdMy9FLUAhlOXXzGoMOMYv1LdoyYDMT/GnGniPKA45nRH9X1EQS2NIGmK5xZjojtBfs48VWKQwqi4MWT7v1Qw3lw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Ty2Q/QuR; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=B1MOpxMd; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Ty2Q/QuR";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="B1MOpxMd"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69D2FX3J3439852;
	Tue, 13 Oct 2026 09:39:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=5k2K9VS7zuQ/UTlCAJld5uxak5XJgLgnhv4R/bikwio=; b=
	Ty2Q/QuRwLLxqPXpl36HijUxRcng8WhUw8uPFtb4SAYslDCSBfy6J4ox+VfNXX2/
	fVTT927q5HuT9e/Ly2716c97AbbwD0H68+NfnxD9N4j5o5uUM6w3EeaOuBaHF0o5
	UTAj2RJfp3rWKL92uJNlnNhRWg3YG/nypvPK38ZElbDXg4zCKd7i481Dp/1J4CFe
	roN8v+07sTcfhNIHufYsUPdLKK7td9UBnY/XLp9Iq0kQ1SGDwHUg3hl5G9D92W9f
	TQu84gknRwHuJsUhBSn67E0szGpI4JKwIlNOHplH8PenPzbdiXmcjkBkTg0v0tj4
	I1gwsSTKvomf6o5AADCdmQ==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4h7de1kp4v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 Oct 2026 09:39:29 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 69D9aiir018196;
	Tue, 13 Oct 2026 09:39:28 GMT
Received: from ph7pr06cu001.outbound.protection.outlook.com (mail-westus3azon11010059.outbound.protection.outlook.com [52.101.201.59])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4h7btp9u60-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 13 Oct 2026 09:39:27 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QceVUoXDB0QkRpdUKdGmYVWAm50mKnU3pJp0uYlikrmcdlQGu2wVHgYDLps9gmdLdewBrXCZLU2oFm0YlVisSB/vGypH6ak+oUU2jcQmui++7nQjEik53JhpZZphis5ZCb4+D0zHK2Ee2U3+j7D1O8rUQmgQdYOFgNM0REA48TavhY+CII/eWnT+tYxRlhv0BiT6NSDzFga3ablpknCmzoDkOlHUxUXVkxCa7SQ4ZTql4lK/U71hyGuo1EqLDrp0hEcHa8baO2a2nmjTZy3mBt9SepPn1DAF2Ka4EhDSVYDktyRuEGQFpxHa4vXQfhdm5yCg1KZakwyk6XkN+pVowg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5k2K9VS7zuQ/UTlCAJld5uxak5XJgLgnhv4R/bikwio=;
 b=pIdW/Xzzc6Xp20514+DbgRQV/ZOLduZOZHHQkCfTlZG8+dif6bG7fjDz/bBRjolXzXL56Jj0Y62n18c7eAAoNc8c+ie54s0ySeE/6mvnUHq334scRpenwrVmvf+sl8HWon0UlsGSdfh+tIJp3/r6hBxnCRIchIa6eeK0+XWlDm7/thl9qNlJXihZShY+P+P9daQHFxpjCQVcJjYQQx56dO/myTqikj4EnKd9PMB1MDvweqQfDDXwJ79YC431KtWTzvdTjcfeV2igR0tXW1hgCvpprJ+b8kHIo32hBIMO203YUeqA2mEbhpA7GGugNeCedTww3l5Km8xnTgVTSDOQKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5k2K9VS7zuQ/UTlCAJld5uxak5XJgLgnhv4R/bikwio=;
 b=B1MOpxMdYH2NX9ONGz7eUHWFR3iZTQVk/2GPuJkFLvhs42h7s2sOWchPjEMVqdibugC1hkzd99Pco7NsVPontfiPqV7VrvnnhciKtzmuRDugGt2g8A9BZfXp3qHkDaI7yjzY3vmkMMrz7yB3qGA9TVCAIbhgVNMhG366AR1vCOM=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oracle.com;
Received: from DM4PR10MB7505.namprd10.prod.outlook.com (2603:10b6:8:18a::7) by
 PH7PR10MB7802.namprd10.prod.outlook.com (2603:10b6:510:30c::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.522.12; Tue, 13 Oct 2026 09:39:23 +0000
Received: from DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::f14:5389:d117:967c]) by DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::f14:5389:d117:967c%4]) with mapi id 15.21.0522.011; Tue, 13 Oct 2026
 09:39:22 +0000
From: Siddh Raman Pant <siddh.raman.pant@oracle.com>
To: "Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org
Cc: Dave Chinner <dchinner@redhat.com>, linux-kernel@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>,
        Mark Tinguely <mark.tinguely@oracle.com>
Subject: [PATCH RESEND 5.15 v2 4/9] xfs: buffer pins need to hold a buffer reference
Date: Tue, 13 Oct 2026 15:08:55 +0530
Message-ID: <85a02418204d3bf4c5f3ed5c96abc8eda1f69d77.1791883296.git.siddh.raman.pant@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1791883295.git.siddh.raman.pant@oracle.com>
References: <cover.1791883295.git.siddh.raman.pant@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI1PR02CA0060.apcprd02.prod.outlook.com
 (2603:1096:4:1f5::17) To DM4PR10MB7505.namprd10.prod.outlook.com
 (2603:10b6:8:18a::7)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB7505:EE_|PH7PR10MB7802:EE_
X-MS-Office365-Filtering-Correlation-Id: a33d1765-e13d-4312-101e-08df290ddc8e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|10070799003|23010399003|6133799003|10067099003|18002099003|22082099003|261009223027099003|5023799004|56012099006;
X-Microsoft-Antispam-Message-Info:
	quyqZ1G7Cy1trlR+zPMmFuucfyLuINirSRnn50n/uI1m52ajyN/zr/l4yzgjHLeOCXWgqwfu43HWE1eq0jVDfItBRTHrGepKT94ZgOs7penqGdhG7bRkY0voFz9qq2lKR7v1cW4Fp8GHflR1DnBTB2Wsz0jza59wJRAgjnrHVJ44IsryX5BYqL1ixNItEsAzrnlEeGgHK5xxrmD6FXel4GrD2ynCUF1ONw6dkOdBrATYJyK0DWduE/WPL3Jvnu8UI6PuTqd+ca4o9HMkU8kGbc85muq3PvvimfXwej+fqSefpRYU15n6GTpaREe17DbuvOhUFRFMaKbH6q86ku3OD1AXipgic8d3R3IzpZtsGWGbmK9d2zgE88WGDODl+krxYSEfypOl+mGpGElToghu8ZGu2OLpcFvoU3X3w0SSRlVEFuq3EhwyG2Adp1rfzIjFusn0uMwbZeIjtiF9qCIZTBH37/euBVvCbP0r4bfAQe/N0M3gBQYh1+s8ijjFDiRkSMjH0eMvNJZoeCO9r8el49MaaVl1ihfQCNNx8DgEhE7axE3fANcZ5GHrQTeCfKKwY3e1dWiafDBDjzVsnPb8lEY4vpvneKkeCGEJMCIki9Nb/nWroJTzLh6cn0a7ubSyC4TGHIf1DwLaxh5i3m7Gjutf/+groOZW0cJMr2b426M=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB7505.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(10070799003)(23010399003)(6133799003)(10067099003)(18002099003)(22082099003)(261009223027099003)(5023799004)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?6nUukkt11pdwnlbzPBbniEQSUhuxIGiksTLcQOIGr68TVstqy0rIydIQIdMq?=
 =?us-ascii?Q?Wqnd7xtlYoDWcZRYlmTmecb/Y+lRa95p9ppFUt6KKXUq1F0sazLBXhjgUsn2?=
 =?us-ascii?Q?DvhP8jRHNk/i1gAOWADghwj5cPrAz4qEXWEsPFHLZ4/iC/IL22R2h0u7Q7Sj?=
 =?us-ascii?Q?DmxRjb5MwrNgFkvoR5HA0oiG7+7sFRdJlIPjaF3RFjBqnsTyrxUCSmfCBtKO?=
 =?us-ascii?Q?ZMQS6/dkt77hYiy3puX4LyiqibOyOdEhrWMFj7u8AqMXzrZSElV6gVv6pFIF?=
 =?us-ascii?Q?BfWRWevVoROBJJh7NWHzvQ2EQjmLQFOjK1jZshM/XuzlkbUwvrQmo40QcpmE?=
 =?us-ascii?Q?lKrnPR+ddBGps9zvoL7NHjcGejeiH268YppYsVF9M2f47TGsSm7YnCex62t2?=
 =?us-ascii?Q?fXkm4JqUVcXxFtRPVW1QYD2Sv9JrRTTqxNJsIceaz4WM1MiNa3wNssZMlRdI?=
 =?us-ascii?Q?JwWI6xuiwuP+Mb1HeGtY1+Xfd+RDO6AoovUgQlaFqcw04bAQEpW0+5OmZS6f?=
 =?us-ascii?Q?rWKcAkWccRFyfoY0x8KnQLj0xJznLvomuFQBbO2g9ExFAc62LfHLQ0KYNa+P?=
 =?us-ascii?Q?fWgIEp1HbZPaPe+quLTbvfU6k2m40bjrrp1t31sXl76rvQzrqmcjuakzWpll?=
 =?us-ascii?Q?ZctqGMCe1aPgzMarlFUN5v/5RdkUHuYdpvfoZr5740SkSw45OtH+WMva4rAm?=
 =?us-ascii?Q?tjnI6Zpvik6JmZQCU0FMGX6yhybuyTPYENt4H/zkWcm1pNy4w9uVkVvZhJMV?=
 =?us-ascii?Q?tBQqHw2F15Pc+v8ZGmLO++Eoovk9imZk+2I2cikvnJSjGNJfDD0/gRn11TYk?=
 =?us-ascii?Q?991kI4hijO4yyeqQIuJj76tvbZkey5dHnIrDllCM2Glv4l46uyqanTPjsqh9?=
 =?us-ascii?Q?UltpBUpDvw+sz2nxtatjl2DRkHV2/2jtD0vtBFtigKqGXxwXu2huNeJfbUkL?=
 =?us-ascii?Q?qfbjATyXQqEKi8MXQuYMKULHtaP/3El4UpAqu1FJ+SeUPUjMLZ1oXTRcU6E1?=
 =?us-ascii?Q?44eOUbn2q/cedirIJtCeo0/+27CibFYqEuz0WYDsWVD6O1XY9AM9UrPo/F5Y?=
 =?us-ascii?Q?sSbMWNjQ+iMNW3G8o3ib4MZYU0Jxh1SGncbx3UgoQ9S98IPnkC1fctJNI1ci?=
 =?us-ascii?Q?bFowe7NU2hjMYod8VwGGt/uaE/6qF6+g6B2egNamHp/TZE/xFkZAvJtRFoRV?=
 =?us-ascii?Q?wupyKp3Z3oLRWmxaK+S55+BVwke/42Ds9Rf7hjw7BdCVEFyZcNruI+Bncx26?=
 =?us-ascii?Q?XfAbyacJGrWtrQkgvgFdoLR6EAXpDV/X3GLvJbxTFmDlpd6DLdXcQD4ApR00?=
 =?us-ascii?Q?SZBtoIKUJDbR6M6XMNtbQUmH/d0oLErgF5Jq9+4OCYHiX+5yXuHgD/Y8LYtp?=
 =?us-ascii?Q?BrR/n+4IwC1KvCKsUR7g+Kh5EJdMk6cWliCZDgCPOaLJo4P42uorcRFpo0V+?=
 =?us-ascii?Q?9ltz7OoY3BaqKkEne/AZD+niNm/Ru3IreDSeOptHlXxjfrHTUSJcLRNByKYi?=
 =?us-ascii?Q?7AdhYhoCLZ8ubL2N/690wqZX2pAZlQcFgcgvQ7goLk123OcjBCFkf/PgqdHv?=
 =?us-ascii?Q?B937G8gc5bHZIUR/n56mtSrOT7Lx96EXaqiCjHLHQVdFC+NLBLDmlm4lrRT7?=
 =?us-ascii?Q?wyswOREHkAtqSBS+LqW9jKGjK2zY2UXlcP/gSm+qeynJGKemafyIidv+PQQi?=
 =?us-ascii?Q?qJrhsN5KEAg5B7r9lPwuHug/DbQiqhXq9mHO1WDPXOVpDXFinByGOLo+NCP2?=
 =?us-ascii?Q?4Hg0Z2fxnTE/VHCWAhuV4YXwzwJ2m5JQxmKIFPjLHGJ5HdBp22vVh/UlWdW6?=
X-MS-Exchange-AntiSpam-MessageData-1: b1FGwJagROJHaWQbIR9gXa1D1BTeiU7ldYk=
X-Exchange-RoutingPolicyChecked:
	hNAS2BVLLW5uXMvRkiDDVKpViY0QQrP/iliiQsO7uvuj6WtjUeVW71QLKVmlEkGliX6ykA5OE+GmhVuFPrTN62VGS5vxHEsxDiGMDHdEDbfQKD8sZSlMitnQgcbZr0HFXValzpECLJ3qRvjvrbX+ps9DgazqRlwj0mreaGZs4diMjploiDvkd/4KmdJpH2xDeuy+TQtCPlTU8H9MnwUbeaLQ1zV/JlgsDRXAsdISkSSKEOFq1jdnUEqPgAFai3HqcT1GYfsNGkucTV+/6G+JvoW4kknDvMY3oaHrI8aTNx4jHxASyFGFNz1n6nJW9CZAbkFSZMOr6JoBMf5XVUrDUQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	oyE09LCs8RPeWBgqH/BqsoReW/ffUxQMH03jQEQBwTU4jeJxfIhZksLTL2dE3lZkTsLIi/TtRncgDbFopLQvmWP9n4USbvXAXTvM8yXftGinirLIMIJt1wKeZ95d9BxXMJUsczyk9AsN5ib9vhVlG+/e4v3E6OIOrAhHG2igJOI/p9vr2UYAMdhjmExrEpAumF4coKkmR/SWzrchEvLd05/TO28z3UUQfmqls9Ujj9Z9KfODp8HnaBfzON6ba07hlW9oBvaKkVLcO0xnc4AwCd54Pc1UevaOfz+R8uXVcCb0wsxXdXtEsNgLfqDnaucBl2fe09AYcC4iS8cPDN2v7FFETaldmBGZ8GPXyWFV/ydlMdr4WFzI1iuxyZGCtt9GMFkviXvesZfvyatWAO5ht8M6dhh+iD203X0yyGH/jMbe+vRRRb3ZAuDubAIfT3Qm8sb8CU4TkfvPUVmSz3UoDS+vOgsxocBSQj1sl+QMEWpxE7Pa9TSQZpgXBl6HeN/7LD+0AO159RDDcwBeRb5AWIic/7mUJYN1B3Ccq+Ink5jI4ZF4jI4L+5KFfacvA7P/vI5ynb430QA1iZPDoAkSNfblm+FF4DMHrL4eM6TaoM8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a33d1765-e13d-4312-101e-08df290ddc8e
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB7505.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2026 09:39:22.4316
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KngLU002M/ZVfuketdbSh8XMoehbo4uzAGtgBa3sidYjXJ3GSFxrEIlZsgupRUVNON5LIFENjSoMbU9a/32XvHsIcps0LkWhFqSAdimhdVk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB7802
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-13_01,2026-10-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
 spamscore=0 adultscore=0 bulkscore=0 malwarescore=0 mlxscore=0
 lowpriorityscore=0 suspectscore=0 mlxlogscore=999 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2610020000 definitions=main-2610130038
X-Authority-Analysis: v=2.4 cv=O9SsLx9W c=1 sm=1 tr=0 ts=6acdfc51 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=660iZSQnnn4A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=EIcjfB9IiI4px24ztqRk:22 a=20KFwNOVAAAA:8 a=i0EeH86SAAAA:8 a=VwQbUJbxAAAA:8
 a=7-415B0cAAAA:8 a=pGLkceISAAAA:8 a=ag1SF4gXAAAA:8 a=yPCof4ZbAAAA:8
 a=t0Y7tUnTQisWX057riYA:9 a=biEYGPWJfzWAr4FL6Ov7:22 a=Yupwre4RP9_Eg_Bd0iYG:22
 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:12107
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDEzMDAzOCBTYWx0ZWRfXyv9EPeWEMThs
 oEG8jRxwcwAMTymG1A8SpgamtmGMaNF96Vm5g+f35ETkiUSAQb2YNQyvntAyZp18FO408Cl2T7u
 N5kErXy3CJfSTlTMwPvHz/40Ja8hxcNLyJtW9JmDlRevIHiqXjlf
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDEzMDAzOCBTYWx0ZWRfX5YokovZihij0
 /5AEtnGWWIMbMbD4bJBR8ojnAI8xJTePH/adHwEq+8uvBC0sGrqmgTLP8qO/GebNW8JZbfz3RRq
 3sn3HKefZjofV0yf7HD//M33KE1A3ZZOkzEuLqzD3EmdgKLC/592dp3I93oamCMfvgeYf7jM8ur
 lEoB8RzpMS4nmosqblIksitgNG1opJ3KlFQXPL8R2GGymmU/5PduQEwLBUEXCXqu/Wk+5EL8gVr
 p3yx1i85C5qsPHl4uZjtuI9ZtHzEOGlSOGxORC3vhXdrBMxigOo/+Lrj/E7YC66KuZLAkfGkj+f
 9zxqwEeJpksgono1h5uokaUour3gDe/dwGO4k+cAHrhu+MxlXipsWEi+mCwa8pC18Fm4LwTVCwa
 1DwA63IG1hQ2Gr/RaJ/CEXlidDPXRPwF49rDmI3j5KbCS77WyO3izzb4RV6ssPfWA/Jl4cbpHgV
 nJemYizul0wKB3kV2UJ2Sh7PNijsL/oNtHTiqago=
X-Proofpoint-GUID: hsa_zQQbszZ29Mfl4ktgT9NupGnrZwCo
X-Proofpoint-ORIG-GUID: hsa_zQQbszZ29Mfl4ktgT9NupGnrZwCo

From: Dave Chinner <dchinner@redhat.com>

[ Upstream commit 89a4bf0dc3857569a77061d3d5ea2ac85f7e13c6 ]

When a buffer is unpinned by xfs_buf_item_unpin(), we need to access
the buffer after we've dropped the buffer log item reference count.
This opens a window where we can have two racing unpins for the
buffer item (e.g. shutdown checkpoint context callback processing
racing with journal IO iclog completion processing) and both attempt
to access the buffer after dropping the BLI reference count.  If we
are unlucky, the "BLI freed" context wins the race and frees the
buffer before the "BLI still active" case checks the buffer pin
count.

This results in a use after free that can only be triggered
in active filesystem shutdown situations.

To fix this, we need to ensure that buffer existence extends beyond
the BLI reference count checks and until the unpin processing is
complete. This implies that a buffer pin operation must also take a
buffer reference to ensure that the buffer cannot be freed until the
buffer unpin processing is complete.

Reported-by: yangerkun <yangerkun@huawei.com>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
(cherry picked from commit 81274891036602355e72eabbb5184490f354b506)
Stable-dep-of: 816c330b605c ("xfs: factor out stale buffer item completion")
Signed-off-by: Siddh Raman Pant <siddh.raman.pant@oracle.com>
---
 fs/xfs/xfs_buf_item.c | 88 ++++++++++++++++++++++++++++++++-----------
 1 file changed, 65 insertions(+), 23 deletions(-)

diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index 065bbf03c7b0..e0c75aa3cca8 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -452,10 +452,18 @@ xfs_buf_item_format(
  * This is called to pin the buffer associated with the buf log item in memory
  * so it cannot be written out.
  *
- * We also always take a reference to the buffer log item here so that the bli
- * is held while the item is pinned in memory. This means that we can
- * unconditionally drop the reference count a transaction holds when the
- * transaction is completed.
+ * We take a reference to the buffer log item here so that the BLI life cycle
+ * extends at least until the buffer is unpinned via xfs_buf_item_unpin() and
+ * inserted into the AIL.
+ *
+ * We also need to take a reference to the buffer itself as the BLI unpin
+ * processing requires accessing the buffer after the BLI has dropped the final
+ * BLI reference. See xfs_buf_item_unpin() for an explanation.
+ * If unpins race to drop the final BLI reference and only the
+ * BLI owns a reference to the buffer, then the loser of the race can have the
+ * buffer fgreed from under it (e.g. on shutdown). Taking a buffer reference per
+ * pin count ensures the life cycle of the buffer extends for as
+ * long as we hold the buffer pin reference in xfs_buf_item_unpin().
  */
 STATIC void
 xfs_buf_item_pin(
@@ -470,13 +478,30 @@ xfs_buf_item_pin(
 
 	trace_xfs_buf_item_pin(bip);
 
+	xfs_buf_hold(bip->bli_buf);
 	atomic_inc(&bip->bli_refcount);
 	atomic_inc(&bip->bli_buf->b_pin_count);
 }
 
 /*
- * This is called to unpin the buffer associated with the buf log item which
- * was previously pinned with a call to xfs_buf_item_pin().
+ * This is called to unpin the buffer associated with the buf log item which was
+ * previously pinned with a call to xfs_buf_item_pin().  We enter this function
+ * with a buffer pin count, a buffer reference and a BLI reference.
+ *
+ * We must drop the BLI reference before we unpin the buffer because the AIL
+ * doesn't acquire a BLI reference whenever it accesses it. Therefore if the
+ * refcount drops to zero, the bli could still be AIL resident and the buffer
+ * submitted for I/O at any point before we return. This can result in IO
+ * completion freeing the buffer while we are still trying to access it here.
+ * This race condition can also occur in shutdown situations where we abort and
+ * unpin buffers from contexts other that journal IO completion.
+ *
+ * Hence we have to hold a buffer reference per pin count to ensure that the
+ * buffer cannot be freed until we have finished processing the unpin operation.
+ * The reference is taken in xfs_buf_item_pin(), and we must hold it until we
+ * are done processing the buffer state. In the case of an abort (remove =
+ * true) then we re-use the current pin reference as the IO reference we hand
+ * off to IO failure handling.
  */
 STATIC void
 xfs_buf_item_unpin(
@@ -493,24 +518,18 @@ xfs_buf_item_unpin(
 
 	trace_xfs_buf_item_unpin(bip);
 
-	/*
-	 * Drop the bli ref associated with the pin and grab the hold required
-	 * for the I/O simulation failure in the abort case. We have to do this
-	 * before the pin count drops because the AIL doesn't acquire a bli
-	 * reference. Therefore if the refcount drops to zero, the bli could
-	 * still be AIL resident and the buffer submitted for I/O (and freed on
-	 * completion) at any point before we return. This can be removed once
-	 * the AIL properly holds a reference on the bli.
-	 */
 	freed = atomic_dec_and_test(&bip->bli_refcount);
-	if (freed && !stale && remove)
-		xfs_buf_hold(bp);
 	if (atomic_dec_and_test(&bp->b_pin_count))
 		wake_up_all(&bp->b_waiters);
 
-	 /* nothing to do but drop the pin count if the bli is active */
-	if (!freed)
+	/*
+	 * Nothing to do but drop the buffer pin reference if the BLI is
+	 * still active.
+	 */
+	if (!freed) {
+		xfs_buf_rele(bp);
 		return;
+	}
 
 	if (stale) {
 		ASSERT(bip->bli_flags & XFS_BLI_STALE);
@@ -522,6 +541,15 @@ xfs_buf_item_unpin(
 
 		trace_xfs_buf_item_unpin_stale(bip);
 
+		/*
+		 * The buffer has been locked and referenced since it was marked
+		 * stale so we own both lock and reference exclusively here. We
+		 * do not need the pin reference any more, so drop it now so
+		 * that we only have one reference to drop once item completion
+		 * processing is complete.
+		 */
+		xfs_buf_rele(bp);
+
 		/*
 		 * If we get called here because of an IO error, we may or may
 		 * not have the item on the AIL. xfs_trans_ail_delete() will
@@ -538,16 +566,30 @@ xfs_buf_item_unpin(
 			ASSERT(bp->b_log_item == NULL);
 		}
 		xfs_buf_relse(bp);
-	} else if (remove) {
+		return;
+	}
+
+	if (remove) {
 		/*
-		 * The buffer must be locked and held by the caller to simulate
-		 * an async I/O failure. We acquired the hold for this case
-		 * before the buffer was unpinned.
+		 * We need to simulate an async IO failures here to ensure that
+		 * the correct error completion is run on this buffer. This
+		 * requires a reference to the buffer and for the buffer to be
+		 * locked. We can safely pass ownership of the pin reference to
+		 * the IO to ensure that nothing can free the buffer while we
+		 * wait for the lock and then run the IO failure completion.
 		 */
 		xfs_buf_lock(bp);
 		bp->b_flags |= XBF_ASYNC;
 		xfs_buf_ioend_fail(bp);
+		return;
 	}
+
+	/*
+	 * BLI has no more active references - it will be moved to the AIL to
+	 * manage the remaining BLI/buffer life cycle. There is nothing left for
+	 * us to do here so drop the pin reference to the buffer.
+	 */
+	xfs_buf_rele(bp);
 }
 
 STATIC uint
-- 
2.53.0

