Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57206 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726172AbfCGRY1 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 7 Mar 2019 12:24:27 -0500
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 632E6307DABB
        for <linux-xfs@vger.kernel.org>; Thu,  7 Mar 2019 17:24:26 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-66.bos.redhat.com [10.18.41.66])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2131460C1B
        for <linux-xfs@vger.kernel.org>; Thu,  7 Mar 2019 17:24:26 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH RFCv2 3/3] xfs: use generic extent alloc mechanism for near mode allocs
Date: Thu,  7 Mar 2019 12:24:24 -0500
Message-Id: <20190307172424.30316-4-bfoster@redhat.com>
In-Reply-To: <20190307172424.30316-1-bfoster@redhat.com>
References: <20190307172424.30316-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Rework the near mode extent allocation algorithm in
xfs_alloc_ag_vextent_near() to use the generic extent allocation
mechanism. The generic mechanism is currently based on the near mode
algorithm with targeted improvements.

[TODO: fold into previous patch]

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_alloc.c | 491 +++-----------------------------------
 fs/xfs/xfs_trace.h        |   4 -
 2 files changed, 28 insertions(+), 467 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 2f09d71ea909..02fc6df5cc0d 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -886,101 +886,6 @@ xfs_alloc_ag_vextent_exact(
 	return error;
 }
 
-/*
- * Search the btree in a given direction via the search cursor and compare
- * the records found against the good extent we've already found.
- */
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
-{
-	xfs_agblock_t		new;
-	xfs_agblock_t		sdiff;
-	int			error;
-	int			i;
-	unsigned		busy_gen;
-
-	/* The good extent is perfect, no need to  search. */
-	if (!gdiff)
-		goto out_use_good;
-
-	/*
-	 * Look until we find a better one, run out of space or run off the end.
-	 */
-	do {
-		error = xfs_alloc_get_rec(*scur, sbno, slen, &i);
-		if (error)
-			goto error0;
-		XFS_WANT_CORRUPTED_GOTO(args->mp, i == 1, error0);
-		xfs_alloc_compute_aligned(args, *sbno, *slen,
-				sbnoa, slena, &busy_gen);
-
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
-
-		/*
-		 * Same distance, compare length and pick the best.
-		 */
-		if (*slena >= args->minlen) {
-			args->len = XFS_EXTLEN_MIN(*slena, args->maxlen);
-			xfs_alloc_fix_len(args);
-
-			sdiff = xfs_alloc_compute_diff(args->agbno, args->len,
-						       args->alignment,
-						       args->datatype, *sbnoa,
-						       *slena, &new);
-
-			/*
-			 * Choose closer size and invalidate other cursor.
-			 */
-			if (sdiff < gdiff)
-				goto out_use_search;
-			goto out_use_good;
-		}
-
-		if (!dir)
-			error = xfs_btree_increment(*scur, 0, &i);
-		else
-			error = xfs_btree_decrement(*scur, 0, &i);
-		if (error)
-			goto error0;
-	} while (i);
-
-out_use_good:
-	xfs_btree_del_cursor(*scur, XFS_BTREE_NOERROR);
-	*scur = NULL;
-	return 0;
-
-out_use_search:
-	xfs_btree_del_cursor(*gcur, XFS_BTREE_NOERROR);
-	*gcur = NULL;
-	return 0;
-
-error0:
-	/* caller invalidates cursors */
-	return error;
-}
-
 /*
  * NEAR allocation algorithm and data structures.
  */
@@ -1438,37 +1343,13 @@ xfs_alloc_ag_vextent_best(
  */
 STATIC int				/* error */
 xfs_alloc_ag_vextent_near(
-	xfs_alloc_arg_t	*args)		/* allocation argument structure */
+	struct xfs_alloc_arg	*args)	/* allocation argument structure */
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
-
-	dofirst = prandom_u32() & 1;
-#endif
+	struct xfs_alloc_best	best = {0,};
+	int			error;		/* error code */
+	int			i;		/* result code, temporary */
+	xfs_agblock_t		bno;	      /* start bno of left side entry */
+	xfs_extlen_t		len;		/* length of left side entry */
 
 	/* handle unitialized agbno range so caller doesn't have to */
 	if (!args->min_agbno && !args->max_agbno)
@@ -1482,353 +1363,37 @@ xfs_alloc_ag_vextent_near(
 		args->agbno = args->max_agbno;
 
 restart:
-	bno_cur_lt = NULL;
-	bno_cur_gt = NULL;
-	ltlen = 0;
-	gtlena = 0;
-	ltlena = 0;
-	busy = false;
-
-	/*
-	 * Get a cursor for the by-size btree.
-	 */
-	cnt_cur = xfs_allocbt_init_cursor(args->mp, args->tp, args->agbp,
-		args->agno, XFS_BTNUM_CNT);
+	/* set up cursors and allocation tracking structure based on args */
+	error = xfs_alloc_best_setup(args, &best);
+	if (error)
+		goto out;
 
-	/*
-	 * See if there are any free extents as big as maxlen.
-	 */
-	if ((error = xfs_alloc_lookup_ge(cnt_cur, 0, args->maxlen, &i)))
-		goto error0;
-	/*
-	 * If none, then pick up the last entry in the tree unless the
-	 * tree is empty.
-	 */
+	error = xfs_alloc_ag_vextent_best(args, &best, &i);
+	if (error)
+		goto out;
 	if (!i) {
-		if ((error = xfs_alloc_ag_vextent_small(args, cnt_cur, &ltbno,
-				&ltlen, &i)))
-			goto error0;
-		if (i == 0 || ltlen == 0) {
-			xfs_btree_del_cursor(cnt_cur, XFS_BTREE_NOERROR);
-			trace_xfs_alloc_near_noentry(args);
-			return 0;
-		}
-		ASSERT(i == 1);
-	}
-	args->wasfromfl = 0;
-
-	/*
-	 * First algorithm.
-	 * If the requested extent is large wrt the freespaces available
-	 * in this a.g., then the cursor will be pointing to a btree entry
-	 * near the right edge of the tree.  If it's in the last btree leaf
-	 * block, then we just examine all the entries in that block
-	 * that are big enough, and pick the best one.
-	 * This is written as a while loop so we can break out of it,
-	 * but we never loop back to the top.
-	 */
-	while (xfs_btree_islastblock(cnt_cur, 0)) {
-		xfs_extlen_t	bdiff;
-		int		besti=0;
-		xfs_extlen_t	blen=0;
-		xfs_agblock_t	bnew=0;
-
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
-				break;
-		}
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
+		if (best.busy) {
+			trace_xfs_alloc_near_busy(args);
+			xfs_extent_busy_flush(args->mp, args->pag,
+					      best.busy_gen);
+			goto restart;
 		}
-		/*
-		 * It didn't work.  We COULD be in a case where
-		 * there's a good record somewhere, so try again.
-		 */
-		if (blen == 0)
-			break;
-		/*
-		 * Point at the best entry, and retrieve it again.
-		 */
-		cnt_cur->bc_ptrs[0] = besti;
-		if ((error = xfs_alloc_get_rec(cnt_cur, &ltbno, &ltlen, &i)))
-			goto error0;
-		XFS_WANT_CORRUPTED_GOTO(args->mp, i == 1, error0);
-		ASSERT(ltbno + ltlen <= be32_to_cpu(XFS_BUF_TO_AGF(args->agbp)->agf_length));
-		args->len = blen;
-
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
-		/*
-		 * Didn't find anything; use this cursor for the rightward
-		 * search.
-		 */
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
 		/*
-		 * It failed, there are no rightward entries.
+		 * We get here if we can't satisfy minlen or the trees are empty
+		 * so this call returns an AGFL block or nothing.
 		 */
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
-			}
-		}
-	} while (bno_cur_lt || bno_cur_gt);
-
-	/*
-	 * Got both cursors still active, need to find better entry.
-	 */
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
+		error = xfs_alloc_ag_vextent_small(args, NULL, &bno, &len, &i);
 		if (error)
-			goto error0;
+			goto out;
+		ASSERT(i == 0 || (i && len == 0));
+		trace_xfs_alloc_near_noentry(args);
 	}
 
-	/*
-	 * If we couldn't get anything, give up.
-	 */
-	if (bno_cur_lt == NULL && bno_cur_gt == NULL) {
-		xfs_btree_del_cursor(cnt_cur, XFS_BTREE_NOERROR);
-
-		if (busy) {
-			trace_xfs_alloc_near_busy(args);
-			xfs_extent_busy_flush(args->mp, args->pag, busy_gen);
-			goto restart;
-		}
-		trace_xfs_alloc_size_neither(args);
-		args->agbno = NULLAGBLOCK;
-		return 0;
-	}
-
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
-
-	/*
-	 * Fix up the length and compute the useful address.
-	 */
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
-
-	if (j)
-		trace_xfs_alloc_near_greater(args);
-	else
-		trace_xfs_alloc_near_lesser(args);
-
-	xfs_btree_del_cursor(cnt_cur, XFS_BTREE_NOERROR);
-	xfs_btree_del_cursor(bno_cur_lt, XFS_BTREE_NOERROR);
-	return 0;
-
- error0:
-	trace_xfs_alloc_near_error(args);
-	if (cnt_cur != NULL)
-		xfs_btree_del_cursor(cnt_cur, XFS_BTREE_ERROR);
-	if (bno_cur_lt != NULL)
-		xfs_btree_del_cursor(bno_cur_lt, XFS_BTREE_ERROR);
-	if (bno_cur_gt != NULL)
-		xfs_btree_del_cursor(bno_cur_gt, XFS_BTREE_ERROR);
+out:
+	xfs_alloc_best_close(&best, error);
+	if (error)
+		trace_xfs_alloc_near_error(args);
 	return error;
 }
 
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 7346646405cd..ed89facfb640 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -1635,10 +1635,6 @@ DEFINE_EVENT(xfs_alloc_class, name, \
 DEFINE_ALLOC_EVENT(xfs_alloc_exact_done);
 DEFINE_ALLOC_EVENT(xfs_alloc_exact_notfound);
 DEFINE_ALLOC_EVENT(xfs_alloc_exact_error);
-DEFINE_ALLOC_EVENT(xfs_alloc_near_nominleft);
-DEFINE_ALLOC_EVENT(xfs_alloc_near_first);
-DEFINE_ALLOC_EVENT(xfs_alloc_near_greater);
-DEFINE_ALLOC_EVENT(xfs_alloc_near_lesser);
 DEFINE_ALLOC_EVENT(xfs_alloc_near_error);
 DEFINE_ALLOC_EVENT(xfs_alloc_near_noentry);
 DEFINE_ALLOC_EVENT(xfs_alloc_near_busy);
-- 
2.17.2
