Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 307117F63
	for <xfs@oss.sgi.com>; Fri,  6 Feb 2015 16:23:14 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 1D7C1304043
	for <xfs@oss.sgi.com>; Fri,  6 Feb 2015 14:23:13 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id g4AAJjA3pF4Ss4q9 for <xfs@oss.sgi.com>;
	Fri, 06 Feb 2015 14:23:09 -0800 (PST)
Message-ID: <54D53EB6.6000306@sandeen.net>
Date: Fri, 06 Feb 2015 16:22:46 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH 1/2] xfs: pass mp to XFS_WANT_CORRUPTED_GOTO
References: <54D53E8C.8070207@redhat.com>
In-Reply-To: <54D53E8C.8070207@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>

Today, if we hit an XFS_WANT_CORRUPTED_GOTO we don't print
any information about which filesystem hit it.  Passing
in the mp allows us to print the filesystem (device) name,
which is a pretty critical piece of information.

Tested by running fsfuzzer 'til I hit some.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index a6fbf44..d38d69a 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -682,7 +682,7 @@ xfs_alloc_ag_vextent_exact(
 	error = xfs_alloc_get_rec(bno_cur, &fbno, &flen, &i);
 	if (error)
 		goto error0;
-	XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
+	XFS_WANT_CORRUPTED_GOTO(args->mp, i == 1, error0);
 	ASSERT(fbno <= args->agbno);
 
 	/*
@@ -783,7 +783,7 @@ xfs_alloc_find_best_extent(
 		error = xfs_alloc_get_rec(*scur, sbno, slen, &i);
 		if (error)
 			goto error0;
-		XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
+		XFS_WANT_CORRUPTED_GOTO(args->mp, i == 1, error0);
 		xfs_alloc_compute_aligned(args, *sbno, *slen, sbnoa, slena);
 
 		/*
@@ -946,7 +946,7 @@ restart:
 				if ((error = xfs_alloc_get_rec(cnt_cur, &ltbno,
 						&ltlen, &i)))
 					goto error0;
-				XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
+				XFS_WANT_CORRUPTED_GOTO(args->mp, i == 1, error0);
 				if (ltlen >= args->minlen)
 					break;
 				if ((error = xfs_btree_increment(cnt_cur, 0, &i)))
@@ -966,7 +966,7 @@ restart:
 			 */
 			if ((error = xfs_alloc_get_rec(cnt_cur, &ltbno, &ltlen, &i)))
 				goto error0;
-			XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
+			XFS_WANT_CORRUPTED_GOTO(args->mp, i == 1, error0);
 			xfs_alloc_compute_aligned(args, ltbno, ltlen,
 						  &ltbnoa, &ltlena);
 			if (ltlena < args->minlen)
@@ -999,7 +999,7 @@ restart:
 		cnt_cur->bc_ptrs[0] = besti;
 		if ((error = xfs_alloc_get_rec(cnt_cur, &ltbno, &ltlen, &i)))
 			goto error0;
-		XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
+		XFS_WANT_CORRUPTED_GOTO(args->mp, i == 1, error0);
 		ASSERT(ltbno + ltlen <= be32_to_cpu(XFS_BUF_TO_AGF(args->agbp)->agf_length));
 		args->len = blen;
 		if (!xfs_alloc_fix_minleft(args)) {
@@ -1088,7 +1088,7 @@ restart:
 		if (bno_cur_lt) {
 			if ((error = xfs_alloc_get_rec(bno_cur_lt, &ltbno, &ltlen, &i)))
 				goto error0;
-			XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
+			XFS_WANT_CORRUPTED_GOTO(args->mp, i == 1, error0);
 			xfs_alloc_compute_aligned(args, ltbno, ltlen,
 						  &ltbnoa, &ltlena);
 			if (ltlena >= args->minlen)
@@ -1104,7 +1104,7 @@ restart:
 		if (bno_cur_gt) {
 			if ((error = xfs_alloc_get_rec(bno_cur_gt, &gtbno, &gtlen, &i)))
 				goto error0;
-			XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
+			XFS_WANT_CORRUPTED_GOTO(args->mp, i == 1, error0);
 			xfs_alloc_compute_aligned(args, gtbno, gtlen,
 						  &gtbnoa, &gtlena);
 			if (gtlena >= args->minlen)
@@ -1303,7 +1303,7 @@ restart:
 			error = xfs_alloc_get_rec(cnt_cur, &fbno, &flen, &i);
 			if (error)
 				goto error0;
-			XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
+			XFS_WANT_CORRUPTED_GOTO(args->mp, i == 1, error0);
 
 			xfs_alloc_compute_aligned(args, fbno, flen,
 						  &rbno, &rlen);
@@ -1342,7 +1342,7 @@ restart:
 	 * This can't happen in the second case above.
 	 */
 	rlen = XFS_EXTLEN_MIN(args->maxlen, rlen);
-	XFS_WANT_CORRUPTED_GOTO(rlen == 0 ||
+	XFS_WANT_CORRUPTED_GOTO(args->mp, rlen == 0 ||
 			(rlen <= flen && rbno + rlen <= fbno + flen), error0);
 	if (rlen < args->maxlen) {
 		xfs_agblock_t	bestfbno;
@@ -1362,13 +1362,13 @@ restart:
 			if ((error = xfs_alloc_get_rec(cnt_cur, &fbno, &flen,
 					&i)))
 				goto error0;
-			XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
+			XFS_WANT_CORRUPTED_GOTO(args->mp, i == 1, error0);
 			if (flen < bestrlen)
 				break;
 			xfs_alloc_compute_aligned(args, fbno, flen,
 						  &rbno, &rlen);
 			rlen = XFS_EXTLEN_MIN(args->maxlen, rlen);
-			XFS_WANT_CORRUPTED_GOTO(rlen == 0 ||
+			XFS_WANT_CORRUPTED_GOTO(args->mp, rlen == 0 ||
 				(rlen <= flen && rbno + rlen <= fbno + flen),
 				error0);
 			if (rlen > bestrlen) {
@@ -1383,7 +1383,7 @@ restart:
 		if ((error = xfs_alloc_lookup_eq(cnt_cur, bestfbno, bestflen,
 				&i)))
 			goto error0;
-		XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
+		XFS_WANT_CORRUPTED_GOTO(args->mp, i == 1, error0);
 		rlen = bestrlen;
 		rbno = bestrbno;
 		flen = bestflen;
@@ -1408,7 +1408,7 @@ restart:
 	if (!xfs_alloc_fix_minleft(args))
 		goto out_nominleft;
 	rlen = args->len;
-	XFS_WANT_CORRUPTED_GOTO(rlen <= flen, error0);
+	XFS_WANT_CORRUPTED_GOTO(args->mp, rlen <= flen, error0);
 	/*
 	 * Allocate and initialize a cursor for the by-block tree.
 	 */
@@ -1422,7 +1422,7 @@ restart:
 	cnt_cur = bno_cur = NULL;
 	args->len = rlen;
 	args->agbno = rbno;
-	XFS_WANT_CORRUPTED_GOTO(
+	XFS_WANT_CORRUPTED_GOTO(args->mp,
 		args->agbno + args->len <=
 			be32_to_cpu(XFS_BUF_TO_AGF(args->agbp)->agf_length),
 		error0);
@@ -1467,7 +1467,7 @@ xfs_alloc_ag_vextent_small(
 	if (i) {
 		if ((error = xfs_alloc_get_rec(ccur, &fbno, &flen, &i)))
 			goto error0;
-		XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
+		XFS_WANT_CORRUPTED_GOTO(args->mp, i == 1, error0);
 	}
 	/*
 	 * Nothing in the btree, try the freelist.  Make sure
@@ -1493,7 +1493,7 @@ xfs_alloc_ag_vextent_small(
 			}
 			args->len = 1;
 			args->agbno = fbno;
-			XFS_WANT_CORRUPTED_GOTO(
+			XFS_WANT_CORRUPTED_GOTO(args->mp,
 				args->agbno + args->len <=
 				be32_to_cpu(XFS_BUF_TO_AGF(args->agbp)->agf_length),
 				error0);
@@ -1579,7 +1579,7 @@ xfs_free_ag_extent(
 		 */
 		if ((error = xfs_alloc_get_rec(bno_cur, &ltbno, &ltlen, &i)))
 			goto error0;
-		XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
+		XFS_WANT_CORRUPTED_GOTO(mp, i == 1, error0);
 		/*
 		 * It's not contiguous, though.
 		 */
@@ -1591,7 +1591,8 @@ xfs_free_ag_extent(
 			 * space was invalid, it's (partly) already free.
 			 * Very bad.
 			 */
-			XFS_WANT_CORRUPTED_GOTO(ltbno + ltlen <= bno, error0);
+			XFS_WANT_CORRUPTED_GOTO(mp,
+						ltbno + ltlen <= bno, error0);
 		}
 	}
 	/*
@@ -1606,7 +1607,7 @@ xfs_free_ag_extent(
 		 */
 		if ((error = xfs_alloc_get_rec(bno_cur, &gtbno, &gtlen, &i)))
 			goto error0;
-		XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
+		XFS_WANT_CORRUPTED_GOTO(mp, i == 1, error0);
 		/*
 		 * It's not contiguous, though.
 		 */
@@ -1618,7 +1619,7 @@ xfs_free_ag_extent(
 			 * space was invalid, it's (partly) already free.
 			 * Very bad.
 			 */
-			XFS_WANT_CORRUPTED_GOTO(gtbno >= bno + len, error0);
+			XFS_WANT_CORRUPTED_GOTO(mp, gtbno >= bno + len, error0);
 		}
 	}
 	/*
@@ -1635,31 +1636,31 @@ xfs_free_ag_extent(
 		 */
 		if ((error = xfs_alloc_lookup_eq(cnt_cur, ltbno, ltlen, &i)))
 			goto error0;
-		XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
+		XFS_WANT_CORRUPTED_GOTO(mp, i == 1, error0);
 		if ((error = xfs_btree_delete(cnt_cur, &i)))
 			goto error0;
-		XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
+		XFS_WANT_CORRUPTED_GOTO(mp, i == 1, error0);
 		/*
 		 * Delete the old by-size entry on the right.
 		 */
 		if ((error = xfs_alloc_lookup_eq(cnt_cur, gtbno, gtlen, &i)))
 			goto error0;
-		XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
+		XFS_WANT_CORRUPTED_GOTO(mp, i == 1, error0);
 		if ((error = xfs_btree_delete(cnt_cur, &i)))
 			goto error0;
-		XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
+		XFS_WANT_CORRUPTED_GOTO(mp, i == 1, error0);
 		/*
 		 * Delete the old by-block entry for the right block.
 		 */
 		if ((error = xfs_btree_delete(bno_cur, &i)))
 			goto error0;
-		XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
+		XFS_WANT_CORRUPTED_GOTO(mp, i == 1, error0);
 		/*
 		 * Move the by-block cursor back to the left neighbor.
 		 */
 		if ((error = xfs_btree_decrement(bno_cur, 0, &i)))
 			goto error0;
-		XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
+		XFS_WANT_CORRUPTED_GOTO(mp, i == 1, error0);
 #ifdef DEBUG
 		/*
 		 * Check that this is the right record: delete didn't
@@ -1672,7 +1673,7 @@ xfs_free_ag_extent(
 			if ((error = xfs_alloc_get_rec(bno_cur, &xxbno, &xxlen,
 					&i)))
 				goto error0;
-			XFS_WANT_CORRUPTED_GOTO(
+			XFS_WANT_CORRUPTED_GOTO(mp,
 				i == 1 && xxbno == ltbno && xxlen == ltlen,
 				error0);
 		}
@@ -1695,17 +1696,17 @@ xfs_free_ag_extent(
 		 */
 		if ((error = xfs_alloc_lookup_eq(cnt_cur, ltbno, ltlen, &i)))
 			goto error0;
-		XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
+		XFS_WANT_CORRUPTED_GOTO(mp, i == 1, error0);
 		if ((error = xfs_btree_delete(cnt_cur, &i)))
 			goto error0;
-		XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
+		XFS_WANT_CORRUPTED_GOTO(mp, i == 1, error0);
 		/*
 		 * Back up the by-block cursor to the left neighbor, and
 		 * update its length.
 		 */
 		if ((error = xfs_btree_decrement(bno_cur, 0, &i)))
 			goto error0;
-		XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
+		XFS_WANT_CORRUPTED_GOTO(mp, i == 1, error0);
 		nbno = ltbno;
 		nlen = len + ltlen;
 		if ((error = xfs_alloc_update(bno_cur, nbno, nlen)))
@@ -1721,10 +1722,10 @@ xfs_free_ag_extent(
 		 */
 		if ((error = xfs_alloc_lookup_eq(cnt_cur, gtbno, gtlen, &i)))
 			goto error0;
-		XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
+		XFS_WANT_CORRUPTED_GOTO(mp, i == 1, error0);
 		if ((error = xfs_btree_delete(cnt_cur, &i)))
 			goto error0;
-		XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
+		XFS_WANT_CORRUPTED_GOTO(mp, i == 1, error0);
 		/*
 		 * Update the starting block and length of the right
 		 * neighbor in the by-block tree.
@@ -1743,7 +1744,7 @@ xfs_free_ag_extent(
 		nlen = len;
 		if ((error = xfs_btree_insert(bno_cur, &i)))
 			goto error0;
-		XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
+		XFS_WANT_CORRUPTED_GOTO(mp, i == 1, error0);
 	}
 	xfs_btree_del_cursor(bno_cur, XFS_BTREE_NOERROR);
 	bno_cur = NULL;
@@ -1752,10 +1753,10 @@ xfs_free_ag_extent(
 	 */
 	if ((error = xfs_alloc_lookup_eq(cnt_cur, nbno, nlen, &i)))
 		goto error0;
-	XFS_WANT_CORRUPTED_GOTO(i == 0, error0);
+	XFS_WANT_CORRUPTED_GOTO(mp, i == 0, error0);
 	if ((error = xfs_btree_insert(cnt_cur, &i)))
 		goto error0;
-	XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
+	XFS_WANT_CORRUPTED_GOTO(mp, i == 1, error0);
 	xfs_btree_del_cursor(cnt_cur, XFS_BTREE_NOERROR);
 	cnt_cur = NULL;
 
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index b5eb474..c655a41 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -410,7 +410,7 @@ xfs_bmap_check_leaf_extents(
 				goto error_norelse;
 		}
 		block = XFS_BUF_TO_BLOCK(bp);
-		XFS_WANT_CORRUPTED_GOTO(
+		XFS_WANT_CORRUPTED_GOTO(mp,
 			xfs_bmap_sanity_check(mp, bp, level),
 			error0);
 		if (level == 0)
@@ -424,7 +424,8 @@ xfs_bmap_check_leaf_extents(
 		xfs_check_block(block, mp, 0, 0);
 		pp = XFS_BMBT_PTR_ADDR(mp, block, 1, mp->m_bmap_dmxr[1]);
 		bno = be64_to_cpu(*pp);
-		XFS_WANT_CORRUPTED_GOTO(XFS_FSB_SANITY_CHECK(mp, bno), error0);
+		XFS_WANT_CORRUPTED_GOTO(mp,
+					XFS_FSB_SANITY_CHECK(mp, bno), error0);
 		if (bp_release) {
 			bp_release = 0;
 			xfs_trans_brelse(NULL, bp);
@@ -1025,7 +1026,7 @@ xfs_bmap_add_attrfork_btree(
 		if ((error = xfs_bmbt_lookup_ge(cur, 0, 0, 0, &stat)))
 			goto error0;
 		/* must be at least one entry */
-		XFS_WANT_CORRUPTED_GOTO(stat == 1, error0);
+		XFS_WANT_CORRUPTED_GOTO(mp, stat == 1, error0);
 		if ((error = xfs_btree_new_iroot(cur, flags, &stat)))
 			goto error0;
 		if (stat == 0) {
@@ -1309,14 +1310,14 @@ xfs_bmap_read_extents(
 		if (error)
 			return error;
 		block = XFS_BUF_TO_BLOCK(bp);
-		XFS_WANT_CORRUPTED_GOTO(
-			xfs_bmap_sanity_check(mp, bp, level),
-			error0);
+		XFS_WANT_CORRUPTED_GOTO(mp,
+			xfs_bmap_sanity_check(mp, bp, level), error0);
 		if (level == 0)
 			break;
 		pp = XFS_BMBT_PTR_ADDR(mp, block, 1, mp->m_bmap_dmxr[1]);
 		bno = be64_to_cpu(*pp);
-		XFS_WANT_CORRUPTED_GOTO(XFS_FSB_SANITY_CHECK(mp, bno), error0);
+		XFS_WANT_CORRUPTED_GOTO(mp,
+			XFS_FSB_SANITY_CHECK(mp, bno), error0);
 		xfs_trans_brelse(tp, bp);
 	}
 	/*
@@ -1343,7 +1344,7 @@ xfs_bmap_read_extents(
 				XFS_ERRLEVEL_LOW, ip->i_mount, block);
 			goto error0;
 		}
-		XFS_WANT_CORRUPTED_GOTO(
+		XFS_WANT_CORRUPTED_GOTO(mp,
 			xfs_bmap_sanity_check(mp, bp, 0),
 			error0);
 		/*
@@ -1753,7 +1754,9 @@ xfs_bmap_add_extent_delay_real(
 	xfs_filblks_t		temp=0;	/* value for da_new calculations */
 	xfs_filblks_t		temp2=0;/* value for da_new calculations */
 	int			tmp_rval;	/* partial logging flags */
+	struct xfs_mount	*mp;
 
+	mp  = bma->tp ? bma->tp->t_mountp : NULL;
 	ifp = XFS_IFORK_PTR(bma->ip, XFS_DATA_FORK);
 
 	ASSERT(bma->idx >= 0);
@@ -1864,15 +1867,15 @@ xfs_bmap_add_extent_delay_real(
 					RIGHT.br_blockcount, &i);
 			if (error)
 				goto done;
-			XFS_WANT_CORRUPTED_GOTO(i == 1, done);
+			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
 			error = xfs_btree_delete(bma->cur, &i);
 			if (error)
 				goto done;
-			XFS_WANT_CORRUPTED_GOTO(i == 1, done);
+			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
 			error = xfs_btree_decrement(bma->cur, 0, &i);
 			if (error)
 				goto done;
-			XFS_WANT_CORRUPTED_GOTO(i == 1, done);
+			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
 			error = xfs_bmbt_update(bma->cur, LEFT.br_startoff,
 					LEFT.br_startblock,
 					LEFT.br_blockcount +
@@ -1905,7 +1908,7 @@ xfs_bmap_add_extent_delay_real(
 					&i);
 			if (error)
 				goto done;
-			XFS_WANT_CORRUPTED_GOTO(i == 1, done);
+			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
 			error = xfs_bmbt_update(bma->cur, LEFT.br_startoff,
 					LEFT.br_startblock,
 					LEFT.br_blockcount +
@@ -1936,7 +1939,7 @@ xfs_bmap_add_extent_delay_real(
 					RIGHT.br_blockcount, &i);
 			if (error)
 				goto done;
-			XFS_WANT_CORRUPTED_GOTO(i == 1, done);
+			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
 			error = xfs_bmbt_update(bma->cur, PREV.br_startoff,
 					new->br_startblock,
 					PREV.br_blockcount +
@@ -1966,12 +1969,12 @@ xfs_bmap_add_extent_delay_real(
 					&i);
 			if (error)
 				goto done;
-			XFS_WANT_CORRUPTED_GOTO(i == 0, done);
+			XFS_WANT_CORRUPTED_GOTO(mp, i == 0, done);
 			bma->cur->bc_rec.b.br_state = XFS_EXT_NORM;
 			error = xfs_btree_insert(bma->cur, &i);
 			if (error)
 				goto done;
-			XFS_WANT_CORRUPTED_GOTO(i == 1, done);
+			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
 		}
 		break;
 
@@ -1999,7 +2002,7 @@ xfs_bmap_add_extent_delay_real(
 					&i);
 			if (error)
 				goto done;
-			XFS_WANT_CORRUPTED_GOTO(i == 1, done);
+			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
 			error = xfs_bmbt_update(bma->cur, LEFT.br_startoff,
 					LEFT.br_startblock,
 					LEFT.br_blockcount +
@@ -2036,12 +2039,12 @@ xfs_bmap_add_extent_delay_real(
 					&i);
 			if (error)
 				goto done;
-			XFS_WANT_CORRUPTED_GOTO(i == 0, done);
+			XFS_WANT_CORRUPTED_GOTO(mp, i == 0, done);
 			bma->cur->bc_rec.b.br_state = XFS_EXT_NORM;
 			error = xfs_btree_insert(bma->cur, &i);
 			if (error)
 				goto done;
-			XFS_WANT_CORRUPTED_GOTO(i == 1, done);
+			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
 		}
 
 		if (xfs_bmap_needs_btree(bma->ip, XFS_DATA_FORK)) {
@@ -2082,7 +2085,7 @@ xfs_bmap_add_extent_delay_real(
 					RIGHT.br_blockcount, &i);
 			if (error)
 				goto done;
-			XFS_WANT_CORRUPTED_GOTO(i == 1, done);
+			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
 			error = xfs_bmbt_update(bma->cur, new->br_startoff,
 					new->br_startblock,
 					new->br_blockcount +
@@ -2120,12 +2123,12 @@ xfs_bmap_add_extent_delay_real(
 					&i);
 			if (error)
 				goto done;
-			XFS_WANT_CORRUPTED_GOTO(i == 0, done);
+			XFS_WANT_CORRUPTED_GOTO(mp, i == 0, done);
 			bma->cur->bc_rec.b.br_state = XFS_EXT_NORM;
 			error = xfs_btree_insert(bma->cur, &i);
 			if (error)
 				goto done;
-			XFS_WANT_CORRUPTED_GOTO(i == 1, done);
+			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
 		}
 
 		if (xfs_bmap_needs_btree(bma->ip, XFS_DATA_FORK)) {
@@ -2189,12 +2192,12 @@ xfs_bmap_add_extent_delay_real(
 					&i);
 			if (error)
 				goto done;
-			XFS_WANT_CORRUPTED_GOTO(i == 0, done);
+			XFS_WANT_CORRUPTED_GOTO(mp, i == 0, done);
 			bma->cur->bc_rec.b.br_state = XFS_EXT_NORM;
 			error = xfs_btree_insert(bma->cur, &i);
 			if (error)
 				goto done;
-			XFS_WANT_CORRUPTED_GOTO(i == 1, done);
+			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
 		}
 
 		if (xfs_bmap_needs_btree(bma->ip, XFS_DATA_FORK)) {
@@ -2307,6 +2310,7 @@ xfs_bmap_add_extent_unwritten_real(
 					/* left is 0, right is 1, prev is 2 */
 	int			rval=0;	/* return value (logging flags) */
 	int			state = 0;/* state bits, accessed thru macros */
+	struct xfs_mount	*mp = tp->t_mountp;
 
 	*logflagsp = 0;
 
@@ -2419,19 +2423,19 @@ xfs_bmap_add_extent_unwritten_real(
 					RIGHT.br_startblock,
 					RIGHT.br_blockcount, &i)))
 				goto done;
-			XFS_WANT_CORRUPTED_GOTO(i == 1, done);
+			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
 			if ((error = xfs_btree_delete(cur, &i)))
 				goto done;
-			XFS_WANT_CORRUPTED_GOTO(i == 1, done);
+			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
 			if ((error = xfs_btree_decrement(cur, 0, &i)))
 				goto done;
-			XFS_WANT_CORRUPTED_GOTO(i == 1, done);
+			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
 			if ((error = xfs_btree_delete(cur, &i)))
 				goto done;
-			XFS_WANT_CORRUPTED_GOTO(i == 1, done);
+			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
 			if ((error = xfs_btree_decrement(cur, 0, &i)))
 				goto done;
-			XFS_WANT_CORRUPTED_GOTO(i == 1, done);
+			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
 			if ((error = xfs_bmbt_update(cur, LEFT.br_startoff,
 				LEFT.br_startblock,
 				LEFT.br_blockcount + PREV.br_blockcount +
@@ -2462,13 +2466,13 @@ xfs_bmap_add_extent_unwritten_real(
 					PREV.br_startblock, PREV.br_blockcount,
 					&i)))
 				goto done;
-			XFS_WANT_CORRUPTED_GOTO(i == 1, done);
+			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
 			if ((error = xfs_btree_delete(cur, &i)))
 				goto done;
-			XFS_WANT_CORRUPTED_GOTO(i == 1, done);
+			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
 			if ((error = xfs_btree_decrement(cur, 0, &i)))
 				goto done;
-			XFS_WANT_CORRUPTED_GOTO(i == 1, done);
+			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
 			if ((error = xfs_bmbt_update(cur, LEFT.br_startoff,
 				LEFT.br_startblock,
 				LEFT.br_blockcount + PREV.br_blockcount,
@@ -2497,13 +2501,13 @@ xfs_bmap_add_extent_unwritten_real(
 					RIGHT.br_startblock,
 					RIGHT.br_blockcount, &i)))
 				goto done;
-			XFS_WANT_CORRUPTED_GOTO(i == 1, done);
+			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
 			if ((error = xfs_btree_delete(cur, &i)))
 				goto done;
-			XFS_WANT_CORRUPTED_GOTO(i == 1, done);
+			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
 			if ((error = xfs_btree_decrement(cur, 0, &i)))
 				goto done;
-			XFS_WANT_CORRUPTED_GOTO(i == 1, done);
+			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
 			if ((error = xfs_bmbt_update(cur, new->br_startoff,
 				new->br_startblock,
 				new->br_blockcount + RIGHT.br_blockcount,
@@ -2530,7 +2534,7 @@ xfs_bmap_add_extent_unwritten_real(
 					new->br_startblock, new->br_blockcount,
 					&i)))
 				goto done;
-			XFS_WANT_CORRUPTED_GOTO(i == 1, done);
+			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
 			if ((error = xfs_bmbt_update(cur, new->br_startoff,
 				new->br_startblock, new->br_blockcount,
 				newext)))
@@ -2567,7 +2571,7 @@ xfs_bmap_add_extent_unwritten_real(
 					PREV.br_startblock, PREV.br_blockcount,
 					&i)))
 				goto done;
-			XFS_WANT_CORRUPTED_GOTO(i == 1, done);
+			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
 			if ((error = xfs_bmbt_update(cur,
 				PREV.br_startoff + new->br_blockcount,
 				PREV.br_startblock + new->br_blockcount,
@@ -2609,7 +2613,7 @@ xfs_bmap_add_extent_unwritten_real(
 					PREV.br_startblock, PREV.br_blockcount,
 					&i)))
 				goto done;
-			XFS_WANT_CORRUPTED_GOTO(i == 1, done);
+			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
 			if ((error = xfs_bmbt_update(cur,
 				PREV.br_startoff + new->br_blockcount,
 				PREV.br_startblock + new->br_blockcount,
@@ -2619,7 +2623,7 @@ xfs_bmap_add_extent_unwritten_real(
 			cur->bc_rec.b = *new;
 			if ((error = xfs_btree_insert(cur, &i)))
 				goto done;
-			XFS_WANT_CORRUPTED_GOTO(i == 1, done);
+			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
 		}
 		break;
 
@@ -2649,7 +2653,7 @@ xfs_bmap_add_extent_unwritten_real(
 					PREV.br_startblock,
 					PREV.br_blockcount, &i)))
 				goto done;
-			XFS_WANT_CORRUPTED_GOTO(i == 1, done);
+			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
 			if ((error = xfs_bmbt_update(cur, PREV.br_startoff,
 				PREV.br_startblock,
 				PREV.br_blockcount - new->br_blockcount,
@@ -2687,7 +2691,7 @@ xfs_bmap_add_extent_unwritten_real(
 					PREV.br_startblock, PREV.br_blockcount,
 					&i)))
 				goto done;
-			XFS_WANT_CORRUPTED_GOTO(i == 1, done);
+			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
 			if ((error = xfs_bmbt_update(cur, PREV.br_startoff,
 				PREV.br_startblock,
 				PREV.br_blockcount - new->br_blockcount,
@@ -2697,11 +2701,11 @@ xfs_bmap_add_extent_unwritten_real(
 					new->br_startblock, new->br_blockcount,
 					&i)))
 				goto done;
-			XFS_WANT_CORRUPTED_GOTO(i == 0, done);
+			XFS_WANT_CORRUPTED_GOTO(mp, i == 0, done);
 			cur->bc_rec.b.br_state = XFS_EXT_NORM;
 			if ((error = xfs_btree_insert(cur, &i)))
 				goto done;
-			XFS_WANT_CORRUPTED_GOTO(i == 1, done);
+			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
 		}
 		break;
 
@@ -2735,7 +2739,7 @@ xfs_bmap_add_extent_unwritten_real(
 					PREV.br_startblock, PREV.br_blockcount,
 					&i)))
 				goto done;
-			XFS_WANT_CORRUPTED_GOTO(i == 1, done);
+			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
 			/* new right extent - oldext */
 			if ((error = xfs_bmbt_update(cur, r[1].br_startoff,
 				r[1].br_startblock, r[1].br_blockcount,
@@ -2747,7 +2751,7 @@ xfs_bmap_add_extent_unwritten_real(
 				new->br_startoff - PREV.br_startoff;
 			if ((error = xfs_btree_insert(cur, &i)))
 				goto done;
-			XFS_WANT_CORRUPTED_GOTO(i == 1, done);
+			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
 			/*
 			 * Reset the cursor to the position of the new extent
 			 * we are about to insert as we can't trust it after
@@ -2757,12 +2761,12 @@ xfs_bmap_add_extent_unwritten_real(
 					new->br_startblock, new->br_blockcount,
 					&i)))
 				goto done;
-			XFS_WANT_CORRUPTED_GOTO(i == 0, done);
+			XFS_WANT_CORRUPTED_GOTO(mp, i == 0, done);
 			/* new middle extent - newext */
 			cur->bc_rec.b.br_state = new->br_state;
 			if ((error = xfs_btree_insert(cur, &i)))
 				goto done;
-			XFS_WANT_CORRUPTED_GOTO(i == 1, done);
+			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
 		}
 		break;
 
@@ -2966,7 +2970,9 @@ xfs_bmap_add_extent_hole_real(
 	xfs_bmbt_irec_t		right;	/* right neighbor extent entry */
 	int			rval=0;	/* return value (logging flags) */
 	int			state;	/* state bits, accessed thru macros */
+	struct xfs_mount	*mp;
 
+	mp = bma->tp ? bma->tp->t_mountp : NULL;
 	ifp = XFS_IFORK_PTR(bma->ip, whichfork);
 
 	ASSERT(bma->idx >= 0);
@@ -3054,15 +3060,15 @@ xfs_bmap_add_extent_hole_real(
 					&i);
 			if (error)
 				goto done;
-			XFS_WANT_CORRUPTED_GOTO(i == 1, done);
+			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
 			error = xfs_btree_delete(bma->cur, &i);
 			if (error)
 				goto done;
-			XFS_WANT_CORRUPTED_GOTO(i == 1, done);
+			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
 			error = xfs_btree_decrement(bma->cur, 0, &i);
 			if (error)
 				goto done;
-			XFS_WANT_CORRUPTED_GOTO(i == 1, done);
+			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
 			error = xfs_bmbt_update(bma->cur, left.br_startoff,
 					left.br_startblock,
 					left.br_blockcount +
@@ -3095,7 +3101,7 @@ xfs_bmap_add_extent_hole_real(
 					&i);
 			if (error)
 				goto done;
-			XFS_WANT_CORRUPTED_GOTO(i == 1, done);
+			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
 			error = xfs_bmbt_update(bma->cur, left.br_startoff,
 					left.br_startblock,
 					left.br_blockcount +
@@ -3129,7 +3135,7 @@ xfs_bmap_add_extent_hole_real(
 					right.br_blockcount, &i);
 			if (error)
 				goto done;
-			XFS_WANT_CORRUPTED_GOTO(i == 1, done);
+			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
 			error = xfs_bmbt_update(bma->cur, new->br_startoff,
 					new->br_startblock,
 					new->br_blockcount +
@@ -3159,12 +3165,12 @@ xfs_bmap_add_extent_hole_real(
 					new->br_blockcount, &i);
 			if (error)
 				goto done;
-			XFS_WANT_CORRUPTED_GOTO(i == 0, done);
+			XFS_WANT_CORRUPTED_GOTO(mp, i == 0, done);
 			bma->cur->bc_rec.b.br_state = new->br_state;
 			error = xfs_btree_insert(bma->cur, &i);
 			if (error)
 				goto done;
-			XFS_WANT_CORRUPTED_GOTO(i == 1, done);
+			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
 		}
 		break;
 	}
@@ -4799,7 +4805,7 @@ xfs_bmap_del_extent(
 					got.br_startblock, got.br_blockcount,
 					&i)))
 				goto done;
-			XFS_WANT_CORRUPTED_GOTO(i == 1, done);
+			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
 		}
 		da_old = da_new = 0;
 	} else {
@@ -4833,7 +4839,7 @@ xfs_bmap_del_extent(
 		}
 		if ((error = xfs_btree_delete(cur, &i)))
 			goto done;
-		XFS_WANT_CORRUPTED_GOTO(i == 1, done);
+		XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
 		break;
 
 	case 2:
@@ -4933,7 +4939,8 @@ xfs_bmap_del_extent(
 							got.br_startblock,
 							temp, &i)))
 						goto done;
-					XFS_WANT_CORRUPTED_GOTO(i == 1, done);
+					XFS_WANT_CORRUPTED_GOTO(mp,
+								i == 1, done);
 					/*
 					 * Update the btree record back
 					 * to the original value.
@@ -4954,7 +4961,7 @@ xfs_bmap_del_extent(
 					error = -ENOSPC;
 					goto done;
 				}
-				XFS_WANT_CORRUPTED_GOTO(i == 1, done);
+				XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
 			} else
 				flags |= xfs_ilog_fext(whichfork);
 			XFS_IFORK_NEXT_SET(ip, whichfork,
diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index 81cad43..8c5ce10 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -2285,7 +2285,7 @@ xfs_btree_rshift(
 	if (error)
 		goto error0;
 	i = xfs_btree_lastrec(tcur, level);
-	XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
+	XFS_WANT_CORRUPTED_GOTO(cur->bc_mp, i == 1, error0);
 
 	error = xfs_btree_increment(tcur, level, &i);
 	if (error)
@@ -3138,7 +3138,7 @@ xfs_btree_insert(
 			goto error0;
 		}
 
-		XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
+		XFS_WANT_CORRUPTED_GOTO(cur->bc_mp, i == 1, error0);
 		level++;
 
 		/*
@@ -3582,15 +3582,15 @@ xfs_btree_delrec(
 		 * Actually any entry but the first would suffice.
 		 */
 		i = xfs_btree_lastrec(tcur, level);
-		XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
+		XFS_WANT_CORRUPTED_GOTO(cur->bc_mp, i == 1, error0);
 
 		error = xfs_btree_increment(tcur, level, &i);
 		if (error)
 			goto error0;
-		XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
+		XFS_WANT_CORRUPTED_GOTO(cur->bc_mp, i == 1, error0);
 
 		i = xfs_btree_lastrec(tcur, level);
-		XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
+		XFS_WANT_CORRUPTED_GOTO(cur->bc_mp, i == 1, error0);
 
 		/* Grab a pointer to the block. */
 		right = xfs_btree_get_block(tcur, level, &rbp);
@@ -3634,12 +3634,12 @@ xfs_btree_delrec(
 		rrecs = xfs_btree_get_numrecs(right);
 		if (!xfs_btree_ptr_is_null(cur, &lptr)) {
 			i = xfs_btree_firstrec(tcur, level);
-			XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
+			XFS_WANT_CORRUPTED_GOTO(cur->bc_mp, i == 1, error0);
 
 			error = xfs_btree_decrement(tcur, level, &i);
 			if (error)
 				goto error0;
-			XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
+			XFS_WANT_CORRUPTED_GOTO(cur->bc_mp, i == 1, error0);
 		}
 	}
 
@@ -3653,13 +3653,13 @@ xfs_btree_delrec(
 		 * previous block.
 		 */
 		i = xfs_btree_firstrec(tcur, level);
-		XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
+		XFS_WANT_CORRUPTED_GOTO(cur->bc_mp, i == 1, error0);
 
 		error = xfs_btree_decrement(tcur, level, &i);
 		if (error)
 			goto error0;
 		i = xfs_btree_firstrec(tcur, level);
-		XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
+		XFS_WANT_CORRUPTED_GOTO(cur->bc_mp, i == 1, error0);
 
 		/* Grab a pointer to the block. */
 		left = xfs_btree_get_block(tcur, level, &lbp);
diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index 116ef1d..f95c4ae 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -783,12 +783,12 @@ xfs_dialloc_ag_inobt(
 		error = xfs_inobt_lookup(cur, pagino, XFS_LOOKUP_LE, &i);
 		if (error)
 			goto error0;
-		XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
+		XFS_WANT_CORRUPTED_GOTO(mp, i == 1, error0);
 
 		error = xfs_inobt_get_rec(cur, &rec, &j);
 		if (error)
 			goto error0;
-		XFS_WANT_CORRUPTED_GOTO(j == 1, error0);
+		XFS_WANT_CORRUPTED_GOTO(mp, j == 1, error0);
 
 		if (rec.ir_freecount > 0) {
 			/*
@@ -944,19 +944,19 @@ newino:
 	error = xfs_inobt_lookup(cur, 0, XFS_LOOKUP_GE, &i);
 	if (error)
 		goto error0;
-	XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
+	XFS_WANT_CORRUPTED_GOTO(mp, i == 1, error0);
 
 	for (;;) {
 		error = xfs_inobt_get_rec(cur, &rec, &i);
 		if (error)
 			goto error0;
-		XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
+		XFS_WANT_CORRUPTED_GOTO(mp, i == 1, error0);
 		if (rec.ir_freecount > 0)
 			break;
 		error = xfs_btree_increment(cur, 0, &i);
 		if (error)
 			goto error0;
-		XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
+		XFS_WANT_CORRUPTED_GOTO(mp, i == 1, error0);
 	}
 
 alloc_inode:
@@ -1039,10 +1039,10 @@ xfs_dialloc_ag_finobt_near(
 		error = xfs_inobt_get_rec(rcur, &rrec, &j);
 		if (error)
 			goto error_rcur;
-		XFS_WANT_CORRUPTED_GOTO(j == 1, error_rcur);
+		XFS_WANT_CORRUPTED_GOTO(lcur->bc_mp, j == 1, error_rcur);
 	}
 
-	XFS_WANT_CORRUPTED_GOTO(i == 1 || j == 1, error_rcur);
+	XFS_WANT_CORRUPTED_GOTO(lcur->bc_mp, i == 1 || j == 1, error_rcur);
 	if (i == 1 && j == 1) {
 		/*
 		 * Both the left and right records are valid. Choose the closer
@@ -1475,14 +1475,14 @@ xfs_difree_inobt(
 			__func__, error);
 		goto error0;
 	}
-	XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
+	XFS_WANT_CORRUPTED_GOTO(mp, i == 1, error0);
 	error = xfs_inobt_get_rec(cur, &rec, &i);
 	if (error) {
 		xfs_warn(mp, "%s: xfs_inobt_get_rec() returned error %d.",
 			__func__, error);
 		goto error0;
 	}
-	XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
+	XFS_WANT_CORRUPTED_GOTO(mp, i == 1, error0);
 	/*
 	 * Get the offset in the inode chunk.
 	 */
@@ -1592,7 +1592,7 @@ xfs_difree_finobt(
 		 * freed an inode in a previously fully allocated chunk. If not,
 		 * something is out of sync.
 		 */
-		XFS_WANT_CORRUPTED_GOTO(ibtrec->ir_freecount == 1, error);
+		XFS_WANT_CORRUPTED_GOTO(mp, ibtrec->ir_freecount == 1, error);
 
 		error = xfs_inobt_insert_rec(cur, ibtrec->ir_freecount,
 					     ibtrec->ir_free, &i);
@@ -1613,12 +1613,12 @@ xfs_difree_finobt(
 	error = xfs_inobt_get_rec(cur, &rec, &i);
 	if (error)
 		goto error;
-	XFS_WANT_CORRUPTED_GOTO(i == 1, error);
+	XFS_WANT_CORRUPTED_GOTO(mp, i == 1, error);
 
 	rec.ir_free |= XFS_INOBT_MASK(offset);
 	rec.ir_freecount++;
 
-	XFS_WANT_CORRUPTED_GOTO((rec.ir_free == ibtrec->ir_free) &&
+	XFS_WANT_CORRUPTED_GOTO(mp, (rec.ir_free == ibtrec->ir_free) &&
 				(rec.ir_freecount == ibtrec->ir_freecount),
 				error);
 
diff --git a/fs/xfs/xfs_discard.c b/fs/xfs/xfs_discard.c
index 799e5a2..e85a951 100644
--- a/fs/xfs/xfs_discard.c
+++ b/fs/xfs/xfs_discard.c
@@ -84,7 +84,7 @@ xfs_trim_extents(
 		error = xfs_alloc_get_rec(cur, &fbno, &flen, &i);
 		if (error)
 			goto out_del_cursor;
-		XFS_WANT_CORRUPTED_GOTO(i == 1, out_del_cursor);
+		XFS_WANT_CORRUPTED_GOTO(mp, i == 1, out_del_cursor);
 		ASSERT(flen <= be32_to_cpu(XFS_BUF_TO_AGF(agbp)->agf_longest));
 
 		/*
diff --git a/fs/xfs/xfs_error.h b/fs/xfs/xfs_error.h
index 279a76e..13eeca3 100644
--- a/fs/xfs/xfs_error.h
+++ b/fs/xfs/xfs_error.h
@@ -40,13 +40,13 @@ extern void xfs_verifier_error(struct xfs_buf *bp);
 /*
  * Macros to set EFSCORRUPTED & return/branch.
  */
-#define	XFS_WANT_CORRUPTED_GOTO(x,l)	\
+#define	XFS_WANT_CORRUPTED_GOTO(mp, x, l)	\
 	{ \
 		int fs_is_ok = (x); \
 		ASSERT(fs_is_ok); \
 		if (unlikely(!fs_is_ok)) { \
 			XFS_ERROR_REPORT("XFS_WANT_CORRUPTED_GOTO", \
-					 XFS_ERRLEVEL_LOW, NULL); \
+					 XFS_ERRLEVEL_LOW, mp); \
 			error = -EFSCORRUPTED; \
 			goto l; \
 		} \


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
