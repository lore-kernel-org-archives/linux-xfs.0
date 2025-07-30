Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76A411F4262
	for <linux-xfs@vger.kernel.org>; Wed, 30 Jul 2025 10:13:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753870430; cv=fail; b=eK/bE258J/4gL7XdrlbuJVNvOknqLRWk5j4F7qFRkmMg4JW1ZkUCaclf9FC2nVkuJphJ+pkTs8waRS1I9djZhTOx5tILIjspyOVMlF0ZLyU737/9FovgDTwfiQ/MQtBh2pTnbdBfl9glE+dOAKY8qRiYqjIZq0P24rlv5qdrY88=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753870430; c=relaxed/simple;
	bh=uOwWeoZUpYDdKPBcmaN5nmpZzcjfgPx1bCRdilDrT4I=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=cYHA0ClXlQRCHtcDAiyipr3Z2nQGqsN0AsKXQPOldUimpX6a7mf37sGfgK5xL0HHVry1csmUQruaCd4MXbrlRV+eZaKn5KWBffWF4ZYiPA3/nkeLOkyIFY0bWezOPMc/dbju3flFjeBk/NIQ6WkitoFOQcm4U9cVTis3MffffVk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=PdtI3756; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Sx8+goWo; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="PdtI3756";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Sx8+goWo"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56U7g8L0028114;
	Wed, 30 Jul 2025 10:13:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=corp-2025-04-25; bh=uaWyYyKEywK1oqpj
	GEFtpC5YlnIfCbIorAELkJXd0Ms=; b=PdtI3756xshTAiqo0G4FwejM2xdBTRqM
	34Qr2vERE347P3f1onDaPGhIvHHbOWwgBEY67xapHxqgSHo7XehbbuRASP34cO4U
	7j+Y8EOOvck4xs95d3Cp4mnlKRoQG3sZECA//vVvFftSShSxtU7/fjRi0W0CwqWC
	2cCkbC6qPE+0wRS8Rf1dOINRQQ7o98ZU5YI29HwKgJOL3pZ/xV8Le83eVFxirp4a
	jnU2WWdb/kHie/1FLqRCT3gXXE6LKCRU8XRrab9LXmc1my5BEZy6KdSXebxIrytb
	SZohspkQ8EoZoehPvY4mAlcgqUgTQ+PgNiKPY7zV4H+MqJpWjMmc5g==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 484q29snsj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 30 Jul 2025 10:13:40 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56UA2sU1016907;
	Wed, 30 Jul 2025 10:13:39 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02on2046.outbound.protection.outlook.com [40.107.95.46])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 484nfhap51-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 30 Jul 2025 10:13:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WSQsSNy49yZI+bOkn4jE+AQa+SfAJ1pYwfePIkCHVtk2++hrmOBOu7isCV+bvT5AJ3MWCTz+g4wT7N6DWT1QkXOXgO/4sjahackGszQo3FLRZJkeMA6JD5M0CB2gQWXEhrH3PdxTUwUFE6oghcnNiYCoPB1hy4ZjnvOxc5tRAOFqNXsqMj8DH5IEwsaHQ+vfwpDlSBCGBaLQuaL6J9xhpU9wdgmLTInucg+RU3PIaEQK8eC50Esow1WA5yfuuMNIR5yk3WQGtO2Zf7L6AJyxNJ8sI8VhlWFxcJhOrv2hPZiQ+TUzjTaUS2xBClYQLXkSr/7YK/Ph9cOrmT0ouWgR5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uaWyYyKEywK1oqpjGEFtpC5YlnIfCbIorAELkJXd0Ms=;
 b=O03I8nqTCaEMZNv9/1+ae8M6F507fDuh9ogmveSAwbz7vNGf9BWR231XytCrSvSdTwGVUJAOq7ZLZod7wEMDsNHjRTdqXkbecYsNT+TVgXrqpToCE1TKYPd1JNSDG+EeM1/0t3WdExQ+r3D3NCqdwY1VefHjytv136HFK2LMqeuQdDpV6jh7P21XbBCwJRYiW2s+KVhyZPDYv51W6v+uNGeJrkEcJRV3ihNqPyJqYjfqSGNK277GPXlNP8LQ9TftbrhvmDx2I7NRT/GxJOuvbEdHzUC31owkvnICpyp+6a0cQ4u+s/Bku77czFExb8tMP1RTZSricpsmSpgz2hEOsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uaWyYyKEywK1oqpjGEFtpC5YlnIfCbIorAELkJXd0Ms=;
 b=Sx8+goWogR4wL1k73OmsIrZFxehFyjm2O9wB783OEK35Ty8VL4zQHG58t+Yjg251omB/Ki05sa0LZMPRqyEJ0X/qKoCAGVH8j5+CgQOiBkzCZ9YSpNbQAw5rgIeQIcjujI0RVrkUPyhs4t6TgFiLFiX3nL04t3Ir1VYzmkSszyU=
Received: from CH2PR10MB4312.namprd10.prod.outlook.com (2603:10b6:610:7b::9)
 by BL3PR10MB6113.namprd10.prod.outlook.com (2603:10b6:208:3b8::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8989.13; Wed, 30 Jul
 2025 10:13:37 +0000
Received: from CH2PR10MB4312.namprd10.prod.outlook.com
 ([fe80::fd5e:682a:f1ac:d0a2]) by CH2PR10MB4312.namprd10.prod.outlook.com
 ([fe80::fd5e:682a:f1ac:d0a2%3]) with mapi id 15.20.8964.025; Wed, 30 Jul 2025
 10:13:37 +0000
From: John Garry <john.g.garry@oracle.com>
To: aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org, djwong@kernel.org,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH] mkfs: require reflink for max_atomic_write option
Date: Wed, 30 Jul 2025 10:13:20 +0000
Message-ID: <20250730101320.2091895-1-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.5
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH7PR02CA0021.namprd02.prod.outlook.com
 (2603:10b6:510:33d::26) To CH2PR10MB4312.namprd10.prod.outlook.com
 (2603:10b6:610:7b::9)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PR10MB4312:EE_|BL3PR10MB6113:EE_
X-MS-Office365-Filtering-Correlation-Id: 8f612d62-6dc5-4e78-2ecb-08ddcf51bf44
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?mxefkBV9ZkiloyNGroH7Kt0ToKbYzmw1CBViAT3HxjdQ0pHYNRKZb+2dVcEC?=
 =?us-ascii?Q?vTqaYqSW5JzIndOWuQ9o7sH6tVNjwEhPRjkPQrlaiuOedqSYxOYdZwvRqlGY?=
 =?us-ascii?Q?M0/kNxtYkK2v1bbOT1vX0u2gWN/5SoZkRsjcXu7e5i2/numcxui5oC8n4M4o?=
 =?us-ascii?Q?DHnPpfIRAQo8FmeZcq0h8GMpngOA/t0bwniarKoDpQh6fwd8LllAj4d7558G?=
 =?us-ascii?Q?fyKUsOv7MXyX/26UwETtGSHmMqolB5MDllMmc14m8usiY5qCJJCvDw75OCMf?=
 =?us-ascii?Q?xoxPKZDmhVDOyprUnkJp+/127f3t5wlaZENeQeV2UNp/LyfysUBKek3nBUSA?=
 =?us-ascii?Q?adb0J7AvdPG2Zm3jLkuQ9EJ3O5rOt94Lt5dhQVAcR7j5unLXRw50F6B5hvGh?=
 =?us-ascii?Q?w/f+vMC6UavJrivjEi0JCGn9JWIbIJfk7M6/V2yZh+RFBvJd71Y9VuM/HBzi?=
 =?us-ascii?Q?BmPW/vkUvE8E741A47pMBw8qUVWWSN08HxyYAI+qOm6rRTLytNjJovNzaPrT?=
 =?us-ascii?Q?+UgYCrwbHdBQ4G1USDTraEiDpk4/URfIySfMbigAZYxeB2HgvUId/q8AOC+2?=
 =?us-ascii?Q?KQ3dMEPXdfdyKWDb5hma1uM2ZHVIpRctq3Sbu/6rpaiGCnbfIooQnrmKZruR?=
 =?us-ascii?Q?y9uLf0sTRcnnL8sFBRbIqGfVAO/QGiSS8D0UXplHWvKj+dE8kr2IYp6mgbJa?=
 =?us-ascii?Q?c9ZMIsqc+O7ispfP/rFPo+5Abe3ls9VTOmbODuZ0aRTQuToUkAdM8V9j/926?=
 =?us-ascii?Q?aTv87Aubh/ffryBzt5bkRkwKnXbUzHrXkXuY6jyMlpFSpIzjgS8kblivOc20?=
 =?us-ascii?Q?eW2aFVBscD2Irjmh7BXE3s8NhGc6HiXTYcwrMIEAeKiIsM0BDm1FgVZ0bM9X?=
 =?us-ascii?Q?Eb1ivQwtjpI/OZGkz2FDm+8Kdwy+uS6Iw+I1Jy8RWcoswtWtxvo56PhiB2rR?=
 =?us-ascii?Q?BqtFxNlPofJ1B5+7ChBl7yRLbKLw2Nilt220xxJa2OG6GWH+R8zUGN+TUbVF?=
 =?us-ascii?Q?goT3mmdc27G2Yh8bMJ124N5FjTfzpqKZIACClWzOMxATI6wwaBHKx1apyqKR?=
 =?us-ascii?Q?No/FTjU5WuReMYIYEf6u2y2J44ut3hPhGf3NEbM/f3vCuwZKxsehcw2nyj//?=
 =?us-ascii?Q?uuRpToSGx56F8sty/h6HckTqUQb84WaLul1TtfDtn32bMzX0W9DjpxUiiyk5?=
 =?us-ascii?Q?NR2y7GXbhoiViYZI8Zt+/0brwJ6kpNmd3Saks6hn4v82zX6oZbK0lEymgQMd?=
 =?us-ascii?Q?Lxol8rwsCOLMY2yw736DZJXrhW4Hnzz+bQKdVVcgNliMmPrZMv9JZedw2Nj2?=
 =?us-ascii?Q?0iYmiC9/yxY5xhjsHx2ktRDVy4TFCG1k9OqverJJ7pIQJjztelapUTvMsHPH?=
 =?us-ascii?Q?zyBGBMFuGQUfCJ82wQJvNUQ03kFaoSqxX87cERVsVa4lZkinyRmYCUF7JUzS?=
 =?us-ascii?Q?zFWlqMtY+o8=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR10MB4312.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?u9JeDbJwOEVZM6YJuWPPECOrouZvyZdt9TwuALACh77paIMGt0NEwkI2yigY?=
 =?us-ascii?Q?gj8cXlCvgE6gpVaQY6Md0WCASWaKsYK1gphCUtresnw1O1sjgWK4BzSMZixl?=
 =?us-ascii?Q?oDkDu01p0Zcb3C9joLbv1/AA3LZWq0CCq4RAyOK95Gk5u6alC24w4sQBa4Yr?=
 =?us-ascii?Q?ky+PeqZEaMyCIHxKuf+ptmO5J5G0tZhpiGC6Ql1z8Spj3dKb+QN+lzl4KxDC?=
 =?us-ascii?Q?Gi6zn5H+sYAKjwh94XunMGt+KlD+OThOLC+mQigAc1oqhVfl7c/jwXmV5IK0?=
 =?us-ascii?Q?Q/8hvxg01b8s2X7kleqFr7wPP9Po8k2YJ620xDW76OZS5QnU2RFC2G3kze9B?=
 =?us-ascii?Q?s3IJJBXW9XZ2XSo/2IlkcTyfBUd/eTqRe9UwfkyPd2ud3+nBNscBl0F8tKDx?=
 =?us-ascii?Q?uyvzaNCeVEBU5PCqptzf3R9V4BfgttnuOMcDHtP/kjRK7+0CYpK6wBbywLFo?=
 =?us-ascii?Q?XaQ8mQdHOE4bE42LGQkwkf/FYccCFYxYE6ZTR2VeNFQ8dgM9Z+HyPDhT6mRm?=
 =?us-ascii?Q?f/4u6jeUyKwintL2t8L89rfczIvQuHTzcngsJcjCt1CagKr7WeUoVGTlHFJ7?=
 =?us-ascii?Q?qiNYwvD//btWjBgTWpJWflmCARjPcWK0h3emJElhBdLuMbw0w1MOZ1CiWz23?=
 =?us-ascii?Q?DN4jFi3vLuDDqaDVroaaTrym0oIBcSTyU4TnpWcJGdS31uEqjJPlyvWXFL4o?=
 =?us-ascii?Q?b8JzJJyMAkdEUPQOMsAaODghLOgRT8Ii6/pCAgSifdAZC+enhOR7Ibw2Q5/V?=
 =?us-ascii?Q?dO3/rRI/ox1UgsYEuohTR/reUo4XMDjQ/2VtWc6KtiyDnv9wVDJnnDpTY/t5?=
 =?us-ascii?Q?0lylFDNbl9jp0rgBT3cHYrKxZjuWru0pCNyJ+qr+79oLiYhcsSrGedU9LQSP?=
 =?us-ascii?Q?YX0dbysypAWGLm1h343zDTGHqTjxrNQEi/+SqKkpqlFEGmdHYYApO429xjPe?=
 =?us-ascii?Q?yRbPh0lq7RfwMKMohxHugrfdMI3v2LZQsKAnKU3rzLpAobl63YsqjJuCFyPq?=
 =?us-ascii?Q?ZJ7AVcOIEdcqBYoryraiBUOLI8zWyMiWxJu6jCgXMZgD/aDneRbkBpYeMS8q?=
 =?us-ascii?Q?ShgL9y81xDV6mcMBhl+U9UVBpEJt4asj3u5aWaXiq8IZaPyCW63z4F3055RN?=
 =?us-ascii?Q?hNM/A0n0Y7HYu9MVDOw9UQPC6V13tgYJPQA30hGASQIMRyOP0YJdzrhf8+v3?=
 =?us-ascii?Q?ioriGJbw4Tgux6jr1Glgt9LqmJf8HkoUCKzLNEjqYdArfE7+32+XTifaCaGD?=
 =?us-ascii?Q?KSFkLvDqJiP6PP5InsYvZxrLgPLC6/R8x4oInftzFGiL51nVJztupBHttyXB?=
 =?us-ascii?Q?RwRVFen8i+V1xx5KdNwq7FsCpBJ4Tm6qTf93XyScPh6TG/kMcLutAEcaBKs0?=
 =?us-ascii?Q?KDmUe4VF4WYBixZVVuZN76Mzgd5M2WNavlN9mh1RIc04g2X1BcbRWbxd9zkA?=
 =?us-ascii?Q?qdilwZMfWeV26sJFKRmFlIE1Nzyr6ozmHp2b+80Cd7NuBWxsZsSfu8QnKC1g?=
 =?us-ascii?Q?3l56GRgsG5+sROnBIRgR6k/VoFsKd+ERNKvFxlwI9I0ughZ5BJxz/ToxUomK?=
 =?us-ascii?Q?dGXDXmpalL9qUxckRG7UX7VcypUipWhQFo0i4phk6zt0BXJmIi9Ht1+Q/C49?=
 =?us-ascii?Q?Vg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ec8wAlo5UuilLWSVxKpgI1185QY9CEt1uxTIp5+Moefk5TbMAo2zxIGy8S9kvJjVIkHcOqKbEr4/TCKENBcsPOkiXTBbJ/mbWD23nYxJVDRF2+PCEr4q/Ez10uVr9i5i6l2drF+Ohh3ixACjyY/cAAruZc7D8cNeJE5895dEP3RqlV7nrEHVJahYOOD5BO9EumC3UewW/OoGztL+w355c2p6LbId7EStMLZbgJKHmrqiP27tWYCKubYmAcwQ1iYzunefn/imx7qhPNg2ZkQEyKDmExP4zSvvTpiu8I/adL6mHjg/LCBw5KSLHzHSkjkM8ZPGA9+nVSCTUZDfwOft04q2tA09QZLlKF4ai3JT+h5NmJA38/ZxcnVOxNLtDL+dtry9MtxEbYG7D7+2DF2Z6herVeLqc47x6n4qNvV6TtnyWLCCs60hh+n5p11PPEqVLEKD54pnbZuaJ8v3+EBiQ+IFVGFAsvq9HzSw7VzhsPym9zUvJTvtMwjzguDRffZjhtKT/J0+p4JhGSSoc7Nl0CTvYmVBXL0bZGZardV8NNzRIDNZmupsQJ56ayyR3fsCTBRbXYI10lpUUmZRWgByQFRdO1GI07XFMpQHRspDz4w=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f612d62-6dc5-4e78-2ecb-08ddcf51bf44
X-MS-Exchange-CrossTenant-AuthSource: CH2PR10MB4312.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jul 2025 10:13:36.9902
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: usSsYwaiP9VTQ/XmcmoKYHlEs5gEDmQzyGdM2NyumJVluvE1Lyw4XAZXX7M9045B7by8dn6iyT6Z/d8LED1ZdA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR10MB6113
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-30_04,2025-07-30_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxscore=0
 phishscore=0 suspectscore=0 mlxlogscore=999 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2507300072
X-Proofpoint-ORIG-GUID: 3F8jAylhRu444TcDFuGSI_d9jz745dvp
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzMwMDA3MiBTYWx0ZWRfX+59NSRlmobDD
 sfX01rPKLP4uKcnP3jlFpFcp7lVXf1U5IYzW3IwBwdkuOJk6io6CyMNyXt4mQaGxYep4XncoMw5
 BbJrD8HKbEtKh0dNvE9JPRBc7h9Td9FxeevyKGa1vU/oqJkt2F3rR0vc840gArNvTTQPvW8DPsK
 xuyxx6Yyv+/gTE4rUaSGKjh8u0WDRiQo1AUChIcRQbGCzXWjtBYLF59u2vnRgKtDCT0h1zh1MBj
 1huXZi4hPXKpDwJ1/XUjtrfaZe4qfT6fh50tuuJIonzpi7i/88hKvgUW4Pe4O+Wmq5J4Cxtj2xV
 qxfmZnIbn2Fcsn0pCS8RgWmTT0RazMP7xeavVzclZ2Gy/j1euv/MNbUZdrmnl4dwhWcod07ksWY
 +ApdGfII++0z8NeEMtIbNZOA3/KW+5XVQtVEn7DeN9SWSA/RYp68QWIWlO53uOa7HL8yZuO8
X-Authority-Analysis: v=2.4 cv=FvIF/3rq c=1 sm=1 tr=0 ts=6889f054 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=Wb1JkmetP80A:10
 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=VwQbUJbxAAAA:8 a=kfBI-rnbE6pO-dUj46YA:9
 cc=ntf awl=host:12070
X-Proofpoint-GUID: 3F8jAylhRu444TcDFuGSI_d9jz745dvp

For max_atomic_write option to be set, it means that the user wants to
support atomic writes up to that size.

However, to support this we must have reflink, so enforce that this is
available.

Signed-off-by: John Garry <john.g.garry@oracle.com>
Suggested-by: "Darrick J. Wong" <djwong@kernel.org>

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index b889c0de..8cd4ccd7 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -3101,6 +3101,12 @@ _("metadir not supported without exchange-range support\n"));
 		cli->sb_feat.exchrange = true;
 	}
 
+	if (cli_opt_set(&iopts, I_MAX_ATOMIC_WRITE) && !cli->sb_feat.reflink) {
+		fprintf(stderr,
+_("max_atomic_write option not supported without reflink support\n"));
+		usage();
+	}
+
 	/*
 	 * Copy features across to config structure now.
 	 */
-- 
2.43.5

