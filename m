Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:54307 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752319AbdIVN7x (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 22 Sep 2017 09:59:53 -0400
Received: from ip-64-134-232-11.public.wayport.net ([64.134.232.11] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1dvOUj-0001CG-G4
        for linux-xfs@vger.kernel.org; Fri, 22 Sep 2017 13:59:53 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 15/19] xfs: pass a struct xfs_bmbt_irec to xfs_bmbt_update
Date: Fri, 22 Sep 2017 06:59:41 -0700
Message-Id: <20170922135945.31574-16-hch@lst.de>
In-Reply-To: <20170922135945.31574-1-hch@lst.de>
References: <20170922135945.31574-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Now that we've massaged the callers into the right form we can always
pass the actual extent record instead of the individual fields.

With that xfs_bmbt_disk_set_allf can go away, and xfs_bmbt_disk_set_all
can be merged into the former implementation of xfs_bmbt_disk_set_allf.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_bmap.c       | 114 +++++++++++------------------------------
 fs/xfs/libxfs/xfs_bmap_btree.c |  42 +++++----------
 fs/xfs/libxfs/xfs_bmap_btree.h |   4 +-
 3 files changed, 44 insertions(+), 116 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index e42b063f8efe..23bea9ed9191 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -161,21 +161,17 @@ static inline bool xfs_bmap_wants_extents(struct xfs_inode *ip, int whichfork)
 }
 
 /*
- * Update the record referred to by cur to the value given
- * by [off, bno, len, state].
+ * Update the record referred to by cur to the value given by irec
  * This either works (return 0) or gets an EFSCORRUPTED error.
  */
 STATIC int
 xfs_bmbt_update(
 	struct xfs_btree_cur	*cur,
-	xfs_fileoff_t		off,
-	xfs_fsblock_t		bno,
-	xfs_filblks_t		len,
-	xfs_exntst_t		state)
+	struct xfs_bmbt_irec	*irec)
 {
 	union xfs_btree_rec	rec;
 
-	xfs_bmbt_disk_set_allf(&rec.bmbt, off, bno, len, state);
+	xfs_bmbt_disk_set_all(&rec.bmbt, irec);
 	return xfs_btree_update(cur, &rec);
 }
 
@@ -1728,9 +1724,7 @@ xfs_bmap_add_extent_delay_real(
 			if (error)
 				goto done;
 			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
-			error = xfs_bmbt_update(bma->cur, LEFT.br_startoff,
-					LEFT.br_startblock,
-					LEFT.br_blockcount, LEFT.br_state);
+			error = xfs_bmbt_update(bma->cur, &LEFT);
 			if (error)
 				goto done;
 		}
@@ -1760,9 +1754,7 @@ xfs_bmap_add_extent_delay_real(
 			if (error)
 				goto done;
 			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
-			error = xfs_bmbt_update(bma->cur, LEFT.br_startoff,
-					LEFT.br_startblock,
-					LEFT.br_blockcount, LEFT.br_state);
+			error = xfs_bmbt_update(bma->cur, &LEFT);
 			if (error)
 				goto done;
 		}
@@ -1790,9 +1782,7 @@ xfs_bmap_add_extent_delay_real(
 			if (error)
 				goto done;
 			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
-			error = xfs_bmbt_update(bma->cur, PREV.br_startoff,
-					PREV.br_startblock,
-					PREV.br_blockcount, PREV.br_state);
+			error = xfs_bmbt_update(bma->cur, &PREV);
 			if (error)
 				goto done;
 		}
@@ -1861,9 +1851,7 @@ xfs_bmap_add_extent_delay_real(
 			if (error)
 				goto done;
 			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
-			error = xfs_bmbt_update(bma->cur, LEFT.br_startoff,
-					LEFT.br_startblock, LEFT.br_blockcount,
-					LEFT.br_state);
+			error = xfs_bmbt_update(bma->cur, &LEFT);
 			if (error)
 				goto done;
 		}
@@ -1941,9 +1929,7 @@ xfs_bmap_add_extent_delay_real(
 			if (error)
 				goto done;
 			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
-			error = xfs_bmbt_update(bma->cur, RIGHT.br_startoff,
-					RIGHT.br_startblock, RIGHT.br_blockcount,
-					RIGHT.br_state);
+			error = xfs_bmbt_update(bma->cur, &RIGHT);
 			if (error)
 				goto done;
 		}
@@ -2289,9 +2275,7 @@ xfs_bmap_add_extent_unwritten_real(
 			if ((error = xfs_btree_decrement(cur, 0, &i)))
 				goto done;
 			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
-			error = xfs_bmbt_update(cur, LEFT.br_startoff,
-					LEFT.br_startblock, LEFT.br_blockcount,
-					LEFT.br_state);
+			error = xfs_bmbt_update(cur, &LEFT);
 			if (error)
 				goto done;
 		}
@@ -2327,9 +2311,7 @@ xfs_bmap_add_extent_unwritten_real(
 			if ((error = xfs_btree_decrement(cur, 0, &i)))
 				goto done;
 			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
-			error = xfs_bmbt_update(cur, LEFT.br_startoff,
-					LEFT.br_startblock, LEFT.br_blockcount,
-					LEFT.br_state);
+			error = xfs_bmbt_update(cur, &LEFT);
 			if (error)
 				goto done;
 		}
@@ -2364,9 +2346,7 @@ xfs_bmap_add_extent_unwritten_real(
 			if ((error = xfs_btree_decrement(cur, 0, &i)))
 				goto done;
 			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
-			error = xfs_bmbt_update(cur, PREV.br_startoff,
-					PREV.br_startblock, PREV.br_blockcount,
-					PREV.br_state);
+			error = xfs_bmbt_update(cur, &PREV);
 			if (error)
 				goto done;
 		}
@@ -2392,9 +2372,7 @@ xfs_bmap_add_extent_unwritten_real(
 					&i)))
 				goto done;
 			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
-			error = xfs_bmbt_update(cur, PREV.br_startoff,
-					PREV.br_startblock, PREV.br_blockcount,
-					PREV.br_state);
+			error = xfs_bmbt_update(cur, &PREV);
 			if (error)
 				goto done;
 		}
@@ -2430,17 +2408,13 @@ xfs_bmap_add_extent_unwritten_real(
 			if (error)
 				goto done;
 			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
-			error = xfs_bmbt_update(cur, PREV.br_startoff,
-					PREV.br_startblock, PREV.br_blockcount,
-					PREV.br_state);
+			error = xfs_bmbt_update(cur, &PREV);
 			if (error)
 				goto done;
 			error = xfs_btree_decrement(cur, 0, &i);
 			if (error)
 				goto done;
-			error = xfs_bmbt_update(cur, LEFT.br_startoff,
-					LEFT.br_startblock, LEFT.br_blockcount,
-					LEFT.br_state);
+			error = xfs_bmbt_update(cur, &LEFT);
 			if (error)
 				goto done;
 		}
@@ -2472,9 +2446,7 @@ xfs_bmap_add_extent_unwritten_real(
 			if (error)
 				goto done;
 			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
-			error = xfs_bmbt_update(cur, PREV.br_startoff,
-					PREV.br_startblock, PREV.br_blockcount,
-					PREV.br_state);
+			error = xfs_bmbt_update(cur, &PREV);
 			if (error)
 				goto done;
 			cur->bc_rec.b = *new;
@@ -2514,17 +2486,13 @@ xfs_bmap_add_extent_unwritten_real(
 			if (error)
 				goto done;
 			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
-			error = xfs_bmbt_update(cur, PREV.br_startoff,
-					PREV.br_startblock, PREV.br_blockcount,
-					PREV.br_state);
+			error = xfs_bmbt_update(cur, &PREV);
 			if (error)
 				goto done;
 			error = xfs_btree_increment(cur, 0, &i);
 			if (error)
 				goto done;
-			error = xfs_bmbt_update(cur, RIGHT.br_startoff,
-					RIGHT.br_startblock,
-					RIGHT.br_blockcount, RIGHT.br_state);
+			error = xfs_bmbt_update(cur, &RIGHT);
 			if (error)
 				goto done;
 		}
@@ -2556,9 +2524,7 @@ xfs_bmap_add_extent_unwritten_real(
 			if (error)
 				goto done;
 			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
-			error = xfs_bmbt_update(cur, PREV.br_startoff,
-					PREV.br_startblock, PREV.br_blockcount,
-					PREV.br_state);
+			error = xfs_bmbt_update(cur, &PREV);
 			if (error)
 				goto done;
 			if ((error = xfs_bmbt_lookup_eq(cur, new->br_startoff,
@@ -2608,9 +2574,8 @@ xfs_bmap_add_extent_unwritten_real(
 				goto done;
 			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
 			/* new right extent - oldext */
-			if ((error = xfs_bmbt_update(cur, r[1].br_startoff,
-				r[1].br_startblock, r[1].br_blockcount,
-				r[1].br_state)))
+			error = xfs_bmbt_update(cur, &r[1]);
+			if (error)
 				goto done;
 			/* new left extent - oldext */
 			cur->bc_rec.b = PREV;
@@ -2951,9 +2916,7 @@ xfs_bmap_add_extent_hole_real(
 			if (error)
 				goto done;
 			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
-			error = xfs_bmbt_update(cur, left.br_startoff,
-					left.br_startblock,
-					left.br_blockcount, left.br_state);
+			error = xfs_bmbt_update(cur, &left);
 			if (error)
 				goto done;
 		}
@@ -2982,9 +2945,7 @@ xfs_bmap_add_extent_hole_real(
 			if (error)
 				goto done;
 			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
-			error = xfs_bmbt_update(cur, left.br_startoff,
-					left.br_startblock,
-					left.br_blockcount, left.br_state);
+			error = xfs_bmbt_update(cur, &left);
 			if (error)
 				goto done;
 		}
@@ -3014,9 +2975,7 @@ xfs_bmap_add_extent_hole_real(
 			if (error)
 				goto done;
 			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
-			error = xfs_bmbt_update(cur, right.br_startoff,
-					right.br_startblock,
-					right.br_blockcount, right.br_state);
+			error = xfs_bmbt_update(cur, &right);
 			if (error)
 				goto done;
 		}
@@ -5189,8 +5148,7 @@ xfs_bmap_del_extent_real(
 			flags |= xfs_ilog_fext(whichfork);
 			break;
 		}
-		error = xfs_bmbt_update(cur, got.br_startoff, got.br_startblock,
-				got.br_blockcount, got.br_state);
+		error = xfs_bmbt_update(cur, &got);
 		if (error)
 			goto done;
 		break;
@@ -5206,8 +5164,7 @@ xfs_bmap_del_extent_real(
 			flags |= xfs_ilog_fext(whichfork);
 			break;
 		}
-		error = xfs_bmbt_update(cur, got.br_startoff, got.br_startblock,
-				got.br_blockcount, got.br_state);
+		error = xfs_bmbt_update(cur, &got);
 		if (error)
 			goto done;
 		break;
@@ -5228,9 +5185,7 @@ xfs_bmap_del_extent_real(
 
 		flags |= XFS_ILOG_CORE;
 		if (cur) {
-			error = xfs_bmbt_update(cur, got.br_startoff,
-					got.br_startblock, got.br_blockcount,
-					got.br_state);
+			error = xfs_bmbt_update(cur, &got);
 			if (error)
 				goto done;
 			error = xfs_btree_increment(cur, 0, &i);
@@ -5260,10 +5215,7 @@ xfs_bmap_del_extent_real(
 				 * Update the btree record back
 				 * to the original value.
 				 */
-				error = xfs_bmbt_update(cur, old.br_startoff,
-						old.br_startblock,
-						old.br_blockcount,
-						old.br_state);
+				error = xfs_bmbt_update(cur, &old);
 				if (error)
 					goto done;
 				/*
@@ -5801,8 +5753,7 @@ xfs_bmse_merge(
 		return error;
 	XFS_WANT_CORRUPTED_RETURN(mp, i == 1);
 
-	error = xfs_bmbt_update(cur, new.br_startoff, new.br_startblock,
-			        new.br_blockcount, new.br_state);
+	error = xfs_bmbt_update(cur, &new);
 	if (error)
 		return error;
 
@@ -5919,9 +5870,7 @@ xfs_bmse_shift_one(
 			return error;
 		XFS_WANT_CORRUPTED_RETURN(mp, i == 1);
 
-		error = xfs_bmbt_update(cur, new.br_startoff,
-				new.br_startblock, new.br_blockcount,
-				new.br_state);
+		error = xfs_bmbt_update(cur, &new);
 		if (error)
 			return error;
 	} else {
@@ -6182,10 +6131,7 @@ xfs_bmap_split_extent_at(
 
 	logflags = XFS_ILOG_CORE;
 	if (cur) {
-		error = xfs_bmbt_update(cur, got.br_startoff,
-				got.br_startblock,
-				got.br_blockcount,
-				got.br_state);
+		error = xfs_bmbt_update(cur, &got);
 		if (error)
 			goto del_cursor;
 	} else
diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
index a6331ffa51e3..7e2d981626ef 100644
--- a/fs/xfs/libxfs/xfs_bmap_btree.c
+++ b/fs/xfs/libxfs/xfs_bmap_btree.c
@@ -228,47 +228,31 @@ xfs_bmbt_set_all(
 			     s->br_blockcount, s->br_state);
 }
 
-
 /*
- * Set all the fields in a disk format bmap extent record from the arguments.
+ * Set all the fields in a bmap extent record from the uncompressed form.
  */
 void
-xfs_bmbt_disk_set_allf(
-	xfs_bmbt_rec_t		*r,
-	xfs_fileoff_t		startoff,
-	xfs_fsblock_t		startblock,
-	xfs_filblks_t		blockcount,
-	xfs_exntst_t		state)
+xfs_bmbt_disk_set_all(
+	struct xfs_bmbt_rec	*r,
+	struct xfs_bmbt_irec	*s)
 {
-	int			extent_flag = (state == XFS_EXT_NORM) ? 0 : 1;
+	int			extent_flag = (s->br_state != XFS_EXT_NORM);
 
-	ASSERT(state == XFS_EXT_NORM || state == XFS_EXT_UNWRITTEN);
-	ASSERT((startoff & xfs_mask64hi(64-BMBT_STARTOFF_BITLEN)) == 0);
-	ASSERT((blockcount & xfs_mask64hi(64-BMBT_BLOCKCOUNT_BITLEN)) == 0);
-	ASSERT((startblock & xfs_mask64hi(64-BMBT_STARTBLOCK_BITLEN)) == 0);
+	ASSERT(s->br_state == XFS_EXT_NORM || s->br_state == XFS_EXT_UNWRITTEN);
+	ASSERT(!(s->br_startoff & xfs_mask64hi(64-BMBT_STARTOFF_BITLEN)));
+	ASSERT(!(s->br_blockcount & xfs_mask64hi(64-BMBT_BLOCKCOUNT_BITLEN)));
+	ASSERT(!(s->br_startblock & xfs_mask64hi(64-BMBT_STARTBLOCK_BITLEN)));
 
 	r->l0 = cpu_to_be64(
 		((xfs_bmbt_rec_base_t)extent_flag << 63) |
-		 ((xfs_bmbt_rec_base_t)startoff << 9) |
-		 ((xfs_bmbt_rec_base_t)startblock >> 43));
+		 ((xfs_bmbt_rec_base_t)s->br_startoff << 9) |
+		 ((xfs_bmbt_rec_base_t)s->br_startblock >> 43));
 	r->l1 = cpu_to_be64(
-		((xfs_bmbt_rec_base_t)startblock << 21) |
-		 ((xfs_bmbt_rec_base_t)blockcount &
+		((xfs_bmbt_rec_base_t)s->br_startblock << 21) |
+		 ((xfs_bmbt_rec_base_t)s->br_blockcount &
 		  (xfs_bmbt_rec_base_t)xfs_mask64lo(21)));
 }
 
-/*
- * Set all the fields in a bmap extent record from the uncompressed form.
- */
-STATIC void
-xfs_bmbt_disk_set_all(
-	xfs_bmbt_rec_t	*r,
-	xfs_bmbt_irec_t *s)
-{
-	xfs_bmbt_disk_set_allf(r, s->br_startoff, s->br_startblock,
-				  s->br_blockcount, s->br_state);
-}
-
 /*
  * Set the blockcount field in a bmap extent record.
  */
diff --git a/fs/xfs/libxfs/xfs_bmap_btree.h b/fs/xfs/libxfs/xfs_bmap_btree.h
index 9da5a8d4f184..bd3c56f1cd03 100644
--- a/fs/xfs/libxfs/xfs_bmap_btree.h
+++ b/fs/xfs/libxfs/xfs_bmap_btree.h
@@ -104,6 +104,7 @@ extern xfs_fsblock_t xfs_bmbt_get_startblock(xfs_bmbt_rec_host_t *r);
 extern xfs_fileoff_t xfs_bmbt_get_startoff(xfs_bmbt_rec_host_t *r);
 extern xfs_exntst_t xfs_bmbt_get_state(xfs_bmbt_rec_host_t *r);
 
+void xfs_bmbt_disk_set_all(struct xfs_bmbt_rec *r, struct xfs_bmbt_irec *s);
 extern xfs_filblks_t xfs_bmbt_disk_get_blockcount(xfs_bmbt_rec_t *r);
 extern xfs_fileoff_t xfs_bmbt_disk_get_startoff(xfs_bmbt_rec_t *r);
 
@@ -115,9 +116,6 @@ extern void xfs_bmbt_set_startblock(xfs_bmbt_rec_host_t *r, xfs_fsblock_t v);
 extern void xfs_bmbt_set_startoff(xfs_bmbt_rec_host_t *r, xfs_fileoff_t v);
 extern void xfs_bmbt_set_state(xfs_bmbt_rec_host_t *r, xfs_exntst_t v);
 
-extern void xfs_bmbt_disk_set_allf(xfs_bmbt_rec_t *r, xfs_fileoff_t o,
-			xfs_fsblock_t b, xfs_filblks_t c, xfs_exntst_t v);
-
 extern void xfs_bmbt_to_bmdr(struct xfs_mount *, struct xfs_btree_block *, int,
 			xfs_bmdr_block_t *, int);
 
-- 
2.14.1

