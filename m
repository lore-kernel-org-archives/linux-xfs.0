Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A078C433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Feb 2022 13:03:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234745AbiBXNDj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 24 Feb 2022 08:03:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234723AbiBXNDj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 24 Feb 2022 08:03:39 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 414DE20DB22
        for <linux-xfs@vger.kernel.org>; Thu, 24 Feb 2022 05:03:09 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21OCYEEP007287;
        Thu, 24 Feb 2022 13:03:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=np4vEouUBcKDYiEXIJB9NXe2liiMbuFLFivNEnKYSmo=;
 b=UqNCpqdsINZGIQr8gncwvOjY1x56sOK9AUxaRyPqONrCu0uezP6cabbOAprlCtjwX3p/
 3q5oip9SaAYpZ4Jo2a2aLWvEEfPdcCPvlOqJagfU6kSD6yiR0JZY6AbeN2itE8RIiWIY
 JDpSqmv0qfGmr1mGahrloHK/TDwBcI/yABGetFoQoeUTT5VbxJhwHzgbIWQnHVYKvBgp
 imajXf6hJdhM7zU2tUNwXG5EeVsp0l0mWd8OsMjvLcv3Csn3Em0i96qYcHTWYRZc/H6t
 H3M11X2/S0aWy4PAfzo/8kpRGv+Uu4B9110l1q1Lb0fYtlU5j9c+w4SOw2xbK+oxQUkT AA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ectsx7b2n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Feb 2022 13:03:02 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21OD0xjP002535;
        Thu, 24 Feb 2022 13:03:02 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2103.outbound.protection.outlook.com [104.47.58.103])
        by aserp3030.oracle.com with ESMTP id 3eapkk41v4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Feb 2022 13:03:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dIKkyMrUF88E+Xq7bWtTea3mw+lTvdozlsxS8jErx3xF32f4DRx07hlSuptOV55sJv8qARhh2BfWfXFbXmQtHCMfE4fCPO49MQanLeHkFhWBE0lKf5igqOiMBLJ/0DjMHnjwZjHzRosweqr7oXYaJyOA9RkcM5AL8OtSoMAWeaNdJ7Ntzhrl3YR++xPE1F6IvVYc+kC/p328H86zgFvzrto8ZeyJQr1yUaRb2PaMZw9rQovnwv/Fqhd0Gtjdo+Mq8BZ5ogmRJ9f3VlHDO+ZK+gQZlx8NAgc8QxqsyEobuMuQVBxrfC61SVN9qdreqR1QzBCPjho7DsfgixtIul5Twg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=np4vEouUBcKDYiEXIJB9NXe2liiMbuFLFivNEnKYSmo=;
 b=Vv741hzvSND9MlyOoGcC9EGVfpzFCpGRerqNOJhB3wJ8g6ZPF/abqDvaXozt0e5JfsHSY954Oevz9WdS6F+0vBdMjlRyhkHRDpAXWR6MUyU1ex2xVSg6BpwAikijaPi4lPHIkQmUBGihYuXZk22VrY6mOi0IsyyN/dVjlNYp9cFi168l07WdgbmWq8wTEiIMeR+DzkWWD2yyVgl4LqsoisqxMzBPPpyhr/MEVyJJ/EewJ9M/AVjZmFDpYwnQWnQjabkg6o0txRSDHSVq3Ogy77ZGQsGWwsZr6WTWI56DT6M36Op4UiQOLvUQu4WT4eGpHxIyItD3Bl3zNkfEooGO4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=np4vEouUBcKDYiEXIJB9NXe2liiMbuFLFivNEnKYSmo=;
 b=GL+ecwsRhs4P5gJao9u2eEHS8z404JmRd2kiR0VIkCFLFvFzlC545twswFmiQarDv5uKZGy4qjrZ8vohtkUkBqiGKT/RDhv6jkjs7vWSJqXL47QqUSVpaygYQenSDC6/cr3xpDUvcvkSe7h/Yrzzd+SM1TIMoaT4Q/hyYNUcCF8=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by DM5PR1001MB2172.namprd10.prod.outlook.com (2603:10b6:4:30::36) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.24; Thu, 24 Feb
 2022 13:03:00 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::46f:d52f:e31c:b552]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::46f:d52f:e31c:b552%7]) with mapi id 15.20.5017.024; Thu, 24 Feb 2022
 13:03:00 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        david@fromorbit.com
Subject: [PATCH V6 11/17] xfs: Introduce macros to represent new maximum extent counts for data/attr forks
Date:   Thu, 24 Feb 2022 18:32:05 +0530
Message-Id: <20220224130211.1346088-12-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220224130211.1346088-1-chandan.babu@oracle.com>
References: <20220224130211.1346088-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR01CA0009.apcprd01.prod.exchangelabs.com
 (2603:1096:4:191::18) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 32eba017-fcf8-4787-f83e-08d9f795fc20
X-MS-TrafficTypeDiagnostic: DM5PR1001MB2172:EE_
X-Microsoft-Antispam-PRVS: <DM5PR1001MB217232B8DDA12808C6FF08BAF63D9@DM5PR1001MB2172.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6uEJ58nBf+noreY/oN35+L7c283qQXDhPgEnJzt1xdr/jJitxdl55B5XGb8lLUMl6fNw0JzM1ljzWYCb6+BXk4ISBbWK9z6RrRXG9MhHPRFL31+NiVQ+L73LLI+MvEQy+AtKL1NnLjkI78K4I721C2clMF528E5aCU0I27h90qXRJ97YQzddzNfUsZz5rYTqgRm6e2KYqXIyRsRQSfuJUUPZDkxfhFGjUkShAHbGc51Yx2kmbxzrOk4Ao4bd1lSHus4CahUNUeF8WfNBf4Vxp00tcKUns9h4x8rixI+1/M3jZ/lKlN0w+1PgVkfpFMDBB2RSj9J9IqLuvjzAmsNHJGKutCato2LySKVz4o4kZx5O3xB2kalGu2IoV/8U84HaEsS0z5/L4mh6uVBqxHAaOmqynvHVYE4CI4lKCKIxW3dWFAmEhOpjBT3WDsRfeSiVi3z9t7VaePHFe8VvTi9//RiXNEyYix8ANYrONNg51nSuLAyRPthJUWgvqG9/wpSSNxzllpGPK5hTYkhXen0CATp4i/cUmYZ4+LcrRRDxSIw0k81iB8zp/qx3M3TlehLNmZE3Y+Bcti3FP8BW28YAEcVvTBUN7MEJ0z9tlWu+MJkvPMFssbqeXugZDE4sThzrYkfhvV+XktDAqmXx71pnakoiPolgWjcPvA5lOiq7Uag0CKkHWkLAjktA4ZTBKTSXJ9TtE7HF4lZSv0trdFg1Jw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(8936002)(6916009)(4326008)(508600001)(6512007)(316002)(66946007)(66556008)(38100700002)(8676002)(66476007)(5660300002)(38350700002)(6506007)(52116002)(86362001)(36756003)(2616005)(1076003)(83380400001)(26005)(186003)(2906002)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?tDmPLYhz3nFHOeL+HhUoqhLxKtsPe3TG9ho9I+Ln2IYG73P9tuVqeMtjxMID?=
 =?us-ascii?Q?6FsVuU8DXBeeLk3HFVVvzoV0eaCmQGAAn/R6rvQ/IoY6q4nLK9tQVEiHMiUq?=
 =?us-ascii?Q?3Kd4qt/VfWMYx3D12upyz2smOGG0FYfUUyOPrXdL/6XvkmpZ1k4j9su1d9eo?=
 =?us-ascii?Q?et1w46SO2cFEJ9L7n78pGfJ3ZyhDUlkK+G/tmQttj35DiRddZyX6cGEp1I+p?=
 =?us-ascii?Q?XVjkYYKoWQzcumPDjKYBy0smXAuMcB7mcNaWxOcL9XuG6SbktxreU9617Q8H?=
 =?us-ascii?Q?UOatymkM3YiNtQgbudgOiwUQ4tLDdRMNjCqTvIjrUpLiYzMPjEWgSHValAaJ?=
 =?us-ascii?Q?dcG+R99mnuVY9iKMSK0TMTSOrWc4yyYDFZ5+YXASmhcY0+lGV3k3bDPSwSHq?=
 =?us-ascii?Q?Q9b/1NJmYNoDRfAX1vNaPuwWHFEUSgsTWZNG2UluooG8dZ+BZIWwsfG742zK?=
 =?us-ascii?Q?Jl2t+K96t9dPHLGlG8nhrWWBOchdk7nKIc7FwaIDvRXNb50KvnHaxUrvSar7?=
 =?us-ascii?Q?5vfemzA1pX0YAN7Y94hKC+EaYa+QmpQ9bWGI2z9z7r/cEUJ4ht1Kld/hwFmr?=
 =?us-ascii?Q?PJ7XJx8NzxS8gYJJwZT4erxbHaQKS7SCIlwk7haZT616jKtfHiZQ2jF1DQAs?=
 =?us-ascii?Q?Z2wqy7cfsD3Cj06nsdKKuevV1QU2H0+zIbPPXTAKxJMu80Rl0GWEBNE23gbk?=
 =?us-ascii?Q?/Rw0PRG93o9SxLZfAGAq4m5YMdv3y9tJZVrVOMlvtvgYR54+g33Ack59C4nI?=
 =?us-ascii?Q?0neDKxvxNtK6tnXrXju5aNqU94+4gV9Dd/aE14M5D/EgzQVqGWgBahjA29ER?=
 =?us-ascii?Q?gvikavJqARx89Hbj+6U09JmZi/JxuQjPkIWEifOfu2+m4T2D+swCoU0xzKVw?=
 =?us-ascii?Q?R2l1DNgdTch6vHSv0lhptVBllL5WModS4VlpFl1j9kIqXhHKHPhDLKLIEqzn?=
 =?us-ascii?Q?JciiEinR/XbJn70o4s9TPNaSeVWpQHv2yTapfxyFt79gBKCZpAwODi7GWAzv?=
 =?us-ascii?Q?51h+7gUg4sZ+q1ix3Muxsp9C7uu4OUwwsI8LsE4hL3In7tysDLGdeV3lfhUC?=
 =?us-ascii?Q?6ZxPWHqgjhzfDWyWkD1SzuU62y1TIFIi8E0t0jOczI5HEtMeq+48bIii13bD?=
 =?us-ascii?Q?vm+T842/QErkWLsmnYkWWZgNc3diNfU7Z0gBAXYxhNXJDLmq9SSvhUB5mO/2?=
 =?us-ascii?Q?rhSWjkhMqDNLDhP9hQUn/lSJGGyOSmRrTT3UEPgVRhPf84652OB/M1p7mgX6?=
 =?us-ascii?Q?FFhJxrpzT4mluU0C4N4QHXotuSFEQ2uhiLAUo+sF1UAe9GX3kENkrzzaYSxk?=
 =?us-ascii?Q?rUZyWQnBQJueBJbcPi6E2jdynrhMh5uBL6mK/k/NKa1wab/eYvV9xbTg3426?=
 =?us-ascii?Q?Nh1xIdQYR2m2VmT4JTWjNHgGSyNpe1ncTarjirsXlQog+x8g2Anhim/mugqz?=
 =?us-ascii?Q?V+Lgd30edWTf3rhFQwbr1tQe9l58S6DUcBk4YY3xizw7U/L7Y0ObBQu4oivI?=
 =?us-ascii?Q?nsHY58IVU0lNeTGC7n0eIKLic6lyHrQkM8SUq5IZUyBz3LBAffknuAybzYZ0?=
 =?us-ascii?Q?VSQEsKYlF9nysoO5lxSnW1rNnScveq78npnxFf9hXFajSyY+RtmCjnfzx9e3?=
 =?us-ascii?Q?0jdsyIwBgYCGuMtJY/vD2DU=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 32eba017-fcf8-4787-f83e-08d9f795fc20
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2022 13:03:00.4666
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JLLw0Huqt/zu1zRyVj0Unq8GMOvxXgcmjDEbValtYH/N2DxolzSnnHNB/hc+MU6kTLu3Pw78ci4NNgU3aih7Ew==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1001MB2172
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10267 signatures=681306
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 mlxscore=0
 spamscore=0 mlxlogscore=999 adultscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202240078
X-Proofpoint-ORIG-GUID: M6L6Zh22u2Hu6GZ47rcQtyXE265sU2EW
X-Proofpoint-GUID: M6L6Zh22u2Hu6GZ47rcQtyXE265sU2EW
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This commit defines new macros to represent maximum extent counts allowed by
filesystems which have support for large per-inode extent counters.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/libxfs/xfs_bmap.c       |  8 +++-----
 fs/xfs/libxfs/xfs_bmap_btree.c |  2 +-
 fs/xfs/libxfs/xfs_format.h     | 20 ++++++++++++++++----
 fs/xfs/libxfs/xfs_inode_buf.c  |  3 ++-
 fs/xfs/libxfs/xfs_inode_fork.c |  2 +-
 fs/xfs/libxfs/xfs_inode_fork.h | 19 +++++++++++++++----
 6 files changed, 38 insertions(+), 16 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index a01d9a9225ae..be7f8ebe3cd5 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -61,10 +61,8 @@ xfs_bmap_compute_maxlevels(
 	int		sz;		/* root block size */
 
 	/*
-	 * The maximum number of extents in a file, hence the maximum number of
-	 * leaf entries, is controlled by the size of the on-disk extent count,
-	 * either a signed 32-bit number for the data fork, or a signed 16-bit
-	 * number for the attr fork.
+	 * The maximum number of extents in a fork, hence the maximum number of
+	 * leaf entries, is controlled by the size of the on-disk extent count.
 	 *
 	 * Note that we can no longer assume that if we are in ATTR1 that the
 	 * fork offset of all the inodes will be
@@ -74,7 +72,7 @@ xfs_bmap_compute_maxlevels(
 	 * ATTR2 we have to assume the worst case scenario of a minimum size
 	 * available.
 	 */
-	maxleafents = xfs_iext_max_nextents(whichfork);
+	maxleafents = xfs_iext_max_nextents(xfs_has_nrext64(mp), whichfork);
 	if (whichfork == XFS_DATA_FORK)
 		sz = XFS_BMDR_SPACE_CALC(MINDBTPTRS);
 	else
diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
index 453309fc85f2..e8d21d69b9ff 100644
--- a/fs/xfs/libxfs/xfs_bmap_btree.c
+++ b/fs/xfs/libxfs/xfs_bmap_btree.c
@@ -611,7 +611,7 @@ xfs_bmbt_maxlevels_ondisk(void)
 	minrecs[1] = xfs_bmbt_block_maxrecs(blocklen, false) / 2;
 
 	/* One extra level for the inode root. */
-	return xfs_btree_compute_maxlevels(minrecs, MAXEXTNUM) + 1;
+	return xfs_btree_compute_maxlevels(minrecs, XFS_MAX_EXTCNT_DATA_FORK) + 1;
 }
 
 /*
diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 9934c320bf01..d3dfd45c39e0 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -872,10 +872,22 @@ enum xfs_dinode_fmt {
 
 /*
  * Max values for extlen, extnum, aextnum.
- */
-#define	MAXEXTLEN	((xfs_extlen_t)0x001fffff)	/* 21 bits */
-#define	MAXEXTNUM	((xfs_extnum_t)0x7fffffff)	/* signed int */
-#define	MAXAEXTNUM	((xfs_aextnum_t)0x7fff)		/* signed short */
+ *
+ * The newly introduced data fork extent counter is a 64-bit field. However, the
+ * maximum number of extents in a file is limited to 2^54 extents (assuming one
+ * blocks per extent) by the 54-bit wide startoff field of an extent record.
+ *
+ * A further limitation applies as shown below,
+ * 2^63 (max file size) / 64k (max block size) = 2^47
+ *
+ * Rounding up 47 to the nearest multiple of bits-per-byte results in 48. Hence
+ * 2^48 was chosen as the maximum data fork extent count.
+ */
+#define	MAXEXTLEN			((xfs_extlen_t)((1ULL << 21) - 1)) /* 21 bits */
+#define XFS_MAX_EXTCNT_DATA_FORK	((xfs_extnum_t)((1ULL << 48) - 1)) /* Unsigned 48-bits */
+#define XFS_MAX_EXTCNT_ATTR_FORK	((xfs_extnum_t)((1ULL << 32) - 1)) /* Unsigned 32-bits */
+#define XFS_MAX_EXTCNT_DATA_FORK_OLD	((xfs_extnum_t)((1ULL << 31) - 1)) /* Signed 32-bits */
+#define XFS_MAX_EXTCNT_ATTR_FORK_OLD	((xfs_extnum_t)((1ULL << 15) - 1)) /* Signed 16-bits */
 
 /*
  * Inode minimum and maximum sizes.
diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index 860d32816909..34f360a38603 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -361,7 +361,8 @@ xfs_dinode_verify_fork(
 			return __this_address;
 		break;
 	case XFS_DINODE_FMT_BTREE:
-		max_extents = xfs_iext_max_nextents(whichfork);
+		max_extents = xfs_iext_max_nextents(xfs_dinode_has_nrext64(dip),
+					whichfork);
 		if (di_nextents > max_extents)
 			return __this_address;
 		break;
diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index ce690abe5dce..a3a3b54f9c55 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -746,7 +746,7 @@ xfs_iext_count_may_overflow(
 	if (whichfork == XFS_COW_FORK)
 		return 0;
 
-	max_exts = xfs_iext_max_nextents(whichfork);
+	max_exts = xfs_iext_max_nextents(xfs_inode_has_nrext64(ip), whichfork);
 
 	if (XFS_TEST_ERROR(false, ip->i_mount, XFS_ERRTAG_REDUCE_MAX_IEXTENTS))
 		max_exts = 10;
diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
index 4a8b77d425df..e56803436c61 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.h
+++ b/fs/xfs/libxfs/xfs_inode_fork.h
@@ -133,12 +133,23 @@ static inline int8_t xfs_ifork_format(struct xfs_ifork *ifp)
 	return ifp->if_format;
 }
 
-static inline xfs_extnum_t xfs_iext_max_nextents(int whichfork)
+static inline xfs_extnum_t xfs_iext_max_nextents(bool has_nrext64,
+				int whichfork)
 {
-	if (whichfork == XFS_DATA_FORK || whichfork == XFS_COW_FORK)
-		return MAXEXTNUM;
+	switch (whichfork) {
+	case XFS_DATA_FORK:
+	case XFS_COW_FORK:
+		return has_nrext64 ? XFS_MAX_EXTCNT_DATA_FORK
+			: XFS_MAX_EXTCNT_DATA_FORK_OLD;
+
+	case XFS_ATTR_FORK:
+		return has_nrext64 ? XFS_MAX_EXTCNT_ATTR_FORK
+			: XFS_MAX_EXTCNT_ATTR_FORK_OLD;
 
-	return MAXAEXTNUM;
+	default:
+		ASSERT(0);
+		return 0;
+	}
 }
 
 static inline xfs_extnum_t
-- 
2.30.2

