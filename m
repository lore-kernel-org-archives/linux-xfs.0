Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F9861591F9
	for <linux-xfs@vger.kernel.org>; Mon, 15 Apr 2024 23:47:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713224855; cv=none; b=T1B1h5rYS2b4OXLuLKJNqmN3tU12p2nzg/uNuID3081jR9dq53PcdCwcAtchHeCnkYYTijNMKydk7f0tJJBhNbkmN3XE3zBBCORB/5JuyKv+j50qb1Zmf6/rE6nKaFwWVCSbEyp+NwuN/e5fGMBL59pOW8WSM0zHLQ1Gc+14LEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713224855; c=relaxed/simple;
	bh=3o5pG21Cy77Lm9KcG1gqVg20j18bc0XZ3G52wvHfZBE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Qox37MLK/FVL2f4ElIMveBrdV8Hf7dWKwTJW4HMZxDJrAmHG16yrBeXVBceXOHj9Onpa51iOP8rqitbGdJBwARQWOlRJC+hPzFz5P7RSiokQJS41HoICMd77BOYVO2MBJZKd9d2yXjtFNvtdKRK9XhF00Qtlb+CPURU1TYZ40vw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BdzTogcb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BdzTogcb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3ADEAC113CC;
	Mon, 15 Apr 2024 23:47:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713224855;
	bh=3o5pG21Cy77Lm9KcG1gqVg20j18bc0XZ3G52wvHfZBE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=BdzTogcbbtpMjOomqbE979wkYxAs6vNEeHGxw8LycuEY0PufpsnOnpRlNOQQGUNzU
	 k73l2eLxk6c3/ArluG2TBmHSq0wiZhHxtrTRORtfVgq7E2sukFnddg0/vu9xqjMh5c
	 YEefPn7n8STeOBE+N4JLHmQd+2SihACN7z/pwL8xODr54bpJI9AJi4QAbdwbTw4wvB
	 DMv+nf/oXlowBPYKqcPJSvfLxsAkuTu2nH6vHI7bcFr8WCxfqsPTqmIiZEvPlK9e6E
	 7smlNr4nQQeEvFyo/97IhpUj2zKshCKOdscMn2cDrxYrwBaIHvtUiiZqKqiooV+HTn
	 t1txvRke7Rnww==
Date: Mon, 15 Apr 2024 16:47:34 -0700
Subject: [PATCH 04/10] xfs: validate attr leaf buffer owners
From: "Darrick J. Wong" <djwong@kernel.org>
To: chandanbabu@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171322382647.88250.4164777366505734319.stgit@frogsfrogsfrogs>
In-Reply-To: <171322382551.88250.5431690184825585631.stgit@frogsfrogsfrogs>
References: <171322382551.88250.5431690184825585631.stgit@frogsfrogsfrogs>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_attr.c      |   10 ++++---
 fs/xfs/libxfs/xfs_attr_leaf.c |   56 ++++++++++++++++++++++++++++++++++-------
 fs/xfs/libxfs/xfs_attr_leaf.h |    4 ++-
 fs/xfs/libxfs/xfs_da_btree.c  |   42 +++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_da_btree.h  |    1 +
 fs/xfs/libxfs/xfs_exchmaps.c  |    3 +-
 fs/xfs/scrub/dabtree.c        |    7 +++++
 fs/xfs/xfs_attr_list.c        |   24 +++++++++++++++---
 8 files changed, 128 insertions(+), 19 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 74d769461443..b3c9666cd011 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -649,8 +649,8 @@ xfs_attr_leaf_remove_attr(
 	int				forkoff;
 	int				error;
 
-	error = xfs_attr3_leaf_read(args->trans, args->dp, args->blkno,
-				   &bp);
+	error = xfs_attr3_leaf_read(args->trans, args->dp, args->owner,
+			args->blkno, &bp);
 	if (error)
 		return error;
 
@@ -681,7 +681,7 @@ xfs_attr_leaf_shrink(
 	if (!xfs_attr_is_leaf(dp))
 		return 0;
 
-	error = xfs_attr3_leaf_read(args->trans, args->dp, 0, &bp);
+	error = xfs_attr3_leaf_read(args->trans, args->dp, args->owner, 0, &bp);
 	if (error)
 		return error;
 
@@ -1158,7 +1158,7 @@ xfs_attr_leaf_try_add(
 	struct xfs_buf		*bp;
 	int			error;
 
-	error = xfs_attr3_leaf_read(args->trans, args->dp, 0, &bp);
+	error = xfs_attr3_leaf_read(args->trans, args->dp, args->owner, 0, &bp);
 	if (error)
 		return error;
 
@@ -1206,7 +1206,7 @@ xfs_attr_leaf_hasname(
 {
 	int                     error = 0;
 
-	error = xfs_attr3_leaf_read(args->trans, args->dp, 0, bp);
+	error = xfs_attr3_leaf_read(args->trans, args->dp, args->owner, 0, bp);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index 8937c034b330..17ec5ff5a4e3 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -388,6 +388,27 @@ xfs_attr3_leaf_verify(
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
+		if (hdr3->hdr.info.hdr.magic !=
+				cpu_to_be16(XFS_ATTR3_LEAF_MAGIC))
+			return __this_address;
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
@@ -448,16 +469,30 @@ int
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
@@ -1160,7 +1195,7 @@ xfs_attr3_leaf_to_node(
 	error = xfs_da_grow_inode(args, &blkno);
 	if (error)
 		goto out;
-	error = xfs_attr3_leaf_read(args->trans, dp, 0, &bp1);
+	error = xfs_attr3_leaf_read(args->trans, dp, args->owner, 0, &bp1);
 	if (error)
 		goto out;
 
@@ -1995,7 +2030,7 @@ xfs_attr3_leaf_toosmall(
 		if (blkno == 0)
 			continue;
 		error = xfs_attr3_leaf_read(state->args->trans, state->args->dp,
-					blkno, &bp);
+					state->args->owner, blkno, &bp);
 		if (error)
 			return error;
 
@@ -2717,7 +2752,8 @@ xfs_attr3_leaf_clearflag(
 	/*
 	 * Set up the operation.
 	 */
-	error = xfs_attr3_leaf_read(args->trans, args->dp, args->blkno, &bp);
+	error = xfs_attr3_leaf_read(args->trans, args->dp, args->owner,
+			args->blkno, &bp);
 	if (error)
 		return error;
 
@@ -2781,7 +2817,8 @@ xfs_attr3_leaf_setflag(
 	/*
 	 * Set up the operation.
 	 */
-	error = xfs_attr3_leaf_read(args->trans, args->dp, args->blkno, &bp);
+	error = xfs_attr3_leaf_read(args->trans, args->dp, args->owner,
+			args->blkno, &bp);
 	if (error)
 		return error;
 
@@ -2840,7 +2877,8 @@ xfs_attr3_leaf_flipflags(
 	/*
 	 * Read the block containing the "old" attr
 	 */
-	error = xfs_attr3_leaf_read(args->trans, args->dp, args->blkno, &bp1);
+	error = xfs_attr3_leaf_read(args->trans, args->dp, args->owner,
+			args->blkno, &bp1);
 	if (error)
 		return error;
 
@@ -2848,8 +2886,8 @@ xfs_attr3_leaf_flipflags(
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
index 9b9948639c0f..bac219589896 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.h
+++ b/fs/xfs/libxfs/xfs_attr_leaf.h
@@ -98,12 +98,14 @@ int	xfs_attr_leaf_order(struct xfs_buf *leaf1_bp,
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
index 743f6421cc04..65eef8775187 100644
--- a/fs/xfs/libxfs/xfs_da_btree.c
+++ b/fs/xfs/libxfs/xfs_da_btree.c
@@ -252,6 +252,25 @@ xfs_da3_node_verify(
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
@@ -1591,6 +1610,7 @@ xfs_da3_node_lookup_int(
 	struct xfs_da_node_entry *btree;
 	struct xfs_da3_icnode_hdr nodehdr;
 	struct xfs_da_args	*args;
+	xfs_failaddr_t		fa;
 	xfs_dablk_t		blkno;
 	xfs_dahash_t		hashval;
 	xfs_dahash_t		btreehashval;
@@ -1629,6 +1649,12 @@ xfs_da3_node_lookup_int(
 
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
@@ -1996,6 +2022,7 @@ xfs_da3_path_shift(
 	struct xfs_da_node_entry *btree;
 	struct xfs_da3_icnode_hdr nodehdr;
 	struct xfs_buf		*bp;
+	xfs_failaddr_t		fa;
 	xfs_dablk_t		blkno = 0;
 	int			level;
 	int			error;
@@ -2087,6 +2114,12 @@ xfs_da3_path_shift(
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
@@ -2290,6 +2323,7 @@ xfs_da3_swap_lastblock(
 	struct xfs_buf		*last_buf;
 	struct xfs_buf		*sib_buf;
 	struct xfs_buf		*par_buf;
+	xfs_failaddr_t		fa;
 	xfs_dahash_t		dead_hash;
 	xfs_fileoff_t		lastoff;
 	xfs_dablk_t		dead_blkno;
@@ -2326,6 +2360,14 @@ xfs_da3_swap_lastblock(
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
index 7fb13f26edaa..99618e0c8a72 100644
--- a/fs/xfs/libxfs/xfs_da_btree.h
+++ b/fs/xfs/libxfs/xfs_da_btree.h
@@ -236,6 +236,7 @@ void	xfs_da3_node_hdr_from_disk(struct xfs_mount *mp,
 		struct xfs_da3_icnode_hdr *to, struct xfs_da_intnode *from);
 void	xfs_da3_node_hdr_to_disk(struct xfs_mount *mp,
 		struct xfs_da_intnode *to, struct xfs_da3_icnode_hdr *from);
+xfs_failaddr_t xfs_da3_header_check(struct xfs_buf *bp, xfs_ino_t owner);
 
 extern struct kmem_cache	*xfs_da_state_cache;
 
diff --git a/fs/xfs/libxfs/xfs_exchmaps.c b/fs/xfs/libxfs/xfs_exchmaps.c
index 8d28e8cce5e9..9c9cf2e998b2 100644
--- a/fs/xfs/libxfs/xfs_exchmaps.c
+++ b/fs/xfs/libxfs/xfs_exchmaps.c
@@ -438,7 +438,8 @@ xfs_exchmaps_attr_to_sf(
 	if (!xfs_attr_is_leaf(xmi->xmi_ip2))
 		return 0;
 
-	error = xfs_attr3_leaf_read(tp, xmi->xmi_ip2, 0, &bp);
+	error = xfs_attr3_leaf_read(tp, xmi->xmi_ip2, xmi->xmi_ip2->i_ino, 0,
+			&bp);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/scrub/dabtree.c b/fs/xfs/scrub/dabtree.c
index fa6385a99ac4..c71254088dff 100644
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
index 42a575db7267..f6496e33ff91 100644
--- a/fs/xfs/xfs_attr_list.c
+++ b/fs/xfs/xfs_attr_list.c
@@ -214,6 +214,7 @@ xfs_attr_node_list_lookup(
 	struct xfs_mount		*mp = dp->i_mount;
 	struct xfs_trans		*tp = context->tp;
 	struct xfs_buf			*bp;
+	xfs_failaddr_t			fa;
 	int				i;
 	int				error = 0;
 	unsigned int			expected_level = 0;
@@ -273,6 +274,12 @@ xfs_attr_node_list_lookup(
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
 
@@ -281,6 +288,7 @@ xfs_attr_node_list_lookup(
 
 out_corruptbuf:
 	xfs_buf_mark_corrupt(bp);
+out_releasebuf:
 	xfs_trans_brelse(tp, bp);
 	xfs_dirattr_mark_sick(dp, XFS_ATTR_FORK);
 	return -EFSCORRUPTED;
@@ -297,6 +305,7 @@ xfs_attr_node_list(
 	struct xfs_buf			*bp;
 	struct xfs_inode		*dp = context->dp;
 	struct xfs_mount		*mp = dp->i_mount;
+	xfs_failaddr_t			fa;
 	int				error = 0;
 
 	trace_xfs_attr_node_list(context);
@@ -332,6 +341,14 @@ xfs_attr_node_list(
 		case XFS_ATTR_LEAF_MAGIC:
 		case XFS_ATTR3_LEAF_MAGIC:
 			leaf = bp->b_addr;
+			fa = xfs_attr3_leaf_header_check(bp, dp->i_ino);
+			if (fa) {
+				__xfs_buf_mark_corrupt(bp, fa);
+				xfs_trans_brelse(context->tp, bp);
+				xfs_dirattr_mark_sick(dp, XFS_ATTR_FORK);
+				bp = NULL;
+				break;
+			}
 			xfs_attr3_leaf_hdr_from_disk(mp->m_attr_geo,
 						     &leafhdr, leaf);
 			entries = xfs_attr3_leaf_entryp(leaf);
@@ -382,8 +399,8 @@ xfs_attr_node_list(
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
@@ -503,7 +520,8 @@ xfs_attr_leaf_list(
 	trace_xfs_attr_leaf_list(context);
 
 	context->cursor.blkno = 0;
-	error = xfs_attr3_leaf_read(context->tp, context->dp, 0, &bp);
+	error = xfs_attr3_leaf_read(context->tp, context->dp,
+			context->dp->i_ino, 0, &bp);
 	if (error)
 		return error;
 

