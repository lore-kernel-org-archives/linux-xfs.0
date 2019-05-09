Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52628 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726704AbfEIRGw (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 9 May 2019 13:06:52 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 1FBA483F3D
        for <linux-xfs@vger.kernel.org>; Thu,  9 May 2019 16:58:41 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CEDA610018FB
        for <linux-xfs@vger.kernel.org>; Thu,  9 May 2019 16:58:40 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 3/6] xfs: use locality optimized cntbt lookups for near mode allocations
Date: Thu,  9 May 2019 12:58:36 -0400
Message-Id: <20190509165839.44329-4-bfoster@redhat.com>
In-Reply-To: <20190509165839.44329-1-bfoster@redhat.com>
References: <20190509165839.44329-1-bfoster@redhat.com>
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

In the common case, a near mode allocation consists of a conditional
scan of the last cntbt block followed by a concurrent left and right
spanning search of the bnobt starting from the ideal point of
locality in the bnobt. This works reasonably well as filesystems age
via most common allocation patterns. If free space fragments as the
filesystem ages, however, the near algorithm has very poor breakdown
characteristics. If the extent size lookup happens to land outside
(i.e., before) the last cntbt block, the alloc bypasses the cntbt
entirely. If a suitably sized extent lies beyond a large enough
number of unusable extents from the starting point(s) of the bnobt
search, the bnobt search can take a significant amount of time to
locate the target extent. This leads to pathological allocation
latencies in certain workloads.

The near allocation algorithm can be fundamentally improved to take
advantage of a preexisting mechanism: that by-size cntbt record
lookups can incorporate locality. This means that a single cntbt
lookup can return the extent of a particular size with best
locality. A single locality lookup only covers extents of the
requested size, but for larger extent allocations, repeated locality
lookups of increasing sizes can search more efficiently than the
bnobt scan because it isolates the search space to extents of
suitable size. Such a cntbt search may not always find the extent
with absolute best locality, but the tradeoff for good enough
locality for a more efficient scan is worthwhile because more often
than not, extent size and contiguity are more important for
performance than perfect locality for data allocations.

This patch introduces generic allocation infrastructure for cursor
setup/teardown, selected extent allocation and various means of
btree scanning. Based on this infrastructure, it reimplements the
near allocation algorithm to balance between repeated cntbt lookups
and bnobt left/right scans as opposed to effectively choosing one
search algorithm or the other. This provides more predictable
allocation latency under breakdown conditions with good enough
locality in the common case. The algorithm naturally balances
between smaller and larger allocations as smaller allocations are
more likely to be satisfied immediately from the bnobt whereas
larger allocations are more likely satisfied by the cntbt. The
generic infrastructure introduced by this patch will be reused to
reduce code duplication between different, but conceptually similar
allocation modes in subsequent patches.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_alloc.c | 895 ++++++++++++++++++++------------------
 fs/xfs/xfs_trace.h        |  26 +-
 2 files changed, 483 insertions(+), 438 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 231e8ca5cce0..112411a46891 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -39,7 +39,7 @@ struct workqueue_struct *xfs_alloc_wq;
 #define	XFSA_FIXUP_CNT_OK	2
 
 STATIC int xfs_alloc_ag_vextent_exact(xfs_alloc_arg_t *);
-STATIC int xfs_alloc_ag_vextent_near(xfs_alloc_arg_t *);
+STATIC int xfs_alloc_ag_vextent_type(struct xfs_alloc_arg *);
 STATIC int xfs_alloc_ag_vextent_size(xfs_alloc_arg_t *);
 STATIC int xfs_alloc_ag_vextent_small(xfs_alloc_arg_t *,
 		xfs_btree_cur_t *, xfs_agblock_t *, xfs_extlen_t *, int *);
@@ -728,7 +728,7 @@ xfs_alloc_ag_vextent(
 		error = xfs_alloc_ag_vextent_size(args);
 		break;
 	case XFS_ALLOCTYPE_NEAR_BNO:
-		error = xfs_alloc_ag_vextent_near(args);
+		error = xfs_alloc_ag_vextent_type(args);
 		break;
 	case XFS_ALLOCTYPE_THIS_BNO:
 		error = xfs_alloc_ag_vextent_exact(args);
@@ -887,499 +887,526 @@ xfs_alloc_ag_vextent_exact(
 }
 
 /*
- * Search the btree in a given direction via the search cursor and compare
- * the records found against the good extent we've already found.
+ * BLock allocation algorithm and data structures.
  */
-STATIC int
-xfs_alloc_find_best_extent(
-	struct xfs_alloc_arg	*args,	/* allocation argument structure */
-	struct xfs_btree_cur	**gcur,	/* good cursor */
-	struct xfs_btree_cur	**scur,	/* searching cursor */
-	xfs_agblock_t		gdiff,	/* difference for search comparison */
-	xfs_agblock_t		*sbno,	/* extent found by search */
-	xfs_extlen_t		*slen,	/* extent length */
-	xfs_agblock_t		*sbnoa,	/* aligned extent found by search */
-	xfs_extlen_t		*slena,	/* aligned extent length */
-	int			dir)	/* 0 = search right, 1 = search left */
+struct xfs_alloc_btree_cur {
+	struct xfs_btree_cur	*cur;		/* cursor */
+	bool			active;		/* cursor active flag */
+};
+
+struct xfs_alloc_cur {
+	struct xfs_alloc_btree_cur	cnt;	/* btree cursors */
+	struct xfs_alloc_btree_cur	bnolt;
+	struct xfs_alloc_btree_cur	bnogt;
+	xfs_extlen_t			cur_len;/* current search length */
+	xfs_agblock_t			rec_bno;/* extent startblock */
+	xfs_extlen_t			rec_len;/* extent length */
+	xfs_agblock_t			bno;	/* alloc bno */
+	xfs_extlen_t			len;	/* alloc len */
+	xfs_extlen_t			diff;	/* diff from search bno */
+	unsigned			busy_gen;/* busy state */
+	bool				busy;
+};
+
+/*
+ * Set up cursors, etc. in the extent allocation cursor. This function can be
+ * called multiple times to reset an initialized structure without having to
+ * reallocate cursors.
+ */
+static int
+xfs_alloc_cur_setup(
+	struct xfs_alloc_arg	*args,
+	struct xfs_alloc_cur	*acur)
 {
-	xfs_agblock_t		new;
-	xfs_agblock_t		sdiff;
+	xfs_agblock_t		agbno = 0;
 	int			error;
 	int			i;
-	unsigned		busy_gen;
 
-	/* The good extent is perfect, no need to  search. */
-	if (!gdiff)
-		goto out_use_good;
+	acur->cnt.active = acur->bnolt.active = acur->bnogt.active = false;
+	acur->cur_len = args->maxlen;
+	acur->rec_bno = 0;
+	acur->rec_len = 0;
+	acur->bno = 0;
+	acur->len = 0;
+	acur->diff = -1;
+	acur->busy = false;
+	acur->busy_gen = 0;
+
+	if (args->agbno != NULLAGBLOCK)
+		agbno = args->agbno;
 
 	/*
-	 * Look until we find a better one, run out of space or run off the end.
+	 * Initialize the cntbt cursor and determine whether to start the search
+	 * at maxlen or minlen. THIS_AG allocation mode expects the cursor at
+	 * the first available maxlen extent or at the end of the tree.
 	 */
-	do {
-		error = xfs_alloc_get_rec(*scur, sbno, slen, &i);
+	if (!acur->cnt.cur)
+		acur->cnt.cur = xfs_allocbt_init_cursor(args->mp, args->tp,
+					args->agbp, args->agno, XFS_BTNUM_CNT);
+	error = xfs_alloc_lookup_ge(acur->cnt.cur, agbno, acur->cur_len, &i);
+	if (!i) {
+		acur->cur_len = args->minlen;
+		error = xfs_alloc_lookup_ge(acur->cnt.cur, agbno, acur->cur_len,
+					    &i);
 		if (error)
-			goto error0;
-		XFS_WANT_CORRUPTED_GOTO(args->mp, i == 1, error0);
-		xfs_alloc_compute_aligned(args, *sbno, *slen,
-				sbnoa, slena, &busy_gen);
+			return error;
+	}
+	if (i)
+		acur->cnt.active = true;
+
+	/* init bnobt left/right search cursors */
+	if (!acur->bnolt.cur)
+		acur->bnolt.cur = xfs_allocbt_init_cursor(args->mp, args->tp,
+					args->agbp, args->agno, XFS_BTNUM_BNO);
+	error = xfs_alloc_lookup_le(acur->bnolt.cur, agbno, args->maxlen, &i);
+	if (error)
+		return error;
+	if (i)
+		acur->bnolt.active = true;
 
-		/*
-		 * The good extent is closer than this one.
-		 */
-		if (!dir) {
-			if (*sbnoa > args->max_agbno)
-				goto out_use_good;
-			if (*sbnoa >= args->agbno + gdiff)
-				goto out_use_good;
-		} else {
-			if (*sbnoa < args->min_agbno)
-				goto out_use_good;
-			if (*sbnoa <= args->agbno - gdiff)
-				goto out_use_good;
-		}
+	if (!acur->bnogt.cur)
+		acur->bnogt.cur = xfs_allocbt_init_cursor(args->mp, args->tp,
+					args->agbp, args->agno, XFS_BTNUM_BNO);
+	error = xfs_alloc_lookup_ge(acur->bnogt.cur, agbno, args->maxlen, &i);
+	if (error)
+		return error;
+	if (i)
+		acur->bnogt.active = true;
 
-		/*
-		 * Same distance, compare length and pick the best.
-		 */
-		if (*slena >= args->minlen) {
-			args->len = XFS_EXTLEN_MIN(*slena, args->maxlen);
-			xfs_alloc_fix_len(args);
+	return 0;
+}
 
-			sdiff = xfs_alloc_compute_diff(args->agbno, args->len,
-						       args->alignment,
-						       args->datatype, *sbnoa,
-						       *slena, &new);
+static void
+xfs_alloc_cur_close(
+	struct xfs_alloc_cur	*acur,
+	bool			error)
+{
+	int			cur_error = XFS_BTREE_NOERROR;
 
-			/*
-			 * Choose closer size and invalidate other cursor.
-			 */
-			if (sdiff < gdiff)
-				goto out_use_search;
-			goto out_use_good;
-		}
+	if (error)
+		cur_error = XFS_BTREE_ERROR;
+
+	if (acur->cnt.cur)
+		xfs_btree_del_cursor(acur->cnt.cur, cur_error);
+	if (acur->bnolt.cur)
+		xfs_btree_del_cursor(acur->bnolt.cur, cur_error);
+	if (acur->bnogt.cur)
+		xfs_btree_del_cursor(acur->bnogt.cur, cur_error);
+	acur->cnt.cur = acur->bnolt.cur = acur->bnogt.cur = NULL;
+}
 
-		if (!dir)
-			error = xfs_btree_increment(*scur, 0, &i);
-		else
-			error = xfs_btree_decrement(*scur, 0, &i);
-		if (error)
-			goto error0;
-	} while (i);
+/*
+ * Check an extent for allocation and track the best available candidate in the
+ * allocation structure. The cursor is deactivated if it has entered an out of
+ * range state based on allocation arguments. Optionally return the extent
+ * extent geometry and allocation status if requested by the caller.
+ */
+static int
+xfs_alloc_cur_check(
+	struct xfs_alloc_arg		*args,
+	struct xfs_alloc_cur		*acur,
+	struct xfs_alloc_btree_cur	*bcur,
+	xfs_agblock_t			*obno,
+	xfs_extlen_t			*olen,
+	bool				*new)
+{
+	int			error, i;
+	xfs_agblock_t		bno, bnoa, bnew;
+	xfs_extlen_t		len, lena, diff = -1;
+	bool			busy;
+	unsigned		busy_gen = 0;
+	bool			deactivate = false;
+	bool			isbnobt = bcur->cur->bc_btnum == XFS_BTNUM_BNO;
+
+	if (new)
+		*new = false;
+
+	error = xfs_alloc_get_rec(bcur->cur, &bno, &len, &i);
+	if (error)
+		return error;
+	XFS_WANT_CORRUPTED_RETURN(args->mp, i == 1);
+	if (obno)
+		*obno = bno;
+	if (olen)
+		*olen = len;
 
-out_use_good:
-	xfs_btree_del_cursor(*scur, XFS_BTREE_NOERROR);
-	*scur = NULL;
-	return 0;
+	/*
+	 * Check against minlen and then compute and check the aligned record.
+	 * If a cntbt record is out of size range (i.e., we're walking
+	 * backwards) or a bnobt record is out of locality range, deactivate the
+	 * cursor.
+	 */
+	if (len < args->minlen) {
+		deactivate = !isbnobt;
+		goto fail;
+	}
+
+	busy = xfs_alloc_compute_aligned(args, bno, len, &bnoa, &lena,
+					 &busy_gen);
+	acur->busy |= busy;
+	if (busy)
+		acur->busy_gen = busy_gen;
+	if (bnoa < args->min_agbno || bnoa > args->max_agbno) {
+		deactivate = isbnobt;
+		goto fail;
+	}
+	if (lena < args->minlen)
+		goto fail;
 
-out_use_search:
-	xfs_btree_del_cursor(*gcur, XFS_BTREE_NOERROR);
-	*gcur = NULL;
+	args->len = XFS_EXTLEN_MIN(lena, args->maxlen);
+	xfs_alloc_fix_len(args);
+	ASSERT(args->len >= args->minlen);
+	if (args->len < acur->len)
+		goto fail;
+
+	/*
+	 * We have an aligned record that satisfies minlen and beats the current
+	 * candidate length. The remaining locality checks are specific to near
+	 * allocation mode.
+	 */
+	ASSERT(args->type == XFS_ALLOCTYPE_NEAR_BNO);
+	diff = xfs_alloc_compute_diff(args->agbno, args->len,
+				      args->alignment, args->datatype,
+				      bnoa, lena, &bnew);
+	if (bnew == NULLAGBLOCK)
+		goto fail;
+	if (diff > acur->diff) {
+		/* deactivate bnobt cursor with worse locality */
+		deactivate = isbnobt;
+		goto fail;
+	}
+	if (args->len < acur->len)
+		goto fail;
+
+	/* found a new candidate extent */
+	acur->rec_bno = bno;
+	acur->rec_len = len;
+	acur->bno = bnew;
+	acur->len = args->len;
+	acur->diff = diff;
+	if (new)
+		*new = true;
+	trace_xfs_alloc_cur_new(args->mp, acur->bno, acur->len, acur->diff);
 	return 0;
 
-error0:
-	/* caller invalidates cursors */
-	return error;
+fail:
+	if (deactivate)
+		bcur->active = false;
+	return 0;
 }
 
 /*
- * Allocate a variable extent near bno in the allocation group agno.
- * Extent's length (returned in len) will be between minlen and maxlen,
- * and of the form k * prod + mod unless there's nothing that large.
- * Return the starting a.g. block, or NULLAGBLOCK if we can't do it.
+ * Complete an allocation of a candidate extent. Remove the extent from both
+ * trees and update the args structure.
  */
-STATIC int				/* error */
-xfs_alloc_ag_vextent_near(
-	xfs_alloc_arg_t	*args)		/* allocation argument structure */
+STATIC int
+xfs_alloc_cur_finish(
+	struct xfs_alloc_arg	*args,
+	struct xfs_alloc_cur	*acur)
 {
-	xfs_btree_cur_t	*bno_cur_gt;	/* cursor for bno btree, right side */
-	xfs_btree_cur_t	*bno_cur_lt;	/* cursor for bno btree, left side */
-	xfs_btree_cur_t	*cnt_cur;	/* cursor for count btree */
-	xfs_agblock_t	gtbno;		/* start bno of right side entry */
-	xfs_agblock_t	gtbnoa;		/* aligned ... */
-	xfs_extlen_t	gtdiff;		/* difference to right side entry */
-	xfs_extlen_t	gtlen;		/* length of right side entry */
-	xfs_extlen_t	gtlena;		/* aligned ... */
-	xfs_agblock_t	gtnew;		/* useful start bno of right side */
-	int		error;		/* error code */
-	int		i;		/* result code, temporary */
-	int		j;		/* result code, temporary */
-	xfs_agblock_t	ltbno;		/* start bno of left side entry */
-	xfs_agblock_t	ltbnoa;		/* aligned ... */
-	xfs_extlen_t	ltdiff;		/* difference to left side entry */
-	xfs_extlen_t	ltlen;		/* length of left side entry */
-	xfs_extlen_t	ltlena;		/* aligned ... */
-	xfs_agblock_t	ltnew;		/* useful start bno of left side */
-	xfs_extlen_t	rlen;		/* length of returned extent */
-	bool		busy;
-	unsigned	busy_gen;
-#ifdef DEBUG
-	/*
-	 * Randomly don't execute the first algorithm.
-	 */
-	int		dofirst;	/* set to do first algorithm */
+	int			error;
 
-	dofirst = prandom_u32() & 1;
-#endif
+	ASSERT(acur->len);
+	ASSERT(acur->cnt.cur && acur->bnolt.cur);
 
-	/* handle unitialized agbno range so caller doesn't have to */
-	if (!args->min_agbno && !args->max_agbno)
-		args->max_agbno = args->mp->m_sb.sb_agblocks - 1;
-	ASSERT(args->min_agbno <= args->max_agbno);
+	error = xfs_alloc_fixup_trees(acur->cnt.cur, acur->bnolt.cur,
+				      acur->rec_bno, acur->rec_len, acur->bno,
+				      acur->len, 0);
+	if (error)
+		return error;
 
-	/* clamp agbno to the range if it's outside */
-	if (args->agbno < args->min_agbno)
-		args->agbno = args->min_agbno;
-	if (args->agbno > args->max_agbno)
-		args->agbno = args->max_agbno;
+	args->agbno = acur->bno;
+	args->len = acur->len;
+	args->wasfromfl = 0;
 
-restart:
-	bno_cur_lt = NULL;
-	bno_cur_gt = NULL;
-	ltlen = 0;
-	gtlena = 0;
-	ltlena = 0;
-	busy = false;
+	trace_xfs_alloc_cur(args);
+	return 0;
+}
 
-	/*
-	 * Get a cursor for the by-size btree.
-	 */
-	cnt_cur = xfs_allocbt_init_cursor(args->mp, args->tp, args->agbp,
-		args->agno, XFS_BTNUM_CNT);
+/*
+ * Locality allocation lookup algorithm. This expects a cntbt cursor and uses
+ * bno optimized lookup to search for extents with ideal size and locality.
+ */
+STATIC int
+xfs_alloc_lookup_iter(
+	struct xfs_alloc_arg		*args,
+	struct xfs_alloc_cur		*acur,
+	struct xfs_alloc_btree_cur	*bcur)
+{
+	struct xfs_btree_cur	*cur = bcur->cur;
+	xfs_agblock_t		bno;
+	xfs_extlen_t		len, cur_len;
+	int			error;
+	int			i;
 
-	/*
-	 * See if there are any free extents as big as maxlen.
-	 */
-	if ((error = xfs_alloc_lookup_ge(cnt_cur, 0, args->maxlen, &i)))
-		goto error0;
-	/*
-	 * If none, then pick up the last entry in the tree unless the
-	 * tree is empty.
-	 */
-	if (!i) {
-		if ((error = xfs_alloc_ag_vextent_small(args, cnt_cur, &ltbno,
-				&ltlen, &i)))
-			goto error0;
-		if (i == 0 || ltlen == 0) {
-			xfs_btree_del_cursor(cnt_cur, XFS_BTREE_NOERROR);
-			trace_xfs_alloc_near_noentry(args);
-			return 0;
+	if (!bcur->active)
+		return 0;
+
+	/* locality optimized lookup */
+	cur_len = acur->cur_len;
+	error = xfs_alloc_lookup_ge(cur, args->agbno, cur_len, &i);
+	if (error)
+		return error;
+	if (i == 0) {
+		bcur->active = false;
+		return 0;
+	}
+
+	/* check the current record and update search length from it */
+	error = xfs_alloc_cur_check(args, acur, bcur, &bno, &len, NULL);
+	if (error)
+		return error;
+	ASSERT(len >= acur->cur_len);
+	acur->cur_len = len;
+
+	/*
+	 * We looked up the first record >= [agbno, len] above. The agbno is a
+	 * secondary key and so the current record may lie just before or after
+	 * agbno. If it is past agbno, check the previous record too so long as
+	 * the length matches as it may be closer. Don't check a smaller record
+	 * because that could deactivate our cursor.
+	 */
+	if (bno > args->agbno) {
+		error = xfs_btree_decrement(cur, 0, &i);
+		if (!error && i) {
+			error = xfs_alloc_get_rec(bcur->cur, &bno, &len, &i);
+			if (!error && i && len == acur->cur_len) {
+				error = xfs_alloc_cur_check(args, acur, bcur,
+							    NULL, NULL, NULL);
+			}
 		}
-		ASSERT(i == 1);
+		if (error)
+			return error;
 	}
-	args->wasfromfl = 0;
 
 	/*
-	 * First algorithm.
-	 * If the requested extent is large wrt the freespaces available
-	 * in this a.g., then the cursor will be pointing to a btree entry
-	 * near the right edge of the tree.  If it's in the last btree leaf
-	 * block, then we just examine all the entries in that block
-	 * that are big enough, and pick the best one.
-	 * This is written as a while loop so we can break out of it,
-	 * but we never loop back to the top.
+	 * Increment the search key until we find at least one allocation
+	 * candidate or if the extent we found was larger. Otherwise, double the
+	 * search key to optimize the search. Efficiency is more important here
+	 * than absolute best locality.
 	 */
-	while (xfs_btree_islastblock(cnt_cur, 0)) {
-		xfs_extlen_t	bdiff;
-		int		besti=0;
-		xfs_extlen_t	blen=0;
-		xfs_agblock_t	bnew=0;
+	cur_len <<= 1;
+	if (!acur->len || acur->cur_len >= cur_len)
+		acur->cur_len++;
+	else
+		acur->cur_len = cur_len;
 
-#ifdef DEBUG
-		if (dofirst)
-			break;
-#endif
-		/*
-		 * Start from the entry that lookup found, sequence through
-		 * all larger free blocks.  If we're actually pointing at a
-		 * record smaller than maxlen, go to the start of this block,
-		 * and skip all those smaller than minlen.
-		 */
-		if (ltlen || args->alignment > 1) {
-			cnt_cur->bc_ptrs[0] = 1;
-			do {
-				if ((error = xfs_alloc_get_rec(cnt_cur, &ltbno,
-						&ltlen, &i)))
-					goto error0;
-				XFS_WANT_CORRUPTED_GOTO(args->mp, i == 1, error0);
-				if (ltlen >= args->minlen)
-					break;
-				if ((error = xfs_btree_increment(cnt_cur, 0, &i)))
-					goto error0;
-			} while (i);
-			ASSERT(ltlen >= args->minlen);
-			if (!i)
+	return error;
+}
+
+/*
+ * Incremental lookup algorithm. Walk a btree in either direction looking for
+ * candidate extents. This works for either bnobt (locality allocation) or cntbt
+ * (by-size allocation) cursors.
+ */
+STATIC int
+xfs_alloc_walk_iter(
+	struct xfs_alloc_arg		*args,
+	struct xfs_alloc_cur		*acur,
+	struct xfs_alloc_btree_cur	*bcur,
+	bool				increment,
+	bool				findone,
+	int				iters,
+	int				*stat)
+{
+	struct xfs_btree_cur	*cur;
+	int			error;
+	int			i;
+	bool			found = false;
+
+	if (!bcur->active)
+		return 0;
+
+	*stat = 0;
+	cur = bcur->cur;
+	for (; iters > 0; iters--) {
+		error = xfs_alloc_cur_check(args, acur, bcur, NULL, NULL,
+					    &found);
+		if (error)
+			return error;
+		if (found) {
+			*stat = 1;
+			if (findone)
 				break;
 		}
-		i = cnt_cur->bc_ptrs[0];
-		for (j = 1, blen = 0, bdiff = 0;
-		     !error && j && (blen < args->maxlen || bdiff > 0);
-		     error = xfs_btree_increment(cnt_cur, 0, &j)) {
-			/*
-			 * For each entry, decide if it's better than
-			 * the previous best entry.
-			 */
-			if ((error = xfs_alloc_get_rec(cnt_cur, &ltbno, &ltlen, &i)))
-				goto error0;
-			XFS_WANT_CORRUPTED_GOTO(args->mp, i == 1, error0);
-			busy = xfs_alloc_compute_aligned(args, ltbno, ltlen,
-					&ltbnoa, &ltlena, &busy_gen);
-			if (ltlena < args->minlen)
-				continue;
-			if (ltbnoa < args->min_agbno || ltbnoa > args->max_agbno)
-				continue;
-			args->len = XFS_EXTLEN_MIN(ltlena, args->maxlen);
-			xfs_alloc_fix_len(args);
-			ASSERT(args->len >= args->minlen);
-			if (args->len < blen)
-				continue;
-			ltdiff = xfs_alloc_compute_diff(args->agbno, args->len,
-				args->alignment, args->datatype, ltbnoa,
-				ltlena, &ltnew);
-			if (ltnew != NULLAGBLOCK &&
-			    (args->len > blen || ltdiff < bdiff)) {
-				bdiff = ltdiff;
-				bnew = ltnew;
-				blen = args->len;
-				besti = cnt_cur->bc_ptrs[0];
-			}
+		if (!bcur->active)
+			break;
+
+		if (increment)
+			error = xfs_btree_increment(cur, 0, &i);
+		else
+			error = xfs_btree_decrement(cur, 0, &i);
+		if (error)
+			return error;
+		if (i == 0) {
+			bcur->active = false;
+			break;
 		}
+	}
+
+	return error;
+}
+
+/*
+ * High level locality allocation algorithm. Search the bnobt (left and right)
+ * in parallel with locality-optimized cntbt lookups to find an extent with
+ * ideal locality.
+ */
+STATIC int
+xfs_alloc_ag_vextent_cur(
+	struct xfs_alloc_arg	*args,
+	struct xfs_alloc_cur	*acur,
+	int			*stat)
+{
+	int				error;
+	int				i;
+	unsigned int			findbestcount;
+	struct xfs_alloc_btree_cur	*fbcur = NULL;
+	bool				fbinc = false;
+
+	ASSERT(acur->cnt.cur);
+	ASSERT(args->type != XFS_ALLOCTYPE_THIS_AG);
+	findbestcount = args->mp->m_alloc_mxr[0];
+	*stat = 0;
+
+	/* search as long as we have at least one active cursor */
+	while (acur->cnt.active || acur->bnolt.active || acur->bnogt.active) {
 		/*
-		 * It didn't work.  We COULD be in a case where
-		 * there's a good record somewhere, so try again.
+		 * Search the bnobt left and right. If either of these find a
+		 * suitable extent, we know we've found ideal locality. Do a
+		 * capped search in the opposite direction and we're done.
 		 */
-		if (blen == 0)
+		error = xfs_alloc_walk_iter(args, acur, &acur->bnolt, false,
+					    true, 1, &i);
+		if (error)
+			return error;
+		if (i) {
+			fbcur = &acur->bnogt;
+			fbinc = true;
 			break;
-		/*
-		 * Point at the best entry, and retrieve it again.
-		 */
-		cnt_cur->bc_ptrs[0] = besti;
-		if ((error = xfs_alloc_get_rec(cnt_cur, &ltbno, &ltlen, &i)))
-			goto error0;
-		XFS_WANT_CORRUPTED_GOTO(args->mp, i == 1, error0);
-		ASSERT(ltbno + ltlen <= be32_to_cpu(XFS_BUF_TO_AGF(args->agbp)->agf_length));
-		args->len = blen;
+		}
 
-		/*
-		 * We are allocating starting at bnew for blen blocks.
-		 */
-		args->agbno = bnew;
-		ASSERT(bnew >= ltbno);
-		ASSERT(bnew + blen <= ltbno + ltlen);
-		/*
-		 * Set up a cursor for the by-bno tree.
-		 */
-		bno_cur_lt = xfs_allocbt_init_cursor(args->mp, args->tp,
-			args->agbp, args->agno, XFS_BTNUM_BNO);
-		/*
-		 * Fix up the btree entries.
-		 */
-		if ((error = xfs_alloc_fixup_trees(cnt_cur, bno_cur_lt, ltbno,
-				ltlen, bnew, blen, XFSA_FIXUP_CNT_OK)))
-			goto error0;
-		xfs_btree_del_cursor(cnt_cur, XFS_BTREE_NOERROR);
-		xfs_btree_del_cursor(bno_cur_lt, XFS_BTREE_NOERROR);
+		error = xfs_alloc_walk_iter(args, acur, &acur->bnogt, true,
+					    true, 1, &i);
+		if (error)
+			return error;
+		if (i) {
+			fbcur = &acur->bnolt;
+			break;
+		}
 
-		trace_xfs_alloc_near_first(args);
-		return 0;
-	}
-	/*
-	 * Second algorithm.
-	 * Search in the by-bno tree to the left and to the right
-	 * simultaneously, until in each case we find a space big enough,
-	 * or run into the edge of the tree.  When we run into the edge,
-	 * we deallocate that cursor.
-	 * If both searches succeed, we compare the two spaces and pick
-	 * the better one.
-	 * With alignment, it's possible for both to fail; the upper
-	 * level algorithm that picks allocation groups for allocations
-	 * is not supposed to do this.
-	 */
-	/*
-	 * Allocate and initialize the cursor for the leftward search.
-	 */
-	bno_cur_lt = xfs_allocbt_init_cursor(args->mp, args->tp, args->agbp,
-		args->agno, XFS_BTNUM_BNO);
-	/*
-	 * Lookup <= bno to find the leftward search's starting point.
-	 */
-	if ((error = xfs_alloc_lookup_le(bno_cur_lt, args->agbno, args->maxlen, &i)))
-		goto error0;
-	if (!i) {
 		/*
-		 * Didn't find anything; use this cursor for the rightward
-		 * search.
+		 * Search the cntbt for a maximum sized extent with ideal
+		 * locality. The lookup search terminates on reaching the end of
+		 * the cntbt. Break out of the loop if this occurs to throttle
+		 * the bnobt scans.
 		 */
-		bno_cur_gt = bno_cur_lt;
-		bno_cur_lt = NULL;
-	}
-	/*
-	 * Found something.  Duplicate the cursor for the rightward search.
-	 */
-	else if ((error = xfs_btree_dup_cursor(bno_cur_lt, &bno_cur_gt)))
-		goto error0;
-	/*
-	 * Increment the cursor, so we will point at the entry just right
-	 * of the leftward entry if any, or to the leftmost entry.
-	 */
-	if ((error = xfs_btree_increment(bno_cur_gt, 0, &i)))
-		goto error0;
-	if (!i) {
-		/*
-		 * It failed, there are no rightward entries.
-		 */
-		xfs_btree_del_cursor(bno_cur_gt, XFS_BTREE_NOERROR);
-		bno_cur_gt = NULL;
-	}
-	/*
-	 * Loop going left with the leftward cursor, right with the
-	 * rightward cursor, until either both directions give up or
-	 * we find an entry at least as big as minlen.
-	 */
-	do {
-		if (bno_cur_lt) {
-			if ((error = xfs_alloc_get_rec(bno_cur_lt, &ltbno, &ltlen, &i)))
-				goto error0;
-			XFS_WANT_CORRUPTED_GOTO(args->mp, i == 1, error0);
-			busy |= xfs_alloc_compute_aligned(args, ltbno, ltlen,
-					&ltbnoa, &ltlena, &busy_gen);
-			if (ltlena >= args->minlen && ltbnoa >= args->min_agbno)
-				break;
-			if ((error = xfs_btree_decrement(bno_cur_lt, 0, &i)))
-				goto error0;
-			if (!i || ltbnoa < args->min_agbno) {
-				xfs_btree_del_cursor(bno_cur_lt,
-						     XFS_BTREE_NOERROR);
-				bno_cur_lt = NULL;
-			}
-		}
-		if (bno_cur_gt) {
-			if ((error = xfs_alloc_get_rec(bno_cur_gt, &gtbno, &gtlen, &i)))
-				goto error0;
-			XFS_WANT_CORRUPTED_GOTO(args->mp, i == 1, error0);
-			busy |= xfs_alloc_compute_aligned(args, gtbno, gtlen,
-					&gtbnoa, &gtlena, &busy_gen);
-			if (gtlena >= args->minlen && gtbnoa <= args->max_agbno)
-				break;
-			if ((error = xfs_btree_increment(bno_cur_gt, 0, &i)))
-				goto error0;
-			if (!i || gtbnoa > args->max_agbno) {
-				xfs_btree_del_cursor(bno_cur_gt,
-						     XFS_BTREE_NOERROR);
-				bno_cur_gt = NULL;
+		error = xfs_alloc_lookup_iter(args, acur, &acur->cnt);
+		if (error)
+			return error;
+		if (!acur->cnt.active) {
+			if (!acur->len) {
+				fbcur = &acur->cnt;
+				error = xfs_btree_decrement(fbcur->cur, 0, &i);
+				if (error)
+					return error;
+				if (i)
+					fbcur->active = true;
 			}
+			break;
 		}
-	} while (bno_cur_lt || bno_cur_gt);
+	}
 
 	/*
-	 * Got both cursors still active, need to find better entry.
+	 * Perform a best-effort search in the opposite direction from a bnobt
+	 * allocation or backwards from the end of the cntbt if we couldn't find
+	 * a maxlen extent.
 	 */
-	if (bno_cur_lt && bno_cur_gt) {
-		if (ltlena >= args->minlen) {
-			/*
-			 * Left side is good, look for a right side entry.
-			 */
-			args->len = XFS_EXTLEN_MIN(ltlena, args->maxlen);
-			xfs_alloc_fix_len(args);
-			ltdiff = xfs_alloc_compute_diff(args->agbno, args->len,
-				args->alignment, args->datatype, ltbnoa,
-				ltlena, &ltnew);
-
-			error = xfs_alloc_find_best_extent(args,
-						&bno_cur_lt, &bno_cur_gt,
-						ltdiff, &gtbno, &gtlen,
-						&gtbnoa, &gtlena,
-						0 /* search right */);
-		} else {
-			ASSERT(gtlena >= args->minlen);
-
-			/*
-			 * Right side is good, look for a left side entry.
-			 */
-			args->len = XFS_EXTLEN_MIN(gtlena, args->maxlen);
-			xfs_alloc_fix_len(args);
-			gtdiff = xfs_alloc_compute_diff(args->agbno, args->len,
-				args->alignment, args->datatype, gtbnoa,
-				gtlena, &gtnew);
-
-			error = xfs_alloc_find_best_extent(args,
-						&bno_cur_gt, &bno_cur_lt,
-						gtdiff, &ltbno, &ltlen,
-						&ltbnoa, &ltlena,
-						1 /* search left */);
-		}
-
+	if (fbcur) {
+		error = xfs_alloc_walk_iter(args, acur, fbcur, fbinc, true,
+					    findbestcount, &i);
 		if (error)
-			goto error0;
+			return error;
 	}
 
-	/*
-	 * If we couldn't get anything, give up.
-	 */
-	if (bno_cur_lt == NULL && bno_cur_gt == NULL) {
-		xfs_btree_del_cursor(cnt_cur, XFS_BTREE_NOERROR);
+	if (acur->len)
+		*stat = 1;
 
-		if (busy) {
-			trace_xfs_alloc_near_busy(args);
-			xfs_extent_busy_flush(args->mp, args->pag, busy_gen);
-			goto restart;
-		}
-		trace_xfs_alloc_size_neither(args);
-		args->agbno = NULLAGBLOCK;
-		return 0;
-	}
+	return error;
+}
 
-	/*
-	 * At this point we have selected a freespace entry, either to the
-	 * left or to the right.  If it's on the right, copy all the
-	 * useful variables to the "left" set so we only have one
-	 * copy of this code.
-	 */
-	if (bno_cur_gt) {
-		bno_cur_lt = bno_cur_gt;
-		bno_cur_gt = NULL;
-		ltbno = gtbno;
-		ltbnoa = gtbnoa;
-		ltlen = gtlen;
-		ltlena = gtlena;
-		j = 1;
-	} else
-		j = 0;
+/*
+ * Allocate a variable extent near bno in the allocation group agno.
+ * Extent's length (returned in len) will be between minlen and maxlen,
+ * and of the form k * prod + mod unless there's nothing that large.
+ * Return the starting a.g. block, or NULLAGBLOCK if we can't do it.
+ */
+STATIC int				/* error */
+xfs_alloc_ag_vextent_type(
+	xfs_alloc_arg_t	*args)		/* allocation argument structure */
+{
+	struct xfs_alloc_cur	acur = {0,};
+	int			error;		/* error code */
+	int			i;		/* result code, temporary */
+	xfs_agblock_t		bno;	      /* start bno of left side entry */
+	xfs_extlen_t		len;		/* length of left side entry */
+
+	/* handle unitialized agbno range so caller doesn't have to */
+	if (!args->min_agbno && !args->max_agbno)
+		args->max_agbno = args->mp->m_sb.sb_agblocks - 1;
+	ASSERT(args->min_agbno <= args->max_agbno);
+
+	/* clamp agbno to the range if it's outside */
+	if (args->agbno < args->min_agbno)
+		args->agbno = args->min_agbno;
+	if (args->agbno > args->max_agbno)
+		args->agbno = args->max_agbno;
+
+restart:
+	/* set up cursors and allocation tracking structure based on args */
+	error = xfs_alloc_cur_setup(args, &acur);
+	if (error)
+		goto out;
+
+	error = xfs_alloc_ag_vextent_cur(args, &acur, &i);
+	if (error)
+		goto out;
 
 	/*
-	 * Fix up the length and compute the useful address.
+	 * If we got an extent, finish the allocation. Otherwise check for busy
+	 * extents and retry or attempt a small allocation.
 	 */
-	args->len = XFS_EXTLEN_MIN(ltlena, args->maxlen);
-	xfs_alloc_fix_len(args);
-	rlen = args->len;
-	(void)xfs_alloc_compute_diff(args->agbno, rlen, args->alignment,
-				     args->datatype, ltbnoa, ltlena, &ltnew);
-	ASSERT(ltnew >= ltbno);
-	ASSERT(ltnew + rlen <= ltbnoa + ltlena);
-	ASSERT(ltnew + rlen <= be32_to_cpu(XFS_BUF_TO_AGF(args->agbp)->agf_length));
-	ASSERT(ltnew >= args->min_agbno && ltnew <= args->max_agbno);
-	args->agbno = ltnew;
-
-	if ((error = xfs_alloc_fixup_trees(cnt_cur, bno_cur_lt, ltbno, ltlen,
-			ltnew, rlen, XFSA_FIXUP_BNO_OK)))
-		goto error0;
+	if (i) {
+		error = xfs_alloc_cur_finish(args, &acur);
+		if (error)
+			goto out;
+	} else  {
+		if (acur.busy) {
+			trace_xfs_alloc_near_busy(args);
+			xfs_extent_busy_flush(args->mp, args->pag,
+					      acur.busy_gen);
+			goto restart;
+		}
 
-	if (j)
-		trace_xfs_alloc_near_greater(args);
-	else
-		trace_xfs_alloc_near_lesser(args);
+		/*
+		 * We get here if we can't satisfy minlen or the trees are
+		 * empty. We don't pass a cursor so this returns an AGFL block
+		 * (i == 0) or nothing.
+		 */
+		error = xfs_alloc_ag_vextent_small(args, NULL, &bno, &len, &i);
+		if (error)
+			goto out;
+		ASSERT(i == 0 || (i && len == 0));
+		trace_xfs_alloc_near_noentry(args);
 
-	xfs_btree_del_cursor(cnt_cur, XFS_BTREE_NOERROR);
-	xfs_btree_del_cursor(bno_cur_lt, XFS_BTREE_NOERROR);
-	return 0;
+		args->agbno = bno;
+		args->len = len;
+	}
 
- error0:
-	trace_xfs_alloc_near_error(args);
-	if (cnt_cur != NULL)
-		xfs_btree_del_cursor(cnt_cur, XFS_BTREE_ERROR);
-	if (bno_cur_lt != NULL)
-		xfs_btree_del_cursor(bno_cur_lt, XFS_BTREE_ERROR);
-	if (bno_cur_gt != NULL)
-		xfs_btree_del_cursor(bno_cur_gt, XFS_BTREE_ERROR);
+out:
+	xfs_alloc_cur_close(&acur, error);
+	if (error)
+		trace_xfs_alloc_near_error(args);
 	return error;
 }
 
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 2464ea351f83..d08d747b51a8 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -1636,13 +1636,10 @@ DEFINE_ALLOC_EVENT(xfs_alloc_exact_done);
 DEFINE_ALLOC_EVENT(xfs_alloc_exact_notfound);
 DEFINE_ALLOC_EVENT(xfs_alloc_exact_error);
 DEFINE_ALLOC_EVENT(xfs_alloc_near_nominleft);
-DEFINE_ALLOC_EVENT(xfs_alloc_near_first);
-DEFINE_ALLOC_EVENT(xfs_alloc_near_greater);
-DEFINE_ALLOC_EVENT(xfs_alloc_near_lesser);
 DEFINE_ALLOC_EVENT(xfs_alloc_near_error);
 DEFINE_ALLOC_EVENT(xfs_alloc_near_noentry);
 DEFINE_ALLOC_EVENT(xfs_alloc_near_busy);
-DEFINE_ALLOC_EVENT(xfs_alloc_size_neither);
+DEFINE_ALLOC_EVENT(xfs_alloc_cur);
 DEFINE_ALLOC_EVENT(xfs_alloc_size_noentry);
 DEFINE_ALLOC_EVENT(xfs_alloc_size_nominleft);
 DEFINE_ALLOC_EVENT(xfs_alloc_size_done);
@@ -1658,6 +1655,27 @@ DEFINE_ALLOC_EVENT(xfs_alloc_vextent_noagbp);
 DEFINE_ALLOC_EVENT(xfs_alloc_vextent_loopfailed);
 DEFINE_ALLOC_EVENT(xfs_alloc_vextent_allfailed);
 
+TRACE_EVENT(xfs_alloc_cur_new,
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
