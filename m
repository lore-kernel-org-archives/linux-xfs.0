Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:54495 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752244AbdIVN7y (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 22 Sep 2017 09:59:54 -0400
Received: from ip-64-134-232-11.public.wayport.net ([64.134.232.11] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1dvOUj-0001Ca-Um
        for linux-xfs@vger.kernel.org; Fri, 22 Sep 2017 13:59:54 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 16/19] xfs: pass a struct xfs_bmbt_irec to xfs_bmbt_lookup_eq
Date: Fri, 22 Sep 2017 06:59:42 -0700
Message-Id: <20170922135945.31574-17-hch@lst.de>
In-Reply-To: <20170922135945.31574-1-hch@lst.de>
References: <20170922135945.31574-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Now that we've massaged the callers into the right form we can always
pass the actual extent record instead of the individual fields.

As an additional benefit the btree cursor will now be prepoulated with
the correct extent state instead of having to fix it up later.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_bmap.c | 145 +++++++++++++----------------------------------
 1 file changed, 39 insertions(+), 106 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 23bea9ed9191..41da4b63130f 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -113,14 +113,10 @@ xfs_bmap_compute_maxlevels(
 STATIC int				/* error */
 xfs_bmbt_lookup_eq(
 	struct xfs_btree_cur	*cur,
-	xfs_fileoff_t		off,
-	xfs_fsblock_t		bno,
-	xfs_filblks_t		len,
+	struct xfs_bmbt_irec	*irec,
 	int			*stat)	/* success/failure */
 {
-	cur->bc_rec.b.br_startoff = off;
-	cur->bc_rec.b.br_startblock = bno;
-	cur->bc_rec.b.br_blockcount = len;
+	cur->bc_rec.b = *irec;
 	return xfs_btree_lookup(cur, XFS_LOOKUP_EQ, stat);
 }
 
@@ -1710,9 +1706,7 @@ xfs_bmap_add_extent_delay_real(
 			rval = XFS_ILOG_CORE | XFS_ILOG_DEXT;
 		else {
 			rval = XFS_ILOG_CORE;
-			error = xfs_bmbt_lookup_eq(bma->cur, RIGHT.br_startoff,
-					RIGHT.br_startblock,
-					RIGHT.br_blockcount, &i);
+			error = xfs_bmbt_lookup_eq(bma->cur, &RIGHT, &i);
 			if (error)
 				goto done;
 			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
@@ -1748,9 +1742,7 @@ xfs_bmap_add_extent_delay_real(
 			rval = XFS_ILOG_DEXT;
 		else {
 			rval = 0;
-			error = xfs_bmbt_lookup_eq(bma->cur, old.br_startoff,
-					old.br_startblock, old.br_blockcount,
-					&i);
+			error = xfs_bmbt_lookup_eq(bma->cur, &old, &i);
 			if (error)
 				goto done;
 			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
@@ -1776,9 +1768,7 @@ xfs_bmap_add_extent_delay_real(
 			rval = XFS_ILOG_DEXT;
 		else {
 			rval = 0;
-			error = xfs_bmbt_lookup_eq(bma->cur, RIGHT.br_startoff,
-					RIGHT.br_startblock,
-					RIGHT.br_blockcount, &i);
+			error = xfs_bmbt_lookup_eq(bma->cur, &RIGHT, &i);
 			if (error)
 				goto done;
 			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
@@ -1805,13 +1795,10 @@ xfs_bmap_add_extent_delay_real(
 			rval = XFS_ILOG_CORE | XFS_ILOG_DEXT;
 		else {
 			rval = XFS_ILOG_CORE;
-			error = xfs_bmbt_lookup_eq(bma->cur, new->br_startoff,
-					new->br_startblock, new->br_blockcount,
-					&i);
+			error = xfs_bmbt_lookup_eq(bma->cur, new, &i);
 			if (error)
 				goto done;
 			XFS_WANT_CORRUPTED_GOTO(mp, i == 0, done);
-			bma->cur->bc_rec.b.br_state = XFS_EXT_NORM;
 			error = xfs_btree_insert(bma->cur, &i);
 			if (error)
 				goto done;
@@ -1845,9 +1832,7 @@ xfs_bmap_add_extent_delay_real(
 			rval = XFS_ILOG_DEXT;
 		else {
 			rval = 0;
-			error = xfs_bmbt_lookup_eq(bma->cur, old.br_startoff,
-					old.br_startblock, old.br_blockcount,
-					&i);
+			error = xfs_bmbt_lookup_eq(bma->cur, &old, &i);
 			if (error)
 				goto done;
 			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
@@ -1870,13 +1855,10 @@ xfs_bmap_add_extent_delay_real(
 			rval = XFS_ILOG_CORE | XFS_ILOG_DEXT;
 		else {
 			rval = XFS_ILOG_CORE;
-			error = xfs_bmbt_lookup_eq(bma->cur, new->br_startoff,
-					new->br_startblock, new->br_blockcount,
-					&i);
+			error = xfs_bmbt_lookup_eq(bma->cur, new, &i);
 			if (error)
 				goto done;
 			XFS_WANT_CORRUPTED_GOTO(mp, i == 0, done);
-			bma->cur->bc_rec.b.br_state = XFS_EXT_NORM;
 			error = xfs_btree_insert(bma->cur, &i);
 			if (error)
 				goto done;
@@ -1923,9 +1905,7 @@ xfs_bmap_add_extent_delay_real(
 			rval = XFS_ILOG_DEXT;
 		else {
 			rval = 0;
-			error = xfs_bmbt_lookup_eq(bma->cur, old.br_startoff,
-					old.br_startblock,
-					old.br_blockcount, &i);
+			error = xfs_bmbt_lookup_eq(bma->cur, &old, &i);
 			if (error)
 				goto done;
 			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
@@ -1958,13 +1938,10 @@ xfs_bmap_add_extent_delay_real(
 			rval = XFS_ILOG_CORE | XFS_ILOG_DEXT;
 		else {
 			rval = XFS_ILOG_CORE;
-			error = xfs_bmbt_lookup_eq(bma->cur, new->br_startoff,
-					new->br_startblock, new->br_blockcount,
-					&i);
+			error = xfs_bmbt_lookup_eq(bma->cur, new, &i);
 			if (error)
 				goto done;
 			XFS_WANT_CORRUPTED_GOTO(mp, i == 0, done);
-			bma->cur->bc_rec.b.br_state = XFS_EXT_NORM;
 			error = xfs_btree_insert(bma->cur, &i);
 			if (error)
 				goto done;
@@ -2046,13 +2023,10 @@ xfs_bmap_add_extent_delay_real(
 			rval = XFS_ILOG_CORE | XFS_ILOG_DEXT;
 		else {
 			rval = XFS_ILOG_CORE;
-			error = xfs_bmbt_lookup_eq(bma->cur, new->br_startoff,
-					new->br_startblock, new->br_blockcount,
-					&i);
+			error = xfs_bmbt_lookup_eq(bma->cur, new, &i);
 			if (error)
 				goto done;
 			XFS_WANT_CORRUPTED_GOTO(mp, i == 0, done);
-			bma->cur->bc_rec.b.br_state = XFS_EXT_NORM;
 			error = xfs_btree_insert(bma->cur, &i);
 			if (error)
 				goto done;
@@ -2258,9 +2232,8 @@ xfs_bmap_add_extent_unwritten_real(
 			rval = XFS_ILOG_CORE | XFS_ILOG_DEXT;
 		else {
 			rval = XFS_ILOG_CORE;
-			if ((error = xfs_bmbt_lookup_eq(cur, RIGHT.br_startoff,
-					RIGHT.br_startblock,
-					RIGHT.br_blockcount, &i)))
+			error = xfs_bmbt_lookup_eq(cur, &RIGHT, &i);
+			if (error)
 				goto done;
 			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
 			if ((error = xfs_btree_delete(cur, &i)))
@@ -2300,9 +2273,8 @@ xfs_bmap_add_extent_unwritten_real(
 			rval = XFS_ILOG_CORE | XFS_ILOG_DEXT;
 		else {
 			rval = XFS_ILOG_CORE;
-			if ((error = xfs_bmbt_lookup_eq(cur, PREV.br_startoff,
-					PREV.br_startblock, PREV.br_blockcount,
-					&i)))
+			error = xfs_bmbt_lookup_eq(cur, &PREV, &i);
+			if (error)
 				goto done;
 			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
 			if ((error = xfs_btree_delete(cur, &i)))
@@ -2335,9 +2307,8 @@ xfs_bmap_add_extent_unwritten_real(
 			rval = XFS_ILOG_CORE | XFS_ILOG_DEXT;
 		else {
 			rval = XFS_ILOG_CORE;
-			if ((error = xfs_bmbt_lookup_eq(cur, RIGHT.br_startoff,
-					RIGHT.br_startblock,
-					RIGHT.br_blockcount, &i)))
+			error = xfs_bmbt_lookup_eq(cur, &RIGHT, &i);
+			if (error)
 				goto done;
 			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
 			if ((error = xfs_btree_delete(cur, &i)))
@@ -2367,9 +2338,8 @@ xfs_bmap_add_extent_unwritten_real(
 			rval = XFS_ILOG_DEXT;
 		else {
 			rval = 0;
-			if ((error = xfs_bmbt_lookup_eq(cur, new->br_startoff,
-					new->br_startblock, new->br_blockcount,
-					&i)))
+			error = xfs_bmbt_lookup_eq(cur, new, &i);
+			if (error)
 				goto done;
 			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
 			error = xfs_bmbt_update(cur, &PREV);
@@ -2402,9 +2372,7 @@ xfs_bmap_add_extent_unwritten_real(
 			rval = XFS_ILOG_DEXT;
 		else {
 			rval = 0;
-			error = xfs_bmbt_lookup_eq(cur, old.br_startoff,
-					old.br_startblock, old.br_blockcount,
-					&i);
+			error = xfs_bmbt_lookup_eq(cur, &old, &i);
 			if (error)
 				goto done;
 			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
@@ -2440,9 +2408,7 @@ xfs_bmap_add_extent_unwritten_real(
 			rval = XFS_ILOG_CORE | XFS_ILOG_DEXT;
 		else {
 			rval = XFS_ILOG_CORE;
-			error = xfs_bmbt_lookup_eq(cur, old.br_startoff,
-					old.br_startblock, old.br_blockcount,
-					&i);
+			error = xfs_bmbt_lookup_eq(cur, &old, &i);
 			if (error)
 				goto done;
 			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
@@ -2480,9 +2446,7 @@ xfs_bmap_add_extent_unwritten_real(
 			rval = XFS_ILOG_DEXT;
 		else {
 			rval = 0;
-			error = xfs_bmbt_lookup_eq(cur, old.br_startoff,
-					old.br_startblock, old.br_blockcount,
-					&i);
+			error = xfs_bmbt_lookup_eq(cur, &old, &i);
 			if (error)
 				goto done;
 			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
@@ -2518,21 +2482,17 @@ xfs_bmap_add_extent_unwritten_real(
 			rval = XFS_ILOG_CORE | XFS_ILOG_DEXT;
 		else {
 			rval = XFS_ILOG_CORE;
-			error = xfs_bmbt_lookup_eq(cur, old.br_startoff,
-					old.br_startblock, old.br_blockcount,
-					&i);
+			error = xfs_bmbt_lookup_eq(cur, &old, &i);
 			if (error)
 				goto done;
 			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
 			error = xfs_bmbt_update(cur, &PREV);
 			if (error)
 				goto done;
-			if ((error = xfs_bmbt_lookup_eq(cur, new->br_startoff,
-					new->br_startblock, new->br_blockcount,
-					&i)))
+			error = xfs_bmbt_lookup_eq(cur, new, &i);
+			if (error)
 				goto done;
 			XFS_WANT_CORRUPTED_GOTO(mp, i == 0, done);
-			cur->bc_rec.b.br_state = new->br_state;
 			if ((error = xfs_btree_insert(cur, &i)))
 				goto done;
 			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
@@ -2567,9 +2527,7 @@ xfs_bmap_add_extent_unwritten_real(
 			rval = XFS_ILOG_CORE | XFS_ILOG_DEXT;
 		else {
 			rval = XFS_ILOG_CORE;
-			error = xfs_bmbt_lookup_eq(cur, old.br_startoff,
-					old.br_startblock, old.br_blockcount,
-					&i);
+			error = xfs_bmbt_lookup_eq(cur, &old, &i);
 			if (error)
 				goto done;
 			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
@@ -2587,13 +2545,11 @@ xfs_bmap_add_extent_unwritten_real(
 			 * we are about to insert as we can't trust it after
 			 * the previous insert.
 			 */
-			if ((error = xfs_bmbt_lookup_eq(cur, new->br_startoff,
-					new->br_startblock, new->br_blockcount,
-					&i)))
+			error = xfs_bmbt_lookup_eq(cur, new, &i);
+			if (error)
 				goto done;
 			XFS_WANT_CORRUPTED_GOTO(mp, i == 0, done);
 			/* new middle extent - newext */
-			cur->bc_rec.b.br_state = new->br_state;
 			if ((error = xfs_btree_insert(cur, &i)))
 				goto done;
 			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
@@ -2902,9 +2858,7 @@ xfs_bmap_add_extent_hole_real(
 			rval = XFS_ILOG_CORE | xfs_ilog_fext(whichfork);
 		} else {
 			rval = XFS_ILOG_CORE;
-			error = xfs_bmbt_lookup_eq(cur, right.br_startoff,
-					right.br_startblock, right.br_blockcount,
-					&i);
+			error = xfs_bmbt_lookup_eq(cur, &right, &i);
 			if (error)
 				goto done;
 			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
@@ -2939,9 +2893,7 @@ xfs_bmap_add_extent_hole_real(
 			rval = xfs_ilog_fext(whichfork);
 		} else {
 			rval = 0;
-			error = xfs_bmbt_lookup_eq(cur, old.br_startoff,
-					old.br_startblock, old.br_blockcount,
-					&i);
+			error = xfs_bmbt_lookup_eq(cur, &old, &i);
 			if (error)
 				goto done;
 			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
@@ -2969,9 +2921,7 @@ xfs_bmap_add_extent_hole_real(
 			rval = xfs_ilog_fext(whichfork);
 		} else {
 			rval = 0;
-			error = xfs_bmbt_lookup_eq(cur, old.br_startoff,
-					old.br_startblock, old.br_blockcount,
-					&i);
+			error = xfs_bmbt_lookup_eq(cur, &old, &i);
 			if (error)
 				goto done;
 			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
@@ -2994,14 +2944,10 @@ xfs_bmap_add_extent_hole_real(
 			rval = XFS_ILOG_CORE | xfs_ilog_fext(whichfork);
 		} else {
 			rval = XFS_ILOG_CORE;
-			error = xfs_bmbt_lookup_eq(cur,
-					new->br_startoff,
-					new->br_startblock,
-					new->br_blockcount, &i);
+			error = xfs_bmbt_lookup_eq(cur, new, &i);
 			if (error)
 				goto done;
 			XFS_WANT_CORRUPTED_GOTO(mp, i == 0, done);
-			cur->bc_rec.b.br_state = new->br_state;
 			error = xfs_btree_insert(cur, &i);
 			if (error)
 				goto done;
@@ -5101,8 +5047,7 @@ xfs_bmap_del_extent_real(
 
 	del_endblock = del->br_startblock + del->br_blockcount;
 	if (cur) {
-		error = xfs_bmbt_lookup_eq(cur, got.br_startoff,
-				got.br_startblock, got.br_blockcount, &i);
+		error = xfs_bmbt_lookup_eq(cur, &got, &i);
 		if (error)
 			goto done;
 		XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
@@ -5205,9 +5150,7 @@ xfs_bmap_del_extent_real(
 				 * Reset the cursor, don't trust it after any
 				 * insert operation.
 				 */
-				error = xfs_bmbt_lookup_eq(cur, got.br_startoff,
-						got.br_startblock,
-						got.br_blockcount, &i);
+				error = xfs_bmbt_lookup_eq(cur, &got, &i);
 				if (error)
 					goto done;
 				XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
@@ -5735,8 +5678,7 @@ xfs_bmse_merge(
 	}
 
 	/* lookup and remove the extent to merge */
-	error = xfs_bmbt_lookup_eq(cur, got->br_startoff, got->br_startblock,
-				   got->br_blockcount, &i);
+	error = xfs_bmbt_lookup_eq(cur, got, &i);
 	if (error)
 		return error;
 	XFS_WANT_CORRUPTED_RETURN(mp, i == 1);
@@ -5747,8 +5689,7 @@ xfs_bmse_merge(
 	XFS_WANT_CORRUPTED_RETURN(mp, i == 1);
 
 	/* lookup and update size of the previous extent */
-	error = xfs_bmbt_lookup_eq(cur, left->br_startoff, left->br_startblock,
-				   left->br_blockcount, &i);
+	error = xfs_bmbt_lookup_eq(cur, left, &i);
 	if (error)
 		return error;
 	XFS_WANT_CORRUPTED_RETURN(mp, i == 1);
@@ -5864,8 +5805,7 @@ xfs_bmse_shift_one(
 	new.br_startoff = startoff;
 
 	if (cur) {
-		error = xfs_bmbt_lookup_eq(cur, got->br_startoff,
-				got->br_startblock, got->br_blockcount, &i);
+		error = xfs_bmbt_lookup_eq(cur, got, &i);
 		if (error)
 			return error;
 		XFS_WANT_CORRUPTED_RETURN(mp, i == 1);
@@ -6117,10 +6057,7 @@ xfs_bmap_split_extent_at(
 		cur->bc_private.b.firstblock = *firstfsb;
 		cur->bc_private.b.dfops = dfops;
 		cur->bc_private.b.flags = 0;
-		error = xfs_bmbt_lookup_eq(cur, got.br_startoff,
-				got.br_startblock,
-				got.br_blockcount,
-				&i);
+		error = xfs_bmbt_lookup_eq(cur, &got, &i);
 		if (error)
 			goto del_cursor;
 		XFS_WANT_CORRUPTED_GOTO(mp, i == 1, del_cursor);
@@ -6144,14 +6081,10 @@ xfs_bmap_split_extent_at(
 			   XFS_IFORK_NEXTENTS(ip, whichfork) + 1);
 
 	if (cur) {
-		error = xfs_bmbt_lookup_eq(cur, new.br_startoff,
-				new.br_startblock, new.br_blockcount,
-				&i);
+		error = xfs_bmbt_lookup_eq(cur, &new, &i);
 		if (error)
 			goto del_cursor;
 		XFS_WANT_CORRUPTED_GOTO(mp, i == 0, del_cursor);
-		cur->bc_rec.b.br_state = new.br_state;
-
 		error = xfs_btree_insert(cur, &i);
 		if (error)
 			goto del_cursor;
-- 
2.14.1

