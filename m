Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 151A9C3DA7C
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 01:50:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236094AbiLaBuM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 20:50:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236079AbiLaBuL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 20:50:11 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 823CC1DDD3
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 17:50:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1A5BCB81DF9
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 01:50:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACCEEC433EF;
        Sat, 31 Dec 2022 01:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672451406;
        bh=5zkxpPy9Pm7WNXl+g9+gbvWMUn9dl9MOz+10UFtcrNo=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Ue8p1+7wP8kT/eQmwjvzAihA7qsSAsXnYIjiNcBh2O3ZxN6zCChBs5RlHidt/ibtK
         UVuTEqBnsMK9p+geWuxtrhg6p1bMPb9eqP2nUKsA6B0xAwgFzpmlojzELFzzVR5+KN
         gX1p6danr29slR8gqnvQu4Ygts0Mx2LIaoEo5EPqUhflYI/1Ix6P+0Bf9QSSpQPdmd
         SIo8U4Ilsjf+ZbHbfpBkT5R9f7zr+7GLiY1IuMrRwoqMe++c6tTqi2zYtgUeFPNEQ/
         6w6ppZIntdY9TmwQMSdpGrVd6PGoWWIXjFeuxIhw3+fTX+qAvjzviIxyuaQeDoqzMo
         kRnTAa/PEtJzw==
Subject: [PATCH 08/42] xfs: add a realtime flag to the refcount update log
 redo items
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:18:30 -0800
Message-ID: <167243871011.717073.12110454853946893456.stgit@magnolia>
In-Reply-To: <167243870849.717073.203452386730176902.stgit@magnolia>
References: <167243870849.717073.203452386730176902.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Extend the refcount update (CUI) log items with a new realtime flag that
indicates that the updates apply against the realtime refcountbt.  We'll
wire up the actual refcount code later.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_bmap.c       |   10 ++-
 fs/xfs/libxfs/xfs_defer.c      |    1 
 fs/xfs/libxfs/xfs_defer.h      |    1 
 fs/xfs/libxfs/xfs_log_format.h |    5 +
 fs/xfs/libxfs/xfs_refcount.c   |  156 +++++++++++++++++++++++++++++-----------
 fs/xfs/libxfs/xfs_refcount.h   |   18 +++--
 fs/xfs/scrub/cow_repair.c      |    2 -
 fs/xfs/scrub/reap.c            |    5 +
 fs/xfs/xfs_refcount_item.c     |   32 ++++++++
 fs/xfs/xfs_reflink.c           |   19 +++--
 10 files changed, 184 insertions(+), 65 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 8c683db35788..b46504d861e3 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -4529,8 +4529,9 @@ xfs_bmapi_write(
 			 * the refcount btree for orphan recovery.
 			 */
 			if (whichfork == XFS_COW_FORK)
-				xfs_refcount_alloc_cow_extent(tp, bma.blkno,
-						bma.length);
+				xfs_refcount_alloc_cow_extent(tp,
+						XFS_IS_REALTIME_INODE(ip),
+						bma.blkno, bma.length);
 		}
 
 		/* Deal with the allocated space we found.  */
@@ -4696,7 +4697,8 @@ xfs_bmapi_convert_delalloc(
 	*seq = READ_ONCE(ifp->if_seq);
 
 	if (whichfork == XFS_COW_FORK)
-		xfs_refcount_alloc_cow_extent(tp, bma.blkno, bma.length);
+		xfs_refcount_alloc_cow_extent(tp, XFS_IS_REALTIME_INODE(ip),
+				bma.blkno, bma.length);
 
 	error = xfs_bmap_btree_to_extents(tp, ip, bma.cur, &bma.logflags,
 			whichfork);
@@ -5313,7 +5315,7 @@ xfs_bmap_del_extent_real(
 	 */
 	if (want_free) {
 		if (xfs_is_reflink_inode(ip) && whichfork == XFS_DATA_FORK) {
-			xfs_refcount_decrease_extent(tp, del);
+			xfs_refcount_decrease_extent(tp, isrt, del);
 		} else {
 			unsigned int	efi_flags = 0;
 
diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
index ce3bc5fe2bdc..1aefb4c99e7b 100644
--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -186,6 +186,7 @@ static struct kmem_cache	*xfs_defer_pending_cache;
 static const struct xfs_defer_op_type *defer_op_types[] = {
 	[XFS_DEFER_OPS_TYPE_BMAP]	= &xfs_bmap_update_defer_type,
 	[XFS_DEFER_OPS_TYPE_REFCOUNT]	= &xfs_refcount_update_defer_type,
+	[XFS_DEFER_OPS_TYPE_REFCOUNT_RT] = &xfs_refcount_update_defer_type,
 	[XFS_DEFER_OPS_TYPE_RMAP]	= &xfs_rmap_update_defer_type,
 	[XFS_DEFER_OPS_TYPE_RMAP_RT]	= &xfs_rmap_update_defer_type,
 	[XFS_DEFER_OPS_TYPE_FREE]	= &xfs_extent_free_defer_type,
diff --git a/fs/xfs/libxfs/xfs_defer.h b/fs/xfs/libxfs/xfs_defer.h
index 89c279185ce6..8564777c4c49 100644
--- a/fs/xfs/libxfs/xfs_defer.h
+++ b/fs/xfs/libxfs/xfs_defer.h
@@ -16,6 +16,7 @@ struct xfs_defer_capture;
 enum xfs_defer_ops_type {
 	XFS_DEFER_OPS_TYPE_BMAP,
 	XFS_DEFER_OPS_TYPE_REFCOUNT,
+	XFS_DEFER_OPS_TYPE_REFCOUNT_RT,
 	XFS_DEFER_OPS_TYPE_RMAP,
 	XFS_DEFER_OPS_TYPE_RMAP_RT,
 	XFS_DEFER_OPS_TYPE_FREE,
diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
index 3a23282d6e6f..66cfcafae9b8 100644
--- a/fs/xfs/libxfs/xfs_log_format.h
+++ b/fs/xfs/libxfs/xfs_log_format.h
@@ -800,7 +800,10 @@ struct xfs_phys_extent {
 /* Type codes are taken directly from enum xfs_refcount_intent_type. */
 #define XFS_REFCOUNT_EXTENT_TYPE_MASK	0xFF
 
-#define XFS_REFCOUNT_EXTENT_FLAGS	(XFS_REFCOUNT_EXTENT_TYPE_MASK)
+#define XFS_REFCOUNT_EXTENT_REALTIME	(1U << 31)
+
+#define XFS_REFCOUNT_EXTENT_FLAGS	(XFS_REFCOUNT_EXTENT_TYPE_MASK | \
+					 XFS_REFCOUNT_EXTENT_REALTIME)
 
 /*
  * This is the structure used to lay out a cui log item in the
diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
index a54a633f2ef9..999ba2c5c37d 100644
--- a/fs/xfs/libxfs/xfs_refcount.c
+++ b/fs/xfs/libxfs/xfs_refcount.c
@@ -25,6 +25,7 @@
 #include "xfs_ag.h"
 #include "xfs_health.h"
 #include "xfs_rtgroup.h"
+#include "xfs_rtalloc.h"
 
 struct kmem_cache	*xfs_refcount_intent_cache;
 
@@ -1141,6 +1142,28 @@ xfs_refcount_still_have_space(
 		xrefc_btree_state(cur)->nr_ops * XFS_REFCOUNT_ITEM_OVERHEAD;
 }
 
+/* Schedule an extent free. */
+static void
+xrefc_free_extent(
+	struct xfs_btree_cur		*cur,
+	struct xfs_refcount_irec	*rec)
+{
+	xfs_fsblock_t			fsbno;
+	unsigned int			flags = 0;
+
+	if (cur->bc_btnum == XFS_BTNUM_RTREFC) {
+		flags |= XFS_FREE_EXTENT_REALTIME;
+		fsbno = xfs_rgbno_to_rtb(cur->bc_mp, cur->bc_ino.rtg->rtg_rgno,
+				rec->rc_startblock);
+	} else {
+		fsbno = XFS_AGB_TO_FSB(cur->bc_mp, cur->bc_ag.pag->pag_agno,
+				rec->rc_startblock);
+	}
+
+	xfs_free_extent_later(cur->bc_tp, fsbno, rec->rc_blockcount, NULL,
+			flags);
+}
+
 /*
  * Adjust the refcounts of middle extents.  At this point we should have
  * split extents that crossed the adjustment range; merged with adjacent
@@ -1157,7 +1180,6 @@ xfs_refcount_adjust_extents(
 	struct xfs_refcount_irec	ext, tmp;
 	int				error;
 	int				found_rec, found_tmp;
-	xfs_fsblock_t			fsbno;
 
 	/* Merging did all the work already. */
 	if (*aglen == 0)
@@ -1210,11 +1232,7 @@ xfs_refcount_adjust_extents(
 					goto out_error;
 				}
 			} else {
-				fsbno = XFS_AGB_TO_FSB(cur->bc_mp,
-						cur->bc_ag.pag->pag_agno,
-						tmp.rc_startblock);
-				xfs_free_extent_later(cur->bc_tp, fsbno,
-						tmp.rc_blockcount, NULL, 0);
+				xrefc_free_extent(cur, &tmp);
 			}
 
 			(*agbno) += tmp.rc_blockcount;
@@ -1270,11 +1288,7 @@ xfs_refcount_adjust_extents(
 			}
 			goto advloop;
 		} else {
-			fsbno = XFS_AGB_TO_FSB(cur->bc_mp,
-					cur->bc_ag.pag->pag_agno,
-					ext.rc_startblock);
-			xfs_free_extent_later(cur->bc_tp, fsbno,
-					ext.rc_blockcount, NULL, 0);
+			xrefc_free_extent(cur, &ext);
 		}
 
 skip:
@@ -1358,19 +1372,31 @@ xfs_refcount_finish_one_cleanup(
 	struct xfs_btree_cur	*rcur,
 	int			error)
 {
-	struct xfs_buf		*agbp;
+	struct xfs_buf		*agbp = NULL;
 
 	if (rcur == NULL)
 		return;
-	agbp = rcur->bc_ag.agbp;
+	if (rcur->bc_btnum == XFS_BTNUM_REFC)
+		agbp = rcur->bc_ag.agbp;
 	xfs_btree_del_cursor(rcur, error);
-	if (error)
+	if (agbp)
 		xfs_trans_brelse(tp, agbp);
 }
 
+/* Does this btree cursor match the given AG? */
+static inline bool
+xfs_refcount_is_wrong_cursor(
+	struct xfs_btree_cur		*cur,
+	struct xfs_refcount_intent	*ri)
+{
+	if (cur->bc_btnum == XFS_BTNUM_RTREFC)
+		return cur->bc_ino.rtg != ri->ri_rtg;
+	return cur->bc_ag.pag != ri->ri_pag;
+}
+
 /*
  * Set up a continuation a deferred refcount operation by updating the intent.
- * Checks to make sure we're not going to run off the end of the AG.
+ * Checks to make sure we're not going to run off the end of the AG or rtgroup.
  */
 static inline int
 xfs_refcount_continue_op(
@@ -1379,19 +1405,35 @@ xfs_refcount_continue_op(
 	xfs_agblock_t			new_agbno)
 {
 	struct xfs_mount		*mp = cur->bc_mp;
-	struct xfs_perag		*pag = cur->bc_ag.pag;
 
-	if (XFS_IS_CORRUPT(mp, !xfs_verify_agbext(pag, new_agbno,
-					ri->ri_blockcount))) {
-		xfs_btree_mark_sick(cur);
-		return -EFSCORRUPTED;
+	if (ri->ri_realtime) {
+		struct xfs_rtgroup	*rtg = ri->ri_rtg;
+
+		if (XFS_IS_CORRUPT(mp, !xfs_verify_rgbext(rtg, new_agbno,
+						ri->ri_blockcount))) {
+			xfs_btree_mark_sick(cur);
+			return -EFSCORRUPTED;
+		}
+
+		ri->ri_startblock = xfs_rgbno_to_rtb(mp, rtg->rtg_rgno, new_agbno);
+
+		ASSERT(xfs_verify_rtbext(mp, ri->ri_startblock, ri->ri_blockcount));
+		ASSERT(rtg->rtg_rgno == xfs_rtb_to_rgno(mp, ri->ri_startblock));
+	} else {
+		struct xfs_perag		*pag = cur->bc_ag.pag;
+
+		if (XFS_IS_CORRUPT(mp, !xfs_verify_agbext(pag, new_agbno,
+						ri->ri_blockcount))) {
+			xfs_btree_mark_sick(cur);
+			return -EFSCORRUPTED;
+		}
+
+		ri->ri_startblock = XFS_AGB_TO_FSB(mp, pag->pag_agno, new_agbno);
+
+		ASSERT(xfs_verify_fsbext(mp, ri->ri_startblock, ri->ri_blockcount));
+		ASSERT(pag->pag_agno == XFS_FSB_TO_AGNO(mp, ri->ri_startblock));
 	}
 
-	ri->ri_startblock = XFS_AGB_TO_FSB(mp, pag->pag_agno, new_agbno);
-
-	ASSERT(xfs_verify_fsbext(mp, ri->ri_startblock, ri->ri_blockcount));
-	ASSERT(pag->pag_agno == XFS_FSB_TO_AGNO(mp, ri->ri_startblock));
-
 	return 0;
 }
 
@@ -1416,10 +1458,16 @@ xfs_refcount_finish_one(
 	unsigned long			nr_ops = 0;
 	int				shape_changes = 0;
 
-	bno = XFS_FSB_TO_AGBNO(mp, ri->ri_startblock);
-
 	trace_xfs_refcount_deferred(mp, ri);
 
+	if (ri->ri_realtime) {
+		xfs_rgnumber_t		rgno;
+
+		bno = xfs_rtb_to_rgbno(mp, ri->ri_startblock, &rgno);
+	} else {
+		bno = XFS_FSB_TO_AGBNO(mp, ri->ri_startblock);
+	}
+
 	if (XFS_TEST_ERROR(false, mp, XFS_ERRTAG_REFCOUNT_FINISH_ONE))
 		return -EIO;
 
@@ -1428,7 +1476,7 @@ xfs_refcount_finish_one(
 	 * the startblock, get one now.
 	 */
 	rcur = *pcur;
-	if (rcur != NULL && rcur->bc_ag.pag != ri->ri_pag) {
+	if (rcur != NULL && xfs_refcount_is_wrong_cursor(rcur, ri)) {
 		nr_ops = xrefc_btree_state(rcur)->nr_ops;
 		shape_changes = xrefc_btree_state(rcur)->shape_changes;
 		xfs_refcount_finish_one_cleanup(tp, rcur, 0);
@@ -1436,12 +1484,19 @@ xfs_refcount_finish_one(
 		*pcur = NULL;
 	}
 	if (rcur == NULL) {
-		error = xfs_alloc_read_agf(ri->ri_pag, tp,
-				XFS_ALLOC_FLAG_FREEING, &agbp);
-		if (error)
-			return error;
+		if (ri->ri_realtime) {
+			/* coming in a later patch */
+			ASSERT(0);
+			return -EFSCORRUPTED;
+		} else {
+			error = xfs_alloc_read_agf(ri->ri_pag, tp,
+					XFS_ALLOC_FLAG_FREEING, &agbp);
+			if (error)
+				return error;
 
-		rcur = xfs_refcountbt_init_cursor(mp, tp, agbp, ri->ri_pag);
+			rcur = xfs_refcountbt_init_cursor(mp, tp, agbp,
+					ri->ri_pag);
+		}
 		xrefc_btree_state(rcur)->nr_ops = nr_ops;
 		xrefc_btree_state(rcur)->shape_changes = shape_changes;
 	}
@@ -1492,10 +1547,12 @@ static void
 __xfs_refcount_add(
 	struct xfs_trans		*tp,
 	enum xfs_refcount_intent_type	type,
+	bool				isrt,
 	xfs_fsblock_t			startblock,
 	xfs_extlen_t			blockcount)
 {
 	struct xfs_refcount_intent	*ri;
+	enum xfs_defer_ops_type		optype;
 
 	ri = kmem_cache_alloc(xfs_refcount_intent_cache,
 			GFP_NOFS | __GFP_NOFAIL);
@@ -1503,11 +1560,24 @@ __xfs_refcount_add(
 	ri->ri_type = type;
 	ri->ri_startblock = startblock;
 	ri->ri_blockcount = blockcount;
+	ri->ri_realtime = isrt;
 
 	trace_xfs_refcount_defer(tp->t_mountp, ri);
 
+	/*
+	 * Deferred refcount updates for the realtime and data sections must
+	 * use separate transactions to finish deferred work because updates to
+	 * realtime metadata files can lock AGFs to allocate btree blocks and
+	 * we don't want that mixing with the AGF locks taken to finish data
+	 * section updates.
+	 */
+	if (isrt)
+		optype = XFS_DEFER_OPS_TYPE_REFCOUNT_RT;
+	else
+		optype = XFS_DEFER_OPS_TYPE_REFCOUNT;
+
 	xfs_refcount_update_get_group(tp->t_mountp, ri);
-	xfs_defer_add(tp, XFS_DEFER_OPS_TYPE_REFCOUNT, &ri->ri_list);
+	xfs_defer_add(tp, optype, &ri->ri_list);
 }
 
 /*
@@ -1516,12 +1586,13 @@ __xfs_refcount_add(
 void
 xfs_refcount_increase_extent(
 	struct xfs_trans		*tp,
+	bool				isrt,
 	struct xfs_bmbt_irec		*PREV)
 {
 	if (!xfs_has_reflink(tp->t_mountp))
 		return;
 
-	__xfs_refcount_add(tp, XFS_REFCOUNT_INCREASE, PREV->br_startblock,
+	__xfs_refcount_add(tp, XFS_REFCOUNT_INCREASE, isrt, PREV->br_startblock,
 			PREV->br_blockcount);
 }
 
@@ -1531,12 +1602,13 @@ xfs_refcount_increase_extent(
 void
 xfs_refcount_decrease_extent(
 	struct xfs_trans		*tp,
+	bool				isrt,
 	struct xfs_bmbt_irec		*PREV)
 {
 	if (!xfs_has_reflink(tp->t_mountp))
 		return;
 
-	__xfs_refcount_add(tp, XFS_REFCOUNT_DECREASE, PREV->br_startblock,
+	__xfs_refcount_add(tp, XFS_REFCOUNT_DECREASE, isrt, PREV->br_startblock,
 			PREV->br_blockcount);
 }
 
@@ -1892,6 +1964,7 @@ __xfs_refcount_cow_free(
 void
 xfs_refcount_alloc_cow_extent(
 	struct xfs_trans		*tp,
+	bool				isrt,
 	xfs_fsblock_t			fsb,
 	xfs_extlen_t			len)
 {
@@ -1900,16 +1973,17 @@ xfs_refcount_alloc_cow_extent(
 	if (!xfs_has_reflink(mp))
 		return;
 
-	__xfs_refcount_add(tp, XFS_REFCOUNT_ALLOC_COW, fsb, len);
+	__xfs_refcount_add(tp, XFS_REFCOUNT_ALLOC_COW, isrt, fsb, len);
 
 	/* Add rmap entry */
-	xfs_rmap_alloc_extent(tp, false, fsb, len, XFS_RMAP_OWN_COW);
+	xfs_rmap_alloc_extent(tp, isrt, fsb, len, XFS_RMAP_OWN_COW);
 }
 
 /* Forget a CoW staging event in the refcount btree. */
 void
 xfs_refcount_free_cow_extent(
 	struct xfs_trans		*tp,
+	bool				isrt,
 	xfs_fsblock_t			fsb,
 	xfs_extlen_t			len)
 {
@@ -1919,8 +1993,8 @@ xfs_refcount_free_cow_extent(
 		return;
 
 	/* Remove rmap entry */
-	xfs_rmap_free_extent(tp, false, fsb, len, XFS_RMAP_OWN_COW);
-	__xfs_refcount_add(tp, XFS_REFCOUNT_FREE_COW, fsb, len);
+	xfs_rmap_free_extent(tp, isrt, fsb, len, XFS_RMAP_OWN_COW);
+	__xfs_refcount_add(tp, XFS_REFCOUNT_FREE_COW, isrt, fsb, len);
 }
 
 struct xfs_refcount_recovery {
@@ -2026,7 +2100,7 @@ xfs_refcount_recover_cow_leftovers(
 		/* Free the orphan record */
 		fsb = XFS_AGB_TO_FSB(mp, pag->pag_agno,
 				rr->rr_rrec.rc_startblock);
-		xfs_refcount_free_cow_extent(tp, fsb,
+		xfs_refcount_free_cow_extent(tp, false, fsb,
 				rr->rr_rrec.rc_blockcount);
 
 		/* Free the block. */
diff --git a/fs/xfs/libxfs/xfs_refcount.h b/fs/xfs/libxfs/xfs_refcount.h
index 7713bb908bdc..4e725d723e88 100644
--- a/fs/xfs/libxfs/xfs_refcount.h
+++ b/fs/xfs/libxfs/xfs_refcount.h
@@ -56,10 +56,14 @@ enum xfs_refcount_intent_type {
 
 struct xfs_refcount_intent {
 	struct list_head			ri_list;
-	struct xfs_perag			*ri_pag;
+	union {
+		struct xfs_perag		*ri_pag;
+		struct xfs_rtgroup		*ri_rtg;
+	};
 	enum xfs_refcount_intent_type		ri_type;
 	xfs_extlen_t				ri_blockcount;
 	xfs_fsblock_t				ri_startblock;
+	bool					ri_realtime;
 };
 
 /* Check that the refcount is appropriate for the record domain. */
@@ -77,9 +81,9 @@ xfs_refcount_check_domain(
 void xfs_refcount_update_get_group(struct xfs_mount *mp,
 		struct xfs_refcount_intent *ri);
 
-void xfs_refcount_increase_extent(struct xfs_trans *tp,
+void xfs_refcount_increase_extent(struct xfs_trans *tp, bool isrt,
 		struct xfs_bmbt_irec *irec);
-void xfs_refcount_decrease_extent(struct xfs_trans *tp,
+void xfs_refcount_decrease_extent(struct xfs_trans *tp, bool isrt,
 		struct xfs_bmbt_irec *irec);
 
 extern void xfs_refcount_finish_one_cleanup(struct xfs_trans *tp,
@@ -91,10 +95,10 @@ extern int xfs_refcount_find_shared(struct xfs_btree_cur *cur,
 		xfs_agblock_t agbno, xfs_extlen_t aglen, xfs_agblock_t *fbno,
 		xfs_extlen_t *flen, bool find_end_of_shared);
 
-void xfs_refcount_alloc_cow_extent(struct xfs_trans *tp, xfs_fsblock_t fsb,
-		xfs_extlen_t len);
-void xfs_refcount_free_cow_extent(struct xfs_trans *tp, xfs_fsblock_t fsb,
-		xfs_extlen_t len);
+void xfs_refcount_alloc_cow_extent(struct xfs_trans *tp, bool isrt,
+		xfs_fsblock_t fsb, xfs_extlen_t len);
+void xfs_refcount_free_cow_extent(struct xfs_trans *tp, bool isrt,
+		xfs_fsblock_t fsb, xfs_extlen_t len);
 extern int xfs_refcount_recover_cow_leftovers(struct xfs_mount *mp,
 		struct xfs_perag *pag);
 
diff --git a/fs/xfs/scrub/cow_repair.c b/fs/xfs/scrub/cow_repair.c
index 5292171e6a2b..a0c1d97ab8b6 100644
--- a/fs/xfs/scrub/cow_repair.c
+++ b/fs/xfs/scrub/cow_repair.c
@@ -336,7 +336,7 @@ xrep_cow_alloc(
 	if (args.fsbno == NULLFSBLOCK)
 		return -ENOSPC;
 
-	xfs_refcount_alloc_cow_extent(sc->tp, args.fsbno, args.len);
+	xfs_refcount_alloc_cow_extent(sc->tp, false, args.fsbno, args.len);
 
 	irec->br_startblock = args.fsbno;
 	irec->br_blockcount = args.len;
diff --git a/fs/xfs/scrub/reap.c b/fs/xfs/scrub/reap.c
index b0b29b1e139b..77354bdb0511 100644
--- a/fs/xfs/scrub/reap.c
+++ b/fs/xfs/scrub/reap.c
@@ -349,7 +349,8 @@ xreap_agextent(
 			 * If we're unmapping CoW staging extents, remove the
 			 * records from the refcountbt as well.
 			 */
-			xfs_refcount_free_cow_extent(sc->tp, fsbno, *aglenp);
+			xfs_refcount_free_cow_extent(sc->tp, false, fsbno,
+					*aglenp);
 			return 0;
 		}
 		return xfs_rmap_free(sc->tp, sc->sa.agf_bp, sc->sa.pag, agbno,
@@ -381,7 +382,7 @@ xreap_agextent(
 		ASSERT(rs->resv == XFS_AG_RESV_NONE);
 
 		rs->force_roll = true;
-		xfs_refcount_free_cow_extent(sc->tp, fsbno, *aglenp);
+		xfs_refcount_free_cow_extent(sc->tp, false, fsbno, *aglenp);
 		xfs_free_extent_later(sc->tp, fsbno, *aglenp, NULL,
 				XFS_FREE_EXTENT_SKIP_DISCARD);
 		return 0;
diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
index ccc334d482a4..7a366b316e79 100644
--- a/fs/xfs/xfs_refcount_item.c
+++ b/fs/xfs/xfs_refcount_item.c
@@ -21,6 +21,7 @@
 #include "xfs_log_priv.h"
 #include "xfs_log_recover.h"
 #include "xfs_ag.h"
+#include "xfs_rtgroup.h"
 
 struct kmem_cache	*xfs_cui_cache;
 struct kmem_cache	*xfs_cud_cache;
@@ -286,6 +287,11 @@ xfs_refcount_update_diff_items(
 	ra = container_of(a, struct xfs_refcount_intent, ri_list);
 	rb = container_of(b, struct xfs_refcount_intent, ri_list);
 
+	ASSERT(ra->ri_realtime == rb->ri_realtime);
+
+	if (ra->ri_realtime)
+		return ra->ri_rtg->rtg_rgno - rb->ri_rtg->rtg_rgno;
+
 	return ra->ri_pag->pag_agno - rb->ri_pag->pag_agno;
 }
 
@@ -324,6 +330,8 @@ xfs_refcount_update_log_item(
 	default:
 		ASSERT(0);
 	}
+	if (ri->ri_realtime)
+		pmap->pe_flags |= XFS_REFCOUNT_EXTENT_REALTIME;
 }
 
 static struct xfs_log_item *
@@ -365,6 +373,15 @@ xfs_refcount_update_get_group(
 {
 	xfs_agnumber_t			agno;
 
+	if (ri->ri_realtime) {
+		xfs_rgnumber_t	rgno;
+
+		rgno = xfs_rtb_to_rgno(mp, ri->ri_startblock);
+		ri->ri_rtg = xfs_rtgroup_get(mp, rgno);
+		xfs_rtgroup_bump_intents(ri->ri_rtg);
+		return;
+	}
+
 	agno = XFS_FSB_TO_AGNO(mp, ri->ri_startblock);
 	ri->ri_pag = xfs_perag_get(mp, agno);
 	xfs_perag_bump_intents(ri->ri_pag);
@@ -375,6 +392,12 @@ static inline void
 xfs_refcount_update_put_group(
 	struct xfs_refcount_intent	*ri)
 {
+	if (ri->ri_realtime) {
+		xfs_rtgroup_drop_intents(ri->ri_rtg);
+		xfs_rtgroup_put(ri->ri_rtg);
+		return;
+	}
+
 	xfs_perag_drop_intents(ri->ri_pag);
 	xfs_perag_put(ri->ri_pag);
 }
@@ -536,6 +559,7 @@ xfs_cui_item_recover(
 			goto abort_error;
 		}
 
+		fake.ri_realtime = pmap->pe_flags & XFS_REFCOUNT_EXTENT_REALTIME;
 		fake.ri_startblock = pmap->pe_startblock;
 		fake.ri_blockcount = pmap->pe_len;
 
@@ -561,18 +585,22 @@ xfs_cui_item_recover(
 
 			switch (fake.ri_type) {
 			case XFS_REFCOUNT_INCREASE:
-				xfs_refcount_increase_extent(tp, &irec);
+				xfs_refcount_increase_extent(tp,
+						fake.ri_realtime, &irec);
 				break;
 			case XFS_REFCOUNT_DECREASE:
-				xfs_refcount_decrease_extent(tp, &irec);
+				xfs_refcount_decrease_extent(tp,
+						fake.ri_realtime, &irec);
 				break;
 			case XFS_REFCOUNT_ALLOC_COW:
 				xfs_refcount_alloc_cow_extent(tp,
+						fake.ri_realtime,
 						irec.br_startblock,
 						irec.br_blockcount);
 				break;
 			case XFS_REFCOUNT_FREE_COW:
 				xfs_refcount_free_cow_extent(tp,
+						fake.ri_realtime,
 						irec.br_startblock,
 						irec.br_blockcount);
 				break;
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index cf514af238ce..52e73aa2c38e 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -585,6 +585,7 @@ xfs_reflink_cancel_cow_blocks(
 	struct xfs_ifork		*ifp = xfs_ifork_ptr(ip, XFS_COW_FORK);
 	struct xfs_bmbt_irec		got, del;
 	struct xfs_iext_cursor		icur;
+	bool				isrt = XFS_IS_REALTIME_INODE(ip);
 	int				error = 0;
 
 	if (!xfs_inode_has_cow_data(ip))
@@ -614,11 +615,12 @@ xfs_reflink_cancel_cow_blocks(
 			ASSERT((*tpp)->t_firstblock == NULLFSBLOCK);
 
 			/* Free the CoW orphan record. */
-			xfs_refcount_free_cow_extent(*tpp, del.br_startblock,
-					del.br_blockcount);
+			xfs_refcount_free_cow_extent(*tpp, isrt,
+					del.br_startblock, del.br_blockcount);
 
 			xfs_free_extent_later(*tpp, del.br_startblock,
-					del.br_blockcount, NULL, 0);
+					del.br_blockcount, NULL,
+					isrt ? XFS_FREE_EXTENT_REALTIME : 0);
 
 			/* Roll the transaction */
 			error = xfs_defer_finish(tpp);
@@ -726,6 +728,7 @@ xfs_reflink_end_cow_extent(
 	struct xfs_ifork	*ifp = xfs_ifork_ptr(ip, XFS_COW_FORK);
 	unsigned int		resblks;
 	int			nmaps;
+	bool			isrt = XFS_IS_REALTIME_INODE(ip);
 	int			error;
 
 	/* No COW extents?  That's easy! */
@@ -803,7 +806,7 @@ xfs_reflink_end_cow_extent(
 		 * or not), unmap the extent and drop its refcount.
 		 */
 		xfs_bmap_unmap_extent(tp, ip, XFS_DATA_FORK, &data);
-		xfs_refcount_decrease_extent(tp, &data);
+		xfs_refcount_decrease_extent(tp, isrt, &data);
 		xfs_trans_mod_dquot_byino(tp, ip, XFS_TRANS_DQ_BCOUNT,
 				-data.br_blockcount);
 	} else if (data.br_startblock == DELAYSTARTBLOCK) {
@@ -823,7 +826,8 @@ xfs_reflink_end_cow_extent(
 	}
 
 	/* Free the CoW orphan record. */
-	xfs_refcount_free_cow_extent(tp, del.br_startblock, del.br_blockcount);
+	xfs_refcount_free_cow_extent(tp, isrt, del.br_startblock,
+			del.br_blockcount);
 
 	/* Map the new blocks into the data fork. */
 	xfs_bmap_map_extent(tp, ip, XFS_DATA_FORK, &del);
@@ -1160,6 +1164,7 @@ xfs_reflink_remap_extent(
 	bool			quota_reserved = true;
 	bool			smap_real;
 	bool			dmap_written = xfs_bmap_is_written_extent(dmap);
+	bool			isrt = XFS_IS_REALTIME_INODE(ip);
 	int			iext_delta = 0;
 	int			nimaps;
 	int			error;
@@ -1291,7 +1296,7 @@ xfs_reflink_remap_extent(
 		 * or not), unmap the extent and drop its refcount.
 		 */
 		xfs_bmap_unmap_extent(tp, ip, XFS_DATA_FORK, &smap);
-		xfs_refcount_decrease_extent(tp, &smap);
+		xfs_refcount_decrease_extent(tp, isrt, &smap);
 		qdelta -= smap.br_blockcount;
 	} else if (smap.br_startblock == DELAYSTARTBLOCK) {
 		int		done;
@@ -1314,7 +1319,7 @@ xfs_reflink_remap_extent(
 	 * its refcount and map it into the file.
 	 */
 	if (dmap_written) {
-		xfs_refcount_increase_extent(tp, dmap);
+		xfs_refcount_increase_extent(tp, isrt, dmap);
 		xfs_bmap_map_extent(tp, ip, XFS_DATA_FORK, dmap);
 		qdelta += dmap->br_blockcount;
 	}

