Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34CBAC433F5
	for <linux-xfs@archiver.kernel.org>; Wed, 27 Apr 2022 00:52:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356525AbiD0Azy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 26 Apr 2022 20:55:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356518AbiD0Azx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Apr 2022 20:55:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D66D17E17
        for <linux-xfs@vger.kernel.org>; Tue, 26 Apr 2022 17:52:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1901A61A5F
        for <linux-xfs@vger.kernel.org>; Wed, 27 Apr 2022 00:52:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71B38C385A0;
        Wed, 27 Apr 2022 00:52:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651020763;
        bh=GkmlHlBaRUnMRIrImsoc+Uu3ZDK0GTiOXw/DzwuLWLM=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=HRZiBS9FcioQJW7PIveaLEdziI9UqXO0uacwD2u0pu4R2dL2xctzdksdpmBkKcDvi
         JGiJpehQRsEutLV6Mp4QSlMUG+CwAduXbS8QcYGDnS6FcAdsDL0luC3147YoK6TIBZ
         3JikXdFPuEfS29zx2DjTrnd93EesVTaloHF5byBhvkMYMOjVzCLG/zZC9CRf7HtVnb
         ZZ0+0ui6QjIIGTIE72GrjLnDpJywWVbya0ML8uvF2j8Xrf+P5wLVfEoWi/hnXfLJmq
         /KMyrQWDnlMGLI5Hjvpcx1ZFpX4j4lwK5I8w/gPKLUV2EGgB6f/rpwvf0r9oLgW5/r
         9NpUki4BhVq4A==
Subject: [PATCH 9/9] xfs: rename xfs_*alloc*_log_count to _block_count
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, david@fromorbit.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 26 Apr 2022 17:52:43 -0700
Message-ID: <165102076298.3922658.10000784148294313471.stgit@magnolia>
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

These functions return the maximum number of blocks that could be logged
in a particular transaction.  "log count" is confusing since there's a
separate concept of a log (operation) count in the reservation code, so
let's change it to "block count" to be less confusing.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_refcount.c   |    2 +-
 fs/xfs/libxfs/xfs_trans_resv.c |   38 +++++++++++++++++++-------------------
 fs/xfs/libxfs/xfs_trans_resv.h |    2 +-
 3 files changed, 21 insertions(+), 21 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
index e53544d52ee2..97e9e6020596 100644
--- a/fs/xfs/libxfs/xfs_refcount.c
+++ b/fs/xfs/libxfs/xfs_refcount.c
@@ -890,7 +890,7 @@ xfs_refcount_still_have_space(
 	 * Worst case estimate: full splits of the free space and rmap btrees
 	 * to handle each of the shape changes to the refcount btree.
 	 */
-	overhead = xfs_allocfree_log_count(cur->bc_mp,
+	overhead = xfs_allocfree_block_count(cur->bc_mp,
 				cur->bc_ag.refc.shape_changes);
 	overhead += cur->bc_mp->m_refc_maxlevels;
 	overhead *= cur->bc_mp->m_sb.sb_blocksize;
diff --git a/fs/xfs/libxfs/xfs_trans_resv.c b/fs/xfs/libxfs/xfs_trans_resv.c
index ab688929d884..e9913c2c5a24 100644
--- a/fs/xfs/libxfs/xfs_trans_resv.c
+++ b/fs/xfs/libxfs/xfs_trans_resv.c
@@ -63,7 +63,7 @@ xfs_calc_buf_res(
  * Keep in mind that max depth is calculated separately for each type of tree.
  */
 uint
-xfs_allocfree_log_count(
+xfs_allocfree_block_count(
 	struct xfs_mount *mp,
 	uint		num_ops)
 {
@@ -146,7 +146,7 @@ xfs_calc_inobt_res(
 {
 	return xfs_calc_buf_res(M_IGEO(mp)->inobt_maxlevels,
 			XFS_FSB_TO_B(mp, 1)) +
-				xfs_calc_buf_res(xfs_allocfree_log_count(mp, 1),
+				xfs_calc_buf_res(xfs_allocfree_block_count(mp, 1),
 			XFS_FSB_TO_B(mp, 1));
 }
 
@@ -193,7 +193,7 @@ xfs_calc_inode_chunk_res(
 {
 	uint			res, size = 0;
 
-	res = xfs_calc_buf_res(xfs_allocfree_log_count(mp, 1),
+	res = xfs_calc_buf_res(xfs_allocfree_block_count(mp, 1),
 			       XFS_FSB_TO_B(mp, 1));
 	if (alloc) {
 		/* icreate tx uses ordered buffers */
@@ -213,7 +213,7 @@ xfs_calc_inode_chunk_res(
  * extents, as well as the realtime summary block.
  */
 static unsigned int
-xfs_rtalloc_log_count(
+xfs_rtalloc_block_count(
 	struct xfs_mount	*mp,
 	unsigned int		num_ops)
 {
@@ -300,21 +300,21 @@ xfs_calc_write_reservation(
 	t1 = xfs_calc_inode_res(mp, 1) +
 	     xfs_calc_buf_res(XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK), blksz) +
 	     xfs_calc_buf_res(3, mp->m_sb.sb_sectsize) +
-	     xfs_calc_buf_res(xfs_allocfree_log_count(mp, 2), blksz);
+	     xfs_calc_buf_res(xfs_allocfree_block_count(mp, 2), blksz);
 
 	if (xfs_has_realtime(mp)) {
 		t2 = xfs_calc_inode_res(mp, 1) +
 		     xfs_calc_buf_res(XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK),
 				     blksz) +
 		     xfs_calc_buf_res(3, mp->m_sb.sb_sectsize) +
-		     xfs_calc_buf_res(xfs_rtalloc_log_count(mp, 1), blksz) +
-		     xfs_calc_buf_res(xfs_allocfree_log_count(mp, 1), blksz);
+		     xfs_calc_buf_res(xfs_rtalloc_block_count(mp, 1), blksz) +
+		     xfs_calc_buf_res(xfs_allocfree_block_count(mp, 1), blksz);
 	} else {
 		t2 = 0;
 	}
 
 	t3 = xfs_calc_buf_res(5, mp->m_sb.sb_sectsize) +
-	     xfs_calc_buf_res(xfs_allocfree_log_count(mp, 2), blksz);
+	     xfs_calc_buf_res(xfs_allocfree_block_count(mp, 2), blksz);
 
 	/*
 	 * In the early days of reflink, we included enough reservation to log
@@ -381,12 +381,12 @@ xfs_calc_itruncate_reservation(
 	     xfs_calc_buf_res(XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK) + 1, blksz);
 
 	t2 = xfs_calc_buf_res(9, mp->m_sb.sb_sectsize) +
-	     xfs_calc_buf_res(xfs_allocfree_log_count(mp, 4), blksz);
+	     xfs_calc_buf_res(xfs_allocfree_block_count(mp, 4), blksz);
 
 	if (xfs_has_realtime(mp)) {
 		t3 = xfs_calc_buf_res(5, mp->m_sb.sb_sectsize) +
-		     xfs_calc_buf_res(xfs_rtalloc_log_count(mp, 2), blksz) +
-		     xfs_calc_buf_res(xfs_allocfree_log_count(mp, 2), blksz);
+		     xfs_calc_buf_res(xfs_rtalloc_block_count(mp, 2), blksz) +
+		     xfs_calc_buf_res(xfs_allocfree_block_count(mp, 2), blksz);
 	} else {
 		t3 = 0;
 	}
@@ -441,7 +441,7 @@ xfs_calc_rename_reservation(
 		     xfs_calc_buf_res(2 * XFS_DIROP_LOG_COUNT(mp),
 				      XFS_FSB_TO_B(mp, 1))),
 		    (xfs_calc_buf_res(7, mp->m_sb.sb_sectsize) +
-		     xfs_calc_buf_res(xfs_allocfree_log_count(mp, 3),
+		     xfs_calc_buf_res(xfs_allocfree_block_count(mp, 3),
 				      XFS_FSB_TO_B(mp, 1))));
 }
 
@@ -481,7 +481,7 @@ xfs_calc_link_reservation(
 		     xfs_calc_buf_res(XFS_DIROP_LOG_COUNT(mp),
 				      XFS_FSB_TO_B(mp, 1))),
 		    (xfs_calc_buf_res(3, mp->m_sb.sb_sectsize) +
-		     xfs_calc_buf_res(xfs_allocfree_log_count(mp, 1),
+		     xfs_calc_buf_res(xfs_allocfree_block_count(mp, 1),
 				      XFS_FSB_TO_B(mp, 1))));
 }
 
@@ -519,7 +519,7 @@ xfs_calc_remove_reservation(
 		     xfs_calc_buf_res(XFS_DIROP_LOG_COUNT(mp),
 				      XFS_FSB_TO_B(mp, 1))),
 		    (xfs_calc_buf_res(4, mp->m_sb.sb_sectsize) +
-		     xfs_calc_buf_res(xfs_allocfree_log_count(mp, 2),
+		     xfs_calc_buf_res(xfs_allocfree_block_count(mp, 2),
 				      XFS_FSB_TO_B(mp, 1))));
 }
 
@@ -664,7 +664,7 @@ xfs_calc_growdata_reservation(
 	struct xfs_mount	*mp)
 {
 	return xfs_calc_buf_res(3, mp->m_sb.sb_sectsize) +
-		xfs_calc_buf_res(xfs_allocfree_log_count(mp, 1),
+		xfs_calc_buf_res(xfs_allocfree_block_count(mp, 1),
 				 XFS_FSB_TO_B(mp, 1));
 }
 
@@ -686,7 +686,7 @@ xfs_calc_growrtalloc_reservation(
 		xfs_calc_buf_res(XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK),
 				 XFS_FSB_TO_B(mp, 1)) +
 		xfs_calc_inode_res(mp, 1) +
-		xfs_calc_buf_res(xfs_allocfree_log_count(mp, 1),
+		xfs_calc_buf_res(xfs_allocfree_block_count(mp, 1),
 				 XFS_FSB_TO_B(mp, 1));
 }
 
@@ -762,7 +762,7 @@ xfs_calc_addafork_reservation(
 		xfs_calc_buf_res(1, mp->m_dir_geo->blksize) +
 		xfs_calc_buf_res(XFS_DAENTER_BMAP1B(mp, XFS_DATA_FORK) + 1,
 				 XFS_FSB_TO_B(mp, 1)) +
-		xfs_calc_buf_res(xfs_allocfree_log_count(mp, 1),
+		xfs_calc_buf_res(xfs_allocfree_block_count(mp, 1),
 				 XFS_FSB_TO_B(mp, 1));
 }
 
@@ -785,7 +785,7 @@ xfs_calc_attrinval_reservation(
 		    xfs_calc_buf_res(XFS_BM_MAXLEVELS(mp, XFS_ATTR_FORK),
 				     XFS_FSB_TO_B(mp, 1))),
 		   (xfs_calc_buf_res(9, mp->m_sb.sb_sectsize) +
-		    xfs_calc_buf_res(xfs_allocfree_log_count(mp, 4),
+		    xfs_calc_buf_res(xfs_allocfree_block_count(mp, 4),
 				     XFS_FSB_TO_B(mp, 1))));
 }
 
@@ -852,7 +852,7 @@ xfs_calc_attrrm_reservation(
 					XFS_BM_MAXLEVELS(mp, XFS_ATTR_FORK)) +
 		     xfs_calc_buf_res(XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK), 0)),
 		    (xfs_calc_buf_res(5, mp->m_sb.sb_sectsize) +
-		     xfs_calc_buf_res(xfs_allocfree_log_count(mp, 2),
+		     xfs_calc_buf_res(xfs_allocfree_block_count(mp, 2),
 				      XFS_FSB_TO_B(mp, 1))));
 }
 
diff --git a/fs/xfs/libxfs/xfs_trans_resv.h b/fs/xfs/libxfs/xfs_trans_resv.h
index 22b99042127a..0554b9d775d2 100644
--- a/fs/xfs/libxfs/xfs_trans_resv.h
+++ b/fs/xfs/libxfs/xfs_trans_resv.h
@@ -96,7 +96,7 @@ struct xfs_trans_resv {
 #define	XFS_WRITE_LOG_COUNT_REFLINK	8
 
 void xfs_trans_resv_calc(struct xfs_mount *mp, struct xfs_trans_resv *resp);
-uint xfs_allocfree_log_count(struct xfs_mount *mp, uint num_ops);
+uint xfs_allocfree_block_count(struct xfs_mount *mp, uint num_ops);
 
 unsigned int xfs_calc_itruncate_reservation_minlogsize(struct xfs_mount *mp);
 unsigned int xfs_calc_write_reservation_minlogsize(struct xfs_mount *mp);

