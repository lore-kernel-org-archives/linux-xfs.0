Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 719341D173F
	for <linux-xfs@vger.kernel.org>; Wed,  2 Oct 2024 17:41:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727890912; cv=fail; b=Z7jd6W8FL0bDSWaNKIoQEfL/lRng1hCZCWMxxudY34DhgMoHYUkGOQBuNB4i+SLyLjPM783YgCe36QuXvihkBwtJzuPS3qFbu/VMN2GTuKIk/k4P77/iq3CFAPYxDsmC2MgaTh7zBaG60M7/GwqSAaYfnMrF3joy9T4iuXlrJy4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727890912; c=relaxed/simple;
	bh=9R5gDYGRkD3zuEAj6D/OwgIiAtThfu1pQPpc/dE4v6w=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=pSWkGKmQC1uGgiQg585lTjO/JlfBbgqSvvHOjr1vJiQLBgRMmZcEvSrgSwTwQXN25zMt8K26ZerVA3NVyHJISs5C5BsabYuZLcJmR0B0ROm04sh7dFTcIAWwhZhPLN1nHoV55NA8YMDE5412KIvMOTLjZjnc4dnt4qLqwo3x2c0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=n784ZDFK; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=n4sYcpex; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="n784ZDFK";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="n4sYcpex"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 492HfZSO025427
	for <linux-xfs@vger.kernel.org>; Wed, 2 Oct 2024 17:41:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:subject:date:message-id:in-reply-to:references
	:content-transfer-encoding:content-type:mime-version; s=
	corp-2023-11-20; bh=ryNP2/BUEI5XGaNMf5mCh93xxASKGerHyr9sWS/BFKk=; b=
	n784ZDFKvg8DRfzcsdfhmrRKTJOD6B13RApJ5vHAw1l6Gn//2ukGyRm2L4da73+3
	nhNaa024POSDukHk9t5Udw+TvooAeV/wILH5M3ZZ2vmC47oA/8bbCB+R7d+EW9qv
	PoL6xfB9zVcDusZmQpGYgTBcOZV6IcEcx5/H2bTpL5hJPwa8u1NYVliSv+u1XLgY
	zf3yosXa61n9xkAcuO6FR/LKyZlxISiSNrbrPLRvvcKCfJQ/Dv4U5H6Qwwb9JyRV
	ERixpl7TU9G8sepdOTvH2HS9crWrS/a2JO8e9+AnS3FcXPMro3GSw3oAr6/0xQzQ
	OHrMKvGHW2JyUs4y6cWsMQ==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 41x9dt2cdg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Wed, 02 Oct 2024 17:41:49 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 492Gj0Ax012532
	for <linux-xfs@vger.kernel.org>; Wed, 2 Oct 2024 17:41:48 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2040.outbound.protection.outlook.com [104.47.73.40])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 41x888xgju-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Wed, 02 Oct 2024 17:41:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lNgDTvTMY8qcZNncPLox4hPs1FsHSIUGNp5sdqZ95XHQmureEyorfkd+HsRX+Dy/9rnFmYYuwxXPcjue203nUcD5FvCtrx9XCWrwwsHG5waygNLhQVefjU96TGK58u62EztGXEvmzKO1DIBdrXarMN04FNIiawW1/BxXMvwTnyTE7dnFCeHHLMM1puUEnkJ43dD9TlksRmgpODGKbsmR420y49TftzYayKuKZlbjU7QT2Zj9LxVWxl3jsk8hVaDhwe9MEdsUOMc9CIchMcDCvJaQ5GjEouwpdvaCX9/SwnbXzvA3mJ2NuYG43ra5Xc0ycTZiAQEx1aJeJQTU5IF/Kg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ryNP2/BUEI5XGaNMf5mCh93xxASKGerHyr9sWS/BFKk=;
 b=HDfK7AlRs1INcrdkJuufu2Y9JGJAw1CL8TGaT8AoYfm2X82jodrNx6BgqygAjAj9H92AVd63HjcKUsGdGEuVxYwBNHkZqMvtz5lInneFC53hYEiO/t++YUoLVc5PZGFRxc3X6YCpnJGfcvfWYbKSWdtbXFXh3ZCBOIcpXRPSyMi7NxgCvs8ukZSxBlangqslccSok5rpGf4Cxf0PMLWpyhMWh4duvIsvSwjBdM+wNuuobiFBvS6kwkpLLCe1zVki3aThz6kNRGhod5kCpJRBwfRZoL3Za0ET/q3pD8sqVjWl1W0VNaiQCHNG55gU+WzFxt/jcLDln/bUkGqldKuGIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ryNP2/BUEI5XGaNMf5mCh93xxASKGerHyr9sWS/BFKk=;
 b=n4sYcpex1nWDn3miB9pdmjKHCI3brlFMr+9mtgJ8D1aoH/pKtbN250xtlJgOtj+opi6yxK+MMNB/p4w3NKyUHpk7fyugzFIVv4L0+IA1ODLJw1uwlBkZ4+1b4FmWyC5uQqhkwevS4yw3N4naQ9ufjcHwQTADMrEXHpmKaS+FS2A=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by BLAPR10MB4995.namprd10.prod.outlook.com (2603:10b6:208:333::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8026.16; Wed, 2 Oct
 2024 17:41:46 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142%4]) with mapi id 15.20.8026.016; Wed, 2 Oct 2024
 17:41:46 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 CANDIDATE v2 19/21] xfs: fix freeing speculative preallocations for preallocated files
Date: Wed,  2 Oct 2024 10:41:06 -0700
Message-Id: <20241002174108.64615-20-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20241002174108.64615-1-catherine.hoang@oracle.com>
References: <20241002174108.64615-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR17CA0061.namprd17.prod.outlook.com
 (2603:10b6:a03:167::38) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|BLAPR10MB4995:EE_
X-MS-Office365-Filtering-Correlation-Id: cb3745a2-41db-4339-9a10-08dce3097c9c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|10070799003|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?A/WRo8QG2YmiV8U6uJXyihKRATXh4ULauHWMF6cXRUbFj+7kDwl53FMR+qb8?=
 =?us-ascii?Q?CEwVpkaCzU2NvPRyd7OlrJcBYWB3KL92lveCovEa4EMlcxdqtMlqb4mzz7fQ?=
 =?us-ascii?Q?MwfQ74tdD2ZUzBjhHEdMnQFm0j6hkO1dBPbQto8V7K/7Cq3k167JMWB2hnh1?=
 =?us-ascii?Q?6htscLvG3oyT5PW6jQFjeOEFH2y0SBdyUGV6OIuOOk7+m4NLwMCLJ+Z36KaL?=
 =?us-ascii?Q?ZOB0wb0gWCNGQBqKvLGfazHguypi2XZcsLGpFinkdM53zdjeU1/yw7Xiwnm+?=
 =?us-ascii?Q?cVHZLptA4UFZCe6lzLTtYEN6xwDKYVHwOHgninuive3bhqw/aY9qV/763ghz?=
 =?us-ascii?Q?Xt8AthwmbrzNm6ZSKH6PFU23w3D7P7mnsDYvcl0iKJi/lsjgZ7J4RnLhAvjr?=
 =?us-ascii?Q?3GjZ0q0f6xPclu1e4O6wuZHys4jgLGq2qrFKfg5X1yG84t2PBiJCqci7MAB8?=
 =?us-ascii?Q?d4GhJxCxz6Uo0avbGBBxuT9Om5ZfP+pi0ReoVoblc6xxvzHGZYxTUSMgIuFq?=
 =?us-ascii?Q?Q0x9alPbw3EomPCMYMB6H7X4iJZwok+kh56v+5k8aOmwhCb64ZeaNddIyKGI?=
 =?us-ascii?Q?BeF2kE83l8soukfUQDe2wroodQI/WfCr6vUuC448/WrPlKPCN3a5SC9vJpOo?=
 =?us-ascii?Q?i6HtybyxozDeqYrZQYePsmD2BB6xLyqArMxY2Yxlu+TBamIW+kQMB1n00xTJ?=
 =?us-ascii?Q?xZMAeIOIqYQUa5BVpSNO3WdUXiKHFuAPIt6Ofyak0DcQGglqUKogEUSQV31L?=
 =?us-ascii?Q?a4XNN+O657v21d7pIyIyYGf6YURWDKaZyRJ3O9Gw04ChtdiYihagiWH/bmyn?=
 =?us-ascii?Q?6HPCnCcUgCWzWz7woY9+dS/D8bpSg3e9y8pnn/aBJNY0Rwh5lwTLbY99RfAz?=
 =?us-ascii?Q?t9Bou7boG77DmvBxuuzgyDGJu0yQwqZHRASE594oNnCiuHWx2rcgXUHkiOJW?=
 =?us-ascii?Q?61uxK+bGKRSkAYA1pmSPplpk7lLEhS67sBB/jXhXu4qbknMdCURHjkg/Z6cT?=
 =?us-ascii?Q?bLzvynV++Gnxb3MR6OlfGVbeQJx7JenV3vifY0fwFIlpuoPMKDWg8VSQsFWq?=
 =?us-ascii?Q?HJrrq38o7Dqy2jD5EqD/dy42fsVapjMqd8wIqekBjeDW3B7TSf/Qkagcvsaf?=
 =?us-ascii?Q?5xzOb465RoaBIyfMSGnQulGkQcZWUGBrItOqWcf6PV+oaTbskA6zhF6lDXmr?=
 =?us-ascii?Q?caFH1tdQSfTJPMOONyychw/dYMggpvEuXxsfW89RhxtV1/hAwx9ubISWdVpB?=
 =?us-ascii?Q?xe9sFVPRXzJxDcZBfxIT5cvLjkD2azRmYtzl7p4m3A=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(10070799003)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?XJdgh7i+lallUGYiCJIktMb9/YpM7M3vxLpdGVzvxc8GXfvgqWgrQGhDC1R4?=
 =?us-ascii?Q?2++F0UQ1vjMcybhDXB61p3WIS1ez3N0gAiAmab4PBrX5vKkXJcAhcW9b5cL8?=
 =?us-ascii?Q?oFa0cky9kcAh6UJOogllNlOC5Tbfu6B9VKCJYB5fuvDbPLXLyTwtQZKW/5T9?=
 =?us-ascii?Q?mz0HuOcNpRl6gIMxX7LrQoz+jpU/alwvb3dn6q4h3RDt3V2LS09MphKKE5hH?=
 =?us-ascii?Q?mcm1sM+NnyYn3fnpZbQV0HlR8eV7J4XFCJUpOEjx9HCu7MC0y0VyJPakPXq3?=
 =?us-ascii?Q?hH8JXWpmgMBJYUrfexbTQG99dlp1dIALzanc+ZQCL58ckcyaeea9nW3S0pxU?=
 =?us-ascii?Q?/hvU9YvYvwnRqqSqqgN6qfvPxFA+F4TSd43dGVJVPUKaWZB+CfTCuu/ilwM3?=
 =?us-ascii?Q?G/7y0OMSvNJ0ks+FvnumOykrp6Eza9QNfJcgoiU/iRG9cJ+nQAikHwTbHv4b?=
 =?us-ascii?Q?W6zrniXRRXrkcohPqD5H2HUq0yNxQscI3HfZBDMo+NiQAHu1IQtVhVzjPelL?=
 =?us-ascii?Q?dItmnmOKKmkfnT/YDmpoCZEgMXiI5j4HcUrPOef63utPyUq+pD+2xNItTRS/?=
 =?us-ascii?Q?0+Lo3dS5QUNYgGCCjzSQMcEf9x/4lRnLq+CXrYHI5T7+mPb3nFjK9DvuSxba?=
 =?us-ascii?Q?/RHkE2TNqTN8tL6lrhfZKGiDegfQ1ffcQT9DaRg08f9au5EmTbhy0h6xIyNz?=
 =?us-ascii?Q?kTwZbiWO1m1cJF5oyc1fKUeKViu1YV/owoojvJj9akBlQ2NxV3Dkh3fcGdxC?=
 =?us-ascii?Q?+gLaELAJ1uvNWkuw0VsA0ciEQeqYo12Y1cH6QpoLPTUSdnU+gYckaX6lGC+P?=
 =?us-ascii?Q?/6N0pDFEsdN8Ng8A8wMIxGs33DE1f9jJYpBISrSrV/v01YBUEhwvYpUdzFW7?=
 =?us-ascii?Q?JZdTfYLThzrhkAAp2UPFBZjGlNCUcBLqgzbmAECOsZmHlFl/HgDwPQbEkKPm?=
 =?us-ascii?Q?7rhaCDH9z53Kg6mfT79vJBqRHBag7R6IX0rzZgIk634AlyExezRM6MypIUHa?=
 =?us-ascii?Q?1VqjyltQaFm+X6MoYFt0FQgnzLr8GB/jxsqcEwEjkHjhjigoc+7yUx07Aajh?=
 =?us-ascii?Q?d6jq3JK+T3W3w5Xl8t/LAEL8dt1W/6mPGWwLSfcMP0LaKoLqXjo9jkyXhvFW?=
 =?us-ascii?Q?r85Fpckn5m8KOfEhJhlOcreK8Z3zLsf7S9hyshq0FqhOX3UBd6AU6JdBNi0K?=
 =?us-ascii?Q?sBm0OcicceExB2LjuCU+vPd2t+jlrb+CsFrw5M9IsTuvC7WF3RYi7hfk84Fo?=
 =?us-ascii?Q?wSP+lIWub7kCP3MYerCtwJJCqOzlJ0RQN2/+bnXMxCVLVO/nrf8TbQMA/jiU?=
 =?us-ascii?Q?mKeAAvLUbo7NhSuKMqfLT5J+n4JhncLzb2zxV2k/eM85/MQb4R7i4c8rVUqZ?=
 =?us-ascii?Q?vZWmtHevhsoJem78Xxu3CFTT+jK+UxtkVQtp0E8ueDcq2+lS6QLP/puKtCe1?=
 =?us-ascii?Q?beJVMJD7ntKba6hBhoD8+u9iLWY4WPA1q5UipPuYPkuDl7PFWlIvuD1QiKE6?=
 =?us-ascii?Q?XyturErpbrlR48Yl1ilJKgVjPae4Wf6nXuW8ZMO7xKps3uOnIlkpxsZxbmS1?=
 =?us-ascii?Q?3iCVFC4IJ+7x3lx8dyrKGm1mlrMngjFuFLRiB2cPOSxrHXRzv+dHfvYc3x50?=
 =?us-ascii?Q?CKpnbYBuHucR51YR6Ez2SwzRHc8CLqYRq0+7OvvGFqYjhwlmjfxNs3MEPEok?=
 =?us-ascii?Q?6dRP+g=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	wBIUGG8ixpRCE2CGfh5tQw3Hu/mZPCFteEClHOfwQGaK0qjJuJFpa/IfbCz2nf77jKdGnw5ZtijdiWf7k/QBUQqG1+grBbysQ1D8/bjX6tPZG+ZhTrGeD/KjzPEZWfEAGs2DHY4Qf3nC/hcAV/ZKfz784QewpOdVzc1gGl9p2K1kT+POUU3S/W9MHgvD+MN6VX65992za3DiXS6sjUmzhVXCxhDZeD7Ajn40mDHatGWqTrEPH3Kjf/xZpmTmlMiliJs4rdW8Xz2yKcL/CXdFj89kvOyueHAkhFcJGuEBkO1FoXThvHdEuhcxen2SUCJdX5cfwr4WeW/ko9qHJIx9yy77DjJvk2EDLujH/AhWYXSZafv3/NZM8itThkiXn+qX6OnHzqkSOr6cO6Ex00RRkjXLS3FL8Wjf3LqyFO8pHHKNmCoJ3uwAl8Kx+zd1E5g1h44reeK7HpmOsFxuozkCscktVcal6qk1xUqLtNL+DVTlrWDROr59yU1+DEe30ECZbazx1v4OxmZR7+mE25c53QbD9xXXAL32bWzmDR4VZf0JZNwmT6ZYtYNYYfnu+Rcx5mlxy9NUdHv9cTfCl2i16vqnRn+cd1M8HH+uw20kxYA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cb3745a2-41db-4339-9a10-08dce3097c9c
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Oct 2024 17:41:46.6133
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: M5epKkgRO1FFNSBvBXwS0LnoNlKfDbp5yj63nMuy0uZIyiegP9vo3VOsACISMIcT4HhSspkyLzkA2KiiJ1gkqVOfoWALDjOyojycvC/UlTs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4995
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-02_17,2024-09-30_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 malwarescore=0 mlxscore=0 spamscore=0 suspectscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2408220000 definitions=main-2410020127
X-Proofpoint-GUID: HkrIJaycTa8S3RrAYqB9A1NnV0Ou6f1k
X-Proofpoint-ORIG-GUID: HkrIJaycTa8S3RrAYqB9A1NnV0Ou6f1k

From: Christoph Hellwig <hch@lst.de>

commit 610b29161b0aa9feb59b78dc867553274f17fb01 upstream.

xfs_can_free_eofblocks returns false for files that have persistent
preallocations unless the force flag is passed and there are delayed
blocks.  This means it won't free delalloc reservations for files
with persistent preallocations unless the force flag is set, and it
will also free the persistent preallocations if the force flag is
set and the file happens to have delayed allocations.

Both of these are bad, so do away with the force flag and always free
only post-EOF delayed allocations for files with the XFS_DIFLAG_PREALLOC
or APPEND flags set.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 fs/xfs/xfs_bmap_util.c | 30 ++++++++++++++++++++++--------
 fs/xfs/xfs_bmap_util.h |  2 +-
 fs/xfs/xfs_icache.c    |  2 +-
 fs/xfs/xfs_inode.c     | 14 ++++----------
 4 files changed, 28 insertions(+), 20 deletions(-)

diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 4a7d1a1b67a3..f9d72d8e3c35 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -636,13 +636,11 @@ xfs_bmap_punch_delalloc_range(
 
 /*
  * Test whether it is appropriate to check an inode for and free post EOF
- * blocks. The 'force' parameter determines whether we should also consider
- * regular files that are marked preallocated or append-only.
+ * blocks.
  */
 bool
 xfs_can_free_eofblocks(
-	struct xfs_inode	*ip,
-	bool			force)
+	struct xfs_inode	*ip)
 {
 	struct xfs_bmbt_irec	imap;
 	struct xfs_mount	*mp = ip->i_mount;
@@ -676,11 +674,11 @@ xfs_can_free_eofblocks(
 		return false;
 
 	/*
-	 * Do not free real preallocated or append-only files unless the file
-	 * has delalloc blocks and we are forced to remove them.
+	 * Only free real extents for inodes with persistent preallocations or
+	 * the append-only flag.
 	 */
 	if (ip->i_diflags & (XFS_DIFLAG_PREALLOC | XFS_DIFLAG_APPEND))
-		if (!force || ip->i_delayed_blks == 0)
+		if (ip->i_delayed_blks == 0)
 			return false;
 
 	/*
@@ -734,6 +732,22 @@ xfs_free_eofblocks(
 	/* Wait on dio to ensure i_size has settled. */
 	inode_dio_wait(VFS_I(ip));
 
+	/*
+	 * For preallocated files only free delayed allocations.
+	 *
+	 * Note that this means we also leave speculative preallocations in
+	 * place for preallocated files.
+	 */
+	if (ip->i_diflags & (XFS_DIFLAG_PREALLOC | XFS_DIFLAG_APPEND)) {
+		if (ip->i_delayed_blks) {
+			xfs_bmap_punch_delalloc_range(ip,
+				round_up(XFS_ISIZE(ip), mp->m_sb.sb_blocksize),
+				LLONG_MAX);
+		}
+		xfs_inode_clear_eofblocks_tag(ip);
+		return 0;
+	}
+
 	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate, 0, 0, 0, &tp);
 	if (error) {
 		ASSERT(xfs_is_shutdown(mp));
@@ -1048,7 +1062,7 @@ xfs_prepare_shift(
 	 * Trim eofblocks to avoid shifting uninitialized post-eof preallocation
 	 * into the accessible region of the file.
 	 */
-	if (xfs_can_free_eofblocks(ip, true)) {
+	if (xfs_can_free_eofblocks(ip)) {
 		error = xfs_free_eofblocks(ip);
 		if (error)
 			return error;
diff --git a/fs/xfs/xfs_bmap_util.h b/fs/xfs/xfs_bmap_util.h
index 6888078f5c31..1383019ccdb7 100644
--- a/fs/xfs/xfs_bmap_util.h
+++ b/fs/xfs/xfs_bmap_util.h
@@ -63,7 +63,7 @@ int	xfs_insert_file_space(struct xfs_inode *, xfs_off_t offset,
 				xfs_off_t len);
 
 /* EOF block manipulation functions */
-bool	xfs_can_free_eofblocks(struct xfs_inode *ip, bool force);
+bool	xfs_can_free_eofblocks(struct xfs_inode *ip);
 int	xfs_free_eofblocks(struct xfs_inode *ip);
 
 int	xfs_swap_extents(struct xfs_inode *ip, struct xfs_inode *tip,
diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index db88f41c94c6..57a9f2317525 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -1149,7 +1149,7 @@ xfs_inode_free_eofblocks(
 	}
 	*lockflags |= XFS_IOLOCK_EXCL;
 
-	if (xfs_can_free_eofblocks(ip, false))
+	if (xfs_can_free_eofblocks(ip))
 		return xfs_free_eofblocks(ip);
 
 	/* inode could be preallocated or append-only */
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 8bfde8fce6e2..7aa73855fab6 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1469,7 +1469,7 @@ xfs_release(
 	if (!xfs_ilock_nowait(ip, XFS_IOLOCK_EXCL))
 		return 0;
 
-	if (xfs_can_free_eofblocks(ip, false)) {
+	if (xfs_can_free_eofblocks(ip)) {
 		/*
 		 * Check if the inode is being opened, written and closed
 		 * frequently and we have delayed allocation blocks outstanding
@@ -1685,15 +1685,13 @@ xfs_inode_needs_inactive(
 
 	/*
 	 * This file isn't being freed, so check if there are post-eof blocks
-	 * to free.  @force is true because we are evicting an inode from the
-	 * cache.  Post-eof blocks must be freed, lest we end up with broken
-	 * free space accounting.
+	 * to free.
 	 *
 	 * Note: don't bother with iolock here since lockdep complains about
 	 * acquiring it in reclaim context. We have the only reference to the
 	 * inode at this point anyways.
 	 */
-	return xfs_can_free_eofblocks(ip, true);
+	return xfs_can_free_eofblocks(ip);
 }
 
 /*
@@ -1741,15 +1739,11 @@ xfs_inactive(
 
 	if (VFS_I(ip)->i_nlink != 0) {
 		/*
-		 * force is true because we are evicting an inode from the
-		 * cache. Post-eof blocks must be freed, lest we end up with
-		 * broken free space accounting.
-		 *
 		 * Note: don't bother with iolock here since lockdep complains
 		 * about acquiring it in reclaim context. We have the only
 		 * reference to the inode at this point anyways.
 		 */
-		if (xfs_can_free_eofblocks(ip, true))
+		if (xfs_can_free_eofblocks(ip))
 			error = xfs_free_eofblocks(ip);
 
 		goto out;
-- 
2.39.3

