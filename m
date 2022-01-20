Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3224AC433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Jan 2022 00:21:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345168AbiATAVW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Jan 2022 19:21:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345152AbiATAVV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Jan 2022 19:21:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99EE3C061574
        for <linux-xfs@vger.kernel.org>; Wed, 19 Jan 2022 16:21:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2A38E61506
        for <linux-xfs@vger.kernel.org>; Thu, 20 Jan 2022 00:21:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E28EC004E1;
        Thu, 20 Jan 2022 00:21:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642638080;
        bh=p5Ogbn4ck6fs+RBnM8K5VX+vckwyexQawDxNN0+qVzA=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=e/eRMORFgI+2SUx6SJV2lMXC/qzczGUUEChpTSLxysG22uU290TQ0LzGZs0ONGZ3r
         qBqv1Wx+dYc/K/Vuh0+3QxdfjSvhshj23OEktSfXzW6c7WEPhD+hoVzwWiMOTLrNHy
         yqp3To4YSb7pq/Ixgly8E/jbd7Gof7vxT7BRSvSdZ59suUIp30iER+W17PqW1Y7g62
         jHpeEcwtn/Du50cqh8CJ1D6eG+y6RrgvNAxBnGH3PTdUjyahtcOhlZtQ+Gl3gNyl0i
         01a3R/+DgLdKP7B1ILzQFdVLf481WTFRGJYn7+J2afthottCvGkGA7TbtcSJJ8Ubo4
         cqhutuk8TuRLQ==
Subject: [PATCH 43/45] xfs: introduce xfs_buf_daddr()
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>, Christoph Hellwig <hch@lst.de>,
        linux-xfs@vger.kernel.org
Date:   Wed, 19 Jan 2022 16:21:20 -0800
Message-ID: <164263808020.860211.10781587227366609849.stgit@magnolia>
In-Reply-To: <164263784199.860211.7509808171577819673.stgit@magnolia>
References: <164263784199.860211.7509808171577819673.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Source kernel commit: 04fcad80cd068731a779fb442f78234732683755

Introduce a helper function xfs_buf_daddr() to extract the disk
address of the buffer from the struct xfs_buf. This will replace
direct accesses to bp->b_bn and bp->b_maps[0].bm_bn, as well as
the XFS_BUF_ADDR() macro.

This patch introduces the helper function and replaces all uses of
XFS_BUF_ADDR() as this is just a simple sed replacement.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/libxfs_io.h          |    9 +++++++--
 libxfs/logitem.c            |    4 ++--
 libxfs/xfs_alloc_btree.c    |    2 +-
 libxfs/xfs_attr.c           |    4 ++--
 libxfs/xfs_bmap.c           |    4 ++--
 libxfs/xfs_bmap_btree.c     |    2 +-
 libxfs/xfs_btree.c          |   10 +++++-----
 libxfs/xfs_ialloc_btree.c   |    2 +-
 libxfs/xfs_inode_buf.c      |    2 +-
 libxfs/xfs_refcount_btree.c |    2 +-
 libxfs/xfs_rmap_btree.c     |    2 +-
 libxfs/xfs_sb.c             |    2 +-
 libxlog/xfs_log_recover.c   |    2 +-
 repair/dino_chunks.c        |    4 ++--
 repair/prefetch.c           |   20 ++++++++++----------
 15 files changed, 38 insertions(+), 33 deletions(-)


diff --git a/libxfs/libxfs_io.h b/libxfs/libxfs_io.h
index bf489259..a4d0a913 100644
--- a/libxfs/libxfs_io.h
+++ b/libxfs/libxfs_io.h
@@ -114,11 +114,16 @@ typedef unsigned int xfs_buf_flags_t;
 #define XFS_BUF_DADDR_NULL		((xfs_daddr_t) (-1LL))
 
 #define xfs_buf_offset(bp, offset)	((bp)->b_addr + (offset))
-#define XFS_BUF_ADDR(bp)		((bp)->b_bn)
+
+static inline xfs_daddr_t xfs_buf_daddr(struct xfs_buf *bp)
+{
+	return bp->b_maps[0].bm_bn;
+}
 
 static inline void xfs_buf_set_daddr(struct xfs_buf *bp, xfs_daddr_t blkno)
 {
-	bp->b_bn = blkno;
+	assert(bp->b_bn == XFS_BUF_DADDR_NULL);
+	bp->b_maps[0].bm_bn = blkno;
 }
 
 void libxfs_buf_set_priority(struct xfs_buf *bp, int priority);
diff --git a/libxfs/logitem.c b/libxfs/logitem.c
index b073cdb4..e6debb6d 100644
--- a/libxfs/logitem.c
+++ b/libxfs/logitem.c
@@ -46,7 +46,7 @@ xfs_trans_buf_item_match(
 		blip = (struct xfs_buf_log_item *)lip;
 		if (blip->bli_item.li_type == XFS_LI_BUF &&
 		    blip->bli_buf->b_target->bt_bdev == btp->bt_bdev &&
-		    XFS_BUF_ADDR(blip->bli_buf) == map[0].bm_bn &&
+		    xfs_buf_daddr(blip->bli_buf) == map[0].bm_bn &&
 		    blip->bli_buf->b_length == len) {
 			ASSERT(blip->bli_buf->b_map_count == nmaps);
 			return blip->bli_buf;
@@ -104,7 +104,7 @@ xfs_buf_item_init(
 	xfs_log_item_init(mp, &bip->bli_item, XFS_LI_BUF);
 	bip->bli_buf = bp;
 	bip->__bli_format.blf_type = XFS_LI_BUF;
-	bip->__bli_format.blf_blkno = (int64_t)XFS_BUF_ADDR(bp);
+	bip->__bli_format.blf_blkno = (int64_t)xfs_buf_daddr(bp);
 	bip->__bli_format.blf_len = (unsigned short)bp->b_length;
 	bp->b_log_item = bip;
 }
diff --git a/libxfs/xfs_alloc_btree.c b/libxfs/xfs_alloc_btree.c
index 94f2d7b6..03ebefc3 100644
--- a/libxfs/xfs_alloc_btree.c
+++ b/libxfs/xfs_alloc_btree.c
@@ -85,7 +85,7 @@ xfs_allocbt_free_block(
 	xfs_agblock_t		bno;
 	int			error;
 
-	bno = xfs_daddr_to_agbno(cur->bc_mp, XFS_BUF_ADDR(bp));
+	bno = xfs_daddr_to_agbno(cur->bc_mp, xfs_buf_daddr(bp));
 	error = xfs_alloc_put_freelist(cur->bc_tp, agbp, NULL, bno, 1);
 	if (error)
 		return error;
diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 00f3ecb5..e44b68e1 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -1540,7 +1540,7 @@ xfs_attr_fillstate(xfs_da_state_t *state)
 	ASSERT((path->active >= 0) && (path->active < XFS_DA_NODE_MAXDEPTH));
 	for (blk = path->blk, level = 0; level < path->active; blk++, level++) {
 		if (blk->bp) {
-			blk->disk_blkno = XFS_BUF_ADDR(blk->bp);
+			blk->disk_blkno = xfs_buf_daddr(blk->bp);
 			blk->bp = NULL;
 		} else {
 			blk->disk_blkno = 0;
@@ -1555,7 +1555,7 @@ xfs_attr_fillstate(xfs_da_state_t *state)
 	ASSERT((path->active >= 0) && (path->active < XFS_DA_NODE_MAXDEPTH));
 	for (blk = path->blk, level = 0; level < path->active; blk++, level++) {
 		if (blk->bp) {
-			blk->disk_blkno = XFS_BUF_ADDR(blk->bp);
+			blk->disk_blkno = xfs_buf_daddr(blk->bp);
 			blk->bp = NULL;
 		} else {
 			blk->disk_blkno = 0;
diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index 1735717c..1edf6236 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -235,7 +235,7 @@ xfs_bmap_get_bp(
 	for (i = 0; i < XFS_BTREE_MAXLEVELS; i++) {
 		if (!cur->bc_bufs[i])
 			break;
-		if (XFS_BUF_ADDR(cur->bc_bufs[i]) == bno)
+		if (xfs_buf_daddr(cur->bc_bufs[i]) == bno)
 			return cur->bc_bufs[i];
 	}
 
@@ -244,7 +244,7 @@ xfs_bmap_get_bp(
 		struct xfs_buf_log_item	*bip = (struct xfs_buf_log_item *)lip;
 
 		if (bip->bli_item.li_type == XFS_LI_BUF &&
-		    XFS_BUF_ADDR(bip->bli_buf) == bno)
+		    xfs_buf_daddr(bip->bli_buf) == bno)
 			return bip->bli_buf;
 	}
 
diff --git a/libxfs/xfs_bmap_btree.c b/libxfs/xfs_bmap_btree.c
index 237af83e..aea9b5a8 100644
--- a/libxfs/xfs_bmap_btree.c
+++ b/libxfs/xfs_bmap_btree.c
@@ -280,7 +280,7 @@ xfs_bmbt_free_block(
 	struct xfs_mount	*mp = cur->bc_mp;
 	struct xfs_inode	*ip = cur->bc_ino.ip;
 	struct xfs_trans	*tp = cur->bc_tp;
-	xfs_fsblock_t		fsbno = XFS_DADDR_TO_FSB(mp, XFS_BUF_ADDR(bp));
+	xfs_fsblock_t		fsbno = XFS_DADDR_TO_FSB(mp, xfs_buf_daddr(bp));
 	struct xfs_owner_info	oinfo;
 
 	xfs_rmap_ino_bmbt_owner(&oinfo, ip->i_ino, cur->bc_ino.whichfork);
diff --git a/libxfs/xfs_btree.c b/libxfs/xfs_btree.c
index 8b2459e3..2f86ab68 100644
--- a/libxfs/xfs_btree.c
+++ b/libxfs/xfs_btree.c
@@ -417,7 +417,7 @@ xfs_btree_dup_cursor(
 		bp = cur->bc_bufs[i];
 		if (bp) {
 			error = xfs_trans_read_buf(mp, tp, mp->m_ddev_targp,
-						   XFS_BUF_ADDR(bp), mp->m_bsize,
+						   xfs_buf_daddr(bp), mp->m_bsize,
 						   0, &bp,
 						   cur->bc_ops->buf_ops);
 			if (error) {
@@ -1189,10 +1189,10 @@ xfs_btree_buf_to_ptr(
 {
 	if (cur->bc_flags & XFS_BTREE_LONG_PTRS)
 		ptr->l = cpu_to_be64(XFS_DADDR_TO_FSB(cur->bc_mp,
-					XFS_BUF_ADDR(bp)));
+					xfs_buf_daddr(bp)));
 	else {
 		ptr->s = cpu_to_be32(xfs_daddr_to_agbno(cur->bc_mp,
-					XFS_BUF_ADDR(bp)));
+					xfs_buf_daddr(bp)));
 	}
 }
 
@@ -1736,7 +1736,7 @@ xfs_btree_lookup_get_block(
 	error = xfs_btree_ptr_to_daddr(cur, pp, &daddr);
 	if (error)
 		return error;
-	if (bp && XFS_BUF_ADDR(bp) == daddr) {
+	if (bp && xfs_buf_daddr(bp) == daddr) {
 		*blkp = XFS_BUF_TO_BLOCK(bp);
 		return 0;
 	}
@@ -4500,7 +4500,7 @@ xfs_btree_sblock_verify(
 		return __this_address;
 
 	/* sibling pointer verification */
-	agno = xfs_daddr_to_agno(mp, XFS_BUF_ADDR(bp));
+	agno = xfs_daddr_to_agno(mp, xfs_buf_daddr(bp));
 	if (block->bb_u.s.bb_leftsib != cpu_to_be32(NULLAGBLOCK) &&
 	    !xfs_verify_agbno(mp, agno, be32_to_cpu(block->bb_u.s.bb_leftsib)))
 		return __this_address;
diff --git a/libxfs/xfs_ialloc_btree.c b/libxfs/xfs_ialloc_btree.c
index 14b5918b..1a5289ce 100644
--- a/libxfs/xfs_ialloc_btree.c
+++ b/libxfs/xfs_ialloc_btree.c
@@ -155,7 +155,7 @@ __xfs_inobt_free_block(
 {
 	xfs_inobt_mod_blockcount(cur, -1);
 	return xfs_free_extent(cur->bc_tp,
-			XFS_DADDR_TO_FSB(cur->bc_mp, XFS_BUF_ADDR(bp)), 1,
+			XFS_DADDR_TO_FSB(cur->bc_mp, xfs_buf_daddr(bp)), 1,
 			&XFS_RMAP_OINFO_INOBT, resv);
 }
 
diff --git a/libxfs/xfs_inode_buf.c b/libxfs/xfs_inode_buf.c
index dfff5979..516dab25 100644
--- a/libxfs/xfs_inode_buf.c
+++ b/libxfs/xfs_inode_buf.c
@@ -45,7 +45,7 @@ xfs_inode_buf_verify(
 	/*
 	 * Validate the magic number and version of every inode in the buffer
 	 */
-	agno = xfs_daddr_to_agno(mp, XFS_BUF_ADDR(bp));
+	agno = xfs_daddr_to_agno(mp, xfs_buf_daddr(bp));
 	ni = XFS_BB_TO_FSB(mp, bp->b_length) * mp->m_sb.sb_inopblock;
 	for (i = 0; i < ni; i++) {
 		int		di_ok;
diff --git a/libxfs/xfs_refcount_btree.c b/libxfs/xfs_refcount_btree.c
index ded0ebe1..62ef048c 100644
--- a/libxfs/xfs_refcount_btree.c
+++ b/libxfs/xfs_refcount_btree.c
@@ -101,7 +101,7 @@ xfs_refcountbt_free_block(
 	struct xfs_mount	*mp = cur->bc_mp;
 	struct xfs_buf		*agbp = cur->bc_ag.agbp;
 	struct xfs_agf		*agf = agbp->b_addr;
-	xfs_fsblock_t		fsbno = XFS_DADDR_TO_FSB(mp, XFS_BUF_ADDR(bp));
+	xfs_fsblock_t		fsbno = XFS_DADDR_TO_FSB(mp, xfs_buf_daddr(bp));
 	int			error;
 
 	trace_xfs_refcountbt_free_block(cur->bc_mp, cur->bc_ag.pag->pag_agno,
diff --git a/libxfs/xfs_rmap_btree.c b/libxfs/xfs_rmap_btree.c
index 05d962d8..ca72324b 100644
--- a/libxfs/xfs_rmap_btree.c
+++ b/libxfs/xfs_rmap_btree.c
@@ -120,7 +120,7 @@ xfs_rmapbt_free_block(
 	xfs_agblock_t		bno;
 	int			error;
 
-	bno = xfs_daddr_to_agbno(cur->bc_mp, XFS_BUF_ADDR(bp));
+	bno = xfs_daddr_to_agbno(cur->bc_mp, xfs_buf_daddr(bp));
 	trace_xfs_rmapbt_free_block(cur->bc_mp, pag->pag_agno,
 			bno, 1);
 	be32_add_cpu(&agf->agf_rmap_blocks, -1);
diff --git a/libxfs/xfs_sb.c b/libxfs/xfs_sb.c
index 198d211e..680441ae 100644
--- a/libxfs/xfs_sb.c
+++ b/libxfs/xfs_sb.c
@@ -190,7 +190,7 @@ xfs_validate_sb_write(
 	 * secondary superblocks, so allow this usage to continue because
 	 * we never read counters from such superblocks.
 	 */
-	if (XFS_BUF_ADDR(bp) == XFS_SB_DADDR && !sbp->sb_inprogress &&
+	if (xfs_buf_daddr(bp) == XFS_SB_DADDR && !sbp->sb_inprogress &&
 	    (sbp->sb_fdblocks > sbp->sb_dblocks ||
 	     !xfs_verify_icount(mp, sbp->sb_icount) ||
 	     sbp->sb_ifree > sbp->sb_icount)) {
diff --git a/libxlog/xfs_log_recover.c b/libxlog/xfs_log_recover.c
index 3c24c021..79a405c5 100644
--- a/libxlog/xfs_log_recover.c
+++ b/libxlog/xfs_log_recover.c
@@ -118,7 +118,7 @@ xlog_bread_noalign(
 	bp->b_length = nbblks;
 	bp->b_error = 0;
 
-	return libxfs_readbufr(log->l_dev, XFS_BUF_ADDR(bp), bp, nbblks, 0);
+	return libxfs_readbufr(log->l_dev, xfs_buf_daddr(bp), bp, nbblks, 0);
 }
 
 int
diff --git a/repair/dino_chunks.c b/repair/dino_chunks.c
index 6d494f2d..51cd06f0 100644
--- a/repair/dino_chunks.c
+++ b/repair/dino_chunks.c
@@ -686,7 +686,7 @@ process_inode_chunk(
 		}
 
 		pftrace("readbuf %p (%llu, %d) in AG %d", bplist[bp_index],
-			(long long)XFS_BUF_ADDR(bplist[bp_index]),
+			(long long)xfs_buf_daddr(bplist[bp_index]),
 			bplist[bp_index]->b_length, agno);
 
 		bplist[bp_index]->b_ops = &xfs_inode_buf_ops;
@@ -985,7 +985,7 @@ process_inode_chunk(
 
 				pftrace("put/writebuf %p (%llu) in AG %d",
 					bplist[bp_index], (long long)
-					XFS_BUF_ADDR(bplist[bp_index]), agno);
+					xfs_buf_daddr(bplist[bp_index]), agno);
 
 				if (dirty && !no_modify) {
 					libxfs_buf_mark_dirty(bplist[bp_index]);
diff --git a/repair/prefetch.c b/repair/prefetch.c
index b5266b8f..83af5bc7 100644
--- a/repair/prefetch.c
+++ b/repair/prefetch.c
@@ -153,7 +153,7 @@ pf_queue_io(
 
 	pftrace("getbuf %c %p (%llu) in AG %d (fsbno = %lu) added to queue"
 		"(inode_bufs_queued = %d, last_bno = %lu)", B_IS_INODE(flag) ?
-		'I' : 'M', bp, (long long)XFS_BUF_ADDR(bp), args->agno, fsbno,
+		'I' : 'M', bp, (long long)xfs_buf_daddr(bp), args->agno, fsbno,
 		args->inode_bufs_queued, args->last_bno_read);
 
 	pf_start_processing(args);
@@ -523,12 +523,12 @@ pf_batch_read(
 		 * otherwise, find as many close together blocks and
 		 * read them in one read
 		 */
-		first_off = LIBXFS_BBTOOFF64(XFS_BUF_ADDR(bplist[0]));
-		last_off = LIBXFS_BBTOOFF64(XFS_BUF_ADDR(bplist[num-1])) +
+		first_off = LIBXFS_BBTOOFF64(xfs_buf_daddr(bplist[0]));
+		last_off = LIBXFS_BBTOOFF64(xfs_buf_daddr(bplist[num-1])) +
 			BBTOB(bplist[num-1]->b_length);
 		while (num > 1 && last_off - first_off > pf_max_bytes) {
 			num--;
-			last_off = LIBXFS_BBTOOFF64(XFS_BUF_ADDR(bplist[num-1])) +
+			last_off = LIBXFS_BBTOOFF64(xfs_buf_daddr(bplist[num-1])) +
 				BBTOB(bplist[num-1]->b_length);
 		}
 		if (num < ((last_off - first_off) >> (mp->m_sb.sb_blocklog + 3))) {
@@ -538,7 +538,7 @@ pf_batch_read(
 			 */
 			last_off = first_off + BBTOB(bplist[0]->b_length);
 			for (i = 1; i < num; i++) {
-				next_off = LIBXFS_BBTOOFF64(XFS_BUF_ADDR(bplist[i])) +
+				next_off = LIBXFS_BBTOOFF64(xfs_buf_daddr(bplist[i])) +
 						BBTOB(bplist[i]->b_length);
 				if (next_off - last_off > pf_batch_bytes)
 					break;
@@ -549,7 +549,7 @@ pf_batch_read(
 
 		for (i = 0; i < num; i++) {
 			if (btree_delete(args->io_queue, XFS_DADDR_TO_FSB(mp,
-					XFS_BUF_ADDR(bplist[i]))) == NULL)
+					xfs_buf_daddr(bplist[i]))) == NULL)
 				do_error(_("prefetch corruption\n"));
 		}
 
@@ -565,8 +565,8 @@ pf_batch_read(
 		}
 #ifdef XR_PF_TRACE
 		pftrace("reading bbs %llu to %llu (%d bufs) from %s queue in AG %d (last_bno = %lu, inode_bufs = %d)",
-			(long long)XFS_BUF_ADDR(bplist[0]),
-			(long long)XFS_BUF_ADDR(bplist[num-1]), num,
+			(long long)xfs_buf_daddr(bplist[0]),
+			(long long)xfs_buf_daddr(bplist[num-1]), num,
 			(which != PF_SECONDARY) ? "pri" : "sec", args->agno,
 			args->last_bno_read, args->inode_bufs_queued);
 #endif
@@ -597,7 +597,7 @@ pf_batch_read(
 			 */
 			for (i = 0; i < num; i++) {
 
-				pbuf = ((char *)buf) + (LIBXFS_BBTOOFF64(XFS_BUF_ADDR(bplist[i])) - first_off);
+				pbuf = ((char *)buf) + (LIBXFS_BBTOOFF64(xfs_buf_daddr(bplist[i])) - first_off);
 				size = BBTOB(bplist[i]->b_length);
 				if (len < size)
 					break;
@@ -619,7 +619,7 @@ pf_batch_read(
 			pftrace("putbuf %c %p (%llu) in AG %d",
 				B_IS_INODE(libxfs_buf_priority(bplist[i])) ?
 								      'I' : 'M',
-				bplist[i], (long long)XFS_BUF_ADDR(bplist[i]),
+				bplist[i], (long long)xfs_buf_daddr(bplist[i]),
 				args->agno);
 			libxfs_buf_relse(bplist[i]);
 		}

