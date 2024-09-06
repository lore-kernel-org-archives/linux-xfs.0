Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D35A158D7B
	for <linux-xfs@vger.kernel.org>; Fri,  6 Sep 2024 21:11:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725657114; cv=fail; b=TZXHFZIN6iG6LdSAf6XHtE3UMFdpNiggih6tGDneERcXoL0wSnvpfWIMXZcHBwLST3cpP12Hqe8oNH3Tc5EWDfECFsuoKvBPNVawJWyU2DZct0CYDEjWu5+aDNCqTAyd32wiBhZAF4nTsvsjRZVsSiltj5S6dHMY9e2DwJJ6WZQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725657114; c=relaxed/simple;
	bh=txLAS/N9lLdbjqXdES6+b0GzWGRw9hrIiRePUb2ahN0=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=U8HJFQFjhxZNWtlRRKi3or8yIQfww2dOSMgCGfJoxK+p+HaN+U6V1cZvNrnWkgXQvSE++Ru+sQmS6ygcb+pUSpJdN+skHpwIXP8TztW6vgy7qm5E93ieG/7gwBBBr5lwclwg9/0RpMjc4GbwnObhMyGSfj5PKTrDo8ogYC/NhIo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=QRHl4H7x; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=DoSuX5Ub; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="QRHl4H7x";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="DoSuX5Ub"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 486KXUGX015014
	for <linux-xfs@vger.kernel.org>; Fri, 6 Sep 2024 21:11:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:subject:date:message-id:in-reply-to:references
	:content-transfer-encoding:content-type:mime-version; s=
	corp-2023-11-20; bh=4Ne7nV7gGlq0QWx2ARdbtveP7rOCPWkZ36WayjiV1Nk=; b=
	QRHl4H7xSxRx3FfJH1N54xP6lm9mbfVow/h3H13ZqNxOYGevkLxeUUWIaWkfKzJY
	Pu2xjb1UyuH+TixsnYmIH/Ku0LcN0w0mQ29GBw3X0j6Whfy7wZoP36TJq1h4i8vi
	u+FRs6/LnoJSj9r5fyzYJCby8mnsFpzmrsBGWiG8chQvEIQQB2iXe3RJq2228faJ
	wha/hmDUJfJS1a2LeT10GxbAbup9gRkH5qME19ZUJKUjIwP3Hri2sb7GiYojMwKE
	FNUphMZ+ITapGvDJgy7u75/oBM3ttwqSc6aUur7D2PFKakIms1jLS04RIWM7EFc9
	V59p+nVzCsDDtJHGLTczsw==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 41fhwjjmxn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Fri, 06 Sep 2024 21:11:52 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 486JO5K7016327
	for <linux-xfs@vger.kernel.org>; Fri, 6 Sep 2024 21:11:51 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2100.outbound.protection.outlook.com [104.47.58.100])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 41fhyjeyt7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Fri, 06 Sep 2024 21:11:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RDR2FokH/2nuuNrFuzGV3+UBAVKrNHIav/BVPs+uoUONLD1MrU26jaye9S11rVn5zC3rn/zcKpBvJoRZvCCUqJfDswIS34uZB4CeWR9+hr9YLNbVb4ZGRDUWH9xRmzL3jytSCQTaha7RSNrkuEg5wIIuRuzD3rjDIH/2g1JXnglNBrSHlzWRoVO0++la0hhX+d3JlaNodOfMCLnex+NB2osiBxCIX58YEtFmnDY7fjZC4JTI4Vv14CgEQZeCXIRkbINTMi6+DgEUdPGfqOLIuIPq6q6NjOOA++qOruJc4MCun3GfY3+52FNPRiZqJQ89X9pinMBpvYfEHKh5U73f7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4Ne7nV7gGlq0QWx2ARdbtveP7rOCPWkZ36WayjiV1Nk=;
 b=J4Pc8+i231hgqyGu2y4oc/Vg/Q14DohYUsYFs+C4uWMCgA1s3pYDmdbUcD9Y2ckJZcTkqZHBzJZNPTBkZfv24Ia4HmuJPzJE5rigyUNHRKgKkZca1To1PZuqU+FANDnqF64UNPBB1XduLxQWbxkN28g1V5oBDHt4tGhvupPPxzq3kZLNba4LaTDnO0xCImJiG5Ax4jcBoCDDxZv/J5CMNqNq7Gg5HWjQ1aEYtU72c7VGX3gqf00Jut3TKKTuvrz0pBkXljX/0TB+jrfEyWlCqQ8MLEGKeidUZh72015D2c6g6sYwyV0za8LRFPnr1DOVsS8jJPh/OIkvvnUN2bcnwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4Ne7nV7gGlq0QWx2ARdbtveP7rOCPWkZ36WayjiV1Nk=;
 b=DoSuX5Ubn0Wzly05Gc4ab4pJodZRJSPSwUcBQoTYtSgo9EEnXDPUPAcXV7J9jpdmwLRtnnHJjUeoKresKj2S1D9q50AvXu26VF/z+epjrrvdr9mJSn1FKXyykZ46gWvw3yHGHTJFiqS8Bn3BhnwGemiC1CJpZ5t9MTZqrvFe34E=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by DM4PR10MB6765.namprd10.prod.outlook.com (2603:10b6:8:10f::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7962.9; Fri, 6 Sep
 2024 21:11:49 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142%4]) with mapi id 15.20.7939.010; Fri, 6 Sep 2024
 21:11:49 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 CANDIDATE 03/22] xfs: fix log recovery buffer allocation for the legacy h_size fixup
Date: Fri,  6 Sep 2024 14:11:17 -0700
Message-Id: <20240906211136.70391-4-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20240906211136.70391-1-catherine.hoang@oracle.com>
References: <20240906211136.70391-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0127.namprd05.prod.outlook.com
 (2603:10b6:a03:33d::12) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|DM4PR10MB6765:EE_
X-MS-Office365-Filtering-Correlation-Id: 88cdda18-1ccc-4f82-bf02-08dcceb885b3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?76gF/sw2aVvzRKNnPx+pHE2HZk4ai9eFrnYnmRcKJPFFDm7ihsV8B4wiLOnN?=
 =?us-ascii?Q?6MiQ1bORdl1ctPHVp6QF/OApfQwnhj7UFEzeENk+338WX5ncHLRpIUzcjoSz?=
 =?us-ascii?Q?gd2IRNPZMM+fRUFlx1NGFATQCVRvl7pvKe11vZ1G3Q44V3SY23ixYkfzHJGb?=
 =?us-ascii?Q?v09PEeVql8L6Z5yTOWaFN4CPIHMMcIUT54Zi10Wz4YvHmtRGFsKSIA5t9NNI?=
 =?us-ascii?Q?09YbtxPAp2Vo2WdRtthbqxHb/xAuCpYMI6KudtqrJ7uqAUpKntA/tkNz1New?=
 =?us-ascii?Q?WDpznDWq2znuQuOY3AqHVlatc0IzsYizaJ94klbq+f1JhpD7Xn/JjiEfSM2d?=
 =?us-ascii?Q?oj08v3pf+wFb4+o9srdkrtaCApURPz931THnHgQyEtEElTXCb2CFsO+N5CM5?=
 =?us-ascii?Q?2eFp8p0Dvi2LO904pqHlsZ5m50BtiXrytWiKMjr8w9T5ByV3s/XDANbqYimJ?=
 =?us-ascii?Q?0/hR+qNV6C4ya6da3iqwAzU6zSaJPc2TuQOrF4WuwA4klVtQ8HHJMT5/s6lA?=
 =?us-ascii?Q?ZFmeNiQ2244Gk5g6FwhA+PsBtUfRaW4bhIHkK2osdUx749KVp6/HLXRVdabA?=
 =?us-ascii?Q?v/L3AIcfoG8k1GXODCyoSey//XHFIBlGSh0vwxupHscjE/W5X84J7oSmQuq5?=
 =?us-ascii?Q?nTtnKHHE10sqAWCc850GL543kj2pcoWZkRFOvpXPhZlgP3vTkT/4MGdwNzZn?=
 =?us-ascii?Q?PhsuXBPfDeqG4T4nQvYhUV2ik648cb+QuwJ0j2qy7aLW++mbxWVwBLPVnbeM?=
 =?us-ascii?Q?LHrqflKOLrkRchg75vXvPbmT2/hFI7KmvUX0iT34V6EIKKy7nctpmC4ZTuMr?=
 =?us-ascii?Q?Z6vObsuyZSHatI32GV5JYVqJG9BI1ShfKFJwS6bzdqmGtRCw9kax5WHqlTGY?=
 =?us-ascii?Q?KOs0BXgc8IJqDKoz55EMLnw0SQ011nlX5/Uet7eAj4XXvVhDMhc9VSZG3tfh?=
 =?us-ascii?Q?1FVFWTBO65hlnZJ4x78RYSZeiRY3XkOTzkrgbhleaMHlHMPAHGE+aLWgl78E?=
 =?us-ascii?Q?A3+jnWM9PW1B40svjZHZHXLYpyj2pTGTu1IdGlZzwjPSp1SgoDzowANMLJFu?=
 =?us-ascii?Q?uBimJkp+INLtbnbIrPm+gwgu1dLiymhNkYYRt22KbZX0EqBAwiLDDosXSC39?=
 =?us-ascii?Q?kw87nVAQsOZXmClXegm6mZ2N80jz4wMyGT59r6D3FfJHBs8oRGOxBO7LFuRv?=
 =?us-ascii?Q?pb0JHxyUhRbuTK7Q4fJIbvbU5eU9a1lfZJwfosUtpbE9swgKr352NorydeDG?=
 =?us-ascii?Q?06P81bCImKvHGE5BqXTWHLA1nZs6s0asxJ0zhacaUmHl04A5nFRHELczYfok?=
 =?us-ascii?Q?6vB65jjPxSBpoQikjOzZK12UfkysJ1lruqXtTdnLU6SJFA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Lf5Hu9+HNIBXGwMTmrZW153QMoQf7+z1cypLspCZqVCNnL4kzYKoLILTrVgV?=
 =?us-ascii?Q?6d6hFyttvutsjQn1ILwLuua7W5ocVMSHtCivH9xEI2l/SV1ivfQ0V9Awzg2J?=
 =?us-ascii?Q?tvcGLD6/FeEeBAKnvofOEjIgzWYi0Zok7FWjlZS6rprLVWjaQK5Hfkeda2hO?=
 =?us-ascii?Q?RZDN5j6elrY+DXk8bv1yWbugT52dGc80UITbrC4NT3NV75P74sE7u1zzjQdq?=
 =?us-ascii?Q?qtlhnb/jzR8Xu3jh7BsP8d95vIt+bXdl7SQo1G0FRogYZiC87PcTApJ4wFjM?=
 =?us-ascii?Q?D1Cpf9lxHkFp6ISrP9slTuzWpNqwa7NoO8Y0HaAxlwsHLGRXrzhRqfiYeYTk?=
 =?us-ascii?Q?SIH72kwmkKDiFd9ayZWsUC+0NnXrVLOjF3OxQyi2HJxGy5SDfnBjgYFtUEpk?=
 =?us-ascii?Q?3tMEeXLyDyYZm87oMKVwVDZ8CJh1Zx7dZhR25gvs2DtEgmoNfuug1cVIdrPB?=
 =?us-ascii?Q?ccC7zU1sSCAdsIot7Unp4sy4OLtk0913lSNWq3lQb9e/WS94zwWJ8auFJdxc?=
 =?us-ascii?Q?Zdaw+vn3/KGn5BRSHPk2WB28qYIlJUb6XlKWR+U9a8foHcXPAHjzWeIR6t6r?=
 =?us-ascii?Q?GMvDsTTTiUygTc0j+X0gwfOfxCY81Cs6EQKF2BJfFWIav7k64nnXMUnv7CeJ?=
 =?us-ascii?Q?o2RG6h/rGuZnBiaRIK5Jdy54tEIAyTlKYyvafc2Nw6Nsf3dl9XiRH/gp1sF/?=
 =?us-ascii?Q?i2KsykjHNE+HO+IiZc4sFY4ZHunIW/0DBiGAFovVg5j4IeoRVtyBfav0ZrCp?=
 =?us-ascii?Q?nVLRGY9lt3B/xkanvBBBOQ2XXmhGTGxlo0yMg72ABTRXiRoP+HH79DRvxsCg?=
 =?us-ascii?Q?4Bd2xKlrssbjZqG8ezFtD/VS/J553deOWMQPUTeeRvbw0+w9u/1WnzLH2Mdn?=
 =?us-ascii?Q?+omwwNJ0OJbztpeZ8LT6uy/f+gNs6ZBy6ofZ/1Ox5XZtr5V/jZHJWdmR3Hg8?=
 =?us-ascii?Q?1ygMibsgWjhfQwOOPuHGI7DvaLS+Bb67Y7lhOleMmdyy5LPRuE12a1cIyIJL?=
 =?us-ascii?Q?9YUbmSjWfKKKD4MmLZ1q3H+jW1cuIDzoSSWq5jtO8WKpsk1Lhp7wlJjD34jp?=
 =?us-ascii?Q?3IdBii379QlHz0LpcjA/4zX765BVEY+01tI/2pr1I5xsfXcdMZEZnZERpws5?=
 =?us-ascii?Q?2rR260O4fZJbubhRSSeZon3IrVK7tbZTWhUuYoL8YJR6/evLFg8nMcY9fy51?=
 =?us-ascii?Q?ncX5JOVQ93q3iS2hQ+pyONu5xoJBTMB0ftMUfjtPvuPxYEpmMpJdwiu32zl7?=
 =?us-ascii?Q?Ot9c8diownYCN1kRysXBPtbZFPqi9sGcqJ31OZ+jZulJG2nGPJnh7WBSr6m2?=
 =?us-ascii?Q?1bu+Nv0llMrMtl1AuN8BjMI1UnG/zvBLGfRueg3jghCo8SYQev6ezafZe9jH?=
 =?us-ascii?Q?CLOkUgoJID89NZcqvxdPwFx8ikT3TumfOJ81FblzgUTI6EJjwVZAk5r/PHY5?=
 =?us-ascii?Q?xEOCkYbucCNPLXo9ycd0BXbZLDLsI0mSSo1DQV0BEmTYJrIGHA4864FEWJr6?=
 =?us-ascii?Q?dVpscpqbSEWIlEGTmH/t9L0aaA6IPNC9O8yAYC6wccqP7B1a/1Rec5RfqloF?=
 =?us-ascii?Q?GSS4JEdRX+z1YoIHzQMCBGa2rlqddAdacs2IBTypWGm2UyRBxTBJvmZuedfg?=
 =?us-ascii?Q?aQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	VAW3cBKQey03yT0aAE65ZVW1aDh72OrHjzkPOAySc1NHCJfpIipTnByoC9G18ZhdAEef66BvB6/pgk33je/EQ1y9Zwtb8a3e83p5/0fN1e7OsZbgheh0GlwDxSANOUi1wWOWrSar/4QBkDn3/58ZDXjxYUGebttee5Po8KaNAAt/rWnbgPnx/WsuECoF0DUeGyGtfLhYNwWNtdPJBqQ1GFXRrEcP72gxjj3oXw9V6BkkmkaZ/8JrINQglByWQql3sy6ALF+FfYbnq9uVY9owV/p587vAMFWadaPxKS7AWEpwkscFtUg7dtIVf2ZSkrOTY2d1jSp7U+4XTXTlZ/BSa1sOZIMp/du4PyONB9uyDfQnMaywZ/d4bS2oSqZN7FjPLovGdacQRn9bVtYBfSo/LEbbTLwv2Y8CJsuWCBiMW9yicwhrKUrJX4dEIy2A6sod/5jcg0v/LATiYdMeETC0YdpgP3Atlx3dhZWT9jvbp+UoN00AS/T+8ufk2eXKwbFTFkS7KK0gDguNipUMAwIWoCEVd2Sm84bqQAbFdFyBod6YaEUOgWT27NJ+gTBcfwPXVn3X1EmH04y5uohUNL1TMu9SuxG4GJezpv1LGHRmfjo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 88cdda18-1ccc-4f82-bf02-08dcceb885b3
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Sep 2024 21:11:49.2904
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dUR/R7C1VVnWwlyb8uPBHM6N5MHqBINvb7aN6uM0S0OPfkQqq/C/P2LiDDko0T+57lbVNj4yipFkAQPryNjRVCNRvGjNl93LN3ycVFmQR2s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6765
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-06_06,2024-09-06_01,2024-09-02_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0
 suspectscore=0 spamscore=0 adultscore=0 mlxlogscore=999 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2408220000 definitions=main-2409060157
X-Proofpoint-ORIG-GUID: iwkXGLQztVkhgH2dfb-Ut1cnSPy1nW_e
X-Proofpoint-GUID: iwkXGLQztVkhgH2dfb-Ut1cnSPy1nW_e

From: Christoph Hellwig <hch@lst.de>

commit 45cf976008ddef4a9c9a30310c9b4fb2a9a6602a upstream.

[backport: resolve conflict due to kmem_free->kvfree conversion]

Commit a70f9fe52daa ("xfs: detect and handle invalid iclog size set by
mkfs") added a fixup for incorrect h_size values used for the initial
umount record in old xfsprogs versions.  Later commit 0c771b99d6c9
("xfs: clean up calculation of LR header blocks") cleaned up the log
reover buffer calculation, but stoped using the fixed up h_size value
to size the log recovery buffer, which can lead to an out of bounds
access when the incorrect h_size does not come from the old mkfs
tool, but a fuzzer.

Fix this by open coding xlog_logrec_hblks and taking the fixed h_size
into account for this calculation.

Fixes: 0c771b99d6c9 ("xfs: clean up calculation of LR header blocks")
Reported-by: Sam Sun <samsun1006219@gmail.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 fs/xfs/xfs_log_recover.c | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 57f366c3d355..9f9d3abad2cf 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2965,7 +2965,7 @@ xlog_do_recovery_pass(
 	int			error = 0, h_size, h_len;
 	int			error2 = 0;
 	int			bblks, split_bblks;
-	int			hblks, split_hblks, wrapped_hblks;
+	int			hblks = 1, split_hblks, wrapped_hblks;
 	int			i;
 	struct hlist_head	rhash[XLOG_RHASH_SIZE];
 	LIST_HEAD		(buffer_list);
@@ -3021,14 +3021,22 @@ xlog_do_recovery_pass(
 		if (error)
 			goto bread_err1;
 
-		hblks = xlog_logrec_hblks(log, rhead);
-		if (hblks != 1) {
-			kmem_free(hbp);
-			hbp = xlog_alloc_buffer(log, hblks);
+		/*
+		 * This open codes xlog_logrec_hblks so that we can reuse the
+		 * fixed up h_size value calculated above.  Without that we'd
+		 * still allocate the buffer based on the incorrect on-disk
+		 * size.
+		 */
+		if (h_size > XLOG_HEADER_CYCLE_SIZE &&
+		    (rhead->h_version & cpu_to_be32(XLOG_VERSION_2))) {
+			hblks = DIV_ROUND_UP(h_size, XLOG_HEADER_CYCLE_SIZE);
+			if (hblks > 1) {
+				kmem_free(hbp);
+				hbp = xlog_alloc_buffer(log, hblks);
+			}
 		}
 	} else {
 		ASSERT(log->l_sectBBsize == 1);
-		hblks = 1;
 		hbp = xlog_alloc_buffer(log, 1);
 		h_size = XLOG_BIG_RECORD_BSIZE;
 	}
-- 
2.39.3

