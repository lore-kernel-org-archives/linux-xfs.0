Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2985176ABA;
	Wed, 18 Dec 2024 19:17:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734549472; cv=fail; b=n/dwu2HflAyo1boihhISTuGopSmEVXNMjBhVsmP92V091+7vhU0vGk0gr/a5xcJYzw1g0zqqTSDw8nCsgFyq6myoWd4IY3Z0DLh3Cqk18wkzKLNAO87DTNcQKFlt1B22WnpRhl+DsJ/9JMg+zcyqqmGkzGBqpDRgTOMhggDnPLg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734549472; c=relaxed/simple;
	bh=z79gwDdl79XyfZmcxtIpL06ReuSOA86MmkGJzqo+NS4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=RnlKYRcVpwbDfPcj6L81EfgUM8ypFSqeJBJmq36tCWG9XvLsei/rxLU033IXymsFh5MzM4i5gXri2HIbPS3u1yCOhgkStPRpxS1M9aj4JW80ecVIDqGA431j3P5WepqeQZ1UFxVKBvo4x19ndLPWKv7sQf5PckvoWnwV/SewTfQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=PQ5L1+bD; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=LUKUcHD/; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="PQ5L1+bD";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="LUKUcHD/"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4BIHQesO018530;
	Wed, 18 Dec 2024 19:17:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=od+Bv4JAYxk08jiyfJ4BnzaM82qz7UqpWN8cV+pErqg=; b=
	PQ5L1+bDFN2jZSnG6GREgZya9iGtoQhOFwOHjiNOEDpvBTp0z624VE0WqfarYLfi
	zhgLPG+PFxcv/TxJAWZJ6vbAVvuUB6Gr4oxFKS6vGVrvdrVJOEOrAqYSDxajTOmw
	hYl9i1JCZZrTWeOIZbKANE2H0/cVJBNn8wYd2xa4m5BBtXIKagvF/BFRXobZqLMK
	f3qC/AbIMuVCjNtStENZKp8Q3VCyj5Vuc2khaCqYnGJUmxEbbcg7nAoLhQxWxv4m
	s7ePFLO+V4V/3Biom6ghvFKXYM3KP4ikT4m/XqV4akIifismCraClODuSGKf78jt
	4l0pYs0HQHEQJj56v3zI4A==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 43h0m09jfr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 18 Dec 2024 19:17:49 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4BIHdTBK006497;
	Wed, 18 Dec 2024 19:17:49 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2041.outbound.protection.outlook.com [104.47.58.41])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 43h0fb4m98-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 18 Dec 2024 19:17:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bSxBHxjjn23+dwaYpERJ6UQ1qCbTzY+rEpn/bCiUNI+HzxGbb7tEGFvgSuMuV1Sf8WcdIjARsJU6INkX63e/9qFTrJUGIGXqdr+CxuUcwawUwch1dlHC9k3LCrFmVkgULQsxGLzXS2ITqSVYt01FfAxJ7ENrD2gI0XbfsnZluduW/iQiN2BWwXjr6cZpQQw1gJvSaChzkyukxa1mXgU/zHMVQdHcv/vW2aHOar6LYqiXSllR3ez1tFoRD+B3RemYeFAIKMzSIllmPxWGgQzE2NLfp/JFj5ywM4BZTQFazxvM0avDbhfueZpJAB90Ws49Q653qeCXzyECGZgCbz8Ycg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=od+Bv4JAYxk08jiyfJ4BnzaM82qz7UqpWN8cV+pErqg=;
 b=O7aIFn3avNPtmnHQkR+D0gLbbFbVNoXAOF/JfbCLtpLY/gW/3lskUzSd7tRfVl5e0WNLrr4WvIon92n/aWybo1JaKkJZXPcOsYMYo8kSHnJFZ1oCIjZRLSn8iIWlg2zg2JaUDkZ9sQt6ldWMRBvWEII5+im/no2bAv4IfeHbOauaqEKJr5qtzjn6JXgscUS4tvT9vwoMEs54ifkjFDNc5yZwSycKHG97hvQp6AMqoy1E8JfyD+nPDbz9k+Fxy/RNcksr3ZezAX1dMhmf71L5Aau+lKdSeARw8hoY3FRwdFeVzTIavpfxNbiH9AePx9Jz+b0r2wUZu2p66Poq8OG1xg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=od+Bv4JAYxk08jiyfJ4BnzaM82qz7UqpWN8cV+pErqg=;
 b=LUKUcHD/Z22jBcW0F1k0y/5vIIC6NsAoKQAwmV4rt+MCHJl8rupisbm8C6JwxoR/wf/OObcJvdXspPp9Mir7dKfn85IjxXg5qbdW/H3ZiIxN/4XWPGa/nH0MCpKc8QNLppdyuZZS/drrZ2B6cuzdRfKTQd4W0S6p/a62nkZdLfY=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by CYYPR10MB7673.namprd10.prod.outlook.com (2603:10b6:930:cb::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8272.12; Wed, 18 Dec
 2024 19:17:47 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142%6]) with mapi id 15.20.8272.013; Wed, 18 Dec 2024
 19:17:46 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 11/17] xfs: remove unused parameter in macro XFS_DQUOT_LOGRES
Date: Wed, 18 Dec 2024 11:17:19 -0800
Message-Id: <20241218191725.63098-12-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20241218191725.63098-1-catherine.hoang@oracle.com>
References: <20241218191725.63098-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR05CA0015.namprd05.prod.outlook.com
 (2603:10b6:a03:c0::28) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|CYYPR10MB7673:EE_
X-MS-Office365-Filtering-Correlation-Id: 3e6a73e7-9d59-4b8a-ba31-08dd1f98a7d4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|10070799003;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?O2XBnT43CdoZDvRPFzSCDA2WKXnxVpf/PCKravcFhPJ7fEffSFtt1maWRrOZ?=
 =?us-ascii?Q?Nd0ReG3qX8Bl7Qgmif4VvYYl6XyxiwOx3bHQ5lU8SvezSm6z8yoLXPvMVzkW?=
 =?us-ascii?Q?4ghSF5/Tew6paPtpxoKihgEDrkaeCo/fa+L/yu3rSwYCSxZfhFiUtUAPh6yU?=
 =?us-ascii?Q?JOT1777AUlyy3Xnw/d+PP0JAiGUYq+pAxfvFZujLz/AcIFqybQ/h3xkRelWI?=
 =?us-ascii?Q?2FUOM7RwWFjxDEMhb9na2kFr0XRTVSuDtRPtIsaBb0iBC5vZfewFQ98ZSn40?=
 =?us-ascii?Q?+4z+j0UzVR8O3ptvjIPdrJmfwQrbSGd60eH9Hd+pIJyY5GW/UA9IXk6O8CAU?=
 =?us-ascii?Q?3eUoJDB/EUfBU5ANtCVIfUNh/YysWUupaPY4u1DzCuN9cqW3CJg7+n17vwLw?=
 =?us-ascii?Q?oYnaJSFhtWKAQxlPIhR4ZHPEIQH45E9V5beFj/ytTHpXJWawoaIJIUI5FnBA?=
 =?us-ascii?Q?JzyEj7R0PMVLqAAzTfPW8ViKbKg1jcMSmyKQLegZ9dCqTnf/V0isw/0cBzI/?=
 =?us-ascii?Q?JeWdPLpIXiHPElw5CMZO+AgQpAkxvn5pcASYblOoDHOWP+ARUSIVRDWdQV9q?=
 =?us-ascii?Q?Ok1qmLVMnrKY23hyTyOCcCrlpO42gpoetEdacGaQKIaLrX6CbLI+TMz1ozem?=
 =?us-ascii?Q?HG+lSzJ1k+O0lOCkIstlevNgq2c/C+KdAxXrfnYt5v2tn+zJrfFIuY7iqO/J?=
 =?us-ascii?Q?49x4WFdwVcyCOD6J1+zJ0k8EJ3zaSzwiEt8UvnuHMBH+BzGL147qqvNkfoMU?=
 =?us-ascii?Q?tjQLg4hEhfnYr9b/ppQZFkpItm4LRUfkf+9JVqQogjH2SJhXo2Yf6KnXp9EK?=
 =?us-ascii?Q?QCzh3eSz6ORXxYPPQhAvXooSTHejDsRtblFbiyErNw0dGiFjc3fyHElee3uc?=
 =?us-ascii?Q?BmOfqMdCdUEpgCeveID2DWLhz9dninKJUsSlwbVqs5zn1L0v0WadwA6A/aDo?=
 =?us-ascii?Q?XYph60HumVLrw2kWiQtmTcMblyeWjYhEyMz4utIgGTNHUCZADWjUsFgE5o2Q?=
 =?us-ascii?Q?4vEmAG9ajgaKEPil5sA2+Q2a3NTUsBPPJmVrs4yKfl5ugPjwFuEBJTCPjaic?=
 =?us-ascii?Q?RGsw7a17sNbYMirMcq4rXZu8e+vncZsd7Mv5VEd5wIOv9wd6U1j3XUsIdWIT?=
 =?us-ascii?Q?AeAB3hhwsZzWDRH73S2Cm07/o4r3d8mD2eacGhpvTOMUkeiioFg8n+up+pMP?=
 =?us-ascii?Q?I2fji/KI9+5CTplJOiXCY/51+bmM+ueWFildX1+n4x5ODrLFiKDDCB00d4E2?=
 =?us-ascii?Q?SheZq5NEdmKMenSXXM/3dcqxqkooqQ0sbGnwRxt6NsGMuCPgQoJdDHrE4c9N?=
 =?us-ascii?Q?n8uhQmZrFpDQ8qisICSgtsS/v4KyyMoR6SNgzpACvHEo1Iru560CTB/uj0iL?=
 =?us-ascii?Q?93tpdjIDb59PuC1K0N6leb4E8qJB?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(10070799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Bmsi7FkUEtU+3QbBuvZU+OSfAsxQcK/6OVEwX0zY5CsotgkccXbemiGAVCAx?=
 =?us-ascii?Q?s0VLmnj5GAVaAnCwMFHC9FIkQjPfQkm5edsgHpzmISXhJm3NDoGs+BmK2+8K?=
 =?us-ascii?Q?7Y4p/nlrr5fZmLGBibIdInw4c6Z1U/eev33I3XQsGm0Lnpy6whyMOcTA4lFK?=
 =?us-ascii?Q?+8WwAikBx5Aid1vFhpEjUThkN2YEdsnNeHx+jKuTpheaiuUtMzyqyZems2KY?=
 =?us-ascii?Q?QQ8LfMvEeRv/66PsFv1h2+4+gCIp+yAoSLJWshAsE10Jv7zdho7stC7V2nOA?=
 =?us-ascii?Q?7h6lILQnc/tGdsgdXQx2HiLoU0D+P1TOJkns1hS1yEP+eGoRuUP7yppG1TzM?=
 =?us-ascii?Q?48VqW1jvU/wLfAG2aOJY+9RkdzeNVi/ugrg6EM5wuWytKdGjG3BsD3nhhMaC?=
 =?us-ascii?Q?hD8RfAaPLjBeApjeauhG8es75C63sIPu+f4BXDRAhD99sGfgEjZukrNXLp7t?=
 =?us-ascii?Q?N5JSp/TBmLOPEcTvBuMliumgIN1DOMbohPEsuHMhAfmhmGVjYCrWET8gAD08?=
 =?us-ascii?Q?bZ8BNO+RVfNXLWy7bw2/oEkwhNY7A4to9hL3+GqYpxv1jpmCbrT2LVYpx/Cf?=
 =?us-ascii?Q?E2hjJ2cpkL0PV/eiMsNuobyO7unm3ytN0RLfN22dbUTNyoqC5V46glBG60Dn?=
 =?us-ascii?Q?gTQaVvH3RK6yoj/disd4fUtj7nnQdbgAQ0WZVUePrufU0UcBaqgDh/bJVvzU?=
 =?us-ascii?Q?nhNYeVkjOEv5D+P+CYcaFe8zmOI9FCPFrIv+i6qAdEr8BOmMs43dyBc8JWOO?=
 =?us-ascii?Q?hxLkZx/BbsFqmEXv6UjYrKy+VyPv7EN0mf7yjTaI0dBLLzwJal/9Ps4ugA/E?=
 =?us-ascii?Q?kFncP0/LWFt/3GAqc6LhlS6fb7x1qhfras41XWPjvHYuKj/Fpor/z+/52Ouf?=
 =?us-ascii?Q?4jv+IRYNL3PvPhMoiO7eB8dsLiC8RysQ4bThtKoWeo1OlDI++wKgepfvD1KV?=
 =?us-ascii?Q?TE3mDjl2WYMZuq62xmFcrcExX/YvjU8s51qlALYiAW8eyenKbEJrZinK7EKS?=
 =?us-ascii?Q?8z8gajlVRPXmkYOQHZGy6gf25Oz7BKl0csF/jYdssXHpAW0TISg/MGw/oFh7?=
 =?us-ascii?Q?jt7hf2AfNkDSy/x897xSo89OtOQV19PrdMoBZCHwgkGtXuVaXMOe6nKQqr+Z?=
 =?us-ascii?Q?2E532BsMaRkr381W3uiiAYP1gLZ7V+feSBwQXWXEJeegGWeKGEOroZTftfJX?=
 =?us-ascii?Q?NWtm9qFma2aakY2rONCjZrKu6lpQR2sk2U1w8Eu7mswU3pydpI14+yOU7IDI?=
 =?us-ascii?Q?5Unmyis7ccz9lilQ4ZYmCzDl+fVbKBBVYpYsATS2LDwhr0fMkC5VH5+8tZ3w?=
 =?us-ascii?Q?IgBOzsXmHZq4f8/w1czx3yOfGR22OP2QKpC4D/8hMHauNZ6ChuP0tbyUO34P?=
 =?us-ascii?Q?X0nIpJumZrmFlKkdOkOL2pQEFUB5Hik7+UVF7nAC6AjXlDFEod1UGcJhQugW?=
 =?us-ascii?Q?h98/0ecZ/P83RHnBRRVpS8vq6n/UVcVKKCD7wuBdOYN8rXiJHGQkjfr8lPb+?=
 =?us-ascii?Q?y9urBChcXflWnBb3DsUigxCnWxb3iHgYXByeNfltSfBvHVr0F0eKStv5flXl?=
 =?us-ascii?Q?SFN+bwDmYRryuozkEgGhIuZQ16T/Xt71sS3bBecGcSaz48maFHUhbXCG6eUF?=
 =?us-ascii?Q?FOLU5IsaFmCdCd7K0JGVwSCwx0M5+NuhvyunaOs/458a0N91zjI4rcQu6Ovo?=
 =?us-ascii?Q?qNfbTg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	wIkk/2AidMOT+i/VuFIH6VMZALOYWFLOzx31O/NZhVa4FpBq+XhN3iTEwGjsly7AKvTyTvnjzf3e0YNeMjiaiHV5SDdDR7uicpnlxnxWFhmFG6VYOLWRAfaI7SMDfN4Gn3WQn1q7FT1eyepbziu2ufm0QVM7K6jmZTyG/pHiNXl0qOd1NsuvMrOG2UAxB9tIfUBwWlE9egCQaykKFw9EIl13d/mGaTJ6COnPCr1PannQTpj1G009oC2dhOSrL0MVpqwPG1fQ0LmVr07jD1ijO9678l6qJYidvzlw/tTuHPDU9ZpTD7Kjq8+jbLnJ4t+vGYgPppVlWvD3xPKSjf/amPjmpga86LWUGMNyX5sEfe99jNh2sWcNpWQAi1RaV5X1SSuKC4lZnQQ8QwWSwVQrunELO42OIEI74ywVgC+TYNdcnggAJGCMGjVAtfVL8g3OKkb1t4t+0t3MutWIO8MdxIYtoEFsB5QsijyA0UphsXHuCaZk+YEY62hoOWK/3JDnIGBDzrP/l9i10LVLnXH+hvun68WxvEYLKoz6t7dhu0XQFyMkrCYHva5ISI9qmgHe0CEdLaTzabR/sjEFcoDC0ic40Gya2zrY723lrrwIadE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e6a73e7-9d59-4b8a-ba31-08dd1f98a7d4
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Dec 2024 19:17:46.8944
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6hQsvZSfu8v1QuxNhPShO2GVr3u+52Ei+C2vwZB0Kz84dUxYmDZasNiyPu/ahJ+ni0fmhOUPjQ7tppHopxP+njq1+u9b7Wxfw68m/c6rtNI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR10MB7673
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2024-12-18_06,2024-12-18_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 malwarescore=0 bulkscore=0 spamscore=0 mlxlogscore=999 suspectscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2411120000 definitions=main-2412180149
X-Proofpoint-GUID: Zp4E74no0cLm3KhW15aP5BaflTVA_Zao
X-Proofpoint-ORIG-GUID: Zp4E74no0cLm3KhW15aP5BaflTVA_Zao

From: Julian Sun <sunjunchao2870@gmail.com>

commit af5d92f2fad818663da2ce073b6fe15b9d56ffdc upstream.

In the macro definition of XFS_DQUOT_LOGRES, a parameter is accepted,
but it is not used. Hence, it should be removed.

This patch has only passed compilation test, but it should be fine.

Signed-off-by: Julian Sun <sunjunchao2870@gmail.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_quota_defs.h |  2 +-
 fs/xfs/libxfs/xfs_trans_resv.c | 28 ++++++++++++++--------------
 2 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_quota_defs.h b/fs/xfs/libxfs/xfs_quota_defs.h
index cb035da3f990..fb05f44f6c75 100644
--- a/fs/xfs/libxfs/xfs_quota_defs.h
+++ b/fs/xfs/libxfs/xfs_quota_defs.h
@@ -56,7 +56,7 @@ typedef uint8_t		xfs_dqtype_t;
  * And, of course, we also need to take into account the dquot log format item
  * used to describe each dquot.
  */
-#define XFS_DQUOT_LOGRES(mp)	\
+#define XFS_DQUOT_LOGRES	\
 	((sizeof(struct xfs_dq_logformat) + sizeof(struct xfs_disk_dquot)) * 6)
 
 #define XFS_IS_QUOTA_ON(mp)		((mp)->m_qflags & XFS_ALL_QUOTA_ACCT)
diff --git a/fs/xfs/libxfs/xfs_trans_resv.c b/fs/xfs/libxfs/xfs_trans_resv.c
index 5b2f27cbdb80..1bb2891b26ff 100644
--- a/fs/xfs/libxfs/xfs_trans_resv.c
+++ b/fs/xfs/libxfs/xfs_trans_resv.c
@@ -334,11 +334,11 @@ xfs_calc_write_reservation(
 					blksz);
 		t1 += adj;
 		t3 += adj;
-		return XFS_DQUOT_LOGRES(mp) + max3(t1, t2, t3);
+		return XFS_DQUOT_LOGRES + max3(t1, t2, t3);
 	}
 
 	t4 = xfs_calc_refcountbt_reservation(mp, 1);
-	return XFS_DQUOT_LOGRES(mp) + max(t4, max3(t1, t2, t3));
+	return XFS_DQUOT_LOGRES + max(t4, max3(t1, t2, t3));
 }
 
 unsigned int
@@ -406,11 +406,11 @@ xfs_calc_itruncate_reservation(
 					xfs_refcountbt_block_count(mp, 4),
 					blksz);
 
-		return XFS_DQUOT_LOGRES(mp) + max3(t1, t2, t3);
+		return XFS_DQUOT_LOGRES + max3(t1, t2, t3);
 	}
 
 	t4 = xfs_calc_refcountbt_reservation(mp, 2);
-	return XFS_DQUOT_LOGRES(mp) + max(t4, max3(t1, t2, t3));
+	return XFS_DQUOT_LOGRES + max(t4, max3(t1, t2, t3));
 }
 
 unsigned int
@@ -436,7 +436,7 @@ STATIC uint
 xfs_calc_rename_reservation(
 	struct xfs_mount	*mp)
 {
-	return XFS_DQUOT_LOGRES(mp) +
+	return XFS_DQUOT_LOGRES +
 		max((xfs_calc_inode_res(mp, 5) +
 		     xfs_calc_buf_res(2 * XFS_DIROP_LOG_COUNT(mp),
 				      XFS_FSB_TO_B(mp, 1))),
@@ -475,7 +475,7 @@ STATIC uint
 xfs_calc_link_reservation(
 	struct xfs_mount	*mp)
 {
-	return XFS_DQUOT_LOGRES(mp) +
+	return XFS_DQUOT_LOGRES +
 		xfs_calc_iunlink_remove_reservation(mp) +
 		max((xfs_calc_inode_res(mp, 2) +
 		     xfs_calc_buf_res(XFS_DIROP_LOG_COUNT(mp),
@@ -513,7 +513,7 @@ STATIC uint
 xfs_calc_remove_reservation(
 	struct xfs_mount	*mp)
 {
-	return XFS_DQUOT_LOGRES(mp) +
+	return XFS_DQUOT_LOGRES +
 		xfs_calc_iunlink_add_reservation(mp) +
 		max((xfs_calc_inode_res(mp, 2) +
 		     xfs_calc_buf_res(XFS_DIROP_LOG_COUNT(mp),
@@ -572,7 +572,7 @@ xfs_calc_icreate_resv_alloc(
 STATIC uint
 xfs_calc_icreate_reservation(xfs_mount_t *mp)
 {
-	return XFS_DQUOT_LOGRES(mp) +
+	return XFS_DQUOT_LOGRES +
 		max(xfs_calc_icreate_resv_alloc(mp),
 		    xfs_calc_create_resv_modify(mp));
 }
@@ -581,7 +581,7 @@ STATIC uint
 xfs_calc_create_tmpfile_reservation(
 	struct xfs_mount        *mp)
 {
-	uint	res = XFS_DQUOT_LOGRES(mp);
+	uint	res = XFS_DQUOT_LOGRES;
 
 	res += xfs_calc_icreate_resv_alloc(mp);
 	return res + xfs_calc_iunlink_add_reservation(mp);
@@ -630,7 +630,7 @@ STATIC uint
 xfs_calc_ifree_reservation(
 	struct xfs_mount	*mp)
 {
-	return XFS_DQUOT_LOGRES(mp) +
+	return XFS_DQUOT_LOGRES +
 		xfs_calc_inode_res(mp, 1) +
 		xfs_calc_buf_res(3, mp->m_sb.sb_sectsize) +
 		xfs_calc_iunlink_remove_reservation(mp) +
@@ -647,7 +647,7 @@ STATIC uint
 xfs_calc_ichange_reservation(
 	struct xfs_mount	*mp)
 {
-	return XFS_DQUOT_LOGRES(mp) +
+	return XFS_DQUOT_LOGRES +
 		xfs_calc_inode_res(mp, 1) +
 		xfs_calc_buf_res(1, mp->m_sb.sb_sectsize);
 
@@ -756,7 +756,7 @@ STATIC uint
 xfs_calc_addafork_reservation(
 	struct xfs_mount	*mp)
 {
-	return XFS_DQUOT_LOGRES(mp) +
+	return XFS_DQUOT_LOGRES +
 		xfs_calc_inode_res(mp, 1) +
 		xfs_calc_buf_res(2, mp->m_sb.sb_sectsize) +
 		xfs_calc_buf_res(1, mp->m_dir_geo->blksize) +
@@ -804,7 +804,7 @@ STATIC uint
 xfs_calc_attrsetm_reservation(
 	struct xfs_mount	*mp)
 {
-	return XFS_DQUOT_LOGRES(mp) +
+	return XFS_DQUOT_LOGRES +
 		xfs_calc_inode_res(mp, 1) +
 		xfs_calc_buf_res(1, mp->m_sb.sb_sectsize) +
 		xfs_calc_buf_res(XFS_DA_NODE_MAXDEPTH, XFS_FSB_TO_B(mp, 1));
@@ -844,7 +844,7 @@ STATIC uint
 xfs_calc_attrrm_reservation(
 	struct xfs_mount	*mp)
 {
-	return XFS_DQUOT_LOGRES(mp) +
+	return XFS_DQUOT_LOGRES +
 		max((xfs_calc_inode_res(mp, 1) +
 		     xfs_calc_buf_res(XFS_DA_NODE_MAXDEPTH,
 				      XFS_FSB_TO_B(mp, 1)) +
-- 
2.39.3

