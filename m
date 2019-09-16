Return-Path: <SRS0=IYS1=XL=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A57FC4CECE
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Sep 2019 12:16:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 34B6F214AF
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Sep 2019 12:16:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732341AbfIPMQh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 16 Sep 2019 08:16:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52018 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731514AbfIPMQh (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 16 Sep 2019 08:16:37 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 17693898103
        for <linux-xfs@vger.kernel.org>; Mon, 16 Sep 2019 12:16:37 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B80F65C1D6
        for <linux-xfs@vger.kernel.org>; Mon, 16 Sep 2019 12:16:36 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v4 02/11] xfs: introduce allocation cursor data structure
Date:   Mon, 16 Sep 2019 08:16:26 -0400
Message-Id: <20190916121635.43148-3-bfoster@redhat.com>
In-Reply-To: <20190916121635.43148-1-bfoster@redhat.com>
References: <20190916121635.43148-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.67]); Mon, 16 Sep 2019 12:16:37 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Introduce a new allocation cursor data structure to encapsulate the
various states and structures used to perform an extent allocation.
This structure will eventually be used to track overall allocation
state across different search algorithms on both free space btrees.

To start, include the three btree cursors (one for the cntbt and two
for the bnobt left/right search) used by the near mode allocation
algorithm and refactor the cursor setup and teardown code into
helpers. This slightly changes cursor memory allocation patterns,
but otherwise makes no functional changes to the allocation
algorithm.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_alloc.c | 318 +++++++++++++++++++-------------------
 1 file changed, 163 insertions(+), 155 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 512a45888e06..d159377ed603 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -710,8 +710,71 @@ xfs_alloc_update_counters(
 }
 
 /*
- * Allocation group level functions.
+ * Block allocation algorithm and data structures.
  */
+struct xfs_alloc_cur {
+	struct xfs_btree_cur		*cnt;	/* btree cursors */
+	struct xfs_btree_cur		*bnolt;
+	struct xfs_btree_cur		*bnogt;
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
+{
+	int			error;
+	int			i;
+
+	ASSERT(args->alignment == 1 || args->type != XFS_ALLOCTYPE_THIS_BNO);
+
+	/*
+	 * Perform an initial cntbt lookup to check for availability of maxlen
+	 * extents. If this fails, we'll return -ENOSPC to signal the caller to
+	 * attempt a small allocation.
+	 */
+	if (!acur->cnt)
+		acur->cnt = xfs_allocbt_init_cursor(args->mp, args->tp,
+					args->agbp, args->agno, XFS_BTNUM_CNT);
+	error = xfs_alloc_lookup_ge(acur->cnt, 0, args->maxlen, &i);
+	if (error)
+		return error;
+
+	/*
+	 * Allocate the bnobt left and right search cursors.
+	 */
+	if (!acur->bnolt)
+		acur->bnolt = xfs_allocbt_init_cursor(args->mp, args->tp,
+					args->agbp, args->agno, XFS_BTNUM_BNO);
+	if (!acur->bnogt)
+		acur->bnogt = xfs_allocbt_init_cursor(args->mp, args->tp,
+					args->agbp, args->agno, XFS_BTNUM_BNO);
+	return i == 1 ? 0 : -ENOSPC;
+}
+
+static void
+xfs_alloc_cur_close(
+	struct xfs_alloc_cur	*acur,
+	bool			error)
+{
+	int			cur_error = XFS_BTREE_NOERROR;
+
+	if (error)
+		cur_error = XFS_BTREE_ERROR;
+
+	if (acur->cnt)
+		xfs_btree_del_cursor(acur->cnt, cur_error);
+	if (acur->bnolt)
+		xfs_btree_del_cursor(acur->bnolt, cur_error);
+	if (acur->bnogt)
+		xfs_btree_del_cursor(acur->bnogt, cur_error);
+	acur->cnt = acur->bnolt = acur->bnogt = NULL;
+}
 
 /*
  * Deal with the case where only small freespaces remain. Either return the
@@ -1008,8 +1071,8 @@ xfs_alloc_ag_vextent_exact(
 STATIC int
 xfs_alloc_find_best_extent(
 	struct xfs_alloc_arg	*args,	/* allocation argument structure */
-	struct xfs_btree_cur	**gcur,	/* good cursor */
-	struct xfs_btree_cur	**scur,	/* searching cursor */
+	struct xfs_btree_cur	*gcur,	/* good cursor */
+	struct xfs_btree_cur	*scur,	/* searching cursor */
 	xfs_agblock_t		gdiff,	/* difference for search comparison */
 	xfs_agblock_t		*sbno,	/* extent found by search */
 	xfs_extlen_t		*slen,	/* extent length */
@@ -1031,7 +1094,7 @@ xfs_alloc_find_best_extent(
 	 * Look until we find a better one, run out of space or run off the end.
 	 */
 	do {
-		error = xfs_alloc_get_rec(*scur, sbno, slen, &i);
+		error = xfs_alloc_get_rec(scur, sbno, slen, &i);
 		if (error)
 			goto error0;
 		XFS_WANT_CORRUPTED_GOTO(args->mp, i == 1, error0);
@@ -1074,21 +1137,19 @@ xfs_alloc_find_best_extent(
 		}
 
 		if (!dir)
-			error = xfs_btree_increment(*scur, 0, &i);
+			error = xfs_btree_increment(scur, 0, &i);
 		else
-			error = xfs_btree_decrement(*scur, 0, &i);
+			error = xfs_btree_decrement(scur, 0, &i);
 		if (error)
 			goto error0;
 	} while (i);
 
 out_use_good:
-	xfs_btree_del_cursor(*scur, XFS_BTREE_NOERROR);
-	*scur = NULL;
+	scur->bc_private.a.priv.abt.active = false;
 	return 0;
 
 out_use_search:
-	xfs_btree_del_cursor(*gcur, XFS_BTREE_NOERROR);
-	*gcur = NULL;
+	gcur->bc_private.a.priv.abt.active = false;
 	return 0;
 
 error0:
@@ -1102,13 +1163,12 @@ xfs_alloc_find_best_extent(
  * and of the form k * prod + mod unless there's nothing that large.
  * Return the starting a.g. block, or NULLAGBLOCK if we can't do it.
  */
-STATIC int				/* error */
+STATIC int
 xfs_alloc_ag_vextent_near(
-	xfs_alloc_arg_t	*args)		/* allocation argument structure */
+	struct xfs_alloc_arg	*args)
 {
-	xfs_btree_cur_t	*bno_cur_gt;	/* cursor for bno btree, right side */
-	xfs_btree_cur_t	*bno_cur_lt;	/* cursor for bno btree, left side */
-	xfs_btree_cur_t	*cnt_cur;	/* cursor for count btree */
+	struct xfs_alloc_cur	acur = {0,};
+	struct xfs_btree_cur	*bno_cur;
 	xfs_agblock_t	gtbno;		/* start bno of right side entry */
 	xfs_agblock_t	gtbnoa;		/* aligned ... */
 	xfs_extlen_t	gtdiff;		/* difference to right side entry */
@@ -1148,38 +1208,29 @@ xfs_alloc_ag_vextent_near(
 		args->agbno = args->max_agbno;
 
 restart:
-	bno_cur_lt = NULL;
-	bno_cur_gt = NULL;
 	ltlen = 0;
 	gtlena = 0;
 	ltlena = 0;
 	busy = false;
 
 	/*
-	 * Get a cursor for the by-size btree.
+	 * Set up cursors and see if there are any free extents as big as
+	 * maxlen. If not, pick the last entry in the tree unless the tree is
+	 * empty.
 	 */
-	cnt_cur = xfs_allocbt_init_cursor(args->mp, args->tp, args->agbp,
-		args->agno, XFS_BTNUM_CNT);
-
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
+	error = xfs_alloc_cur_setup(args, &acur);
+	if (error == -ENOSPC) {
+		error = xfs_alloc_ag_vextent_small(args, acur.cnt, &ltbno,
+				&ltlen, &i);
+		if (error)
+			goto out;
 		if (i == 0 || ltlen == 0) {
-			xfs_btree_del_cursor(cnt_cur, XFS_BTREE_NOERROR);
 			trace_xfs_alloc_near_noentry(args);
-			return 0;
+			goto out;
 		}
 		ASSERT(i == 1);
+	} else if (error) {
+		goto out;
 	}
 	args->wasfromfl = 0;
 
@@ -1193,7 +1244,7 @@ xfs_alloc_ag_vextent_near(
 	 * This is written as a while loop so we can break out of it,
 	 * but we never loop back to the top.
 	 */
-	while (xfs_btree_islastblock(cnt_cur, 0)) {
+	while (xfs_btree_islastblock(acur.cnt, 0)) {
 		xfs_extlen_t	bdiff;
 		int		besti=0;
 		xfs_extlen_t	blen=0;
@@ -1210,32 +1261,35 @@ xfs_alloc_ag_vextent_near(
 		 * and skip all those smaller than minlen.
 		 */
 		if (ltlen || args->alignment > 1) {
-			cnt_cur->bc_ptrs[0] = 1;
+			acur.cnt->bc_ptrs[0] = 1;
 			do {
-				if ((error = xfs_alloc_get_rec(cnt_cur, &ltbno,
-						&ltlen, &i)))
-					goto error0;
-				XFS_WANT_CORRUPTED_GOTO(args->mp, i == 1, error0);
+				error = xfs_alloc_get_rec(acur.cnt, &ltbno,
+						&ltlen, &i);
+				if (error)
+					goto out;
+				XFS_WANT_CORRUPTED_GOTO(args->mp, i == 1, out);
 				if (ltlen >= args->minlen)
 					break;
-				if ((error = xfs_btree_increment(cnt_cur, 0, &i)))
-					goto error0;
+				error = xfs_btree_increment(acur.cnt, 0, &i);
+				if (error)
+					goto out;
 			} while (i);
 			ASSERT(ltlen >= args->minlen);
 			if (!i)
 				break;
 		}
-		i = cnt_cur->bc_ptrs[0];
+		i = acur.cnt->bc_ptrs[0];
 		for (j = 1, blen = 0, bdiff = 0;
 		     !error && j && (blen < args->maxlen || bdiff > 0);
-		     error = xfs_btree_increment(cnt_cur, 0, &j)) {
+		     error = xfs_btree_increment(acur.cnt, 0, &j)) {
 			/*
 			 * For each entry, decide if it's better than
 			 * the previous best entry.
 			 */
-			if ((error = xfs_alloc_get_rec(cnt_cur, &ltbno, &ltlen, &i)))
-				goto error0;
-			XFS_WANT_CORRUPTED_GOTO(args->mp, i == 1, error0);
+			error = xfs_alloc_get_rec(acur.cnt, &ltbno, &ltlen, &i);
+			if (error)
+				goto out;
+			XFS_WANT_CORRUPTED_GOTO(args->mp, i == 1, out);
 			busy = xfs_alloc_compute_aligned(args, ltbno, ltlen,
 					&ltbnoa, &ltlena, &busy_gen);
 			if (ltlena < args->minlen)
@@ -1255,7 +1309,7 @@ xfs_alloc_ag_vextent_near(
 				bdiff = ltdiff;
 				bnew = ltnew;
 				blen = args->len;
-				besti = cnt_cur->bc_ptrs[0];
+				besti = acur.cnt->bc_ptrs[0];
 			}
 		}
 		/*
@@ -1267,10 +1321,11 @@ xfs_alloc_ag_vextent_near(
 		/*
 		 * Point at the best entry, and retrieve it again.
 		 */
-		cnt_cur->bc_ptrs[0] = besti;
-		if ((error = xfs_alloc_get_rec(cnt_cur, &ltbno, &ltlen, &i)))
-			goto error0;
-		XFS_WANT_CORRUPTED_GOTO(args->mp, i == 1, error0);
+		acur.cnt->bc_ptrs[0] = besti;
+		error = xfs_alloc_get_rec(acur.cnt, &ltbno, &ltlen, &i);
+		if (error)
+			goto out;
+		XFS_WANT_CORRUPTED_GOTO(args->mp, i == 1, out);
 		ASSERT(ltbno + ltlen <= be32_to_cpu(XFS_BUF_TO_AGF(args->agbp)->agf_length));
 		args->len = blen;
 
@@ -1280,23 +1335,14 @@ xfs_alloc_ag_vextent_near(
 		args->agbno = bnew;
 		ASSERT(bnew >= ltbno);
 		ASSERT(bnew + blen <= ltbno + ltlen);
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
-
+		error = xfs_alloc_fixup_trees(acur.cnt, acur.bnolt, ltbno,
+					ltlen, bnew, blen, XFSA_FIXUP_CNT_OK);
+		if (error)
+			goto out;
 		trace_xfs_alloc_near_first(args);
-		return 0;
+		goto out;
 	}
+
 	/*
 	 * Second algorithm.
 	 * Search in the by-bno tree to the left and to the right
@@ -1309,86 +1355,57 @@ xfs_alloc_ag_vextent_near(
 	 * level algorithm that picks allocation groups for allocations
 	 * is not supposed to do this.
 	 */
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
+	error = xfs_alloc_lookup_le(acur.bnolt, args->agbno, 0, &i);
+	if (error)
+		goto out;
+	error = xfs_alloc_lookup_ge(acur.bnogt, args->agbno, 0, &i);
+	if (error)
+		goto out;
+
 	/*
 	 * Loop going left with the leftward cursor, right with the
 	 * rightward cursor, until either both directions give up or
 	 * we find an entry at least as big as minlen.
 	 */
 	do {
-		if (bno_cur_lt) {
-			if ((error = xfs_alloc_get_rec(bno_cur_lt, &ltbno, &ltlen, &i)))
-				goto error0;
-			XFS_WANT_CORRUPTED_GOTO(args->mp, i == 1, error0);
+		if (xfs_alloc_cur_active(acur.bnolt)) {
+			error = xfs_alloc_get_rec(acur.bnolt, &ltbno, &ltlen, &i);
+			if (error)
+				goto out;
+			XFS_WANT_CORRUPTED_GOTO(args->mp, i == 1, out);
 			busy |= xfs_alloc_compute_aligned(args, ltbno, ltlen,
 					&ltbnoa, &ltlena, &busy_gen);
 			if (ltlena >= args->minlen && ltbnoa >= args->min_agbno)
 				break;
-			if ((error = xfs_btree_decrement(bno_cur_lt, 0, &i)))
-				goto error0;
-			if (!i || ltbnoa < args->min_agbno) {
-				xfs_btree_del_cursor(bno_cur_lt,
-						     XFS_BTREE_NOERROR);
-				bno_cur_lt = NULL;
-			}
+			error = xfs_btree_decrement(acur.bnolt, 0, &i);
+			if (error)
+				goto out;
+			if (!i || ltbnoa < args->min_agbno)
+				acur.bnolt->bc_private.a.priv.abt.active = false;
 		}
-		if (bno_cur_gt) {
-			if ((error = xfs_alloc_get_rec(bno_cur_gt, &gtbno, &gtlen, &i)))
-				goto error0;
-			XFS_WANT_CORRUPTED_GOTO(args->mp, i == 1, error0);
+		if (xfs_alloc_cur_active(acur.bnogt)) {
+			error = xfs_alloc_get_rec(acur.bnogt, &gtbno, &gtlen, &i);
+			if (error)
+				goto out;
+			XFS_WANT_CORRUPTED_GOTO(args->mp, i == 1, out);
 			busy |= xfs_alloc_compute_aligned(args, gtbno, gtlen,
 					&gtbnoa, &gtlena, &busy_gen);
 			if (gtlena >= args->minlen && gtbnoa <= args->max_agbno)
 				break;
-			if ((error = xfs_btree_increment(bno_cur_gt, 0, &i)))
-				goto error0;
-			if (!i || gtbnoa > args->max_agbno) {
-				xfs_btree_del_cursor(bno_cur_gt,
-						     XFS_BTREE_NOERROR);
-				bno_cur_gt = NULL;
-			}
+			error = xfs_btree_increment(acur.bnogt, 0, &i);
+			if (error)
+				goto out;
+			if (!i || gtbnoa > args->max_agbno)
+				acur.bnogt->bc_private.a.priv.abt.active = false;
 		}
-	} while (bno_cur_lt || bno_cur_gt);
+	} while (xfs_alloc_cur_active(acur.bnolt) ||
+		 xfs_alloc_cur_active(acur.bnogt));
 
 	/*
 	 * Got both cursors still active, need to find better entry.
 	 */
-	if (bno_cur_lt && bno_cur_gt) {
+	if (xfs_alloc_cur_active(acur.bnolt) &&
+	    xfs_alloc_cur_active(acur.bnogt)) {
 		if (ltlena >= args->minlen) {
 			/*
 			 * Left side is good, look for a right side entry.
@@ -1400,7 +1417,7 @@ xfs_alloc_ag_vextent_near(
 				ltlena, &ltnew);
 
 			error = xfs_alloc_find_best_extent(args,
-						&bno_cur_lt, &bno_cur_gt,
+						acur.bnolt, acur.bnogt,
 						ltdiff, &gtbno, &gtlen,
 						&gtbnoa, &gtlena,
 						0 /* search right */);
@@ -1417,22 +1434,21 @@ xfs_alloc_ag_vextent_near(
 				gtlena, &gtnew);
 
 			error = xfs_alloc_find_best_extent(args,
-						&bno_cur_gt, &bno_cur_lt,
+						acur.bnogt, acur.bnolt,
 						gtdiff, &ltbno, &ltlen,
 						&ltbnoa, &ltlena,
 						1 /* search left */);
 		}
 
 		if (error)
-			goto error0;
+			goto out;
 	}
 
 	/*
 	 * If we couldn't get anything, give up.
 	 */
-	if (bno_cur_lt == NULL && bno_cur_gt == NULL) {
-		xfs_btree_del_cursor(cnt_cur, XFS_BTREE_NOERROR);
-
+	if (!xfs_alloc_cur_active(acur.bnolt) &&
+	    !xfs_alloc_cur_active(acur.bnogt)) {
 		if (busy) {
 			trace_xfs_alloc_near_busy(args);
 			xfs_extent_busy_flush(args->mp, args->pag, busy_gen);
@@ -1440,7 +1456,7 @@ xfs_alloc_ag_vextent_near(
 		}
 		trace_xfs_alloc_size_neither(args);
 		args->agbno = NULLAGBLOCK;
-		return 0;
+		goto out;
 	}
 
 	/*
@@ -1449,16 +1465,17 @@ xfs_alloc_ag_vextent_near(
 	 * useful variables to the "left" set so we only have one
 	 * copy of this code.
 	 */
-	if (bno_cur_gt) {
-		bno_cur_lt = bno_cur_gt;
-		bno_cur_gt = NULL;
+	if (xfs_alloc_cur_active(acur.bnogt)) {
+		bno_cur = acur.bnogt;
 		ltbno = gtbno;
 		ltbnoa = gtbnoa;
 		ltlen = gtlen;
 		ltlena = gtlena;
 		j = 1;
-	} else
+	} else {
+		bno_cur = acur.bnolt;
 		j = 0;
+	}
 
 	/*
 	 * Fix up the length and compute the useful address.
@@ -1474,27 +1491,18 @@ xfs_alloc_ag_vextent_near(
 	ASSERT(ltnew >= args->min_agbno && ltnew <= args->max_agbno);
 	args->agbno = ltnew;
 
-	if ((error = xfs_alloc_fixup_trees(cnt_cur, bno_cur_lt, ltbno, ltlen,
-			ltnew, rlen, XFSA_FIXUP_BNO_OK)))
-		goto error0;
+	error = xfs_alloc_fixup_trees(acur.cnt, bno_cur, ltbno, ltlen, ltnew,
+				      rlen, XFSA_FIXUP_BNO_OK);
+	if (error)
+		goto out;
 
 	if (j)
 		trace_xfs_alloc_near_greater(args);
 	else
 		trace_xfs_alloc_near_lesser(args);
 
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
+	xfs_alloc_cur_close(&acur, error);
 	return error;
 }
 
-- 
2.20.1

