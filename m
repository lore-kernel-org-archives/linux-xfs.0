Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E284156F4B
	for <linux-xfs@vger.kernel.org>; Mon, 15 Apr 2024 23:47:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713224824; cv=none; b=MQB/ws8rbgHNhIwIBuzRteu9VGkjjg7j9TZhNJg5p51nb3+7nDfr9UpeLI8Mb/BP9qBEszJ3sX9Ok1Cn2jMP6gGSYy73kdPsveB17b0qJ+WqexCu6Av8hhnbuIj0B+KaVMaj2Jf56ZhdVVpUeR5fB3eJ8K0C2PlpnrIoecvAsE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713224824; c=relaxed/simple;
	bh=X1MDj9G6xmvaKdq4MScFVdrGrZmOiPL99GoGJY62OWg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aztkc10Hk8kpRiLraN2/QiYabzV+RX7jHik40F7CtuxKAINVK1+wym2SqgNDwYezYTXBtaBQeLdOQCfr6+/uVk8YsVIJNmJB+v5kv/AHRpswhAiLwe+I+olbAsLffd9/ZBzHRfBQhOL0b89Lzd2vA7t4LeMZhMoJdwdC+bccV2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QiNS/0eH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QiNS/0eH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06176C113CC;
	Mon, 15 Apr 2024 23:47:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713224824;
	bh=X1MDj9G6xmvaKdq4MScFVdrGrZmOiPL99GoGJY62OWg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=QiNS/0eHL+YvUFiAfsdB3J0LP1fsKNjOwNrI4jk74OJFm4805e5PwV8jd00kwdkBw
	 V16aVpJ75wBVVVegLsVps9hJ7xRF+xulKa1L5M1Z1sqSX6xnqF+KozVzLOSjRO63L2
	 ElrMOcSu6bsg/N4CdQdDk8PDL50DqDc6As+6n7XCNFz8JhMDGJuI0RQwM+avtPX73R
	 eMLwjVntaw5+syHczZSB3a9qEIc8ZRwfebbS7xFvBG4Wu5DGrbdRrKOfYG1l1bbJBZ
	 3+rU07byN39g4WexJFPejjFI/tjD1EfLQeKdIqc9vSCK0zDgwHH9XRZTwWSjaUDh+t
	 +AEHTc6CgxGvg==
Date: Mon, 15 Apr 2024 16:47:03 -0700
Subject: [PATCH 02/10] xfs: use the xfs_da_args owner field to set new
 dir/attr block owner
From: "Darrick J. Wong" <djwong@kernel.org>
To: chandanbabu@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171322382613.88250.7060876079770289154.stgit@frogsfrogsfrogs>
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

When we're creating leaf, data, freespace, or dabtree blocks for
directories and xattrs, use the explicit owner field (instead of the
xfs_inode) to set the owner field.  This will enable online repair to
construct replacement data structures in a temporary file without having
to change the owner fields prior to swapping the new and old structures.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
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
index e606eae8d377..8937c034b330 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -1239,7 +1239,7 @@ xfs_attr3_leaf_create(
 		ichdr.magic = XFS_ATTR3_LEAF_MAGIC;
 
 		hdr3->blkno = cpu_to_be64(xfs_buf_daddr(bp));
-		hdr3->owner = cpu_to_be64(dp->i_ino);
+		hdr3->owner = cpu_to_be64(args->owner);
 		uuid_copy(&hdr3->uuid, &mp->m_sb.sb_meta_uuid);
 
 		ichdr.freemap[0].base = sizeof(struct xfs_attr3_leaf_hdr);
diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
index ff0412828772..024895cc7029 100644
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
index 718d071bb21a..743f6421cc04 100644
--- a/fs/xfs/libxfs/xfs_da_btree.c
+++ b/fs/xfs/libxfs/xfs_da_btree.c
@@ -486,7 +486,7 @@ xfs_da3_node_create(
 		memset(hdr3, 0, sizeof(struct xfs_da3_node_hdr));
 		ichdr.magic = XFS_DA3_NODE_MAGIC;
 		hdr3->info.blkno = cpu_to_be64(xfs_buf_daddr(bp));
-		hdr3->info.owner = cpu_to_be64(args->dp->i_ino);
+		hdr3->info.owner = cpu_to_be64(args->owner);
 		uuid_copy(&hdr3->info.uuid, &mp->m_sb.sb_meta_uuid);
 	} else {
 		ichdr.magic = XFS_DA_NODE_MAGIC;
diff --git a/fs/xfs/libxfs/xfs_dir2_block.c b/fs/xfs/libxfs/xfs_dir2_block.c
index a2da007adb46..61cbc668f228 100644
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
@@ -1129,7 +1130,7 @@ xfs_dir2_sf_to_block(
 	error = xfs_dir3_data_init(args, blkno, &bp);
 	if (error)
 		goto out_free;
-	xfs_dir3_block_init(mp, tp, bp, dp);
+	xfs_dir3_block_init(args, bp);
 	hdr = bp->b_addr;
 
 	/*
@@ -1169,7 +1170,7 @@ xfs_dir2_sf_to_block(
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

