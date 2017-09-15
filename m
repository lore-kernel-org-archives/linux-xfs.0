Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:51898 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751407AbdIOOy3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 15 Sep 2017 10:54:29 -0400
Received: from [8.25.222.2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1dss0j-0003Iw-04
        for linux-xfs@vger.kernel.org; Fri, 15 Sep 2017 14:54:29 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 15/18] xfs: pass a struct xfs_bmbt_irec to xfs_bmbt_lookup_eq
Date: Fri, 15 Sep 2017 07:54:23 -0700
Message-Id: <20170915145426.26194-16-hch@lst.de>
In-Reply-To: <20170915145426.26194-1-hch@lst.de>
References: <20170915145426.26194-1-hch@lst.de>
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
---
 fs/xfs/libxfs/xfs_bmap.c | 145 +++++++++++++----------------------------------
 1 file changed, 39 insertions(+), 106 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index fb5e669f438d..3bb074993141 100644
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
 
@@ -1711,9 +1707,7 @@ xfs_bmap_add_extent_delay_real(
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
@@ -1749,9 +1743,7 @@ xfs_bmap_add_extent_delay_real(
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
@@ -1777,9 +1769,7 @@ xfs_bmap_add_extent_delay_real(
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
@@ -1806,13 +1796,10 @@ xfs_bmap_add_extent_delay_real(
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
@@ -1846,9 +1833,7 @@ xfs_bmap_add_extent_delay_real(
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
@@ -1871,13 +1856,10 @@ xfs_bmap_add_extent_delay_real(
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
@@ -1924,9 +1906,7 @@ xfs_bmap_add_extent_delay_real(
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
@@ -1959,13 +1939,10 @@ xfs_bmap_add_extent_delay_real(
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
@@ -2047,13 +2024,10 @@ xfs_bmap_add_extent_delay_real(
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
@@ -2272,9 +2246,8 @@ xfs_bmap_add_extent_unwritten_real(
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
@@ -2314,9 +2287,8 @@ xfs_bmap_add_extent_unwritten_real(
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
@@ -2349,9 +2321,8 @@ xfs_bmap_add_extent_unwritten_real(
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
@@ -2381,9 +2352,8 @@ xfs_bmap_add_extent_unwritten_real(
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
@@ -2416,9 +2386,7 @@ xfs_bmap_add_extent_unwritten_real(
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
@@ -2454,9 +2422,7 @@ xfs_bmap_add_extent_unwritten_real(
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
@@ -2494,9 +2460,7 @@ xfs_bmap_add_extent_unwritten_real(
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
@@ -2532,21 +2496,17 @@ xfs_bmap_add_extent_unwritten_real(
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
@@ -2581,9 +2541,7 @@ xfs_bmap_add_extent_unwritten_real(
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
@@ -2601,13 +2559,11 @@ xfs_bmap_add_extent_unwritten_real(
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
@@ -2916,9 +2872,7 @@ xfs_bmap_add_extent_hole_real(
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
@@ -2953,9 +2907,7 @@ xfs_bmap_add_extent_hole_real(
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
@@ -2983,9 +2935,7 @@ xfs_bmap_add_extent_hole_real(
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
@@ -3008,14 +2958,10 @@ xfs_bmap_add_extent_hole_real(
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
@@ -5115,8 +5061,7 @@ xfs_bmap_del_extent_real(
 
 	del_endblock = del->br_startblock + del->br_blockcount;
 	if (cur) {
-		error = xfs_bmbt_lookup_eq(cur, got.br_startoff,
-				got.br_startblock, got.br_blockcount, &i);
+		error = xfs_bmbt_lookup_eq(cur, &got, &i);
 		if (error)
 			goto done;
 		XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
@@ -5219,9 +5164,7 @@ xfs_bmap_del_extent_real(
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
@@ -5749,8 +5692,7 @@ xfs_bmse_merge(
 	}
 
 	/* lookup and remove the extent to merge */
-	error = xfs_bmbt_lookup_eq(cur, got->br_startoff, got->br_startblock,
-				   got->br_blockcount, &i);
+	error = xfs_bmbt_lookup_eq(cur, got, &i);
 	if (error)
 		return error;
 	XFS_WANT_CORRUPTED_RETURN(mp, i == 1);
@@ -5761,8 +5703,7 @@ xfs_bmse_merge(
 	XFS_WANT_CORRUPTED_RETURN(mp, i == 1);
 
 	/* lookup and update size of the previous extent */
-	error = xfs_bmbt_lookup_eq(cur, left->br_startoff, left->br_startblock,
-				   left->br_blockcount, &i);
+	error = xfs_bmbt_lookup_eq(cur, left, &i);
 	if (error)
 		return error;
 	XFS_WANT_CORRUPTED_RETURN(mp, i == 1);
@@ -5878,8 +5819,7 @@ xfs_bmse_shift_one(
 	new.br_startoff = startoff;
 
 	if (cur) {
-		error = xfs_bmbt_lookup_eq(cur, got->br_startoff,
-				got->br_startblock, got->br_blockcount, &i);
+		error = xfs_bmbt_lookup_eq(cur, got, &i);
 		if (error)
 			return error;
 		XFS_WANT_CORRUPTED_RETURN(mp, i == 1);
@@ -6131,10 +6071,7 @@ xfs_bmap_split_extent_at(
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
@@ -6158,14 +6095,10 @@ xfs_bmap_split_extent_at(
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

