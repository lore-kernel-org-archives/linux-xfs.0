Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D7C6C127
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 22:32:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iPKTeZOR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2BF1C433C8;
	Sun, 31 Dec 2023 22:32:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704061967;
	bh=Ic2LvQPLEwE3jDd135ox5YPj9uv8xMJ2HYxajejTeQg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=iPKTeZORNXh4IjJt6LTOEfKEwESmHs7t1e/y37Z6zK+gBdYQqWS2Ur0M8YNS8tQFZ
	 4f1JlFx+tVBlbMHnFFp4GH4l4DAjBZPQNGl1H9dkdr9qxkxBxL5g5jI1sTg684GybN
	 aa8AQj3uTxYso3bKNS0mFvhIBv/hYTKmy/NfgyWtosdK/Tn8BVEofOpmNRs/Amasyw
	 aKAC56oIasn/JlQdShi8gMMp0/P5hG7Kd0ZTZP+rxm5jztHjzNGFjBCeUvv94TRtwt
	 epTKDS46jQB2pI6SYjPoS93/vxydKPbkoagjaoQAyGTS8Z1Seo0Y7oWotqJHQ2o/Qc
	 ifKtfVEZausJw==
Date: Sun, 31 Dec 2023 14:32:47 -0800
Subject: [PATCH 2/9] xfs: use the xfs_da_args owner field to set new dir/attr
 block owner
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404996895.1796662.16921501581836874041.stgit@frogsfrogsfrogs>
In-Reply-To: <170404996860.1796662.9605761412685436403.stgit@frogsfrogsfrogs>
References: <170404996860.1796662.9605761412685436403.stgit@frogsfrogsfrogs>
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

When we're creating leaf, data, freespace, or dabtree blocks for
directories and xattrs, use the explicit owner field (instead of the
xfs_inode) to set the owner field.  This will enable online repair to
construct replacement data structures in a temporary file without having
to change the owner fields prior to swapping the new and old structures.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_attr_leaf.c   |    2 +-
 libxfs/xfs_attr_remote.c |    4 ++--
 libxfs/xfs_da_btree.c    |    2 +-
 libxfs/xfs_dir2_block.c  |   19 ++++++++++---------
 libxfs/xfs_dir2_data.c   |    2 +-
 libxfs/xfs_dir2_leaf.c   |   11 +++++------
 libxfs/xfs_dir2_node.c   |    2 +-
 7 files changed, 21 insertions(+), 21 deletions(-)


diff --git a/libxfs/xfs_attr_leaf.c b/libxfs/xfs_attr_leaf.c
index e3e9c265fab..1e87c8243f7 100644
--- a/libxfs/xfs_attr_leaf.c
+++ b/libxfs/xfs_attr_leaf.c
@@ -1308,7 +1308,7 @@ xfs_attr3_leaf_create(
 		ichdr.magic = XFS_ATTR3_LEAF_MAGIC;
 
 		hdr3->blkno = cpu_to_be64(xfs_buf_daddr(bp));
-		hdr3->owner = cpu_to_be64(dp->i_ino);
+		hdr3->owner = cpu_to_be64(args->owner);
 		uuid_copy(&hdr3->uuid, &mp->m_sb.sb_meta_uuid);
 
 		ichdr.freemap[0].base = sizeof(struct xfs_attr3_leaf_hdr);
diff --git a/libxfs/xfs_attr_remote.c b/libxfs/xfs_attr_remote.c
index f1c7cd31459..bc58dc6fa34 100644
--- a/libxfs/xfs_attr_remote.c
+++ b/libxfs/xfs_attr_remote.c
@@ -521,8 +521,8 @@ xfs_attr_rmtval_set_value(
 			return error;
 		bp->b_ops = &xfs_attr3_rmt_buf_ops;
 
-		xfs_attr_rmtval_copyin(mp, bp, args->dp->i_ino, &offset,
-				       &valuelen, &src);
+		xfs_attr_rmtval_copyin(mp, bp, args->owner, &offset, &valuelen,
+				&src);
 
 		error = xfs_bwrite(bp);	/* GROT: NOTE: synchronous write */
 		xfs_buf_relse(bp);
diff --git a/libxfs/xfs_da_btree.c b/libxfs/xfs_da_btree.c
index 87996c5da4f..672dc8aa433 100644
--- a/libxfs/xfs_da_btree.c
+++ b/libxfs/xfs_da_btree.c
@@ -481,7 +481,7 @@ xfs_da3_node_create(
 		memset(hdr3, 0, sizeof(struct xfs_da3_node_hdr));
 		ichdr.magic = XFS_DA3_NODE_MAGIC;
 		hdr3->info.blkno = cpu_to_be64(xfs_buf_daddr(bp));
-		hdr3->info.owner = cpu_to_be64(args->dp->i_ino);
+		hdr3->info.owner = cpu_to_be64(args->owner);
 		uuid_copy(&hdr3->info.uuid, &mp->m_sb.sb_meta_uuid);
 	} else {
 		ichdr.magic = XFS_DA_NODE_MAGIC;
diff --git a/libxfs/xfs_dir2_block.c b/libxfs/xfs_dir2_block.c
index 19fededab5d..1f6a88091e7 100644
--- a/libxfs/xfs_dir2_block.c
+++ b/libxfs/xfs_dir2_block.c
@@ -160,12 +160,13 @@ xfs_dir3_block_read(
 
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
@@ -174,7 +175,7 @@ xfs_dir3_block_init(
 		memset(hdr3, 0, sizeof(*hdr3));
 		hdr3->magic = cpu_to_be32(XFS_DIR3_BLOCK_MAGIC);
 		hdr3->blkno = cpu_to_be64(xfs_buf_daddr(bp));
-		hdr3->owner = cpu_to_be64(dp->i_ino);
+		hdr3->owner = cpu_to_be64(args->owner);
 		uuid_copy(&hdr3->uuid, &mp->m_sb.sb_meta_uuid);
 		return;
 
@@ -1006,7 +1007,7 @@ xfs_dir2_leaf_to_block(
 	/*
 	 * Start converting it to block form.
 	 */
-	xfs_dir3_block_init(mp, tp, dbp, dp);
+	xfs_dir3_block_init(args, dbp);
 
 	needlog = 1;
 	needscan = 0;
@@ -1128,7 +1129,7 @@ xfs_dir2_sf_to_block(
 	error = xfs_dir3_data_init(args, blkno, &bp);
 	if (error)
 		goto out_free;
-	xfs_dir3_block_init(mp, tp, bp, dp);
+	xfs_dir3_block_init(args, bp);
 	hdr = bp->b_addr;
 
 	/*
@@ -1168,7 +1169,7 @@ xfs_dir2_sf_to_block(
 	 * Create entry for .
 	 */
 	dep = bp->b_addr + offset;
-	dep->inumber = cpu_to_be64(dp->i_ino);
+	dep->inumber = cpu_to_be64(args->owner);
 	dep->namelen = 1;
 	dep->name[0] = '.';
 	xfs_dir2_data_put_ftype(mp, dep, XFS_DIR3_FT_DIR);
diff --git a/libxfs/xfs_dir2_data.c b/libxfs/xfs_dir2_data.c
index aaf3f62af91..6f3ccfeb69f 100644
--- a/libxfs/xfs_dir2_data.c
+++ b/libxfs/xfs_dir2_data.c
@@ -722,7 +722,7 @@ xfs_dir3_data_init(
 		memset(hdr3, 0, sizeof(*hdr3));
 		hdr3->magic = cpu_to_be32(XFS_DIR3_DATA_MAGIC);
 		hdr3->blkno = cpu_to_be64(xfs_buf_daddr(bp));
-		hdr3->owner = cpu_to_be64(dp->i_ino);
+		hdr3->owner = cpu_to_be64(args->owner);
 		uuid_copy(&hdr3->uuid, &mp->m_sb.sb_meta_uuid);
 
 	} else
diff --git a/libxfs/xfs_dir2_leaf.c b/libxfs/xfs_dir2_leaf.c
index 80cea8a275d..8fbda22508d 100644
--- a/libxfs/xfs_dir2_leaf.c
+++ b/libxfs/xfs_dir2_leaf.c
@@ -302,12 +302,12 @@ xfs_dir3_leafn_read(
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
@@ -321,7 +321,7 @@ xfs_dir3_leaf_init(
 					 ? cpu_to_be16(XFS_DIR3_LEAF1_MAGIC)
 					 : cpu_to_be16(XFS_DIR3_LEAFN_MAGIC);
 		leaf3->info.blkno = cpu_to_be64(xfs_buf_daddr(bp));
-		leaf3->info.owner = cpu_to_be64(owner);
+		leaf3->info.owner = cpu_to_be64(args->owner);
 		uuid_copy(&leaf3->info.uuid, &mp->m_sb.sb_meta_uuid);
 	} else {
 		memset(leaf, 0, sizeof(*leaf));
@@ -354,7 +354,6 @@ xfs_dir3_leaf_get_buf(
 {
 	struct xfs_inode	*dp = args->dp;
 	struct xfs_trans	*tp = args->trans;
-	struct xfs_mount	*mp = dp->i_mount;
 	struct xfs_buf		*bp;
 	int			error;
 
@@ -367,7 +366,7 @@ xfs_dir3_leaf_get_buf(
 	if (error)
 		return error;
 
-	xfs_dir3_leaf_init(mp, tp, bp, dp->i_ino, magic);
+	xfs_dir3_leaf_init(args, bp, magic);
 	xfs_dir3_leaf_log_header(args, bp);
 	if (magic == XFS_DIR2_LEAF1_MAGIC)
 		xfs_dir3_leaf_log_tail(args, bp);
diff --git a/libxfs/xfs_dir2_node.c b/libxfs/xfs_dir2_node.c
index 44c8f3f2b07..b00f783877e 100644
--- a/libxfs/xfs_dir2_node.c
+++ b/libxfs/xfs_dir2_node.c
@@ -346,7 +346,7 @@ xfs_dir3_free_get_buf(
 		hdr.magic = XFS_DIR3_FREE_MAGIC;
 
 		hdr3->hdr.blkno = cpu_to_be64(xfs_buf_daddr(bp));
-		hdr3->hdr.owner = cpu_to_be64(dp->i_ino);
+		hdr3->hdr.owner = cpu_to_be64(args->owner);
 		uuid_copy(&hdr3->hdr.uuid, &mp->m_sb.sb_meta_uuid);
 	} else
 		hdr.magic = XFS_DIR2_FREE_MAGIC;

