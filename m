Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFE02C433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Apr 2022 22:55:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347382AbiDNW5Z (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 14 Apr 2022 18:57:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347377AbiDNW5Y (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Apr 2022 18:57:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E0692FFEC
        for <linux-xfs@vger.kernel.org>; Thu, 14 Apr 2022 15:54:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D494FB82B23
        for <linux-xfs@vger.kernel.org>; Thu, 14 Apr 2022 22:54:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D7F8C385A5;
        Thu, 14 Apr 2022 22:54:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649976894;
        bh=eERqww80ku1zsjsNSSW+ostr1TgSgE+byh2tfjvo9zE=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=oMukj9Zbvicg8YOlzO9VFMMbSJU/GUnyOfrjVYpU15Pxm7T/uQNeH9COik2Q6QrRN
         WsQO8KXxnQAsdA3LzsQ6l8PWND0V9gPLFwrSdi0uJtgYnQhHlBONXnU9Y5Zurgvs+/
         S9tULM07LZqTzSU/GB/uR8tMT0obvBVZX7zlBjLL0lnbVPvJvmW8HEE/Y7Y3YqRGhf
         bAyDRAxF0dq29UWkA052bCNNqmEXlYV+bSl5JEj7G6ad4B/s4B2RSt8L2jznqTfXTN
         pJVmihmZqmWZNh1cingoPIaSOnKVLol7aR2JyS4avDqniv5HizWuEGaNRPmiS4kyYd
         lXEUMt2o6jupg==
Subject: [PATCH 5/6] xfs: reduce transaction reservations with reflink
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, david@fromorbit.com
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 14 Apr 2022 15:54:54 -0700
Message-ID: <164997689398.383881.16693790752445073096.stgit@magnolia>
In-Reply-To: <164997686569.383881.8935566398533700022.stgit@magnolia>
References: <164997686569.383881.8935566398533700022.stgit@magnolia>
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
 fs/xfs/libxfs/xfs_refcount.c   |    9 +++-
 fs/xfs/libxfs/xfs_trans_resv.c |   97 ++++++++++++++++++++++++++++++++++++++--
 2 files changed, 98 insertions(+), 8 deletions(-)


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
index 8d2f04dddb65..e5c3fcc2ab15 100644
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
+xfs_refcount_log_count(
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
+xfs_refcount_log_reservation(
+	struct xfs_mount	*mp,
+	unsigned int		nr_ops)
+{
+	unsigned int		blksz = XFS_FSB_TO_B(mp, 1);
+
+	if (!xfs_has_reflink(mp))
+		return 0;
+
+	return xfs_calc_buf_res(nr_ops, mp->m_sb.sb_sectsize) +
+	       xfs_calc_buf_res(xfs_refcount_log_count(mp, nr_ops), blksz);
+}
 
 /*
  * In a write transaction we can allocate a maximum of 2
@@ -255,12 +287,13 @@ xfs_rtalloc_log_count(
  *    the agfls of the ags containing the blocks: 2 * sector size
  *    the super block free block counter: sector size
  *    the allocation btrees: 2 exts * 2 trees * (2 * max depth - 1) * block size
+ * And any refcount updates that happen in a separate transaction (t4).
  */
 STATIC uint
 xfs_calc_write_reservation(
 	struct xfs_mount	*mp)
 {
-	unsigned int		t1, t2, t3;
+	unsigned int		t1, t2, t3, t4;
 	unsigned int		blksz = XFS_FSB_TO_B(mp, 1);
 
 	t1 = xfs_calc_inode_res(mp, 1) +
@@ -282,7 +315,9 @@ xfs_calc_write_reservation(
 	t3 = xfs_calc_buf_res(5, mp->m_sb.sb_sectsize) +
 	     xfs_calc_buf_res(xfs_allocfree_log_count(mp, 2), blksz);
 
-	return XFS_DQUOT_LOGRES(mp) + max3(t1, t2, t3);
+	t4 = xfs_refcount_log_reservation(mp, 1);
+
+	return XFS_DQUOT_LOGRES(mp) + max(t4, max3(t1, t2, t3));
 }
 
 /*
@@ -303,10 +338,42 @@ xfs_calc_write_reservation(
  *    the realtime summary: 2 exts * 1 block
  *    worst case split in allocation btrees per extent assuming 2 extents:
  *		2 exts * 2 trees * (2 * max depth - 1) * block size
+ * And any refcount updates that happen in a separate transaction (t4).
  */
 STATIC uint
 xfs_calc_itruncate_reservation(
 	struct xfs_mount	*mp)
+{
+	unsigned int		t1, t2, t3, t4;
+	unsigned int		blksz = XFS_FSB_TO_B(mp, 1);
+
+	t1 = xfs_calc_inode_res(mp, 1) +
+	     xfs_calc_buf_res(XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK) + 1, blksz);
+
+	t2 = xfs_calc_buf_res(9, mp->m_sb.sb_sectsize) +
+	     xfs_calc_buf_res(xfs_allocfree_log_count(mp, 4), blksz);
+
+	if (xfs_has_realtime(mp)) {
+		t3 = xfs_calc_buf_res(5, mp->m_sb.sb_sectsize) +
+		     xfs_calc_buf_res(xfs_rtalloc_log_count(mp, 2), blksz) +
+		     xfs_calc_buf_res(xfs_allocfree_log_count(mp, 2), blksz);
+	} else {
+		t3 = 0;
+	}
+
+	t4 = xfs_refcount_log_reservation(mp, 2);
+
+	return XFS_DQUOT_LOGRES(mp) + max(t4, max3(t1, t2, t3));
+}
+
+/*
+ * For log size calculation, this is the same as above except that we used to
+ * include refcount updates in the allocfree computation even though we've
+ * always run them as a separate transaction.
+ */
+STATIC uint
+xfs_calc_itruncate_reservation_logsize(
+	struct xfs_mount	*mp)
 {
 	unsigned int		t1, t2, t3;
 	unsigned int		blksz = XFS_FSB_TO_B(mp, 1);
@@ -317,6 +384,9 @@ xfs_calc_itruncate_reservation(
 	t2 = xfs_calc_buf_res(9, mp->m_sb.sb_sectsize) +
 	     xfs_calc_buf_res(xfs_allocfree_log_count(mp, 4), blksz);
 
+	if (xfs_has_reflink(mp))
+	     t2 += xfs_calc_buf_res(xfs_refcount_log_count(mp, 4), blksz);
+
 	if (xfs_has_realtime(mp)) {
 		t3 = xfs_calc_buf_res(5, mp->m_sb.sb_sectsize) +
 		     xfs_calc_buf_res(xfs_rtalloc_log_count(mp, 2), blksz) +
@@ -956,6 +1026,9 @@ xfs_trans_resv_calc_logsize(
 	xfs_trans_resv_calc(mp, resp);
 
 	if (xfs_has_reflink(mp)) {
+		unsigned int	t4;
+		unsigned int	blksz = XFS_FSB_TO_B(mp, 1);
+
 		/*
 		 * In the early days of reflink we set the logcounts absurdly
 		 * high.
@@ -964,6 +1037,18 @@ xfs_trans_resv_calc_logsize(
 		resp->tr_itruncate.tr_logcount =
 				XFS_ITRUNCATE_LOG_COUNT_REFLINK;
 		resp->tr_qm_dqalloc.tr_logcount = XFS_WRITE_LOG_COUNT_REFLINK;
+
+		/*
+		 * We also used to account two refcount updates per extent into
+		 * the alloc/free step of write and truncate calls, even though
+		 * those are run in separate transactions.
+		 */
+		t4 = xfs_calc_buf_res(xfs_refcount_log_count(mp, 2), blksz);
+		resp->tr_write.tr_logres += t4;
+		resp->tr_qm_dqalloc.tr_logres += t4;
+
+		resp->tr_itruncate.tr_logres =
+				xfs_calc_itruncate_reservation_logsize(mp);
 	} else if (xfs_has_rmapbt(mp)) {
 		/*
 		 * In the early days of non-reflink rmap we set the logcount

