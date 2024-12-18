Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 339EE7080B
	for <linux-xfs@vger.kernel.org>; Wed, 18 Dec 2024 02:14:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734488070; cv=fail; b=XSWqWkh/UlyNLlz806PNSw6zRiUythN9QXD4uzVQMYcGKS719voD5eOUdfvKvNQbv9x+weIVzbz9nx7gpDRwUaMOWSj4UGJLUzgdPYm+3qg+/toEqlFfNfJ7d8lqM59LafWztF1TWM5o8gBCNV/2s3bYK5Xp/FId5w1JX696N6A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734488070; c=relaxed/simple;
	bh=EDEAopcb5aaDV3IxtkrLyB5Fh/DfGDmJHerFBFZoaKs=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=noFW5YvnE7qOASyMXu9uRkBy0GyuHaVVJJ9dYEpnLLRV/UsKgbbg3Pszr/tEiwoEtiOGoHlordtn8JbmFwcKonA98p2CMqlIZ2EOXBsGyr36AvGH/gfbLG+sTH6fhzzyjphyahRt5ifjSoNepg0ak8820U85dsCttLw1Q+svL20=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=PJ+tIlub; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=PFQ18QL8; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="PJ+tIlub";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="PFQ18QL8"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4BI2BrvX001129
	for <linux-xfs@vger.kernel.org>; Wed, 18 Dec 2024 02:14:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=33Sa8NpBRSsVzc9p9XSCT1Ps1Lc+cgCT0PjOc4qJGag=; b=
	PJ+tIlubbF9dzYTytyS5TRCtVTt+1s025rSo9Em2spGKubVWZmijzPXYWjDcDMiZ
	eot3VpU1iAn6BFyQBfwQR2k1+PEOqgFyW9qYXshYk5ZSTOYkhNEf27IHnF/6FHUm
	sHSPxUK47z+M/r4tCzgfC7nJNndD+aXFQoys8AnFRqb4j2v82KvtV9Vah/ctxLMb
	D7lg6qoiPOV9KuvZU5ADuxtcy5DsmSVWdNvBBIThWONj08bsOFkyGDZtINR0hNoj
	4DPLF2tmqfzG8Ws5DZblO9mGfxkg6EKIEre+NFy/Qmj6idc4uhHCl/0L6fIy17av
	cnjH2I/bcwKIk46Y03KN7Q==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 43h0ec7fmd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Wed, 18 Dec 2024 02:14:28 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4BI16RUG032823
	for <linux-xfs@vger.kernel.org>; Wed, 18 Dec 2024 02:14:27 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2176.outbound.protection.outlook.com [104.47.55.176])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 43h0fffbd3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Wed, 18 Dec 2024 02:14:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OF1iee+7UECWPpAwy0vpN8yAgObc49/T3nyr0rb3AajtZ8VX4cWRCDxtS7/Tpu/zHErRi+e+6PzTkEJhnHPiGiWmWvZoMnrsx9N3NAvFyBcBjukZfs07W9yED4Y+Rmb9Nr5AllekEL6mi7lcjTcLXUKmE8Y8/r/wW9bvKaMSI4pDdh1hNNyk+9PyAxjroE2zm4IB1LU60Wpv3Jvjdfwdjw5h0d52uHfs2sD5Hx0JBQxzzGDAN6NIz0nbC7gadqvjdAFjZWezsacAMn5GKc4qHO+ARtsdm5Xtxnl/eTFVp8wYqKZ5J+sLeQFrQaRUM+hBEirgouFhBQxIcHV4Qh3+AA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=33Sa8NpBRSsVzc9p9XSCT1Ps1Lc+cgCT0PjOc4qJGag=;
 b=Yp+2fS4IMFpCNWQB/5Llr78owHLUy4JIHgy1KpixGqg1k/jAvyOos5YpkGDR2GP2fw/HD+PCR4OaH9mu5mYbFBjVu9r6uG4nc9YSPyT4LQVO7WDXig8+XK356mBpwkXf1mCprU8qCNBzaAgS49/nNX7xa7tJVUEdcYrXHghCCnHDa4MpemYCDb6uot2qJndY/gvCk0LF3RGWQHDCAep4kd3oMeOppR8Fay87E3ujy/nuyvmWHKdg+Fe5uFX8isdm8u3yLU9yA1V6AyW6okxpvo2hEpNbEjVsh78TL/KAbvMRicqjAatB14qECsi1XsWUEceCFy/ENBLUpz/tokTU6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=33Sa8NpBRSsVzc9p9XSCT1Ps1Lc+cgCT0PjOc4qJGag=;
 b=PFQ18QL8ELJSNAR2sFQaWIA9SMYczHhmuN4BY7Tmwh6K6yKoMqqAeOb7SYVeK143i1sKnflZ5ih70ww/UpCSaisn45alqkojAeix4+EXRvFjsQ6Ji+TRaZA78StKGWEChrkpeLvX410Clvkz9UBkDMg/WUfx1SHpHIOIsow8Z00=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by PH0PR10MB6959.namprd10.prod.outlook.com (2603:10b6:510:28f::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8251.21; Wed, 18 Dec
 2024 02:14:25 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142%6]) with mapi id 15.20.8272.005; Wed, 18 Dec 2024
 02:14:25 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 CANDIDATE 07/18] xfs: Fix xfs_prepare_shift() range for RT
Date: Tue, 17 Dec 2024 18:14:00 -0800
Message-Id: <20241218021411.42144-8-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20241218021411.42144-1-catherine.hoang@oracle.com>
References: <20241218021411.42144-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR11CA0070.namprd11.prod.outlook.com
 (2603:10b6:a03:80::47) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|PH0PR10MB6959:EE_
X-MS-Office365-Filtering-Correlation-Id: 91865e97-d658-49eb-2560-08dd1f09b1d8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|10070799003|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?uz68642VtAjCgryD2Pz/pC7crxLalUUJ6w+Psp6AQ6qbZTjAYlmDC5xpUavm?=
 =?us-ascii?Q?0NZA+pbs07X8JOfH6V3AecK3fmUr2RinDZfMw+/spmsB9xawBsGHy8N9trW0?=
 =?us-ascii?Q?FuKtiQ3dmjdv4Y8nx26/SItljq69lOk3p990ZPMo96XwE9VmcWiJhy1PjyXB?=
 =?us-ascii?Q?LlRFbrZWTcvLnndwq9umzP7GaQ6KMsxnuPmOYYruz0ehUUetUs81RhuMKLDw?=
 =?us-ascii?Q?hFf0SyCQXIpzeKYCggUHLhJmVWMJKli4G1fq+36XXm2EMiSh9MfL3hsp0bwn?=
 =?us-ascii?Q?3v6B3ipxBQwn80M2vmdiMofX8Xw2+u4+BrSTxXQpmbdf3nyzGt9I1IztD6Ek?=
 =?us-ascii?Q?YAnAwXh4eKA8YyHDSsQEcvTyLruRUz5qxUZ4Z9AoHaVTMDUBcguC6kSVi2b3?=
 =?us-ascii?Q?Gpt+5NWnLjF7ggj0JoY6kO7LtT088ooLfr/h7CoSjSXq8xc/zQnOHy4IJhkM?=
 =?us-ascii?Q?k0KKhowbP8Zhzp6S14aDohjiU0B6veZTa6loi8bRMSwDPpzIdP4s5mWG0QOx?=
 =?us-ascii?Q?DTSzDbz/sc84ii4+lW86r6mPmjTZzWDmNLrBXfG6WfYdrGhD8dtz+kTMer89?=
 =?us-ascii?Q?ApeYWbD+3RqKIoHQVWKZGkup8klGVz08X9paURHTZcBL0i76I9i4VamDCvtp?=
 =?us-ascii?Q?TYHrUHMkEORMdhjheHjQ5js57YExcIlh2Y18FUlafl4NW9fFvYXMWyu0YP/s?=
 =?us-ascii?Q?r3O7oOAL694dEwxNqu0SOs3u+MHTZ6l0zjYz2U+ViQNaiU0tosAnwBRY/AwO?=
 =?us-ascii?Q?z6lcF3Z8mYepy6+coWhSoVgNP8PFxKiFP8ke6uXjZLu1odyQ8uoBI3QUYZO+?=
 =?us-ascii?Q?l/FB8gfDx4/wE1aKki8F+3A1ortfx7ysYvh+xh5hqDHZaGXFTUigk6EgvM4d?=
 =?us-ascii?Q?8DvUNLzy89b8ZjyuR8Zt3ITg5J23anmaAw3bJE6J9PBkr8w8SN+1u0WCmrCx?=
 =?us-ascii?Q?qwog0kkAsNWCRnllyE5PCxKKd6KFEjdLIZw3SAV87ZKDmFKGgY/NDUIdXMfe?=
 =?us-ascii?Q?4a7C6I6yHXb3d6cX2sOyLNg4TQZfAjzC4GmMh3VsHw5R/sT22NVZQDaEv5VT?=
 =?us-ascii?Q?3f5PQCLFSBrBMfGImDt19YOQYfqlU/9aaRb2LJaqM7UAtMfivtz1UYoxOYdH?=
 =?us-ascii?Q?R0wNGonzxmsULECk6yQ0igHNof++P2mst1lHtwehz19v0W5kcJtJBOK7zAki?=
 =?us-ascii?Q?EUjLey40tiG2pGH3IdeaGfqY7+1mVeSe47pwh090rsfVdReAPEZ58l1MCrrw?=
 =?us-ascii?Q?dx9oMN/aNpZZWDi5kOJCNSKmmYQjzeeJ6ZIylPPUnXHPket/S47pGWjg6sc9?=
 =?us-ascii?Q?uFE8SI6gXpcqLDXh50d3GQcSE0RX5eCJrVSBxVv+lV50F6qLxA7yEOyzfShA?=
 =?us-ascii?Q?dj9Wn8MLNq7MP4yzYCbHOuawwUt1?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Cfm4BBehtv/YgUNYsBxjiHuj0QmeTLY6sPs7EICrVeLLqDysDlaEvhQHVX63?=
 =?us-ascii?Q?LWGrLhcQF60BgTuVJI9fy8w+GQgBbsRyBlOsVO4nWXbYYizxIIzhbmzfoTET?=
 =?us-ascii?Q?WwHW/46bF+697Mz8dQkAD7L++UaaZX/v/i/VWTNqohSW0/UMWW17G1uBHtQ3?=
 =?us-ascii?Q?37cyWdN8azvHc1IFpcRvo9kOrtgN8rt0Ocf1WhkR6lljSS689NA5zsdnwWbr?=
 =?us-ascii?Q?ORMIYU9w8EB/BRhPd2Hm4KstBUh8N9t0CWjbvY2GuEzefpEctP8bu51eJ+2v?=
 =?us-ascii?Q?h7BHWMATHQRv694cdhmLV1QQw1CbBweIJOA6DpUXf+k1JYdvucCY96YDesLH?=
 =?us-ascii?Q?OG1WoSm/cc09r4SZSqe5R1jmOi96Hy3/OyR2ENo8Fo+Q2OWmjjSqWUVoxz7d?=
 =?us-ascii?Q?cTaHbhvIctaJIvx5naHPp9js6/lvjQEjSzrWwBk9RbUV+sK/Ome4hWLuTk8Q?=
 =?us-ascii?Q?WeDMiZBhpoQ0+6MSKLdm6Pr6rkllfQUwn4zKxjrh53sdkTX8DUr35kG6lLz8?=
 =?us-ascii?Q?GhJHRIEBFE8nfi7vwJPt7e1guNYPDvZgO6J8BgU1GS+Sltm/hLmoG59B6KIN?=
 =?us-ascii?Q?kXPZFEuSUobvBqTKEh23FWM13YTfIg4a9l/A8KPZxvZaMnVyuZK+FKIk+wz1?=
 =?us-ascii?Q?cjwFhTNPaAQ0b0fBmyF9Ad/mSnVTxdZVyb47aWFpGCU8r/MFqxvFw9Tb255m?=
 =?us-ascii?Q?GGhkgqkWDES+fARAgYPPZ+V11qfWvnY2DF1i3mYUjaoYI5KiUtgMEKJEDAH7?=
 =?us-ascii?Q?B1HZz9/5vWlg59d1XWvzlLbQl4+Qs6FuTCYbcLmnXIR7TtQMxvp/mv8hQ0E4?=
 =?us-ascii?Q?9c/r2zY9y0DADAKcKnKwRliZKGWy/2RD9FIq/0PSEfeNb//TRwdcMq++enHq?=
 =?us-ascii?Q?IPifqTy4LT5guNVXMuOuCA88K3dlyn6n+9U7RO1SouWfg0f8fMKhozwLmev7?=
 =?us-ascii?Q?itbuWJ4m7PyhWXYu4RPrL8YSuAyy+Ukt5lNTelU93iLFb0gdiP5anTq8duhB?=
 =?us-ascii?Q?HjcY4e7cI2sZlmdP5u7W9vYY6UrH/IZetji5yqpzQBCvUo1yViBoYtRRIeAo?=
 =?us-ascii?Q?vhV+/Gi0FNB/RJ7nsHjbP1BMLClttOchYLx1EpkOhDHBiPMn27igkddJfe0B?=
 =?us-ascii?Q?s6sIM7LCA6gGCmtKm5a7z6tlSgyfVY/5FwjmPjpXAs+ZLZp3NSUmYyTAw2pc?=
 =?us-ascii?Q?9l439A9c4sT+SNq1DBxcZ6kA5x99exLVLV/mhQ2tYIoQDDiHZ11lqm4FMoka?=
 =?us-ascii?Q?W3d3Kk4oKTuiS12sScNJ748FLU+TH3QQik+67LJG6ru0JGJCxMqlmnB3wKPw?=
 =?us-ascii?Q?7ZaJsR2gRTyGwCnmYLy+htC3/Zike88BGWe4lyT3eZxRNSfK4wi/W1gjqUzz?=
 =?us-ascii?Q?k2mh47WrRgrtlfFfAGErDokRmV330+C+nR9aDIx2gG6sbqmEzpAiXq/voPuT?=
 =?us-ascii?Q?HaXfCiSVzjh/wJvnlUOE7K72AhIuL1PtwQxAlVteUehPSs6lzchYJ9eugXbF?=
 =?us-ascii?Q?HyXCCDvAtsDmp67SXLncCPwMiiQtkTjGPZJOJKk8p5hilOCwwndHcjFyuKzg?=
 =?us-ascii?Q?azBORC/ssgIH2T/H9i1NkiJGCDAn5WnSNVG537aOqjy6i0hPpRsVIvnJb4zb?=
 =?us-ascii?Q?mjnx9PDTcwjAPxMyJ1kdmKQ1hEQifegkMHKmW/6OcaA3LJV9+D2k0+JAK2F2?=
 =?us-ascii?Q?cEZOXQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	+SYN0DO3yA6IYAhctWkYaDiqvIpi3mkCJJLNStuPTnSW1g6RHFYvRxnY2cg8EZZylLEpWa24LYKtvAkcO26Le12ZODU5ar5LeYeAHTQv4BHyttAV1AM+b7Rw7JGXK7zg28PFtg3VMnEKAfClw4RKakdB3kHGZ3gvTOn7hF8FVROtU49UxGAJxgXrLjm14z9jqovorwoCqOJzuPt5sJrUw7lm+yfggpjQnCliiMS4ltVYkQdctUPj8X6u21N0zOauDKAGA6jjuVi5LTTRdgPY2lhg5Xuop7RrCU/YwtWNxR4KIQh9WHCN0i5OLQk0q68bAHAk0NSB1LzDOSWGSVeKXZC4ubQgMJBs3g3Dh0PfI3c6FzcXyfeT++Un1didz8Sw6VGJaW79vCluPsf5hu3sg+jEWPty5pZcG5Cbs7zP9xc5wDwQ+2uczm8k08LQfxlvRoO0fW+ufr4Vtab7DmwTkOLX/vTBCU84R4/Gd2kQU7Cq5RShnjfbQJYzxkZ+WW0NBxKzPbWv/xuExZCtEChHB/GXN2EfzQpmhx0Jcv0CGEqn35iPHfyuihxKHkmo38xcI49lDYJd0/f8aMb3P3qWFXnNZ0jiugi2bOtTdshGmKs=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 91865e97-d658-49eb-2560-08dd1f09b1d8
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Dec 2024 02:14:25.7136
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wprYd/P7CfRU+yDPw3qcKAFH7Jq+VPUIoe+X1OUUqDD1Bc1egaCqYvmhqpjWZl6YZf9wi5agOZ/xo7DrsWv3QTLazvI/ypUqRvW/2tCzBlk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB6959
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2024-12-18_01,2024-12-17_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 suspectscore=0
 adultscore=0 bulkscore=0 mlxscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2411120000
 definitions=main-2412180015
X-Proofpoint-GUID: qAfr6uKFBkuBUsk07KnrLlGCC9OBVT7J
X-Proofpoint-ORIG-GUID: qAfr6uKFBkuBUsk07KnrLlGCC9OBVT7J

From: John Garry <john.g.garry@oracle.com>

commit f23660f059470ec7043748da7641e84183c23bc8 upstream.

The RT extent range must be considered in the xfs_flush_unmap_range() call
to stabilize the boundary.

This code change is originally from Dave Chinner.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: John Garry <john.g.garry@oracle.com>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 fs/xfs/xfs_bmap_util.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 7336402f1efa..1fa10a83da0b 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -1059,7 +1059,7 @@ xfs_prepare_shift(
 	struct xfs_inode	*ip,
 	loff_t			offset)
 {
-	struct xfs_mount	*mp = ip->i_mount;
+	unsigned int		rounding;
 	int			error;
 
 	/*
@@ -1077,11 +1077,13 @@ xfs_prepare_shift(
 	 * with the full range of the operation. If we don't, a COW writeback
 	 * completion could race with an insert, front merge with the start
 	 * extent (after split) during the shift and corrupt the file. Start
-	 * with the block just prior to the start to stabilize the boundary.
+	 * with the allocation unit just prior to the start to stabilize the
+	 * boundary.
 	 */
-	offset = round_down(offset, mp->m_sb.sb_blocksize);
+	rounding = xfs_inode_alloc_unitsize(ip);
+	offset = rounddown_64(offset, rounding);
 	if (offset)
-		offset -= mp->m_sb.sb_blocksize;
+		offset -= rounding;
 
 	/*
 	 * Writeback and invalidate cache for the remainder of the file as we're
-- 
2.39.3

