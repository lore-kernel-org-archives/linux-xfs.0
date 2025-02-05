Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C67D20E316;
	Wed,  5 Feb 2025 03:08:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738724914; cv=fail; b=u32YMFw9etFK2vGmsaj2iXJ44dxWKRZe83pca021zfNsyY79tKA73GYlhfOBexewGljmJ1Q+IjbAwkf5wEuZQyaYd7gq7q/9V2crshmWQYWzFygH7SHHQXmk8LsU0UsKWJLgTbUrj1dPHvVguiEL2h/LT5SIRCTC+uAUjYj0XGY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738724914; c=relaxed/simple;
	bh=0+IgPemvuBnCwUvxtTxn4tbKz5Tkghi9aGUHEebsjFg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=kLMLA1Lo2DnW721fiAo2bIdyrM3+60HFSTKGb9JS+PztFCvOneY/ACJDzdLJI0L1OaBfL93dFgNrf3jHAguoqhaH9kc15sUHUpAaGee9cuNYTsoSeUC9OtMi8iRPY3YfOZ2BC/QWvhMYgFQJanSkuIQY/hyPDWIaSRnZwJGcaGI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=R1TPgu2Q; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=rUKTKq5d; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="R1TPgu2Q";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="rUKTKq5d"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 514NCgip004493;
	Wed, 5 Feb 2025 03:08:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=ojCMpgNtjeV0bHEFno51ZnNk1q9Qnms3Fpy80+mMxLk=; b=
	R1TPgu2QpEHBpmoJoBkn57Lp+0qrMRFwJR+Jn/U85w8hO72qo8h67Pat1t3AXGPG
	AVKH87SFuKPDrLaCn4c5zMUzSpMClFnLOCc7SN8amwoYg8aDGtkl6XXT9e9Em2HR
	6Ve8SVyLn0rliT3ZQ5D516I/kIrvA97nwYIj2v8FUObfdn3V3oe1cjOMsTN2Sfov
	lz3e3xduz1d5X0j0BFs/MTykHQ188Vq8aANju+GLdXorwqdsaR0/nbcfE0AAPZrZ
	7Dp6Jz2uHJVDqCH6XuE5IsEanDKQ+WY6YMX21T044bsA62Og91ME2bJfYlxSTXUc
	93ykBMFKsotloj908hIqyA==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 44kku4sdb0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 05 Feb 2025 03:08:30 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5150gUhC036451;
	Wed, 5 Feb 2025 03:08:30 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2176.outbound.protection.outlook.com [104.47.59.176])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 44j8fn1phg-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 05 Feb 2025 03:08:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=J2zP7eIZurSISwohRDHpvgl7p3cEGHbmqdd85j07zDEteAtj/AqkElEI1y+LwCC2tU7MlxUo+1T5HBmDM+HsGkt/MJ6ICFGLNFNkOXwemqCypD4EFY5djTZtOOoU9PrdQEtwl8/pRTDvRpARa3GtwgJpECPW6M9+V7VTA/hDayT57ZT1uhJW5MDUnj91qty/Oh4p5agysKouhsUoNQogktbjrETRbIoaV4ZSTU7LWBYRpgy7nRdaDA8pNaWDHLp82gFtTEA2rsrMP2N4RPXGsjh1sdgHA5mPCElctJ6pa2xrTvkDnZSAmu1JBVs25DaQSEI58Tln+hG2qB7HlY2MXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ojCMpgNtjeV0bHEFno51ZnNk1q9Qnms3Fpy80+mMxLk=;
 b=vM7kwVv9bWWepKAmOhq4qlWISwtK1fF3DpgrD065ui4C7zNBp2d3PGVoC3dQYNO4W5nHSEsdUny+XO168XGhzL28LR5NbMmE8CkeOIIifsNYwPojLjgcpucR7ZO9IzDzQVMaWSklHr2Rvcnm974MCnpQrCqEu7XRt9b2iImKeL/5R4V5Gucmpf7BDfbuI48s4xyyPSvObeaV1a1DunQUJr6yD+MTk/tA72PTYPn+j9Ge3ECCte15GMKMQKZy0TiGR4DOrYM4UG1Ef5Bq5p27SlPKT3LnpP/5/MvTV9MHolgPp5oTHfTlBURJM6sMdM18Q6N4uemzmOkl4SdaxO4zyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ojCMpgNtjeV0bHEFno51ZnNk1q9Qnms3Fpy80+mMxLk=;
 b=rUKTKq5drL5ULG4yRClu+r/Cd9zI8DsMMGIDAv9iwh2LtEs7hR/XBs5oFIZo3gizoU6R5GEVb/j7YXh9Nvf1da2SvyThR3SLDxnjDmUoTsEBWXgYUovAhBjwXHMQnrQCA/dPMB3CBvvv7glteH/B8jwJ3KYQf8Xdn+zDSc+q+nc=
Received: from DS7PR10MB5327.namprd10.prod.outlook.com (2603:10b6:5:3b1::15)
 by MW5PR10MB5689.namprd10.prod.outlook.com (2603:10b6:303:19a::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8398.25; Wed, 5 Feb
 2025 03:08:28 +0000
Received: from DS7PR10MB5327.namprd10.prod.outlook.com
 ([fe80::43e7:5b82:9069:b402]) by DS7PR10MB5327.namprd10.prod.outlook.com
 ([fe80::43e7:5b82:9069:b402%7]) with mapi id 15.20.8398.021; Wed, 5 Feb 2025
 03:08:28 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: xfs-stable@lists.linux.dev
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 CANDIDATE 18/24] xfs: update the file system geometry after recoverying superblock buffers
Date: Tue,  4 Feb 2025 19:07:26 -0800
Message-Id: <20250205030732.29546-19-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20250205030732.29546-1-catherine.hoang@oracle.com>
References: <20250205030732.29546-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0024.namprd03.prod.outlook.com
 (2603:10b6:a03:33a::29) To DS7PR10MB5327.namprd10.prod.outlook.com
 (2603:10b6:5:3b1::15)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR10MB5327:EE_|MW5PR10MB5689:EE_
X-MS-Office365-Filtering-Correlation-Id: 1fef0ef5-312a-42f5-1ca9-08dd45925d0f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|10070799003|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?DO9cIbhCNMaF/k7nJ+lvV8dMv1iovRmGxKmNIPJwIJ1cT/yEa7I21jUc1sBR?=
 =?us-ascii?Q?H61XD2MTk6usXneO0s1PKGjmsx5KEq2Q6GcMqMfLiVToLTcNwvdYYuWzYsoq?=
 =?us-ascii?Q?hUQuX8LP74xC/jPvcROmwA+H82hMVxyDK5lwj5a1m+ZVHqNjZCV6jjlPqCiI?=
 =?us-ascii?Q?X0AirA2KAsFJk8fl24wB1jI8EZhvP/s+z5FkFHkXpLA/uAXE1FbBZzQ4TKjj?=
 =?us-ascii?Q?itzHOAgCGFFIMIoR8RIZrOpYxFX8gDPGOY6lWPFyTbdcenzwDII8rqc09f/D?=
 =?us-ascii?Q?3wiQMLOtHKO01h3KFW55rgyX1Kc/j5jvyTGg6kZ7Y7Bma0p7Rjd3Qkbv6CmD?=
 =?us-ascii?Q?pHpapXZ93dJoWPpRyRd5lckjrub/6uzrv7HSNlXsqnhKnM4Rce3BGs9xl1MJ?=
 =?us-ascii?Q?Dehl12ZT0tlE6nLM6GniZ4Jsvp8x6M/KMWOEny53QfZUSXB1+dWEJ7uWrsKT?=
 =?us-ascii?Q?8jURM6leEglZiZT5kdpZa/Txx3GyLOFRSFq2ayAbzUDTNg+YqjqTlct+BK0i?=
 =?us-ascii?Q?NzEij6u7yh3UX9DBcBpizxh7ncYETMQEflr1RWUYAoANXvnGwJDNGP5C4i1X?=
 =?us-ascii?Q?MtWGoqGLc4vv4AFvPUNSkcsZGIaAUJwUia2d0CrNNF0uw9eht0aDn7XV9nux?=
 =?us-ascii?Q?lNkm8iU7I/noZe2LgY3lRizJ/4H1SHotWUxV4f4RRMHIjGM3VURv3+aIlYc9?=
 =?us-ascii?Q?sPKH7kn7eOuIIRFW0cpo0IIMVjXV3pCu5sJXS6Z9fjh5j80wjMS+FA9fwJ6U?=
 =?us-ascii?Q?wEEt8vPXcbw36UhfXV+ApX8mKP98QPV3FTkf3ORdIrPfkx6Atfbne0BcfXBR?=
 =?us-ascii?Q?x1I7zhwOeSJuxLFelNQ600kpZIY8LPTdry2eXo1iXNZEwW0YY5a/+BWWBWZ5?=
 =?us-ascii?Q?A8QjpvRoBdIBh1FeXVo8LD0JdWqmqMlFK1LCO4LK2izz9hcG2fSzqzSlFx5V?=
 =?us-ascii?Q?WZG6QmDZmYv7hHH7ODBqvr3fTPTa0F88np6+3EhbXijP4GKSzsp2PxTvI0L+?=
 =?us-ascii?Q?ftAayLmhY+6mFTacuFmelEtDKbPjZKNH89yE6gEo/drKqfeUL+AWSn7SifVt?=
 =?us-ascii?Q?m22fnOsav2dHq7L0V16TnLgo6qwpRIqTUh3KjphqSrl6RWlEEAOwQA2fDCZM?=
 =?us-ascii?Q?eTaJtThfczAUdEVlcUPoi0kb8SnW8NmsAjacQoT3OZX14cj+//eul2IwNAwp?=
 =?us-ascii?Q?fa966mk+yOPE6SnRV4GuOTxwtLGsRIkUjrPLCwwCEQcPtjn86YY6UbAPQlfR?=
 =?us-ascii?Q?utJq497eit/ZUJ4LnJnI+Jwb0WuyhcPBzcqUDHGpynZ/1+cGe35ChMYvFh2s?=
 =?us-ascii?Q?C+CWQp7G/7dRJasdY4gqqqBq/LtYCGTRVx/BnqWV/9kh4TOX9To+DGfCahmu?=
 =?us-ascii?Q?DlyW5s3V1xdwHAQzGf+JJkSip3/J?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR10MB5327.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(10070799003)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?S2+rhOQalGHNwFJc3CTxkR/ID2DoQOdQ6XpDio00r9o0eL5hZNij1o4SpM22?=
 =?us-ascii?Q?KQ7uopqokaTyzjevncKa7rQCQeOD30NIFgPc3tH+RkS2ti8oR75dVzyRx6wF?=
 =?us-ascii?Q?//BcwCV2pHaFs9xz4TNfM25mWAgfR1udc3GvxNNdh4jje/iHit7nMa0jI1wx?=
 =?us-ascii?Q?XigbkFDOKeBToNv2vKY+VxS7XGmY2Q7oBe2BSGaf2dh3RSJrqxn+FifNQFzE?=
 =?us-ascii?Q?FhUI8NF5N4mEOmftz1cb6UEHIdb21XuNvh24MP5PzyJmGYj0OPKoTa8453j1?=
 =?us-ascii?Q?v7GSt4K+8b+h2hvGCRMV2ukUeB6BA20qCat7MMBoIgBlV8O0Uz8TRGNnqRV0?=
 =?us-ascii?Q?YFABK6+Ok42jbcB27QmaZYZajz4F3EOKJ716R442F0wDppEjEw0oEm9GnJiX?=
 =?us-ascii?Q?qNDBfsTvDVhuO8yetx5IR+q19vdhNhWUlMXagFZEig/O5DEoc4fMea/VXECq?=
 =?us-ascii?Q?ORNyjwGJ57tGGnF20MX8rttet27UybKh80HBGxGQINkFcuIQ+Mg12BXZihYk?=
 =?us-ascii?Q?OIohrhuAdms/JkZctF7ok3AP5ZJcvXj1ATNs8KDCTJl/KJDR6FJB2A0KIxdF?=
 =?us-ascii?Q?idrpT1rMY7QgpxQmzgSQyAjjyifWKaX4abmej0AX1GKq497GbMDRit6gVGaL?=
 =?us-ascii?Q?vYf3BIIw6eHeKeMcjZU9LttMH+x3BYsv3nMvKM2EyHF8aYOlupwLOE8pWw6R?=
 =?us-ascii?Q?RnvXUPMmy+W+x5xrv5pLdKFieIIiMxDojAJGFHM4Z1DrU4N27zbjQPQzpzAj?=
 =?us-ascii?Q?bFKlQIbXs72e+LZol8CuxzNft3cOzbPoyRDN4jCVxBt43eUB2PkZ1DsgMZds?=
 =?us-ascii?Q?BPm3FMF+DfPf8gpr11lltWMqxBr6xx2ITjqGXpdvv0xon2BLkHwYm8vsnh2h?=
 =?us-ascii?Q?4Yl4s8hkgRuzDdicK3Zqtgy6/037BROxBqwOIZHd9tTRMQQE8XBQRQiNH3Sp?=
 =?us-ascii?Q?OLhOmFCBRPvyfL7WWX+892rEcDgy5mdOS/PYoBEIOLsARBA4Ku7q0tEwhOtY?=
 =?us-ascii?Q?bMvcfLy6KrQt5k0/+sfqDX/3wBjp+xuwNKMVLo0dvqGpbHdTk5vYfMy5GK6d?=
 =?us-ascii?Q?gLUIv2XtsnByKVGkV2Vuky/Ufi8LaDGpz3RlCTn9xF+QObqhvcppTyqeGtk6?=
 =?us-ascii?Q?9mZm927nN+nRzwrBLPxz8PcSCkBheG9tbt6M5xi/kL6mmCun/vYwz8AgxOz3?=
 =?us-ascii?Q?qn2eRFQwJuduHM16Ec7G4225xUGiglKVy/1UlJ2dDX9rWxurSofeUV0Y06Fo?=
 =?us-ascii?Q?7eUCzErB5z03BUfl4eg2Mf64x8THlPq7N9JN5k5mJ9T+TrRM/1DDSBmyYYYV?=
 =?us-ascii?Q?FBlluye2lvoVaGGx2mIHocKaBU3DZWiwUdaw8z4bGdId1f2NznQ8WlZTQNHU?=
 =?us-ascii?Q?rvNXRYdFPho/1JDKeuSroKwKyyMTIzXReiavE8/Bu5PKoO4p0ve0N3Am3VUz?=
 =?us-ascii?Q?oA3G80GY0xcxkPB97kSMMCIrZSPyY9KwHwehCjwtoOxxgrZUt2m3FpG3EHU0?=
 =?us-ascii?Q?i+PPQo0OQVBFMmGuXoK0zarSOaON6/Q0zcccLZV8EofrzgMv4Nclm/ODuVIP?=
 =?us-ascii?Q?ow0DhuJE/LO5CEKiwvWQh4up0EewfcZf5MHn4N9yQcgzwLmzZEc0dsAcpD59?=
 =?us-ascii?Q?SjaKlkrWReyVJjfcVmK7XSPHehFmO/wk8vU2y2TnccuCl/dt0SXtiSUpllgV?=
 =?us-ascii?Q?SsPpyw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	S4+0XkZ+ApaDbiMPotqzTZrmoexJaqG3CF2fk/Nb9FHTMQ1m4ntDci70nlziY7YA4sTz1CgT8TK975DH0rPcc68vPmgp+A6gBbSxnBFlUuzQ8Dz5Dxkp6yzigkQwi7A5v9c2DyjgxRwWVXhqKwX9NUKhVgGlhq16DUzOaVPHy/pbwMF6GIOyexgyVJHFWkGaWifCdW0oWh3Cj6fYYnIaC6g5vU45zyB4v30m3cbUaAP3FMM14jmCX0sbDmnGck7grgRMdxmiJfvKfL+zHht7Rf56ekarq/mMNYyY02sKCqFwZCB8DJ0MuJZMtkH41+/1vZm2GkucROHUHCJHY5LMN+omfyMrberOz/kJyrvOLGGkZK3Q+IXx5WryZ+8aumWbnNZ0DNX4EQOV3AsMueDbGQnWUsEMHh/HlGR7ZEFqIFxSGivPH4vcQY8ua70Ebqm4LI89WpyPIlQnsEgO30PDH83D91o/T24kdqCz4AWu6YHuqD+O2ZHDKbIVrEkGy1JpZBE3xKj4GPy/NGHdTNQa5sbMoCGW+ZJ3/t6FQwcNsEeD4SHZX8hTUpRLsLRHfBo5UosByHDEJ7dIgRnu3OUj8yJ8vT3k/KVwlKRaCmoqFtw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1fef0ef5-312a-42f5-1ca9-08dd45925d0f
X-MS-Exchange-CrossTenant-AuthSource: DS7PR10MB5327.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2025 03:08:28.6696
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aatT3b4kG7/9251MsGWiaXDTfZhroxDbg/yncApBevuLOSCPSyA/P+k2ryOBe55qi73wrXr8gGCy3y1/GAXlTebQIRcH5JU0+bH1/hHsJ4E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR10MB5689
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-05_01,2025-02-04_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 phishscore=0
 suspectscore=0 adultscore=0 bulkscore=0 mlxlogscore=999 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2501170000
 definitions=main-2502050020
X-Proofpoint-GUID: rnmjWDLHeqs_FksCDIaGFh5Y-O-eTCQB
X-Proofpoint-ORIG-GUID: rnmjWDLHeqs_FksCDIaGFh5Y-O-eTCQB

From: Christoph Hellwig <hch@lst.de>

commit 6a18765b54e2e52aebcdb84c3b4f4d1f7cb2c0ca upstream.

Primary superblock buffers that change the file system geometry after a
growfs operation can affect the operation of later CIL checkpoints that
make use of the newly added space and allocation groups.

Apply the changes to the in-memory structures as part of recovery pass 2,
to ensure recovery works fine for such cases.

In the future we should apply the logic to other updates such as features
bits as well.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 fs/xfs/xfs_buf_item_recover.c | 52 +++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_log_recover.c      |  8 ------
 2 files changed, 52 insertions(+), 8 deletions(-)

diff --git a/fs/xfs/xfs_buf_item_recover.c b/fs/xfs/xfs_buf_item_recover.c
index 43167f543afc..b9fd22891052 100644
--- a/fs/xfs/xfs_buf_item_recover.c
+++ b/fs/xfs/xfs_buf_item_recover.c
@@ -22,6 +22,9 @@
 #include "xfs_inode.h"
 #include "xfs_dir2.h"
 #include "xfs_quota.h"
+#include "xfs_alloc.h"
+#include "xfs_ag.h"
+#include "xfs_sb.h"
 
 /*
  * This is the number of entries in the l_buf_cancel_table used during
@@ -684,6 +687,49 @@ xlog_recover_do_inode_buffer(
 	return 0;
 }
 
+/*
+ * Update the in-memory superblock and perag structures from the primary SB
+ * buffer.
+ *
+ * This is required because transactions running after growfs may require the
+ * updated values to be set in a previous fully commit transaction.
+ */
+static int
+xlog_recover_do_primary_sb_buffer(
+	struct xfs_mount		*mp,
+	struct xlog_recover_item	*item,
+	struct xfs_buf			*bp,
+	struct xfs_buf_log_format	*buf_f,
+	xfs_lsn_t			current_lsn)
+{
+	struct xfs_dsb			*dsb = bp->b_addr;
+	xfs_agnumber_t			orig_agcount = mp->m_sb.sb_agcount;
+	int				error;
+
+	xlog_recover_do_reg_buffer(mp, item, bp, buf_f, current_lsn);
+
+	/*
+	 * Update the in-core super block from the freshly recovered on-disk one.
+	 */
+	xfs_sb_from_disk(&mp->m_sb, dsb);
+
+	/*
+	 * Initialize the new perags, and also update various block and inode
+	 * allocator setting based off the number of AGs or total blocks.
+	 * Because of the latter this also needs to happen if the agcount did
+	 * not change.
+	 */
+	error = xfs_initialize_perag(mp, orig_agcount,
+			mp->m_sb.sb_agcount, mp->m_sb.sb_dblocks,
+			&mp->m_maxagi);
+	if (error) {
+		xfs_warn(mp, "Failed recovery per-ag init: %d", error);
+		return error;
+	}
+	mp->m_alloc_set_aside = xfs_alloc_set_aside(mp);
+	return 0;
+}
+
 /*
  * V5 filesystems know the age of the buffer on disk being recovered. We can
  * have newer objects on disk than we are replaying, and so for these cases we
@@ -967,6 +1013,12 @@ xlog_recover_buf_commit_pass2(
 		dirty = xlog_recover_do_dquot_buffer(mp, log, item, bp, buf_f);
 		if (!dirty)
 			goto out_release;
+	} else if ((xfs_blft_from_flags(buf_f) & XFS_BLFT_SB_BUF) &&
+			xfs_buf_daddr(bp) == 0) {
+		error = xlog_recover_do_primary_sb_buffer(mp, item, bp, buf_f,
+				current_lsn);
+		if (error)
+			goto out_release;
 	} else {
 		xlog_recover_do_reg_buffer(mp, item, bp, buf_f, current_lsn);
 	}
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 79fdd4c91c44..60382eb49961 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -3317,7 +3317,6 @@ xlog_do_recover(
 	struct xfs_mount	*mp = log->l_mp;
 	struct xfs_buf		*bp = mp->m_sb_bp;
 	struct xfs_sb		*sbp = &mp->m_sb;
-	xfs_agnumber_t		orig_agcount = sbp->sb_agcount;
 	int			error;
 
 	trace_xfs_log_recover(log, head_blk, tail_blk);
@@ -3366,13 +3365,6 @@ xlog_do_recover(
 	/* re-initialise in-core superblock and geometry structures */
 	mp->m_features |= xfs_sb_version_to_features(sbp);
 	xfs_reinit_percpu_counters(mp);
-	error = xfs_initialize_perag(mp, orig_agcount, sbp->sb_agcount,
-			sbp->sb_dblocks, &mp->m_maxagi);
-	if (error) {
-		xfs_warn(mp, "Failed post-recovery per-ag init: %d", error);
-		return error;
-	}
-	mp->m_alloc_set_aside = xfs_alloc_set_aside(mp);
 
 	/* Normal transactions can now occur */
 	clear_bit(XLOG_ACTIVE_RECOVERY, &log->l_opstate);
-- 
2.39.3

