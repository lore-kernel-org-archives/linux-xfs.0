Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B310C77B7A
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 01:30:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234071AbjEZBaz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 21:30:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230297AbjEZBaz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 21:30:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24F58125
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 18:30:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B5C1064C30
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 01:30:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DDF5C433D2;
        Fri, 26 May 2023 01:30:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685064653;
        bh=LIlsByehIi6GSLdwMJJTTx1/PMldNB2y9VDVKj4nCI8=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=bjmoRtUq3RlO9VOQ5Lz9qoc6ce/CctSdkU1CP73LTOflmenhg4jZtgD0Hn6o8Ycu/
         d8W4aTQbmFgsNJ9DZnfG0ANUSEeZJ7SORUXR/P6F2fnvfbZdQOam5pI0Mrut2asp3D
         iBsT2s6Ox4sAf4GS2cnBEXRD0cq8c7IVVWMdCHiXEePWfHza9d3oW3I0vW+4mpISKd
         N6K7fXK1tZkuMt6i7fU1+5UAc7izjbzbocgOr0L/rgKOtLbAP1/44EphJn9IEZodF0
         4XUASH35IuRaQ47H4KPWlRa88Yl1cLhNSKKnBZhPDEk9HnsCPpzbl9QF/Rfn/AoWZK
         qzlfO2xlFKYZw==
Date:   Thu, 25 May 2023 18:30:52 -0700
Subject: [PATCH 2/9] xfs: use the xfs_da_args owner field to set new dir/attr
 block owner
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <168506066404.3735378.14861847965214447251.stgit@frogsfrogsfrogs>
In-Reply-To: <168506066363.3735378.3534676169269107254.stgit@frogsfrogsfrogs>
References: <168506066363.3735378.3534676169269107254.stgit@frogsfrogsfrogs>
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

