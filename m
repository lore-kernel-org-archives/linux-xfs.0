Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p24CwSHL165570 for <xfs@oss.sgi.com>; Fri, 4 Mar 2011 06:58:29 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7648DA9603B
	for <xfs@oss.sgi.com>; Fri,  4 Mar 2011 05:01:20 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id y1HVb8sUTJmPmAHH for
	<xfs@oss.sgi.com>; Fri, 04 Mar 2011 05:01:20 -0800 (PST)
Message-Id: <20110304130119.656476789@bombadil.infradead.org>
Date: Fri, 04 Mar 2011 07:59:56 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 3/3] xfs: do not immediately reuse busy extent ranges
References: <20110304125953.650347660@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-skip-busy-extents
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Every time we reallocate a busy extent, we cause a synchronous log force
to occur to ensure the freeing transaction is on disk before we continue
and use the newly allocated extent.  This is extremely sub-optimal as we
have to mark every transaction with blocks that get reused as synchronous.

Instead of searching the busy extent list after deciding on the extent to
allocate, check each candidate extent during the allocation decisions as
to whether they are in the busy list.  If they are in the busy list, we
trim the busy range out of the extent we have found and determine if that
trimmed range is still OK for allocation. In many cases, this check can
be incorporated into the allocation extent alignment code which already
does trimming of the found extent before determining if it is a valid
candidate for allocation.

[hch: merged two earlier patches from Dave and fixed various bugs]

Signed-off-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/xfs_alloc.c
===================================================================
--- xfs.orig/fs/xfs/xfs_alloc.c	2011-03-02 12:18:01.599040095 -0500
+++ xfs/fs/xfs/xfs_alloc.c	2011-03-02 12:19:10.599027233 -0500
@@ -41,19 +41,13 @@
 #define	XFSA_FIXUP_BNO_OK	1
 #define	XFSA_FIXUP_CNT_OK	2
 
-/*
- * Prototypes for per-ag allocation routines
- */
-
 STATIC int xfs_alloc_ag_vextent_exact(xfs_alloc_arg_t *);
 STATIC int xfs_alloc_ag_vextent_near(xfs_alloc_arg_t *);
 STATIC int xfs_alloc_ag_vextent_size(xfs_alloc_arg_t *);
 STATIC int xfs_alloc_ag_vextent_small(xfs_alloc_arg_t *,
-	xfs_btree_cur_t *, xfs_agblock_t *, xfs_extlen_t *, int *);
-
-/*
- * Internal functions.
- */
+		xfs_btree_cur_t *, xfs_agblock_t *, xfs_extlen_t *, int *);
+STATIC void xfs_alloc_busy_trim(struct xfs_alloc_arg *,
+		xfs_agblock_t, xfs_extlen_t, xfs_agblock_t *, xfs_extlen_t *);
 
 /*
  * Lookup the record equal to [bno, len] in the btree given by cur.
@@ -154,19 +148,21 @@ xfs_alloc_compute_aligned(
 	xfs_extlen_t	*reslen)	/* result length */
 {
 	xfs_agblock_t	bno;
-	xfs_extlen_t	diff;
 	xfs_extlen_t	len;
 
-	if (args->alignment > 1 && foundlen >= args->minlen) {
-		bno = roundup(foundbno, args->alignment);
-		diff = bno - foundbno;
-		len = diff >= foundlen ? 0 : foundlen - diff;
+	/* Trim busy sections out of found extent */
+	xfs_alloc_busy_trim(args, foundbno, foundlen, &bno, &len);
+
+	if (args->alignment > 1 && len >= args->minlen) {
+		xfs_agblock_t	aligned_bno = roundup(bno, args->alignment);
+		xfs_extlen_t	diff = aligned_bno - bno;
+
+		*resbno = aligned_bno;
+		*reslen = diff >= len ? 0 : len - diff;
 	} else {
-		bno = foundbno;
-		len = foundlen;
+		*resbno = bno;
+		*reslen = len;
 	}
-	*resbno = bno;
-	*reslen = len;
 }
 
 /*
@@ -541,16 +537,8 @@ xfs_alloc_ag_vextent(
 		if (error)
 			return error;
 
-		/*
-		 * Search the busylist for these blocks and mark the
-		 * transaction as synchronous if blocks are found. This
-		 * avoids the need to block due to a synchronous log
-		 * force to ensure correct ordering as the synchronous
-		 * transaction will guarantee that for us.
-		 */
-		if (xfs_alloc_busy_search(args->mp, args->agno,
-					args->agbno, args->len))
-			xfs_trans_set_sync(args->tp);
+		ASSERT(!xfs_alloc_busy_search(args->mp, args->agno,
+					      args->agbno, args->len));
 	}
 
 	if (!args->isfl) {
@@ -577,14 +565,14 @@ xfs_alloc_ag_vextent_exact(
 {
 	xfs_btree_cur_t	*bno_cur;/* by block-number btree cursor */
 	xfs_btree_cur_t	*cnt_cur;/* by count btree cursor */
-	xfs_agblock_t	end;	/* end of allocated extent */
 	int		error;
 	xfs_agblock_t	fbno;	/* start block of found extent */
-	xfs_agblock_t	fend;	/* end block of found extent */
 	xfs_extlen_t	flen;	/* length of found extent */
+	xfs_agblock_t	tbno;	/* start block of trimmed extent */
+	xfs_extlen_t	tlen;	/* length of trimmed extent */
+	xfs_agblock_t	tend;	/* end block of trimmed extent */
+	xfs_agblock_t	end;	/* end of allocated extent */
 	int		i;	/* success/failure of operation */
-	xfs_agblock_t	maxend;	/* end of maximal extent */
-	xfs_agblock_t	minend;	/* end of minimal extent */
 	xfs_extlen_t	rlen;	/* length of returned extent */
 
 	ASSERT(args->alignment == 1);
@@ -614,14 +602,22 @@ xfs_alloc_ag_vextent_exact(
 		goto error0;
 	XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
 	ASSERT(fbno <= args->agbno);
-	minend = args->agbno + args->minlen;
-	maxend = args->agbno + args->maxlen;
-	fend = fbno + flen;
 
 	/*
-	 * Give up if the freespace isn't long enough for the minimum request.
+	 * Check for overlapping busy extents.
+	 */
+	xfs_alloc_busy_trim(args, fbno, flen, &tbno, &tlen);
+
+	/*
+	 * Give up if the start of the extent is busy, or the freespace isn't
+	 * long enough for the minimum request.
 	 */
-	if (fend < minend)
+	if (tbno > args->agbno)
+		goto not_found;
+	if (tlen < args->minlen)
+		goto not_found;
+	tend = tbno + tlen;
+	if (tend < args->agbno + args->minlen)
 		goto not_found;
 
 	/*
@@ -630,14 +626,14 @@ xfs_alloc_ag_vextent_exact(
 	 *
 	 * Fix the length according to mod and prod if given.
 	 */
-	end = XFS_AGBLOCK_MIN(fend, maxend);
+	end = XFS_AGBLOCK_MIN(tend, args->agbno + args->maxlen);
 	args->len = end - args->agbno;
 	xfs_alloc_fix_len(args);
 	if (!xfs_alloc_fix_minleft(args))
 		goto not_found;
 
 	rlen = args->len;
-	ASSERT(args->agbno + rlen <= fend);
+	ASSERT(args->agbno + rlen <= tend);
 	end = args->agbno + rlen;
 
 	/*
@@ -686,11 +682,11 @@ xfs_alloc_find_best_extent(
 	struct xfs_btree_cur	**scur,	/* searching cursor */
 	xfs_agblock_t		gdiff,	/* difference for search comparison */
 	xfs_agblock_t		*sbno,	/* extent found by search */
-	xfs_extlen_t		*slen,
-	xfs_extlen_t		*slena,	/* aligned length */
+	xfs_extlen_t		*slen,	/* extent length */
+	xfs_agblock_t		*sbnoa,	/* aligned extent found by search */
+	xfs_extlen_t		*slena,	/* aligned extent length */
 	int			dir)	/* 0 = search right, 1 = search left */
 {
-	xfs_agblock_t		bno;
 	xfs_agblock_t		new;
 	xfs_agblock_t		sdiff;
 	int			error;
@@ -708,16 +704,16 @@ xfs_alloc_find_best_extent(
 		if (error)
 			goto error0;
 		XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
-		xfs_alloc_compute_aligned(args, *sbno, *slen, &bno, slena);
+		xfs_alloc_compute_aligned(args, *sbno, *slen, sbnoa, slena);
 
 		/*
 		 * The good extent is closer than this one.
 		 */
 		if (!dir) {
-			if (bno >= args->agbno + gdiff)
+			if (*sbnoa >= args->agbno + gdiff)
 				goto out_use_good;
 		} else {
-			if (bno <= args->agbno - gdiff)
+			if (*sbnoa <= args->agbno - gdiff)
 				goto out_use_good;
 		}
 
@@ -729,8 +725,8 @@ xfs_alloc_find_best_extent(
 			xfs_alloc_fix_len(args);
 
 			sdiff = xfs_alloc_compute_diff(args->agbno, args->len,
-						       args->alignment, *sbno,
-						       *slen, &new);
+						       args->alignment, *sbnoa,
+						       *slena, &new);
 
 			/*
 			 * Choose closer size and invalidate other cursor.
@@ -780,7 +776,7 @@ xfs_alloc_ag_vextent_near(
 	xfs_agblock_t	gtbnoa;		/* aligned ... */
 	xfs_extlen_t	gtdiff;		/* difference to right side entry */
 	xfs_extlen_t	gtlen;		/* length of right side entry */
-	xfs_extlen_t	gtlena = 0;	/* aligned ... */
+	xfs_extlen_t	gtlena;		/* aligned ... */
 	xfs_agblock_t	gtnew;		/* useful start bno of right side */
 	int		error;		/* error code */
 	int		i;		/* result code, temporary */
@@ -789,9 +785,10 @@ xfs_alloc_ag_vextent_near(
 	xfs_agblock_t	ltbnoa;		/* aligned ... */
 	xfs_extlen_t	ltdiff;		/* difference to left side entry */
 	xfs_extlen_t	ltlen;		/* length of left side entry */
-	xfs_extlen_t	ltlena = 0;	/* aligned ... */
+	xfs_extlen_t	ltlena;		/* aligned ... */
 	xfs_agblock_t	ltnew;		/* useful start bno of left side */
 	xfs_extlen_t	rlen;		/* length of returned extent */
+	int		forced = 0;
 #if defined(DEBUG) && defined(__KERNEL__)
 	/*
 	 * Randomly don't execute the first algorithm.
@@ -800,13 +797,20 @@ xfs_alloc_ag_vextent_near(
 
 	dofirst = random32() & 1;
 #endif
+
+restart:
+	bno_cur_lt = NULL;
+	bno_cur_gt = NULL;
+	ltlen = 0;
+	gtlena = 0;
+	ltlena = 0;
+
 	/*
 	 * Get a cursor for the by-size btree.
 	 */
 	cnt_cur = xfs_allocbt_init_cursor(args->mp, args->tp, args->agbp,
 		args->agno, XFS_BTNUM_CNT);
-	ltlen = 0;
-	bno_cur_lt = bno_cur_gt = NULL;
+
 	/*
 	 * See if there are any free extents as big as maxlen.
 	 */
@@ -822,11 +826,13 @@ xfs_alloc_ag_vextent_near(
 			goto error0;
 		if (i == 0 || ltlen == 0) {
 			xfs_btree_del_cursor(cnt_cur, XFS_BTREE_NOERROR);
+			trace_xfs_alloc_near_noentry(args);
 			return 0;
 		}
 		ASSERT(i == 1);
 	}
 	args->wasfromfl = 0;
+
 	/*
 	 * First algorithm.
 	 * If the requested extent is large wrt the freespaces available
@@ -890,7 +896,7 @@ xfs_alloc_ag_vextent_near(
 			if (args->len < blen)
 				continue;
 			ltdiff = xfs_alloc_compute_diff(args->agbno, args->len,
-				args->alignment, ltbno, ltlen, &ltnew);
+				args->alignment, ltbnoa, ltlena, &ltnew);
 			if (ltnew != NULLAGBLOCK &&
 			    (args->len > blen || ltdiff < bdiff)) {
 				bdiff = ltdiff;
@@ -1042,11 +1048,12 @@ xfs_alloc_ag_vextent_near(
 			args->len = XFS_EXTLEN_MIN(ltlena, args->maxlen);
 			xfs_alloc_fix_len(args);
 			ltdiff = xfs_alloc_compute_diff(args->agbno, args->len,
-				args->alignment, ltbno, ltlen, &ltnew);
+				args->alignment, ltbnoa, ltlena, &ltnew);
 
 			error = xfs_alloc_find_best_extent(args,
 						&bno_cur_lt, &bno_cur_gt,
-						ltdiff, &gtbno, &gtlen, &gtlena,
+						ltdiff, &gtbno, &gtlen,
+						&gtbnoa, &gtlena,
 						0 /* search right */);
 		} else {
 			ASSERT(gtlena >= args->minlen);
@@ -1057,11 +1064,12 @@ xfs_alloc_ag_vextent_near(
 			args->len = XFS_EXTLEN_MIN(gtlena, args->maxlen);
 			xfs_alloc_fix_len(args);
 			gtdiff = xfs_alloc_compute_diff(args->agbno, args->len,
-				args->alignment, gtbno, gtlen, &gtnew);
+				args->alignment, gtbnoa, gtlena, &gtnew);
 
 			error = xfs_alloc_find_best_extent(args,
 						&bno_cur_gt, &bno_cur_lt,
-						gtdiff, &ltbno, &ltlen, &ltlena,
+						gtdiff, &ltbno, &ltlen,
+						&ltbnoa, &ltlena,
 						1 /* search left */);
 		}
 
@@ -1073,6 +1081,12 @@ xfs_alloc_ag_vextent_near(
 	 * If we couldn't get anything, give up.
 	 */
 	if (bno_cur_lt == NULL && bno_cur_gt == NULL) {
+		if (!forced++) {
+			trace_xfs_alloc_near_busy(args);
+			xfs_log_force(args->mp, XFS_LOG_SYNC);
+			goto restart;
+		}
+
 		trace_xfs_alloc_size_neither(args);
 		args->agbno = NULLAGBLOCK;
 		return 0;
@@ -1107,12 +1121,13 @@ xfs_alloc_ag_vextent_near(
 		return 0;
 	}
 	rlen = args->len;
-	(void)xfs_alloc_compute_diff(args->agbno, rlen, args->alignment, ltbno,
-		ltlen, &ltnew);
+	(void)xfs_alloc_compute_diff(args->agbno, rlen, args->alignment,
+				     ltbnoa, ltlena, &ltnew);
 	ASSERT(ltnew >= ltbno);
-	ASSERT(ltnew + rlen <= ltbno + ltlen);
+	ASSERT(ltnew + rlen <= ltbnoa + ltlena);
 	ASSERT(ltnew + rlen <= be32_to_cpu(XFS_BUF_TO_AGF(args->agbp)->agf_length));
 	args->agbno = ltnew;
+
 	if ((error = xfs_alloc_fixup_trees(cnt_cur, bno_cur_lt, ltbno, ltlen,
 			ltnew, rlen, XFSA_FIXUP_BNO_OK)))
 		goto error0;
@@ -1155,26 +1170,35 @@ xfs_alloc_ag_vextent_size(
 	int		i;		/* temp status variable */
 	xfs_agblock_t	rbno;		/* returned block number */
 	xfs_extlen_t	rlen;		/* length of returned extent */
+	int		forced = 0;
 
+restart:
 	/*
 	 * Allocate and initialize a cursor for the by-size btree.
 	 */
 	cnt_cur = xfs_allocbt_init_cursor(args->mp, args->tp, args->agbp,
 		args->agno, XFS_BTNUM_CNT);
 	bno_cur = NULL;
+
 	/*
 	 * Look for an entry >= maxlen+alignment-1 blocks.
 	 */
 	if ((error = xfs_alloc_lookup_ge(cnt_cur, 0,
 			args->maxlen + args->alignment - 1, &i)))
 		goto error0;
+
 	/*
-	 * If none, then pick up the last entry in the tree unless the
-	 * tree is empty.
-	 */
-	if (!i) {
-		if ((error = xfs_alloc_ag_vextent_small(args, cnt_cur, &fbno,
-				&flen, &i)))
+	 * If none or we have busy extents that we cannot allocate from, then
+	 * we have to settle for a smaller extent. In the case that there are
+	 * no large extents, this will return the last entry in the tree unless
+	 * the tree is empty. In the case that there are only busy large
+	 * extents, this will return the largest small extent unless there
+	 * are no smaller extents available.
+	 */
+	if (!i || forced > 1) {
+		error = xfs_alloc_ag_vextent_small(args, cnt_cur,
+						   &fbno, &flen, &i);
+		if (error)
 			goto error0;
 		if (i == 0 || flen == 0) {
 			xfs_btree_del_cursor(cnt_cur, XFS_BTREE_NOERROR);
@@ -1182,22 +1206,56 @@ xfs_alloc_ag_vextent_size(
 			return 0;
 		}
 		ASSERT(i == 1);
-	}
-	/*
-	 * There's a freespace as big as maxlen+alignment-1, get it.
-	 */
-	else {
-		if ((error = xfs_alloc_get_rec(cnt_cur, &fbno, &flen, &i)))
-			goto error0;
-		XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
-	}
+		xfs_alloc_compute_aligned(args, fbno, flen, &rbno, &rlen);
+	} else {
+		/*
+		 * Search for a non-busy extent that is large enough.
+		 * If we are at low space, don't check, or if we fall of
+		 * the end of the btree, turn off the busy check and
+		 * restart.
+		 */
+		for (;;) {
+			error = xfs_alloc_get_rec(cnt_cur, &fbno, &flen, &i);
+			if (error)
+				goto error0;
+			XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
+
+			xfs_alloc_compute_aligned(args, fbno, flen,
+						  &rbno, &rlen);
+
+			if (rlen >= args->maxlen)
+				break;
+
+			error = xfs_btree_increment(cnt_cur, 0, &i);
+			if (error)
+				goto error0;
+			if (i == 0) {
+				/*
+				 * Our only valid extents must have been busy.
+				 * Make it unbusy by forcing the log out and
+				 * retrying. If we've been here before, forcing
+				 * the log isn't making the extents available,
+				 * which means they have probably been freed in
+				 * this transaction.  In that case, we have to
+				 * give up on them and we'll attempt a minlen
+				 * allocation the next time around.
+				 */
+				xfs_btree_del_cursor(cnt_cur,
+						     XFS_BTREE_NOERROR);
+				trace_xfs_alloc_size_busy(args);
+				if (!forced++)
+					xfs_log_force(args->mp, XFS_LOG_SYNC);
+				goto restart;
+			}
+		}
+ 	}
+
 	/*
 	 * In the first case above, we got the last entry in the
 	 * by-size btree.  Now we check to see if the space hits maxlen
 	 * once aligned; if not, we search left for something better.
 	 * This can't happen in the second case above.
 	 */
-	xfs_alloc_compute_aligned(args, fbno, flen, &rbno, &rlen);
 	rlen = XFS_EXTLEN_MIN(args->maxlen, rlen);
 	XFS_WANT_CORRUPTED_GOTO(rlen == 0 ||
 			(rlen <= flen && rbno + rlen <= fbno + flen), error0);
@@ -1251,13 +1309,19 @@ xfs_alloc_ag_vextent_size(
 	 * Fix up the length.
 	 */
 	args->len = rlen;
-	xfs_alloc_fix_len(args);
-	if (rlen < args->minlen || !xfs_alloc_fix_minleft(args)) {
-		xfs_btree_del_cursor(cnt_cur, XFS_BTREE_NOERROR);
-		trace_xfs_alloc_size_nominleft(args);
-		args->agbno = NULLAGBLOCK;
-		return 0;
+	if (rlen < args->minlen) {
+		if (!forced++) {
+			xfs_btree_del_cursor(cnt_cur, XFS_BTREE_NOERROR);
+			trace_xfs_alloc_size_busy(args);
+			xfs_log_force(args->mp, XFS_LOG_SYNC);
+			goto restart;
+		}
+		goto out_nominleft;
 	}
+	xfs_alloc_fix_len(args);
+
+	if (!xfs_alloc_fix_minleft(args))
+		goto out_nominleft;
 	rlen = args->len;
 	XFS_WANT_CORRUPTED_GOTO(rlen <= flen, error0);
 	/*
@@ -1287,6 +1351,12 @@ error0:
 	if (bno_cur)
 		xfs_btree_del_cursor(bno_cur, XFS_BTREE_ERROR);
 	return error;
+
+out_nominleft:
+	xfs_btree_del_cursor(cnt_cur, XFS_BTREE_NOERROR);
+	trace_xfs_alloc_size_nominleft(args);
+	args->agbno = NULLAGBLOCK;
+	return 0;
 }
 
 /*
@@ -2657,6 +2727,177 @@ xfs_alloc_busy_search(
 	return match;
 }
 
+/*
+ * For a given extent [fbno, flen], search the busy extent list
+ * to find a subset of the extent that is not busy.
+ */
+STATIC void
+xfs_alloc_busy_trim(
+	struct xfs_alloc_arg	*args,
+	xfs_agblock_t		fbno,
+	xfs_extlen_t		flen,
+	xfs_agblock_t		*rbno,
+	xfs_extlen_t		*rlen)
+{
+	struct rb_node		*rbp;
+
+	ASSERT(flen > 0);
+
+	spin_lock(&args->pag->pagb_lock);
+	rbp = args->pag->pagb_tree.rb_node;
+	while (rbp && flen >= args->minlen) {
+		struct xfs_busy_extent *busyp =
+			rb_entry(rbp, struct xfs_busy_extent, rb_node);
+		xfs_agblock_t	fend = fbno + flen;
+		xfs_agblock_t	bbno = busyp->bno;
+		xfs_agblock_t	bend = bbno + busyp->length;
+
+		if (fbno + flen <= bbno) {
+			rbp = rbp->rb_left;
+			continue;
+		} else if (fbno >= bend) {
+			rbp = rbp->rb_right;
+			continue;
+		}
+
+		if (bbno <= fbno) {
+			/* start overlap */
+			ASSERT(bend > fbno);
+			ASSERT(bend <= fend);
+
+			/*
+			 * Case 1:
+			 *    bbno           bend
+			 *    +BBBBBBBBBBBBBBBBB+
+			 *        +---------+
+			 *        bno     end
+			 *
+			 * Case 2:
+			 *    bbno           bend
+			 *    +BBBBBBBBBBBBBBBBB+
+			 *    +-------------+
+			 *    bno         end
+			 *
+			 * Case 3:
+			 *    bbno           bend
+			 *    +BBBBBBBBBBBBBBBBB+
+			 *    +-----------------+
+			 *    bno             end
+			 *
+			 * No unbusy region in extent, return failure.
+			 */
+			if (fend <= bend)
+				goto fail;
+
+			/*
+			 * Case 4:
+			 *    bbno           bend
+			 *    +BBBBBBBBBBBBBBBBB+
+			 *        +----------------------+
+			 *        bno                  end
+			 *
+			 * Case 5:
+			 *    bbno           bend
+			 *    +BBBBBBBBBBBBBBBBB+
+			 *    +--------------------------+
+			 *    bno                      end
+			 *
+			 * Needs to be trimmed to:
+			 *                       +-------+
+			 *                       bno   end
+			 */
+			fbno = bend;
+		} else if (bend >= fend) {
+			/* end overlap */
+
+			/*
+			 * Case 6:
+			 *             bbno           bend
+			 *             +BBBBBBBBBBBBBBBBB+
+			 *    +------------------+
+			 *    bno              end
+			 *
+			 * Case 7:
+			 *             bbno           bend
+			 *             +BBBBBBBBBBBBBBBBB+
+			 *    +--------------------------+
+			 *    bno                      end
+			 *
+			 * Needs to be trimmed to:
+			 *    +-------+
+			 *    bno   end
+			 */
+			fend = bbno;
+		} else {
+			/* middle overlap */
+
+			/*
+			 * Case 9:
+			 *             bbno           bend
+			 *             +BBBBBBBBBBBBBBBBB+
+			 *    +-----------------------------------+
+			 *    bno                               end
+			 *
+			 * Can be trimmed to:
+			 *    +-------+        OR         +-------+
+			 *    bno   end                   bno   end
+			 *
+			 * We prefer the lower bno extent because the next
+			 * allocation for this inode will use "end" as the
+			 * target for first block.  If the busy segment has
+			 * cleared, this will get a contiguous allocation next
+			 * time around; if thebusy segment has not cleared,
+			 * it will get an allocation at bend, which is a forward
+			 * allocation.
+			 *
+			 * If we choose segment at bend, and this remains the
+			 * best extent for the next allocation (e.g. NEAR_BNO
+			 * allocation) we'll next allocate at bno, which will
+			 * give us backwards allocation.  We already know that
+			 * backwards allocation direction causes significant
+			 * fragmentation of directories and degradataion of
+			 * directory performance.
+			 *
+			 * Always chose the option that produces forward
+			 * allocation patterns so that sequential reads and
+			 * writes only ever seek in one direction.  Only choose
+			 * the higher bno extent if the remainin unused extent
+			 * length is much larger than the current allocation
+			 * request, promising us a contiguous allocation in
+			 * the following free space.
+			 */
+
+			if (bbno - fbno >= args->maxlen) {
+				/* left candidate fits perfect */
+				fend = bbno;
+			} else if (fend - bend >= args->maxlen * 4) {
+				/* right candidate has enough free space */
+				fbno = bend;
+			} else if (bbno - fbno >= args->minlen) {
+				/* left candidate fits minimum requirement */
+				fend = bbno;
+			} else {
+				goto fail;
+			}
+		}
+
+		flen = fend - fbno;
+	}
+	spin_unlock(&args->pag->pagb_lock);
+
+	*rbno = fbno;
+	*rlen = flen;
+	return;
+fail:
+	/*
+	 * Return a zero extent length as failure indications.  All callers
+	 * re-check if the trimmed extent satisfies the minlen requirement.
+	 */
+	spin_unlock(&args->pag->pagb_lock);
+	*rbno = fbno;
+	*rlen = 0;
+}
+
 void
 xfs_alloc_busy_clear(
 	struct xfs_mount	*mp,
Index: xfs/fs/xfs/linux-2.6/xfs_trace.h
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_trace.h	2011-03-02 12:17:26.235027219 -0500
+++ xfs/fs/xfs/linux-2.6/xfs_trace.h	2011-03-02 12:18:02.011028461 -0500
@@ -1433,11 +1433,14 @@ DEFINE_ALLOC_EVENT(xfs_alloc_near_first)
 DEFINE_ALLOC_EVENT(xfs_alloc_near_greater);
 DEFINE_ALLOC_EVENT(xfs_alloc_near_lesser);
 DEFINE_ALLOC_EVENT(xfs_alloc_near_error);
+DEFINE_ALLOC_EVENT(xfs_alloc_near_noentry);
+DEFINE_ALLOC_EVENT(xfs_alloc_near_busy);
 DEFINE_ALLOC_EVENT(xfs_alloc_size_neither);
 DEFINE_ALLOC_EVENT(xfs_alloc_size_noentry);
 DEFINE_ALLOC_EVENT(xfs_alloc_size_nominleft);
 DEFINE_ALLOC_EVENT(xfs_alloc_size_done);
 DEFINE_ALLOC_EVENT(xfs_alloc_size_error);
+DEFINE_ALLOC_EVENT(xfs_alloc_size_busy);
 DEFINE_ALLOC_EVENT(xfs_alloc_small_freelist);
 DEFINE_ALLOC_EVENT(xfs_alloc_small_notenough);
 DEFINE_ALLOC_EVENT(xfs_alloc_small_done);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
