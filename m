Return-Path: <SRS0=2cgH=B3=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B09B4C433E1
	for <linux-xfs@archiver.kernel.org>; Mon, 17 Aug 2020 22:58:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8633D2072D
	for <linux-xfs@archiver.kernel.org>; Mon, 17 Aug 2020 22:58:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="GRW1kldZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727992AbgHQW6V (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 17 Aug 2020 18:58:21 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:34800 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727954AbgHQW6R (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 Aug 2020 18:58:17 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07HMwEoW164201;
        Mon, 17 Aug 2020 22:58:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=v9C1W6sOTvauYdxV9eD1EXkIG0SgrYNhmTPbPwfAnqE=;
 b=GRW1kldZg1xq0pF+qxncAMhOaCJTzMGTjDywUfUafpMcKD94/XxPkE+cVIkb0s5Yw8W8
 Vuw+LewkivJqebQ5WV3qqRSJ6ab9pnAIkzxbl3qVJfwP/AldfIjEjHz7++SKG9MVmIIf
 D4hZQDvE+iQ9tKpF5MCDMgxAIzauDCw66tcspG+aLzoVWHoXnErLvd02RkJwlTi8BDZ9
 VSJ8RDw9mjpMcY9fPnfrGD0dXeqZeASu6kL8m8Z6HrzDFDK1esk2ErBnzlZKw/N2mq4x
 lU/dQwx1GGSbwgw6W2hmdlZHNR6cIph2Ip5+joop8Re7P+c9g4CPFgKeN+gZlPKo52Uv qQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 32x74r1mq6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 17 Aug 2020 22:58:14 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07HMmtau074788;
        Mon, 17 Aug 2020 22:58:14 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 32xsmwgg85-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 17 Aug 2020 22:58:14 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 07HMwD22013800;
        Mon, 17 Aug 2020 22:58:13 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 17 Aug 2020 15:58:12 -0700
Subject: [PATCH 1/7] xfs: store inode btree block counts in AGI header
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 17 Aug 2020 15:58:12 -0700
Message-ID: <159770509202.3958545.11061993192287588061.stgit@magnolia>
In-Reply-To: <159770508586.3958545.417872750558976156.stgit@magnolia>
References: <159770508586.3958545.417872750558976156.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9716 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 bulkscore=0
 mlxlogscore=999 phishscore=0 mlxscore=0 suspectscore=2 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008170152
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9716 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 mlxlogscore=999
 priorityscore=1501 phishscore=0 spamscore=0 mlxscore=0 adultscore=0
 suspectscore=2 lowpriorityscore=0 bulkscore=0 malwarescore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008170153
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Add a btree block usage counter for both inode btrees to the AGI header
so that we don't have to walk the entire finobt at mount time to create
the per-AG reservations.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/xfs_ag.c           |    4 ++
 libxfs/xfs_format.h       |   19 ++++++++++-
 libxfs/xfs_ialloc.c       |    1 +
 libxfs/xfs_ialloc_btree.c |   78 +++++++++++++++++++++++++++++++++++++++++----
 4 files changed, 94 insertions(+), 8 deletions(-)


diff --git a/libxfs/xfs_ag.c b/libxfs/xfs_ag.c
index ceaa7e5e4640..38c3acd8d990 100644
--- a/libxfs/xfs_ag.c
+++ b/libxfs/xfs_ag.c
@@ -333,6 +333,10 @@ xfs_agiblock_init(
 	}
 	for (bucket = 0; bucket < XFS_AGI_UNLINKED_BUCKETS; bucket++)
 		agi->agi_unlinked[bucket] = cpu_to_be32(NULLAGINO);
+	if (xfs_sb_version_hasinobtcounts(&mp->m_sb)) {
+		agi->agi_iblocks = cpu_to_be32(1);
+		agi->agi_fblocks = cpu_to_be32(1);
+	}
 }
 
 typedef void (*aghdr_init_work_f)(struct xfs_mount *mp, struct xfs_buf *bp,
diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index d14fee3e3ac2..67357622e5e5 100644
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
@@ -563,6 +564,18 @@ static inline bool xfs_sb_version_hasreflink(struct xfs_sb *sbp)
 		(sbp->sb_features_ro_compat & XFS_SB_FEAT_RO_COMPAT_REFLINK);
 }
 
+/*
+ * Inode btree block counter.  We record the number of inobt and finobt blocks
+ * in the AGI header so that we can skip the finobt walk at mount time when
+ * setting up per-AG reservations.  Since this is mostly an optimization of an
+ * existing feature, we only enable it when that feature is also enabled.
+ */
+static inline bool xfs_sb_version_hasinobtcounts(struct xfs_sb *sbp)
+{
+	return xfs_sb_version_hasfinobt(sbp) &&
+		(sbp->sb_features_ro_compat & XFS_SB_FEAT_RO_COMPAT_INOBTCNT);
+}
+
 /*
  * end of superblock version macros
  */
@@ -765,6 +778,9 @@ typedef struct xfs_agi {
 	__be32		agi_free_root; /* root of the free inode btree */
 	__be32		agi_free_level;/* levels in free inode btree */
 
+	__be32		agi_iblocks;	/* inobt blocks used */
+	__be32		agi_fblocks;	/* finobt blocks used */
+
 	/* structure must be padded to 64 bit alignment */
 } xfs_agi_t;
 
@@ -785,7 +801,8 @@ typedef struct xfs_agi {
 #define	XFS_AGI_ALL_BITS_R1	((1 << XFS_AGI_NUM_BITS_R1) - 1)
 #define	XFS_AGI_FREE_ROOT	(1 << 11)
 #define	XFS_AGI_FREE_LEVEL	(1 << 12)
-#define	XFS_AGI_NUM_BITS_R2	13
+#define	XFS_AGI_IBLOCKS		(1 << 13) /* both inobt/finobt block counters */
+#define	XFS_AGI_NUM_BITS_R2	14
 
 /* disk block (xfs_daddr_t) in the AG */
 #define XFS_AGI_DADDR(mp)	((xfs_daddr_t)(2 << (mp)->m_sectbb_log))
diff --git a/libxfs/xfs_ialloc.c b/libxfs/xfs_ialloc.c
index 1d5bb668c9f9..45bbbb321118 100644
--- a/libxfs/xfs_ialloc.c
+++ b/libxfs/xfs_ialloc.c
@@ -2512,6 +2512,7 @@ xfs_ialloc_log_agi(
 		offsetof(xfs_agi_t, agi_unlinked),
 		offsetof(xfs_agi_t, agi_free_root),
 		offsetof(xfs_agi_t, agi_free_level),
+		offsetof(xfs_agi_t, agi_iblocks),
 		sizeof(xfs_agi_t)
 	};
 #ifdef DEBUG
diff --git a/libxfs/xfs_ialloc_btree.c b/libxfs/xfs_ialloc_btree.c
index e73ffffede4d..6df4afb4e138 100644
--- a/libxfs/xfs_ialloc_btree.c
+++ b/libxfs/xfs_ialloc_btree.c
@@ -66,6 +66,25 @@ xfs_finobt_set_root(
 			   XFS_AGI_FREE_ROOT | XFS_AGI_FREE_LEVEL);
 }
 
+/* Update the inode btree block counter for this btree. */
+static inline void
+xfs_inobt_change_blocks(
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
+	else
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
+	xfs_inobt_change_blocks(cur, 1);
 	return 0;
 }
 
@@ -121,10 +141,17 @@ xfs_finobt_alloc_block(
 	union xfs_btree_ptr	*new,
 	int			*stat)
 {
+	int			error;
+
 	if (cur->bc_mp->m_finobt_nores)
-		return xfs_inobt_alloc_block(cur, start, new, stat);
-	return __xfs_inobt_alloc_block(cur, start, new, stat,
-			XFS_AG_RESV_METADATA);
+		error = xfs_inobt_alloc_block(cur, start, new, stat);
+	else
+		error = __xfs_inobt_alloc_block(cur, start, new, stat,
+				XFS_AG_RESV_METADATA);
+	if (error)
+		return error;
+
+	return 0;
 }
 
 STATIC int
@@ -133,6 +160,7 @@ __xfs_inobt_free_block(
 	struct xfs_buf		*bp,
 	enum xfs_ag_resv_type	resv)
 {
+	xfs_inobt_change_blocks(cur, -1);
 	return xfs_free_extent(cur->bc_tp,
 			XFS_DADDR_TO_FSB(cur->bc_mp, XFS_BUF_ADDR(bp)), 1,
 			&XFS_RMAP_OINFO_INOBT, resv);
@@ -479,19 +507,29 @@ xfs_inobt_commit_staged_btree(
 {
 	struct xfs_agi		*agi = agbp->b_addr;
 	struct xbtree_afakeroot	*afake = cur->bc_ag.afake;
+	int			fields;
 
 	ASSERT(cur->bc_flags & XFS_BTREE_STAGING);
 
 	if (cur->bc_btnum == XFS_BTNUM_INO) {
+		fields = XFS_AGI_ROOT | XFS_AGI_LEVEL;
 		agi->agi_root = cpu_to_be32(afake->af_root);
 		agi->agi_level = cpu_to_be32(afake->af_levels);
-		xfs_ialloc_log_agi(tp, agbp, XFS_AGI_ROOT | XFS_AGI_LEVEL);
+		if (xfs_sb_version_hasinobtcounts(&cur->bc_mp->m_sb)) {
+			agi->agi_iblocks = cpu_to_be32(afake->af_blocks);
+			fields |= XFS_AGI_IBLOCKS;
+		}
+		xfs_ialloc_log_agi(tp, agbp, fields);
 		xfs_btree_commit_afakeroot(cur, tp, agbp, &xfs_inobt_ops);
 	} else {
+		fields = XFS_AGI_FREE_ROOT | XFS_AGI_FREE_LEVEL;
 		agi->agi_free_root = cpu_to_be32(afake->af_root);
 		agi->agi_free_level = cpu_to_be32(afake->af_levels);
-		xfs_ialloc_log_agi(tp, agbp, XFS_AGI_FREE_ROOT |
-					     XFS_AGI_FREE_LEVEL);
+		if (xfs_sb_version_hasinobtcounts(&cur->bc_mp->m_sb)) {
+			agi->agi_fblocks = cpu_to_be32(afake->af_blocks);
+			fields |= XFS_AGI_IBLOCKS;
+		}
+		xfs_ialloc_log_agi(tp, agbp, fields);
 		xfs_btree_commit_afakeroot(cur, tp, agbp, &xfs_finobt_ops);
 	}
 }
@@ -672,6 +710,28 @@ xfs_inobt_count_blocks(
 	return error;
 }
 
+/* Read finobt block count from AGI header. */
+static int
+xfs_finobt_read_blocks(
+	struct xfs_mount	*mp,
+	struct xfs_trans	*tp,
+	xfs_agnumber_t		agno,
+	xfs_extlen_t		*tree_blocks)
+{
+	struct xfs_buf		*agbp;
+	struct xfs_agi		*agi;
+	int			error;
+
+	error = xfs_ialloc_read_agi(mp, tp, agno, &agbp);
+	if (error)
+		return error;
+
+	agi = agbp->b_addr;
+	*tree_blocks = be32_to_cpu(agi->agi_fblocks);
+	xfs_trans_brelse(tp, agbp);
+	return 0;
+}
+
 /*
  * Figure out how many blocks to reserve and how many are used by this btree.
  */
@@ -689,7 +749,11 @@ xfs_finobt_calc_reserves(
 	if (!xfs_sb_version_hasfinobt(&mp->m_sb))
 		return 0;
 
-	error = xfs_inobt_count_blocks(mp, tp, agno, XFS_BTNUM_FINO, &tree_len);
+	if (xfs_sb_version_hasinobtcounts(&mp->m_sb))
+		error = xfs_finobt_read_blocks(mp, tp, agno, &tree_len);
+	else
+		error = xfs_inobt_count_blocks(mp, tp, agno, XFS_BTNUM_FINO,
+				&tree_len);
 	if (error)
 		return error;
 

