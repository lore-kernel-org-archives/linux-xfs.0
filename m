Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14FCCFC0C
	for <linux-xfs@vger.kernel.org>; Tue, 27 Feb 2024 02:26:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709000812; cv=none; b=rjEAmCmWNSbtUTBWKsa08Kh9D9mxoi+FiUUQNu8MP/Nhj1yOVYIOCgFzDmGelCxx3eZlK1AfMRpaXQQUYfFweJXCKo0rQV29W1jqvOhBlUU7TNDLt+3O0/LYSweR9RsTL1pHzDRqLTeuGHGl8/hcEY/Faf70tNlt0+QgQwZzP8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709000812; c=relaxed/simple;
	bh=WXnsjZvIhbwJSjJLEoP7QZYZahqpw5qdNzGnITpad10=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KIDMjPLZGzTrf9l+ZLWRun+7tz5pvPvhIelZ5IuZ/6hXdNvoh9LD7brBdpKgc1deiyKb/2IyPFIMjfeo/iarnUYAxlxQcJo83kzTGrAfY+5iMgcOwIZblrhZ97mqv0N8oBSMRMotM7z06KaZQjfiGAaYnCtzJYeDifn5jBZ1PEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iU6Qt9ym; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iU6Qt9ym"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3241C433C7;
	Tue, 27 Feb 2024 02:26:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1709000811;
	bh=WXnsjZvIhbwJSjJLEoP7QZYZahqpw5qdNzGnITpad10=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=iU6Qt9ymdv8e51SW4HsOMgQ8qmJG6/s1myBQiWdic4pjmQuMFA7YGA18zYUzkTO6A
	 fNqoc2+vgoWaTHz1sVjzbb1+Ha5FIeUvYyKTjaP/N6+ZySgoQzKDIVfgWaRr1JCcEw
	 Rqf7EbSAmO5m6mBmk6LU2v+LZ2FjT39fg7w66LerI+qVzL/dCKmPIDuFC7lN6GKIQZ
	 B9Td1NdzSIdBGaC7QusQI2d33zvxfDvMorYZoGeSFM5fCOUJFML/JvWONWWHuHQTrw
	 hFVJDu4quT75IrIIISVq3Ajc69rDmcyNTCytq0TUVjODPVCqZTDjWhFzVmTqxrKCGn
	 bHDujnBoAi/5w==
Date: Mon, 26 Feb 2024 18:26:51 -0800
Subject: [PATCH 2/9] xfs: use the xfs_da_args owner field to set new dir/attr
 block owner
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <170900013126.938940.5185893300236524104.stgit@frogsfrogsfrogs>
In-Reply-To: <170900013068.938940.1740993823820687963.stgit@frogsfrogsfrogs>
References: <170900013068.938940.1740993823820687963.stgit@frogsfrogsfrogs>
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
 fs/xfs/libxfs/xfs_attr_leaf.c   |    2 +-
 fs/xfs/libxfs/xfs_attr_remote.c |    4 ++--
 fs/xfs/libxfs/xfs_da_btree.c    |    2 +-
 fs/xfs/libxfs/xfs_dir2_block.c  |   19 ++++++++++---------
 fs/xfs/libxfs/xfs_dir2_data.c   |    2 +-
 fs/xfs/libxfs/xfs_dir2_leaf.c   |   11 +++++------
 fs/xfs/libxfs/xfs_dir2_node.c   |    2 +-
 7 files changed, 21 insertions(+), 21 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index 5982036df61a7..b7833bf96b953 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -1240,7 +1240,7 @@ xfs_attr3_leaf_create(
 		ichdr.magic = XFS_ATTR3_LEAF_MAGIC;
 
 		hdr3->blkno = cpu_to_be64(xfs_buf_daddr(bp));
-		hdr3->owner = cpu_to_be64(dp->i_ino);
+		hdr3->owner = cpu_to_be64(args->owner);
 		uuid_copy(&hdr3->uuid, &mp->m_sb.sb_meta_uuid);
 
 		ichdr.freemap[0].base = sizeof(struct xfs_attr3_leaf_hdr);
diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
index bb4cf1fa0dc2c..b8cdd15c4e1af 100644
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
index 21fb8aff40df7..a69d04ed74935 100644
--- a/fs/xfs/libxfs/xfs_da_btree.c
+++ b/fs/xfs/libxfs/xfs_da_btree.c
@@ -485,7 +485,7 @@ xfs_da3_node_create(
 		memset(hdr3, 0, sizeof(struct xfs_da3_node_hdr));
 		ichdr.magic = XFS_DA3_NODE_MAGIC;
 		hdr3->info.blkno = cpu_to_be64(xfs_buf_daddr(bp));
-		hdr3->info.owner = cpu_to_be64(args->dp->i_ino);
+		hdr3->info.owner = cpu_to_be64(args->owner);
 		uuid_copy(&hdr3->info.uuid, &mp->m_sb.sb_meta_uuid);
 	} else {
 		ichdr.magic = XFS_DA_NODE_MAGIC;
diff --git a/fs/xfs/libxfs/xfs_dir2_block.c b/fs/xfs/libxfs/xfs_dir2_block.c
index ba9fce415faf9..c5af43ff6ec8e 100644
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
index 7a6d965bea71b..c3ef720b5ff6e 100644
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
index 08dda5ce9d91c..20ce057d12e82 100644
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
index be0b8834028c0..1ad7405f9c389 100644
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

