Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A03FE378823;
	Tue, 13 Oct 2026 08:13:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791879218; cv=fail; b=KycBqSUE1B5YFlZhDJP1UQ/q2YqFvPpSNWZE0ueR05g5xo2CkMbcDQ6wit0N1VqaJnboWX8CdLdqSoWfbC41cvmko5WfXcimgeP8M3CoO4782xP7cXKHS+9wC0+e14XWf6TFEKTaAFSR+1Ups3WBaN4AbyAlrsvXFkZNkDmSRdU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791879218; c=relaxed/simple;
	bh=EZLf5iAL3/bm5+d0WEKpXwSMZGoP/gjk3JPgxbG3Zb4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=NRfm9J42Z9aAFIoyIqyXP7OTkSgChZXusfZhe87knJS2TsQamgfN3xz6+rOXi7ZZOq3qBvyINqLPUj9kF6+9q9CZtudbrPXHbptIbyWQVdqyi3JltyfU9H95LMCRRNGlEwg3HkOyn2woFsNdQLLrDUFAHWkHemFmgrmTYrgmPMc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=g5q01DBW; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=d3tWUTQa; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="g5q01DBW";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="d3tWUTQa"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69D2CoP13435858;
	Tue, 13 Oct 2026 08:13:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=CNOw+JpAMJq4r0RRIJzsCzcuJps3xdxHvWn07qbQvPQ=; b=
	g5q01DBW0MCEvwofH8lWY25FuAGbThsKw3xcoBmDdjrjEQby+wQxQYDEfNkAz62F
	lUVawSOlvSDV45PReGT7G/EHavR6fmdnvMafw4pADbOLuqnqazVhtCJqAAJd0c9k
	LvzhHUoMnXFTuBT9x/iEVA2b7yLinfTm8hxyVSDW+kHuMj8bQp5+tp9+ILjYbQl1
	TAitAk+RahVOLh4H34i3DKfJ9YMc7G+qw9xbS0Yn0Q9LAlxoyxAMF6yQJyw2WnKv
	7Nibi4qSmuki8JoMgzC/B3wz06m/HHL7Z7a2SloaXd8Nb97qXHXjIBRDnyfirdtc
	MWKP4Gv+fVrUY0QYBw5EXw==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4h7de1kjh7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 Oct 2026 08:13:33 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 69D86mha034970;
	Tue, 13 Oct 2026 08:13:32 GMT
Received: from ph7pr06cu001.outbound.protection.outlook.com (mail-westus3azon11010036.outbound.protection.outlook.com [52.101.201.36])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4h7btp7bm5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 13 Oct 2026 08:13:31 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hMPUL6hL8xgfBEduelGzxpVUvW43AcTrp6Yf2pVtpt2HS+Ck5RwYOJNUluSCvfhJji7NVezDRJ39shbXWXebmlWrQNbOzIFMMZ0rMJ0grDpYqjbXA1NXiOsYwpd7g8eLHHRlSX3hjLG97fuvu9THwD3mKX38g0hCJVDylgBdh2EkpymQ1ZzE0L5SProUqkPHXDpeD/4K9oJsvcLl7dutdMWOU+qIH6XH6U8uSR2uWn3pqTs4QDDgSSpt7+6I50itstWHmpo3JNaiyZr9taLE2C4GpdTUy1+/8QhVI0jzuvqI1DgRnYt0g9zgDILcUszoG17CO8HEcBl/66dz5Fx+1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CNOw+JpAMJq4r0RRIJzsCzcuJps3xdxHvWn07qbQvPQ=;
 b=wYSjjivF7q0xmrtvxCmpqEeSM+svOntsgrqluMoE/YYWi643I9s9P04wRJYJ+sfHy1d14tzRtY6HBiyVAnAZBFEzfUA/6SuJSzsDhwjnMi1Aw4k0t6Sd6dtk3OK4zQOmcT9MzxSMH6+ORRKe8u0aD+mgj0m9B6p7oy3aXYWIMaPiz/SnVdqZgIrVo0xAkfnXNSe16Ge8j/volS+6HQ1lrrYkmQLVHMESZwETiX3qJdZtJ6pEgEUms7vydzUm06TyCK6khsdx+mqL46bdLiNWWPLDlfR9CI6GAv3q8DP0MsV+WoCaKOzoHvzpfT0Dbm0NFPsQNIx/r5wHKSljZPJpPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CNOw+JpAMJq4r0RRIJzsCzcuJps3xdxHvWn07qbQvPQ=;
 b=d3tWUTQadnLgW6VBzZGmZqQSDfsV6dec6Ll8yjTZ3j1EOJwAWs1oo5SwYVadoQ7LRUUE9GpsObt4b3nNViasJ8d/1TVESmtuZCSoeNOsvs2PAneeZk9dtpbCJn9n8rCgNNA+iblMxVZONcL3rSJZpDkdzhSerb8I1tGiDEfUCAY=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oracle.com;
Received: from DM4PR10MB7505.namprd10.prod.outlook.com (2603:10b6:8:18a::7) by
 DM6PR10MB4138.namprd10.prod.outlook.com (2603:10b6:5:218::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.522.12; Tue, 13 Oct 2026 08:13:29 +0000
Received: from DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::f14:5389:d117:967c]) by DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::f14:5389:d117:967c%4]) with mapi id 15.21.0522.011; Tue, 13 Oct 2026
 08:13:28 +0000
From: Siddh Raman Pant <siddh.raman.pant@oracle.com>
To: "Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org
Cc: Dave Chinner <dchinner@redhat.com>, linux-kernel@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 v2 1/5] xfs: xfs_ifree_cluster vs xfs_iflush_shutdown_abort deadlock
Date: Tue, 13 Oct 2026 13:43:16 +0530
Message-ID: <38cc6761de24babc5bc43083a234ef023ec41a80.1791877865.git.siddh.raman.pant@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1791877865.git.siddh.raman.pant@oracle.com>
References: <2026-10-01-1-daily-reply-0012-re-xfs-umount-hang-backports@kernel.org> <cover.1791877865.git.siddh.raman.pant@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2P153CA0011.APCP153.PROD.OUTLOOK.COM (2603:1096::21) To
 DM4PR10MB7505.namprd10.prod.outlook.com (2603:10b6:8:18a::7)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB7505:EE_|DM6PR10MB4138:EE_
X-MS-Office365-Filtering-Correlation-Id: 5df9a1e5-85ad-4d1a-dad2-08df2901dcde
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|10070799003|1800799024|366016|56012099006|4143699003|261009223027099003|10067099003|22082099003|18002099003|6133799003|3023799007;
X-Microsoft-Antispam-Message-Info:
	Pk114Fk1GCm7xQmIEf9wCX+r5z1NjWpRxfAumf9ywid7JCdiYEfn/0J1Q2AR3tDyCrVjS/sO9QlhXXiI/OOz7rQ6aK9l3JIzt1gp5v340tV5KSKp4zKjYhSDbUJE1AoVMKQFu/AYGsgQhZWmZjzhjNPa8m7HpuQJvV+R1OwbUhfUc0j1M4v2Gx1wzDt7Gqn5Py5RXS1NH6jLDwrnc/UaqJuJV28nkexguTI9vXy6F9awaGmGgnUPz64xt1CNbgPUpHgYVFHCnt82vqNEqqD0EnmuK5U6LgWFeI64BLZFtcw/FUiqJD9fV08SghbFJjf8fIJK8A8mkzuZANj3sL1K4+5nsxJ13hOJNxgankfwqJMkoBfGLOBYW+7HAPQKEN1MaXx0EkciJKYfIKHDT/Xi1GEm82N+5ArHk6jF6Rg3uESZO9ePnuZI8/stYmTGFLVf8fDn7eXc9IOlySWxyp9tj/5GpI/H+Z/KVVLAh5Q6du++OtNHrwwWxrm8pne6Vknzz1bNqreCtUZYOXUocL6ILXxJ5Sh2mXFN8X9ccvREkbsnPURntnE/0/aARquP9sDio1lz6kApRazbbMg6KHjyvyXANAMI66DNWO/bh5PSWv7Y1rO8UvB7NmVQ4PtLpRBJ425UKDX/qdHUWQafIqnANrz3wUdo+xfnbaUiknDnYDI=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB7505.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(10070799003)(1800799024)(366016)(56012099006)(4143699003)(261009223027099003)(10067099003)(22082099003)(18002099003)(6133799003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ZT5qwCb+X6CfUMoI4DTeP2tocxF2KM9RaCXu6gLIBCIEn6od8s/ihbizM5oj?=
 =?us-ascii?Q?bQewyPJ1pv0B7qgvLHP7sXAYeDOs1fOheG78meEdN+OpxVi3sMKt46zgVvom?=
 =?us-ascii?Q?dMfkK1hzJDzy2uSmdAWMp7IWFBZqgfu/hPu5JTfZEkfb9kFyCqMGyLoqMHCI?=
 =?us-ascii?Q?zEbyKyXsqDYl92dwFTG5alA23pXRq3VL71mvLmpgyz2LAih+hzXSRJE5jJix?=
 =?us-ascii?Q?OjJTUMWuL1V5/ZcR11OAvUUpl7TQgtFF7gQnoG9qnaDoknk75rlcESPPAfdf?=
 =?us-ascii?Q?xa83TnEpxJI4UyErNBggFen2Y7BYxl5OAV8XmtVMnDoRW4fPIt71iEMpTwQb?=
 =?us-ascii?Q?0JsvrLKnQrT4tsLZmqZOMFfvzUIpsJSYubDKkKUVltA00o5LEf40Wwy8pbBd?=
 =?us-ascii?Q?8VRyt/Hqet0sS+CmmwRiKQj/P2beIgtVnKtyNCVdZSt+uSgXwYP0jZGrOK2X?=
 =?us-ascii?Q?qJ/aDscLMgnbm/GqI7z95LyF4pK6fA81YoNGer7LWMpvJZVgXxuRfR/9hK93?=
 =?us-ascii?Q?T17eBi7Vi5+vzVgizf2pnd70I6sIdHoht94bnO6ucFQhe5LMu5CVe12lAE04?=
 =?us-ascii?Q?++s0VxIj/AL8ZtGs81vCSpPMA+o89AYLz9HFtIWrsFJa3PXXHwE+L8m9vKS0?=
 =?us-ascii?Q?xHT6Gi8TAyMTp0pAg9uXOWoZwV9Bpsz/fhGNtF7+Stv5hKKk3D0S1C/SjTwc?=
 =?us-ascii?Q?ukO01bRAjWOe3lIdlNOZoI/RQtWk34hx/xNF7v5WhhQ2lNXfZX+gqfmewaRO?=
 =?us-ascii?Q?CK2oBJv8OgnD9v6LfDZVBOxB8+Y+nEZMxR6m4pYesJIb/4nhO4ZP08P1bWMd?=
 =?us-ascii?Q?1jwrPQ7vg2ElgQD0KGL24j5GEHXb4DBIsO6AKK8K8gt3YOf3DiAUw8+jkXAY?=
 =?us-ascii?Q?Y9W4gQ9OFj2ewRNVKNl+LHrv511A4RrTCSaluRgFz5P/dzHY6Bm7oPRwnlFd?=
 =?us-ascii?Q?elzfftLApmbh45t5fDxFkgZhkZt2MDeh/BfYXwrXU01XgytB6Lc7hhlp5EIF?=
 =?us-ascii?Q?9cCoPRT96hv36XfxVv9xo/iJjLcaAl1M2nvzboofRWbdZODdOJ5Rx9en3v25?=
 =?us-ascii?Q?ElQATcNVKyoWaWW9KM/0yAYI6fc/aeJIlbVR/y+hfVy04vgmaCsjnkNZFsjE?=
 =?us-ascii?Q?Rc/Azee7WovBzY7K5NeAseIvmq8YKkyO8DVXdhICCutNnFnjCHJzYbjzcsHU?=
 =?us-ascii?Q?WdJ0gLXy6/HLPa6OiDlk2GFlDf5hXwsUebyyTrnh8PoHneJ65tchFclwezK4?=
 =?us-ascii?Q?0aaj01LOZSlDG1CZeGkNZiGOmMfwXLWTxsbhhNkczsbnCS9ByTFFYMOcF8S+?=
 =?us-ascii?Q?qSTPnKyDFtfIxYEX7b2dtnfGEGFT5MpRlMUuSy+ghbPKV6kg7M3Wxgpiota3?=
 =?us-ascii?Q?h1bYIGRbHs9FhyyRjrta2FTVhGKgkrCtYMIvCm8yIwO/++2YHac6dcsUKwWe?=
 =?us-ascii?Q?MosaB/y4Z8KpErmRPfHOhYgB1jsU08aNWeWzvnAdHUsKbalWtD8auS8K0jVZ?=
 =?us-ascii?Q?okL6//eypFw3ROx91WscZX2ye05iDUDNYXQQntZyBoTae6YN8S9DEB+daqm7?=
 =?us-ascii?Q?OCJwLlOe2TujJLLSDD2zyknRQhXJcF7tJnLtULjU303BpGRmO/q9uaiexdaZ?=
 =?us-ascii?Q?4O6ABT9SnWw2CKbzZbDGsrku2C3C4uUMhCY4V8ljglRbOspChAhdsBnhb/Ug?=
 =?us-ascii?Q?Qr7g+HeFh3pqV76Tuyza0sykZ8FtAFDLAyv9jjFmV2/w3Umiycohp3gigB9b?=
 =?us-ascii?Q?nLFsg9M2OLKRZObFsKEludU42P5TnDyjtPjbWXd0jJIJSMMx7qhj74LGZ486?=
X-MS-Exchange-AntiSpam-MessageData-1: TT8fWPi78wFMBoB/d/eper9PytK/bFskYmA=
X-Exchange-RoutingPolicyChecked:
	Wu2ry7iYc9DfRCSKzzZOzqdr9GkDixDGIlZq0+DhQuRIak+E0gMxhe8lP3ZgFcyzXy5zbnIGZMjEm12OJVSZMFdxWTbvH2n1e381il602vo2jdh8sdu/yveWy1HxFDflygCIUhIPeEDm8knjXC+4VblvGKwdKV1pfA8lvqj2UJoCHvJquEIq3/d10cRkyONZQaQfGV8y29S1Ou4hq/l8hawl6o+X9r+lBU4fb1mnND62YBr6KqxNpl4BbMm1Mgl5ZX+WzPHBI1T6gk9pbKjK7ViRHmjS+C88HVfgWxqY3Qcg0wPXHaff20Rk8TEkgiUCatdiBqewNeuONSWHX9yGJg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	vb88QSuMNgMb5Xn8eIo1f1m2YkE1DSc4Yq8cqC+xeeXfWiX4YJwcUeppxdVFTS0VKc1tg8CavbcASuB/oTkwiydt3NSNMnRV4NUhsJVEjN29ubVYqqilro9w6i0VZmD7fCAa8SLnXMN6fZCciOVLQdcHpOZhz0WjMY7FhFipTGIqxCZb4wO819dbmaYjpuLBPlPatcI3Tmvgd6u78HRK/Sv/7yv5YObcPmD5F3auEvWWlgShr8iisC797MjRNpN6utCuThCtBTHwjPS/BCVEQrgD8lF3Ug+3J8NMcNZkMmFgzwcbdpPZFSO5buc2KJIpiXkY7RcflOfYSGlc9xNF9F7qfp8avl8kaPJf+rmzHZyRorttlv1/Z+Y4PrJlfE44qSaaadwfRPhXHXSxAAoPFRsXEEapsXUgEBrut38a+3pePxBac1F6mwDGpKlNCUexuboSqqeOwO+f8vOG1JrcGWrLfOB0o9t9qRoguf8oHWOJL47dQRiNnojyRjcggd1GRSC4uDe9OASUMtogIk+zrky4QX/caO+h5salghv0w0talzAtFphL2snBLBG3Cozn1btZge9mJami0nQtqk/thronSmRN17oe7bT5UStLS7Q=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5df9a1e5-85ad-4d1a-dad2-08df2901dcde
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB7505.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2026 08:13:28.8993
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EB3ljs7Pr4L/O+qbBCqzAlFT2V9vFRH5uICMaYWzOHH1lsVTX3PHgXPeEdVbOcqftnjp/KBvqmNg2OVxlh73Q0rHkaGFNwwDqjOp9toxgMk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4138
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-13_01,2026-10-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
 spamscore=0 adultscore=0 bulkscore=0 malwarescore=0 mlxscore=0
 lowpriorityscore=0 suspectscore=0 mlxlogscore=999 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2610020000 definitions=main-2610130032
X-Authority-Analysis: v=2.4 cv=O9SsLx9W c=1 sm=1 tr=0 ts=6acde82d b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=660iZSQnnn4A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=EIcjfB9IiI4px24ztqRk:22 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
 a=-BFCJ2bJgao7vN__fc8A:9 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22
 cc=ntf awl=host:12107
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDEzMDAzMiBTYWx0ZWRfX5jVO5mtMhaHf
 6x1IdfihJcGWNH0FDyBbeFaJsAxMe5DdIFhsDUzxUijWqC3ucgyf19LN1NYyq4/OThUw2llk/xl
 3XQgcK3LZwopbbZGFZ7r0HUkONGQDFVDRmGChHksQMi7QaGvp7Ec
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDEzMDAzMiBTYWx0ZWRfX/R0hRndE4OQq
 pvQjVtU/a+L4OXt0dThpxlNwEEgvKHtawT4TJI+OUD2gQVhKGk9pickBDQykJ3PdE4dLik3yTr0
 B6+WwF0+UXedP1rMOv2aGr3KFhK8+OCSVUIlZekudcx1BIuMXQHx3NkdfxugpPXSrP2/wnycZqM
 PChIgXSB4rv/8rxGNnN1SUEqiD3uT7pEeDsfGvUkAFC7Hd5tG0mPVnb++MWt8YfTL34JnF0J8Fx
 gR2mM4jJo4S83YxATmo6PaSlhb9gv4eIHCfJpd9jRv25wJ8qDfL4CG45goS/Cyh6nXKVu/1EkOD
 zjxct+92jZPCn2i5n7Vx+ZKMk5NHVeXZN4D95OS7X2TW/8EtpGFfGkZXXY0a+r54ByXdln5MFB3
 M8ojHbtr6hrF6sk7Uq0Qcd6+ngHu0XnTgjWLRbTe+FlTbd7846CODdWNcXHX6/AlofHNSOKNTiX
 zPUhBEYud3vp837UxfOf/egSZzPTMFa0hhGat6WY=
X-Proofpoint-GUID: AIi10AQ9bFSWjcVi9GKgobaxz6TxOx-R
X-Proofpoint-ORIG-GUID: AIi10AQ9bFSWjcVi9GKgobaxz6TxOx-R

From: Dave Chinner <dchinner@redhat.com>

Lock order of xfs_ifree_cluster() is cluster buffer -> try ILOCK
-> IFLUSHING, except for the last inode in the cluster that is
triggering the free. In that case, the lock order is ILOCK ->
cluster buffer -> IFLUSHING.

xfs_iflush_cluster() uses cluster buffer -> try ILOCK -> IFLUSHING,
so this can safely run concurrently with xfs_ifree_cluster().

xfs_inode_item_precommit() uses ILOCK -> cluster buffer, but this
cannot race with xfs_ifree_cluster() so being in a different order
will not trigger a deadlock.

xfs_reclaim_inode() during a filesystem shutdown uses ILOCK ->
IFLUSHING -> cluster buffer via xfs_iflush_shutdown_abort(), and
this deadlocks against xfs_ifree_cluster() like so:

 sysrq: Show Blocked State
 task:kworker/10:37   state:D stack:12560 pid:276182 tgid:276182 ppid:2      flags:0x00004000
 Workqueue: xfs-inodegc/dm-3 xfs_inodegc_worker
 Call Trace:
  <TASK>
  __schedule+0x650/0xb10
  schedule+0x6d/0xf0
  schedule_timeout+0x8b/0x180
  schedule_timeout_uninterruptible+0x1e/0x30
  xfs_ifree+0x326/0x730
  xfs_inactive_ifree+0xcb/0x230
  xfs_inactive+0x2c8/0x380
  xfs_inodegc_worker+0xaa/0x180
  process_scheduled_works+0x1d4/0x400
  worker_thread+0x234/0x2e0
  kthread+0x147/0x170
  ret_from_fork+0x3e/0x50
  ret_from_fork_asm+0x1a/0x30
  </TASK>
 task:fsync-tester    state:D stack:12160 pid:2255943 tgid:2255943 ppid:3988702 flags:0x00004006
 Call Trace:
  <TASK>
  __schedule+0x650/0xb10
  schedule+0x6d/0xf0
  schedule_timeout+0x31/0x180
  __down_common+0xbe/0x1f0
  __down+0x1d/0x30
  down+0x48/0x50
  xfs_buf_lock+0x3d/0xe0
  xfs_iflush_shutdown_abort+0x51/0x1e0
  xfs_icwalk_ag+0x386/0x690
  xfs_reclaim_inodes_nr+0x114/0x160
  xfs_fs_free_cached_objects+0x19/0x20
  super_cache_scan+0x17b/0x1a0
  do_shrink_slab+0x180/0x350
  shrink_slab+0xf8/0x430
  drop_slab+0x97/0xf0
  drop_caches_sysctl_handler+0x59/0xc0
  proc_sys_call_handler+0x189/0x280
  proc_sys_write+0x13/0x20
  vfs_write+0x33d/0x3f0
  ksys_write+0x7c/0xf0
  __x64_sys_write+0x1b/0x30
  x64_sys_call+0x271d/0x2ee0
  do_syscall_64+0x68/0x130
  entry_SYSCALL_64_after_hwframe+0x76/0x7e

We can't change the lock order of xfs_ifree_cluster() - XFS_ISTALE
and XFS_IFLUSHING are serialised through to journal IO completion
by the cluster buffer lock being held.

There's quite a few asserts in the code that check that XFS_ISTALE
does not occur out of sync with buffer locking (e.g. in
xfs_iflush_cluster). There's also a dependency on the inode log item
being removed from the buffer before XFS_IFLUSHING is cleared, also
with asserts that trigger on this.

Further, we don't have a requirement for the inode to be locked when
completing or aborting inode flushing because all the inode state
updates are serialised by holding the cluster buffer lock across the
IO to completion.

We can't check for XFS_IRECLAIM in xfs_ifree_mark_inode_stale() and
skip the inode, because there is no guarantee that the inode will be
reclaimed. Hence it *must* be marked XFS_ISTALE regardless of
whether reclaim is preparing to free that inode. Similarly, we can't
check for IFLUSHING before locking the inode because that would
result in dirty inodes not being marked with ISTALE in the event of
racing with XFS_IRECLAIM.

Hence we have to address this issue from the xfs_reclaim_inode()
side. It is clear that we cannot hold the inode locked here when
calling xfs_iflush_shutdown_abort() because it is the inode->buffer
lock order that causes the deadlock against xfs_ifree_cluster().

Hence we need to drop the ILOCK before aborting the inode in the
shutdown case. Once we've aborted the inode, we can grab the ILOCK
again and then immediately reclaim it as it is now guaranteed to be
clean.

Note that dropping the ILOCK in xfs_reclaim_inode() means that it
can now be locked by xfs_ifree_mark_inode_stale() and seen whilst in
this state. This is safe because we have left the XFS_IFLUSHING flag
on the inode and so xfs_ifree_mark_inode_stale() will simply set
XFS_ISTALE and move to the next inode. An ASSERT check in this path
needs to be tweaked to take into account this new shutdown
interaction.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
(cherry picked from commit 09234a632be42573d9743ac5ff6773622d233ad0)
Signed-off-by: Siddh Raman Pant <siddh.raman.pant@oracle.com>
---
 fs/xfs/xfs_icache.c | 8 ++++++++
 fs/xfs/xfs_inode.c  | 2 +-
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index be44c7477c16..ea743699ae6f 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -879,7 +879,15 @@ xfs_reclaim_inode(
 	 */
 	if (xlog_is_shutdown(ip->i_mount->m_log)) {
 		xfs_iunpin_wait(ip);
+		/*
+		 * Avoid a ABBA deadlock on the inode cluster buffer vs
+		 * concurrent xfs_ifree_cluster() trying to mark the inode
+		 * stale. We don't need the inode locked to run the flush abort
+		 * code, but the flush abort needs to lock the cluster buffer.
+		 */
+		xfs_iunlock(ip, XFS_ILOCK_EXCL);
 		xfs_iflush_shutdown_abort(ip);
+		xfs_ilock(ip, XFS_ILOCK_EXCL);
 		goto reclaim;
 	}
 	if (xfs_ipincount(ip))
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index e1adad91dba6..a9fa5b1fd208 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2235,7 +2235,7 @@ xfs_ifree_mark_inode_stale(
 	iip = ip->i_itemp;
 	if (__xfs_iflags_test(ip, XFS_IFLUSHING)) {
 		ASSERT(!list_empty(&iip->ili_item.li_bio_list));
-		ASSERT(iip->ili_last_fields);
+		ASSERT(iip->ili_last_fields || xlog_is_shutdown(mp->m_log));
 		goto out_iunlock;
 	}
 
-- 
2.53.0

