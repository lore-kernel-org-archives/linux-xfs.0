Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:55118 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751593AbdJSHAf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 19 Oct 2017 03:00:35 -0400
Received: from 212095007233.public.telering.at ([212.95.7.233] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1e54ol-0005uh-0B
        for linux-xfs@vger.kernel.org; Thu, 19 Oct 2017 07:00:35 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 11/15] xfs: remove xfs_bmse_shift_one
Date: Thu, 19 Oct 2017 08:59:38 +0200
Message-Id: <20171019065942.18813-12-hch@lst.de>
In-Reply-To: <20171019065942.18813-1-hch@lst.de>
References: <20171019065942.18813-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Instead do the actual left and right shift work in the callers, and just
keep a helper to update the bmap and rmap btrees as well as the in-core
extent list.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_bmap.c | 181 +++++++++++++++++++----------------------------
 fs/xfs/libxfs/xfs_bmap.h |   5 --
 2 files changed, 71 insertions(+), 115 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 7d3a38e69d28..703596caf255 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -5568,94 +5568,21 @@ xfs_bmse_merge(
 	return xfs_rmap_map_extent(mp, dfops, ip, whichfork, &new);
 }
 
-/*
- * Shift a single extent.
- */
-STATIC int
-xfs_bmse_shift_one(
-	struct xfs_inode		*ip,
-	int				whichfork,
-	xfs_fileoff_t			offset_shift_fsb,
-	int				*current_ext,
-	struct xfs_bmbt_irec		*got,
-	struct xfs_btree_cur		*cur,
-	int				*logflags,
-	enum shift_direction		direction,
-	struct xfs_defer_ops		*dfops)
+static int
+xfs_bmap_shift_update_extent(
+	struct xfs_inode	*ip,
+	int			whichfork,
+	xfs_extnum_t		idx,
+	struct xfs_bmbt_irec	*got,
+	struct xfs_btree_cur	*cur,
+	int			*logflags,
+	struct xfs_defer_ops	*dfops,
+	xfs_fileoff_t		startoff)
 {
-	struct xfs_ifork		*ifp;
-	struct xfs_mount		*mp;
-	xfs_fileoff_t			startoff;
-	struct xfs_bmbt_irec		adj_irec, new;
-	int				error;
-	int				i;
-	int				total_extents;
-
-	mp = ip->i_mount;
-	ifp = XFS_IFORK_PTR(ip, whichfork);
-	total_extents = xfs_iext_count(ifp);
-
-	/* delalloc extents should be prevented by caller */
-	XFS_WANT_CORRUPTED_RETURN(mp, !isnullstartblock(got->br_startblock));
-
-	if (direction == SHIFT_LEFT) {
-		startoff = got->br_startoff - offset_shift_fsb;
-
-		/*
-		 * Check for merge if we've got an extent to the left,
-		 * otherwise make sure there's enough room at the start
-		 * of the file for the shift.
-		 */
-		if (!*current_ext) {
-			if (got->br_startoff < offset_shift_fsb)
-				return -EINVAL;
-			goto update_current_ext;
-		}
-
-		/*
-		 * grab the left extent and check for a large enough hole.
-		 */
-		xfs_iext_get_extent(ifp, *current_ext - 1, &adj_irec);
-		if (startoff < adj_irec.br_startoff + adj_irec.br_blockcount)
-			return -EINVAL;
-
-		/* check whether to merge the extent or shift it down */
-		if (xfs_bmse_can_merge(&adj_irec, got, offset_shift_fsb)) {
-			return xfs_bmse_merge(ip, whichfork, offset_shift_fsb,
-					      *current_ext, got, &adj_irec,
-					      cur, logflags, dfops);
-		}
-	} else {
-		startoff = got->br_startoff + offset_shift_fsb;
-		/* nothing to move if this is the last extent */
-		if (*current_ext >= (total_extents - 1))
-			goto update_current_ext;
-
-		/*
-		 * If this is not the last extent in the file, make sure there
-		 * is enough room between current extent and next extent for
-		 * accommodating the shift.
-		 */
-		xfs_iext_get_extent(ifp, *current_ext + 1, &adj_irec);
-		if (startoff + got->br_blockcount > adj_irec.br_startoff)
-			return -EINVAL;
-
-		/*
-		 * Unlike a left shift (which involves a hole punch),
-		 * a right shift does not modify extent neighbors
-		 * in any way. We should never find mergeable extents
-		 * in this scenario. Check anyways and warn if we
-		 * encounter two extents that could be one.
-		 */
-		if (xfs_bmse_can_merge(got, &adj_irec, offset_shift_fsb))
-			WARN_ON_ONCE(1);
-	}
+	struct xfs_mount	*mp = ip->i_mount;
+	struct xfs_bmbt_irec	new;
+	int			error, i;
 
-	/*
-	 * Increment the extent index for the next iteration, update the start
-	 * offset of the in-core extent and update the btree if applicable.
-	 */
-update_current_ext:
 	*logflags |= XFS_ILOG_CORE;
 
 	new = *got;
@@ -5674,13 +5601,8 @@ xfs_bmse_shift_one(
 		*logflags |= XFS_ILOG_DEXT;
 	}
 
-	xfs_iext_update_extent(ip, xfs_bmap_fork_to_state(whichfork),
-			*current_ext, &new);
-
-	if (direction == SHIFT_LEFT)
-		(*current_ext)++;
-	else
-		(*current_ext)--;
+	xfs_iext_update_extent(ip, xfs_bmap_fork_to_state(whichfork), idx,
+			&new);
 
 	/* update reverse mapping */
 	error = xfs_rmap_unmap_extent(mp, dfops, ip, whichfork, got);
@@ -5704,10 +5626,11 @@ xfs_bmap_collapse_extents(
 	struct xfs_mount	*mp = ip->i_mount;
 	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
 	struct xfs_btree_cur	*cur = NULL;
-	struct xfs_bmbt_irec	got;
+	struct xfs_bmbt_irec	got, prev;
 	xfs_extnum_t		current_ext;
 	xfs_extnum_t		total_extents;
 	xfs_extnum_t		stop_extent;
+	xfs_fileoff_t		new_startoff;
 	int			error = 0;
 	int			logflags = 0;
 
@@ -5760,6 +5683,7 @@ xfs_bmap_collapse_extents(
 		*done = true;
 		goto del_cursor;
 	}
+	XFS_WANT_CORRUPTED_RETURN(mp, !isnullstartblock(got.br_startblock));
 
 	stop_extent = total_extents;
 	if (current_ext >= stop_extent) {
@@ -5767,11 +5691,36 @@ xfs_bmap_collapse_extents(
 		goto del_cursor;
 	}
 
-	error = xfs_bmse_shift_one(ip, whichfork, offset_shift_fsb,
-				   &current_ext, &got, cur, &logflags,
-				   SHIFT_LEFT, dfops);
+	new_startoff = got.br_startoff - offset_shift_fsb;
+	if (current_ext) {
+		xfs_iext_get_extent(ifp, current_ext - 1, &prev);
+		if (new_startoff < prev.br_startoff + prev.br_blockcount) {
+			error = -EINVAL;
+			goto del_cursor;
+		}
+
+		/* check whether to merge the extent or shift it down */
+		if (xfs_bmse_can_merge(&prev, &got, offset_shift_fsb)) {
+			error = xfs_bmse_merge(ip, whichfork, offset_shift_fsb,
+					current_ext, &got, &prev, cur,
+					&logflags, dfops);
+			if (error)
+				goto del_cursor;
+			goto done;
+		}
+	} else {
+		if (got.br_startoff < offset_shift_fsb) {
+			error = -EINVAL;
+			goto del_cursor;
+		}
+	}
+
+	error = xfs_bmap_shift_update_extent(ip, whichfork, current_ext, &got,
+			cur, &logflags, dfops, new_startoff);
 	if (error)
 		goto del_cursor;
+	current_ext++;
+done:
 	/*
 	 * If there was an extent merge during the shift, the extent
 	 * count can change. Update the total and grade the next record.
@@ -5784,17 +5733,13 @@ xfs_bmap_collapse_extents(
 	}
 	xfs_iext_get_extent(ifp, current_ext, &got);
 
-	if (!*done)
-		*next_fsb = got.br_startoff;
-
+	*next_fsb = got.br_startoff;
 del_cursor:
 	if (cur)
 		xfs_btree_del_cursor(cur,
 			error ? XFS_BTREE_ERROR : XFS_BTREE_NOERROR);
-
 	if (logflags)
 		xfs_trans_log_inode(tp, ip, logflags);
-
 	return error;
 }
 
@@ -5813,10 +5758,11 @@ xfs_bmap_insert_extents(
 	struct xfs_mount	*mp = ip->i_mount;
 	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
 	struct xfs_btree_cur	*cur = NULL;
-	struct xfs_bmbt_irec	got, s;
+	struct xfs_bmbt_irec	got, next, s;
 	xfs_extnum_t		current_ext;
 	xfs_extnum_t		total_extents;
 	xfs_extnum_t		stop_extent;
+	xfs_fileoff_t		new_startoff;
 	int			error = 0;
 	int			logflags = 0;
 
@@ -5883,6 +5829,7 @@ xfs_bmap_insert_extents(
 			goto del_cursor;
 		}
 	}
+	XFS_WANT_CORRUPTED_RETURN(mp, !isnullstartblock(got.br_startblock));
 
 	/* Lookup the extent index at which we have to stop */
 	xfs_iext_lookup_extent(ip, ifp, stop_fsb, &stop_extent, &s);
@@ -5893,27 +5840,41 @@ xfs_bmap_insert_extents(
 		goto del_cursor;
 	}
 
-	error = xfs_bmse_shift_one(ip, whichfork, offset_shift_fsb,
-				   &current_ext, &got, cur, &logflags,
-				   SHIFT_RIGHT, dfops);
+	new_startoff = got.br_startoff + offset_shift_fsb;
+	if (current_ext < total_extents - 1) {
+		xfs_iext_get_extent(ifp, current_ext + 1, &next);
+		if (new_startoff + got.br_blockcount > next.br_startoff) {
+			error = -EINVAL;
+			goto del_cursor;
+		}
+
+		/*
+		 * Unlike a left shift (which involves a hole punch), a right
+		 * shift does not modify extent neighbors in any way.  We should
+		 * never find mergeable extents in this scenario.  Check anyways
+		 * and warn if we encounter two extents that could be one.
+		 */
+		if (xfs_bmse_can_merge(&got, &next, offset_shift_fsb))
+			WARN_ON_ONCE(1);
+	}
+
+	error = xfs_bmap_shift_update_extent(ip, whichfork, current_ext, &got,
+			cur, &logflags, dfops, new_startoff);
 	if (error)
 		goto del_cursor;
-	if (current_ext == stop_extent) {
+	if (--current_ext == stop_extent) {
 		*done = true;
 		goto del_cursor;
 	}
 	xfs_iext_get_extent(ifp, current_ext, &got);
 
 	*next_fsb = got.br_startoff;
-
 del_cursor:
 	if (cur)
 		xfs_btree_del_cursor(cur,
 			error ? XFS_BTREE_ERROR : XFS_BTREE_NOERROR);
-
 	if (logflags)
 		xfs_trans_log_inode(tp, ip, logflags);
-
 	return error;
 }
 
diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
index f7ccf2de1a8c..6c426cdfb758 100644
--- a/fs/xfs/libxfs/xfs_bmap.h
+++ b/fs/xfs/libxfs/xfs_bmap.h
@@ -183,11 +183,6 @@ static inline bool xfs_bmap_is_real_extent(struct xfs_bmbt_irec *irec)
 		!isnullstartblock(irec->br_startblock);
 }
 
-enum shift_direction {
-	SHIFT_LEFT = 0,
-	SHIFT_RIGHT,
-};
-
 void	xfs_trim_extent(struct xfs_bmbt_irec *irec, xfs_fileoff_t bno,
 		xfs_filblks_t len);
 int	xfs_bmap_add_attrfork(struct xfs_inode *ip, int size, int rsvd);
-- 
2.14.1

