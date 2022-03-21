Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FCF5C433FE
	for <linux-xfs@archiver.kernel.org>; Mon, 21 Mar 2022 05:18:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344374AbiCUFUF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 21 Mar 2022 01:20:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344381AbiCUFUE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 21 Mar 2022 01:20:04 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E977344C4
        for <linux-xfs@vger.kernel.org>; Sun, 20 Mar 2022 22:18:39 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22KJYA12000642;
        Mon, 21 Mar 2022 05:18:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=FpIXWJJaj4jM5kdDoakQknAlYcf1/gZw2eTO/ARe4Qc=;
 b=hTGC998ohR8tSdtfGDNU0MCO/fo2Qx8xjotKv5+0YYry7zZ+U8PyBzDfH6EqcZTIkKfC
 c6sLDMcz9Ykecec36A/q0CNTWIht/JPVbJCOpi5ZKupDxcGSRd7uIqzRzqx2yfileu6t
 WrqGVbead3GnlilypqHfZZfpN7k1sVTIRPYw2KI3GuwG+q8ZnR3pMgrsjtDdIrOVbXBV
 1srATg93/79ASHs/NKepxe3K5b1Y2YYwlcs9NiD8u3kkEzOyJqKMYQU23yWEycYwkbXj
 Um+PQX+4MFpEPzQuqN7y+1YgUtIIbwxrVT+uTLNt0MEwD1BW9rWrMR6c5oiCkGdEW8qR 9Q== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ew72aa3j7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Mar 2022 05:18:35 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 22L5GdOo155969;
        Mon, 21 Mar 2022 05:18:34 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2042.outbound.protection.outlook.com [104.47.56.42])
        by aserp3020.oracle.com with ESMTP id 3ew70096kw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Mar 2022 05:18:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OtEYLTSkW0eVuNPvbsGmHyTMbYfK2DjIdXKzLK5KxAXoEYCiMgOphDhLpOjGP0aeKfAOTt3sTv1ARD89z49OvtxhTdbD/WfdtY/ZVZ5OLEu9TWV6fsEF2vQnaR8bFKDPXWCzWCLpzl8cfbivjVtbnFfN90Ruc6PbFD7pGzyOeIeyzLEAfOazEwR5j8oMxGIJ0y5+CV1SBQjozKSf+6RVNNQ+L6nrgb+31byPerG0uRmYaArev2FceqemDCsqMiDqe09sDxWcCY2an2ItuE9vhQ75DOS5qJF01Cj3qMSvc2XKFvspmmuJAdpVcehCbJ3dmQHDjc9xta6qobHqQWxEqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FpIXWJJaj4jM5kdDoakQknAlYcf1/gZw2eTO/ARe4Qc=;
 b=PcJrFAJhGS0j77aMzKWnNTRRiTTLUiN2beC6fW5Dev1XkN9A8+8iUbAvNM8EDXdAfpI0Jz7FaNdJhr4gFGc3+U4aQ7L0g+zuf9LXgWU/xmu0rOC5wFzlGp7g//9sOMgyGKKunoA/ji5awZexKYuyiWUDSU2Q/apO6aMrGU2PLvKC0BeSt5QgLNcM/xaxhaubHfYLj7sBX57yRvIQrpeFNPpP7IrZcqsODJ9N2RTr70yjRLPyF8Smol6SdP5q5XjRTGDa5CQapkE/0evvu7VWuQ1thdAIw6cs1Qrvtpad3fzQJ4NxpzqoWGTlnpIlckrjbfFMgHBhzM5S3H21tkKKTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FpIXWJJaj4jM5kdDoakQknAlYcf1/gZw2eTO/ARe4Qc=;
 b=gpzw/2mQGf2/Fep9DQw16gJWK+uungqWi9qBkkRqb00FlATRZp+Ytgcq4180Ji0hkUiX5hj8F3xFlrqvpQriNG7SIQdZRwHVxNvuOt0GFtvfHmcAzjcUV+VurlUlF3c4VlClDb1hPCZKmR+qvlZJ1bx7s4o8+kKLa7PXyEDIpCU=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by CO6PR10MB5537.namprd10.prod.outlook.com (2603:10b6:303:134::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.22; Mon, 21 Mar
 2022 05:18:33 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::b0b4:e94f:82df:234f]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::b0b4:e94f:82df:234f%9]) with mapi id 15.20.5081.022; Mon, 21 Mar 2022
 05:18:33 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        david@fromorbit.com
Subject: [PATCH V8 10/19] xfs: Introduce XFS_DIFLAG2_NREXT64 and associated helpers
Date:   Mon, 21 Mar 2022 10:47:41 +0530
Message-Id: <20220321051750.400056-11-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220321051750.400056-1-chandan.babu@oracle.com>
References: <20220321051750.400056-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYCPR01CA0120.jpnprd01.prod.outlook.com
 (2603:1096:405:4::36) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 85328924-5a90-4236-dc93-08da0afa3e54
X-MS-TrafficTypeDiagnostic: CO6PR10MB5537:EE_
X-Microsoft-Antispam-PRVS: <CO6PR10MB55372EF25516AEC1A240959EF6169@CO6PR10MB5537.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nviOJ+PWj1HESHgrZOAQs28gxYyaxrDrLik1MUt+HYJSucRpWUA48L/5dsjaZyDB6Zwj/JaATRxxXQlgKNyq61z1H1mClu/sNmSDVLCEO50WwAgulctotxZZXLiAb85Gq9D1s90vNtKvvSw+nXQ6r/KVDGnvXrE667hKVQy4CrfMrF7tpZ03qwF9IPb4sUqrMtWqTM5qTQwmTMlCulwW/ziKJlhkcPTK9BPlkB2/rWkpc7bE013auneXOgNIytJl9Vy7BPYvJ/0fJVflpTENbpOJff82aPq/gC00tkiIJ3teNPZvaraP08TngLwihOC5JzagQzuB6Jbn5XZiXn2Pxvujpa4A79nV6c/3EEcrFkDiGqGx4kL/OeqYsTC3tiB5rBpcT19b2awdhL5ip0dNFmrsXV5cZ7MPtHQ+IGWxIctvbxWjDd0rYVpSgG94Vzasuu9XK+JoOVziK1EsYXasl0n8zmeq2s0sQnhKh9hQD2CYLhGnw1+eojjF/JN+V7BDkj4apT9PIcbS3OLw/CBE1ePv/cAq41UUXO9EwTzHXvPg8+oi42i8zrVXA9L+lJmZiqld/h9juU83ZfAP+rnvhn5rqikjwHVHo4OjDddRQn1nzp7OrcqfWMBjR+q66ajPJ5rG2p+lwVZFYtTLX15ccLRsATg3/JFd3lYwNBFjseRZDMbuHsiqMgi8azllL9OK3PEvbjbtN9iNBk8Fsy+FzA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(38100700002)(38350700002)(2616005)(4326008)(66476007)(66556008)(66946007)(6512007)(6486002)(86362001)(6916009)(8676002)(508600001)(316002)(26005)(36756003)(52116002)(5660300002)(8936002)(186003)(6506007)(83380400001)(2906002)(1076003)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?496n6WUZZi8mIIrZxu0jjcyOBTsgpqWlH+AwWCwQDIHClNLpK/Vbi8S0Cjr4?=
 =?us-ascii?Q?pgQ7j4B1ZwT3GIBd7mdaU+74q3QcRpOFRUCGUYeCMtriy1hB9wSYHzIfBWHy?=
 =?us-ascii?Q?ngYZFf5H775RtOvFVZ0BneHv7owwRBq2DIWRWMKT8VXkaGk4XxEdR/NFHJ5u?=
 =?us-ascii?Q?o2CYy7MzY/YHsVS29HtNFk1s9lRFu3/C3wIN1oeOlBly4u/d1cQFk3T9Ek45?=
 =?us-ascii?Q?sBoRBJocjwUzJQGvUl7iAPbXKRR6J8Yq6qINAYik3VpvqwJRiF8ng2w+jx7p?=
 =?us-ascii?Q?lVmzY2vhVW5/xhqh5kQ6Ox/0PzhQ2vZn4kUt4VgV9EzFLYbXpLlB/kbro37g?=
 =?us-ascii?Q?eigAMFzP2e0H0srswGNhKSWGjKtWkbr10z70vU1AtburjK6ER6gD0YQVgctJ?=
 =?us-ascii?Q?1w0ftypyg9krIHlzi2Ili7Iwxu5yNoU+lOvRMMnvXQn0uBdNe6Awp4ePcFQM?=
 =?us-ascii?Q?NqB0MVMgnoXAWVSXku+VpuQNQbrwit0iFqO5ByXwQJnzaCRWGn9iLFxSonJY?=
 =?us-ascii?Q?ZdLosr8FQkQNzKht3Y0ZCOIgsghorPCRVQMTFbQ16NgQJG3alOdn2phyqkPL?=
 =?us-ascii?Q?32iJlbmn+3wxyO2oOK7ZYifJKSVDnyn9Fzq+pZxLutJb+1oM6Z+mqTfQgwB6?=
 =?us-ascii?Q?bpk1u0Y4Bl4vgT62KHC09uGQWKZsbSVuRIGtpJsmZYwMvNmf6plrn7hMSWTY?=
 =?us-ascii?Q?q4z9KQEQ0G9AzWaH2BSfhaLOGGRiRgMod/U2o1nD3+39/erJuQQwcVyjBpJN?=
 =?us-ascii?Q?i+gBVcKEYcfjXvx765FDzHiJtns9aMT7jSnsFYEWxcdS5KsDgqcaTkJENrnA?=
 =?us-ascii?Q?kve5WTo3+v2Z8xNSMFa9sQ/JX8HGKuzBa0u/c7V9r0Pc9tdaEyyaWKiEoIo6?=
 =?us-ascii?Q?k1LwQlo+URbI6RVqKmX1TDSGm1phYyv0REedtMCQmmQljSkGyXnJGBt6/hcR?=
 =?us-ascii?Q?FtF2ZuXjrW0rU+zfx7BNPcOuPN7GMy+UoymQ/WJtHUOMLeMywSfEy9CwI1Xo?=
 =?us-ascii?Q?+hEM7FizE62q8g7nMLMRmDcem2VrBUu83RoIUgOcJN9SMHrF6x5ilfqPPBPO?=
 =?us-ascii?Q?5xWmDSowxJkBaNbfQhTAxiI3EKZZOV+Erisr4BKEgj53RAdsgmyEhi/OCzZA?=
 =?us-ascii?Q?mYShjkR9uckhKB+VipMo0LbIF5ubdqFEZqh34VGfldwuq0pmPqE72CFejTRL?=
 =?us-ascii?Q?7GQodXMRodwYg2OmSHStBEljcKAiUFDaNMksCbms7XipxH3bbSrGa3sDh8G5?=
 =?us-ascii?Q?QqRThS+3RHuAa5vJFi3kQ9UuLiZYQ8oywJFmfd6/ETuXTt+ggtNU7fzrI2fD?=
 =?us-ascii?Q?zUdlp5nSKKCiSnBKaFN6S+zx2MrVDeNhwpTUWfF6y5qLDghg4CjJcwTzj9HM?=
 =?us-ascii?Q?C44VXajIUU8dNC63rJ119AzsmZtLtoEKITxjvxYOXd7sskWsyBTkp7z85r9Y?=
 =?us-ascii?Q?v6N3yx47i6y9GcfwZWYJWTn9tq5U8K5DMn9LDnRJJgxvDXjd6iqp0A=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 85328924-5a90-4236-dc93-08da0afa3e54
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Mar 2022 05:18:33.1915
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5rA7JVXUk9QYFsj20soDzoTfUihSioWBcsM6aEuRSpQL0zuyvDon7nsgqqfRpMUPKj8kfjwEuOG55RJVsgUFeg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5537
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10292 signatures=694221
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 malwarescore=0
 suspectscore=0 mlxlogscore=999 bulkscore=0 phishscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203210033
X-Proofpoint-GUID: _Tbwh7gajgbU23JNuOdLbv0xXV-naavF
X-Proofpoint-ORIG-GUID: _Tbwh7gajgbU23JNuOdLbv0xXV-naavF
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This commit adds the new per-inode flag XFS_DIFLAG2_NREXT64 to indicate that
an inode supports 64-bit extent counters. This flag is also enabled by default
on newly created inodes when the corresponding filesystem has large extent
counter feature bit (i.e. XFS_FEAT_NREXT64) set.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/libxfs/xfs_format.h      | 11 ++++++++++-
 fs/xfs/libxfs/xfs_ialloc.c      |  2 ++
 fs/xfs/xfs_inode.h              |  5 +++++
 fs/xfs/xfs_inode_item_recover.c |  7 +++++++
 4 files changed, 24 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 64ff0c310696..57b24744a7c2 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -991,15 +991,17 @@ static inline void xfs_dinode_put_rdev(struct xfs_dinode *dip, xfs_dev_t rdev)
 #define XFS_DIFLAG2_REFLINK_BIT	1	/* file's blocks may be shared */
 #define XFS_DIFLAG2_COWEXTSIZE_BIT   2  /* copy on write extent size hint */
 #define XFS_DIFLAG2_BIGTIME_BIT	3	/* big timestamps */
+#define XFS_DIFLAG2_NREXT64_BIT 4	/* large extent counters */
 
 #define XFS_DIFLAG2_DAX		(1 << XFS_DIFLAG2_DAX_BIT)
 #define XFS_DIFLAG2_REFLINK     (1 << XFS_DIFLAG2_REFLINK_BIT)
 #define XFS_DIFLAG2_COWEXTSIZE  (1 << XFS_DIFLAG2_COWEXTSIZE_BIT)
 #define XFS_DIFLAG2_BIGTIME	(1 << XFS_DIFLAG2_BIGTIME_BIT)
+#define XFS_DIFLAG2_NREXT64	(1 << XFS_DIFLAG2_NREXT64_BIT)
 
 #define XFS_DIFLAG2_ANY \
 	(XFS_DIFLAG2_DAX | XFS_DIFLAG2_REFLINK | XFS_DIFLAG2_COWEXTSIZE | \
-	 XFS_DIFLAG2_BIGTIME)
+	 XFS_DIFLAG2_BIGTIME | XFS_DIFLAG2_NREXT64)
 
 static inline bool xfs_dinode_has_bigtime(const struct xfs_dinode *dip)
 {
@@ -1007,6 +1009,13 @@ static inline bool xfs_dinode_has_bigtime(const struct xfs_dinode *dip)
 	       (dip->di_flags2 & cpu_to_be64(XFS_DIFLAG2_BIGTIME));
 }
 
+static inline bool xfs_dinode_has_large_extent_counts(
+	const struct xfs_dinode *dip)
+{
+	return dip->di_version >= 3 &&
+	       (dip->di_flags2 & cpu_to_be64(XFS_DIFLAG2_NREXT64));
+}
+
 /*
  * Inode number format:
  * low inopblog bits - offset in block
diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index b418fe0c0679..cdf8b63fcb22 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -2772,6 +2772,8 @@ xfs_ialloc_setup_geometry(
 	igeo->new_diflags2 = 0;
 	if (xfs_has_bigtime(mp))
 		igeo->new_diflags2 |= XFS_DIFLAG2_BIGTIME;
+	if (xfs_has_large_extent_counts(mp))
+		igeo->new_diflags2 |= XFS_DIFLAG2_NREXT64;
 
 	/* Compute inode btree geometry. */
 	igeo->agino_log = sbp->sb_inopblog + sbp->sb_agblklog;
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index b7e8f14d9fca..3d28daba88c9 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -218,6 +218,11 @@ static inline bool xfs_inode_has_bigtime(struct xfs_inode *ip)
 	return ip->i_diflags2 & XFS_DIFLAG2_BIGTIME;
 }
 
+static inline bool xfs_inode_has_large_extent_counts(struct xfs_inode *ip)
+{
+	return ip->i_diflags2 & XFS_DIFLAG2_NREXT64;
+}
+
 /*
  * Return the buftarg used for data allocations on a given inode.
  */
diff --git a/fs/xfs/xfs_inode_item_recover.c b/fs/xfs/xfs_inode_item_recover.c
index 239dd2e3384e..44b90614859e 100644
--- a/fs/xfs/xfs_inode_item_recover.c
+++ b/fs/xfs/xfs_inode_item_recover.c
@@ -142,6 +142,13 @@ xfs_log_dinode_to_disk_ts(
 	return ts;
 }
 
+static inline bool xfs_log_dinode_has_large_extent_counts(
+		const struct xfs_log_dinode *ld)
+{
+	return ld->di_version >= 3 &&
+	       (ld->di_flags2 & XFS_DIFLAG2_NREXT64);
+}
+
 STATIC void
 xfs_log_dinode_to_disk(
 	struct xfs_log_dinode	*from,
-- 
2.30.2

