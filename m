Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B7C9C433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Oct 2021 20:17:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 291DC610E6
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Oct 2021 20:17:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229587AbhJNUTe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 14 Oct 2021 16:19:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:35128 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230460AbhJNUTd (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 14 Oct 2021 16:19:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 446466108E;
        Thu, 14 Oct 2021 20:17:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634242648;
        bh=/4ahjCsLcySCtYZuywErQvk8kJQM01FWx5fNKDelZs0=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=eOxmFLVNc6d4DE0vK7xG9hkm8xiZdGf/gQwhhxQw/KBe/2dVkjZlzt3C4JKohZZLs
         wtJZD7StABDtsl28ebLq3L5gtAtq3ztIIpnu2GaLRmHrm6/Ch1KkQZseKAWqc8Y25D
         6srudgvB5POcgfR+YggA2VoZeVN1MEcLSnhOW7oiKOxd2NIoIuc92d8sSoy6n3nCWt
         xJj1TqpyncX57H7EbDpwMlftzCtpnT3bE4ZBVFWTMuVts0JsFgSVHCtUXeLZBP3UsB
         54y/vQESRl0PJxzMua9m1lKrxTorOe835zayQStwYGKkfMe3DODahqlPinECYxarEG
         DUiZhbudNx9Rg==
Subject: [PATCH 06/17] xfs: prepare xfs_btree_cur for dynamic cursor heights
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, david@fromorbit.com
Cc:     Chandan Babu R <chandan.babu@oracle.com>,
        Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        chandan.babu@oracle.com, hch@lst.de
Date:   Thu, 14 Oct 2021 13:17:28 -0700
Message-ID: <163424264796.756780.1894573242070893253.stgit@magnolia>
In-Reply-To: <163424261462.756780.16294781570977242370.stgit@magnolia>
References: <163424261462.756780.16294781570977242370.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Split out the btree level information into a separate struct and put it
at the end of the cursor structure as a VLA.  Files with huge data forks
(and in the future, the realtime rmap btree) will require the ability to
support many more levels than a per-AG btree cursor, which means that
we're going to create per-btree type cursor caches to conserve memory
for the more common case.

Note that a subsequent patch actually introduces dynamic cursor heights.
This one merely rearranges the structure to prepare for that.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Chandan Babu R <chandan.babu@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_alloc.c |    6 +-
 fs/xfs/libxfs/xfs_bmap.c  |   10 +--
 fs/xfs/libxfs/xfs_btree.c |  168 +++++++++++++++++++++++----------------------
 fs/xfs/libxfs/xfs_btree.h |   33 +++++++--
 fs/xfs/scrub/bitmap.c     |   22 +++---
 fs/xfs/scrub/bmap.c       |    2 -
 fs/xfs/scrub/btree.c      |   47 +++++++------
 fs/xfs/scrub/trace.c      |    4 +
 fs/xfs/scrub/trace.h      |   10 +--
 fs/xfs/xfs_super.c        |    2 -
 fs/xfs/xfs_trace.h        |    2 -
 11 files changed, 167 insertions(+), 139 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 35fb1dd3be95..55c5adc9b54e 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -488,8 +488,8 @@ xfs_alloc_fixup_trees(
 		struct xfs_btree_block	*bnoblock;
 		struct xfs_btree_block	*cntblock;
 
-		bnoblock = XFS_BUF_TO_BLOCK(bno_cur->bc_bufs[0]);
-		cntblock = XFS_BUF_TO_BLOCK(cnt_cur->bc_bufs[0]);
+		bnoblock = XFS_BUF_TO_BLOCK(bno_cur->bc_levels[0].bp);
+		cntblock = XFS_BUF_TO_BLOCK(cnt_cur->bc_levels[0].bp);
 
 		if (XFS_IS_CORRUPT(mp,
 				   bnoblock->bb_numrecs !=
@@ -1512,7 +1512,7 @@ xfs_alloc_ag_vextent_lastblock(
 	 * than minlen.
 	 */
 	if (*len || args->alignment > 1) {
-		acur->cnt->bc_ptrs[0] = 1;
+		acur->cnt->bc_levels[0].ptr = 1;
 		do {
 			error = xfs_alloc_get_rec(acur->cnt, bno, len, &i);
 			if (error)
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 499c977cbf56..644b956301b6 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -240,10 +240,10 @@ xfs_bmap_get_bp(
 		return NULL;
 
 	for (i = 0; i < XFS_BTREE_MAXLEVELS; i++) {
-		if (!cur->bc_bufs[i])
+		if (!cur->bc_levels[i].bp)
 			break;
-		if (xfs_buf_daddr(cur->bc_bufs[i]) == bno)
-			return cur->bc_bufs[i];
+		if (xfs_buf_daddr(cur->bc_levels[i].bp) == bno)
+			return cur->bc_levels[i].bp;
 	}
 
 	/* Chase down all the log items to see if the bp is there */
@@ -629,8 +629,8 @@ xfs_bmap_btree_to_extents(
 	ip->i_nblocks--;
 	xfs_trans_mod_dquot_byino(tp, ip, XFS_TRANS_DQ_BCOUNT, -1L);
 	xfs_trans_binval(tp, cbp);
-	if (cur->bc_bufs[0] == cbp)
-		cur->bc_bufs[0] = NULL;
+	if (cur->bc_levels[0].bp == cbp)
+		cur->bc_levels[0].bp = NULL;
 	xfs_iroot_realloc(ip, -1, whichfork);
 	ASSERT(ifp->if_broot == NULL);
 	ifp->if_format = XFS_DINODE_FMT_EXTENTS;
diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index bc4e49f0456a..25dfab81025f 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -367,8 +367,8 @@ xfs_btree_del_cursor(
 	 * way we won't have initialized all the entries down to 0.
 	 */
 	for (i = 0; i < cur->bc_nlevels; i++) {
-		if (cur->bc_bufs[i])
-			xfs_trans_brelse(cur->bc_tp, cur->bc_bufs[i]);
+		if (cur->bc_levels[i].bp)
+			xfs_trans_brelse(cur->bc_tp, cur->bc_levels[i].bp);
 		else if (!error)
 			break;
 	}
@@ -415,9 +415,9 @@ xfs_btree_dup_cursor(
 	 * For each level current, re-get the buffer and copy the ptr value.
 	 */
 	for (i = 0; i < new->bc_nlevels; i++) {
-		new->bc_ptrs[i] = cur->bc_ptrs[i];
-		new->bc_ra[i] = cur->bc_ra[i];
-		bp = cur->bc_bufs[i];
+		new->bc_levels[i].ptr = cur->bc_levels[i].ptr;
+		new->bc_levels[i].ra = cur->bc_levels[i].ra;
+		bp = cur->bc_levels[i].bp;
 		if (bp) {
 			error = xfs_trans_read_buf(mp, tp, mp->m_ddev_targp,
 						   xfs_buf_daddr(bp), mp->m_bsize,
@@ -429,7 +429,7 @@ xfs_btree_dup_cursor(
 				return error;
 			}
 		}
-		new->bc_bufs[i] = bp;
+		new->bc_levels[i].bp = bp;
 	}
 	*ncur = new;
 	return 0;
@@ -681,7 +681,7 @@ xfs_btree_get_block(
 		return xfs_btree_get_iroot(cur);
 	}
 
-	*bpp = cur->bc_bufs[level];
+	*bpp = cur->bc_levels[level].bp;
 	return XFS_BUF_TO_BLOCK(*bpp);
 }
 
@@ -711,7 +711,7 @@ xfs_btree_firstrec(
 	/*
 	 * Set the ptr value to 1, that's the first record/key.
 	 */
-	cur->bc_ptrs[level] = 1;
+	cur->bc_levels[level].ptr = 1;
 	return 1;
 }
 
@@ -741,7 +741,7 @@ xfs_btree_lastrec(
 	/*
 	 * Set the ptr value to numrecs, that's the last record/key.
 	 */
-	cur->bc_ptrs[level] = be16_to_cpu(block->bb_numrecs);
+	cur->bc_levels[level].ptr = be16_to_cpu(block->bb_numrecs);
 	return 1;
 }
 
@@ -922,11 +922,11 @@ xfs_btree_readahead(
 	    (lev == cur->bc_nlevels - 1))
 		return 0;
 
-	if ((cur->bc_ra[lev] | lr) == cur->bc_ra[lev])
+	if ((cur->bc_levels[lev].ra | lr) == cur->bc_levels[lev].ra)
 		return 0;
 
-	cur->bc_ra[lev] |= lr;
-	block = XFS_BUF_TO_BLOCK(cur->bc_bufs[lev]);
+	cur->bc_levels[lev].ra |= lr;
+	block = XFS_BUF_TO_BLOCK(cur->bc_levels[lev].bp);
 
 	if (cur->bc_flags & XFS_BTREE_LONG_PTRS)
 		return xfs_btree_readahead_lblock(cur, lr, block);
@@ -991,22 +991,22 @@ xfs_btree_setbuf(
 {
 	struct xfs_btree_block	*b;	/* btree block */
 
-	if (cur->bc_bufs[lev])
-		xfs_trans_brelse(cur->bc_tp, cur->bc_bufs[lev]);
-	cur->bc_bufs[lev] = bp;
-	cur->bc_ra[lev] = 0;
+	if (cur->bc_levels[lev].bp)
+		xfs_trans_brelse(cur->bc_tp, cur->bc_levels[lev].bp);
+	cur->bc_levels[lev].bp = bp;
+	cur->bc_levels[lev].ra = 0;
 
 	b = XFS_BUF_TO_BLOCK(bp);
 	if (cur->bc_flags & XFS_BTREE_LONG_PTRS) {
 		if (b->bb_u.l.bb_leftsib == cpu_to_be64(NULLFSBLOCK))
-			cur->bc_ra[lev] |= XFS_BTCUR_LEFTRA;
+			cur->bc_levels[lev].ra |= XFS_BTCUR_LEFTRA;
 		if (b->bb_u.l.bb_rightsib == cpu_to_be64(NULLFSBLOCK))
-			cur->bc_ra[lev] |= XFS_BTCUR_RIGHTRA;
+			cur->bc_levels[lev].ra |= XFS_BTCUR_RIGHTRA;
 	} else {
 		if (b->bb_u.s.bb_leftsib == cpu_to_be32(NULLAGBLOCK))
-			cur->bc_ra[lev] |= XFS_BTCUR_LEFTRA;
+			cur->bc_levels[lev].ra |= XFS_BTCUR_LEFTRA;
 		if (b->bb_u.s.bb_rightsib == cpu_to_be32(NULLAGBLOCK))
-			cur->bc_ra[lev] |= XFS_BTCUR_RIGHTRA;
+			cur->bc_levels[lev].ra |= XFS_BTCUR_RIGHTRA;
 	}
 }
 
@@ -1548,7 +1548,7 @@ xfs_btree_increment(
 #endif
 
 	/* We're done if we remain in the block after the increment. */
-	if (++cur->bc_ptrs[level] <= xfs_btree_get_numrecs(block))
+	if (++cur->bc_levels[level].ptr <= xfs_btree_get_numrecs(block))
 		goto out1;
 
 	/* Fail if we just went off the right edge of the tree. */
@@ -1571,7 +1571,7 @@ xfs_btree_increment(
 			goto error0;
 #endif
 
-		if (++cur->bc_ptrs[lev] <= xfs_btree_get_numrecs(block))
+		if (++cur->bc_levels[lev].ptr <= xfs_btree_get_numrecs(block))
 			break;
 
 		/* Read-ahead the right block for the next loop. */
@@ -1598,14 +1598,14 @@ xfs_btree_increment(
 	for (block = xfs_btree_get_block(cur, lev, &bp); lev > level; ) {
 		union xfs_btree_ptr	*ptrp;
 
-		ptrp = xfs_btree_ptr_addr(cur, cur->bc_ptrs[lev], block);
+		ptrp = xfs_btree_ptr_addr(cur, cur->bc_levels[lev].ptr, block);
 		--lev;
 		error = xfs_btree_read_buf_block(cur, ptrp, 0, &block, &bp);
 		if (error)
 			goto error0;
 
 		xfs_btree_setbuf(cur, lev, bp);
-		cur->bc_ptrs[lev] = 1;
+		cur->bc_levels[lev].ptr = 1;
 	}
 out1:
 	*stat = 1;
@@ -1641,7 +1641,7 @@ xfs_btree_decrement(
 	xfs_btree_readahead(cur, level, XFS_BTCUR_LEFTRA);
 
 	/* We're done if we remain in the block after the decrement. */
-	if (--cur->bc_ptrs[level] > 0)
+	if (--cur->bc_levels[level].ptr > 0)
 		goto out1;
 
 	/* Get a pointer to the btree block. */
@@ -1665,7 +1665,7 @@ xfs_btree_decrement(
 	 * Stop when we don't go off the left edge of a block.
 	 */
 	for (lev = level + 1; lev < cur->bc_nlevels; lev++) {
-		if (--cur->bc_ptrs[lev] > 0)
+		if (--cur->bc_levels[lev].ptr > 0)
 			break;
 		/* Read-ahead the left block for the next loop. */
 		xfs_btree_readahead(cur, lev, XFS_BTCUR_LEFTRA);
@@ -1691,13 +1691,13 @@ xfs_btree_decrement(
 	for (block = xfs_btree_get_block(cur, lev, &bp); lev > level; ) {
 		union xfs_btree_ptr	*ptrp;
 
-		ptrp = xfs_btree_ptr_addr(cur, cur->bc_ptrs[lev], block);
+		ptrp = xfs_btree_ptr_addr(cur, cur->bc_levels[lev].ptr, block);
 		--lev;
 		error = xfs_btree_read_buf_block(cur, ptrp, 0, &block, &bp);
 		if (error)
 			goto error0;
 		xfs_btree_setbuf(cur, lev, bp);
-		cur->bc_ptrs[lev] = xfs_btree_get_numrecs(block);
+		cur->bc_levels[lev].ptr = xfs_btree_get_numrecs(block);
 	}
 out1:
 	*stat = 1;
@@ -1735,7 +1735,7 @@ xfs_btree_lookup_get_block(
 	 *
 	 * Otherwise throw it away and get a new one.
 	 */
-	bp = cur->bc_bufs[level];
+	bp = cur->bc_levels[level].bp;
 	error = xfs_btree_ptr_to_daddr(cur, pp, &daddr);
 	if (error)
 		return error;
@@ -1864,7 +1864,7 @@ xfs_btree_lookup(
 					return -EFSCORRUPTED;
 				}
 
-				cur->bc_ptrs[0] = dir != XFS_LOOKUP_LE;
+				cur->bc_levels[0].ptr = dir != XFS_LOOKUP_LE;
 				*stat = 0;
 				return 0;
 			}
@@ -1916,7 +1916,7 @@ xfs_btree_lookup(
 			if (error)
 				goto error0;
 
-			cur->bc_ptrs[level] = keyno;
+			cur->bc_levels[level].ptr = keyno;
 		}
 	}
 
@@ -1933,7 +1933,7 @@ xfs_btree_lookup(
 		    !xfs_btree_ptr_is_null(cur, &ptr)) {
 			int	i;
 
-			cur->bc_ptrs[0] = keyno;
+			cur->bc_levels[0].ptr = keyno;
 			error = xfs_btree_increment(cur, 0, &i);
 			if (error)
 				goto error0;
@@ -1944,7 +1944,7 @@ xfs_btree_lookup(
 		}
 	} else if (dir == XFS_LOOKUP_LE && diff > 0)
 		keyno--;
-	cur->bc_ptrs[0] = keyno;
+	cur->bc_levels[0].ptr = keyno;
 
 	/* Return if we succeeded or not. */
 	if (keyno == 0 || keyno > xfs_btree_get_numrecs(block))
@@ -2104,7 +2104,7 @@ __xfs_btree_updkeys(
 		if (error)
 			return error;
 #endif
-		ptr = cur->bc_ptrs[level];
+		ptr = cur->bc_levels[level].ptr;
 		nlkey = xfs_btree_key_addr(cur, ptr, block);
 		nhkey = xfs_btree_high_key_addr(cur, ptr, block);
 		if (!force_all &&
@@ -2171,7 +2171,7 @@ xfs_btree_update_keys(
 		if (error)
 			return error;
 #endif
-		ptr = cur->bc_ptrs[level];
+		ptr = cur->bc_levels[level].ptr;
 		kp = xfs_btree_key_addr(cur, ptr, block);
 		xfs_btree_copy_keys(cur, kp, &key, 1);
 		xfs_btree_log_keys(cur, bp, ptr, ptr);
@@ -2205,7 +2205,7 @@ xfs_btree_update(
 		goto error0;
 #endif
 	/* Get the address of the rec to be updated. */
-	ptr = cur->bc_ptrs[0];
+	ptr = cur->bc_levels[0].ptr;
 	rp = xfs_btree_rec_addr(cur, ptr, block);
 
 	/* Fill in the new contents and log them. */
@@ -2280,7 +2280,7 @@ xfs_btree_lshift(
 	 * If the cursor entry is the one that would be moved, don't
 	 * do it... it's too complicated.
 	 */
-	if (cur->bc_ptrs[level] <= 1)
+	if (cur->bc_levels[level].ptr <= 1)
 		goto out0;
 
 	/* Set up the left neighbor as "left". */
@@ -2414,7 +2414,7 @@ xfs_btree_lshift(
 		goto error0;
 
 	/* Slide the cursor value left one. */
-	cur->bc_ptrs[level]--;
+	cur->bc_levels[level].ptr--;
 
 	*stat = 1;
 	return 0;
@@ -2476,7 +2476,7 @@ xfs_btree_rshift(
 	 * do it... it's too complicated.
 	 */
 	lrecs = xfs_btree_get_numrecs(left);
-	if (cur->bc_ptrs[level] >= lrecs)
+	if (cur->bc_levels[level].ptr >= lrecs)
 		goto out0;
 
 	/* Set up the right neighbor as "right". */
@@ -2664,7 +2664,7 @@ __xfs_btree_split(
 	 */
 	lrecs = xfs_btree_get_numrecs(left);
 	rrecs = lrecs / 2;
-	if ((lrecs & 1) && cur->bc_ptrs[level] <= rrecs + 1)
+	if ((lrecs & 1) && cur->bc_levels[level].ptr <= rrecs + 1)
 		rrecs++;
 	src_index = (lrecs - rrecs + 1);
 
@@ -2760,9 +2760,9 @@ __xfs_btree_split(
 	 * If it's just pointing past the last entry in left, then we'll
 	 * insert there, so don't change anything in that case.
 	 */
-	if (cur->bc_ptrs[level] > lrecs + 1) {
+	if (cur->bc_levels[level].ptr > lrecs + 1) {
 		xfs_btree_setbuf(cur, level, rbp);
-		cur->bc_ptrs[level] -= lrecs;
+		cur->bc_levels[level].ptr -= lrecs;
 	}
 	/*
 	 * If there are more levels, we'll need another cursor which refers
@@ -2772,7 +2772,7 @@ __xfs_btree_split(
 		error = xfs_btree_dup_cursor(cur, curp);
 		if (error)
 			goto error0;
-		(*curp)->bc_ptrs[level + 1]++;
+		(*curp)->bc_levels[level + 1].ptr++;
 	}
 	*ptrp = rptr;
 	*stat = 1;
@@ -2934,7 +2934,7 @@ xfs_btree_new_iroot(
 	xfs_btree_set_numrecs(block, 1);
 	cur->bc_nlevels++;
 	ASSERT(cur->bc_nlevels <= XFS_BTREE_MAXLEVELS);
-	cur->bc_ptrs[level + 1] = 1;
+	cur->bc_levels[level + 1].ptr = 1;
 
 	kp = xfs_btree_key_addr(cur, 1, block);
 	ckp = xfs_btree_key_addr(cur, 1, cblock);
@@ -3095,7 +3095,7 @@ xfs_btree_new_root(
 
 	/* Fix up the cursor. */
 	xfs_btree_setbuf(cur, cur->bc_nlevels, nbp);
-	cur->bc_ptrs[cur->bc_nlevels] = nptr;
+	cur->bc_levels[cur->bc_nlevels].ptr = nptr;
 	cur->bc_nlevels++;
 	ASSERT(cur->bc_nlevels <= XFS_BTREE_MAXLEVELS);
 	*stat = 1;
@@ -3154,7 +3154,7 @@ xfs_btree_make_block_unfull(
 		return error;
 
 	if (*stat) {
-		*oindex = *index = cur->bc_ptrs[level];
+		*oindex = *index = cur->bc_levels[level].ptr;
 		return 0;
 	}
 
@@ -3169,7 +3169,7 @@ xfs_btree_make_block_unfull(
 		return error;
 
 
-	*index = cur->bc_ptrs[level];
+	*index = cur->bc_levels[level].ptr;
 	return 0;
 }
 
@@ -3216,7 +3216,7 @@ xfs_btree_insrec(
 	}
 
 	/* If we're off the left edge, return failure. */
-	ptr = cur->bc_ptrs[level];
+	ptr = cur->bc_levels[level].ptr;
 	if (ptr == 0) {
 		*stat = 0;
 		return 0;
@@ -3559,7 +3559,7 @@ xfs_btree_kill_iroot(
 	if (error)
 		return error;
 
-	cur->bc_bufs[level - 1] = NULL;
+	cur->bc_levels[level - 1].bp = NULL;
 	be16_add_cpu(&block->bb_level, -1);
 	xfs_trans_log_inode(cur->bc_tp, ip,
 		XFS_ILOG_CORE | xfs_ilog_fbroot(cur->bc_ino.whichfork));
@@ -3592,8 +3592,8 @@ xfs_btree_kill_root(
 	if (error)
 		return error;
 
-	cur->bc_bufs[level] = NULL;
-	cur->bc_ra[level] = 0;
+	cur->bc_levels[level].bp = NULL;
+	cur->bc_levels[level].ra = 0;
 	cur->bc_nlevels--;
 
 	return 0;
@@ -3652,7 +3652,7 @@ xfs_btree_delrec(
 	tcur = NULL;
 
 	/* Get the index of the entry being deleted, check for nothing there. */
-	ptr = cur->bc_ptrs[level];
+	ptr = cur->bc_levels[level].ptr;
 	if (ptr == 0) {
 		*stat = 0;
 		return 0;
@@ -3962,7 +3962,7 @@ xfs_btree_delrec(
 				xfs_btree_del_cursor(tcur, XFS_BTREE_NOERROR);
 				tcur = NULL;
 				if (level == 0)
-					cur->bc_ptrs[0]++;
+					cur->bc_levels[0].ptr++;
 
 				*stat = 1;
 				return 0;
@@ -4099,9 +4099,9 @@ xfs_btree_delrec(
 	 * cursor to the left block, and fix up the index.
 	 */
 	if (bp != lbp) {
-		cur->bc_bufs[level] = lbp;
-		cur->bc_ptrs[level] += lrecs;
-		cur->bc_ra[level] = 0;
+		cur->bc_levels[level].bp = lbp;
+		cur->bc_levels[level].ptr += lrecs;
+		cur->bc_levels[level].ra = 0;
 	}
 	/*
 	 * If we joined with the right neighbor and there's a level above
@@ -4121,16 +4121,16 @@ xfs_btree_delrec(
 	 * We can't use decrement because it would change the next level up.
 	 */
 	if (level > 0)
-		cur->bc_ptrs[level]--;
+		cur->bc_levels[level].ptr--;
 
 	/*
 	 * We combined blocks, so we have to update the parent keys if the
-	 * btree supports overlapped intervals.  However, bc_ptrs[level + 1]
-	 * points to the old block so that the caller knows which record to
-	 * delete.  Therefore, the caller must be savvy enough to call updkeys
-	 * for us if we return stat == 2.  The other exit points from this
-	 * function don't require deletions further up the tree, so they can
-	 * call updkeys directly.
+	 * btree supports overlapped intervals.  However,
+	 * bc_levels[level + 1].ptr points to the old block so that the caller
+	 * knows which record to delete.  Therefore, the caller must be savvy
+	 * enough to call updkeys for us if we return stat == 2.  The other
+	 * exit points from this function don't require deletions further up
+	 * the tree, so they can call updkeys directly.
 	 */
 
 	/* Return value means the next level up has something to do. */
@@ -4184,7 +4184,7 @@ xfs_btree_delete(
 
 	if (i == 0) {
 		for (level = 1; level < cur->bc_nlevels; level++) {
-			if (cur->bc_ptrs[level] == 0) {
+			if (cur->bc_levels[level].ptr == 0) {
 				error = xfs_btree_decrement(cur, level, &i);
 				if (error)
 					goto error0;
@@ -4215,7 +4215,7 @@ xfs_btree_get_rec(
 	int			error;	/* error return value */
 #endif
 
-	ptr = cur->bc_ptrs[0];
+	ptr = cur->bc_levels[0].ptr;
 	block = xfs_btree_get_block(cur, 0, &bp);
 
 #ifdef DEBUG
@@ -4663,23 +4663,25 @@ xfs_btree_overlapped_query_range(
 	if (error)
 		goto out;
 #endif
-	cur->bc_ptrs[level] = 1;
+	cur->bc_levels[level].ptr = 1;
 
 	while (level < cur->bc_nlevels) {
 		block = xfs_btree_get_block(cur, level, &bp);
 
 		/* End of node, pop back towards the root. */
-		if (cur->bc_ptrs[level] > be16_to_cpu(block->bb_numrecs)) {
+		if (cur->bc_levels[level].ptr >
+					be16_to_cpu(block->bb_numrecs)) {
 pop_up:
 			if (level < cur->bc_nlevels - 1)
-				cur->bc_ptrs[level + 1]++;
+				cur->bc_levels[level + 1].ptr++;
 			level++;
 			continue;
 		}
 
 		if (level == 0) {
 			/* Handle a leaf node. */
-			recp = xfs_btree_rec_addr(cur, cur->bc_ptrs[0], block);
+			recp = xfs_btree_rec_addr(cur, cur->bc_levels[0].ptr,
+					block);
 
 			cur->bc_ops->init_high_key_from_rec(&rec_hkey, recp);
 			ldiff = cur->bc_ops->diff_two_keys(cur, &rec_hkey,
@@ -4702,14 +4704,15 @@ xfs_btree_overlapped_query_range(
 				/* Record is larger than high key; pop. */
 				goto pop_up;
 			}
-			cur->bc_ptrs[level]++;
+			cur->bc_levels[level].ptr++;
 			continue;
 		}
 
 		/* Handle an internal node. */
-		lkp = xfs_btree_key_addr(cur, cur->bc_ptrs[level], block);
-		hkp = xfs_btree_high_key_addr(cur, cur->bc_ptrs[level], block);
-		pp = xfs_btree_ptr_addr(cur, cur->bc_ptrs[level], block);
+		lkp = xfs_btree_key_addr(cur, cur->bc_levels[level].ptr, block);
+		hkp = xfs_btree_high_key_addr(cur, cur->bc_levels[level].ptr,
+				block);
+		pp = xfs_btree_ptr_addr(cur, cur->bc_levels[level].ptr, block);
 
 		ldiff = cur->bc_ops->diff_two_keys(cur, hkp, low_key);
 		hdiff = cur->bc_ops->diff_two_keys(cur, high_key, lkp);
@@ -4732,13 +4735,13 @@ xfs_btree_overlapped_query_range(
 			if (error)
 				goto out;
 #endif
-			cur->bc_ptrs[level] = 1;
+			cur->bc_levels[level].ptr = 1;
 			continue;
 		} else if (hdiff < 0) {
 			/* The low key is larger than the upper range; pop. */
 			goto pop_up;
 		}
-		cur->bc_ptrs[level]++;
+		cur->bc_levels[level].ptr++;
 	}
 
 out:
@@ -4749,13 +4752,14 @@ xfs_btree_overlapped_query_range(
 	 * with a zero-results range query, so release the buffers if we
 	 * failed to return any results.
 	 */
-	if (cur->bc_bufs[0] == NULL) {
+	if (cur->bc_levels[0].bp == NULL) {
 		for (i = 0; i < cur->bc_nlevels; i++) {
-			if (cur->bc_bufs[i]) {
-				xfs_trans_brelse(cur->bc_tp, cur->bc_bufs[i]);
-				cur->bc_bufs[i] = NULL;
-				cur->bc_ptrs[i] = 0;
-				cur->bc_ra[i] = 0;
+			if (cur->bc_levels[i].bp) {
+				xfs_trans_brelse(cur->bc_tp,
+						cur->bc_levels[i].bp);
+				cur->bc_levels[i].bp = NULL;
+				cur->bc_levels[i].ptr = 0;
+				cur->bc_levels[i].ra = 0;
 			}
 		}
 	}
@@ -4917,7 +4921,7 @@ xfs_btree_has_more_records(
 	block = xfs_btree_get_block(cur, 0, &bp);
 
 	/* There are still records in this block. */
-	if (cur->bc_ptrs[0] < xfs_btree_get_numrecs(block))
+	if (cur->bc_levels[0].ptr < xfs_btree_get_numrecs(block))
 		return true;
 
 	/* There are more record blocks. */
diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
index 1018bcc43d66..0181fc98bc12 100644
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
@@ -212,6 +212,19 @@ struct xfs_btree_cur_ino {
 #define	XFS_BTCUR_BMBT_INVALID_OWNER	(1 << 1)
 };
 
+struct xfs_btree_level {
+	/* buffer pointer */
+	struct xfs_buf		*bp;
+
+	/* key/record number */
+	uint16_t		ptr;
+
+	/* readahead info */
+#define XFS_BTCUR_LEFTRA	(1 << 0) /* left sibling has been read-ahead */
+#define XFS_BTCUR_RIGHTRA	(1 << 1) /* right sibling has been read-ahead */
+	uint16_t		ra;
+};
+
 /*
  * Btree cursor structure.
  * This collects all information needed by the btree code in one place.
@@ -223,11 +236,6 @@ struct xfs_btree_cur
 	const struct xfs_btree_ops *bc_ops;
 	uint			bc_flags; /* btree features - below */
 	union xfs_btree_irec	bc_rec;	/* current insert/search record value */
-	struct xfs_buf	*bc_bufs[XFS_BTREE_MAXLEVELS];	/* buf ptr per level */
-	int		bc_ptrs[XFS_BTREE_MAXLEVELS];	/* key/record # */
-	uint8_t		bc_ra[XFS_BTREE_MAXLEVELS];	/* readahead bits */
-#define	XFS_BTCUR_LEFTRA	1	/* left sibling has been read-ahead */
-#define	XFS_BTCUR_RIGHTRA	2	/* right sibling has been read-ahead */
 	uint8_t		bc_nlevels;	/* number of levels in the tree */
 	xfs_btnum_t	bc_btnum;	/* identifies which btree type */
 	int		bc_statoff;	/* offset of btre stats array */
@@ -242,8 +250,22 @@ struct xfs_btree_cur
 		struct xfs_btree_cur_ag	bc_ag;
 		struct xfs_btree_cur_ino bc_ino;
 	};
+
+	/* Must be at the end of the struct! */
+	struct xfs_btree_level	bc_levels[];
 };
 
+/*
+ * Compute the size of a btree cursor that can handle a btree of a given
+ * height.  The bc_levels array handles node and leaf blocks, so its size
+ * is exactly nlevels.
+ */
+static inline size_t
+xfs_btree_cur_sizeof(unsigned int nlevels)
+{
+	return struct_size((struct xfs_btree_cur *)NULL, bc_levels, nlevels);
+}
+
 /* cursor flags */
 #define XFS_BTREE_LONG_PTRS		(1<<0)	/* pointers are 64bits long */
 #define XFS_BTREE_ROOT_IN_INODE		(1<<1)	/* root may be variable size */
@@ -257,7 +279,6 @@ struct xfs_btree_cur
  */
 #define XFS_BTREE_STAGING		(1<<5)
 
-
 #define	XFS_BTREE_NOERROR	0
 #define	XFS_BTREE_ERROR		1
 
diff --git a/fs/xfs/scrub/bitmap.c b/fs/xfs/scrub/bitmap.c
index d6d24c866bc4..b89bf9de9b1c 100644
--- a/fs/xfs/scrub/bitmap.c
+++ b/fs/xfs/scrub/bitmap.c
@@ -222,21 +222,21 @@ xbitmap_disunion(
  * 1  2  3
  *
  * Pretend for this example that each leaf block has 100 btree records.  For
- * the first btree record, we'll observe that bc_ptrs[0] == 1, so we record
- * that we saw block 1.  Then we observe that bc_ptrs[1] == 1, so we record
- * block 4.  The list is [1, 4].
+ * the first btree record, we'll observe that bc_levels[0].ptr == 1, so we
+ * record that we saw block 1.  Then we observe that bc_levels[1].ptr == 1, so
+ * we record block 4.  The list is [1, 4].
  *
- * For the second btree record, we see that bc_ptrs[0] == 2, so we exit the
- * loop.  The list remains [1, 4].
+ * For the second btree record, we see that bc_levels[0].ptr == 2, so we exit
+ * the loop.  The list remains [1, 4].
  *
  * For the 101st btree record, we've moved onto leaf block 2.  Now
- * bc_ptrs[0] == 1 again, so we record that we saw block 2.  We see that
- * bc_ptrs[1] == 2, so we exit the loop.  The list is now [1, 4, 2].
+ * bc_levels[0].ptr == 1 again, so we record that we saw block 2.  We see that
+ * bc_levels[1].ptr == 2, so we exit the loop.  The list is now [1, 4, 2].
  *
- * For the 102nd record, bc_ptrs[0] == 2, so we continue.
+ * For the 102nd record, bc_levels[0].ptr == 2, so we continue.
  *
- * For the 201st record, we've moved on to leaf block 3.  bc_ptrs[0] == 1, so
- * we add 3 to the list.  Now it is [1, 4, 2, 3].
+ * For the 201st record, we've moved on to leaf block 3.
+ * bc_levels[0].ptr == 1, so we add 3 to the list.  Now it is [1, 4, 2, 3].
  *
  * For the 300th record we just exit, with the list being [1, 4, 2, 3].
  */
@@ -256,7 +256,7 @@ xbitmap_set_btcur_path(
 	int			i;
 	int			error;
 
-	for (i = 0; i < cur->bc_nlevels && cur->bc_ptrs[i] == 1; i++) {
+	for (i = 0; i < cur->bc_nlevels && cur->bc_levels[i].ptr == 1; i++) {
 		xfs_btree_get_block(cur, i, &bp);
 		if (!bp)
 			continue;
diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
index 017da9ceaee9..a4cbbc346f60 100644
--- a/fs/xfs/scrub/bmap.c
+++ b/fs/xfs/scrub/bmap.c
@@ -402,7 +402,7 @@ xchk_bmapbt_rec(
 	 * the root since the verifiers don't do that.
 	 */
 	if (xfs_has_crc(bs->cur->bc_mp) &&
-	    bs->cur->bc_ptrs[0] == 1) {
+	    bs->cur->bc_levels[0].ptr == 1) {
 		for (i = 0; i < bs->cur->bc_nlevels - 1; i++) {
 			block = xfs_btree_get_block(bs->cur, i, &bp);
 			owner = be64_to_cpu(block->bb_u.l.bb_owner);
diff --git a/fs/xfs/scrub/btree.c b/fs/xfs/scrub/btree.c
index 6d4eba85ef77..39dd46f038fe 100644
--- a/fs/xfs/scrub/btree.c
+++ b/fs/xfs/scrub/btree.c
@@ -136,12 +136,12 @@ xchk_btree_rec(
 	struct xfs_buf		*bp;
 
 	block = xfs_btree_get_block(cur, 0, &bp);
-	rec = xfs_btree_rec_addr(cur, cur->bc_ptrs[0], block);
+	rec = xfs_btree_rec_addr(cur, cur->bc_levels[0].ptr, block);
 
 	trace_xchk_btree_rec(bs->sc, cur, 0);
 
 	/* If this isn't the first record, are they in order? */
-	if (cur->bc_ptrs[0] > 1 &&
+	if (cur->bc_levels[0].ptr > 1 &&
 	    !cur->bc_ops->recs_inorder(cur, &bs->lastrec, rec))
 		xchk_btree_set_corrupt(bs->sc, cur, 0);
 	memcpy(&bs->lastrec, rec, cur->bc_ops->rec_len);
@@ -152,7 +152,7 @@ xchk_btree_rec(
 	/* Is this at least as large as the parent low key? */
 	cur->bc_ops->init_key_from_rec(&key, rec);
 	keyblock = xfs_btree_get_block(cur, 1, &bp);
-	keyp = xfs_btree_key_addr(cur, cur->bc_ptrs[1], keyblock);
+	keyp = xfs_btree_key_addr(cur, cur->bc_levels[1].ptr, keyblock);
 	if (cur->bc_ops->diff_two_keys(cur, &key, keyp) < 0)
 		xchk_btree_set_corrupt(bs->sc, cur, 1);
 
@@ -161,7 +161,7 @@ xchk_btree_rec(
 
 	/* Is this no larger than the parent high key? */
 	cur->bc_ops->init_high_key_from_rec(&hkey, rec);
-	keyp = xfs_btree_high_key_addr(cur, cur->bc_ptrs[1], keyblock);
+	keyp = xfs_btree_high_key_addr(cur, cur->bc_levels[1].ptr, keyblock);
 	if (cur->bc_ops->diff_two_keys(cur, keyp, &hkey) < 0)
 		xchk_btree_set_corrupt(bs->sc, cur, 1);
 }
@@ -183,12 +183,12 @@ xchk_btree_key(
 	struct xfs_buf		*bp;
 
 	block = xfs_btree_get_block(cur, level, &bp);
-	key = xfs_btree_key_addr(cur, cur->bc_ptrs[level], block);
+	key = xfs_btree_key_addr(cur, cur->bc_levels[level].ptr, block);
 
 	trace_xchk_btree_key(bs->sc, cur, level);
 
 	/* If this isn't the first key, are they in order? */
-	if (cur->bc_ptrs[level] > 1 &&
+	if (cur->bc_levels[level].ptr > 1 &&
 	    !cur->bc_ops->keys_inorder(cur, &bs->lastkey[level - 1], key))
 		xchk_btree_set_corrupt(bs->sc, cur, level);
 	memcpy(&bs->lastkey[level - 1], key, cur->bc_ops->key_len);
@@ -198,7 +198,7 @@ xchk_btree_key(
 
 	/* Is this at least as large as the parent low key? */
 	keyblock = xfs_btree_get_block(cur, level + 1, &bp);
-	keyp = xfs_btree_key_addr(cur, cur->bc_ptrs[level + 1], keyblock);
+	keyp = xfs_btree_key_addr(cur, cur->bc_levels[level + 1].ptr, keyblock);
 	if (cur->bc_ops->diff_two_keys(cur, key, keyp) < 0)
 		xchk_btree_set_corrupt(bs->sc, cur, level);
 
@@ -206,8 +206,9 @@ xchk_btree_key(
 		return;
 
 	/* Is this no larger than the parent high key? */
-	key = xfs_btree_high_key_addr(cur, cur->bc_ptrs[level], block);
-	keyp = xfs_btree_high_key_addr(cur, cur->bc_ptrs[level + 1], keyblock);
+	key = xfs_btree_high_key_addr(cur, cur->bc_levels[level].ptr, block);
+	keyp = xfs_btree_high_key_addr(cur, cur->bc_levels[level + 1].ptr,
+			keyblock);
 	if (cur->bc_ops->diff_two_keys(cur, keyp, key) < 0)
 		xchk_btree_set_corrupt(bs->sc, cur, level);
 }
@@ -290,7 +291,7 @@ xchk_btree_block_check_sibling(
 
 	/* Compare upper level pointer to sibling pointer. */
 	pblock = xfs_btree_get_block(ncur, level + 1, &pbp);
-	pp = xfs_btree_ptr_addr(ncur, ncur->bc_ptrs[level + 1], pblock);
+	pp = xfs_btree_ptr_addr(ncur, ncur->bc_levels[level + 1].ptr, pblock);
 	if (!xchk_btree_ptr_ok(bs, level + 1, pp))
 		goto out;
 	if (pbp)
@@ -595,7 +596,7 @@ xchk_btree_block_keys(
 
 	/* Obtain the parent's copy of the keys for this block. */
 	parent_block = xfs_btree_get_block(cur, level + 1, &bp);
-	parent_keys = xfs_btree_key_addr(cur, cur->bc_ptrs[level + 1],
+	parent_keys = xfs_btree_key_addr(cur, cur->bc_levels[level + 1].ptr,
 			parent_block);
 
 	if (cur->bc_ops->diff_two_keys(cur, &block_keys, parent_keys) != 0)
@@ -606,7 +607,7 @@ xchk_btree_block_keys(
 
 	/* Get high keys */
 	high_bk = xfs_btree_high_key_from_key(cur, &block_keys);
-	high_pk = xfs_btree_high_key_addr(cur, cur->bc_ptrs[level + 1],
+	high_pk = xfs_btree_high_key_addr(cur, cur->bc_levels[level + 1].ptr,
 			parent_block);
 
 	if (cur->bc_ops->diff_two_keys(cur, high_bk, high_pk) != 0)
@@ -672,18 +673,18 @@ xchk_btree(
 	if (error || !block)
 		goto out;
 
-	cur->bc_ptrs[level] = 1;
+	cur->bc_levels[level].ptr = 1;
 
 	while (level < cur->bc_nlevels) {
 		block = xfs_btree_get_block(cur, level, &bp);
 
 		if (level == 0) {
 			/* End of leaf, pop back towards the root. */
-			if (cur->bc_ptrs[level] >
+			if (cur->bc_levels[level].ptr >
 			    be16_to_cpu(block->bb_numrecs)) {
 				xchk_btree_block_keys(bs, level, block);
 				if (level < cur->bc_nlevels - 1)
-					cur->bc_ptrs[level + 1]++;
+					cur->bc_levels[level + 1].ptr++;
 				level++;
 				continue;
 			}
@@ -692,7 +693,8 @@ xchk_btree(
 			xchk_btree_rec(bs);
 
 			/* Call out to the record checker. */
-			recp = xfs_btree_rec_addr(cur, cur->bc_ptrs[0], block);
+			recp = xfs_btree_rec_addr(cur, cur->bc_levels[0].ptr,
+					block);
 			error = bs->scrub_rec(bs, recp);
 			if (error)
 				break;
@@ -700,15 +702,16 @@ xchk_btree(
 			    (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT))
 				break;
 
-			cur->bc_ptrs[level]++;
+			cur->bc_levels[level].ptr++;
 			continue;
 		}
 
 		/* End of node, pop back towards the root. */
-		if (cur->bc_ptrs[level] > be16_to_cpu(block->bb_numrecs)) {
+		if (cur->bc_levels[level].ptr >
+					be16_to_cpu(block->bb_numrecs)) {
 			xchk_btree_block_keys(bs, level, block);
 			if (level < cur->bc_nlevels - 1)
-				cur->bc_ptrs[level + 1]++;
+				cur->bc_levels[level + 1].ptr++;
 			level++;
 			continue;
 		}
@@ -717,9 +720,9 @@ xchk_btree(
 		xchk_btree_key(bs, level);
 
 		/* Drill another level deeper. */
-		pp = xfs_btree_ptr_addr(cur, cur->bc_ptrs[level], block);
+		pp = xfs_btree_ptr_addr(cur, cur->bc_levels[level].ptr, block);
 		if (!xchk_btree_ptr_ok(bs, level, pp)) {
-			cur->bc_ptrs[level]++;
+			cur->bc_levels[level].ptr++;
 			continue;
 		}
 		level--;
@@ -727,7 +730,7 @@ xchk_btree(
 		if (error || !block)
 			goto out;
 
-		cur->bc_ptrs[level] = 1;
+		cur->bc_levels[level].ptr = 1;
 	}
 
 out:
diff --git a/fs/xfs/scrub/trace.c b/fs/xfs/scrub/trace.c
index 93c13763c15e..b5f94676c37c 100644
--- a/fs/xfs/scrub/trace.c
+++ b/fs/xfs/scrub/trace.c
@@ -21,9 +21,9 @@ xchk_btree_cur_fsbno(
 	struct xfs_btree_cur	*cur,
 	int			level)
 {
-	if (level < cur->bc_nlevels && cur->bc_bufs[level])
+	if (level < cur->bc_nlevels && cur->bc_levels[level].bp)
 		return XFS_DADDR_TO_FSB(cur->bc_mp,
-				xfs_buf_daddr(cur->bc_bufs[level]));
+				xfs_buf_daddr(cur->bc_levels[level].bp));
 
 	if (level == cur->bc_nlevels - 1 &&
 	    (cur->bc_flags & XFS_BTREE_ROOT_IN_INODE))
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index a7bbb84f91a7..93ece6df02e3 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -348,7 +348,7 @@ TRACE_EVENT(xchk_btree_op_error,
 		__entry->level = level;
 		__entry->agno = XFS_FSB_TO_AGNO(cur->bc_mp, fsbno);
 		__entry->bno = XFS_FSB_TO_AGBNO(cur->bc_mp, fsbno);
-		__entry->ptr = cur->bc_ptrs[level];
+		__entry->ptr = cur->bc_levels[level].ptr;
 		__entry->error = error;
 		__entry->ret_ip = ret_ip;
 	),
@@ -389,7 +389,7 @@ TRACE_EVENT(xchk_ifork_btree_op_error,
 		__entry->type = sc->sm->sm_type;
 		__entry->btnum = cur->bc_btnum;
 		__entry->level = level;
-		__entry->ptr = cur->bc_ptrs[level];
+		__entry->ptr = cur->bc_levels[level].ptr;
 		__entry->agno = XFS_FSB_TO_AGNO(cur->bc_mp, fsbno);
 		__entry->bno = XFS_FSB_TO_AGBNO(cur->bc_mp, fsbno);
 		__entry->error = error;
@@ -431,7 +431,7 @@ TRACE_EVENT(xchk_btree_error,
 		__entry->level = level;
 		__entry->agno = XFS_FSB_TO_AGNO(cur->bc_mp, fsbno);
 		__entry->bno = XFS_FSB_TO_AGBNO(cur->bc_mp, fsbno);
-		__entry->ptr = cur->bc_ptrs[level];
+		__entry->ptr = cur->bc_levels[level].ptr;
 		__entry->ret_ip = ret_ip;
 	),
 	TP_printk("dev %d:%d type %s btree %s level %d ptr %d agno 0x%x agbno 0x%x ret_ip %pS",
@@ -471,7 +471,7 @@ TRACE_EVENT(xchk_ifork_btree_error,
 		__entry->level = level;
 		__entry->agno = XFS_FSB_TO_AGNO(cur->bc_mp, fsbno);
 		__entry->bno = XFS_FSB_TO_AGBNO(cur->bc_mp, fsbno);
-		__entry->ptr = cur->bc_ptrs[level];
+		__entry->ptr = cur->bc_levels[level].ptr;
 		__entry->ret_ip = ret_ip;
 	),
 	TP_printk("dev %d:%d ino 0x%llx fork %s type %s btree %s level %d ptr %d agno 0x%x agbno 0x%x ret_ip %pS",
@@ -511,7 +511,7 @@ DECLARE_EVENT_CLASS(xchk_sbtree_class,
 		__entry->bno = XFS_FSB_TO_AGBNO(cur->bc_mp, fsbno);
 		__entry->level = level;
 		__entry->nlevels = cur->bc_nlevels;
-		__entry->ptr = cur->bc_ptrs[level];
+		__entry->ptr = cur->bc_levels[level].ptr;
 	),
 	TP_printk("dev %d:%d type %s btree %s agno 0x%x agbno 0x%x level %d nlevels %d ptr %d",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index c4e0cd1c1c8c..30bae0657343 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1966,7 +1966,7 @@ xfs_init_zones(void)
 		goto out_destroy_log_ticket_zone;
 
 	xfs_btree_cur_zone = kmem_cache_create("xfs_btree_cur",
-					       sizeof(struct xfs_btree_cur),
+				xfs_btree_cur_sizeof(XFS_BTREE_MAXLEVELS),
 					       0, 0, NULL);
 	if (!xfs_btree_cur_zone)
 		goto out_destroy_bmap_free_item_zone;
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 1033a95fbf8e..4a8076ef8cb4 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -2476,7 +2476,7 @@ DECLARE_EVENT_CLASS(xfs_btree_cur_class,
 		__entry->btnum = cur->bc_btnum;
 		__entry->level = level;
 		__entry->nlevels = cur->bc_nlevels;
-		__entry->ptr = cur->bc_ptrs[level];
+		__entry->ptr = cur->bc_levels[level].ptr;
 		__entry->daddr = bp ? xfs_buf_daddr(bp) : -1;
 	),
 	TP_printk("dev %d:%d btree %s level %d/%d ptr %d daddr 0x%llx",

