Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42095C433F5
	for <linux-xfs@archiver.kernel.org>; Wed, 27 Apr 2022 00:52:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356532AbiD0Azp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 26 Apr 2022 20:55:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356527AbiD0Azo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Apr 2022 20:55:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D513213DC5
        for <linux-xfs@vger.kernel.org>; Tue, 26 Apr 2022 17:52:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8D80FB82461
        for <linux-xfs@vger.kernel.org>; Wed, 27 Apr 2022 00:52:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B550C385A4;
        Wed, 27 Apr 2022 00:52:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651020752;
        bh=OXQHx+rhnKT31c6Pr4nvyBVnFJHBFWkoy4gnxf194nQ=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=p8IfllWrp3ycx6tFuUuk2IM2v17jBWBJC8OCdximT/TmpC9UdHOCIe4R24EFhx71P
         jcjYsPjTICdoSH4UAHSs9B5ZDS6ZWgHavZECQlW1SInoPUNG1vCpVXtlfiQ5tdNcTC
         apShwsU69kUbzWPP+sK+eL684TbbyABULdpk/4JQfYGMt1tJwQhBE0JhXgOHWWAD3v
         CT5UIXrobjNB7x1A1emI6yJBPURBIZ1WDN+Sl/XFzwGMbqCNIhTm503SfKP42Ley7Q
         18jjydflB+67aDepg+gcQqBlRu7yyIPMbOoBU27/WZ5MqqVhll4xYA1QcLs/uvh8dN
         7p3P9lVcf6jDQ==
Subject: [PATCH 7/9] xfs: reduce transaction reservations with reflink
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, david@fromorbit.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 26 Apr 2022 17:52:31 -0700
Message-ID: <165102075178.3922658.11792444708694506676.stgit@magnolia>
In-Reply-To: <165102071223.3922658.5241787533081256670.stgit@magnolia>
References: <165102071223.3922658.5241787533081256670.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Before to the introduction of deferred refcount operations, reflink
would try to cram refcount btree updates into the same transaction as an
allocation or a free event.  Mainline XFS has never actually done that,
but we never refactored the transaction reservations to reflect that we
now do all refcount updates in separate transactions.  Fix this to
reduce the transaction reservation size even farther, so that between
this patch and the previous one, we reduce the tr_write and tr_itruncate
sizes by 66%.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_log_rlimit.c |   12 ++++
 fs/xfs/libxfs/xfs_refcount.c   |    9 ++-
 fs/xfs/libxfs/xfs_trans_resv.c |  130 +++++++++++++++++++++++++++++++++++-----
 fs/xfs/libxfs/xfs_trans_resv.h |    4 +
 4 files changed, 138 insertions(+), 17 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_log_rlimit.c b/fs/xfs/libxfs/xfs_log_rlimit.c
index 60fff8c6716f..9975b93a7412 100644
--- a/fs/xfs/libxfs/xfs_log_rlimit.c
+++ b/fs/xfs/libxfs/xfs_log_rlimit.c
@@ -80,6 +80,18 @@ xfs_log_calc_trans_resv_for_minlogblocks(
 		resv->tr_qm_dqalloc.tr_logcount = XFS_WRITE_LOG_COUNT;
 	}
 
+	/*
+	 * In the early days of reflink, we did not use deferred refcount
+	 * update log items, so log reservations must be recomputed using the
+	 * old calculations.
+	 */
+	resv->tr_write.tr_logres =
+			xfs_calc_write_reservation_minlogsize(mp);
+	resv->tr_itruncate.tr_logres =
+			xfs_calc_itruncate_reservation_minlogsize(mp);
+	resv->tr_qm_dqalloc.tr_logres =
+			xfs_calc_qm_dqalloc_reservation_minlogsize(mp);
+
 	/* Put everything back the way it was.  This goes at the end. */
 	mp->m_rmap_maxlevels = rmap_maxlevels;
 }
diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
index a07ebaecba73..e53544d52ee2 100644
--- a/fs/xfs/libxfs/xfs_refcount.c
+++ b/fs/xfs/libxfs/xfs_refcount.c
@@ -886,8 +886,13 @@ xfs_refcount_still_have_space(
 {
 	unsigned long			overhead;
 
-	overhead = cur->bc_ag.refc.shape_changes *
-			xfs_allocfree_log_count(cur->bc_mp, 1);
+	/*
+	 * Worst case estimate: full splits of the free space and rmap btrees
+	 * to handle each of the shape changes to the refcount btree.
+	 */
+	overhead = xfs_allocfree_log_count(cur->bc_mp,
+				cur->bc_ag.refc.shape_changes);
+	overhead += cur->bc_mp->m_refc_maxlevels;
 	overhead *= cur->bc_mp->m_sb.sb_blocksize;
 
 	/*
diff --git a/fs/xfs/libxfs/xfs_trans_resv.c b/fs/xfs/libxfs/xfs_trans_resv.c
index 60be82cd491b..ab688929d884 100644
--- a/fs/xfs/libxfs/xfs_trans_resv.c
+++ b/fs/xfs/libxfs/xfs_trans_resv.c
@@ -56,8 +56,7 @@ xfs_calc_buf_res(
  * Per-extent log reservation for the btree changes involved in freeing or
  * allocating an extent.  In classic XFS there were two trees that will be
  * modified (bnobt + cntbt).  With rmap enabled, there are three trees
- * (rmapbt).  With reflink, there are four trees (refcountbt).  The number of
- * blocks reserved is based on the formula:
+ * (rmapbt).  The number of blocks reserved is based on the formula:
  *
  * num trees * ((2 blocks/level * max depth) - 1)
  *
@@ -73,12 +72,23 @@ xfs_allocfree_log_count(
 	blocks = num_ops * 2 * (2 * mp->m_alloc_maxlevels - 1);
 	if (xfs_has_rmapbt(mp))
 		blocks += num_ops * (2 * mp->m_rmap_maxlevels - 1);
-	if (xfs_has_reflink(mp))
-		blocks += num_ops * (2 * mp->m_refc_maxlevels - 1);
 
 	return blocks;
 }
 
+/*
+ * Per-extent log reservation for refcount btree changes.  These are never done
+ * in the same transaction as an allocation or a free, so we compute them
+ * separately.
+ */
+static unsigned int
+xfs_refcountbt_block_count(
+	struct xfs_mount	*mp,
+	unsigned int		num_ops)
+{
+	return num_ops * (2 * mp->m_refc_maxlevels - 1);
+}
+
 /*
  * Logging inodes is really tricksy. They are logged in memory format,
  * which means that what we write into the log doesn't directly translate into
@@ -233,6 +243,28 @@ xfs_rtalloc_log_count(
  * register overflow from temporaries in the calculations.
  */
 
+/*
+ * Compute the log reservation required to handle the refcount update
+ * transaction.  Refcount updates are always done via deferred log items.
+ *
+ * This is calculated as:
+ * Data device refcount updates (t1):
+ *    the agfs of the ags containing the blocks: nr_ops * sector size
+ *    the refcount btrees: nr_ops * 1 trees * (2 * max depth - 1) * block size
+ */
+static unsigned int
+xfs_calc_refcountbt_reservation(
+	struct xfs_mount	*mp,
+	unsigned int		nr_ops)
+{
+	unsigned int		blksz = XFS_FSB_TO_B(mp, 1);
+
+	if (!xfs_has_reflink(mp))
+		return 0;
+
+	return xfs_calc_buf_res(nr_ops, mp->m_sb.sb_sectsize) +
+	       xfs_calc_buf_res(xfs_refcountbt_block_count(mp, nr_ops), blksz);
+}
 
 /*
  * In a write transaction we can allocate a maximum of 2
@@ -255,12 +287,14 @@ xfs_rtalloc_log_count(
  *    the agfls of the ags containing the blocks: 2 * sector size
  *    the super block free block counter: sector size
  *    the allocation btrees: 2 exts * 2 trees * (2 * max depth - 1) * block size
+ * And any refcount updates that happen in a separate transaction (t4).
  */
 STATIC uint
 xfs_calc_write_reservation(
-	struct xfs_mount	*mp)
+	struct xfs_mount	*mp,
+	bool			for_minlogsize)
 {
-	unsigned int		t1, t2, t3;
+	unsigned int		t1, t2, t3, t4;
 	unsigned int		blksz = XFS_FSB_TO_B(mp, 1);
 
 	t1 = xfs_calc_inode_res(mp, 1) +
@@ -282,7 +316,36 @@ xfs_calc_write_reservation(
 	t3 = xfs_calc_buf_res(5, mp->m_sb.sb_sectsize) +
 	     xfs_calc_buf_res(xfs_allocfree_log_count(mp, 2), blksz);
 
-	return XFS_DQUOT_LOGRES(mp) + max3(t1, t2, t3);
+	/*
+	 * In the early days of reflink, we included enough reservation to log
+	 * two refcountbt splits for each transaction.  The codebase runs
+	 * refcountbt updates in separate transactions now, so to compute the
+	 * minimum log size, add the refcountbtree splits back to t1 and t3 and
+	 * do not account them separately as t4.  Reflink did not support
+	 * realtime when the reservations were established, so no adjustment to
+	 * t2 is needed.
+	 */
+	if (for_minlogsize) {
+		unsigned int	adj = 0;
+
+		if (xfs_has_reflink(mp))
+			adj = xfs_calc_buf_res(
+					xfs_refcountbt_block_count(mp, 2),
+					blksz);
+		t1 += adj;
+		t3 += adj;
+		return XFS_DQUOT_LOGRES(mp) + max3(t1, t2, t3);
+	}
+
+	t4 = xfs_calc_refcountbt_reservation(mp, 1);
+	return XFS_DQUOT_LOGRES(mp) + max(t4, max3(t1, t2, t3));
+}
+
+unsigned int
+xfs_calc_write_reservation_minlogsize(
+	struct xfs_mount	*mp)
+{
+	return xfs_calc_write_reservation(mp, true);
 }
 
 /*
@@ -304,12 +367,14 @@ xfs_calc_write_reservation(
  *    the realtime summary: 2 exts * 1 block
  *    worst case split in allocation btrees per extent assuming 2 extents:
  *		2 exts * 2 trees * (2 * max depth - 1) * block size
+ * And any refcount updates that happen in a separate transaction (t4).
  */
 STATIC uint
 xfs_calc_itruncate_reservation(
-	struct xfs_mount	*mp)
+	struct xfs_mount	*mp,
+	bool			for_minlogsize)
 {
-	unsigned int		t1, t2, t3;
+	unsigned int		t1, t2, t3, t4;
 	unsigned int		blksz = XFS_FSB_TO_B(mp, 1);
 
 	t1 = xfs_calc_inode_res(mp, 1) +
@@ -326,7 +391,33 @@ xfs_calc_itruncate_reservation(
 		t3 = 0;
 	}
 
-	return XFS_DQUOT_LOGRES(mp) + max3(t1, t2, t3);
+	/*
+	 * In the early days of reflink, we included enough reservation to log
+	 * four refcountbt splits in the same transaction as bnobt/cntbt
+	 * updates.  The codebase runs refcountbt updates in separate
+	 * transactions now, so to compute the minimum log size, add the
+	 * refcount btree splits back here and do not compute them separately
+	 * as t4.  Reflink did not support realtime when the reservations were
+	 * established, so do not adjust t3.
+	 */
+	if (for_minlogsize) {
+		if (xfs_has_reflink(mp))
+			t2 += xfs_calc_buf_res(
+					xfs_refcountbt_block_count(mp, 4),
+					blksz);
+
+		return XFS_DQUOT_LOGRES(mp) + max3(t1, t2, t3);
+	}
+
+	t4 = xfs_calc_refcountbt_reservation(mp, 2);
+	return XFS_DQUOT_LOGRES(mp) + max(t4, max3(t1, t2, t3));
+}
+
+unsigned int
+xfs_calc_itruncate_reservation_minlogsize(
+	struct xfs_mount	*mp)
+{
+	return xfs_calc_itruncate_reservation(mp, true);
 }
 
 /*
@@ -792,13 +883,21 @@ xfs_calc_qm_setqlim_reservation(void)
  */
 STATIC uint
 xfs_calc_qm_dqalloc_reservation(
-	struct xfs_mount	*mp)
+	struct xfs_mount	*mp,
+	bool			for_minlogsize)
 {
-	return xfs_calc_write_reservation(mp) +
+	return xfs_calc_write_reservation(mp, for_minlogsize) +
 		xfs_calc_buf_res(1,
 			XFS_FSB_TO_B(mp, XFS_DQUOT_CLUSTER_SIZE_FSB) - 1);
 }
 
+unsigned int
+xfs_calc_qm_dqalloc_reservation_minlogsize(
+	struct xfs_mount	*mp)
+{
+	return xfs_calc_qm_dqalloc_reservation(mp, true);
+}
+
 /*
  * Syncing the incore super block changes to disk.
  *     the super block to reflect the changes: sector size
@@ -821,11 +920,11 @@ xfs_trans_resv_calc(
 	 * The following transactions are logged in physical format and
 	 * require a permanent reservation on space.
 	 */
-	resp->tr_write.tr_logres = xfs_calc_write_reservation(mp);
+	resp->tr_write.tr_logres = xfs_calc_write_reservation(mp, false);
 	resp->tr_write.tr_logcount = XFS_WRITE_LOG_COUNT;
 	resp->tr_write.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
 
-	resp->tr_itruncate.tr_logres = xfs_calc_itruncate_reservation(mp);
+	resp->tr_itruncate.tr_logres = xfs_calc_itruncate_reservation(mp, false);
 	resp->tr_itruncate.tr_logcount = XFS_ITRUNCATE_LOG_COUNT;
 	resp->tr_itruncate.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
 
@@ -882,7 +981,8 @@ xfs_trans_resv_calc(
 	resp->tr_growrtalloc.tr_logcount = XFS_DEFAULT_PERM_LOG_COUNT;
 	resp->tr_growrtalloc.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
 
-	resp->tr_qm_dqalloc.tr_logres = xfs_calc_qm_dqalloc_reservation(mp);
+	resp->tr_qm_dqalloc.tr_logres = xfs_calc_qm_dqalloc_reservation(mp,
+			false);
 	resp->tr_qm_dqalloc.tr_logcount = XFS_WRITE_LOG_COUNT;
 	resp->tr_qm_dqalloc.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
 
diff --git a/fs/xfs/libxfs/xfs_trans_resv.h b/fs/xfs/libxfs/xfs_trans_resv.h
index fa330e646dc5..22b99042127a 100644
--- a/fs/xfs/libxfs/xfs_trans_resv.h
+++ b/fs/xfs/libxfs/xfs_trans_resv.h
@@ -98,4 +98,8 @@ struct xfs_trans_resv {
 void xfs_trans_resv_calc(struct xfs_mount *mp, struct xfs_trans_resv *resp);
 uint xfs_allocfree_log_count(struct xfs_mount *mp, uint num_ops);
 
+unsigned int xfs_calc_itruncate_reservation_minlogsize(struct xfs_mount *mp);
+unsigned int xfs_calc_write_reservation_minlogsize(struct xfs_mount *mp);
+unsigned int xfs_calc_qm_dqalloc_reservation_minlogsize(struct xfs_mount *mp);
+
 #endif	/* __XFS_TRANS_RESV_H__ */

