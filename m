Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29829F9C8
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 20:33:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="vDcZawuc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E631C433C7;
	Sun, 31 Dec 2023 20:33:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704054802;
	bh=rUQqjaRVauuQvCRb80s6C7udpZ3pFT0cUV+ntoHsR10=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=vDcZawuc8ilrqJ5rZA5QNZEjP1lfGf3eRt9gtMj4taApB/FDVLod5/2a5LBc/B/Sk
	 f8Qgq4Pl4X2YsRCuGTkjVg9efVK7MFK9EcBJG0BcW/zHi+VwAFxr0Z0ZmtZux5YjG2
	 LQcQZrlBYQofDXYJyi9Nw7AcvmRMJR/x+tZyhQXVLnqS5xShRyFkcfofFbIRamF7L4
	 P7O3KtNsynI9QGjS0LzCEDZttQRCokx7nUEHl/TKPgQhXaOD4gpBDvZNOd2nz1je8x
	 IF6gY4Jy5YvyboCjWpA09i9epdKNb3OK4ibXu8F2a9qmHKppK0gEtewul8MoShOn8G
	 UgISb8a6maKzA==
Date: Sun, 31 Dec 2023 12:33:22 -0800
Subject: [PATCH 3/9] xfs: validate attr leaf buffer owners
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404834749.1753044.1547078514172742944.stgit@frogsfrogsfrogs>
In-Reply-To: <170404834676.1753044.18168629400918360020.stgit@frogsfrogsfrogs>
References: <170404834676.1753044.18168629400918360020.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

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
index fa49c795f4074..1e94e933d7682 100644
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
 
@@ -1160,7 +1160,7 @@ xfs_attr_leaf_try_add(
 	struct xfs_buf		*bp;
 	int			error;
 
-	error = xfs_attr3_leaf_read(args->trans, args->dp, 0, &bp);
+	error = xfs_attr3_leaf_read(args->trans, args->dp, args->owner, 0, &bp);
 	if (error)
 		return error;
 
@@ -1208,7 +1208,7 @@ xfs_attr_leaf_hasname(
 {
 	int                     error = 0;
 
-	error = xfs_attr3_leaf_read(args->trans, args->dp, 0, bp);
+	error = xfs_attr3_leaf_read(args->trans, args->dp, args->owner, 0, bp);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index 01f93122f4286..3face870b4dac 100644
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
@@ -1232,7 +1266,7 @@ xfs_attr3_leaf_to_node(
 	error = xfs_da_grow_inode(args, &blkno);
 	if (error)
 		goto out;
-	error = xfs_attr3_leaf_read(args->trans, dp, 0, &bp1);
+	error = xfs_attr3_leaf_read(args->trans, dp, args->owner, 0, &bp1);
 	if (error)
 		goto out;
 
@@ -2067,7 +2101,7 @@ xfs_attr3_leaf_toosmall(
 		if (blkno == 0)
 			continue;
 		error = xfs_attr3_leaf_read(state->args->trans, state->args->dp,
-					blkno, &bp);
+					state->args->owner, blkno, &bp);
 		if (error)
 			return error;
 
@@ -2788,7 +2822,8 @@ xfs_attr3_leaf_clearflag(
 	/*
 	 * Set up the operation.
 	 */
-	error = xfs_attr3_leaf_read(args->trans, args->dp, args->blkno, &bp);
+	error = xfs_attr3_leaf_read(args->trans, args->dp, args->owner,
+			args->blkno, &bp);
 	if (error)
 		return error;
 
@@ -2852,7 +2887,8 @@ xfs_attr3_leaf_setflag(
 	/*
 	 * Set up the operation.
 	 */
-	error = xfs_attr3_leaf_read(args->trans, args->dp, args->blkno, &bp);
+	error = xfs_attr3_leaf_read(args->trans, args->dp, args->owner,
+			args->blkno, &bp);
 	if (error)
 		return error;
 
@@ -2911,7 +2947,8 @@ xfs_attr3_leaf_flipflags(
 	/*
 	 * Read the block containing the "old" attr
 	 */
-	error = xfs_attr3_leaf_read(args->trans, args->dp, args->blkno, &bp1);
+	error = xfs_attr3_leaf_read(args->trans, args->dp, args->owner,
+			args->blkno, &bp1);
 	if (error)
 		return error;
 
@@ -2919,8 +2956,8 @@ xfs_attr3_leaf_flipflags(
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
index ce6743463c868..70edddedd1ad3 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.h
+++ b/fs/xfs/libxfs/xfs_attr_leaf.h
@@ -101,12 +101,14 @@ int	xfs_attr_leaf_order(struct xfs_buf *leaf1_bp,
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
index a69d04ed74935..a7782055db6cd 100644
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
@@ -1590,6 +1609,7 @@ xfs_da3_node_lookup_int(
 	struct xfs_da_node_entry *btree;
 	struct xfs_da3_icnode_hdr nodehdr;
 	struct xfs_da_args	*args;
+	xfs_failaddr_t		fa;
 	xfs_dablk_t		blkno;
 	xfs_dahash_t		hashval;
 	xfs_dahash_t		btreehashval;
@@ -1628,6 +1648,12 @@ xfs_da3_node_lookup_int(
 
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
@@ -1995,6 +2021,7 @@ xfs_da3_path_shift(
 	struct xfs_da_node_entry *btree;
 	struct xfs_da3_icnode_hdr nodehdr;
 	struct xfs_buf		*bp;
+	xfs_failaddr_t		fa;
 	xfs_dablk_t		blkno = 0;
 	int			level;
 	int			error;
@@ -2086,6 +2113,12 @@ xfs_da3_path_shift(
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
@@ -2288,6 +2321,7 @@ xfs_da3_swap_lastblock(
 	struct xfs_buf		*last_buf;
 	struct xfs_buf		*sib_buf;
 	struct xfs_buf		*par_buf;
+	xfs_failaddr_t		fa;
 	xfs_dahash_t		dead_hash;
 	xfs_fileoff_t		lastoff;
 	xfs_dablk_t		dead_blkno;
@@ -2324,6 +2358,14 @@ xfs_da3_swap_lastblock(
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
index 7fb13f26edaa7..99618e0c8a72b 100644
--- a/fs/xfs/libxfs/xfs_da_btree.h
+++ b/fs/xfs/libxfs/xfs_da_btree.h
@@ -236,6 +236,7 @@ void	xfs_da3_node_hdr_from_disk(struct xfs_mount *mp,
 		struct xfs_da3_icnode_hdr *to, struct xfs_da_intnode *from);
 void	xfs_da3_node_hdr_to_disk(struct xfs_mount *mp,
 		struct xfs_da_intnode *to, struct xfs_da3_icnode_hdr *from);
+xfs_failaddr_t xfs_da3_header_check(struct xfs_buf *bp, xfs_ino_t owner);
 
 extern struct kmem_cache	*xfs_da_state_cache;
 
diff --git a/fs/xfs/libxfs/xfs_swapext.c b/fs/xfs/libxfs/xfs_swapext.c
index ced2365fa7b59..0446376365ec7 100644
--- a/fs/xfs/libxfs/xfs_swapext.c
+++ b/fs/xfs/libxfs/xfs_swapext.c
@@ -535,7 +535,8 @@ xfs_swapext_attr_to_sf(
 	if (!xfs_attr_is_leaf(sxi->sxi_ip2))
 		return 0;
 
-	error = xfs_attr3_leaf_read(tp, sxi->sxi_ip2, 0, &bp);
+	error = xfs_attr3_leaf_read(tp, sxi->sxi_ip2, sxi->sxi_ip2->i_ino, 0,
+			&bp);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/scrub/dabtree.c b/fs/xfs/scrub/dabtree.c
index fa6385a99ac4e..c71254088dffe 100644
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
index dcfa8e8e146a3..2954ed7cfaf43 100644
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
 

