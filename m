Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BB17C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:56:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236289AbiLaC4E (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:56:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236243AbiLaC4D (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:56:03 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B39AFFD07
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:56:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 44A3EB81E52
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:56:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3990C433D2;
        Sat, 31 Dec 2022 02:55:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672455359;
        bh=DjPvMdwrTEMnzTqJcvjwoL92sLyTw5dlH+cmG1Qe9nA=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=o3JUg5Vsa2PxcMlXfz1WpUqQefr1ejACJuRj4N3uyMFtcVxwyMYwlck+OrDDTrzV8
         EmJdkCCnSSE4qOfspL7WO2tZ33ai/blSDRbenZ6sQvoUCeWbQ1JRzojBa1d4oU4/wC
         3wBzuJBxTgp5MphAD6jCQgwNFsMDp5RQKLLraC+0gBTDKSqPFM24EaPElQWgQ8WtSn
         6VBGksQsFEl0OtHIBrmU7QnLrAJBw1i+d38a1r9G/qOR/fG2pMER9O2X8KHfThWZNZ
         rno5HgcmZdfPZ+dd3elpquDHxt31nMvAnafVxysVWEJlpB2qBamDcsLq/s5IkDuFD+
         TCJq/F3aCoZvQ==
Subject: [PATCH 07/41] xfs: add a realtime flag to the refcount update log
 redo items
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:20:08 -0800
Message-ID: <167243880862.734096.16749713609164309138.stgit@magnolia>
In-Reply-To: <167243880752.734096.171910706541747310.stgit@magnolia>
References: <167243880752.734096.171910706541747310.stgit@magnolia>
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
 libxfs/defer_item.c     |   20 ++++++
 libxfs/xfs_bmap.c       |   10 ++-
 libxfs/xfs_defer.c      |    1 
 libxfs/xfs_defer.h      |    1 
 libxfs/xfs_log_format.h |    5 +-
 libxfs/xfs_refcount.c   |  155 +++++++++++++++++++++++++++++++++++------------
 libxfs/xfs_refcount.h   |   18 +++--
 7 files changed, 157 insertions(+), 53 deletions(-)


diff --git a/libxfs/defer_item.c b/libxfs/defer_item.c
index baf3b9e6204..df66f54138f 100644
--- a/libxfs/defer_item.c
+++ b/libxfs/defer_item.c
@@ -365,6 +365,11 @@ xfs_refcount_update_diff_items(
 	ra = container_of(a, struct xfs_refcount_intent, ri_list);
 	rb = container_of(b, struct xfs_refcount_intent, ri_list);
 
+	ASSERT(ra->ri_realtime == rb->ri_realtime);
+
+	if (ra->ri_realtime)
+		return ra->ri_rtg->rtg_rgno - rb->ri_rtg->rtg_rgno;
+
 	return ra->ri_pag->pag_agno - rb->ri_pag->pag_agno;
 }
 
@@ -401,6 +406,15 @@ xfs_refcount_update_get_group(
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
@@ -411,6 +425,12 @@ static inline void
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
diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index d0588d3fa70..6795f070214 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -4523,8 +4523,9 @@ xfs_bmapi_write(
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
@@ -4690,7 +4691,8 @@ xfs_bmapi_convert_delalloc(
 	*seq = READ_ONCE(ifp->if_seq);
 
 	if (whichfork == XFS_COW_FORK)
-		xfs_refcount_alloc_cow_extent(tp, bma.blkno, bma.length);
+		xfs_refcount_alloc_cow_extent(tp, XFS_IS_REALTIME_INODE(ip),
+				bma.blkno, bma.length);
 
 	error = xfs_bmap_btree_to_extents(tp, ip, bma.cur, &bma.logflags,
 			whichfork);
@@ -5307,7 +5309,7 @@ xfs_bmap_del_extent_real(
 	 */
 	if (want_free) {
 		if (xfs_is_reflink_inode(ip) && whichfork == XFS_DATA_FORK) {
-			xfs_refcount_decrease_extent(tp, del);
+			xfs_refcount_decrease_extent(tp, isrt, del);
 		} else {
 			unsigned int	efi_flags = 0;
 
diff --git a/libxfs/xfs_defer.c b/libxfs/xfs_defer.c
index 9dbab9ac955..1d8bf2f6f65 100644
--- a/libxfs/xfs_defer.c
+++ b/libxfs/xfs_defer.c
@@ -181,6 +181,7 @@ static struct kmem_cache	*xfs_defer_pending_cache;
 static const struct xfs_defer_op_type *defer_op_types[] = {
 	[XFS_DEFER_OPS_TYPE_BMAP]	= &xfs_bmap_update_defer_type,
 	[XFS_DEFER_OPS_TYPE_REFCOUNT]	= &xfs_refcount_update_defer_type,
+	[XFS_DEFER_OPS_TYPE_REFCOUNT_RT] = &xfs_refcount_update_defer_type,
 	[XFS_DEFER_OPS_TYPE_RMAP]	= &xfs_rmap_update_defer_type,
 	[XFS_DEFER_OPS_TYPE_RMAP_RT]	= &xfs_rmap_update_defer_type,
 	[XFS_DEFER_OPS_TYPE_FREE]	= &xfs_extent_free_defer_type,
diff --git a/libxfs/xfs_defer.h b/libxfs/xfs_defer.h
index 89c279185ce..8564777c4c4 100644
--- a/libxfs/xfs_defer.h
+++ b/libxfs/xfs_defer.h
@@ -16,6 +16,7 @@ struct xfs_defer_capture;
 enum xfs_defer_ops_type {
 	XFS_DEFER_OPS_TYPE_BMAP,
 	XFS_DEFER_OPS_TYPE_REFCOUNT,
+	XFS_DEFER_OPS_TYPE_REFCOUNT_RT,
 	XFS_DEFER_OPS_TYPE_RMAP,
 	XFS_DEFER_OPS_TYPE_RMAP_RT,
 	XFS_DEFER_OPS_TYPE_FREE,
diff --git a/libxfs/xfs_log_format.h b/libxfs/xfs_log_format.h
index 3a23282d6e6..66cfcafae9b 100644
--- a/libxfs/xfs_log_format.h
+++ b/libxfs/xfs_log_format.h
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
diff --git a/libxfs/xfs_refcount.c b/libxfs/xfs_refcount.c
index 248761ca1dd..960dbb401bd 100644
--- a/libxfs/xfs_refcount.c
+++ b/libxfs/xfs_refcount.c
@@ -1140,6 +1140,28 @@ xfs_refcount_still_have_space(
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
@@ -1156,7 +1178,6 @@ xfs_refcount_adjust_extents(
 	struct xfs_refcount_irec	ext, tmp;
 	int				error;
 	int				found_rec, found_tmp;
-	xfs_fsblock_t			fsbno;
 
 	/* Merging did all the work already. */
 	if (*aglen == 0)
@@ -1209,11 +1230,7 @@ xfs_refcount_adjust_extents(
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
@@ -1269,11 +1286,7 @@ xfs_refcount_adjust_extents(
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
@@ -1357,19 +1370,31 @@ xfs_refcount_finish_one_cleanup(
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
@@ -1378,19 +1403,35 @@ xfs_refcount_continue_op(
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
 
@@ -1415,10 +1456,16 @@ xfs_refcount_finish_one(
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
 
@@ -1427,7 +1474,7 @@ xfs_refcount_finish_one(
 	 * the startblock, get one now.
 	 */
 	rcur = *pcur;
-	if (rcur != NULL && rcur->bc_ag.pag != ri->ri_pag) {
+	if (rcur != NULL && xfs_refcount_is_wrong_cursor(rcur, ri)) {
 		nr_ops = xrefc_btree_state(rcur)->nr_ops;
 		shape_changes = xrefc_btree_state(rcur)->shape_changes;
 		xfs_refcount_finish_one_cleanup(tp, rcur, 0);
@@ -1435,12 +1482,19 @@ xfs_refcount_finish_one(
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
@@ -1491,10 +1545,12 @@ static void
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
@@ -1502,11 +1558,24 @@ __xfs_refcount_add(
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
@@ -1515,12 +1584,13 @@ __xfs_refcount_add(
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
 
@@ -1530,12 +1600,13 @@ xfs_refcount_increase_extent(
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
 
@@ -1891,6 +1962,7 @@ __xfs_refcount_cow_free(
 void
 xfs_refcount_alloc_cow_extent(
 	struct xfs_trans		*tp,
+	bool				isrt,
 	xfs_fsblock_t			fsb,
 	xfs_extlen_t			len)
 {
@@ -1899,16 +1971,17 @@ xfs_refcount_alloc_cow_extent(
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
@@ -1918,8 +1991,8 @@ xfs_refcount_free_cow_extent(
 		return;
 
 	/* Remove rmap entry */
-	xfs_rmap_free_extent(tp, false, fsb, len, XFS_RMAP_OWN_COW);
-	__xfs_refcount_add(tp, XFS_REFCOUNT_FREE_COW, fsb, len);
+	xfs_rmap_free_extent(tp, isrt, fsb, len, XFS_RMAP_OWN_COW);
+	__xfs_refcount_add(tp, XFS_REFCOUNT_FREE_COW, isrt, fsb, len);
 }
 
 struct xfs_refcount_recovery {
@@ -2025,7 +2098,7 @@ xfs_refcount_recover_cow_leftovers(
 		/* Free the orphan record */
 		fsb = XFS_AGB_TO_FSB(mp, pag->pag_agno,
 				rr->rr_rrec.rc_startblock);
-		xfs_refcount_free_cow_extent(tp, fsb,
+		xfs_refcount_free_cow_extent(tp, false, fsb,
 				rr->rr_rrec.rc_blockcount);
 
 		/* Free the block. */
diff --git a/libxfs/xfs_refcount.h b/libxfs/xfs_refcount.h
index 7713bb908bd..4e725d723e8 100644
--- a/libxfs/xfs_refcount.h
+++ b/libxfs/xfs_refcount.h
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
 

