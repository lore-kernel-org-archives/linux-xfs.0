Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1279BC4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 23:58:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235835AbiL3X6P (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 18:58:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229827AbiL3X6N (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 18:58:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFF3A16588
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 15:58:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3F5DC61C9A
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 23:58:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96989C433EF;
        Fri, 30 Dec 2022 23:58:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672444691;
        bh=12ZAdP1OeOfoNk56OP4+EC84YmxY4/zvcOtBO1TGJnc=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=UMBkxEPbC9hK1dZPCDcTinDaGiIMr88uJYh5aNQ+sKC4I5jth8802EoO70odEr3za
         3d5bTWt2RsVOiB3fGF70yUUeeiiW/WbxqdLQC3KegwGdqDVZAJtft6eCBBdeFcscn3
         qFmvblYmyp07rh3iw4gZjElE48hF0ziv4mj6eq/VLqAjQ9Byhs7Ex36I2tKOLtZnpq
         THsQXE1gqUEXgDsASsmkERfDbqCCAmCYH83XGGIrm1pxxf9bL00bTtxWFLb50AwzGK
         GaK3JS6yy9LR94Ufd4ZvjqVPpffvYXoAoNM72YRKvJNxb1f8pmWrFJm73G1zwdUFES
         co7DEDfSAziAQ==
Subject: [PATCH 3/9] xfs: validate attr leaf buffer owners
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:14:08 -0800
Message-ID: <167243844877.700244.14517504565083192435.stgit@magnolia>
In-Reply-To: <167243844821.700244.10251762547708755105.stgit@magnolia>
References: <167243844821.700244.10251762547708755105.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Create a leaf block header checking function to validate the owner field
of xattr leaf blocks.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_attr.c      |   10 ++++---
 fs/xfs/libxfs/xfs_attr_leaf.c |   55 ++++++++++++++++++++++++++++++++++-------
 fs/xfs/libxfs/xfs_attr_leaf.h |    4 ++-
 fs/xfs/libxfs/xfs_da_btree.c  |   42 +++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_da_btree.h  |    1 +
 fs/xfs/libxfs/xfs_swapext.c   |    3 +-
 fs/xfs/scrub/dabtree.c        |    7 +++++
 fs/xfs/xfs_attr_list.c        |   25 ++++++++++++++++---
 8 files changed, 128 insertions(+), 19 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index e28d93d232de..564345a17119 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -647,8 +647,8 @@ xfs_attr_leaf_remove_attr(
 	int				forkoff;
 	int				error;
 
-	error = xfs_attr3_leaf_read(args->trans, args->dp, args->blkno,
-				   &bp);
+	error = xfs_attr3_leaf_read(args->trans, args->dp, args->owner,
+			args->blkno, &bp);
 	if (error)
 		return error;
 
@@ -679,7 +679,7 @@ xfs_attr_leaf_shrink(
 	if (!xfs_attr_is_leaf(dp))
 		return 0;
 
-	error = xfs_attr3_leaf_read(args->trans, args->dp, 0, &bp);
+	error = xfs_attr3_leaf_read(args->trans, args->dp, args->owner, 0, &bp);
 	if (error)
 		return error;
 
@@ -1208,7 +1208,7 @@ xfs_attr_leaf_try_add(
 	struct xfs_buf		*bp;
 	int			error;
 
-	error = xfs_attr3_leaf_read(args->trans, args->dp, 0, &bp);
+	error = xfs_attr3_leaf_read(args->trans, args->dp, args->owner, 0, &bp);
 	if (error)
 		return error;
 
@@ -1256,7 +1256,7 @@ xfs_attr_leaf_hasname(
 {
 	int                     error = 0;
 
-	error = xfs_attr3_leaf_read(args->trans, args->dp, 0, bp);
+	error = xfs_attr3_leaf_read(args->trans, args->dp, args->owner, 0, bp);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index 9ce886d5e53d..1f3febeccbe0 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -388,6 +388,26 @@ xfs_attr3_leaf_verify(
 	return NULL;
 }
 
+xfs_failaddr_t
+xfs_attr3_leaf_header_check(
+	struct xfs_buf		*bp,
+	xfs_ino_t		owner)
+{
+	struct xfs_mount	*mp = bp->b_mount;
+
+	if (xfs_has_crc(mp)) {
+		struct xfs_attr3_leafblock *hdr3 = bp->b_addr;
+
+		ASSERT(hdr3->hdr.info.hdr.magic ==
+				cpu_to_be16(XFS_ATTR3_LEAF_MAGIC));
+
+		if (be64_to_cpu(hdr3->hdr.info.owner) != owner)
+			return __this_address;
+	}
+
+	return NULL;
+}
+
 static void
 xfs_attr3_leaf_write_verify(
 	struct xfs_buf	*bp)
@@ -448,16 +468,30 @@ int
 xfs_attr3_leaf_read(
 	struct xfs_trans	*tp,
 	struct xfs_inode	*dp,
+	xfs_ino_t		owner,
 	xfs_dablk_t		bno,
 	struct xfs_buf		**bpp)
 {
+	xfs_failaddr_t		fa;
 	int			err;
 
 	err = xfs_da_read_buf(tp, dp, bno, 0, bpp, XFS_ATTR_FORK,
 			&xfs_attr3_leaf_buf_ops);
-	if (!err && tp && *bpp)
+	if (err || !(*bpp))
+		return err;
+
+	fa = xfs_attr3_leaf_header_check(*bpp, owner);
+	if (fa) {
+		__xfs_buf_mark_corrupt(*bpp, fa);
+		xfs_trans_brelse(tp, *bpp);
+		*bpp = NULL;
+		xfs_dirattr_mark_sick(dp, XFS_ATTR_FORK);
+		return -EFSCORRUPTED;
+	}
+
+	if (tp)
 		xfs_trans_buf_set_type(tp, *bpp, XFS_BLFT_ATTR_LEAF_BUF);
-	return err;
+	return 0;
 }
 
 /*========================================================================
@@ -1249,7 +1283,7 @@ xfs_attr3_leaf_to_node(
 	error = xfs_da_grow_inode(args, &blkno);
 	if (error)
 		goto out;
-	error = xfs_attr3_leaf_read(args->trans, dp, 0, &bp1);
+	error = xfs_attr3_leaf_read(args->trans, dp, args->owner, 0, &bp1);
 	if (error)
 		goto out;
 
@@ -2088,7 +2122,7 @@ xfs_attr3_leaf_toosmall(
 		if (blkno == 0)
 			continue;
 		error = xfs_attr3_leaf_read(state->args->trans, state->args->dp,
-					blkno, &bp);
+					state->args->owner, blkno, &bp);
 		if (error)
 			return error;
 
@@ -2811,7 +2845,8 @@ xfs_attr3_leaf_clearflag(
 	/*
 	 * Set up the operation.
 	 */
-	error = xfs_attr3_leaf_read(args->trans, args->dp, args->blkno, &bp);
+	error = xfs_attr3_leaf_read(args->trans, args->dp, args->owner,
+			args->blkno, &bp);
 	if (error)
 		return error;
 
@@ -2875,7 +2910,8 @@ xfs_attr3_leaf_setflag(
 	/*
 	 * Set up the operation.
 	 */
-	error = xfs_attr3_leaf_read(args->trans, args->dp, args->blkno, &bp);
+	error = xfs_attr3_leaf_read(args->trans, args->dp, args->owner,
+			args->blkno, &bp);
 	if (error)
 		return error;
 
@@ -2934,7 +2970,8 @@ xfs_attr3_leaf_flipflags(
 	/*
 	 * Read the block containing the "old" attr
 	 */
-	error = xfs_attr3_leaf_read(args->trans, args->dp, args->blkno, &bp1);
+	error = xfs_attr3_leaf_read(args->trans, args->dp, args->owner,
+			args->blkno, &bp1);
 	if (error)
 		return error;
 
@@ -2942,8 +2979,8 @@ xfs_attr3_leaf_flipflags(
 	 * Read the block containing the "new" attr, if it is different
 	 */
 	if (args->blkno2 != args->blkno) {
-		error = xfs_attr3_leaf_read(args->trans, args->dp, args->blkno2,
-					   &bp2);
+		error = xfs_attr3_leaf_read(args->trans, args->dp, args->owner,
+				args->blkno2, &bp2);
 		if (error)
 			return error;
 	} else {
diff --git a/fs/xfs/libxfs/xfs_attr_leaf.h b/fs/xfs/libxfs/xfs_attr_leaf.h
index 0711a448f64c..e585317dc680 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.h
+++ b/fs/xfs/libxfs/xfs_attr_leaf.h
@@ -102,12 +102,14 @@ int	xfs_attr_leaf_order(struct xfs_buf *leaf1_bp,
 				   struct xfs_buf *leaf2_bp);
 int	xfs_attr_leaf_newentsize(struct xfs_da_args *args, int *local);
 int	xfs_attr3_leaf_read(struct xfs_trans *tp, struct xfs_inode *dp,
-			xfs_dablk_t bno, struct xfs_buf **bpp);
+			xfs_ino_t owner, xfs_dablk_t bno, struct xfs_buf **bpp);
 void	xfs_attr3_leaf_hdr_from_disk(struct xfs_da_geometry *geo,
 				     struct xfs_attr3_icleaf_hdr *to,
 				     struct xfs_attr_leafblock *from);
 void	xfs_attr3_leaf_hdr_to_disk(struct xfs_da_geometry *geo,
 				   struct xfs_attr_leafblock *to,
 				   struct xfs_attr3_icleaf_hdr *from);
+xfs_failaddr_t xfs_attr3_leaf_header_check(struct xfs_buf *bp,
+		xfs_ino_t owner);
 
 #endif	/* __XFS_ATTR_LEAF_H__ */
diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
index b0d1aad1fbbb..0349e10552f6 100644
--- a/fs/xfs/libxfs/xfs_da_btree.c
+++ b/fs/xfs/libxfs/xfs_da_btree.c
@@ -251,6 +251,25 @@ xfs_da3_node_verify(
 	return NULL;
 }
 
+xfs_failaddr_t
+xfs_da3_header_check(
+	struct xfs_buf		*bp,
+	xfs_ino_t		owner)
+{
+	struct xfs_mount	*mp = bp->b_mount;
+	struct xfs_da_blkinfo	*hdr = bp->b_addr;
+
+	if (!xfs_has_crc(mp))
+		return NULL;
+
+	switch (hdr->magic) {
+	case cpu_to_be16(XFS_ATTR3_LEAF_MAGIC):
+		return xfs_attr3_leaf_header_check(bp, owner);
+	}
+
+	return NULL;
+}
+
 static void
 xfs_da3_node_write_verify(
 	struct xfs_buf	*bp)
@@ -1598,6 +1617,7 @@ xfs_da3_node_lookup_int(
 	struct xfs_da_node_entry *btree;
 	struct xfs_da3_icnode_hdr nodehdr;
 	struct xfs_da_args	*args;
+	xfs_failaddr_t		fa;
 	xfs_dablk_t		blkno;
 	xfs_dahash_t		hashval;
 	xfs_dahash_t		btreehashval;
@@ -1636,6 +1656,12 @@ xfs_da3_node_lookup_int(
 
 		if (magic == XFS_ATTR_LEAF_MAGIC ||
 		    magic == XFS_ATTR3_LEAF_MAGIC) {
+			fa = xfs_attr3_leaf_header_check(blk->bp, args->owner);
+			if (fa) {
+				__xfs_buf_mark_corrupt(blk->bp, fa);
+				xfs_da_mark_sick(args);
+				return -EFSCORRUPTED;
+			}
 			blk->magic = XFS_ATTR_LEAF_MAGIC;
 			blk->hashval = xfs_attr_leaf_lasthash(blk->bp, NULL);
 			break;
@@ -2003,6 +2029,7 @@ xfs_da3_path_shift(
 	struct xfs_da_node_entry *btree;
 	struct xfs_da3_icnode_hdr nodehdr;
 	struct xfs_buf		*bp;
+	xfs_failaddr_t		fa;
 	xfs_dablk_t		blkno = 0;
 	int			level;
 	int			error;
@@ -2094,6 +2121,12 @@ xfs_da3_path_shift(
 			break;
 		case XFS_ATTR_LEAF_MAGIC:
 		case XFS_ATTR3_LEAF_MAGIC:
+			fa = xfs_attr3_leaf_header_check(blk->bp, args->owner);
+			if (fa) {
+				__xfs_buf_mark_corrupt(blk->bp, fa);
+				xfs_da_mark_sick(args);
+				return -EFSCORRUPTED;
+			}
 			blk->magic = XFS_ATTR_LEAF_MAGIC;
 			ASSERT(level == path->active-1);
 			blk->index = 0;
@@ -2296,6 +2329,7 @@ xfs_da3_swap_lastblock(
 	struct xfs_buf		*last_buf;
 	struct xfs_buf		*sib_buf;
 	struct xfs_buf		*par_buf;
+	xfs_failaddr_t		fa;
 	xfs_dahash_t		dead_hash;
 	xfs_fileoff_t		lastoff;
 	xfs_dablk_t		dead_blkno;
@@ -2332,6 +2366,14 @@ xfs_da3_swap_lastblock(
 	error = xfs_da3_node_read(tp, dp, last_blkno, &last_buf, w);
 	if (error)
 		return error;
+	fa = xfs_da3_header_check(last_buf, args->owner);
+	if (fa) {
+		__xfs_buf_mark_corrupt(last_buf, fa);
+		xfs_trans_brelse(tp, last_buf);
+		xfs_da_mark_sick(args);
+		return -EFSCORRUPTED;
+	}
+
 	/*
 	 * Copy the last block into the dead buffer and log it.
 	 */
diff --git a/fs/xfs/libxfs/xfs_da_btree.h b/fs/xfs/libxfs/xfs_da_btree.h
index 52694dc0cd3c..0b9e467663b6 100644
--- a/fs/xfs/libxfs/xfs_da_btree.h
+++ b/fs/xfs/libxfs/xfs_da_btree.h
@@ -234,6 +234,7 @@ void	xfs_da3_node_hdr_from_disk(struct xfs_mount *mp,
 		struct xfs_da3_icnode_hdr *to, struct xfs_da_intnode *from);
 void	xfs_da3_node_hdr_to_disk(struct xfs_mount *mp,
 		struct xfs_da_intnode *to, struct xfs_da3_icnode_hdr *from);
+xfs_failaddr_t xfs_da3_header_check(struct xfs_buf *bp, xfs_ino_t owner);
 
 extern struct kmem_cache	*xfs_da_state_cache;
 
diff --git a/fs/xfs/libxfs/xfs_swapext.c b/fs/xfs/libxfs/xfs_swapext.c
index 65b1ccb162ad..063922989d77 100644
--- a/fs/xfs/libxfs/xfs_swapext.c
+++ b/fs/xfs/libxfs/xfs_swapext.c
@@ -475,7 +475,8 @@ xfs_swapext_attr_to_sf(
 	if (!xfs_attr_is_leaf(sxi->sxi_ip2))
 		return 0;
 
-	error = xfs_attr3_leaf_read(tp, sxi->sxi_ip2, 0, &bp);
+	error = xfs_attr3_leaf_read(tp, sxi->sxi_ip2, sxi->sxi_ip2->i_ino, 0,
+			&bp);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/scrub/dabtree.c b/fs/xfs/scrub/dabtree.c
index c8274a7e0cfd..e60b4cc96c54 100644
--- a/fs/xfs/scrub/dabtree.c
+++ b/fs/xfs/scrub/dabtree.c
@@ -320,6 +320,7 @@ xchk_da_btree_block(
 	struct xfs_da3_blkinfo		*hdr3;
 	struct xfs_da_args		*dargs = &ds->dargs;
 	struct xfs_inode		*ip = ds->dargs.dp;
+	xfs_failaddr_t			fa;
 	xfs_ino_t			owner;
 	int				*pmaxrecs;
 	struct xfs_da3_icnode_hdr	nodehdr;
@@ -442,6 +443,12 @@ xchk_da_btree_block(
 		goto out_freebp;
 	}
 
+	fa = xfs_da3_header_check(blk->bp, dargs->owner);
+	if (fa) {
+		xchk_da_set_corrupt(ds, level);
+		goto out_freebp;
+	}
+
 	/*
 	 * If we've been handed a block that is below the dabtree root, does
 	 * its hashval match what the parent block expected to see?
diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
index dcfa8e8e146a..2954ed7cfaf4 100644
--- a/fs/xfs/xfs_attr_list.c
+++ b/fs/xfs/xfs_attr_list.c
@@ -215,6 +215,7 @@ xfs_attr_node_list_lookup(
 	struct xfs_mount		*mp = dp->i_mount;
 	struct xfs_trans		*tp = context->tp;
 	struct xfs_buf			*bp;
+	xfs_failaddr_t			fa;
 	int				i;
 	int				error = 0;
 	unsigned int			expected_level = 0;
@@ -274,6 +275,12 @@ xfs_attr_node_list_lookup(
 		}
 	}
 
+	fa = xfs_attr3_leaf_header_check(bp, dp->i_ino);
+	if (fa) {
+		__xfs_buf_mark_corrupt(bp, fa);
+		goto out_releasebuf;
+	}
+
 	if (expected_level != 0)
 		goto out_corruptbuf;
 
@@ -282,6 +289,7 @@ xfs_attr_node_list_lookup(
 
 out_corruptbuf:
 	xfs_buf_mark_corrupt(bp);
+out_releasebuf:
 	xfs_trans_brelse(tp, bp);
 	xfs_dirattr_mark_sick(dp, XFS_ATTR_FORK);
 	return -EFSCORRUPTED;
@@ -298,6 +306,7 @@ xfs_attr_node_list(
 	struct xfs_buf			*bp;
 	struct xfs_inode		*dp = context->dp;
 	struct xfs_mount		*mp = dp->i_mount;
+	xfs_failaddr_t			fa;
 	int				error = 0;
 
 	trace_xfs_attr_node_list(context);
@@ -331,6 +340,15 @@ xfs_attr_node_list(
 			case XFS_ATTR_LEAF_MAGIC:
 			case XFS_ATTR3_LEAF_MAGIC:
 				leaf = bp->b_addr;
+				fa = xfs_attr3_leaf_header_check(bp,
+						dp->i_ino);
+				if (fa) {
+					__xfs_buf_mark_corrupt(bp, fa);
+					xfs_trans_brelse(context->tp, bp);
+					xfs_dirattr_mark_sick(dp, XFS_ATTR_FORK);
+					bp = NULL;
+					break;
+				}
 				xfs_attr3_leaf_hdr_from_disk(mp->m_attr_geo,
 							     &leafhdr, leaf);
 				entries = xfs_attr3_leaf_entryp(leaf);
@@ -381,8 +399,8 @@ xfs_attr_node_list(
 			break;
 		cursor->blkno = leafhdr.forw;
 		xfs_trans_brelse(context->tp, bp);
-		error = xfs_attr3_leaf_read(context->tp, dp, cursor->blkno,
-					    &bp);
+		error = xfs_attr3_leaf_read(context->tp, dp, dp->i_ino,
+				cursor->blkno, &bp);
 		if (error)
 			return error;
 	}
@@ -502,7 +520,8 @@ xfs_attr_leaf_list(
 	trace_xfs_attr_leaf_list(context);
 
 	context->cursor.blkno = 0;
-	error = xfs_attr3_leaf_read(context->tp, context->dp, 0, &bp);
+	error = xfs_attr3_leaf_read(context->tp, context->dp,
+			context->dp->i_ino, 0, &bp);
 	if (error)
 		return error;
 

