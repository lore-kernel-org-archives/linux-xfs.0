Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:63275 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731298AbeLNMey (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 14 Dec 2018 07:34:54 -0500
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 5D731300C230
        for <linux-xfs@vger.kernel.org>; Fri, 14 Dec 2018 12:34:53 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1358B261A6
        for <linux-xfs@vger.kernel.org>; Fri, 14 Dec 2018 12:34:52 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH RFC 1/5] xfs: factor out bnobt based near allocation algorithm
Date: Fri, 14 Dec 2018 07:34:48 -0500
Message-Id: <20181214123452.20974-2-bfoster@redhat.com>
In-Reply-To: <20181214123452.20974-1-bfoster@redhat.com>
References: <20181214123452.20974-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

- mostly for reviewability
- clean up some var names, labels, logic format, comments
- use -EAGAIN to implement busy restart

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_alloc.c | 486 +++++++++++++++++++++-----------------
 1 file changed, 265 insertions(+), 221 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index e1c0c0d2f1b0..76affbcbd5ff 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -980,6 +980,228 @@ xfs_alloc_find_best_extent(
 	return error;
 }
 
+/*
+ * Second NEAR allocation algorithm. Search in the by-bno tree to the left and
+ * to the right simultaneously until in each case we find a space big enough or
+ * run into the edge of the tree. When we run into the edge, we deallocate that
+ * cursor. If both searches succeed, we compare the two spaces and pick the
+ * better one. With alignment, it's possible for both to fail; the upper level
+ * algorithm that picks allocation groups for allocations is not supposed to do
+ * this.
+ */
+STATIC int
+xfs_alloc_ag_vextent_near_bnobt(
+	struct xfs_alloc_arg	*args,
+	struct xfs_btree_cur	*cnt_cur,
+	bool			*busy,
+	unsigned		*busy_gen)
+{
+	struct xfs_btree_cur	*bno_cur_gt;
+	struct xfs_btree_cur	*bno_cur_lt;
+	xfs_agblock_t		gtbno;	/* start bno of right side entry */
+	xfs_agblock_t		gtbnoa;	/* aligned ... */
+	xfs_extlen_t		gtdiff;	/* difference to right side entry */
+	xfs_extlen_t		gtlen;	/* length of right side entry */
+	xfs_extlen_t		gtlena;	/* aligned ... */
+	xfs_agblock_t		gtnew;	/* useful start bno of right side */
+	int			error;	/* error code */
+	int			i;	/* result code, temporary */
+	int			j;	/* result code, temporary */
+	xfs_agblock_t		ltbno;	/* start bno of left side entry */
+	xfs_agblock_t		ltbnoa;	/* aligned ... */
+	xfs_extlen_t		ltdiff;	/* difference to left side entry */
+	xfs_extlen_t		ltlen;	/* length of left side entry */
+	xfs_extlen_t		ltlena;	/* aligned ... */
+	xfs_agblock_t		ltnew;	/* useful start bno of left side */
+	xfs_extlen_t		rlen;	/* length of returned extent */
+
+	/*
+	 * Allocate and initialize the cursor for the leftward search.
+	 */
+	bno_cur_lt = xfs_allocbt_init_cursor(args->mp, args->tp, args->agbp,
+		args->agno, XFS_BTNUM_BNO);
+	/*
+	 * Lookup <= bno to find the leftward search's starting point.
+	 */
+	error = xfs_alloc_lookup_le(bno_cur_lt, args->agbno, args->maxlen, &i);
+	if (error)
+		goto error;
+	if (!i) {
+		/*
+		 * Didn't find anything; use this cursor for the rightward
+		 * search.
+		 */
+		bno_cur_gt = bno_cur_lt;
+		bno_cur_lt = NULL;
+	}
+	/*
+	 * Found something.  Duplicate the cursor for the rightward search.
+	 */
+	else if ((error = xfs_btree_dup_cursor(bno_cur_lt, &bno_cur_gt)))
+		goto error;
+	/*
+	 * Increment the cursor, so we will point at the entry just right
+	 * of the leftward entry if any, or to the leftmost entry.
+	 */
+	error = xfs_btree_increment(bno_cur_gt, 0, &i);
+	if (error)
+		goto error;
+	if (!i) {
+		/*
+		 * It failed, there are no rightward entries.
+		 */
+		xfs_btree_del_cursor(bno_cur_gt, XFS_BTREE_NOERROR);
+		bno_cur_gt = NULL;
+	}
+	/*
+	 * Loop going left with the leftward cursor, right with the
+	 * rightward cursor, until either both directions give up or
+	 * we find an entry at least as big as minlen.
+	 */
+	do {
+		if (bno_cur_lt) {
+			error = xfs_alloc_get_rec(bno_cur_lt, &ltbno, &ltlen, &i);
+			if (error)
+				goto error;
+			XFS_WANT_CORRUPTED_GOTO(args->mp, i == 1, error);
+			*busy |= xfs_alloc_compute_aligned(args, ltbno, ltlen,
+					&ltbnoa, &ltlena, busy_gen);
+			if (ltlena >= args->minlen && ltbnoa >= args->min_agbno)
+				break;
+			error = xfs_btree_decrement(bno_cur_lt, 0, &i);
+			if (error)
+				goto error;
+			if (!i || ltbnoa < args->min_agbno) {
+				xfs_btree_del_cursor(bno_cur_lt,
+						     XFS_BTREE_NOERROR);
+				bno_cur_lt = NULL;
+			}
+		}
+		if (bno_cur_gt) {
+			error = xfs_alloc_get_rec(bno_cur_gt, &gtbno, &gtlen, &i);
+			if (error)
+				goto error;
+			XFS_WANT_CORRUPTED_GOTO(args->mp, i == 1, error);
+			*busy |= xfs_alloc_compute_aligned(args, gtbno, gtlen,
+					&gtbnoa, &gtlena, busy_gen);
+			if (gtlena >= args->minlen && gtbnoa <= args->max_agbno)
+				break;
+			if ((error = xfs_btree_increment(bno_cur_gt, 0, &i)))
+				goto error;
+			if (!i || gtbnoa > args->max_agbno) {
+				xfs_btree_del_cursor(bno_cur_gt,
+						     XFS_BTREE_NOERROR);
+				bno_cur_gt = NULL;
+			}
+		}
+	} while (bno_cur_lt || bno_cur_gt);
+
+	/*
+	 * Got both cursors still active, need to find better entry.
+	 */
+	if (bno_cur_lt && bno_cur_gt) {
+		if (ltlena >= args->minlen) {
+			/*
+			 * Left side is good, look for a right side entry.
+			 */
+			args->len = XFS_EXTLEN_MIN(ltlena, args->maxlen);
+			xfs_alloc_fix_len(args);
+			ltdiff = xfs_alloc_compute_diff(args->agbno, args->len,
+				args->alignment, args->datatype, ltbnoa,
+				ltlena, &ltnew);
+
+			error = xfs_alloc_find_best_extent(args,
+						&bno_cur_lt, &bno_cur_gt,
+						ltdiff, &gtbno, &gtlen,
+						&gtbnoa, &gtlena,
+						0 /* search right */);
+		} else {
+			ASSERT(gtlena >= args->minlen);
+
+			/*
+			 * Right side is good, look for a left side entry.
+			 */
+			args->len = XFS_EXTLEN_MIN(gtlena, args->maxlen);
+			xfs_alloc_fix_len(args);
+			gtdiff = xfs_alloc_compute_diff(args->agbno, args->len,
+				args->alignment, args->datatype, gtbnoa,
+				gtlena, &gtnew);
+
+			error = xfs_alloc_find_best_extent(args,
+						&bno_cur_gt, &bno_cur_lt,
+						gtdiff, &ltbno, &ltlen,
+						&ltbnoa, &ltlena,
+						1 /* search left */);
+		}
+
+		if (error)
+			goto error;
+	}
+
+	/*
+	 * If we couldn't get anything, give up.
+	 */
+	if (bno_cur_lt == NULL && bno_cur_gt == NULL) {
+		if (*busy)
+			return -EAGAIN;
+		trace_xfs_alloc_size_neither(args);
+		args->agbno = NULLAGBLOCK;
+		return 0;
+	}
+
+	/*
+	 * At this point we have selected a freespace entry, either to the
+	 * left or to the right.  If it's on the right, copy all the
+	 * useful variables to the "left" set so we only have one
+	 * copy of this code.
+	 */
+	if (bno_cur_gt) {
+		bno_cur_lt = bno_cur_gt;
+		bno_cur_gt = NULL;
+		ltbno = gtbno;
+		ltbnoa = gtbnoa;
+		ltlen = gtlen;
+		ltlena = gtlena;
+		j = 1;
+	} else
+		j = 0;
+
+	/*
+	 * Fix up the length and compute the useful address.
+	 */
+	args->len = XFS_EXTLEN_MIN(ltlena, args->maxlen);
+	xfs_alloc_fix_len(args);
+	rlen = args->len;
+	(void)xfs_alloc_compute_diff(args->agbno, rlen, args->alignment,
+				     args->datatype, ltbnoa, ltlena, &ltnew);
+	ASSERT(ltnew >= ltbno);
+	ASSERT(ltnew + rlen <= ltbnoa + ltlena);
+	ASSERT(ltnew + rlen <= be32_to_cpu(XFS_BUF_TO_AGF(args->agbp)->agf_length));
+	ASSERT(ltnew >= args->min_agbno && ltnew <= args->max_agbno);
+	args->agbno = ltnew;
+
+	error = xfs_alloc_fixup_trees(cnt_cur, bno_cur_lt, ltbno, ltlen, ltnew,
+				rlen, XFSA_FIXUP_BNO_OK);
+	if (error)
+		goto error;
+
+	if (j)
+		trace_xfs_alloc_near_greater(args);
+	else
+		trace_xfs_alloc_near_lesser(args);
+
+	xfs_btree_del_cursor(bno_cur_lt, XFS_BTREE_NOERROR);
+	return 0;
+
+error:
+	if (bno_cur_lt)
+		xfs_btree_del_cursor(bno_cur_lt, XFS_BTREE_ERROR);
+	if (bno_cur_gt)
+		xfs_btree_del_cursor(bno_cur_gt, XFS_BTREE_ERROR);
+	return error;
+
+}
+
 /*
  * Allocate a variable extent near bno in the allocation group agno.
  * Extent's length (returned in len) will be between minlen and maxlen,
@@ -990,15 +1212,8 @@ STATIC int				/* error */
 xfs_alloc_ag_vextent_near(
 	xfs_alloc_arg_t	*args)		/* allocation argument structure */
 {
-	xfs_btree_cur_t	*bno_cur_gt;	/* cursor for bno btree, right side */
-	xfs_btree_cur_t	*bno_cur_lt;	/* cursor for bno btree, left side */
+	xfs_btree_cur_t	*bno_cur = NULL;/* cursor for bno btree */
 	xfs_btree_cur_t	*cnt_cur;	/* cursor for count btree */
-	xfs_agblock_t	gtbno;		/* start bno of right side entry */
-	xfs_agblock_t	gtbnoa;		/* aligned ... */
-	xfs_extlen_t	gtdiff;		/* difference to right side entry */
-	xfs_extlen_t	gtlen;		/* length of right side entry */
-	xfs_extlen_t	gtlena;		/* aligned ... */
-	xfs_agblock_t	gtnew;		/* useful start bno of right side */
 	int		error;		/* error code */
 	int		i;		/* result code, temporary */
 	int		j;		/* result code, temporary */
@@ -1008,7 +1223,6 @@ xfs_alloc_ag_vextent_near(
 	xfs_extlen_t	ltlen;		/* length of left side entry */
 	xfs_extlen_t	ltlena;		/* aligned ... */
 	xfs_agblock_t	ltnew;		/* useful start bno of left side */
-	xfs_extlen_t	rlen;		/* length of returned extent */
 	bool		busy;
 	unsigned	busy_gen;
 #ifdef DEBUG
@@ -1032,10 +1246,7 @@ xfs_alloc_ag_vextent_near(
 		args->agbno = args->max_agbno;
 
 restart:
-	bno_cur_lt = NULL;
-	bno_cur_gt = NULL;
 	ltlen = 0;
-	gtlena = 0;
 	ltlena = 0;
 	busy = false;
 
@@ -1048,16 +1259,18 @@ xfs_alloc_ag_vextent_near(
 	/*
 	 * See if there are any free extents as big as maxlen.
 	 */
-	if ((error = xfs_alloc_lookup_ge(cnt_cur, 0, args->maxlen, &i)))
-		goto error0;
+	error = xfs_alloc_lookup_ge(cnt_cur, 0, args->maxlen, &i);
+	if (error)
+		goto error;
 	/*
 	 * If none, then pick up the last entry in the tree unless the
 	 * tree is empty.
 	 */
 	if (!i) {
-		if ((error = xfs_alloc_ag_vextent_small(args, cnt_cur, &ltbno,
-				&ltlen, &i)))
-			goto error0;
+		error = xfs_alloc_ag_vextent_small(args, cnt_cur, &ltbno,
+				&ltlen, &i);
+		if (error)
+			goto error;
 		if (i == 0 || ltlen == 0) {
 			xfs_btree_del_cursor(cnt_cur, XFS_BTREE_NOERROR);
 			trace_xfs_alloc_near_noentry(args);
@@ -1096,14 +1309,15 @@ xfs_alloc_ag_vextent_near(
 		if (ltlen || args->alignment > 1) {
 			cnt_cur->bc_ptrs[0] = 1;
 			do {
-				if ((error = xfs_alloc_get_rec(cnt_cur, &ltbno,
-						&ltlen, &i)))
-					goto error0;
-				XFS_WANT_CORRUPTED_GOTO(args->mp, i == 1, error0);
+				error = xfs_alloc_get_rec(cnt_cur, &ltbno,
+						&ltlen, &i);
+				if (error)
+					goto error;
+				XFS_WANT_CORRUPTED_GOTO(args->mp, i == 1, error);
 				if (ltlen >= args->minlen)
 					break;
 				if ((error = xfs_btree_increment(cnt_cur, 0, &i)))
-					goto error0;
+					goto error;
 			} while (i);
 			ASSERT(ltlen >= args->minlen);
 			if (!i)
@@ -1117,9 +1331,10 @@ xfs_alloc_ag_vextent_near(
 			 * For each entry, decide if it's better than
 			 * the previous best entry.
 			 */
-			if ((error = xfs_alloc_get_rec(cnt_cur, &ltbno, &ltlen, &i)))
-				goto error0;
-			XFS_WANT_CORRUPTED_GOTO(args->mp, i == 1, error0);
+			error = xfs_alloc_get_rec(cnt_cur, &ltbno, &ltlen, &i);
+			if (error)
+				goto error;
+			XFS_WANT_CORRUPTED_GOTO(args->mp, i == 1, error);
 			busy = xfs_alloc_compute_aligned(args, ltbno, ltlen,
 					&ltbnoa, &ltlena, &busy_gen);
 			if (ltlena < args->minlen)
@@ -1152,9 +1367,10 @@ xfs_alloc_ag_vextent_near(
 		 * Point at the best entry, and retrieve it again.
 		 */
 		cnt_cur->bc_ptrs[0] = besti;
-		if ((error = xfs_alloc_get_rec(cnt_cur, &ltbno, &ltlen, &i)))
-			goto error0;
-		XFS_WANT_CORRUPTED_GOTO(args->mp, i == 1, error0);
+		error = xfs_alloc_get_rec(cnt_cur, &ltbno, &ltlen, &i);
+		if (error)
+			goto error;
+		XFS_WANT_CORRUPTED_GOTO(args->mp, i == 1, error);
 		ASSERT(ltbno + ltlen <= be32_to_cpu(XFS_BUF_TO_AGF(args->agbp)->agf_length));
 		args->len = blen;
 
@@ -1167,218 +1383,46 @@ xfs_alloc_ag_vextent_near(
 		/*
 		 * Set up a cursor for the by-bno tree.
 		 */
-		bno_cur_lt = xfs_allocbt_init_cursor(args->mp, args->tp,
+		bno_cur = xfs_allocbt_init_cursor(args->mp, args->tp,
 			args->agbp, args->agno, XFS_BTNUM_BNO);
 		/*
 		 * Fix up the btree entries.
 		 */
-		if ((error = xfs_alloc_fixup_trees(cnt_cur, bno_cur_lt, ltbno,
-				ltlen, bnew, blen, XFSA_FIXUP_CNT_OK)))
-			goto error0;
+		error = xfs_alloc_fixup_trees(cnt_cur, bno_cur, ltbno,
+				ltlen, bnew, blen, XFSA_FIXUP_CNT_OK);
+		if (error)
+			goto error;
 		xfs_btree_del_cursor(cnt_cur, XFS_BTREE_NOERROR);
-		xfs_btree_del_cursor(bno_cur_lt, XFS_BTREE_NOERROR);
+		xfs_btree_del_cursor(bno_cur, XFS_BTREE_NOERROR);
 
 		trace_xfs_alloc_near_first(args);
 		return 0;
 	}
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
-		if (error)
-			goto error0;
-	}
 
 	/*
-	 * If we couldn't get anything, give up.
+	 * Execute the fallback bnobt-based algorithm. This returns -EAGAIN if
+	 * the allocation failed due to busy extents. In that case, flush all
+	 * busy extents and restart.
 	 */
-	if (bno_cur_lt == NULL && bno_cur_gt == NULL) {
+	error = xfs_alloc_ag_vextent_near_bnobt(args, cnt_cur, &busy,
+						&busy_gen);
+	if (error == -EAGAIN) {
+		trace_xfs_alloc_near_busy(args);
 		xfs_btree_del_cursor(cnt_cur, XFS_BTREE_NOERROR);
-
-		if (busy) {
-			trace_xfs_alloc_near_busy(args);
-			xfs_extent_busy_flush(args->mp, args->pag, busy_gen);
-			goto restart;
-		}
-		trace_xfs_alloc_size_neither(args);
-		args->agbno = NULLAGBLOCK;
-		return 0;
+		xfs_extent_busy_flush(args->mp, args->pag, busy_gen);
+		goto restart;
 	}
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
+	if (error)
+		goto error;
 	xfs_btree_del_cursor(cnt_cur, XFS_BTREE_NOERROR);
-	xfs_btree_del_cursor(bno_cur_lt, XFS_BTREE_NOERROR);
 	return 0;
 
- error0:
+error:
 	trace_xfs_alloc_near_error(args);
-	if (cnt_cur != NULL)
+	if (cnt_cur)
 		xfs_btree_del_cursor(cnt_cur, XFS_BTREE_ERROR);
-	if (bno_cur_lt != NULL)
-		xfs_btree_del_cursor(bno_cur_lt, XFS_BTREE_ERROR);
-	if (bno_cur_gt != NULL)
-		xfs_btree_del_cursor(bno_cur_gt, XFS_BTREE_ERROR);
+	if (bno_cur)
+		xfs_btree_del_cursor(bno_cur, XFS_BTREE_ERROR);
 	return error;
 }
 
-- 
2.17.2
