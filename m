Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96FF96FE2D
	for <linux-xfs@vger.kernel.org>; Mon, 25 Mar 2024 22:07:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711404461; cv=fail; b=YmG1A8RacXo/LDgr2ifAhkZKjM1CB+NMEWsYjwrjKezqa+ayvLlXzglT9Ul9I+98eVn4eHZ8rD5r0AKZG2KL7+gQXXvA2WaTQ1xmB3LlSRpvmjZDYEXtqVIVOPVJZJ6bY+MmzzNjcrznor/sEn+eYRhhaJd213oxLXCostjiYp8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711404461; c=relaxed/simple;
	bh=hiZvmiaQ7uWM86tdldzny1c/+nL7EVlicsVp3p0OCPc=;
	h=From:To:Subject:Date:Message-Id:Content-Type:MIME-Version; b=aokEqPCbaFrVIcFyHdjCPW1JunvXTCiWGpbXBo5eC1Uj5YTVo741jdZpO6544C4gsR1zzo2Tzq6xfUC1Z1McQarucnjiD3x4rAaSWyv9h4ipeXJ4pzJDkCpRtuDs9Wjk/PCmvKIjANB02OGKziNYddA7FyTV1lAUKyw1sqPDneg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=jtpK2RI2; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=xgPjvNuX; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="jtpK2RI2";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="xgPjvNuX"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 42PLG1YP002279
	for <linux-xfs@vger.kernel.org>; Mon, 25 Mar 2024 22:07:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2023-11-20;
 bh=kPSX6grpWDbVzDKbXNwWmrWXKvp4CyfsgaH4awSwVto=;
 b=jtpK2RI2fKG0xFfa11TIr3C1v6vp75nONG3c33wwToNznEhurgeGIDcCQSplt6j6dEsy
 Lwq6blHBq3y9oKEUxOjC/zuBB1RvTeOyfIqwsCSX2QuIG9UcmydX7vfjBiWbyCr+R8l6
 EIhmlcQWIvooqwHPJnDtOt91ZQvUfX80t7RB4PDeYkuW0JsKZkRtgaj8JDgm5G1WNqoi
 KBs+2dBzgczU5xvSFJyTuR4ks/v1erTqhvdFq8Z398J2oP164kidBR5Wmi6swr7nf8nx
 cZPnimElp8xn60l0nhOpKp0YShNkXyURCN6qVF1ApQXFUHgUl0o9qJgsdsOZIJzCWdFP Cg== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3x1np2btgx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Mon, 25 Mar 2024 22:07:38 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 42PKIonP015978
	for <linux-xfs@vger.kernel.org>; Mon, 25 Mar 2024 22:07:36 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azlp17012016.outbound.protection.outlook.com [40.93.12.16])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3x1nh64qx7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Mon, 25 Mar 2024 22:07:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Rl5335NftuWBA8IpQoe8ZEYOga2y1cYF8nHa7X62OzT9bfQW6RI9bPWWwjsREWhCB+QinsqtjEm9+d0ojrpPzOQi9Ltw4A2jEoR2EhXrcF4y+9IXscHS2oMyC4X+IwCLE6OrtFaD1YdXGjQBL/guP5KjroZ0lShB56Am5mbiBf+6tt8G3NeWsEUbIzjriLwHXiXTGRa0Sz9PdAjHvLiCdj8/zFi8yHjpSnQ4CirI3t+v+nNPk7eLh5+4+cbNJL7XBscee1+3SMFkjKQ12FFM7SoL9RzmsLyjS0dfR4kx6F9v1iMser8+savnWpekC1R2IYFu19VxmTBKFhAMhKdKmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kPSX6grpWDbVzDKbXNwWmrWXKvp4CyfsgaH4awSwVto=;
 b=cmUp9tNS7KuFzbw9oiK3boQK3ba6vsjy27oDoKONvzSPH5a3mEigferaoFnAL5uajIj2AlJf1XVIGUaQyJcDy9Kjpr+SJyT0uNVNS33PGC3K/DBJlZjXpUXjCiZkznc1wphjWsu0mKflrVNJfDxuGnwUL2pg7cu8X1eJPu5NffyMk4qw7JKOrMcYFuJFWFdgC/1yNP7jVtPXTXPgq5NI8R6oF5tY7YplOTl+OxR/WiQXjHI/T7Iq7uS/ohUnC5AWzJKNn9s7HOFVgalGtNAVloxzzvO36kmQdKWUkRguEZiv0DySJrt/rE7v+2ZckNXUublt1PlIBEnaA2Kaw60Z/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kPSX6grpWDbVzDKbXNwWmrWXKvp4CyfsgaH4awSwVto=;
 b=xgPjvNuXxtzF1d+quVM1NdL6ZSkCZzNgzaGKZ4sJDRJj1D9KkxCm8+TxEbUUZMNRyVKqebHTL/F02GSsrxXPUh4wwgnVM0eNXlmkPeJbueT7agnnLl9DG0UNp3dTWQNzNVb8DjCQvPrILWEXCc8s/vyf4Ms3IBiOIQ4lw+n9/Gg=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by DM4PR10MB7476.namprd10.prod.outlook.com (2603:10b6:8:17d::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.31; Mon, 25 Mar
 2024 22:07:34 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::404e:f2ff:fe2c:bd7a]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::404e:f2ff:fe2c:bd7a%4]) with mapi id 15.20.7409.031; Mon, 25 Mar 2024
 22:07:34 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 CANDIDATE 00/24] xfs backports for 6.6.y (from 6.8)
Date: Mon, 25 Mar 2024 15:07:00 -0700
Message-Id: <20240325220724.42216-1-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0010.namprd13.prod.outlook.com
 (2603:10b6:a03:2c0::15) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|DM4PR10MB7476:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	IT9kQ51urUWIdt3YHGkCU2sY9Kg5Ofb8yz5tOIwAe7Ud02v9ttCt+zz03MYqcRoPTjLoA6oRm/U4I3FRPPw4ENNQ7xTrn1IsXubLSdsSu+4f7NJZLhpfHfue9duGfD/VZq1y7lq/Q17+y0XEB/5TiuYK56HgfyHQPRkZHp7tq8m6vNeitRhz1vbYP5b4ac4UXUGa6zJzlTj57OE26pVWBLRUgEuzmUhzpR6GXtBYkDfOuA5aMaXks0e/+httHmxeNc62azk6M+913LtQgd1JuvttUEn44LHMVjwl6vAC8jnv7LFPeGFRHEMUHrEYGM4jaJkMEZJV5oyE9FJM35bu2+lO2ejvP4Rg4igdkjHTJdUCtdnEZ9Mx3CGyA+0T9vO8GBUQ8ER+c1Y+vUo2UVBo2zyHkSKXnzhk7GP4oF7vesLhqsxmErUY8FaIXOGcVHIydPOoxgAdRtGtbeihNhlF+JElanclD81zmiYWiLvODmDQMOVb/EgbLecy6vCuvDrV6C+9OHXGKAaoYIN3OMnq7cwYe7wbHQcTevgsgu2WI/GJKNsdw2Z6mQ1jnYwB9Ktq1xNuV6cZ1g3v49QTg4idngUItq2p59nLJLhubmYuZbuBRDREzxgud5CUztA3NUtA2fEHblIkIK7nPnBaTASjgOeLXZeSB+xLPDPlbDW+p6M=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?jPvndJtXGfjTV0MlOUiH0tHJ2O51elbhkVYitLFKFzpVmVnyqY001YrTJX2u?=
 =?us-ascii?Q?stXG5Rl9CpmW7TP/Q+6hNlasEUbMVTyMWRysEdikg/T0A3UFxo/TlfyPYA7C?=
 =?us-ascii?Q?eOsOSkz2emXL/32Ml7LXbDhDyYTIGMiuWXc+g5lYqTj1r2mE8DVQzAyTvKEI?=
 =?us-ascii?Q?TjmiW9ew8+HekzZoX4NLDOP8mP4o5PVa9O1XB2RDRhzb7o6PXd3vK/atZff6?=
 =?us-ascii?Q?e6W2n1RrqHLt2racNN1oGXrAFv+0SLf8Cx/P8CL78f7uqiHUya65X9NH/i3h?=
 =?us-ascii?Q?20E6rCZ7GZc4D5VxwcqPiBnrAJN/Kd+8bcVcnKTKBbLkPrtVORklvSHu5dSe?=
 =?us-ascii?Q?D5xsmsHf/lRcMiYX9e6I4i1b/U9zOktKmTkQKzBG0WvEMctrRqO1CvcudAC+?=
 =?us-ascii?Q?oMPB4gcaFT9pO2s5oyIV2gr+IS40ILqxbemiDw7LfroxK5lInQNG7/RkGAC9?=
 =?us-ascii?Q?x4U4WPFKSYtGm9DNLlrrbu6U8tQZFa/D/JoDMFg0PGtYw3+LhFkdW30OtAlq?=
 =?us-ascii?Q?qL/dKS5SiXWEUQBE8Y2XNN2NKjzaO86j9ur05IAtAOryXpb9Q1I7Fu3lff92?=
 =?us-ascii?Q?V1iwsl9Ek/jrC+2u9gfqCufJyOpwJOIp/cWMrujM0Wt2xc0+XI5zgC4p9B6L?=
 =?us-ascii?Q?1bLVundjsGyg5+ZlefgmAt6yx1lHx6YYjdo+7pC8aK8AD9kSgcVMuif8VxfL?=
 =?us-ascii?Q?GkXHJ6C+UVJsJxE+OYcggEOF9IsK4dHKzW3ZMqUnz7T7xMoGKUGAXVC2no7N?=
 =?us-ascii?Q?jjqFv3I30077L3SfopAV0CcTnOkG4M7togB+Reow6cmS9AMGy5wNOp2ywX+Y?=
 =?us-ascii?Q?CvPFsVogwKWoZKAAPeH9I/GGfQ6VFClBnU9Dc+4vuldLCSkO+k3DRuVU91tb?=
 =?us-ascii?Q?ILpZ4mRnuCb32tzcPiwExovHgQFL2FWK9raPStFKuZu4p93LBANMmq50/68w?=
 =?us-ascii?Q?snDD0hjpVTWG3Pk8b5Yh4EFax9CpwszzUNmcgjyh4rXFoxb12fgjsXmz3YiL?=
 =?us-ascii?Q?UG7iU8rMoa8uT6eYughVpTrHngdlAyKC4N9XFhUEwV2apw2xYTRzykNcR2rb?=
 =?us-ascii?Q?OZs9LoL0+e3sgYPvgDupx0KWY8S6oV4VRh1cNysQSXaQtNhHA/3rCZ5il7iJ?=
 =?us-ascii?Q?Dd9nA0mNvoLIAJevI+6nZbmLsaM7qRGI0NowK2edh/bHycVX0sA1Fq/tpWSk?=
 =?us-ascii?Q?LtnSs656N6qfvXKxcp51GcQud+0zwHBFAnrqP86lIyHb1vOWWmxCIlzzbd4S?=
 =?us-ascii?Q?9T800RHlnOl9hp4UBzHZDPj3IfmM/Qp5E/BRwAQXQDbmOY2suC2EZX/871/0?=
 =?us-ascii?Q?zYD0EL9T1chFD0nOYWHA3zY14YbeBYRxrvz06vVX8YAsCF5hP2FXNIHM6GrG?=
 =?us-ascii?Q?EyIvSZt9GKVYAN5tzFKoGQ/fjMEH0U2tn4n5bt/nvJ8nOD/yhD/i4dhpRyxn?=
 =?us-ascii?Q?+dORcDTbTP+ZyUtppCNZawJP3KkiVZ8UdWZwzD/BA6uXUA4Zq4P2bq1tHWRy?=
 =?us-ascii?Q?H6sGDABJbUde0lE5B2tnLjOh1SwsTGMSgXnAXJ8nKzaDdAOSDAkeLV7isGBy?=
 =?us-ascii?Q?NY8gfx6QDfkcr4P1K+oUyQYdtLps8R0lZGqSZyySYAxl1c60pSnACyNrf8Og?=
 =?us-ascii?Q?2om6aysU14R3ZnekQPoX57Anrwdpz4YWZfV69Vp8kQIWQKJ7Jx7trCgT0m+G?=
 =?us-ascii?Q?QO8qjw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	WV/dRLCtYXCpuY7HiYm3931eV5UcaOugdy1nehv4zo90nRLm7EZZbpQGKqvs0RIduX+V+5fwtrcxcvlhAEcXEEjW4X2uZoXBXDs34OOo/Qz2oUDCkH1B1lPV7FWaCVJJRH3YzXr+X3qc4YvTwn4cFtOg9kTw8NM0/EjygOPm7COCPZxPXQV2h6HohgqKejn9zx4yUFEwSZaXtG/0jFy9IuYZ7hFCggHWA+U8EZTQecTTddvIxOlcYCiUglzFSV1kA/69Xw8lRlv6oz5vMt6peCmOMiXyI0tEDR8QgalyXM4oDjQA6yPyAmwsi1E9EpSk84H9LzKH+LFj6N8ZB5Q5uW1NAqnlWMNjryLaEMa4XIiSi6R7BWjGIc5BkbbNgnmkJmT6qsolIV+9BkjQ/hNpgkKfVpyiCEe8CLNWOmVEi0VddsI5rhA1yuyj75Mv+KvHJMMyaz4byQTI3pXvRM4dzoBFofvs1zXaXGQZRKEntlJUlZtwuO2IBCX/XzdRsEWt5ADqgm9oj0fJr+LEP7MqnzolGXgkJdpyppjGQvxX+3tLRRenXfgeuvxGcEmGWfFu1JO/SLMF/hdh8mTUTDv+JO9KyYULCcjkbtgbyGpQJto=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 62286a0b-b8d9-4348-89ec-08dc4d17f969
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Mar 2024 22:07:34.5084
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kf0qhzsvv45tfyRSRvf/0/jH+s9ATbtDA6FgKUN+T7b3pYpyv8EgwCXOW+AQD+wbS5Z4eYAlz/aN+3QVFHCBcqfbmW6txILCSKVCzV3FJyM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB7476
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-03-25_22,2024-03-21_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 phishscore=0 mlxscore=0 mlxlogscore=999 spamscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2403210000 definitions=main-2403250137
X-Proofpoint-GUID: 9jC5mp3uXVIn5x-DHvN13I5PyXk78P92
X-Proofpoint-ORIG-GUID: 9jC5mp3uXVIn5x-DHvN13I5PyXk78P92

Hi all,

This series contains backports for 6.6 from the 6.8 release. Tested on
30 runs of kdevops with the following configurations:

1. CRC
2. No CRC (512 and 4k block size)
3. Reflink (1K and 4k block size)
4. Reflink without rmapbt
4. External log device

Note that patch 1-2 are backported as dependencies of patch 8, 10, and
24.

Andrey Albershteyn (1):
  xfs: reset XFS_ATTR_INCOMPLETE filter on node removal

Christoph Hellwig (1):
  xfs: consider minlen sized extents in xfs_rtallocate_extent_block

Darrick J. Wong (16):
  xfs: move the xfs_rtbitmap.c declarations to xfs_rtbitmap.h
  xfs: convert rt bitmap extent lengths to xfs_rtbxlen_t
  xfs: don't leak recovered attri intent items
  xfs: use xfs_defer_pending objects to recover intent items
  xfs: pass the xfs_defer_pending object to iop_recover
  xfs: transfer recovered intent item ownership in ->iop_recover
  xfs: make rextslog computation consistent with mkfs
  xfs: fix 32-bit truncation in xfs_compute_rextslog
  xfs: don't allow overly small or large realtime volumes
  xfs: make xchk_iget safer in the presence of corrupt inode btrees
  xfs: remove unused fields from struct xbtree_ifakeroot
  xfs: recompute growfsrtfree transaction reservation while growing rt
    volume
  xfs: fix an off-by-one error in xreap_agextent_binval
  xfs: force all buffers to be written during btree bulk load
  xfs: add missing nrext64 inode flag check to scrub
  xfs: remove conditional building of rt geometry validator functions

Dave Chinner (1):
  xfs: initialise di_crc in xfs_log_dinode

Eric Sandeen (1):
  xfs: short circuit xfs_growfs_data_private() if delta is zero

Jiachen Zhang (1):
  xfs: ensure logflagsp is initialized in xfs_bmap_del_extent_real

Long Li (2):
  xfs: add lock protection when remove perag from radix tree
  xfs: fix perag leak when growfs fails

Zhang Tianci (1):
  xfs: update dir3 leaf block metadata after swap

 fs/xfs/libxfs/xfs_ag.c            |  36 +++++++--
 fs/xfs/libxfs/xfs_ag.h            |   2 +
 fs/xfs/libxfs/xfs_attr.c          |   6 +-
 fs/xfs/libxfs/xfs_bmap.c          |  75 ++++++++-----------
 fs/xfs/libxfs/xfs_btree_staging.c |   4 +-
 fs/xfs/libxfs/xfs_btree_staging.h |   6 --
 fs/xfs/libxfs/xfs_da_btree.c      |   7 ++
 fs/xfs/libxfs/xfs_defer.c         | 105 +++++++++++++++++++-------
 fs/xfs/libxfs/xfs_defer.h         |   5 ++
 fs/xfs/libxfs/xfs_format.h        |   2 +-
 fs/xfs/libxfs/xfs_log_recover.h   |   5 ++
 fs/xfs/libxfs/xfs_rtbitmap.c      |   2 +
 fs/xfs/libxfs/xfs_rtbitmap.h      |  83 +++++++++++++++++++++
 fs/xfs/libxfs/xfs_sb.c            |  20 ++++-
 fs/xfs/libxfs/xfs_sb.h            |   2 +
 fs/xfs/libxfs/xfs_types.h         |  13 ++++
 fs/xfs/scrub/common.c             |   6 +-
 fs/xfs/scrub/common.h             |  25 +++++++
 fs/xfs/scrub/fscounters.c         |   2 +-
 fs/xfs/scrub/inode.c              |   8 +-
 fs/xfs/scrub/reap.c               |   2 +-
 fs/xfs/scrub/rtbitmap.c           |   3 +-
 fs/xfs/scrub/rtsummary.c          |   3 +-
 fs/xfs/scrub/trace.h              |   3 +-
 fs/xfs/xfs_attr_item.c            |  23 +++---
 fs/xfs/xfs_bmap_item.c            |  14 ++--
 fs/xfs/xfs_buf.c                  |  44 ++++++++++-
 fs/xfs/xfs_buf.h                  |   1 +
 fs/xfs/xfs_extfree_item.c         |  14 ++--
 fs/xfs/xfs_fsmap.c                |   2 +-
 fs/xfs/xfs_fsops.c                |   9 ++-
 fs/xfs/xfs_inode_item.c           |   3 +
 fs/xfs/xfs_log.c                  |   1 +
 fs/xfs/xfs_log_priv.h             |   1 +
 fs/xfs/xfs_log_recover.c          | 118 ++++++++++++++++--------------
 fs/xfs/xfs_refcount_item.c        |  13 ++--
 fs/xfs/xfs_rmap_item.c            |  14 ++--
 fs/xfs/xfs_rtalloc.c              |  14 +++-
 fs/xfs/xfs_rtalloc.h              |  73 ------------------
 fs/xfs/xfs_trans.h                |   4 +-
 40 files changed, 492 insertions(+), 281 deletions(-)
 create mode 100644 fs/xfs/libxfs/xfs_rtbitmap.h

-- 
2.39.3

