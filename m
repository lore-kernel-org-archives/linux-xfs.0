Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57100 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731466AbeLNMe4 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 14 Dec 2018 07:34:56 -0500
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 0BA799F748
        for <linux-xfs@vger.kernel.org>; Fri, 14 Dec 2018 12:34:55 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BAAED26E71
        for <linux-xfs@vger.kernel.org>; Fri, 14 Dec 2018 12:34:54 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH RFC 5/5] xfs: new cntbt based near allocation algorithm
Date: Fri, 14 Dec 2018 07:34:52 -0500
Message-Id: <20181214123452.20974-6-bfoster@redhat.com>
In-Reply-To: <20181214123452.20974-1-bfoster@redhat.com>
References: <20181214123452.20974-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Prototype a new NEAR type allocation algorithm. Use both the
by-block and by-size btrees to allocate the largest available extent
with ideal locality.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_alloc.c | 405 +++++++++++++++++++++++++++++++++++++-
 fs/xfs/xfs_trace.h        |   1 +
 2 files changed, 405 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 95ee48e3fb9d..96aef9f9eaca 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -1315,6 +1315,392 @@ xfs_alloc_ag_vextent_near_bnobt(
 
 }
 
+enum xfs_alloc_cur {
+	XFS_ALLOC_CNT = 0,
+	XFS_ALLOC_BNOLT,
+	XFS_ALLOC_BNOGT,
+	XFS_ALLOC_MAX
+};
+
+struct xfs_alloc_best {
+	struct xfs_btree_cur	*cur[XFS_ALLOC_MAX];
+	xfs_extlen_t		cur_len;	/* current search length */
+	xfs_agblock_t		rec_bno;	/* record startblock */
+	xfs_extlen_t		rec_len;	/* record length */
+	xfs_agblock_t		bno;		/* alloc bno */
+	xfs_extlen_t		len;		/* alloc len */
+	xfs_extlen_t		diff;		/* diff from search bno */
+	bool			done;
+	bool			busy;
+	unsigned		busy_gen;
+};
+
+static int
+xfs_alloc_best_setup(
+	struct xfs_alloc_arg	*args,
+	struct xfs_alloc_best	*best)
+{
+	int			error;
+	int			i;
+
+	best->diff = -1;
+
+	best->cur[XFS_ALLOC_CNT] = xfs_allocbt_init_cursor(args->mp, args->tp,
+					args->agbp, args->agno, XFS_BTNUM_CNT);
+
+	best->cur[XFS_ALLOC_BNOLT] = xfs_allocbt_init_cursor(args->mp, args->tp,
+					args->agbp, args->agno, XFS_BTNUM_BNO);
+	error = xfs_alloc_lookup_le(best->cur[XFS_ALLOC_BNOLT], args->agbno,
+				    args->maxlen, &i);
+	if (error)
+		return error;
+	if (!i) {
+		best->cur[XFS_ALLOC_BNOGT] = best->cur[XFS_ALLOC_BNOLT];
+		best->cur[XFS_ALLOC_BNOLT] = NULL;
+	} else {
+		xfs_btree_dup_cursor(best->cur[XFS_ALLOC_BNOLT],
+				     &best->cur[XFS_ALLOC_BNOGT]);
+	}
+
+	error = xfs_btree_increment(best->cur[XFS_ALLOC_BNOGT], 0, &i);
+	if (error)
+		return error;
+	if (!i) {
+		xfs_btree_del_cursor(best->cur[XFS_ALLOC_BNOGT],
+				     XFS_BTREE_NOERROR);
+		best->cur[XFS_ALLOC_BNOGT] = NULL;
+	}
+
+	return error;
+}
+
+static inline void
+__xfs_alloc_best_close(
+	struct xfs_alloc_best	*best,
+	enum xfs_alloc_cur	cidx,
+	int			error)
+{
+	if (!best->cur[cidx])
+		return;
+
+	xfs_btree_del_cursor(best->cur[cidx], error);
+	best->cur[cidx] = NULL;
+}
+
+static void
+xfs_alloc_best_close(
+	struct xfs_alloc_best	*best,
+	bool			error)
+{
+	int			cur_error = XFS_BTREE_NOERROR;
+	int			i;
+
+	if (error)
+		cur_error = XFS_BTREE_ERROR;
+	for (i = 0; i < XFS_ALLOC_MAX; i++)
+		__xfs_alloc_best_close(best, i, cur_error);
+}
+
+static bool
+xfs_alloc_best_check(
+	struct xfs_alloc_arg	*args,
+	xfs_agblock_t		bno,
+	xfs_extlen_t		len,
+	struct xfs_alloc_best	*best,
+	enum xfs_alloc_cur	cidx)
+{
+	xfs_agblock_t		bnoa, bnew;
+	xfs_extlen_t		lena, diff = -1;
+	bool			busy;
+	unsigned		busy_gen = 0;
+	bool			badrange = false;
+	bool			isbnobt = false;
+
+	isbnobt = (cidx == XFS_ALLOC_BNOLT || cidx == XFS_ALLOC_BNOGT);
+
+	busy = xfs_alloc_compute_aligned(args, bno, len, &bnoa, &lena,
+					 &busy_gen);
+	best->busy |= busy;
+	if (busy)
+		best->busy_gen = busy_gen;
+
+	if (bnoa < args->min_agbno || bnoa > args->max_agbno) {
+		badrange = true;
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
+	diff = xfs_alloc_compute_diff(args->agbno, args->len,
+				      args->alignment, args->datatype,
+				      bnoa, lena, &bnew);
+	if (bnew == NULLAGBLOCK)
+		goto fail;
+	if (diff > best->diff) {
+		badrange = true;
+		goto fail;
+	}
+	if (args->len < best->len)
+		goto fail;
+
+	best->rec_bno = bno;
+	best->rec_len = len;
+	best->bno = bnew;
+	best->len = args->len;
+	best->diff = diff;
+	return true;
+
+fail:
+	/* close bnobt cursors once out of range to prevent further searching */
+	if (isbnobt && badrange)
+		__xfs_alloc_best_close(best, cidx, XFS_BTREE_NOERROR);
+	return false;
+}
+
+/*
+ * Complete an allocation if we have a candidate extent.
+ */
+STATIC int
+xfs_alloc_best_finish(
+	struct xfs_alloc_arg	*args,
+	struct xfs_alloc_best	*best,
+	int			*stat)
+{
+	struct xfs_btree_cur	*bno_cur;
+	int			error;
+
+	ASSERT(best->len);
+	ASSERT(best->cur[XFS_ALLOC_CNT]);
+
+	/*
+	 * Reuse or reopen a bnobt cursor if necessary. It will be closed as
+	 * part of the xfs_alloc_best cleanup.
+	 */
+	if (best->cur[XFS_ALLOC_BNOLT]) {
+		bno_cur = best->cur[XFS_ALLOC_BNOLT];
+	} else if (best->cur[XFS_ALLOC_BNOGT]) {
+		bno_cur = best->cur[XFS_ALLOC_BNOGT];
+	} else {
+		bno_cur = xfs_allocbt_init_cursor(args->mp, args->tp,
+						  args->agbp, args->agno,
+						  XFS_BTNUM_BNO);
+		best->cur[XFS_ALLOC_BNOLT] = bno_cur;
+	}
+
+	error = xfs_alloc_fixup_trees(best->cur[XFS_ALLOC_CNT], bno_cur,
+				      best->rec_bno, best->rec_len, best->bno,
+				      best->len, 0);
+	if (error)
+		return error;
+
+	args->agbno = best->bno;
+	args->len = best->len;
+	*stat = 1;
+
+	return 0;
+}
+
+STATIC int
+xfs_alloc_size_iter(
+	struct xfs_alloc_arg	*args,
+	struct xfs_alloc_best	*best,
+	enum xfs_alloc_cur	cidx)
+{
+	struct xfs_btree_cur	*cur = best->cur[cidx];
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
+		best->done = true;
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
+	xfs_alloc_best_check(args, bno, len, best, cidx);
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
+						     cidx);
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
+STATIC int
+xfs_alloc_bno_iter(
+	struct xfs_alloc_arg	*args,
+	struct xfs_alloc_best	*best,
+	enum xfs_alloc_cur	cidx,
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
+	*stat = 0;
+	cur = best->cur[cidx];
+	if (!cur)
+		return 0;
+
+	for (; iters > 0; iters--) {
+		error = xfs_alloc_get_rec(cur, &bno, &len, &i);
+		if (error)
+			return error;
+		XFS_WANT_CORRUPTED_RETURN(args->mp, i == 1);
+		found = xfs_alloc_best_check(args, bno, len, best, cidx);
+		if (found) {
+			*stat = 1;
+			break;
+		}
+		if (!best->cur[cidx])
+			break;
+
+		if (cidx == XFS_ALLOC_BNOLT)
+			error = xfs_btree_decrement(cur, 0, &i);
+		else if (cidx == XFS_ALLOC_BNOGT)
+			error = xfs_btree_increment(cur, 0, &i);
+		if (error)
+			return error;
+		if (i == 0) {
+			xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
+			best->cur[cidx] = NULL;
+			break;
+		}
+	}
+
+	return error;
+}
+
+STATIC int
+xfs_alloc_ag_vextent_new(
+	struct xfs_alloc_arg	*args,
+	struct xfs_alloc_best	*best,
+	int			*stat)
+{
+	int			error;
+	int			i;
+	unsigned int		findbest = 0;
+	enum xfs_alloc_cur	findbestc;
+
+	*stat = 0;
+
+	error = xfs_alloc_best_setup(args, best);
+	if (error)
+		goto out;
+
+	best->cur_len = args->maxlen;
+	while (!best->done) {
+		/*
+		 * Search the bnobt left and right. If either of these find a
+		 * suitable extent, we know we've found ideal locality. Do a
+		 * capped search in the opposite direction and we're done.
+		 */
+		error = xfs_alloc_bno_iter(args, best, XFS_ALLOC_BNOLT, 1, &i);
+		if (error)
+			goto out;
+		if (i) {
+			best->done = true;
+			findbest = args->mp->m_alloc_mxr[0];
+			findbestc = XFS_ALLOC_BNOGT;
+			break;
+		}
+
+		error = xfs_alloc_bno_iter(args, best, XFS_ALLOC_BNOGT, 1, &i);
+		if (error)
+			goto out;
+		if (i) {
+			best->done = true;
+			findbest = args->mp->m_alloc_mxr[0];
+			findbestc = XFS_ALLOC_BNOLT;
+			break;
+		}
+
+		/*
+		 * Search for an extent based on size. This only sets best.done
+		 * if we hit the end of the tree.
+		 */
+		error = xfs_alloc_size_iter(args, best, XFS_ALLOC_CNT);
+		if (error)
+			goto out;
+	}
+
+	if (findbest) {
+		error = xfs_alloc_bno_iter(args, best, findbestc, findbest, &i);
+		if (error)
+			goto out;
+	}
+
+	if (best->len)
+		error = xfs_alloc_best_finish(args, best, stat);
+
+out:
+	xfs_alloc_best_close(best, error);
+	return error;
+}
+
 /*
  * Allocate a variable extent near bno in the allocation group agno.
  * Extent's length (returned in len) will be between minlen and maxlen,
@@ -1326,7 +1712,7 @@ xfs_alloc_ag_vextent_near(
 	struct xfs_alloc_arg	*args)	/* allocation argument structure */
 {
 	struct xfs_btree_cur	*bno_cur = NULL;/* cursor for bno btree */
-	struct xfs_btree_cur	*cnt_cur;	/* cursor for count btree */
+	struct xfs_btree_cur	*cnt_cur = NULL;/* cursor for count btree */
 	int			error;		/* error code */
 	int			i;		/* result code, temporary */
 	xfs_agblock_t		bno;	      /* start bno of left side entry */
@@ -1357,6 +1743,23 @@ xfs_alloc_ag_vextent_near(
 	len = 0;
 	busy = false;
 
+	if (args->agbno != NULLAGBLOCK) {
+		struct xfs_alloc_best	best = {0,};
+
+		error = xfs_alloc_ag_vextent_new(args, &best, &i);
+		if (error)
+			goto error;
+		if (i) {
+			trace_xfs_alloc_near_new(args);
+			return 0;
+		}
+		if (best.busy) {
+			xfs_extent_busy_flush(args->mp, args->pag,
+					      best.busy_gen);
+			goto restart;
+		}
+	}
+
 	/*
 	 * Get a cursor for the by-size btree and start with a lookup for maxlen
 	 * free extents.
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 8a6532aae779..7a4e5829d594 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -1626,6 +1626,7 @@ DEFINE_ALLOC_EVENT(xfs_alloc_exact_done);
 DEFINE_ALLOC_EVENT(xfs_alloc_exact_notfound);
 DEFINE_ALLOC_EVENT(xfs_alloc_exact_error);
 DEFINE_ALLOC_EVENT(xfs_alloc_near_nominleft);
+DEFINE_ALLOC_EVENT(xfs_alloc_near_new);
 DEFINE_ALLOC_EVENT(xfs_alloc_near_first);
 DEFINE_ALLOC_EVENT(xfs_alloc_near_greater);
 DEFINE_ALLOC_EVENT(xfs_alloc_near_lesser);
-- 
2.17.2
