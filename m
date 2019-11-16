Return-Path: <SRS0=QPje=ZI=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A73CC432C3
	for <linux-xfs@archiver.kernel.org>; Sat, 16 Nov 2019 18:22:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D76312068D
	for <linux-xfs@archiver.kernel.org>; Sat, 16 Nov 2019 18:22:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Gfff0wnp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727698AbfKPSWi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 16 Nov 2019 13:22:38 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:35046 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727656AbfKPSWi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 16 Nov 2019 13:22:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=8REHYeRslwBVXoZ25W/PbmHlKapamGkOJHarfZ+e998=; b=Gfff0wnps682qljkSEEANxrNmD
        tNdQI62tV7xhcD0HoTohINK85jUwL/WhAMpJe/SYCMteA0QwTbdM1iZJGGX5TGyb1qwKQLet/7Nsi
        HMDrpItyIPtVpxQQeZvBweS50BK02DCYiyqIienM+rOUJuRanp89fgMAdJVPrPuxuFV22DbClmM2V
        Edd+6lLx6jWbc8JtHXlgnkkZ9pFXFi7kYxAyIpudOG9Za8LhlkyCoSZxnuZmKnlw6YTvVZeWsmOXV
        Hd56XEiBccm+AEfMONdbkn4cMsp/4yByrrN/HP0u5O37S4oIF6up3q1jJZS0I5x5CFYokHlneoX5A
        gWo1MCoQ==;
Received: from [2001:4bb8:180:3806:c70:4a89:bc61:6] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iW2iT-0006j8-Ny; Sat, 16 Nov 2019 18:22:38 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Allison Collins <allison.henderson@oracle.com>
Subject: [PATCH 7/9] xfs: split xfs_da3_node_read
Date:   Sat, 16 Nov 2019 19:22:12 +0100
Message-Id: <20191116182214.23711-8-hch@lst.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191116182214.23711-1-hch@lst.de>
References: <20191116182214.23711-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Split xfs_da3_node_read into one variant that always looks up the daddr
and doesn't accept holes, and one that already has a daddr at hand.
This is in preparation of splitting up xfs_da_read_buf in a similar way.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_attr.c     |  14 ++---
 fs/xfs/libxfs/xfs_da_btree.c | 111 ++++++++++++++++++++---------------
 fs/xfs/libxfs/xfs_da_btree.h |   6 +-
 fs/xfs/xfs_attr_inactive.c   |   8 +--
 fs/xfs/xfs_attr_list.c       |   6 +-
 5 files changed, 82 insertions(+), 63 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index ebe6b0575f40..0d7fcc983b3d 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -1266,10 +1266,9 @@ xfs_attr_refillstate(xfs_da_state_t *state)
 	ASSERT((path->active >= 0) && (path->active < XFS_DA_NODE_MAXDEPTH));
 	for (blk = path->blk, level = 0; level < path->active; blk++, level++) {
 		if (blk->disk_blkno) {
-			error = xfs_da3_node_read(state->args->trans,
-						state->args->dp,
-						blk->blkno, blk->disk_blkno,
-						&blk->bp, XFS_ATTR_FORK);
+			error = xfs_da3_node_read_mapped(state->args->trans,
+					state->args->dp, blk->disk_blkno,
+					&blk->bp, XFS_ATTR_FORK);
 			if (error)
 				return error;
 		} else {
@@ -1285,10 +1284,9 @@ xfs_attr_refillstate(xfs_da_state_t *state)
 	ASSERT((path->active >= 0) && (path->active < XFS_DA_NODE_MAXDEPTH));
 	for (blk = path->blk, level = 0; level < path->active; blk++, level++) {
 		if (blk->disk_blkno) {
-			error = xfs_da3_node_read(state->args->trans,
-						state->args->dp,
-						blk->blkno, blk->disk_blkno,
-						&blk->bp, XFS_ATTR_FORK);
+			error = xfs_da3_node_read_mapped(state->args->trans,
+					state->args->dp, blk->disk_blkno,
+					&blk->bp, XFS_ATTR_FORK);
 			if (error)
 				return error;
 		} else {
diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
index b1b0b38d7747..489936e01c33 100644
--- a/fs/xfs/libxfs/xfs_da_btree.c
+++ b/fs/xfs/libxfs/xfs_da_btree.c
@@ -331,46 +331,66 @@ const struct xfs_buf_ops xfs_da3_node_buf_ops = {
 	.verify_struct = xfs_da3_node_verify_struct,
 };
 
+static int
+xfs_da3_node_set_type(
+	struct xfs_trans	*tp,
+	struct xfs_buf		*bp)
+{
+	struct xfs_da_blkinfo	*info = bp->b_addr;
+
+	switch (be16_to_cpu(info->magic)) {
+	case XFS_DA_NODE_MAGIC:
+	case XFS_DA3_NODE_MAGIC:
+		xfs_trans_buf_set_type(tp, bp, XFS_BLFT_DA_NODE_BUF);
+		return 0;
+	case XFS_ATTR_LEAF_MAGIC:
+	case XFS_ATTR3_LEAF_MAGIC:
+		xfs_trans_buf_set_type(tp, bp, XFS_BLFT_ATTR_LEAF_BUF);
+		return 0;
+	case XFS_DIR2_LEAFN_MAGIC:
+	case XFS_DIR3_LEAFN_MAGIC:
+		xfs_trans_buf_set_type(tp, bp, XFS_BLFT_DIR_LEAFN_BUF);
+		return 0;
+	default:
+		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, tp->t_mountp,
+				info, sizeof(*info));
+		xfs_trans_brelse(tp, bp);
+		return -EFSCORRUPTED;
+	}
+}
+
 int
 xfs_da3_node_read(
 	struct xfs_trans	*tp,
 	struct xfs_inode	*dp,
 	xfs_dablk_t		bno,
-	xfs_daddr_t		mappedbno,
 	struct xfs_buf		**bpp,
-	int			which_fork)
+	int			whichfork)
 {
-	int			err;
+	int			error;
 
-	err = xfs_da_read_buf(tp, dp, bno, mappedbno, bpp,
-					which_fork, &xfs_da3_node_buf_ops);
-	if (!err && tp && *bpp) {
-		struct xfs_da_blkinfo	*info = (*bpp)->b_addr;
-		int			type;
+	error = xfs_da_read_buf(tp, dp, bno, -1, bpp, whichfork,
+			&xfs_da3_node_buf_ops);
+	if (error || !*bpp || !tp)
+		return error;
+	return xfs_da3_node_set_type(tp, *bpp);
+}
 
-		switch (be16_to_cpu(info->magic)) {
-		case XFS_DA_NODE_MAGIC:
-		case XFS_DA3_NODE_MAGIC:
-			type = XFS_BLFT_DA_NODE_BUF;
-			break;
-		case XFS_ATTR_LEAF_MAGIC:
-		case XFS_ATTR3_LEAF_MAGIC:
-			type = XFS_BLFT_ATTR_LEAF_BUF;
-			break;
-		case XFS_DIR2_LEAFN_MAGIC:
-		case XFS_DIR3_LEAFN_MAGIC:
-			type = XFS_BLFT_DIR_LEAFN_BUF;
-			break;
-		default:
-			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW,
-					tp->t_mountp, info, sizeof(*info));
-			xfs_trans_brelse(tp, *bpp);
-			*bpp = NULL;
-			return -EFSCORRUPTED;
-		}
-		xfs_trans_buf_set_type(tp, *bpp, type);
-	}
-	return err;
+int
+xfs_da3_node_read_mapped(
+	struct xfs_trans	*tp,
+	struct xfs_inode	*dp,
+	xfs_daddr_t		mappedbno,
+	struct xfs_buf		**bpp,
+	int			whichfork)
+{
+	int			error;
+
+	error = xfs_da_read_buf(tp, dp, 0, mappedbno, bpp, whichfork,
+			&xfs_da3_node_buf_ops);
+	if (error || !*bpp || !tp)
+		return error;
+	return xfs_da3_node_set_type(tp, *bpp);
 }
 
 /*========================================================================
@@ -1166,8 +1186,7 @@ xfs_da3_root_join(
 	 */
 	child = be32_to_cpu(oldroothdr.btree[0].before);
 	ASSERT(child != 0);
-	error = xfs_da3_node_read(args->trans, dp, child, -1, &bp,
-					     args->whichfork);
+	error = xfs_da3_node_read(args->trans, dp, child, &bp, args->whichfork);
 	if (error)
 		return error;
 	xfs_da_blkinfo_onlychild_validate(bp->b_addr, oldroothdr.level);
@@ -1281,8 +1300,8 @@ xfs_da3_node_toosmall(
 			blkno = nodehdr.back;
 		if (blkno == 0)
 			continue;
-		error = xfs_da3_node_read(state->args->trans, dp,
-					blkno, -1, &bp, state->args->whichfork);
+		error = xfs_da3_node_read(state->args->trans, dp, blkno, &bp,
+				state->args->whichfork);
 		if (error)
 			return error;
 
@@ -1570,7 +1589,7 @@ xfs_da3_node_lookup_int(
 		 */
 		blk->blkno = blkno;
 		error = xfs_da3_node_read(args->trans, args->dp, blkno,
-					-1, &blk->bp, args->whichfork);
+					&blk->bp, args->whichfork);
 		if (error) {
 			blk->blkno = 0;
 			state->path.active--;
@@ -1809,7 +1828,7 @@ xfs_da3_blk_link(
 		if (old_info->back) {
 			error = xfs_da3_node_read(args->trans, dp,
 						be32_to_cpu(old_info->back),
-						-1, &bp, args->whichfork);
+						&bp, args->whichfork);
 			if (error)
 				return error;
 			ASSERT(bp != NULL);
@@ -1830,7 +1849,7 @@ xfs_da3_blk_link(
 		if (old_info->forw) {
 			error = xfs_da3_node_read(args->trans, dp,
 						be32_to_cpu(old_info->forw),
-						-1, &bp, args->whichfork);
+						&bp, args->whichfork);
 			if (error)
 				return error;
 			ASSERT(bp != NULL);
@@ -1889,7 +1908,7 @@ xfs_da3_blk_unlink(
 		if (drop_info->back) {
 			error = xfs_da3_node_read(args->trans, args->dp,
 						be32_to_cpu(drop_info->back),
-						-1, &bp, args->whichfork);
+						&bp, args->whichfork);
 			if (error)
 				return error;
 			ASSERT(bp != NULL);
@@ -1906,7 +1925,7 @@ xfs_da3_blk_unlink(
 		if (drop_info->forw) {
 			error = xfs_da3_node_read(args->trans, args->dp,
 						be32_to_cpu(drop_info->forw),
-						-1, &bp, args->whichfork);
+						&bp, args->whichfork);
 			if (error)
 				return error;
 			ASSERT(bp != NULL);
@@ -1990,7 +2009,7 @@ xfs_da3_path_shift(
 		/*
 		 * Read the next child block into a local buffer.
 		 */
-		error = xfs_da3_node_read(args->trans, dp, blkno, -1, &bp,
+		error = xfs_da3_node_read(args->trans, dp, blkno, &bp,
 					  args->whichfork);
 		if (error)
 			return error;
@@ -2283,7 +2302,7 @@ xfs_da3_swap_lastblock(
 	 * Read the last block in the btree space.
 	 */
 	last_blkno = (xfs_dablk_t)lastoff - args->geo->fsbcount;
-	error = xfs_da3_node_read(tp, dp, last_blkno, -1, &last_buf, w);
+	error = xfs_da3_node_read(tp, dp, last_blkno, &last_buf, w);
 	if (error)
 		return error;
 	/*
@@ -2320,7 +2339,7 @@ xfs_da3_swap_lastblock(
 	 * If the moved block has a left sibling, fix up the pointers.
 	 */
 	if ((sib_blkno = be32_to_cpu(dead_info->back))) {
-		error = xfs_da3_node_read(tp, dp, sib_blkno, -1, &sib_buf, w);
+		error = xfs_da3_node_read(tp, dp, sib_blkno, &sib_buf, w);
 		if (error)
 			goto done;
 		sib_info = sib_buf->b_addr;
@@ -2342,7 +2361,7 @@ xfs_da3_swap_lastblock(
 	 * If the moved block has a right sibling, fix up the pointers.
 	 */
 	if ((sib_blkno = be32_to_cpu(dead_info->forw))) {
-		error = xfs_da3_node_read(tp, dp, sib_blkno, -1, &sib_buf, w);
+		error = xfs_da3_node_read(tp, dp, sib_blkno, &sib_buf, w);
 		if (error)
 			goto done;
 		sib_info = sib_buf->b_addr;
@@ -2366,7 +2385,7 @@ xfs_da3_swap_lastblock(
 	 * Walk down the tree looking for the parent of the moved block.
 	 */
 	for (;;) {
-		error = xfs_da3_node_read(tp, dp, par_blkno, -1, &par_buf, w);
+		error = xfs_da3_node_read(tp, dp, par_blkno, &par_buf, w);
 		if (error)
 			goto done;
 		par_node = par_buf->b_addr;
@@ -2417,7 +2436,7 @@ xfs_da3_swap_lastblock(
 			error = -EFSCORRUPTED;
 			goto done;
 		}
-		error = xfs_da3_node_read(tp, dp, par_blkno, -1, &par_buf, w);
+		error = xfs_da3_node_read(tp, dp, par_blkno, &par_buf, w);
 		if (error)
 			goto done;
 		par_node = par_buf->b_addr;
diff --git a/fs/xfs/libxfs/xfs_da_btree.h b/fs/xfs/libxfs/xfs_da_btree.h
index 4ba0ded7b973..74eeb97852d8 100644
--- a/fs/xfs/libxfs/xfs_da_btree.h
+++ b/fs/xfs/libxfs/xfs_da_btree.h
@@ -198,8 +198,10 @@ int	xfs_da3_path_shift(xfs_da_state_t *state, xfs_da_state_path_t *path,
 int	xfs_da3_blk_link(xfs_da_state_t *state, xfs_da_state_blk_t *old_blk,
 				       xfs_da_state_blk_t *new_blk);
 int	xfs_da3_node_read(struct xfs_trans *tp, struct xfs_inode *dp,
-			 xfs_dablk_t bno, xfs_daddr_t mappedbno,
-			 struct xfs_buf **bpp, int which_fork);
+			xfs_dablk_t bno, struct xfs_buf **bpp, int whichfork);
+int	xfs_da3_node_read_mapped(struct xfs_trans *tp, struct xfs_inode *dp,
+			xfs_daddr_t mappedbno, struct xfs_buf **bpp,
+			int whichfork);
 
 /*
  * Utility routines.
diff --git a/fs/xfs/xfs_attr_inactive.c b/fs/xfs/xfs_attr_inactive.c
index a78c501f6fb1..f1cafd82ec75 100644
--- a/fs/xfs/xfs_attr_inactive.c
+++ b/fs/xfs/xfs_attr_inactive.c
@@ -233,7 +233,7 @@ xfs_attr3_node_inactive(
 		 * traversal of the tree so we may deal with many blocks
 		 * before we come back to this one.
 		 */
-		error = xfs_da3_node_read(*trans, dp, child_fsb, -1, &child_bp,
+		error = xfs_da3_node_read(*trans, dp, child_fsb, &child_bp,
 					  XFS_ATTR_FORK);
 		if (error)
 			return error;
@@ -280,8 +280,8 @@ xfs_attr3_node_inactive(
 		if (i + 1 < ichdr.count) {
 			struct xfs_da3_icnode_hdr phdr;
 
-			error = xfs_da3_node_read(*trans, dp, 0, parent_blkno,
-						 &bp, XFS_ATTR_FORK);
+			error = xfs_da3_node_read_mapped(*trans, dp,
+					parent_blkno, &bp, XFS_ATTR_FORK);
 			if (error)
 				return error;
 			xfs_da3_node_hdr_from_disk(dp->i_mount, &phdr,
@@ -322,7 +322,7 @@ xfs_attr3_root_inactive(
 	 * the extents in reverse order the extent containing
 	 * block 0 must still be there.
 	 */
-	error = xfs_da3_node_read(*trans, dp, 0, -1, &bp, XFS_ATTR_FORK);
+	error = xfs_da3_node_read(*trans, dp, 0, &bp, XFS_ATTR_FORK);
 	if (error)
 		return error;
 	blkno = bp->b_bn;
diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
index 426f93cfb2ea..8afbb30be002 100644
--- a/fs/xfs/xfs_attr_list.c
+++ b/fs/xfs/xfs_attr_list.c
@@ -224,7 +224,7 @@ xfs_attr_node_list_lookup(
 	ASSERT(*pbp == NULL);
 	cursor->blkno = 0;
 	for (;;) {
-		error = xfs_da3_node_read(tp, dp, cursor->blkno, -1, &bp,
+		error = xfs_da3_node_read(tp, dp, cursor->blkno, &bp,
 				XFS_ATTR_FORK);
 		if (error)
 			return error;
@@ -312,8 +312,8 @@ xfs_attr_node_list(
 	 */
 	bp = NULL;
 	if (cursor->blkno > 0) {
-		error = xfs_da3_node_read(context->tp, dp, cursor->blkno, -1,
-					      &bp, XFS_ATTR_FORK);
+		error = xfs_da3_node_read(context->tp, dp, cursor->blkno, &bp,
+				XFS_ATTR_FORK);
 		if ((error != 0) && (error != -EFSCORRUPTED))
 			return error;
 		if (bp) {
-- 
2.20.1

