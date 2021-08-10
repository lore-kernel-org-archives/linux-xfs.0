Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B9CFC4320A
	for <linux-xfs@archiver.kernel.org>; Tue, 10 Aug 2021 05:28:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4C8F760295
	for <linux-xfs@archiver.kernel.org>; Tue, 10 Aug 2021 05:28:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237249AbhHJF3R (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 10 Aug 2021 01:29:17 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:49628 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231617AbhHJF3R (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 Aug 2021 01:29:17 -0400
Received: from dread.disaster.area (pa49-195-182-146.pa.nsw.optusnet.com.au [49.195.182.146])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id ABD9E1048324
        for <linux-xfs@vger.kernel.org>; Tue, 10 Aug 2021 15:28:54 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1mDKJq-00GZt8-4L
        for linux-xfs@vger.kernel.org; Tue, 10 Aug 2021 15:28:54 +1000
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1mDKJp-000B4G-Sq
        for linux-xfs@vger.kernel.org; Tue, 10 Aug 2021 15:28:53 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 1/3] xfs: introduce xfs_buf_daddr()
Date:   Tue, 10 Aug 2021 15:28:49 +1000
Message-Id: <20210810052851.42312-2-david@fromorbit.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210810052851.42312-1-david@fromorbit.com>
References: <20210810052851.42312-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0
        a=QpfB3wCSrn/dqEBSktpwZQ==:117 a=QpfB3wCSrn/dqEBSktpwZQ==:17
        a=MhDmnRu9jo8A:10 a=20KFwNOVAAAA:8 a=LZ-cIWIJuhyqz1JogpcA:9
        a=kEy8Ct4uVETcqRd_:21 a=0DUh5tAj3V6KcV65:21
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Introduce a helper function xfs_buf_daddr() to extract the disk
address of the buffer from the struct xfs_buf. This will replace
direct accesses to bp->b_bn and bp->b_maps[0].bm_bn, as well as
the XFS_BUF_ADDR() macro.

This patch introduces the helper function and replaces all uses of
XFS_BUF_ADDR() as this is just a simple sed replacement.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_alloc_btree.c    |  2 +-
 fs/xfs/libxfs/xfs_attr.c           |  4 ++--
 fs/xfs/libxfs/xfs_bmap.c           |  4 ++--
 fs/xfs/libxfs/xfs_bmap_btree.c     |  2 +-
 fs/xfs/libxfs/xfs_btree.c          | 10 +++++-----
 fs/xfs/libxfs/xfs_ialloc_btree.c   |  2 +-
 fs/xfs/libxfs/xfs_inode_buf.c      |  2 +-
 fs/xfs/libxfs/xfs_refcount_btree.c |  2 +-
 fs/xfs/libxfs/xfs_rmap_btree.c     |  2 +-
 fs/xfs/libxfs/xfs_sb.c             |  2 +-
 fs/xfs/scrub/btree.c               |  4 ++--
 fs/xfs/xfs_attr_inactive.c         |  2 +-
 fs/xfs/xfs_buf.c                   |  2 +-
 fs/xfs/xfs_buf.h                   |  6 +++++-
 fs/xfs/xfs_trans_buf.c             |  2 +-
 15 files changed, 26 insertions(+), 22 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc_btree.c b/fs/xfs/libxfs/xfs_alloc_btree.c
index 81a8e1d0cd90..7f69387609d3 100644
--- a/fs/xfs/libxfs/xfs_alloc_btree.c
+++ b/fs/xfs/libxfs/xfs_alloc_btree.c
@@ -87,7 +87,7 @@ xfs_allocbt_free_block(
 	xfs_agblock_t		bno;
 	int			error;
 
-	bno = xfs_daddr_to_agbno(cur->bc_mp, XFS_BUF_ADDR(bp));
+	bno = xfs_daddr_to_agbno(cur->bc_mp, xfs_buf_daddr(bp));
 	error = xfs_alloc_put_freelist(cur->bc_tp, agbp, NULL, bno, 1);
 	if (error)
 		return error;
diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 58fac02aad2a..270973d4a4ac 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -1541,7 +1541,7 @@ xfs_attr_fillstate(xfs_da_state_t *state)
 	ASSERT((path->active >= 0) && (path->active < XFS_DA_NODE_MAXDEPTH));
 	for (blk = path->blk, level = 0; level < path->active; blk++, level++) {
 		if (blk->bp) {
-			blk->disk_blkno = XFS_BUF_ADDR(blk->bp);
+			blk->disk_blkno = xfs_buf_daddr(blk->bp);
 			blk->bp = NULL;
 		} else {
 			blk->disk_blkno = 0;
@@ -1556,7 +1556,7 @@ xfs_attr_fillstate(xfs_da_state_t *state)
 	ASSERT((path->active >= 0) && (path->active < XFS_DA_NODE_MAXDEPTH));
 	for (blk = path->blk, level = 0; level < path->active; blk++, level++) {
 		if (blk->bp) {
-			blk->disk_blkno = XFS_BUF_ADDR(blk->bp);
+			blk->disk_blkno = xfs_buf_daddr(blk->bp);
 			blk->bp = NULL;
 		} else {
 			blk->disk_blkno = 0;
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 75354023cea7..d0bfa9a1f549 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -242,7 +242,7 @@ xfs_bmap_get_bp(
 	for (i = 0; i < XFS_BTREE_MAXLEVELS; i++) {
 		if (!cur->bc_bufs[i])
 			break;
-		if (XFS_BUF_ADDR(cur->bc_bufs[i]) == bno)
+		if (xfs_buf_daddr(cur->bc_bufs[i]) == bno)
 			return cur->bc_bufs[i];
 	}
 
@@ -251,7 +251,7 @@ xfs_bmap_get_bp(
 		struct xfs_buf_log_item	*bip = (struct xfs_buf_log_item *)lip;
 
 		if (bip->bli_item.li_type == XFS_LI_BUF &&
-		    XFS_BUF_ADDR(bip->bli_buf) == bno)
+		    xfs_buf_daddr(bip->bli_buf) == bno)
 			return bip->bli_buf;
 	}
 
diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
index c04b2a697b29..e0ae95c7b379 100644
--- a/fs/xfs/libxfs/xfs_bmap_btree.c
+++ b/fs/xfs/libxfs/xfs_bmap_btree.c
@@ -282,7 +282,7 @@ xfs_bmbt_free_block(
 	struct xfs_mount	*mp = cur->bc_mp;
 	struct xfs_inode	*ip = cur->bc_ino.ip;
 	struct xfs_trans	*tp = cur->bc_tp;
-	xfs_fsblock_t		fsbno = XFS_DADDR_TO_FSB(mp, XFS_BUF_ADDR(bp));
+	xfs_fsblock_t		fsbno = XFS_DADDR_TO_FSB(mp, xfs_buf_daddr(bp));
 	struct xfs_owner_info	oinfo;
 
 	xfs_rmap_ino_bmbt_owner(&oinfo, ip->i_ino, cur->bc_ino.whichfork);
diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index 393c9438d5a7..dc704c2b22cb 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -420,7 +420,7 @@ xfs_btree_dup_cursor(
 		bp = cur->bc_bufs[i];
 		if (bp) {
 			error = xfs_trans_read_buf(mp, tp, mp->m_ddev_targp,
-						   XFS_BUF_ADDR(bp), mp->m_bsize,
+						   xfs_buf_daddr(bp), mp->m_bsize,
 						   0, &bp,
 						   cur->bc_ops->buf_ops);
 			if (error) {
@@ -1192,10 +1192,10 @@ xfs_btree_buf_to_ptr(
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
 
@@ -1739,7 +1739,7 @@ xfs_btree_lookup_get_block(
 	error = xfs_btree_ptr_to_daddr(cur, pp, &daddr);
 	if (error)
 		return error;
-	if (bp && XFS_BUF_ADDR(bp) == daddr) {
+	if (bp && xfs_buf_daddr(bp) == daddr) {
 		*blkp = XFS_BUF_TO_BLOCK(bp);
 		return 0;
 	}
@@ -4499,7 +4499,7 @@ xfs_btree_sblock_verify(
 		return __this_address;
 
 	/* sibling pointer verification */
-	agno = xfs_daddr_to_agno(mp, XFS_BUF_ADDR(bp));
+	agno = xfs_daddr_to_agno(mp, xfs_buf_daddr(bp));
 	if (block->bb_u.s.bb_leftsib != cpu_to_be32(NULLAGBLOCK) &&
 	    !xfs_verify_agbno(mp, agno, be32_to_cpu(block->bb_u.s.bb_leftsib)))
 		return __this_address;
diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.c b/fs/xfs/libxfs/xfs_ialloc_btree.c
index f1384c280059..65a94741ce16 100644
--- a/fs/xfs/libxfs/xfs_ialloc_btree.c
+++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
@@ -156,7 +156,7 @@ __xfs_inobt_free_block(
 {
 	xfs_inobt_mod_blockcount(cur, -1);
 	return xfs_free_extent(cur->bc_tp,
-			XFS_DADDR_TO_FSB(cur->bc_mp, XFS_BUF_ADDR(bp)), 1,
+			XFS_DADDR_TO_FSB(cur->bc_mp, xfs_buf_daddr(bp)), 1,
 			&XFS_RMAP_OINFO_INOBT, resv);
 }
 
diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index 036f909ff7a6..83ba63b4ace4 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -48,7 +48,7 @@ xfs_inode_buf_verify(
 	/*
 	 * Validate the magic number and version of every inode in the buffer
 	 */
-	agno = xfs_daddr_to_agno(mp, XFS_BUF_ADDR(bp));
+	agno = xfs_daddr_to_agno(mp, xfs_buf_daddr(bp));
 	ni = XFS_BB_TO_FSB(mp, bp->b_length) * mp->m_sb.sb_inopblock;
 	for (i = 0; i < ni; i++) {
 		int		di_ok;
diff --git a/fs/xfs/libxfs/xfs_refcount_btree.c b/fs/xfs/libxfs/xfs_refcount_btree.c
index 31ce9d2d45e1..fd47dc934dae 100644
--- a/fs/xfs/libxfs/xfs_refcount_btree.c
+++ b/fs/xfs/libxfs/xfs_refcount_btree.c
@@ -102,7 +102,7 @@ xfs_refcountbt_free_block(
 	struct xfs_mount	*mp = cur->bc_mp;
 	struct xfs_buf		*agbp = cur->bc_ag.agbp;
 	struct xfs_agf		*agf = agbp->b_addr;
-	xfs_fsblock_t		fsbno = XFS_DADDR_TO_FSB(mp, XFS_BUF_ADDR(bp));
+	xfs_fsblock_t		fsbno = XFS_DADDR_TO_FSB(mp, xfs_buf_daddr(bp));
 	int			error;
 
 	trace_xfs_refcountbt_free_block(cur->bc_mp, cur->bc_ag.pag->pag_agno,
diff --git a/fs/xfs/libxfs/xfs_rmap_btree.c b/fs/xfs/libxfs/xfs_rmap_btree.c
index 921651fb4b1b..f0fe7aa09a43 100644
--- a/fs/xfs/libxfs/xfs_rmap_btree.c
+++ b/fs/xfs/libxfs/xfs_rmap_btree.c
@@ -122,7 +122,7 @@ xfs_rmapbt_free_block(
 	xfs_agblock_t		bno;
 	int			error;
 
-	bno = xfs_daddr_to_agbno(cur->bc_mp, XFS_BUF_ADDR(bp));
+	bno = xfs_daddr_to_agbno(cur->bc_mp, xfs_buf_daddr(bp));
 	trace_xfs_rmapbt_free_block(cur->bc_mp, pag->pag_agno,
 			bno, 1);
 	be32_add_cpu(&agf->agf_rmap_blocks, -1);
diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index 197093acb828..b1c5ec1bd200 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -192,7 +192,7 @@ xfs_validate_sb_write(
 	 * secondary superblocks, so allow this usage to continue because
 	 * we never read counters from such superblocks.
 	 */
-	if (XFS_BUF_ADDR(bp) == XFS_SB_DADDR && !sbp->sb_inprogress &&
+	if (xfs_buf_daddr(bp) == XFS_SB_DADDR && !sbp->sb_inprogress &&
 	    (sbp->sb_fdblocks > sbp->sb_dblocks ||
 	     !xfs_verify_icount(mp, sbp->sb_icount) ||
 	     sbp->sb_ifree > sbp->sb_icount)) {
diff --git a/fs/xfs/scrub/btree.c b/fs/xfs/scrub/btree.c
index c044e0a8da7f..fd832f103fa4 100644
--- a/fs/xfs/scrub/btree.c
+++ b/fs/xfs/scrub/btree.c
@@ -435,12 +435,12 @@ xchk_btree_check_owner(
 		if (!co)
 			return -ENOMEM;
 		co->level = level;
-		co->daddr = XFS_BUF_ADDR(bp);
+		co->daddr = xfs_buf_daddr(bp);
 		list_add_tail(&co->list, &bs->to_check);
 		return 0;
 	}
 
-	return xchk_btree_check_block_owner(bs, level, XFS_BUF_ADDR(bp));
+	return xchk_btree_check_block_owner(bs, level, xfs_buf_daddr(bp));
 }
 
 /* Decide if we want to check minrecs of a btree block in the inode root. */
diff --git a/fs/xfs/xfs_attr_inactive.c b/fs/xfs/xfs_attr_inactive.c
index aaa7e66c42d7..d8fdde206867 100644
--- a/fs/xfs/xfs_attr_inactive.c
+++ b/fs/xfs/xfs_attr_inactive.c
@@ -177,7 +177,7 @@ xfs_attr3_node_inactive(
 			return error;
 
 		/* save for re-read later */
-		child_blkno = XFS_BUF_ADDR(child_bp);
+		child_blkno = xfs_buf_daddr(child_bp);
 
 		/*
 		 * Invalidate the subtree, however we have to.
diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 82dd9bfa4265..c1bb6e41595b 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1335,7 +1335,7 @@ xfs_buf_ioerror_alert(
 {
 	xfs_buf_alert_ratelimited(bp, "XFS: metadata IO error",
 		"metadata I/O error in \"%pS\" at daddr 0x%llx len %d error %d",
-				  func, (uint64_t)XFS_BUF_ADDR(bp),
+				  func, (uint64_t)xfs_buf_daddr(bp),
 				  bp->b_length, -bp->b_error);
 }
 
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index 37c9004f11de..6db2fba44b46 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -311,9 +311,13 @@ extern void xfs_buf_terminate(void);
  * In future, uncached buffers will pass the block number directly to the io
  * request function and hence these macros will go away at that point.
  */
-#define XFS_BUF_ADDR(bp)		((bp)->b_maps[0].bm_bn)
 #define XFS_BUF_SET_ADDR(bp, bno)	((bp)->b_maps[0].bm_bn = (xfs_daddr_t)(bno))
 
+static inline xfs_daddr_t xfs_buf_daddr(struct xfs_buf *bp)
+{
+	return bp->b_maps[0].bm_bn;
+}
+
 void xfs_buf_set_ref(struct xfs_buf *bp, int lru_ref);
 
 /*
diff --git a/fs/xfs/xfs_trans_buf.c b/fs/xfs/xfs_trans_buf.c
index 4ff274ce31c4..6549e50d852c 100644
--- a/fs/xfs/xfs_trans_buf.c
+++ b/fs/xfs/xfs_trans_buf.c
@@ -38,7 +38,7 @@ xfs_trans_buf_item_match(
 		blip = (struct xfs_buf_log_item *)lip;
 		if (blip->bli_item.li_type == XFS_LI_BUF &&
 		    blip->bli_buf->b_target == target &&
-		    XFS_BUF_ADDR(blip->bli_buf) == map[0].bm_bn &&
+		    xfs_buf_daddr(blip->bli_buf) == map[0].bm_bn &&
 		    blip->bli_buf->b_length == len) {
 			ASSERT(blip->bli_buf->b_map_count == nmaps);
 			return blip->bli_buf;
-- 
2.31.1

