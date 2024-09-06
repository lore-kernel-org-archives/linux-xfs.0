Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9E7B1D79AD
	for <linux-xfs@vger.kernel.org>; Fri,  6 Sep 2024 21:12:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725657144; cv=fail; b=gSsnUJuKvTj66ij8Wq3XL/DFouRQ0DEAlVjjcCebS90pM3QCvU9bAppwwDswKMa3MmnyCDeV8M/j6DusHtruJKg4BhKIKsAVwzjZu13+EwKhE5I5eXP0fvobWEiZZIKdI2Wwh40MemefZK68ei7YGfwAUm3NNO0gB2Vw2KTXhTY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725657144; c=relaxed/simple;
	bh=SRIlL4xgXmRXiBOwWWi1VsEk+x3iHxH2LFfvZwedhAo=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=LetEZTF8wsp+VOE5tnQy8OHak+YNXsSyp7BD+lvZN2bldeXhQXW7P6EdxPrNPrVBU7UalNbItqCexCYVOyfm0uawPNIvIBhkozQtnQ7nDvsFGUt/qOwVwkA7HSGsTfvuBHrPz84UDLTv6ytUKFIZylWvXjpSRKig5pPv+j7g6dU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=eE0Xay3K; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=q9eE0y0M; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="eE0Xay3K";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="q9eE0y0M"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 486KXWt1027392
	for <linux-xfs@vger.kernel.org>; Fri, 6 Sep 2024 21:12:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:subject:date:message-id:in-reply-to:references
	:content-transfer-encoding:content-type:mime-version; s=
	corp-2023-11-20; bh=daYqU5HBP1jUzvPrbHscg9YPGF3bZmAUiZqYxWk+Cq4=; b=
	eE0Xay3KkOLpDMx6WjWCLb+Z4i8tfvDoSvwHDNqAKnQr36VGkn6wupcxkZItB01+
	kfvrtxuvvGaxHK3PmbGqVdpztPgGFC/KjPzTckWadGohqF7YFQl4Kvs149NLgT6U
	28LPFo0pblOM+fEetHVJ0vEf3GVx/0dfDfsKNepk3zmuE5pZ2tH6q1u8FIrXYVVX
	yAE/045BlSBIAZu1RqhrJkYMYA73k5R9DjF+Iz9OkXD4bnoael/tWW3AtJhYd6md
	ugOtBB9mbaQX8Q4r7Sz8TXFmV5svU8q77lqLM6nSYRxm0Ruc4ZGV5ZOmQGuwR1IE
	FPamJ9RF84OiK3Qb2Pb/UQ==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 41fhwqjhd0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Fri, 06 Sep 2024 21:12:21 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 486K64ci016219
	for <linux-xfs@vger.kernel.org>; Fri, 6 Sep 2024 21:12:21 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2172.outbound.protection.outlook.com [104.47.59.172])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 41fhyjf0ae-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Fri, 06 Sep 2024 21:12:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SIHNguGhsqcvjUlFu00d1bpOkNTrXzg3lI4BPRD6auRZPFYYeqx3L03Mwt2hrTMpbIqGMoKyjFfPgNRjbE4WGPewxYA/2Oa7vqYiWPNfiG+A2pEJ5w/Tz2Qf7cNTSWbyxk24r4xADYBtP/SjCeQQsiV8OB1/1DNrB3ERZQkyJh6rsrlmOfS9KOyZ01P8V7kgPhummnOIwK6AJqvQXTtzlF5UmkQU6Ja4Fb5zJMUAvPnqFeXWTctP4o3IqC+GSLXUg5CSW6IStTgl0tHjrKd85xU8p4PZ1kbxr1jHxl69Eky2QiXi08wcU9Sry30CEK8WOUUk8ohYNdLI2Np009Y5Jg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=daYqU5HBP1jUzvPrbHscg9YPGF3bZmAUiZqYxWk+Cq4=;
 b=yKTbKGUf35DsAtIL/hrpjx5p7v77HFV59iN9+sTuufrt2d4FhPt0bSAnIxSNagxyp177NUKuhs4gE2wyGpcIcSyu6Elr3y/QjVq5pR3y7Nik2SMCLwxEVcizXkMbQzI6gah/5NZ6XLink9ul6kHsRZPzW6elmC5hZB61RYmoDcU923UaOVHFV+Okwy35tCahHP1AMSwBMxbHwYuttD3lpBSkoKvBfqQ9A0ZeN63BhQ55/VuRoglGSlmbDpzyhvhHiKXYpiVcOUl8eDLnD4qMdG10R5PTBhlpywr8YmxPoMmn/CP9ibawTXzD23pkVwrdWnZ16PvhfzR1LnCYryZuUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=daYqU5HBP1jUzvPrbHscg9YPGF3bZmAUiZqYxWk+Cq4=;
 b=q9eE0y0Myfwj5OpWtp7t+RYiEkl43WnFYCMfcvjRy8n3iewQzexksyb+uV7TnJXslSgkjCDQR7rmIb+TpG88fYRZj4JpKH3XgRFzfXKDHAb+2p/O2khse++DZYMqP7F6VHvpLfLIBg7Q9NjWbBzSuVAorywEJAgjqJ65qlBXD8U=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by CO6PR10MB5587.namprd10.prod.outlook.com (2603:10b6:303:146::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7962.9; Fri, 6 Sep
 2024 21:12:18 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142%4]) with mapi id 15.20.7939.010; Fri, 6 Sep 2024
 21:12:18 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 CANDIDATE 19/22] xfs: fix unlink vs cluster buffer instantiation race
Date: Fri,  6 Sep 2024 14:11:33 -0700
Message-Id: <20240906211136.70391-20-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20240906211136.70391-1-catherine.hoang@oracle.com>
References: <20240906211136.70391-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR03CA0001.namprd03.prod.outlook.com
 (2603:10b6:a03:39a::6) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|CO6PR10MB5587:EE_
X-MS-Office365-Filtering-Correlation-Id: f421e939-6698-43fe-2825-08dcceb89754
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?1pIJ4ztjYq4ILKPzezUf4VfBhhcBJN7GlHTkluJksD3jaHrG3PsDACjJZi/p?=
 =?us-ascii?Q?2WfybSRfRZDc1kPlEISQ5YJmpwDMpPD4eZHsdv2kD0i45nzmDPv2DImilYUQ?=
 =?us-ascii?Q?xqaN14EUC9Ftcb3yWpaNkf0iwI4bVHNjzmKW38K37D0lJRmpBFaI6VVsOqLN?=
 =?us-ascii?Q?qY0tCl0MWCejgbzPRhXrtXJKUAOMEMZ05WVkdxx7eJsUO/d86Mz+7UdgMpnm?=
 =?us-ascii?Q?PVpI1iL3NenOJ+lcv7se8hTv8XFvA61zxM22zOwPQMN7LrmqCUfnYoD4yA9Y?=
 =?us-ascii?Q?OflgL47XM8DNcBI48cevjyPloyXtU19i7nlcsWkZaPmUUDV6Slu5gFdPQHNU?=
 =?us-ascii?Q?Cp1DkGUAig+ZaRYKktgV0J2nSVtuvn01M0J5dWgi/7E+9jt9pERdwoEdyecz?=
 =?us-ascii?Q?ZKIgAEoUjAXlclGHJLDlBSxYmuTOq3YetcAA/TyUCEQ2ZrUdoQAyESy31Kyd?=
 =?us-ascii?Q?vXwlFPWftOxJYFeaaWkjVxQHLmOMvdbcBhSV7b5pubArOsXs79o86IEbYNAO?=
 =?us-ascii?Q?6iM5EWkAkziCv02vzNF/oUStPmQMs2S679CnskBkqLGzILgdQwY9UhFpsfYp?=
 =?us-ascii?Q?UhClzDZNyp93yd/yv3F4Y6R3lzRxf9apAV9b5IUcPqLtf3ofPqI5fpCKzWIn?=
 =?us-ascii?Q?QjOUTj+xYZdyR+JtKlpjH0OA+u4WOJBKMeQm45kGHHj4aajpR1sbOQxnwqSi?=
 =?us-ascii?Q?d/AHZV1zqxLJbArWFkTPT5QKJ+6AI3L5ie3jz28SNbHQkYqASaiBKNqa5Npf?=
 =?us-ascii?Q?R2tAMLvjjNXi6DtuO00Tzz5Ej8RkqBmYS0pA60jqWspiVEKjRYYAh+LRL2YV?=
 =?us-ascii?Q?VbtG3yublafHdRA9uu16bJljvjXXEncLRFosxQKHjVKQbcLhfdLtXK0p5pdQ?=
 =?us-ascii?Q?FdaFWDVDZ0O6INYkB9OUe9xgTIKp9w66dsTiKmoLBdUagjs7cc/BqLEEOqRQ?=
 =?us-ascii?Q?ONWFxi23v05V6nq7Md+uZtwV02u8DBfnWdgw9Af2Ns8vgM3jS0C9l4M65B/W?=
 =?us-ascii?Q?FGXEva/B2GcAIT/beZzD6rn7zj9XKdDVDwbzBwTMcuuXOaOmDBKqfvpb3Xw6?=
 =?us-ascii?Q?o6gPchEq9vSm9Nt1gpK2hW0H9SdXK+DJyoFoY/Q9rnreZQYKPCzGXkFYBz6Z?=
 =?us-ascii?Q?h3QPL7Nj1TBx0CSUYtt4e6TUlDQR4c5Qd9LhkKkhkad56iFgl59aEUpkfh7j?=
 =?us-ascii?Q?eiKZaLxtJ3b3O7ktLTC5mrl36n2An5Go4pK+9FXPWs0Gw1oQhaup0HLQqzPC?=
 =?us-ascii?Q?HZoXJgUqzZViNZQIvYqtw3fag//TP8ycE+XLkNc3QNhxUGpHMOrCT9i2pRq/?=
 =?us-ascii?Q?ci9rxm90ACrEFqfLTWLYpC4MZtttkIN498fz7I5ZUL+3WQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?DyRd4ipMlQ86GAP5im+61ejmeTSnisuj9RtfTHBgzpVZOT8gMIqoSrz2ni5W?=
 =?us-ascii?Q?z8kXN65U/qWwxQ601TC/yAc/5LujrahmTC71I9Y1QAmz3lCqxRgxd5845ES1?=
 =?us-ascii?Q?Ty2cC/UfZSS5NS0ilHQvUGOfPL4rpoT4Tjh7+p1fGv5L2haeRdXXZnq4Ybi+?=
 =?us-ascii?Q?eDMBDOanbpLIrRVPB8qUgTkucZj3NiSq0eONnfw+WYetIyS0RjXiSaSOwLAv?=
 =?us-ascii?Q?QMFaeLaZR7gciYvKG1gFPfrVYxsU4t1DOP4J8CntzRoosjyO8fbaE4IP6nyR?=
 =?us-ascii?Q?N6sbDnghTRepD7W1stBOKtRoU4Zc9oeBpcarnpW4nS+VSFbjciJIl8Uu1S4y?=
 =?us-ascii?Q?wgNuhkv+KPkTaj6Lamdgq6fydiWc7/N7Xz6rsRIltm0oba6H8uPzbWzQb2bQ?=
 =?us-ascii?Q?yqoHOFAt4SIptCq1a9ya4+aTUFNxYzdUPac1Gi6qP1+67SnuXNlPH5Wqv0Gj?=
 =?us-ascii?Q?Aq56Dz9vopCwZtuF/2kuVHN8JVxdlS4UJcZtU+d23aSI7teADpaIeEZpg5nV?=
 =?us-ascii?Q?i7DffZ4P7A1QONiPu2ZYDdHTbqdFbMH2qBPGGYyQChV5mbqEumDUptjr9sqd?=
 =?us-ascii?Q?gCgmEVgVlcsfS2potWCUI58foGV3zlNu19V0rDvwt1HrMd0/ZBJSFMWkVyr6?=
 =?us-ascii?Q?OM3nqRhI0TJCTUqysND4y3Lyl1VO8jbKAiqu1D/S//54rOQA4FgzRAyUbXLI?=
 =?us-ascii?Q?L1pKHn8teEPECPuc8Qbv+AZwddSvA7YIeQNZPKD5W1eHHQUYv1Jirng8T78Y?=
 =?us-ascii?Q?5FhODv4lkifXiAR9a6sNxmnEuqe3za47/cGc4vEj8VUfhTHaByFbRjqh/fpm?=
 =?us-ascii?Q?xgbfUGGaNDFyZ5eeihstuZT9OMeKZQ86zHeI8xfnU2wYaErpuOJW37duf62e?=
 =?us-ascii?Q?kOUZ7H6lus67+XSupeBxJun5fo/OJdB+Bphp6m9d+5SIVqXN6YpBcs0Tq1qM?=
 =?us-ascii?Q?JfZHO6sj2eYmdJsVQckkXjmV9w3sqKw3LpReeXfJVQUDE468xedZM5KlVlM+?=
 =?us-ascii?Q?7fxaEW08PAV/is/esec5Y3F7B5+LbrHRBFA04bxY3hapDfzuU/T6CY2OD8k2?=
 =?us-ascii?Q?rSp7ggEQv91J7rRG/rpoaK1DDER88QjFtKUM69ZA7bV56B+ymGWmYOJTWjsp?=
 =?us-ascii?Q?OCmmF3ES78znQTUhKxIXjpObBEGHRvLV5WySETkykegOiaZL35YzN4hMEHEz?=
 =?us-ascii?Q?1GY03Rx4zTAy4Kb6eaW0Y9expmgVpPIyXts3ESYY9sO3k9XkpGFbuvsA9uyx?=
 =?us-ascii?Q?6nuPJ12FUOk+sUpCFwkJWEoaIceajWK4uE0fr70EdsWdJKZegV4+6CdcF1Tv?=
 =?us-ascii?Q?jqPspg6OH6+KaHoNlR6O9I0SnGWtdfx9jnN/B3qbwq8kHQ5B7eOqqAxKYKQY?=
 =?us-ascii?Q?WHBNwTTlk+pZS/nEVR7JKPQviqMtqxT5izDBRjN60olHkAWqLtOq3mgtgloS?=
 =?us-ascii?Q?JJErQ8hRuLJM+oW0yWZ8Q9Fd4N38YhOPJfztl/HVOyswGTiT0a7bfksqrGtk?=
 =?us-ascii?Q?Umgym0k+wJ4GDofXZF4N3kOvgzk8fmHt3+nufm8ErmN7qHGDYWSrjSG77FRG?=
 =?us-ascii?Q?GhUxoUovSnfoA44VqJcf+inEjT6+ecV39XOtSsZNy8SPxmmktl5KIbljaa19?=
 =?us-ascii?Q?4w=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	gcr1lg2thozoAmpz8xEshFRkfyp8kuhKpLpgVf0fsE/rNf0G46Fv8hPrRI4Sg5HpijoDj1hwMf7QxB2qlOTREUL/WSDMS17KiEgl2SXgR6xaNkJ9tb6VetuxauNXhnYRl+8re2YSo+qk+FzbfuUUkWA31Eo1V2vTpro2v2arr1aCrFMv2XeI6JnpyD8rYmqnQTL/O17BvfMV7PjrZ8WDVPq99qxbYQaICoGweauk36p16bV2+nSAcecviL82fubkENRnNPhP0hM9rToza0at09v7FI9j+XlykdZEmrzDML9dZ6srzabDxxXF3ORF7TrBQI0NHkYLqLnsV897z0bNJS5KHUroBmWAsChH8NA3NX/J1XG0jrwZF/lA1XqlLO15PFOrtPupTP4K0rkEUsfX8ni6pujKLewYK8YlmaPIv/YL0s8Ytl1g9yXIhtBNoRitOY7KfBUbUg8TfLy0S9FDhJUwPkbnuZO0RoTRnNLhOkzUAyGj9LkRGoZV3bs7ECxAj1/3A6y4hXWVopDlbJypEbtyzN0cMlNMxTHiVCWt0XLFHrC4fMHFc251u9lHtu0jw6Ew0AcXJzeOKwZ95ZPEI/fG8ADcmXaMTJRe7WVPfrU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f421e939-6698-43fe-2825-08dcceb89754
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Sep 2024 21:12:18.9228
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: J+YmITaicWv0f31Z2IWcBZzZgZyNBfsxvZei6dBhJOu9N8rIab4VLdB7RWcRnAG5SuoN6tqJRVq4BF5FhXhVtZd8ufP7EON8iX++NgfhIN4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5587
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-06_06,2024-09-06_01,2024-09-02_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0
 suspectscore=0 spamscore=0 adultscore=0 mlxlogscore=999 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2408220000 definitions=main-2409060157
X-Proofpoint-ORIG-GUID: QXNrR1v9F7VFxfF-Hdwd6Tac6q7lC64p
X-Proofpoint-GUID: QXNrR1v9F7VFxfF-Hdwd6Tac6q7lC64p

From: Dave Chinner <dchinner@redhat.com>

commit 348a1983cf4cf5099fc398438a968443af4c9f65 upstream.

Luis has been reporting an assert failure when freeing an inode
cluster during inode inactivation for a while. The assert looks
like:

 XFS: Assertion failed: bp->b_flags & XBF_DONE, file: fs/xfs/xfs_trans_buf.c, line: 241
 ------------[ cut here ]------------
 kernel BUG at fs/xfs/xfs_message.c:102!
 Oops: invalid opcode: 0000 [#1] PREEMPT SMP KASAN NOPTI
 CPU: 4 PID: 73 Comm: kworker/4:1 Not tainted 6.10.0-rc1 #4
 Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
 Workqueue: xfs-inodegc/loop5 xfs_inodegc_worker [xfs]
 RIP: 0010:assfail (fs/xfs/xfs_message.c:102) xfs
 RSP: 0018:ffff88810188f7f0 EFLAGS: 00010202
 RAX: 0000000000000000 RBX: ffff88816e748250 RCX: 1ffffffff844b0e7
 RDX: 0000000000000004 RSI: ffff88810188f558 RDI: ffffffffc2431fa0
 RBP: 1ffff11020311f01 R08: 0000000042431f9f R09: ffffed1020311e9b
 R10: ffff88810188f4df R11: ffffffffac725d70 R12: ffff88817a3f4000
 R13: ffff88812182f000 R14: ffff88810188f998 R15: ffffffffc2423f80
 FS:  0000000000000000(0000) GS:ffff8881c8400000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: 000055fe9d0f109c CR3: 000000014426c002 CR4: 0000000000770ef0
 DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
 DR3: 0000000000000000 DR6: 00000000fffe07f0 DR7: 0000000000000400
 PKRU: 55555554
 Call Trace:
  <TASK>
 xfs_trans_read_buf_map (fs/xfs/xfs_trans_buf.c:241 (discriminator 1)) xfs
 xfs_imap_to_bp (fs/xfs/xfs_trans.h:210 fs/xfs/libxfs/xfs_inode_buf.c:138) xfs
 xfs_inode_item_precommit (fs/xfs/xfs_inode_item.c:145) xfs
 xfs_trans_run_precommits (fs/xfs/xfs_trans.c:931) xfs
 __xfs_trans_commit (fs/xfs/xfs_trans.c:966) xfs
 xfs_inactive_ifree (fs/xfs/xfs_inode.c:1811) xfs
 xfs_inactive (fs/xfs/xfs_inode.c:2013) xfs
 xfs_inodegc_worker (fs/xfs/xfs_icache.c:1841 fs/xfs/xfs_icache.c:1886) xfs
 process_one_work (kernel/workqueue.c:3231)
 worker_thread (kernel/workqueue.c:3306 (discriminator 2) kernel/workqueue.c:3393 (discriminator 2))
 kthread (kernel/kthread.c:389)
 ret_from_fork (arch/x86/kernel/process.c:147)
 ret_from_fork_asm (arch/x86/entry/entry_64.S:257)
  </TASK>

And occurs when the the inode precommit handlers is attempt to look
up the inode cluster buffer to attach the inode for writeback.

The trail of logic that I can reconstruct is as follows.

	1. the inode is clean when inodegc runs, so it is not
	   attached to a cluster buffer when precommit runs.

	2. #1 implies the inode cluster buffer may be clean and not
	   pinned by dirty inodes when inodegc runs.

	3. #2 implies that the inode cluster buffer can be reclaimed
	   by memory pressure at any time.

	4. The assert failure implies that the cluster buffer was
	   attached to the transaction, but not marked done. It had
	   been accessed earlier in the transaction, but not marked
	   done.

	5. #4 implies the cluster buffer has been invalidated (i.e.
	   marked stale).

	6. #5 implies that the inode cluster buffer was instantiated
	   uninitialised in the transaction in xfs_ifree_cluster(),
	   which only instantiates the buffers to invalidate them
	   and never marks them as done.

Given factors 1-3, this issue is highly dependent on timing and
environmental factors. Hence the issue can be very difficult to
reproduce in some situations, but highly reliable in others. Luis
has an environment where it can be reproduced easily by g/531 but,
OTOH, I've reproduced it only once in ~2000 cycles of g/531.

I think the fix is to have xfs_ifree_cluster() set the XBF_DONE flag
on the cluster buffers, even though they may not be initialised. The
reasons why I think this is safe are:

	1. A buffer cache lookup hit on a XBF_STALE buffer will
	   clear the XBF_DONE flag. Hence all future users of the
	   buffer know they have to re-initialise the contents
	   before use and mark it done themselves.

	2. xfs_trans_binval() sets the XFS_BLI_STALE flag, which
	   means the buffer remains locked until the journal commit
	   completes and the buffer is unpinned. Hence once marked
	   XBF_STALE/XFS_BLI_STALE by xfs_ifree_cluster(), the only
	   context that can access the freed buffer is the currently
	   running transaction.

	3. #2 implies that future buffer lookups in the currently
	   running transaction will hit the transaction match code
	   and not the buffer cache. Hence XBF_STALE and
	   XFS_BLI_STALE will not be cleared unless the transaction
	   initialises and logs the buffer with valid contents
	   again. At which point, the buffer will be marked marked
	   XBF_DONE again, so having XBF_DONE already set on the
	   stale buffer is a moot point.

	4. #2 also implies that any concurrent access to that
	   cluster buffer will block waiting on the buffer lock
	   until the inode cluster has been fully freed and is no
	   longer an active inode cluster buffer.

	5. #4 + #1 means that any future user of the disk range of
	   that buffer will always see the range of disk blocks
	   covered by the cluster buffer as not done, and hence must
	   initialise the contents themselves.

	6. Setting XBF_DONE in xfs_ifree_cluster() then means the
	   unlinked inode precommit code will see a XBF_DONE buffer
	   from the transaction match as it expects. It can then
	   attach the stale but newly dirtied inode to the stale
	   but newly dirtied cluster buffer without unexpected
	   failures. The stale buffer will then sail through the
	   journal and do the right thing with the attached stale
	   inode during unpin.

Hence the fix is just one line of extra code. The explanation of
why we have to set XBF_DONE in xfs_ifree_cluster, OTOH, is long and
complex....

Fixes: 82842fee6e59 ("xfs: fix AGF vs inode cluster buffer deadlock")
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Tested-by: Luis Chamberlain <mcgrof@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 fs/xfs/xfs_inode.c | 23 +++++++++++++++++++----
 1 file changed, 19 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index efb6b8f35617..8bfde8fce6e2 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2329,11 +2329,26 @@ xfs_ifree_cluster(
 		 * This buffer may not have been correctly initialised as we
 		 * didn't read it from disk. That's not important because we are
 		 * only using to mark the buffer as stale in the log, and to
-		 * attach stale cached inodes on it. That means it will never be
-		 * dispatched for IO. If it is, we want to know about it, and we
-		 * want it to fail. We can acheive this by adding a write
-		 * verifier to the buffer.
+		 * attach stale cached inodes on it.
+		 *
+		 * For the inode that triggered the cluster freeing, this
+		 * attachment may occur in xfs_inode_item_precommit() after we
+		 * have marked this buffer stale.  If this buffer was not in
+		 * memory before xfs_ifree_cluster() started, it will not be
+		 * marked XBF_DONE and this will cause problems later in
+		 * xfs_inode_item_precommit() when we trip over a (stale, !done)
+		 * buffer to attached to the transaction.
+		 *
+		 * Hence we have to mark the buffer as XFS_DONE here. This is
+		 * safe because we are also marking the buffer as XBF_STALE and
+		 * XFS_BLI_STALE. That means it will never be dispatched for
+		 * IO and it won't be unlocked until the cluster freeing has
+		 * been committed to the journal and the buffer unpinned. If it
+		 * is written, we want to know about it, and we want it to
+		 * fail. We can acheive this by adding a write verifier to the
+		 * buffer.
 		 */
+		bp->b_flags |= XBF_DONE;
 		bp->b_ops = &xfs_inode_buf_ops;
 
 		/*
-- 
2.39.3

