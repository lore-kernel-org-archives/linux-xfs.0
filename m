Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36764 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731336AbeLNMey (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 14 Dec 2018 07:34:54 -0500
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id D5CF430C7020
        for <linux-xfs@vger.kernel.org>; Fri, 14 Dec 2018 12:34:53 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7B20A261A6
        for <linux-xfs@vger.kernel.org>; Fri, 14 Dec 2018 12:34:53 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH RFC 2/5] xfs: factor out cntbt based near allocation algorithm
Date: Fri, 14 Dec 2018 07:34:49 -0500
Message-Id: <20181214123452.20974-3-bfoster@redhat.com>
In-Reply-To: <20181214123452.20974-1-bfoster@redhat.com>
References: <20181214123452.20974-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_alloc.c | 224 +++++++++++++++++++++-----------------
 1 file changed, 127 insertions(+), 97 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 76affbcbd5ff..a7e3daa16717 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -980,6 +980,119 @@ xfs_alloc_find_best_extent(
 	return error;
 }
 
+/*
+ * First NEAR algorithm. If the requested extent is large wrt the freespace
+ * available in this AG, then the cursor will point to a btree entry near the
+ * right edge of the tree. If it's in the last btree leaf block, then we just
+ * examine all the entries in that block that are big enough and pick the best
+ * one.
+ */
+STATIC int
+xfs_alloc_ag_vextent_near_cntbt(
+	struct xfs_alloc_arg	*args,
+	struct xfs_btree_cur	*cnt_cur,
+	bool			*busy,
+	unsigned		*busy_gen,
+	int			*done)
+{
+	struct xfs_btree_cur	*bno_cur = NULL;
+	xfs_agblock_t		bno;
+	xfs_extlen_t		len;
+	xfs_agblock_t		bnoa;
+	xfs_extlen_t		lena;
+	xfs_extlen_t		diff;
+	xfs_agblock_t		new;
+	xfs_extlen_t		bdiff;
+	int			besti = 0;
+	xfs_extlen_t		blen;
+	xfs_agblock_t		bnew = 0;
+	int			i, j;
+	int			error = 0;
+
+	*done = 0;
+
+	/*
+	 * Inspect each record to the end of the tree and keep track of the one
+	 * with the best locality. Note that the caller points cnt_cur to the
+	 * last block in the tree before we get here.
+	 */
+	for (j = 1, blen = 0, bdiff = 0;
+	     !error && j && (blen < args->maxlen || bdiff > 0);
+	     error = xfs_btree_increment(cnt_cur, 0, &j)) {
+		error = xfs_alloc_get_rec(cnt_cur, &bno, &len, &i);
+		if (error)
+			goto error;
+		XFS_WANT_CORRUPTED_GOTO(args->mp, i == 1, error);
+
+		*busy = xfs_alloc_compute_aligned(args, bno, len, &bnoa, &lena,
+						  busy_gen);
+		if (lena < args->minlen)
+			continue;
+		if (bnoa < args->min_agbno || bnoa > args->max_agbno)
+			continue;
+		args->len = XFS_EXTLEN_MIN(lena, args->maxlen);
+		xfs_alloc_fix_len(args);
+		ASSERT(args->len >= args->minlen);
+		if (args->len < blen)
+			continue;
+
+		diff = xfs_alloc_compute_diff(args->agbno, args->len,
+					      args->alignment, args->datatype,
+					      bnoa, lena, &new);
+		if (new != NULLAGBLOCK && (args->len > blen || diff < bdiff)) {
+			bdiff = diff;
+			bnew = new;
+			blen = args->len;
+			besti = cnt_cur->bc_ptrs[0];
+		}
+	}
+
+	/*
+	 * If we didn't find a suitable record, return and the let the caller
+	 * try another algorithm.
+	 */
+	if (blen == 0)
+		return 0;
+
+	/*
+	 * We found a suitable record. Point the cntbt back at the record,
+	 * retrieve it and fix up args with the final allocation.
+	 */
+	cnt_cur->bc_ptrs[0] = besti;
+	error = xfs_alloc_get_rec(cnt_cur, &bno, &len, &i);
+	if (error)
+		goto error;
+	XFS_WANT_CORRUPTED_GOTO(args->mp, i == 1, error);
+	ASSERT(bno + len <=
+	       be32_to_cpu(XFS_BUF_TO_AGF(args->agbp)->agf_length));
+	ASSERT(bnew >= bno);
+	ASSERT(bnew + blen <= bno + len);
+
+	args->agbno = bnew;
+	args->len = blen;
+
+	/*
+	 * Set up a bnobt cursor and fix up both trees with the allocation. Note
+	 * that the caller owns cnt_cur so we don't close it here.
+	 */
+	bno_cur = xfs_allocbt_init_cursor(args->mp, args->tp, args->agbp,
+					  args->agno, XFS_BTNUM_BNO);
+	error = xfs_alloc_fixup_trees(cnt_cur, bno_cur, bno, len, bnew, blen,
+				      XFSA_FIXUP_CNT_OK);
+	if (error)
+		goto error;
+	xfs_btree_del_cursor(bno_cur, XFS_BTREE_NOERROR);
+
+	*done = 1;
+	trace_xfs_alloc_near_first(args);
+	return 0;
+
+error:
+	if (bno_cur)
+		xfs_btree_del_cursor(bno_cur, XFS_BTREE_ERROR);
+	return error;
+}
+
 /*
  * Second NEAR allocation algorithm. Search in the by-bno tree to the left and
  * to the right simultaneously until in each case we find a space big enough or
@@ -1216,13 +1329,8 @@ xfs_alloc_ag_vextent_near(
 	xfs_btree_cur_t	*cnt_cur;	/* cursor for count btree */
 	int		error;		/* error code */
 	int		i;		/* result code, temporary */
-	int		j;		/* result code, temporary */
 	xfs_agblock_t	ltbno;		/* start bno of left side entry */
-	xfs_agblock_t	ltbnoa;		/* aligned ... */
-	xfs_extlen_t	ltdiff;		/* difference to left side entry */
 	xfs_extlen_t	ltlen;		/* length of left side entry */
-	xfs_extlen_t	ltlena;		/* aligned ... */
-	xfs_agblock_t	ltnew;		/* useful start bno of left side */
 	bool		busy;
 	unsigned	busy_gen;
 #ifdef DEBUG
@@ -1247,7 +1355,6 @@ xfs_alloc_ag_vextent_near(
 
 restart:
 	ltlen = 0;
-	ltlena = 0;
 	busy = false;
 
 	/*
@@ -1280,25 +1387,10 @@ xfs_alloc_ag_vextent_near(
 	}
 	args->wasfromfl = 0;
 
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
+	if (xfs_btree_islastblock(cnt_cur, 0)) {
 #ifdef DEBUG
 		if (dofirst)
-			break;
+			goto near_bnobt;
 #endif
 		/*
 		 * Start from the entry that lookup found, sequence through
@@ -1313,92 +1405,30 @@ xfs_alloc_ag_vextent_near(
 						&ltlen, &i);
 				if (error)
 					goto error;
-				XFS_WANT_CORRUPTED_GOTO(args->mp, i == 1, error);
+				XFS_WANT_CORRUPTED_GOTO(args->mp, i == 1,
+							error);
 				if (ltlen >= args->minlen)
 					break;
-				if ((error = xfs_btree_increment(cnt_cur, 0, &i)))
+				error = xfs_btree_increment(cnt_cur, 0, &i);
+				if (error)
 					goto error;
 			} while (i);
 			ASSERT(ltlen >= args->minlen);
 			if (!i)
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
-			error = xfs_alloc_get_rec(cnt_cur, &ltbno, &ltlen, &i);
-			if (error)
-				goto error;
-			XFS_WANT_CORRUPTED_GOTO(args->mp, i == 1, error);
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
+				goto near_bnobt;
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
-		error = xfs_alloc_get_rec(cnt_cur, &ltbno, &ltlen, &i);
-		if (error)
-			goto error;
-		XFS_WANT_CORRUPTED_GOTO(args->mp, i == 1, error);
-		ASSERT(ltbno + ltlen <= be32_to_cpu(XFS_BUF_TO_AGF(args->agbp)->agf_length));
-		args->len = blen;
 
-		/*
-		 * We are allocating starting at bnew for blen blocks.
-		 */
-		args->agbno = bnew;
-		ASSERT(bnew >= ltbno);
-		ASSERT(bnew + blen <= ltbno + ltlen);
-		/*
-		 * Set up a cursor for the by-bno tree.
-		 */
-		bno_cur = xfs_allocbt_init_cursor(args->mp, args->tp,
-			args->agbp, args->agno, XFS_BTNUM_BNO);
-		/*
-		 * Fix up the btree entries.
-		 */
-		error = xfs_alloc_fixup_trees(cnt_cur, bno_cur, ltbno,
-				ltlen, bnew, blen, XFSA_FIXUP_CNT_OK);
+		error = xfs_alloc_ag_vextent_near_cntbt(args, cnt_cur, &busy,
+							&busy_gen, &i);
 		if (error)
 			goto error;
-		xfs_btree_del_cursor(cnt_cur, XFS_BTREE_NOERROR);
-		xfs_btree_del_cursor(bno_cur, XFS_BTREE_NOERROR);
-
-		trace_xfs_alloc_near_first(args);
-		return 0;
+		if (i) {
+			xfs_btree_del_cursor(cnt_cur, XFS_BTREE_NOERROR);
+			return 0;
+		}
 	}
 
+near_bnobt:
 	/*
 	 * Execute the fallback bnobt-based algorithm. This returns -EAGAIN if
 	 * the allocation failed due to busy extents. In that case, flush all
-- 
2.17.2
