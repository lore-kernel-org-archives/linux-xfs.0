Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:34815 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752325AbdIRPY0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 Sep 2017 11:24:26 -0400
Received: from [107.17.164.65] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1dtxuL-0005Df-Jf
        for linux-xfs@vger.kernel.org; Mon, 18 Sep 2017 15:24:25 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 05/19] xfs: use xfs_bmap_del_extent_delay for the data fork as well
Date: Mon, 18 Sep 2017 08:24:08 -0700
Message-Id: <20170918152422.24345-6-hch@lst.de>
In-Reply-To: <20170918152422.24345-1-hch@lst.de>
References: <20170918152422.24345-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

And remove the delalloc code from xfs_bmap_del_extent, which gets renamed
to xfs_bmap_del_extent_real to fit the naming scheme used by the other
xfs_bmap_{add,del}_extent_* routines.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_bmap.c | 331 ++++++++++++++++-------------------------------
 1 file changed, 114 insertions(+), 217 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 15650bb7d881..4e6c4cc4168f 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -5061,10 +5061,10 @@ xfs_bmap_del_extent_cow(
 
 /*
  * Called by xfs_bmapi to update file extent records and the btree
- * after removing space (or undoing a delayed allocation).
+ * after removing space.
  */
 STATIC int				/* error */
-xfs_bmap_del_extent(
+xfs_bmap_del_extent_real(
 	xfs_inode_t		*ip,	/* incore inode pointer */
 	xfs_trans_t		*tp,	/* current transaction pointer */
 	xfs_extnum_t		*idx,	/* extent number to update/delete */
@@ -5075,11 +5075,8 @@ xfs_bmap_del_extent(
 	int			whichfork, /* data or attr fork */
 	int			bflags)	/* bmapi flags */
 {
-	xfs_filblks_t		da_new;	/* new delay-alloc indirect blocks */
-	xfs_filblks_t		da_old;	/* old delay-alloc indirect blocks */
 	xfs_fsblock_t		del_endblock=0;	/* first block past del */
 	xfs_fileoff_t		del_endoff;	/* first offset past del */
-	int			delay;	/* current block is delayed allocated */
 	int			do_fx;	/* free extent at end of routine */
 	xfs_bmbt_rec_host_t	*ep;	/* current extent entry pointer */
 	int			error;	/* error return value */
@@ -5114,63 +5111,40 @@ xfs_bmap_del_extent(
 	del_endoff = del->br_startoff + del->br_blockcount;
 	got_endoff = got.br_startoff + got.br_blockcount;
 	ASSERT(got_endoff >= del_endoff);
-	delay = isnullstartblock(got.br_startblock);
-	ASSERT(isnullstartblock(del->br_startblock) == delay);
-	flags = 0;
+	ASSERT(!isnullstartblock(got.br_startblock));
+	flags = XFS_ILOG_CORE;
 	qfield = 0;
 	error = 0;
-	/*
-	 * If deleting a real allocation, must free up the disk space.
-	 */
-	if (!delay) {
-		flags = XFS_ILOG_CORE;
-		/*
-		 * Realtime allocation.  Free it and record di_nblocks update.
-		 */
-		if (whichfork == XFS_DATA_FORK && XFS_IS_REALTIME_INODE(ip)) {
-			xfs_fsblock_t	bno;
-			xfs_filblks_t	len;
-
-			ASSERT(do_mod(del->br_blockcount,
-				      mp->m_sb.sb_rextsize) == 0);
-			ASSERT(do_mod(del->br_startblock,
-				      mp->m_sb.sb_rextsize) == 0);
-			bno = del->br_startblock;
-			len = del->br_blockcount;
-			do_div(bno, mp->m_sb.sb_rextsize);
-			do_div(len, mp->m_sb.sb_rextsize);
-			error = xfs_rtfree_extent(tp, bno, (xfs_extlen_t)len);
-			if (error)
-				goto done;
-			do_fx = 0;
-			nblks = len * mp->m_sb.sb_rextsize;
-			qfield = XFS_TRANS_DQ_RTBCOUNT;
-		}
-		/*
-		 * Ordinary allocation.
-		 */
-		else {
-			do_fx = 1;
-			nblks = del->br_blockcount;
-			qfield = XFS_TRANS_DQ_BCOUNT;
-		}
-		/*
-		 * Set up del_endblock and cur for later.
-		 */
-		del_endblock = del->br_startblock + del->br_blockcount;
-		if (cur) {
-			if ((error = xfs_bmbt_lookup_eq(cur, got.br_startoff,
-					got.br_startblock, got.br_blockcount,
-					&i)))
-				goto done;
-			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
-		}
-		da_old = da_new = 0;
-	} else {
-		da_old = startblockval(got.br_startblock);
-		da_new = 0;
-		nblks = 0;
+
+	if (whichfork == XFS_DATA_FORK && XFS_IS_REALTIME_INODE(ip)) {
+		xfs_fsblock_t	bno;
+		xfs_filblks_t	len;
+
+		ASSERT(do_mod(del->br_blockcount, mp->m_sb.sb_rextsize) == 0);
+		ASSERT(do_mod(del->br_startblock, mp->m_sb.sb_rextsize) == 0);
+		bno = del->br_startblock;
+		len = del->br_blockcount;
+		do_div(bno, mp->m_sb.sb_rextsize);
+		do_div(len, mp->m_sb.sb_rextsize);
+		error = xfs_rtfree_extent(tp, bno, (xfs_extlen_t)len);
+		if (error)
+			goto done;
 		do_fx = 0;
+		nblks = len * mp->m_sb.sb_rextsize;
+		qfield = XFS_TRANS_DQ_RTBCOUNT;
+	} else {
+		do_fx = 1;
+		nblks = del->br_blockcount;
+		qfield = XFS_TRANS_DQ_BCOUNT;
+	}
+
+	del_endblock = del->br_startblock + del->br_blockcount;
+	if (cur) {
+		error = xfs_bmbt_lookup_eq(cur, got.br_startoff,
+				got.br_startblock, got.br_blockcount, &i);
+		if (error)
+			goto done;
+		XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
 	}
 
 	/*
@@ -5187,8 +5161,6 @@ xfs_bmap_del_extent(
 		xfs_iext_remove(ip, *idx, 1,
 				whichfork == XFS_ATTR_FORK ? BMAP_ATTRFORK : 0);
 		--*idx;
-		if (delay)
-			break;
 
 		XFS_IFORK_NEXT_SET(ip, whichfork,
 			XFS_IFORK_NEXTENTS(ip, whichfork) - 1);
@@ -5210,14 +5182,6 @@ xfs_bmap_del_extent(
 		xfs_bmbt_set_startoff(ep, del_endoff);
 		temp = got.br_blockcount - del->br_blockcount;
 		xfs_bmbt_set_blockcount(ep, temp);
-		if (delay) {
-			temp = XFS_FILBLKS_MIN(xfs_bmap_worst_indlen(ip, temp),
-				da_old);
-			xfs_bmbt_set_startblock(ep, nullstartblock((int)temp));
-			trace_xfs_bmap_post_update(ip, *idx, state, _THIS_IP_);
-			da_new = temp;
-			break;
-		}
 		xfs_bmbt_set_startblock(ep, del_endblock);
 		trace_xfs_bmap_post_update(ip, *idx, state, _THIS_IP_);
 		if (!cur) {
@@ -5237,14 +5201,6 @@ xfs_bmap_del_extent(
 		temp = got.br_blockcount - del->br_blockcount;
 		trace_xfs_bmap_pre_update(ip, *idx, state, _THIS_IP_);
 		xfs_bmbt_set_blockcount(ep, temp);
-		if (delay) {
-			temp = XFS_FILBLKS_MIN(xfs_bmap_worst_indlen(ip, temp),
-				da_old);
-			xfs_bmbt_set_startblock(ep, nullstartblock((int)temp));
-			trace_xfs_bmap_post_update(ip, *idx, state, _THIS_IP_);
-			da_new = temp;
-			break;
-		}
 		trace_xfs_bmap_post_update(ip, *idx, state, _THIS_IP_);
 		if (!cur) {
 			flags |= xfs_ilog_fext(whichfork);
@@ -5268,89 +5224,60 @@ xfs_bmap_del_extent(
 		temp2 = got_endoff - del_endoff;
 		new.br_blockcount = temp2;
 		new.br_state = got.br_state;
-		if (!delay) {
-			new.br_startblock = del_endblock;
-			flags |= XFS_ILOG_CORE;
-			if (cur) {
-				if ((error = xfs_bmbt_update(cur,
-						got.br_startoff,
-						got.br_startblock, temp,
-						got.br_state)))
-					goto done;
-				if ((error = xfs_btree_increment(cur, 0, &i)))
-					goto done;
-				cur->bc_rec.b = new;
-				error = xfs_btree_insert(cur, &i);
-				if (error && error != -ENOSPC)
-					goto done;
+		new.br_startblock = del_endblock;
+		flags |= XFS_ILOG_CORE;
+		if (cur) {
+			error = xfs_bmbt_update(cur, got.br_startoff,
+					got.br_startblock, temp,
+					got.br_state);
+			if (error)
+				goto done;
+			error = xfs_btree_increment(cur, 0, &i);
+			if (error)
+				goto done;
+			cur->bc_rec.b = new;
+			error = xfs_btree_insert(cur, &i);
+			if (error && error != -ENOSPC)
+				goto done;
+			/*
+			 * If get no-space back from btree insert, it tried a
+			 * split, and we have a zero block reservation.  Fix up
+			 * our state and return the error.
+			 */
+			if (error == -ENOSPC) {
 				/*
-				 * If get no-space back from btree insert,
-				 * it tried a split, and we have a zero
-				 * block reservation.
-				 * Fix up our state and return the error.
+				 * Reset the cursor, don't trust it after any
+				 * insert operation.
 				 */
-				if (error == -ENOSPC) {
-					/*
-					 * Reset the cursor, don't trust
-					 * it after any insert operation.
-					 */
-					if ((error = xfs_bmbt_lookup_eq(cur,
-							got.br_startoff,
-							got.br_startblock,
-							temp, &i)))
-						goto done;
-					XFS_WANT_CORRUPTED_GOTO(mp,
-								i == 1, done);
-					/*
-					 * Update the btree record back
-					 * to the original value.
-					 */
-					if ((error = xfs_bmbt_update(cur,
-							got.br_startoff,
-							got.br_startblock,
-							got.br_blockcount,
-							got.br_state)))
-						goto done;
-					/*
-					 * Reset the extent record back
-					 * to the original value.
-					 */
-					xfs_bmbt_set_blockcount(ep,
-						got.br_blockcount);
-					flags = 0;
-					error = -ENOSPC;
+				error = xfs_bmbt_lookup_eq(cur, got.br_startoff,
+						got.br_startblock, temp, &i);
+				if (error)
 					goto done;
-				}
 				XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
-			} else
-				flags |= xfs_ilog_fext(whichfork);
-			XFS_IFORK_NEXT_SET(ip, whichfork,
-				XFS_IFORK_NEXTENTS(ip, whichfork) + 1);
-		} else {
-			xfs_filblks_t	stolen;
-			ASSERT(whichfork == XFS_DATA_FORK);
-
-			/*
-			 * Distribute the original indlen reservation across the
-			 * two new extents. Steal blocks from the deleted extent
-			 * if necessary. Stealing blocks simply fudges the
-			 * fdblocks accounting in xfs_bunmapi().
-			 */
-			temp = xfs_bmap_worst_indlen(ip, got.br_blockcount);
-			temp2 = xfs_bmap_worst_indlen(ip, new.br_blockcount);
-			stolen = xfs_bmap_split_indlen(da_old, &temp, &temp2,
-						       del->br_blockcount);
-			da_new = temp + temp2 - stolen;
-			del->br_blockcount -= stolen;
-
-			/*
-			 * Set the reservation for each extent. Warn if either
-			 * is zero as this can lead to delalloc problems.
-			 */
-			WARN_ON_ONCE(!temp || !temp2);
-			xfs_bmbt_set_startblock(ep, nullstartblock((int)temp));
-			new.br_startblock = nullstartblock((int)temp2);
-		}
+				/*
+				 * Update the btree record back
+				 * to the original value.
+				 */
+				error = xfs_bmbt_update(cur, got.br_startoff,
+						got.br_startblock,
+						got.br_blockcount,
+						got.br_state);
+				if (error)
+					goto done;
+				/*
+				 * Reset the extent record back
+				 * to the original value.
+				 */
+				xfs_bmbt_set_blockcount(ep, got.br_blockcount);
+				flags = 0;
+				error = -ENOSPC;
+				goto done;
+			}
+			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
+		} else
+			flags |= xfs_ilog_fext(whichfork);
+		XFS_IFORK_NEXT_SET(ip, whichfork,
+			XFS_IFORK_NEXTENTS(ip, whichfork) + 1);
 		trace_xfs_bmap_post_update(ip, *idx, state, _THIS_IP_);
 		xfs_iext_insert(ip, *idx + 1, 1, &new, state);
 		++*idx;
@@ -5358,11 +5285,9 @@ xfs_bmap_del_extent(
 	}
 
 	/* remove reverse mapping */
-	if (!delay) {
-		error = xfs_rmap_unmap_extent(mp, dfops, ip, whichfork, del);
-		if (error)
-			goto done;
-	}
+	error = xfs_rmap_unmap_extent(mp, dfops, ip, whichfork, del);
+	if (error)
+		goto done;
 
 	/*
 	 * If we need to, add to list of extents to delete.
@@ -5388,13 +5313,6 @@ xfs_bmap_del_extent(
 	if (qfield && !(bflags & XFS_BMAPI_REMAP))
 		xfs_trans_mod_dquot_byino(tp, ip, qfield, (long)-nblks);
 
-	/*
-	 * Account for change in delayed indirect blocks.
-	 * Nothing to do for disk quota accounting here.
-	 */
-	ASSERT(da_old >= da_new);
-	if (da_old > da_new)
-		xfs_mod_fdblocks(mp, (int64_t)(da_old - da_new), false);
 done:
 	*logflagsp = flags;
 	return error;
@@ -5679,62 +5597,41 @@ __xfs_bunmapi(
 			}
 		}
 
-		/*
-		 * If it's the case where the directory code is running
-		 * with no block reservation, and the deleted block is in
-		 * the middle of its extent, and the resulting insert
-		 * of an extent would cause transformation to btree format,
-		 * then reject it.  The calling code will then swap
-		 * blocks around instead.
-		 * We have to do this now, rather than waiting for the
-		 * conversion to btree format, since the transaction
-		 * will be dirty.
-		 */
-		if (!wasdel && tp->t_blk_res == 0 &&
-		    XFS_IFORK_FORMAT(ip, whichfork) == XFS_DINODE_FMT_EXTENTS &&
-		    XFS_IFORK_NEXTENTS(ip, whichfork) >= /* Note the >= */
-			XFS_IFORK_MAXEXT(ip, whichfork) &&
-		    del.br_startoff > got.br_startoff &&
-		    del.br_startoff + del.br_blockcount <
-		    got.br_startoff + got.br_blockcount) {
-			error = -ENOSPC;
-			goto error0;
-		}
-
-		/*
-		 * Unreserve quota and update realtime free space, if
-		 * appropriate. If delayed allocation, update the inode delalloc
-		 * counter now and wait to update the sb counters as
-		 * xfs_bmap_del_extent() might need to borrow some blocks.
-		 */
 		if (wasdel) {
-			ASSERT(startblockval(del.br_startblock) > 0);
-			if (isrt) {
-				xfs_filblks_t rtexts;
-
-				rtexts = XFS_FSB_TO_B(mp, del.br_blockcount);
-				do_div(rtexts, mp->m_sb.sb_rextsize);
-				xfs_mod_frextents(mp, (int64_t)rtexts);
-				(void)xfs_trans_reserve_quota_nblks(NULL,
-					ip, -((long)del.br_blockcount), 0,
-					XFS_QMOPT_RES_RTBLKS);
-			} else {
-				(void)xfs_trans_reserve_quota_nblks(NULL,
-					ip, -((long)del.br_blockcount), 0,
-					XFS_QMOPT_RES_REGBLKS);
+			error = xfs_bmap_del_extent_delay(ip, whichfork, &lastx,
+					&got, &del);
+		} else {
+			/*
+			 * If it's the case where the directory code is running
+			 * with no block reservation, and the deleted block is
+			 * in the middle of its extent, and the resulting insert
+			 * of an extent would cause transformation to btree
+			 * format, then reject it.  The calling code will then
+			 * swap blocks around instead.  We have to do this now,
+			 * rather than waiting for the conversion to btree
+			 * format, since the transaction will be dirty.
+			 */
+			if (tp->t_blk_res == 0 &&
+			    XFS_IFORK_FORMAT(ip, whichfork) ==
+					XFS_DINODE_FMT_EXTENTS &&
+			    XFS_IFORK_NEXTENTS(ip, whichfork) >=
+					XFS_IFORK_MAXEXT(ip, whichfork) &&
+			    del.br_startoff > got.br_startoff &&
+			    del.br_startoff + del.br_blockcount <
+			    got.br_startoff + got.br_blockcount) {
+				error = -ENOSPC;
+				goto error0;
 			}
-			ip->i_delayed_blks -= del.br_blockcount;
+
+			error = xfs_bmap_del_extent_real(ip, tp, &lastx, dfops,
+					cur, &del, &tmp_logflags, whichfork,
+					flags);
+			logflags |= tmp_logflags;
 		}
 
-		error = xfs_bmap_del_extent(ip, tp, &lastx, dfops, cur, &del,
-				&tmp_logflags, whichfork, flags);
-		logflags |= tmp_logflags;
 		if (error)
 			goto error0;
 
-		if (!isrt && wasdel)
-			xfs_mod_fdblocks(mp, (int64_t)del.br_blockcount, false);
-
 		max_len -= del.br_blockcount;
 		end = del.br_startoff - 1;
 nodelete:
-- 
2.14.1

