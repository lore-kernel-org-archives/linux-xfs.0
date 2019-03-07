Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57768 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726233AbfCGRY0 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 7 Mar 2019 12:24:26 -0500
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id F2DF9C0587DD
        for <linux-xfs@vger.kernel.org>; Thu,  7 Mar 2019 17:24:25 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-66.bos.redhat.com [10.18.41.66])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9DAE960C1B
        for <linux-xfs@vger.kernel.org>; Thu,  7 Mar 2019 17:24:25 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH RFCv2 2/3] xfs: introduce generic extent allocation infrastructure
Date: Thu,  7 Mar 2019 12:24:23 -0500
Message-Id: <20190307172424.30316-3-bfoster@redhat.com>
In-Reply-To: <20190307172424.30316-1-bfoster@redhat.com>
References: <20190307172424.30316-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

The extent allocation code in XFS has several allocation modes with
unique implementations. This is slightly unfortunate as the
allocation modes are not all that different from a high level
perspective. The most involved mode is the near allocation mode
which attempts to allocate an optimally sized extent with ideal
locality with respect to a provided agbno.

In the common case of suitable extent availability, a near mode
allocation consists of a conditional scan of the last cntbt block
followed by a concurrent left and right spanning search of the bnobt
starting from the ideal point of locality in the bnobt. This works
reasonably well as filesystems age via most common allocation
patterns. If free space fragments as the filesystem ages, however,
the near algorithm has very poor breakdown characteristics. If the
extent size lookup happens to land outside of the last cntbt block,
the alloc bypasses the cntbt entirely. If the target extent lies
beyond a large enough number of unusable extents from the starting
point(s) of the bnobt search, the bnobt search can take a
significant amount of time to locate the target extent. This leads
to pathological allocation latencies in certain workloads.

The near allocation algorithm can be fundamentally improved to take
advantage of a preexisting mechanism: that by-size cntbt record
lookups can incorporate locality. This means that a single cntbt
lookup can return the extent with ideal locality (with respect to an
agbno param) of a particular size. This means that for larger extent
allocations, repeated lookups of the cntbt with an agbno hint can be
far more reliable and efficient than a brute force bnobt search. Such
a cntbt search may not always find the extent with absolute best
locality, but the tradeoff for good enough locality for a more
efficient scan is worthwhile because more often than not, extent
contiguity is more important for performance than locality.

Introduce a new allocation mechanism based on the existing near
allocation mode with the aforementioned tweaks. The new mechanism
initiates concurrent bnobt spanning and cntbt lookup searches to
naturally balance the optimal approach for smaller vs. larger
allocation requests. For example, smaller allocation requests are
highly likely to be satisfied by the bnobt search. The larger the
allocation request, the more likely the cntbt lookup search locates
the ideal extent. Once the cntbt search locates at least one
suitable allocation candidate, the remaining search for better
locality is boosted to throttle bnobt scans and the overall latency
of the allocation.

Implement the new mechanism with a generic interface and code
factoring to facilitate reuse for other allocation modes. For
example, the exact and size allocation modes are a subset of this
implementation. It should be possible to perform such allocations in
the future with fairly isolated logic changes to incorporate the
different allocation requirements.

Note that this patch introduces mechanism only and makes no
functional changes. [XXX: Squash with follow on patch to address
static function warnings, etc.].

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_alloc.c | 449 ++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_trace.h        |  22 ++
 2 files changed, 471 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 10a6e22b764d..2f09d71ea909 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -981,6 +981,455 @@ xfs_alloc_find_best_extent(
 	return error;
 }
 
+/*
+ * NEAR allocation algorithm and data structures.
+ */
+struct xfs_best_cur {
+	struct xfs_btree_cur	*cur;		/* cursor */
+	bool			done;		/* search done flag */
+};
+
+struct xfs_alloc_best {
+	struct xfs_best_cur	cnt;		/* btree cursors */
+	struct xfs_best_cur	bnolt;
+	struct xfs_best_cur	bnogt;
+	xfs_extlen_t		cur_len;	/* current search length */
+	xfs_agblock_t		rec_bno;	/* extent startblock */
+	xfs_extlen_t		rec_len;	/* extent length */
+	xfs_agblock_t		bno;		/* alloc bno */
+	xfs_extlen_t		len;		/* alloc len */
+	xfs_extlen_t		diff;		/* diff from search bno */
+	unsigned		busy_gen;	/* busy state */
+	bool			busy;
+};
+
+/*
+ * Set up the cursors, etc. in the best extent allocation tracking structure.
+ * This function can be called multiple times to reset an initialized structure
+ * without having to reallocate cursors.
+ */
+static int
+xfs_alloc_best_setup(
+	struct xfs_alloc_arg	*args,
+	struct xfs_alloc_best	*best)
+{
+	int			error;
+	int			i;
+
+	best->cnt.done = best->bnolt.done = best->bnogt.done = true;
+	best->cur_len = args->maxlen;
+	best->rec_bno = 0;
+	best->rec_len = 0;
+	best->bno = 0;
+	best->len = 0;
+	best->diff = -1;
+	best->busy = false;
+	best->busy_gen = 0;
+
+	/*
+	 * Initialize the cntbt cursor and determine whether to start the search
+	 * at maxlen or minlen.
+	 */
+	if (!best->cnt.cur)
+		best->cnt.cur = xfs_allocbt_init_cursor(args->mp, args->tp,
+					args->agbp, args->agno, XFS_BTNUM_CNT);
+	error = xfs_alloc_lookup_ge(best->cnt.cur, args->agbno, best->cur_len,
+				    &i);
+	if (!i) {
+		best->cur_len = args->minlen;
+		error = xfs_alloc_lookup_ge(best->cnt.cur, args->agbno,
+					    best->cur_len, &i);
+		if (error)
+			return error;
+	}
+	if (i)
+		best->cnt.done = false;
+
+	/*
+	 * Initialize bnobt left/right search cursors. Mark the cursor done if
+	 * either lands at the associated end of the tree.
+	 */
+	if (!best->bnolt.cur)
+		best->bnolt.cur = xfs_allocbt_init_cursor(args->mp, args->tp,
+					args->agbp, args->agno, XFS_BTNUM_BNO);
+	error = xfs_alloc_lookup_le(best->bnolt.cur, args->agbno, args->maxlen,
+				    &i);
+	if (error)
+		return error;
+	if (i)
+		best->bnolt.done = false;
+
+	if (!best->bnogt.cur)
+		best->bnogt.cur = xfs_allocbt_init_cursor(args->mp, args->tp,
+					args->agbp, args->agno, XFS_BTNUM_BNO);
+	error = xfs_alloc_lookup_ge(best->bnogt.cur, args->agbno, args->maxlen,
+				    &i);
+	if (error)
+		return error;
+	if (i)
+		best->bnogt.done = false;
+
+	return 0;
+}
+
+static void
+xfs_alloc_best_close(
+	struct xfs_alloc_best	*best,
+	bool			error)
+{
+	int			cur_error = XFS_BTREE_NOERROR;
+
+	if (error)
+		cur_error = XFS_BTREE_ERROR;
+
+	if (best->cnt.cur)
+		xfs_btree_del_cursor(best->cnt.cur, cur_error);
+	if (best->bnolt.cur)
+		xfs_btree_del_cursor(best->bnolt.cur, cur_error);
+	if (best->bnogt.cur)
+		xfs_btree_del_cursor(best->bnogt.cur, cur_error);
+	best->cnt.cur = best->bnolt.cur = best->bnogt.cur = NULL;
+}
+
+/*
+ * Consider an extent for allocation. If the provided extent fits allocation
+ * criteria and has better locality than the current candidate, store it in the
+ * best extent tracking structure. Mark the search cursor done if it has entered
+ * an out of range state based on allocation criteria. Returns true if the
+ * provided extent has been assigned as the new allocation candidate, false
+ * otherwise.
+ */
+static bool
+xfs_alloc_best_check(
+	struct xfs_alloc_arg	*args,
+	xfs_agblock_t		bno,
+	xfs_extlen_t		len,
+	struct xfs_alloc_best	*best,
+	struct xfs_best_cur	*bcur)
+{
+	xfs_agblock_t		bnoa, bnew;
+	xfs_extlen_t		lena, diff = -1;
+	bool			busy;
+	unsigned		busy_gen = 0;
+	bool			badrange = false;
+	bool			isbnobt = bcur->cur->bc_btnum == XFS_BTNUM_BNO;
+
+	/*
+	 * Check against minlen. If this is a cntbt cursor, it has gone out of
+	 * range. This should only happen when walking backwards.
+	 */
+	if (len < args->minlen) {
+		badrange = !isbnobt;
+		goto fail;
+	}
+
+	/*
+	 * Compute aligned extent and check length and range. If this is a bnobt
+	 * record that violates the range criteria, mark the bnobt cursor done.
+	 */
+	busy = xfs_alloc_compute_aligned(args, bno, len, &bnoa, &lena,
+					 &busy_gen);
+	best->busy |= busy;
+	if (busy)
+		best->busy_gen = busy_gen;
+	if (bnoa < args->min_agbno || bnoa > args->max_agbno) {
+		badrange = isbnobt;
+		goto fail;
+	}
+	if (lena < args->minlen)
+		goto fail;
+
+	args->len = XFS_EXTLEN_MIN(lena, args->maxlen);
+	xfs_alloc_fix_len(args);
+	ASSERT(args->len >= args->minlen);
+	if (args->len < best->len)
+		goto fail;
+
+	/*
+	 * If we have a usable extent, compare it to the current allocation
+	 * candidate. Mark the cursor done if this is a bnobt cursor with worse
+	 * locality.
+	 */
+	diff = xfs_alloc_compute_diff(args->agbno, args->len,
+				      args->alignment, args->datatype,
+				      bnoa, lena, &bnew);
+	if (bnew == NULLAGBLOCK)
+		goto fail;
+	if (diff > best->diff) {
+		badrange = isbnobt;
+		goto fail;
+	}
+	if (args->len < best->len)
+		goto fail;
+
+	/* new candidate extent */
+	best->rec_bno = bno;
+	best->rec_len = len;
+	best->bno = bnew;
+	best->len = args->len;
+	best->diff = diff;
+	trace_xfs_alloc_best_new(args->mp, best->bno, best->len, best->diff);
+	return true;
+
+fail:
+	if (badrange)
+		bcur->done = true;
+	return false;
+}
+
+/*
+ * Perform an allocation of a candidate extent. Remove the extent from both
+ * trees and update the caller's allocation structure.
+ */
+STATIC int
+xfs_alloc_best_finish(
+	struct xfs_alloc_arg	*args,
+	struct xfs_alloc_best	*best,
+	int			*stat)
+{
+	int			error;
+
+	ASSERT(best->len);
+	ASSERT(best->cnt.cur && best->bnolt.cur);
+
+	error = xfs_alloc_fixup_trees(best->cnt.cur, best->bnolt.cur,
+				      best->rec_bno, best->rec_len, best->bno,
+				      best->len, 0);
+	if (error)
+		return error;
+
+	args->agbno = best->bno;
+	args->len = best->len;
+	args->wasfromfl = 0;
+	*stat = 1;
+
+	trace_xfs_alloc_best(args);
+	return 0;
+}
+
+/*
+ * Perform an iterative by-size lookup based on the allocation request. This
+ * generally expects a cntbt cursor and uses the bno optimized lookup to find a
+ * suitably sized extent with ideal locality.
+ */
+STATIC int
+xfs_alloc_lookup_iter(
+	struct xfs_alloc_arg	*args,
+	struct xfs_alloc_best	*best,
+	struct xfs_best_cur	*bcur)
+{
+	struct xfs_btree_cur	*cur = bcur->cur;
+	xfs_agblock_t		bno;
+	xfs_extlen_t		len, cur_len;
+	int			error;
+	int			i;
+
+	/*
+	 * Store the current search key and perform a locality optimized lookup.
+	 */
+	cur_len = best->cur_len;
+	error = xfs_alloc_lookup_ge(cur, args->agbno, cur_len, &i);
+	if (error)
+		return error;
+	if (i == 0) {
+		bcur->done = true;
+		return 0;
+	}
+	error = xfs_alloc_get_rec(cur, &bno, &len, &i);
+	if (error)
+		return error;
+
+	/*
+	 * Check the record and update the search key to the extent length we
+	 * actually found in the tree.
+	 */
+	XFS_WANT_CORRUPTED_RETURN(args->mp, i == 1);
+	xfs_alloc_best_check(args, bno, len, best, bcur);
+	ASSERT(len >= best->cur_len);
+	best->cur_len = len;
+
+	/*
+	 * We looked up the first record >= [agbno, len] above. If this is a
+	 * cntbt search, the agbno is a secondary key and so the record may not
+	 * start beyond agbno if there are no such records for the particular
+	 * length. If it is past agbno, check the previous record too so long as
+	 * the length matches as it may be closer.
+	 */
+	if (bno > args->agbno) {
+		error = xfs_btree_decrement(cur, 0, &i);
+		if (error)
+			return error;
+		if (i) {
+			error = xfs_alloc_get_rec(cur, &bno, &len, &i);
+			if (error)
+				return error;
+			XFS_WANT_CORRUPTED_RETURN(args->mp, i == 1);
+			if (len == best->cur_len)
+				xfs_alloc_best_check(args, bno, len, best,
+						     bcur);
+		}
+	}
+
+	/*
+	 * Increment the search key if we haven't yet found a candidate extent
+	 * or this lookup already significantly bumped the key. We have to make
+	 * sure to not skip any records until we have at least one allocatable
+	 * extent. Note that if the allocation ultimately fails due to busy
+	 * extents, we'll flush the busy list and restart the whole thing.
+	 *
+	 * Otherwise, double the search key for the next lookup to optimize the
+	 * search. This allows us to find good enough locality at the expense of
+	 * absolute best locality. Max extent size and reasonable allocation
+	 * efficiency are more important here than perfect locality.
+	 */
+	cur_len <<= 1;
+	if (!best->len || best->cur_len >= cur_len)
+		best->cur_len++;
+	else
+		best->cur_len = cur_len;
+
+	return error;
+}
+
+/*
+ * Perform an iterative record at a time walk of a btree to find an allocation
+ * candidate extent. This is generally used for left/right spanning searches of
+ * the bnobt, but this also works on a cntbt cursor for cases where a minimal
+ * number of suitably sized extents are available and a more aggressive search
+ * is required.
+ */
+STATIC int
+xfs_alloc_walk_iter(
+	struct xfs_alloc_arg	*args,
+	struct xfs_alloc_best	*best,
+	struct xfs_best_cur	*bcur,
+	bool			increment,
+	int			iters,
+	int			*stat)
+{
+	struct xfs_btree_cur	*cur;
+	int			error;
+	int			i;
+	xfs_agblock_t		bno;
+	xfs_extlen_t		len;
+	bool			found = false;
+
+	if (bcur->done)
+		return 0;
+
+	*stat = 0;
+	cur = bcur->cur;
+	for (; iters > 0; iters--) {
+		error = xfs_alloc_get_rec(cur, &bno, &len, &i);
+		if (error)
+			return error;
+		XFS_WANT_CORRUPTED_RETURN(args->mp, i == 1);
+		found = xfs_alloc_best_check(args, bno, len, best, bcur);
+		if (found) {
+			*stat = 1;
+			break;
+		}
+		if (bcur->done)
+			break;
+
+		if (increment)
+			error = xfs_btree_increment(cur, 0, &i);
+		else
+			error = xfs_btree_decrement(cur, 0, &i);
+		if (error)
+			return error;
+		if (i == 0) {
+			bcur->done = true;
+			break;
+		}
+	}
+
+	return error;
+}
+
+STATIC int
+xfs_alloc_ag_vextent_best(
+	struct xfs_alloc_arg	*args,
+	struct xfs_alloc_best	*best,
+	int			*stat)
+{
+	int			error;
+	int			i;
+	unsigned int		findbestcount = args->mp->m_alloc_mxr[0];
+
+	ASSERT(best->cnt.cur);
+	*stat = 0;
+
+	/* search as long as we have at least one active cursor */
+	while (!best->cnt.done || !best->bnolt.done || !best->bnogt.done) {
+		/*
+		 * Search the bnobt left and right. If either of these find a
+		 * suitable extent, we know we've found ideal locality. Do a
+		 * capped search in the opposite direction and we're done.
+		 */
+		error = xfs_alloc_walk_iter(args, best, &best->bnolt, false, 1,
+					    &i);
+		if (error)
+			return error;
+		if (i) {
+			error = xfs_alloc_walk_iter(args, best, &best->bnogt,
+						    true, findbestcount, &i);
+			if (error)
+				return error;
+			break;
+		}
+
+		error = xfs_alloc_walk_iter(args, best, &best->bnogt, true, 1,
+					    &i);
+		if (error)
+			return error;
+		if (i) {
+			error = xfs_alloc_walk_iter(args, best, &best->bnolt,
+						    false, findbestcount, &i);
+			if (error)
+				return error;
+			break;
+		}
+
+		/*
+		 * Search the cntbt for a maximum sized extent with ideal
+		 * locality. The lookup search terminates on reaching the end of
+		 * the cntbt. Break out of the loop if this occurs to throttle
+		 * the bnobt scans.
+		 */
+		error = xfs_alloc_lookup_iter(args, best, &best->cnt);
+		if (error)
+			return error;
+		if (best->cnt.done)
+			break;
+	}
+
+	/*
+	 * If the lookup search terminated and we still have no suitable
+	 * allocation, scan the largest extents available in the cntbt as a last
+	 * resort. The cntbt done flag means the cursor points off the end of
+	 * the tree. Point it back to the last record in the tree and walk
+	 * backwards from there.
+	 */
+	if (!best->len && best->cnt.done) {
+		best->cnt.done = false;
+		error = xfs_btree_decrement(best->cnt.cur, 0, &i);
+		if (error)
+			return error;
+		if (i) {
+			error = xfs_alloc_walk_iter(args, best, &best->cnt,
+						    false, findbestcount, &i);
+			if (error)
+				return error;
+		}
+	}
+
+	if (best->len)
+		error = xfs_alloc_best_finish(args, best, stat);
+
+	return error;
+}
+
 /*
  * Allocate a variable extent near bno in the allocation group agno.
  * Extent's length (returned in len) will be between minlen and maxlen,
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 47fb07d86efd..7346646405cd 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -1642,6 +1642,7 @@ DEFINE_ALLOC_EVENT(xfs_alloc_near_lesser);
 DEFINE_ALLOC_EVENT(xfs_alloc_near_error);
 DEFINE_ALLOC_EVENT(xfs_alloc_near_noentry);
 DEFINE_ALLOC_EVENT(xfs_alloc_near_busy);
+DEFINE_ALLOC_EVENT(xfs_alloc_best);
 DEFINE_ALLOC_EVENT(xfs_alloc_size_neither);
 DEFINE_ALLOC_EVENT(xfs_alloc_size_noentry);
 DEFINE_ALLOC_EVENT(xfs_alloc_size_nominleft);
@@ -1658,6 +1659,27 @@ DEFINE_ALLOC_EVENT(xfs_alloc_vextent_noagbp);
 DEFINE_ALLOC_EVENT(xfs_alloc_vextent_loopfailed);
 DEFINE_ALLOC_EVENT(xfs_alloc_vextent_allfailed);
 
+TRACE_EVENT(xfs_alloc_best_new,
+	TP_PROTO(struct xfs_mount *mp, xfs_agblock_t bno, xfs_extlen_t len,
+		 xfs_extlen_t diff),
+	TP_ARGS(mp, bno, len, diff),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_agblock_t, bno)
+		__field(xfs_extlen_t, len)
+		__field(xfs_extlen_t, diff)
+	),
+	TP_fast_assign(
+		__entry->dev = mp->m_super->s_dev;
+		__entry->bno = bno;
+		__entry->len = len;
+		__entry->diff = diff;
+	),
+	TP_printk("dev %d:%d bno 0x%x len 0x%x diff 0x%x",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->bno, __entry->len, __entry->diff)
+)
+
 DECLARE_EVENT_CLASS(xfs_da_class,
 	TP_PROTO(struct xfs_da_args *args),
 	TP_ARGS(args),
-- 
2.17.2
