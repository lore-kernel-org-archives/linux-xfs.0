Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60EECC4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 23:58:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231282AbiL3X6B (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 18:58:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229827AbiL3X6A (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 18:58:00 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78E281E3D8
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 15:57:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id C74E5CE19E1
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 23:57:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E8BBC433F0;
        Fri, 30 Dec 2022 23:57:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672444676;
        bh=LIlsByehIi6GSLdwMJJTTx1/PMldNB2y9VDVKj4nCI8=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=TxUBGxX0mL7wwfoZR7pFqp3BxHH7TBWZAaRKsd/Acb+Z4WtqcvPnp8RykuDsZ1KEq
         wFDO9mrzYg2kPPoLUjiuFkyK9+wM0vP20xFpl3ADr4xcNREDp+Zgg0Z2U6UL/Dp+W2
         kJIPdFnO9BfK17nkWZT9BjG6u6m48SxsalVyBO2VOfEVYaigfJjbtbUlI1+Gjz4hlR
         UN06cLqVYhUhN1OTlkOE5QdbGKWYgqOcW5VB1mLUWuNGM0qxC29L2whtTrU5B1kJ3t
         pVp0PpSkhxNGUITNZ9zgNSa9MSuaHWVOmlQUpV3lNZdiElSKSQ83lny5U/s8yKK4Di
         XsE5dfd3qYPCg==
Subject: [PATCH 2/9] xfs: use the xfs_da_args owner field to set new dir/attr
 block owner
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:14:08 -0800
Message-ID: <167243844862.700244.4695821930878590457.stgit@magnolia>
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

When we're creating leaf, data, freespace, or dabtree blocks for
directories and xattrs, use the explicit owner field (instead of the
xfs_inode) to set the owner field.  This will enable online repair to
construct replacement data structures in a temporary file without having
to change the owner fields prior to swapping the new and old structures.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_attr_leaf.c   |    2 +-
 fs/xfs/libxfs/xfs_attr_remote.c |    4 ++--
 fs/xfs/libxfs/xfs_da_btree.c    |    2 +-
 fs/xfs/libxfs/xfs_dir2_block.c  |   19 ++++++++++---------
 fs/xfs/libxfs/xfs_dir2_data.c   |    2 +-
 fs/xfs/libxfs/xfs_dir2_leaf.c   |   11 +++++------
 fs/xfs/libxfs/xfs_dir2_node.c   |    2 +-
 7 files changed, 21 insertions(+), 21 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index e771167c8766..9ce886d5e53d 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -1332,7 +1332,7 @@ xfs_attr3_leaf_create(
 		ichdr.magic = XFS_ATTR3_LEAF_MAGIC;
 
 		hdr3->blkno = cpu_to_be64(xfs_buf_daddr(bp));
-		hdr3->owner = cpu_to_be64(dp->i_ino);
+		hdr3->owner = cpu_to_be64(args->owner);
 		uuid_copy(&hdr3->uuid, &mp->m_sb.sb_meta_uuid);
 
 		ichdr.freemap[0].base = sizeof(struct xfs_attr3_leaf_hdr);
diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
index bb4cf1fa0dc2..b8cdd15c4e1a 100644
--- a/fs/xfs/libxfs/xfs_attr_remote.c
+++ b/fs/xfs/libxfs/xfs_attr_remote.c
@@ -522,8 +522,8 @@ xfs_attr_rmtval_set_value(
 			return error;
 		bp->b_ops = &xfs_attr3_rmt_buf_ops;
 
-		xfs_attr_rmtval_copyin(mp, bp, args->dp->i_ino, &offset,
-				       &valuelen, &src);
+		xfs_attr_rmtval_copyin(mp, bp, args->owner, &offset, &valuelen,
+				&src);
 
 		error = xfs_bwrite(bp);	/* GROT: NOTE: synchronous write */
 		xfs_buf_relse(bp);
diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
index 8d2992413047..b0d1aad1fbbb 100644
--- a/fs/xfs/libxfs/xfs_da_btree.c
+++ b/fs/xfs/libxfs/xfs_da_btree.c
@@ -466,7 +466,7 @@ xfs_da3_node_create(
 		memset(hdr3, 0, sizeof(struct xfs_da3_node_hdr));
 		ichdr.magic = XFS_DA3_NODE_MAGIC;
 		hdr3->info.blkno = cpu_to_be64(xfs_buf_daddr(bp));
-		hdr3->info.owner = cpu_to_be64(args->dp->i_ino);
+		hdr3->info.owner = cpu_to_be64(args->owner);
 		uuid_copy(&hdr3->info.uuid, &mp->m_sb.sb_meta_uuid);
 	} else {
 		ichdr.magic = XFS_DA_NODE_MAGIC;
diff --git a/fs/xfs/libxfs/xfs_dir2_block.c b/fs/xfs/libxfs/xfs_dir2_block.c
index 6b3ca2b384cf..6bda6a490671 100644
--- a/fs/xfs/libxfs/xfs_dir2_block.c
+++ b/fs/xfs/libxfs/xfs_dir2_block.c
@@ -163,12 +163,13 @@ xfs_dir3_block_read(
 
 static void
 xfs_dir3_block_init(
-	struct xfs_mount	*mp,
-	struct xfs_trans	*tp,
-	struct xfs_buf		*bp,
-	struct xfs_inode	*dp)
+	struct xfs_da_args	*args,
+	struct xfs_buf		*bp)
 {
-	struct xfs_dir3_blk_hdr *hdr3 = bp->b_addr;
+	struct xfs_trans	*tp = args->trans;
+	struct xfs_inode	*dp = args->dp;
+	struct xfs_mount	*mp = dp->i_mount;
+	struct xfs_dir3_blk_hdr	*hdr3 = bp->b_addr;
 
 	bp->b_ops = &xfs_dir3_block_buf_ops;
 	xfs_trans_buf_set_type(tp, bp, XFS_BLFT_DIR_BLOCK_BUF);
@@ -177,7 +178,7 @@ xfs_dir3_block_init(
 		memset(hdr3, 0, sizeof(*hdr3));
 		hdr3->magic = cpu_to_be32(XFS_DIR3_BLOCK_MAGIC);
 		hdr3->blkno = cpu_to_be64(xfs_buf_daddr(bp));
-		hdr3->owner = cpu_to_be64(dp->i_ino);
+		hdr3->owner = cpu_to_be64(args->owner);
 		uuid_copy(&hdr3->uuid, &mp->m_sb.sb_meta_uuid);
 		return;
 
@@ -1009,7 +1010,7 @@ xfs_dir2_leaf_to_block(
 	/*
 	 * Start converting it to block form.
 	 */
-	xfs_dir3_block_init(mp, tp, dbp, dp);
+	xfs_dir3_block_init(args, dbp);
 
 	needlog = 1;
 	needscan = 0;
@@ -1131,7 +1132,7 @@ xfs_dir2_sf_to_block(
 	error = xfs_dir3_data_init(args, blkno, &bp);
 	if (error)
 		goto out_free;
-	xfs_dir3_block_init(mp, tp, bp, dp);
+	xfs_dir3_block_init(args, bp);
 	hdr = bp->b_addr;
 
 	/*
@@ -1171,7 +1172,7 @@ xfs_dir2_sf_to_block(
 	 * Create entry for .
 	 */
 	dep = bp->b_addr + offset;
-	dep->inumber = cpu_to_be64(dp->i_ino);
+	dep->inumber = cpu_to_be64(args->owner);
 	dep->namelen = 1;
 	dep->name[0] = '.';
 	xfs_dir2_data_put_ftype(mp, dep, XFS_DIR3_FT_DIR);
diff --git a/fs/xfs/libxfs/xfs_dir2_data.c b/fs/xfs/libxfs/xfs_dir2_data.c
index 7a6d965bea71..c3ef720b5ff6 100644
--- a/fs/xfs/libxfs/xfs_dir2_data.c
+++ b/fs/xfs/libxfs/xfs_dir2_data.c
@@ -725,7 +725,7 @@ xfs_dir3_data_init(
 		memset(hdr3, 0, sizeof(*hdr3));
 		hdr3->magic = cpu_to_be32(XFS_DIR3_DATA_MAGIC);
 		hdr3->blkno = cpu_to_be64(xfs_buf_daddr(bp));
-		hdr3->owner = cpu_to_be64(dp->i_ino);
+		hdr3->owner = cpu_to_be64(args->owner);
 		uuid_copy(&hdr3->uuid, &mp->m_sb.sb_meta_uuid);
 
 	} else
diff --git a/fs/xfs/libxfs/xfs_dir2_leaf.c b/fs/xfs/libxfs/xfs_dir2_leaf.c
index 08dda5ce9d91..20ce057d12e8 100644
--- a/fs/xfs/libxfs/xfs_dir2_leaf.c
+++ b/fs/xfs/libxfs/xfs_dir2_leaf.c
@@ -304,12 +304,12 @@ xfs_dir3_leafn_read(
  */
 static void
 xfs_dir3_leaf_init(
-	struct xfs_mount	*mp,
-	struct xfs_trans	*tp,
+	struct xfs_da_args	*args,
 	struct xfs_buf		*bp,
-	xfs_ino_t		owner,
 	uint16_t		type)
 {
+	struct xfs_mount	*mp = args->dp->i_mount;
+	struct xfs_trans	*tp = args->trans;
 	struct xfs_dir2_leaf	*leaf = bp->b_addr;
 
 	ASSERT(type == XFS_DIR2_LEAF1_MAGIC || type == XFS_DIR2_LEAFN_MAGIC);
@@ -323,7 +323,7 @@ xfs_dir3_leaf_init(
 					 ? cpu_to_be16(XFS_DIR3_LEAF1_MAGIC)
 					 : cpu_to_be16(XFS_DIR3_LEAFN_MAGIC);
 		leaf3->info.blkno = cpu_to_be64(xfs_buf_daddr(bp));
-		leaf3->info.owner = cpu_to_be64(owner);
+		leaf3->info.owner = cpu_to_be64(args->owner);
 		uuid_copy(&leaf3->info.uuid, &mp->m_sb.sb_meta_uuid);
 	} else {
 		memset(leaf, 0, sizeof(*leaf));
@@ -356,7 +356,6 @@ xfs_dir3_leaf_get_buf(
 {
 	struct xfs_inode	*dp = args->dp;
 	struct xfs_trans	*tp = args->trans;
-	struct xfs_mount	*mp = dp->i_mount;
 	struct xfs_buf		*bp;
 	int			error;
 
@@ -369,7 +368,7 @@ xfs_dir3_leaf_get_buf(
 	if (error)
 		return error;
 
-	xfs_dir3_leaf_init(mp, tp, bp, dp->i_ino, magic);
+	xfs_dir3_leaf_init(args, bp, magic);
 	xfs_dir3_leaf_log_header(args, bp);
 	if (magic == XFS_DIR2_LEAF1_MAGIC)
 		xfs_dir3_leaf_log_tail(args, bp);
diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
index be0b8834028c..1ad7405f9c38 100644
--- a/fs/xfs/libxfs/xfs_dir2_node.c
+++ b/fs/xfs/libxfs/xfs_dir2_node.c
@@ -349,7 +349,7 @@ xfs_dir3_free_get_buf(
 		hdr.magic = XFS_DIR3_FREE_MAGIC;
 
 		hdr3->hdr.blkno = cpu_to_be64(xfs_buf_daddr(bp));
-		hdr3->hdr.owner = cpu_to_be64(dp->i_ino);
+		hdr3->hdr.owner = cpu_to_be64(args->owner);
 		uuid_copy(&hdr3->hdr.uuid, &mp->m_sb.sb_meta_uuid);
 	} else
 		hdr.magic = XFS_DIR2_FREE_MAGIC;

