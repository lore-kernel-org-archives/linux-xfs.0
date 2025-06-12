Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AFB3433AD;
	Thu, 12 Jun 2025 01:57:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749693443; cv=fail; b=GobA0/Ic+KGthw4zdy2TKeQex4ZuQreaym5vxY83ksOzmt7pd3EQUAMPZfIkbTXPgsOAaOxt4Y9u1nVT/+oKrYlIJ8AhroxfdT2nx9RFytxnjttLsmY2hV+RzZIk3bEStZExizQhb93zTaiWl6VMYRF2CAOsE9xLm1A/YyDG/2U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749693443; c=relaxed/simple;
	bh=ZorfE4S3qUUYMuEFTgCWruVb+4pN0uHcFXxGmCBoQPA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=js0Qu3qxI2voDpc1+EYiduwqkQWWyThu+0nFS8Jr62MG4O43Rq/AzjES93h+k8kR1cpDpcb4EKoN6XtZBJCGEOS0gftsxeAtVoCSNYI/HD3V44By9cK4TTjA6BGkcPN30Sc/vJK07Q1HlGU4WrigwJfhXM870E4neiNyk//I1Qk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=GRqkUdAh; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=YSr7QZxh; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="GRqkUdAh";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="YSr7QZxh"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55BMPUc7007502;
	Thu, 12 Jun 2025 01:57:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=iPR0F2OSIuKJNWJiiigvmrQSt+5Q17Sw0rKIPDvrY9c=; b=
	GRqkUdAhfIJxBBqaFKd3DdT625CbuSUA74pfYzmeKuQ6QemxFBzzPVVcIzCHbqJp
	gRs4PC1kpEup1S9c5zyCglpn70WRD8JrFm0EBZVjJBsPPPS+ii0t2c1TQ0Is8+EQ
	jp+SkhumQIMrdVXiM/gzN8o0Pi9PLjo7sKxaetQexzGZFDyZS5gPTWo4h7zLYS3i
	+eLQOgss1hV4LhzofyOlrUFUjx4M/3b6pwgZAs7FoIbVA/F9o592L0NmF6UhQDt1
	KJIZo8R+ihC+2NBK20nj0XCQaLpWPIEph7H/zy/wiUlj+0naT04w3iYbOqoiSbGr
	amHkx52ptTv8SmKnAcUZTg==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 474buf8qx6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 12 Jun 2025 01:57:15 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 55C12po3003202;
	Thu, 12 Jun 2025 01:57:15 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam02on2043.outbound.protection.outlook.com [40.107.212.43])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 474bvaywnh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 12 Jun 2025 01:57:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qitQiuD235SqbjE4LQgC/HvtPtUWigGvojudVhA0lsDK4NMGiCALQrb7yf1bZYprHsVZUIk3riuRNOyE2yaIdFFTYY6x65DuDE73SLnV/RqszQoOrCc6rDFT98kliBkA9Qrn92EaQ6YZqJxPdjxjy6jhWeZYyZxfYACgyskpmlLurMgKYfryh5TmaDLtJWfjN/3yFpHIuYTfqUSZYrVCn0wNHtijvuxIdRi3Eufs62WtdKwsF/sDKDnMp9wXZ23eVZHU+UXbAp2Pm9Fhme1UfabMukVI7iy+obCnJz3qqgxTMKiO+fpLBFsiX9dYiCjjfafSSaz1P6toTRYjFAz/Mw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iPR0F2OSIuKJNWJiiigvmrQSt+5Q17Sw0rKIPDvrY9c=;
 b=EmU6gRI/ui7CaW/OljPdY0GAZOkwCMov3SgYE6ilHfzxiMGb1Dew43aMdWDjCHo6jAjU44WUgtgaWQiWyqxNsg9xKn8IWMPWsbMigGhBlvT2wY855309cMxWj2d0PnZuAPIOQPTHIW99OLvlybHuZDQr31IZYRSKPy+vp64dAzfayIa1pFy1+KEpH3siNOTc0j0/AH1hcA2+ooIjXuVgB/5SBP1BupEPtwiu4GG6GJz9eVNPNulbauz+9oq6sqqbZ0UVLBreLEpMUpoNecdrAlQLYvm+S2+9PcxZcaZ4Hh5RsanmpXKUlhCPyDf/ap5+y347B1WG9VYWRK7TJxkerg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iPR0F2OSIuKJNWJiiigvmrQSt+5Q17Sw0rKIPDvrY9c=;
 b=YSr7QZxhLk4gcJsg6LAIu1aXORjhd0BnZ4h9z5Y5ZXCH4KQ/oK8JtpPpUDLgnqWAGIc1jEPZ3v+HFenZ+XWxJh/XidtY1apfg9O++sRVbqmkUEaLaYVVWZWFuSyAy7ieeG6aNGCgmZr7mjBFFBSmp85a7QH19CAVttADx34HK/c=
Received: from DS7PR10MB5327.namprd10.prod.outlook.com (2603:10b6:5:3b1::15)
 by PH7PR10MB7839.namprd10.prod.outlook.com (2603:10b6:510:2ff::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8813.25; Thu, 12 Jun
 2025 01:57:11 +0000
Received: from DS7PR10MB5327.namprd10.prod.outlook.com
 ([fe80::43e7:5b82:9069:b402]) by DS7PR10MB5327.namprd10.prod.outlook.com
 ([fe80::43e7:5b82:9069:b402%6]) with mapi id 15.20.8813.024; Thu, 12 Jun 2025
 01:57:11 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Cc: djwong@kernel.org, john.g.garry@oracle.com, ritesh.list@gmail.com,
        ojaswin@linux.ibm.com
Subject: [PATCH v4 1/3] common/atomicwrites: add helper for multi block atomic writes
Date: Wed, 11 Jun 2025 18:57:06 -0700
Message-Id: <20250612015708.84255-2-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20250612015708.84255-1-catherine.hoang@oracle.com>
References: <20250612015708.84255-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR03CA0020.namprd03.prod.outlook.com
 (2603:10b6:a03:39a::25) To DS7PR10MB5327.namprd10.prod.outlook.com
 (2603:10b6:5:3b1::15)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR10MB5327:EE_|PH7PR10MB7839:EE_
X-MS-Office365-Filtering-Correlation-Id: 7f2f7904-8cfe-4ece-24dc-08dda954721c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|10070799003|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Hp8Fpbz8sW956dB3Wp3HArEUF1gkhiDs6GjGINvn33SghbalvjiTIrfgLgkT?=
 =?us-ascii?Q?jCUkgSN/jUeGwTDjN/WPplAqaytSy1foOfOxuPxTgFSsfy4t8vZ2JNZz6BL2?=
 =?us-ascii?Q?WFgRXwqGgPMXiRzpF48ecPjhQms04mmJFkiGgrQqi9j0+3Gi/atOlxLqycdP?=
 =?us-ascii?Q?0jGj0dF1ti1lKox3SjoP+5GxFEkdlXsur+5hj7CF6yNOMrLZuAdy2Uh3yunn?=
 =?us-ascii?Q?0p67r5W6plgnx6OUOmi/pSMWjyNWtWEcLsDWZMKGeKOQCXo+u6Ijl9u+k2Jj?=
 =?us-ascii?Q?8HqJxP6ghVm8hSTobOtTd7K/eR0ZHaSyqE5WNM2169ABWkH6JuRfNce1KESu?=
 =?us-ascii?Q?HiQ/W4NIwU8mhW+7fDv374TD0g8Agn8TDYDGSJnvyDGvSkwXKVLZA5EvH6ce?=
 =?us-ascii?Q?BbsB1mefOPmxRLolylmRNiHkuKFfWeY0pBLx7OAU+nXTG0B4Kof8AkuBoXwU?=
 =?us-ascii?Q?/MhTeUXm5W+sVfT7B4yxcUJj45mhzY6BsM55PGQdavWkWXb9GROzsE7liFnx?=
 =?us-ascii?Q?j3Aervio5FyE9fIRDl+JcaK0dMyEUFMBMgIoCoVAsROM8pHJQtA3Cevrfgom?=
 =?us-ascii?Q?bhEF/R3YAk+6G93Rkdrz0kmp5hddWvQ2wktqaQv016Hsl+JequSLWe8ZZ4Z3?=
 =?us-ascii?Q?SWXAU3ysU5Qgi8GfU7znVfShdz+T078yu2p/GJQaCwuWGMzI0CAgQITBdVUF?=
 =?us-ascii?Q?g0lqpkNb5BYcHABRXNtMjQIbPzdV7p3Oj6mkiSfXD5rq+xcxWE8rp0f931c5?=
 =?us-ascii?Q?sCuAfBA6nMPPimJfxnYe+Tq14oCNqYA5I7EXxBgJoN+X6BiyPozuHkGkOWtZ?=
 =?us-ascii?Q?u9hC82TtiRGDepyx8x3/iK7xD1irDFn7nsO/JRATZmVmOkf+nCkw9ttB6DAt?=
 =?us-ascii?Q?/wyn30jVFsYgFZqWAbV63eYSdTm0Z0yixIsPfgVt6iLPHF/vqaiRDWgzz7t6?=
 =?us-ascii?Q?0XgePwfuv3qr1M+YT34S6tH5SMmbxvws9lH0wu39E2xLGmrzOPGB54ln0aee?=
 =?us-ascii?Q?Ipe4f0CY4AKuMCXid2Bn9ACvOa3kUX8UFmwupMhEMZFbdEC4PKVndknuaPvE?=
 =?us-ascii?Q?e6zXWz8HSEXj+xwL8caUQdsGuhNVTKQK1hRFqfqz7IiobRjGuSJUebPDCDjp?=
 =?us-ascii?Q?NhyMV24XB6AgVLBGUf1B9t9Y0j5aSPvNkbG3CksG3l8EJze4wF1awsB1cdrj?=
 =?us-ascii?Q?HcwtftwzbNT2h2vkSgTumvoERzAjq6xQ+IuwpHnoDu4gJNbHtT6MIHpyjaso?=
 =?us-ascii?Q?sKcWZYmBmvZ3u0vsYONFoQrI9S03HzmP9/+5IjmlKavJ7zRiZ9cupdpO89fP?=
 =?us-ascii?Q?V87aPTLLnNNiiKgQ62qIL5gbt0cNZJStxtBWG3PYe6+r8EvulJwFM8wQfu6R?=
 =?us-ascii?Q?flhjnIe02nP5XPyTANXKcpFg/TUUlSbbgUZa+k6VeNkAiUNFMtdBDwTXLLCo?=
 =?us-ascii?Q?tUOoHGLtXCk=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR10MB5327.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(10070799003)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?QU5AbhKq7xFSGhvnnWr5mFJ9c7fF6pUsmuiOs+Dy6HKvn5a8O4wIXrppWu65?=
 =?us-ascii?Q?9DimMxSolMruqUFBFjwsFdh81co1ySNWyvblMkfxwdiIBfe4OxrTYM0W52sx?=
 =?us-ascii?Q?rXUfauR5lJY1K8fcK8znH++H8rOT2UKqvnqev1BXkXyK9peoqmoHIs7igpog?=
 =?us-ascii?Q?9cBOsdInGc5bzsjASPEQud9geFoZLY86qe2xU029M4Z0GRN3IOrmPQwcFLjD?=
 =?us-ascii?Q?ZzMPzsg1W1/ogpw03W3LFOICbhr1kDxSHLsOQg9BqUZQdp1/ddd1SZE8NFE5?=
 =?us-ascii?Q?YEezmsAP71RKRf3xRz9YMXvhAOzmzmenSgyUmW4Vxqq9pSywEIken+VPRPV5?=
 =?us-ascii?Q?42VuReGNwNR9Cck8zGAt+hrJBieAy6Xoj1D42GUkLb7SoQgMl2ETKbY5SbL/?=
 =?us-ascii?Q?kJd0aFOKk8G1npZAZ8XFcLawNykjHwK8iB671kWrqGkYPB3BvIRuQKUN2+Sr?=
 =?us-ascii?Q?2KhJ9DZaGRVW+35+5PCoKauiAuvOuTJznJtduUBwSb7BtAxY3nGvtOCSfy1D?=
 =?us-ascii?Q?dnU1CA1ONrE+1DpUhy8jPFMZnCNQlDZvQqUFR1/9LXymQkYrH+3vmDQmYIYL?=
 =?us-ascii?Q?cMAFEKf1K4FxEQOmB1GmR9v2O8LebrBhZpnqL0Y/gnbiVzNmI9jNXSsAu4tv?=
 =?us-ascii?Q?W/TsDD+Zw5rXwarsput+RzrSXgEOigbrEhCwfIgA4Dz9AyC3RUQa1bxCmyH6?=
 =?us-ascii?Q?AoyEje4R8tdUSZ/6Ca6JSq6DNVBYJL2W39xoFj89MDK/lOeYP9JXb1+Y2uYL?=
 =?us-ascii?Q?pGAf/4lRU4JLS/AiEsEtAgBpqLGT7k0uhKAvsleJAZSiUzHvh3plrLDP2hM5?=
 =?us-ascii?Q?+IRqkezZZOj1tUswRewKyUiuaVsr5POWtztcLODCQE59euCndIO2cVhjAI4g?=
 =?us-ascii?Q?JcMN9/wIt6ad/+1IE8aE7G8+gINVbnZc7+tbO/EGgzYw2AuPDzOaMuXgjRER?=
 =?us-ascii?Q?J2+36lFTFgbDEYIRSGBvI+0BL6vy7iEm1VOdx01PKPbU0/5gsWVUsyTn9Vtm?=
 =?us-ascii?Q?QxXvKQlminn8tDPcKJ0wCwJMzKoJ0vk7mibezZaK970Z/D3ozMco4eO18jCQ?=
 =?us-ascii?Q?85jM523Qa8F0D5U+BbzgpT6ajQD7xnj0a/bDEDf1YNOrrqDjknWEkiRUB3hE?=
 =?us-ascii?Q?6YSEc/b3YHBpAQ2c/ey6JpG9ZtGD/a8ukId9DVvIxZtIw7Pk3JuDhhtVnD2d?=
 =?us-ascii?Q?o1ZjIA2SR6QbB5KEceszTCovUVZCZjICAh5y6bj8aO+ywZlpzAu2sGWUkrjv?=
 =?us-ascii?Q?rMQrmCL8vBfoNr+nlQXz3M6y92oGYZjQOsqpxBXCcDXZsw+VYFlMoXoFMWDV?=
 =?us-ascii?Q?FxS+E0oqITecFlKNYSoBzcqGKnUDtFoaCCfoHkIUf8d54GsIBLf2LPtE0bhH?=
 =?us-ascii?Q?HzmMD1POXuPDsWy3lhF1CeOUUbR/Ofoq9G1+bsXJ95tRDRwX45+fDkUc4b+P?=
 =?us-ascii?Q?MfUGUn+jm8Ulh7lYft+5SXfU7sJFUUuMNgOZeT759HwS5bebJY4zkWQs6QPw?=
 =?us-ascii?Q?W7M8JMc+qvvBjKhy0fEPbZ/PD31mn7BmsR0lJPfkfRBDhP6KZJTY44C0jzVi?=
 =?us-ascii?Q?iDuRCNFanUCk3L9emNNbFSuokeS3Li1foZIfNSl56OnLB6DVZPHJdCti0frw?=
 =?us-ascii?Q?rL2jLU0G3juAv8hhsPR5ML5/1L//Sfy2cRQtoiyjJLs8sNI+Ud98SMdhZK4h?=
 =?us-ascii?Q?H7J2JQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	bJdSyJ8lv2np3r56FtrK54QVzz35MGpN0fgn6c6TviWFbx+vdZ/Xxz0luQXu0ybKobHCG/5jXDZXcuu2tPNzfpqhZ1/gh6FsXaxGuEu2xTYZ8eZYv6xO0tmdQXbPouKHf9MRn3n1CywMfaNBfPcydvXDPddenQAA4Ef3udURbXObqxCr3Ku6ml8iWr0YxZINoV6Ig57UPwiNY5kMN3bwFZ8ZxuoGDNrxr3CsQneehirFup/iLLOlZasv0s3qfpUfLzyzQJb8zkTI/vXtZECc4FsdcBD9iQ3NDUDW0VCAMx5AdIqBbyJ2kcDI58kc9PiEWtnan9+GTzV9OGH3uLPRPP8ty6UgzAZCntGs1lXzcPfMpCIjpMqPCzIP8o/R1WMBXIhENl1Xc4M29LgjsoMwWboExAUHtkECt0k7OWH673WZzkWjhfmRYDVHyraPanApFqSXR5Fl9Xamm6dxezXxbo1/l1YvgQ6hfHkDKOS4LrymeSPSffQGVUkVkiEXX6m3hdqjaNqAzqOVR2zNoBGmy9OnzNjOh2YJgLrRd8tr/GxY81R/nxR1Gy/TRUYrUiWBrEUq49Gfs4MUA2pMYLTy3pjC0D1FcJZxMTKcRBClb94=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f2f7904-8cfe-4ece-24dc-08dda954721c
X-MS-Exchange-CrossTenant-AuthSource: DS7PR10MB5327.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2025 01:57:11.4718
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MWIDe+3Tt6SCynqYs0kPcD2r1L5uKjmaA9oofXmIsKvyjVyLP30roN0thypJdOUAsAckZsKGqVG4sgkLsGAcJkYpi59oqTiGpm9oNnS4iP4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB7839
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-12_01,2025-06-10_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0 mlxscore=0
 mlxlogscore=999 phishscore=0 spamscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2506120013
X-Authority-Analysis: v=2.4 cv=RZGQC0tv c=1 sm=1 tr=0 ts=684a33fb b=1 cx=c_pps a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=6IFa9wvqVegA:10 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=pGLkceISAAAA:8 a=mx6Z5l6ODcrpD94SwjoA:9 cc=ntf awl=host:14714
X-Proofpoint-GUID: 5SxhF6HZQpbFXC1-KwdGaIFMq818uFlg
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjEyMDAxMyBTYWx0ZWRfX7aKiHm6hokAw AhW6QwE88QRForQRr/kxGDu/RxvFcRjFufQ5t4YyrMYnXpjRcGSILfI8KR5ELpU+Py+8ZbIwnrS nV9KTPun9YpJbMyXe5aTVM64FAtzXUZ0GVFN29FLOGRAkEW/abeHl+eIcqF7/NiaTFpk6FrW2Ox
 qVfyl6xS8C6bmmI9xpTLPBQSiLd2TVk2dvQQ229As850vRPj+OOcUDCSv6UNfNHaTn7pxEkMB03 kB7WMMallGXSyLsh9ANH+IShbReQ08cl483v13+NV0xB7UO6F+r7XirmFVb6GvfrR/G2zbO2Ppr PCHEMg6NhPC8TTokf/h+cb3/RFEKUW0dzERKcmrgl08EjOAV75du8V6MEyAjha67QQ9QTGEgq6M
 agoII6PL1B7EdfRUDNHbSbN/xJJTnnfoTAtR7kQxEVrkYwIx0BfHI2GKgbZAxospNUmRlDWw
X-Proofpoint-ORIG-GUID: 5SxhF6HZQpbFXC1-KwdGaIFMq818uFlg

Add a helper to check that we can perform multi block atomic writes. We will
use this in the following patches that add testing for large atomic writes.
This helper will prevent these tests from running on kernels that only support
single block atomic writes.

Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Reviewed-by: John Garry <john.g.garry@oracle.com>
Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
---
 common/atomicwrites | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/common/atomicwrites b/common/atomicwrites
index 391bb6f6..88f49a1a 100644
--- a/common/atomicwrites
+++ b/common/atomicwrites
@@ -24,6 +24,27 @@ _get_atomic_write_segments_max()
         grep -w atomic_write_segments_max | grep -o '[0-9]\+'
 }
 
+_require_scratch_write_atomic_multi_fsblock()
+{
+    _require_scratch
+
+    _scratch_mkfs > /dev/null 2>&1 || \
+        _notrun "cannot format scratch device for atomic write checks"
+    _try_scratch_mount || \
+        _notrun "cannot mount scratch device for atomic write checks"
+
+    local testfile=$SCRATCH_MNT/testfile
+    touch $testfile
+
+    local bsize=$(_get_file_block_size $SCRATCH_MNT)
+    local awu_max_fs=$(_get_atomic_write_unit_max $testfile)
+
+    _scratch_unmount
+
+    test $awu_max_fs -ge $((bsize * 2)) || \
+        _notrun "multi-block atomic writes not supported by this filesystem"
+}
+
 _require_scratch_write_atomic()
 {
 	_require_scratch
-- 
2.34.1

