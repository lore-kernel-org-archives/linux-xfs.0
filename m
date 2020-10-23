Return-Path: <SRS0=+s6N=D6=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45853C388F9
	for <linux-xfs@archiver.kernel.org>; Fri, 23 Oct 2020 06:35:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E260C22253
	for <linux-xfs@archiver.kernel.org>; Fri, 23 Oct 2020 06:35:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="qojxtR3i"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S372832AbgJWGfT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 23 Oct 2020 02:35:19 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:45140 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S372843AbgJWGfT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 23 Oct 2020 02:35:19 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09N6OHDv025403
        for <linux-xfs@vger.kernel.org>; Fri, 23 Oct 2020 06:35:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=QolY6rM5KBfj6BujmkLxmJjCLlNsu7GImlyQ2DbLdnA=;
 b=qojxtR3i5Hu2gHGzTjUNmwua/h+m3nqh4hTdCORHWVgtB1lXtdYfAQesOYzdyRe/WFV7
 I0BFoqRg4egQBr4NhN0skPhnoyWHjpfRUnGJ1Uzl0ovdRffshk6ifXf2RxBRZy0EJ8nu
 I/6v+rOHPU2DLAbPBal29g0OKGiLOWS88iEGoC6gpsbgrba7wpqP7Yi6xBSEf2Tf4EJ5
 hmH81DUUrdQOSfv4qhINAVRGi7ktOl6J4RzNWARj+5BD5EYeopRm49eVUSzj5fcOL4RJ
 BUYTaptqfskwfJWZJglpAGjfFZsED+kBYVZZ3vDkg0KcgIBSEKAGWG3IlJII79l8lK+6 Kg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 34ak16snpp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Fri, 23 Oct 2020 06:35:17 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09N6P558178184
        for <linux-xfs@vger.kernel.org>; Fri, 23 Oct 2020 06:33:17 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 348aj0n96u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 23 Oct 2020 06:33:17 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 09N6XGQg009332
        for <linux-xfs@vger.kernel.org>; Fri, 23 Oct 2020 06:33:17 GMT
Received: from localhost.localdomain (/67.1.244.254)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 22 Oct 2020 23:33:16 -0700
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v13 01/14] xfs: store inode btree block counts in AGI header
Date:   Thu, 22 Oct 2020 23:32:53 -0700
Message-Id: <20201023063306.7441-2-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201023063306.7441-1-allison.henderson@oracle.com>
References: <20201023063306.7441-1-allison.henderson@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9782 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 bulkscore=0
 malwarescore=0 spamscore=0 mlxlogscore=999 mlxscore=0 suspectscore=4
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010230045
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9782 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0
 priorityscore=1501 clxscore=1015 malwarescore=0 mlxscore=0 adultscore=0
 lowpriorityscore=0 impostorscore=0 spamscore=0 mlxlogscore=999
 suspectscore=4 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010230045
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: "Darrick J. Wong" <darrick.wong@oracle.com>

Source kernel commit: 2a39946c984464e4aac82c556ba9915589be7323

Add a btree block usage counters for both inode btrees to the AGI header
so that we don't have to walk the entire finobt at mount time to create
the per-AG reservations.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 libxfs/xfs_ag.c           |  5 +++++
 libxfs/xfs_format.h       | 18 +++++++++++++++++-
 libxfs/xfs_ialloc.c       |  1 +
 libxfs/xfs_ialloc_btree.c | 21 +++++++++++++++++++++
 4 files changed, 44 insertions(+), 1 deletion(-)

diff --git a/libxfs/xfs_ag.c b/libxfs/xfs_ag.c
index ceaa7e5..af8a0af 100644
--- a/libxfs/xfs_ag.c
+++ b/libxfs/xfs_ag.c
@@ -333,6 +333,11 @@ xfs_agiblock_init(
 	}
 	for (bucket = 0; bucket < XFS_AGI_UNLINKED_BUCKETS; bucket++)
 		agi->agi_unlinked[bucket] = cpu_to_be32(NULLAGINO);
+	if (xfs_sb_version_hasinobtcounts(&mp->m_sb)) {
+		agi->agi_iblocks = cpu_to_be32(1);
+		if (xfs_sb_version_hasfinobt(&mp->m_sb))
+			agi->agi_fblocks = cpu_to_be32(1);
+	}
 }
 
 typedef void (*aghdr_init_work_f)(struct xfs_mount *mp, struct xfs_buf *bp,
diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index f0ecd06..01544f9 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
@@ -449,6 +449,7 @@ xfs_sb_has_compat_feature(
 #define XFS_SB_FEAT_RO_COMPAT_FINOBT   (1 << 0)		/* free inode btree */
 #define XFS_SB_FEAT_RO_COMPAT_RMAPBT   (1 << 1)		/* reverse map btree */
 #define XFS_SB_FEAT_RO_COMPAT_REFLINK  (1 << 2)		/* reflinked files */
+#define XFS_SB_FEAT_RO_COMPAT_INOBTCNT (1 << 3)		/* inobt block counts */
 #define XFS_SB_FEAT_RO_COMPAT_ALL \
 		(XFS_SB_FEAT_RO_COMPAT_FINOBT | \
 		 XFS_SB_FEAT_RO_COMPAT_RMAPBT | \
@@ -564,6 +565,17 @@ static inline bool xfs_sb_version_hasreflink(struct xfs_sb *sbp)
 }
 
 /*
+ * Inode btree block counter.  We record the number of inobt and finobt blocks
+ * in the AGI header so that we can skip the finobt walk at mount time when
+ * setting up per-AG reservations.
+ */
+static inline bool xfs_sb_version_hasinobtcounts(struct xfs_sb *sbp)
+{
+	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5 &&
+		(sbp->sb_features_ro_compat & XFS_SB_FEAT_RO_COMPAT_INOBTCNT);
+}
+
+/*
  * end of superblock version macros
  */
 
@@ -765,6 +777,9 @@ typedef struct xfs_agi {
 	__be32		agi_free_root; /* root of the free inode btree */
 	__be32		agi_free_level;/* levels in free inode btree */
 
+	__be32		agi_iblocks;	/* inobt blocks used */
+	__be32		agi_fblocks;	/* finobt blocks used */
+
 	/* structure must be padded to 64 bit alignment */
 } xfs_agi_t;
 
@@ -785,7 +800,8 @@ typedef struct xfs_agi {
 #define	XFS_AGI_ALL_BITS_R1	((1 << XFS_AGI_NUM_BITS_R1) - 1)
 #define	XFS_AGI_FREE_ROOT	(1 << 11)
 #define	XFS_AGI_FREE_LEVEL	(1 << 12)
-#define	XFS_AGI_NUM_BITS_R2	13
+#define	XFS_AGI_IBLOCKS		(1 << 13) /* both inobt/finobt block counters */
+#define	XFS_AGI_NUM_BITS_R2	14
 
 /* disk block (xfs_daddr_t) in the AG */
 #define XFS_AGI_DADDR(mp)	((xfs_daddr_t)(2 << (mp)->m_sectbb_log))
diff --git a/libxfs/xfs_ialloc.c b/libxfs/xfs_ialloc.c
index ce73fee..8adeb10 100644
--- a/libxfs/xfs_ialloc.c
+++ b/libxfs/xfs_ialloc.c
@@ -2468,6 +2468,7 @@ xfs_ialloc_log_agi(
 		offsetof(xfs_agi_t, agi_unlinked),
 		offsetof(xfs_agi_t, agi_free_root),
 		offsetof(xfs_agi_t, agi_free_level),
+		offsetof(xfs_agi_t, agi_iblocks),
 		sizeof(xfs_agi_t)
 	};
 #ifdef DEBUG
diff --git a/libxfs/xfs_ialloc_btree.c b/libxfs/xfs_ialloc_btree.c
index 41c308c..3ed87d1 100644
--- a/libxfs/xfs_ialloc_btree.c
+++ b/libxfs/xfs_ialloc_btree.c
@@ -66,6 +66,25 @@ xfs_finobt_set_root(
 			   XFS_AGI_FREE_ROOT | XFS_AGI_FREE_LEVEL);
 }
 
+/* Update the inode btree block counter for this btree. */
+static inline void
+xfs_inobt_mod_blockcount(
+	struct xfs_btree_cur	*cur,
+	int			howmuch)
+{
+	struct xfs_buf		*agbp = cur->bc_ag.agbp;
+	struct xfs_agi		*agi = agbp->b_addr;
+
+	if (!xfs_sb_version_hasinobtcounts(&cur->bc_mp->m_sb))
+		return;
+
+	if (cur->bc_btnum == XFS_BTNUM_FINO)
+		be32_add_cpu(&agi->agi_fblocks, howmuch);
+	else if (cur->bc_btnum == XFS_BTNUM_INO)
+		be32_add_cpu(&agi->agi_iblocks, howmuch);
+	xfs_ialloc_log_agi(cur->bc_tp, agbp, XFS_AGI_IBLOCKS);
+}
+
 STATIC int
 __xfs_inobt_alloc_block(
 	struct xfs_btree_cur	*cur,
@@ -101,6 +120,7 @@ __xfs_inobt_alloc_block(
 
 	new->s = cpu_to_be32(XFS_FSB_TO_AGBNO(args.mp, args.fsbno));
 	*stat = 1;
+	xfs_inobt_mod_blockcount(cur, 1);
 	return 0;
 }
 
@@ -133,6 +153,7 @@ __xfs_inobt_free_block(
 	struct xfs_buf		*bp,
 	enum xfs_ag_resv_type	resv)
 {
+	xfs_inobt_mod_blockcount(cur, -1);
 	return xfs_free_extent(cur->bc_tp,
 			XFS_DADDR_TO_FSB(cur->bc_mp, XFS_BUF_ADDR(bp)), 1,
 			&XFS_RMAP_OINFO_INOBT, resv);
-- 
2.7.4

