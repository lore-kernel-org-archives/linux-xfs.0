Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 435743CE4B5;
	Tue, 13 Oct 2026 08:14:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791879292; cv=fail; b=DRU/DK8Is/prSGqbHBX4x2VuXHmhCowFN5eDuxF63NP0qTkH34BeyPogaSZoIwQGM1ni6QoBsaScDUTvuSQoUwLLfo5Cb/nvuF3y/6IuQVrO+uLNaUA98Ikh6l9bKxVAfIKpVVEohyYhNTB7p9hrOStr+Knrzk6InPtLhsp6UEM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791879292; c=relaxed/simple;
	bh=JDbshOHBIaZZ5IRbwUIj/mZpS/ruK4e9iGpqEq6XcXE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=tbCBy95mOFNTAkkVVmkUIylGHlGOsXWfRAp5fANtx7w0fcXJWKvQPagLUKrtHoQbZEeIlY/4lDCTIAvklyXnME9oE5NGYzh8s348QDQfU1YqRgyvS9Kpe+KFKDv3KDUK0oinh7hcXiRhMvKI/iod9eGgdtgPIU32EZUasWIF8BI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=MpI+qfPy; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=dYOQk9vz; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="MpI+qfPy";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="dYOQk9vz"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69D2CfvA680865;
	Tue, 13 Oct 2026 08:14:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=e+PAXEMb75fquC5JQ9i1JaBNrl58F1UE4VJXBqdHTGo=; b=
	MpI+qfPy6uOcO8xHjzPSvZwOG0VbZdT3ZfGscK/GpN5BfTBKZToaJ1aKhfX/4pm5
	bFHXBmYgIcSjdZAuiNcls92rP6AyazWkuHS7LQaduAAInpqd3hSejDBoMaMSlNDT
	CgZM9f0SAw2QZwlLbtE4etRdqU/oZAR6imcah2AAt9DN/3PjsN8gmCNlFk7bERXS
	BjjC+OsqBa5Tjneh4hqKgax+3H9gleRvxaqfWUSdYNrebgIH38+xIvjRMREzKCQf
	fkmLPaCequsosUxCIQw7SK0rTMujmNbG+dVb0rkxAiTxsdEu1juOnBMoiI+Hxzmd
	gG3mQ8xdvTJ6yVBFkteSQw==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4h7dddunfw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 Oct 2026 08:14:47 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 69D86hoh033537;
	Tue, 13 Oct 2026 08:14:47 GMT
Received: from bl2pr02cu003.outbound.protection.outlook.com (mail-eastusazon11011017.outbound.protection.outlook.com [52.101.52.17])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4h7btnxr4k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 13 Oct 2026 08:14:46 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WkhNNIWuKQueYEQzggk2l66Qga/9jpNfxBZpha3NQq9WgVeQsAJtKyDtvY8TIE8LZHsXT1bTYRY9NW5MvQKo6PcoO4MCZZTazxREYs+o8lDvyOz6I2PLz1YrNRwbkVjndfWHYatW+/08u1TcR1x7YLkDTemBcaqlyAh2PxiqPNGgc7MPPcq3zmqCDic5Fyd4rzOUMIZOoXFG6clhgb3uShCbDtr6SN6MsuWQ0j0pDF0t/9Mfw0I1BcV6VYycnaILINb/8olF7aAEVk0IpWNcjweP4lH+1fSfYM1/QgRb6AqsaTW+CiJySJvbm1u5ylg61lh64OXJ0Qcs84dpQmKCZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=e+PAXEMb75fquC5JQ9i1JaBNrl58F1UE4VJXBqdHTGo=;
 b=FAZNiQhw5w1joq72ncu1hrKqZtN5MrJyQIctGDi16R2GZDSsqbFayuinjhEC1WmYhropOCBzyqxJKUw6PF4pi9eOvKS5i4SdsAkKbOH2c+P9Tas/Id6mKpBehauhzllFUKr5QANJuCy6eav48oWnfs2WDPjmGOYkApDPkmrZJzhb2o4tb6alns7wrNwk7kkCLBtu5wZIuYbu6h3/c7DqOQLJGxj7QEqQJ7BoDP1y3HPg2Ls/b90yxmK34rFQyAnYmiotGQ4poedt8QRc5Ncb/YEUwsR0XoRhl85+swZ/V2vzYMWifRGBY/N8FDIWNskecESjnccvpm2KW9gX8iFr+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e+PAXEMb75fquC5JQ9i1JaBNrl58F1UE4VJXBqdHTGo=;
 b=dYOQk9vz2K5+HkEyVwpG1qmfxlVodguG7QNV7EP/hv1BewZsekrCN2h762RFF4/Um97O/pVtOZJzZmASqKIuBUPppa0uRozIV+JU4+vJdsMjBAc1wj/puUL1nCEqVtQ73gqwy11PxAMGTh5eyLWV3KQqKm5nE3EtXhPBIY9jgT0=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oracle.com;
Received: from DM4PR10MB7505.namprd10.prod.outlook.com (2603:10b6:8:18a::7) by
 DM6PR10MB4138.namprd10.prod.outlook.com (2603:10b6:5:218::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.522.12; Tue, 13 Oct 2026 08:14:44 +0000
Received: from DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::f14:5389:d117:967c]) by DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::f14:5389:d117:967c%4]) with mapi id 15.21.0522.011; Tue, 13 Oct 2026
 08:14:44 +0000
From: Siddh Raman Pant <siddh.raman.pant@oracle.com>
To: "Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org
Cc: Dave Chinner <dchinner@redhat.com>, linux-kernel@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 v2 5/9] xfs: xfs_ifree_cluster vs xfs_iflush_shutdown_abort deadlock
Date: Tue, 13 Oct 2026 13:44:13 +0530
Message-ID: <3da5cfc96a3d8aa5bdebe52d3e58f377b4e45632.1791877866.git.siddh.raman.pant@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1791877866.git.siddh.raman.pant@oracle.com>
References: <2026-10-01-1-daily-reply-0012-re-xfs-umount-hang-backports@kernel.org> <cover.1791877866.git.siddh.raman.pant@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI3PR01CA0009.apcprd01.prod.exchangelabs.com
 (2603:1096:4:296::14) To DM4PR10MB7505.namprd10.prod.outlook.com
 (2603:10b6:8:18a::7)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB7505:EE_|DM6PR10MB4138:EE_
X-MS-Office365-Filtering-Correlation-Id: 64f88ba6-7401-4ec1-bea8-08df29020a1f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|10070799003|1800799024|366016|56012099006|4143699003|261009223027099003|10067099003|22082099003|18002099003|6133799003|3023799007;
X-Microsoft-Antispam-Message-Info:
	XcRUbfp0Qw45GF/PoVJFMo1U1zJO4PseKqV8pDDB/ekx3+eXWEnyUiIRAK/vdfhbOqbxU55bex4aF2LMX6Zu/igvw/fcDXfIxR28rWIG7h4deS+W33dubknip3bo6wN1qGQhF6b7La/ovpICmYBs9svOtGOUCHaW5rQkKAYDd5UhOckakU1rHUhRjnQYWCndCIC48YoSmWwg5U1M57cUmQyJOXiHm0uxyeSvQ6+xzcyPCsP5fDQ1VaNwd1bwp5AfYSfWgsgUzBYL6E4GKsyz4XHGV/ABphSZjoo8wqmoDzDQ/Q4AftgRyARWgHM8JRVg9423Y8iUR30vzArKJOo/CqkDDeso+H99lWxe+suZGcCWhARli8LdmTZ95c7uskfqz5enduVIlz/PgupaHReO4oiafnYTrixKClAPouA1TUvn+JE61PlMxobsVO1RWGR1QHumB4JmolC9leisQtHhnLC2YyAvTOcqCz+aGK6VSQedyUN0eU8BrQpRNqA0MZu1lrUMSmpwOA1ZNqz9+dPQJiNSX7Uk0H43MvmiDyzdD7Vcrd8JX+p4BFy0UBPuC9CXUUNgQQPzUBbpWTi+eL4Dq2rZNJfAZvHsUAv+MnoA6U1+T+zeaLlmSHWqW/si3yMNSc6GBWKNuVD+2nXrHqQ+8Gf75zyHACaNfkxz2tyRQEI=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB7505.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(10070799003)(1800799024)(366016)(56012099006)(4143699003)(261009223027099003)(10067099003)(22082099003)(18002099003)(6133799003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?+U8UPOUYmkHSgYQdPE0b45xASn/oTLUDn3mIOHdCsYcfETPFbJxprURM3t8W?=
 =?us-ascii?Q?pJZqH9yK5YhZg3psG5aDvAtkBbtTfZq/nAj3UuFVJoHBscBqNYvil6FVeF1A?=
 =?us-ascii?Q?osHRzqLBlFvT8lICtrq4sKY8GeIWRPSrxYeICoyN8sqP3G4J5qY2Q7wiNdLD?=
 =?us-ascii?Q?r/d0bOY7T+Nu3DJuh3PcZDfWYeaNzGCRF0YuDcM1+HrAZyGhqhXN13EWXt/n?=
 =?us-ascii?Q?SFahGjQy8RD7myUYSJs2h2WMctT3mv4u2TeIsI0IwMfh747ETilhJKWQRK50?=
 =?us-ascii?Q?s/y9VUzPTt3mYUnYINI0IIYrxHUw/Eyry5GV+dC8OsFRjS+F65NwSCU309K6?=
 =?us-ascii?Q?NAwfBVD4GJdDFxzXvGGX7KI67/5Nfub0cLb/tZmrSm47NjyBPgKlrQvWFGCI?=
 =?us-ascii?Q?/aBriiVnrZI4MBPomClmWtwzgO3R19UusZhDd2v7aNdWixJHvGq5vobO7rCw?=
 =?us-ascii?Q?AOkxzwCQ+V6kKdkZbUTlkgU0G4hqIW/26Aao/lRxoaT+VvJ61S7Q5fgDuSqu?=
 =?us-ascii?Q?4ws1IYGsbaJV/2x9zSd4TsgkwawZUocIRnYX6iUtLJfCC+UOGP5sd8xI9z7Z?=
 =?us-ascii?Q?RTKxaqy1ZOWAkWqeDWHrcQWeclThZlUAzqQhZoSu+VUArcMKqYNa8QodTJnI?=
 =?us-ascii?Q?YjiZED7znlbCexKtYum+4JITqg4pTV5ZkqneF70WkDEhmPKEOx+ocrIlO/T4?=
 =?us-ascii?Q?tfc/Hbt/PrSPRiXr+9tyPUBXe8evRKDsaG+BZGIY4IUYt6MeLStWsSWCoOpt?=
 =?us-ascii?Q?1+lg1q3rkCHUjvblQyi2T5+01YMeM/upQ33HPThiZWPlnzesxAPZCdTDBjuI?=
 =?us-ascii?Q?ko+Q4g6Ut+rdO5xpSqmWszwJlpiagIYd9hGRYZgdQRwysyX1qNsyHYoxU7Ht?=
 =?us-ascii?Q?Nfxuw3Y5gzFlL72a+lnayz74yHkdDkeLerQLV3u/E1Hw50fE+of6UqUsNs0k?=
 =?us-ascii?Q?rwgGNO4a080kTlvBVh8Zz3v6VR6339uSoX+IEQWbKXamAxWgIPntrkStBFNF?=
 =?us-ascii?Q?oICyV1GKV7ta1QXRaD8qyGy/VE6v+PyAPxi84BBzdwaedX3TtiZu2nDRjHFO?=
 =?us-ascii?Q?VopC0c9IcUpDFZ+bwRXnsRCEUefuB1tP93UDNADRM+5HTjSQ8g86RLOmBnXU?=
 =?us-ascii?Q?SxZNm6aJjAW+xcKUQ1Cq5CatUDFjqKAplr4NhoxhW36PQtO9xQpvb0DN6yLq?=
 =?us-ascii?Q?M9RVIP5QEdCoEwpvycK+ZmNoy/6sz6jg6hZNe8wwReury2ABEM66jj9DtERk?=
 =?us-ascii?Q?n2gBNzq3eS4nlOfpJAG5t9VMVI/fBBf89BgLdw3McJd7Nte8l/tFz5mJdawu?=
 =?us-ascii?Q?z2p3XiUqgs+raObvXhCObpmtRzxcBGsc+meOcxgui89rUME3HOACoInU0PNn?=
 =?us-ascii?Q?YIOIX4/J6jHkEmOHY6jxJGUFu3FMM1PZrz6SjZjlaLmqHow2TSZztJ7IKFKs?=
 =?us-ascii?Q?fp4CT4tMV4/dH7Uio7qgFjwGDEDsocP3hkD/mJoTXTuLDLRLgekXlPOE6dcj?=
 =?us-ascii?Q?W2Oa97EIx2exakSFCGCsVLJdL0y+EuDNUI/kFFEPp1ldCpNqSpO7GIwSkyBf?=
 =?us-ascii?Q?9a4MHjG/0NSmzftZJdskODkalLczNUfR7Nb38YHhKNwtwM9vf3F5v08Gqyow?=
 =?us-ascii?Q?QqRzPBX6baDfqUUI3FORMF8UKQ5Xf4RkNru6TA0E6zntE8ekE9IRxtExCBjw?=
 =?us-ascii?Q?Cic1/ezEwVMDNn387oJ0IKBfCUPpomC50JCQp3XJzNDjjUwjPfGVkGxlafe/?=
 =?us-ascii?Q?R1gW2rCT9FmvrGgh6mGc9kgMAId4tbLs/y0QlFJwGKpwoclt04UhCBYSWXmo?=
X-MS-Exchange-AntiSpam-MessageData-1: TbD5DitFlOypf+k7eIMlTTsOLUzOJIlVNbE=
X-Exchange-RoutingPolicyChecked:
	Xgn5aRjUDydXX1O7S0uo7LjY5CCstUE8aTk63lbHJeXLXO4ustPn0BpzG084ZBzttoh81d+/3lg6ANN9y2IwU+oTDl/EYAcPVmwl30jDD5ClYqVI6p1kdvBjqDOhc1izajJ03RNnUemUMAveOpl398oPul5FRdkT+6GSUJbR1QCLg7Zcy/NX+O2Ku5o3UZVZwKRY464COn9Vi77+hQmJR5JIZyyk6t4lN4Aj7BAQUsmDAUQqBNsWANC1sx54BV+wy5yETzCU1daqYTEuFLgD4gQ9O/EIm6yt1zSpKQFq17Y0tY6LMiyr3q5nBKAhavs4R/N+44zVLM3waZcdbwynHA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	TJkVZZFzd6hhYEYQP0I/mwb/5T3+JBC3cVQGY4Dht/ER/DVsG0zvc1czbjGjWZ26ise3Eypi/BoHFZWTDuX6iq3J2KwoYjRdwpNgvVV6YuC9Ek+Hltf9OKV/snaZKpxvjeW+vLQrl8F1FNuX0O/GU+byBa99Tkf/IfRgf3juFbcXIDRoYNJFtihoT2hraMnHW+iqO8gM/YI8X7zIzHySwBzr1LdxneLJh7xOmQvLfkhn3rqPTkTf692wYhdLZa7BEJyyzYfmAY+8o0e4NERTunyngFVey+Zhbf4mKGMDMQL3kEqcmHmCEMpC1FnP+bAYpKNu14drFskP/N+U6kC6Spkyr6S3wUzLnylEbcujpgIHVSdANRYXt6JZ8IHkh/ztFSweezdG6ggFGzmYsa5uLks+8QnWHOYctgGpaDZQdunmV5YbhLSCt5CwrlK5qi8PqIiwEubK5p2n/ZkdezlbcxEptdx///Ix3WFkZ7fYBnMjMlEKHY7MK9h9tu2YqCq+yN8Oosv1fuXSrpfU/7ar+8GVDhzatHMHo6nAD6qO0d5dUe89BX3ntfsF8hMu6iqIJlFqNGoNRDe/VPPoiajcy8SMcH7uCZZQYwyNhi6cg+8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 64f88ba6-7401-4ec1-bea8-08df29020a1f
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB7505.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2026 08:14:44.8131
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SX3ZlHF3UYqI9sI40wUg3WePvryU9NTelgighQm3dsVWU0RhjktcLKujLOzyXTLMAN/l3sEEBH5Ped2gy8RaTgUFFWDMW0SBCrTkprfpEb0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4138
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-13_01,2026-10-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999
 lowpriorityscore=0 adultscore=0 bulkscore=0 malwarescore=0 mlxscore=0
 phishscore=0 spamscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2610020000 definitions=main-2610130032
X-Proofpoint-GUID: q_7VspOImygFt-CZNXcef-zVmYObMapK
X-Proofpoint-ORIG-GUID: q_7VspOImygFt-CZNXcef-zVmYObMapK
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDEzMDAzMiBTYWx0ZWRfX+Dfo5lA4BeyV
 b20sduRgQM9q6NRXVBtbmvoiMiixnLUEwZHMq8MGz/+wfYeID5waU0cOl8Z8IvBB4i4SU9VTXnr
 ExYfOIn4K0uVcqZfEQEfejzNqrqelZtgtfM3WHfPXprjRIPr4z50
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDEzMDAzMiBTYWx0ZWRfX006K/BvqadwB
 QXSGhT5RxvuKP75NCMrMByW4VvFt5qg/X3vhQkR6vqn+epgC2Qx2vW/m/O3wjus7M4BTBEg6AZC
 pcdT3m/3t0OELqfKKw4L9oLeJRTvfBhzIGp8sXCEo4mZrV2zU+g+Yt598X/3VH+2YljQYmUPEWw
 rEEHz5BUSg3f7N4BFpzWZ0qsGlgiCuap1LngOiEUuCfur91edeal6+9uJFswm7koIVuf8rkKE53
 WD0YIoO/rGLKnemYU/qeP4FcH6VmxMjQagksmSZILqAg3Cm+0Wod1laWPDciK9+yp35JGlkvGbT
 Zdm1L4wBVl16L6r4MHRmJS8Kszc1qjJSvBvUzm9naehQQiJ2vAsTwVC8bmL1ap6aih5ZCa2cM8i
 GVVsZknodvQIO3r8nArhHcPXXSrtj7HAaNzuIP3lb1AoNPpMZBbIoEyIwLE8bjMSMCaFbKh2AXQ
 6GPZlWhmbeJf3HT9mWOrjB6SMvAQ3odQxUzl+aiU=
X-Authority-Analysis: v=2.4 cv=J/8/fwnS c=1 sm=1 tr=0 ts=6acde877 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=660iZSQnnn4A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=BqU2WV_vvsyTyxaotp0D:22 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
 a=-BFCJ2bJgao7vN__fc8A:9 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22
 cc=ntf awl=host:13537

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
index 51fb70bce819..b609759de490 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -898,7 +898,15 @@ xfs_reclaim_inode(
 
 	if (xfs_is_shutdown(ip->i_mount)) {
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
index 13a113ed666f..3f2cc6204153 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2492,7 +2492,7 @@ xfs_ifree_mark_inode_stale(
 	iip = ip->i_itemp;
 	if (__xfs_iflags_test(ip, XFS_IFLUSHING)) {
 		ASSERT(!list_empty(&iip->ili_item.li_bio_list));
-		ASSERT(iip->ili_last_fields);
+		ASSERT(iip->ili_last_fields || xlog_is_shutdown(mp->m_log));
 		goto out_iunlock;
 	}
 
-- 
2.53.0

