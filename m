Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47FFEC433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Jan 2022 00:24:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345222AbiATAYm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Jan 2022 19:24:42 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:60698 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357771AbiATAYg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Jan 2022 19:24:36 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CE88D61506
        for <linux-xfs@vger.kernel.org>; Thu, 20 Jan 2022 00:24:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31602C004E1;
        Thu, 20 Jan 2022 00:24:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642638275;
        bh=QSFXuG5yjrc+O+iyjOs4YaIS6k2LdtqbSuFv+Xdimlk=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=GwRr6Nk2p9WRrFGGHfYcb9y9M0IK1wAa2+awg1BqSM2JatOsviu6JL+00hrfa/Yhe
         0d8VdVpbdjisF5Fn4jYwnNEUMPZ4GuAn2r6g8dZFwqX7s0aPYa6CTk5iL6zx2ZYglF
         koiDgDJUknEDOvQq39iZwfbDEqd5MjSspkvDuSQJAnyH2rS4MGdK/eAtDVtl3HRP/x
         EnjsxTFZryqZccf8fUUseUeW3UQ+1sJcrgTYeHFm9HITS/vuFCBx+ZXrb7XbVFZx7+
         c+1GnNLyY90FlPf/8ia+uzJX1K4R+0I/6pYbo0KVNsPXJx0+HYtbmn+DidCBs0kKNr
         H6o0Rd3apdpNw==
Subject: [PATCH 15/48] xfs: prepare xfs_btree_cur for dynamic cursor heights
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Date:   Wed, 19 Jan 2022 16:24:34 -0800
Message-ID: <164263827485.865554.18385069093603234333.stgit@magnolia>
In-Reply-To: <164263819185.865554.6000499997543946756.stgit@magnolia>
References: <164263819185.865554.6000499997543946756.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Source kernel commit: 6ca444cfd663545e9e1c19ad2695836ffafad0a6

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
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_alloc.c |    6 +-
 libxfs/xfs_bmap.c  |   10 ++-
 libxfs/xfs_btree.c |  168 +++++++++++++++++++++++++++-------------------------
 libxfs/xfs_btree.h |   33 ++++++++--
 4 files changed, 121 insertions(+), 96 deletions(-)


diff --git a/libxfs/xfs_alloc.c b/libxfs/xfs_alloc.c
index fe050d8e..b8857204 100644
--- a/libxfs/xfs_alloc.c
+++ b/libxfs/xfs_alloc.c
@@ -484,8 +484,8 @@ xfs_alloc_fixup_trees(
 		struct xfs_btree_block	*bnoblock;
 		struct xfs_btree_block	*cntblock;
 
-		bnoblock = XFS_BUF_TO_BLOCK(bno_cur->bc_bufs[0]);
-		cntblock = XFS_BUF_TO_BLOCK(cnt_cur->bc_bufs[0]);
+		bnoblock = XFS_BUF_TO_BLOCK(bno_cur->bc_levels[0].bp);
+		cntblock = XFS_BUF_TO_BLOCK(cnt_cur->bc_levels[0].bp);
 
 		if (XFS_IS_CORRUPT(mp,
 				   bnoblock->bb_numrecs !=
@@ -1508,7 +1508,7 @@ xfs_alloc_ag_vextent_lastblock(
 	 * than minlen.
 	 */
 	if (*len || args->alignment > 1) {
-		acur->cnt->bc_ptrs[0] = 1;
+		acur->cnt->bc_levels[0].ptr = 1;
 		do {
 			error = xfs_alloc_get_rec(acur->cnt, bno, len, &i);
 			if (error)
diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index 371aedc2..fa8d6880 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -233,10 +233,10 @@ xfs_bmap_get_bp(
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
@@ -622,8 +622,8 @@ xfs_bmap_btree_to_extents(
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
diff --git a/libxfs/xfs_btree.c b/libxfs/xfs_btree.c
index 426ab7f8..2e144dc2 100644
--- a/libxfs/xfs_btree.c
+++ b/libxfs/xfs_btree.c
@@ -364,8 +364,8 @@ xfs_btree_del_cursor(
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
@@ -412,9 +412,9 @@ xfs_btree_dup_cursor(
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
@@ -426,7 +426,7 @@ xfs_btree_dup_cursor(
 				return error;
 			}
 		}
-		new->bc_bufs[i] = bp;
+		new->bc_levels[i].bp = bp;
 	}
 	*ncur = new;
 	return 0;
@@ -678,7 +678,7 @@ xfs_btree_get_block(
 		return xfs_btree_get_iroot(cur);
 	}
 
-	*bpp = cur->bc_bufs[level];
+	*bpp = cur->bc_levels[level].bp;
 	return XFS_BUF_TO_BLOCK(*bpp);
 }
 
@@ -708,7 +708,7 @@ xfs_btree_firstrec(
 	/*
 	 * Set the ptr value to 1, that's the first record/key.
 	 */
-	cur->bc_ptrs[level] = 1;
+	cur->bc_levels[level].ptr = 1;
 	return 1;
 }
 
@@ -738,7 +738,7 @@ xfs_btree_lastrec(
 	/*
 	 * Set the ptr value to numrecs, that's the last record/key.
 	 */
-	cur->bc_ptrs[level] = be16_to_cpu(block->bb_numrecs);
+	cur->bc_levels[level].ptr = be16_to_cpu(block->bb_numrecs);
 	return 1;
 }
 
@@ -919,11 +919,11 @@ xfs_btree_readahead(
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
@@ -988,22 +988,22 @@ xfs_btree_setbuf(
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
 
@@ -1545,7 +1545,7 @@ xfs_btree_increment(
 #endif
 
 	/* We're done if we remain in the block after the increment. */
-	if (++cur->bc_ptrs[level] <= xfs_btree_get_numrecs(block))
+	if (++cur->bc_levels[level].ptr <= xfs_btree_get_numrecs(block))
 		goto out1;
 
 	/* Fail if we just went off the right edge of the tree. */
@@ -1568,7 +1568,7 @@ xfs_btree_increment(
 			goto error0;
 #endif
 
-		if (++cur->bc_ptrs[lev] <= xfs_btree_get_numrecs(block))
+		if (++cur->bc_levels[lev].ptr <= xfs_btree_get_numrecs(block))
 			break;
 
 		/* Read-ahead the right block for the next loop. */
@@ -1595,14 +1595,14 @@ xfs_btree_increment(
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
@@ -1638,7 +1638,7 @@ xfs_btree_decrement(
 	xfs_btree_readahead(cur, level, XFS_BTCUR_LEFTRA);
 
 	/* We're done if we remain in the block after the decrement. */
-	if (--cur->bc_ptrs[level] > 0)
+	if (--cur->bc_levels[level].ptr > 0)
 		goto out1;
 
 	/* Get a pointer to the btree block. */
@@ -1662,7 +1662,7 @@ xfs_btree_decrement(
 	 * Stop when we don't go off the left edge of a block.
 	 */
 	for (lev = level + 1; lev < cur->bc_nlevels; lev++) {
-		if (--cur->bc_ptrs[lev] > 0)
+		if (--cur->bc_levels[lev].ptr > 0)
 			break;
 		/* Read-ahead the left block for the next loop. */
 		xfs_btree_readahead(cur, lev, XFS_BTCUR_LEFTRA);
@@ -1688,13 +1688,13 @@ xfs_btree_decrement(
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
@@ -1732,7 +1732,7 @@ xfs_btree_lookup_get_block(
 	 *
 	 * Otherwise throw it away and get a new one.
 	 */
-	bp = cur->bc_bufs[level];
+	bp = cur->bc_levels[level].bp;
 	error = xfs_btree_ptr_to_daddr(cur, pp, &daddr);
 	if (error)
 		return error;
@@ -1861,7 +1861,7 @@ xfs_btree_lookup(
 					return -EFSCORRUPTED;
 				}
 
-				cur->bc_ptrs[0] = dir != XFS_LOOKUP_LE;
+				cur->bc_levels[0].ptr = dir != XFS_LOOKUP_LE;
 				*stat = 0;
 				return 0;
 			}
@@ -1913,7 +1913,7 @@ xfs_btree_lookup(
 			if (error)
 				goto error0;
 
-			cur->bc_ptrs[level] = keyno;
+			cur->bc_levels[level].ptr = keyno;
 		}
 	}
 
@@ -1930,7 +1930,7 @@ xfs_btree_lookup(
 		    !xfs_btree_ptr_is_null(cur, &ptr)) {
 			int	i;
 
-			cur->bc_ptrs[0] = keyno;
+			cur->bc_levels[0].ptr = keyno;
 			error = xfs_btree_increment(cur, 0, &i);
 			if (error)
 				goto error0;
@@ -1941,7 +1941,7 @@ xfs_btree_lookup(
 		}
 	} else if (dir == XFS_LOOKUP_LE && diff > 0)
 		keyno--;
-	cur->bc_ptrs[0] = keyno;
+	cur->bc_levels[0].ptr = keyno;
 
 	/* Return if we succeeded or not. */
 	if (keyno == 0 || keyno > xfs_btree_get_numrecs(block))
@@ -2101,7 +2101,7 @@ __xfs_btree_updkeys(
 		if (error)
 			return error;
 #endif
-		ptr = cur->bc_ptrs[level];
+		ptr = cur->bc_levels[level].ptr;
 		nlkey = xfs_btree_key_addr(cur, ptr, block);
 		nhkey = xfs_btree_high_key_addr(cur, ptr, block);
 		if (!force_all &&
@@ -2168,7 +2168,7 @@ xfs_btree_update_keys(
 		if (error)
 			return error;
 #endif
-		ptr = cur->bc_ptrs[level];
+		ptr = cur->bc_levels[level].ptr;
 		kp = xfs_btree_key_addr(cur, ptr, block);
 		xfs_btree_copy_keys(cur, kp, &key, 1);
 		xfs_btree_log_keys(cur, bp, ptr, ptr);
@@ -2202,7 +2202,7 @@ xfs_btree_update(
 		goto error0;
 #endif
 	/* Get the address of the rec to be updated. */
-	ptr = cur->bc_ptrs[0];
+	ptr = cur->bc_levels[0].ptr;
 	rp = xfs_btree_rec_addr(cur, ptr, block);
 
 	/* Fill in the new contents and log them. */
@@ -2277,7 +2277,7 @@ xfs_btree_lshift(
 	 * If the cursor entry is the one that would be moved, don't
 	 * do it... it's too complicated.
 	 */
-	if (cur->bc_ptrs[level] <= 1)
+	if (cur->bc_levels[level].ptr <= 1)
 		goto out0;
 
 	/* Set up the left neighbor as "left". */
@@ -2411,7 +2411,7 @@ xfs_btree_lshift(
 		goto error0;
 
 	/* Slide the cursor value left one. */
-	cur->bc_ptrs[level]--;
+	cur->bc_levels[level].ptr--;
 
 	*stat = 1;
 	return 0;
@@ -2473,7 +2473,7 @@ xfs_btree_rshift(
 	 * do it... it's too complicated.
 	 */
 	lrecs = xfs_btree_get_numrecs(left);
-	if (cur->bc_ptrs[level] >= lrecs)
+	if (cur->bc_levels[level].ptr >= lrecs)
 		goto out0;
 
 	/* Set up the right neighbor as "right". */
@@ -2661,7 +2661,7 @@ __xfs_btree_split(
 	 */
 	lrecs = xfs_btree_get_numrecs(left);
 	rrecs = lrecs / 2;
-	if ((lrecs & 1) && cur->bc_ptrs[level] <= rrecs + 1)
+	if ((lrecs & 1) && cur->bc_levels[level].ptr <= rrecs + 1)
 		rrecs++;
 	src_index = (lrecs - rrecs + 1);
 
@@ -2757,9 +2757,9 @@ __xfs_btree_split(
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
@@ -2769,7 +2769,7 @@ __xfs_btree_split(
 		error = xfs_btree_dup_cursor(cur, curp);
 		if (error)
 			goto error0;
-		(*curp)->bc_ptrs[level + 1]++;
+		(*curp)->bc_levels[level + 1].ptr++;
 	}
 	*ptrp = rptr;
 	*stat = 1;
@@ -2935,7 +2935,7 @@ xfs_btree_new_iroot(
 	xfs_btree_set_numrecs(block, 1);
 	cur->bc_nlevels++;
 	ASSERT(cur->bc_nlevels <= XFS_BTREE_MAXLEVELS);
-	cur->bc_ptrs[level + 1] = 1;
+	cur->bc_levels[level + 1].ptr = 1;
 
 	kp = xfs_btree_key_addr(cur, 1, block);
 	ckp = xfs_btree_key_addr(cur, 1, cblock);
@@ -3096,7 +3096,7 @@ xfs_btree_new_root(
 
 	/* Fix up the cursor. */
 	xfs_btree_setbuf(cur, cur->bc_nlevels, nbp);
-	cur->bc_ptrs[cur->bc_nlevels] = nptr;
+	cur->bc_levels[cur->bc_nlevels].ptr = nptr;
 	cur->bc_nlevels++;
 	ASSERT(cur->bc_nlevels <= XFS_BTREE_MAXLEVELS);
 	*stat = 1;
@@ -3155,7 +3155,7 @@ xfs_btree_make_block_unfull(
 		return error;
 
 	if (*stat) {
-		*oindex = *index = cur->bc_ptrs[level];
+		*oindex = *index = cur->bc_levels[level].ptr;
 		return 0;
 	}
 
@@ -3170,7 +3170,7 @@ xfs_btree_make_block_unfull(
 		return error;
 
 
-	*index = cur->bc_ptrs[level];
+	*index = cur->bc_levels[level].ptr;
 	return 0;
 }
 
@@ -3217,7 +3217,7 @@ xfs_btree_insrec(
 	}
 
 	/* If we're off the left edge, return failure. */
-	ptr = cur->bc_ptrs[level];
+	ptr = cur->bc_levels[level].ptr;
 	if (ptr == 0) {
 		*stat = 0;
 		return 0;
@@ -3560,7 +3560,7 @@ xfs_btree_kill_iroot(
 	if (error)
 		return error;
 
-	cur->bc_bufs[level - 1] = NULL;
+	cur->bc_levels[level - 1].bp = NULL;
 	be16_add_cpu(&block->bb_level, -1);
 	xfs_trans_log_inode(cur->bc_tp, ip,
 		XFS_ILOG_CORE | xfs_ilog_fbroot(cur->bc_ino.whichfork));
@@ -3593,8 +3593,8 @@ xfs_btree_kill_root(
 	if (error)
 		return error;
 
-	cur->bc_bufs[level] = NULL;
-	cur->bc_ra[level] = 0;
+	cur->bc_levels[level].bp = NULL;
+	cur->bc_levels[level].ra = 0;
 	cur->bc_nlevels--;
 
 	return 0;
@@ -3653,7 +3653,7 @@ xfs_btree_delrec(
 	tcur = NULL;
 
 	/* Get the index of the entry being deleted, check for nothing there. */
-	ptr = cur->bc_ptrs[level];
+	ptr = cur->bc_levels[level].ptr;
 	if (ptr == 0) {
 		*stat = 0;
 		return 0;
@@ -3963,7 +3963,7 @@ xfs_btree_delrec(
 				xfs_btree_del_cursor(tcur, XFS_BTREE_NOERROR);
 				tcur = NULL;
 				if (level == 0)
-					cur->bc_ptrs[0]++;
+					cur->bc_levels[0].ptr++;
 
 				*stat = 1;
 				return 0;
@@ -4100,9 +4100,9 @@ xfs_btree_delrec(
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
@@ -4122,16 +4122,16 @@ xfs_btree_delrec(
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
@@ -4185,7 +4185,7 @@ xfs_btree_delete(
 
 	if (i == 0) {
 		for (level = 1; level < cur->bc_nlevels; level++) {
-			if (cur->bc_ptrs[level] == 0) {
+			if (cur->bc_levels[level].ptr == 0) {
 				error = xfs_btree_decrement(cur, level, &i);
 				if (error)
 					goto error0;
@@ -4216,7 +4216,7 @@ xfs_btree_get_rec(
 	int			error;	/* error return value */
 #endif
 
-	ptr = cur->bc_ptrs[0];
+	ptr = cur->bc_levels[0].ptr;
 	block = xfs_btree_get_block(cur, 0, &bp);
 
 #ifdef DEBUG
@@ -4664,23 +4664,25 @@ xfs_btree_overlapped_query_range(
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
@@ -4703,14 +4705,15 @@ xfs_btree_overlapped_query_range(
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
@@ -4733,13 +4736,13 @@ xfs_btree_overlapped_query_range(
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
@@ -4750,13 +4753,14 @@ xfs_btree_overlapped_query_range(
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
@@ -4918,7 +4922,7 @@ xfs_btree_has_more_records(
 	block = xfs_btree_get_block(cur, 0, &bp);
 
 	/* There are still records in this block. */
-	if (cur->bc_ptrs[0] < xfs_btree_get_numrecs(block))
+	if (cur->bc_levels[0].ptr < xfs_btree_get_numrecs(block))
 		return true;
 
 	/* There are more record blocks. */
diff --git a/libxfs/xfs_btree.h b/libxfs/xfs_btree.h
index 1018bcc4..0181fc98 100644
--- a/libxfs/xfs_btree.h
+++ b/libxfs/xfs_btree.h
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
 

