Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39798 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726650AbfBGULY (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 7 Feb 2019 15:11:24 -0500
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 4ACE9E6A7B
        for <linux-xfs@vger.kernel.org>; Thu,  7 Feb 2019 20:11:23 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-66.bos.redhat.com [10.18.41.66])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E33335C269
        for <linux-xfs@vger.kernel.org>; Thu,  7 Feb 2019 20:11:22 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v4.1] xfs: miscellaneous verifier magic value fixups
Date: Thu,  7 Feb 2019 15:11:22 -0500
Message-Id: <20190207201122.18668-1-bfoster@redhat.com>
In-Reply-To: <20190207184105.17064-8-bfoster@redhat.com>
References: <20190207184105.17064-8-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Most buffer verifiers have hardcoded magic value checks
conditionalized on the version of the filesystem. The magic value
field of the verifier structure facilitates abstraction of some of
this code. Populate the ->magic field of various verifiers to take
advantage of this abstraction. No functional changes.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---

v4.1:
- Drop the compile-time magic offset checks.

 fs/xfs/libxfs/xfs_alloc.c          | 12 ++++++++----
 fs/xfs/libxfs/xfs_attr_leaf.c      | 11 +++++------
 fs/xfs/libxfs/xfs_attr_remote.c    |  8 +++++---
 fs/xfs/libxfs/xfs_bmap_btree.c     | 13 ++++++-------
 fs/xfs/libxfs/xfs_da_btree.c       | 11 +++++------
 fs/xfs/libxfs/xfs_dir2_block.c     | 10 +++++-----
 fs/xfs/libxfs/xfs_dir2_data.c      | 12 +++++++-----
 fs/xfs/libxfs/xfs_dir2_node.c      | 10 +++++-----
 fs/xfs/libxfs/xfs_ialloc.c         |  3 ++-
 fs/xfs/libxfs/xfs_refcount_btree.c |  3 ++-
 fs/xfs/libxfs/xfs_rmap_btree.c     |  3 ++-
 fs/xfs/libxfs/xfs_sb.c             |  4 +++-
 fs/xfs/libxfs/xfs_symlink_remote.c |  3 ++-
 13 files changed, 57 insertions(+), 46 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 48aab07e7138..bc3367b8b7bb 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -568,9 +568,9 @@ xfs_agfl_verify(
 	if (!xfs_sb_version_hascrc(&mp->m_sb))
 		return NULL;
 
-	if (!uuid_equal(&agfl->agfl_uuid, &mp->m_sb.sb_meta_uuid))
+	if (!xfs_verify_magic(bp, agfl->agfl_magicnum))
 		return __this_address;
-	if (agfl->agfl_magicnum != cpu_to_be32(XFS_AGFL_MAGIC))
+	if (!uuid_equal(&agfl->agfl_uuid, &mp->m_sb.sb_meta_uuid))
 		return __this_address;
 	/*
 	 * during growfs operations, the perag is not fully initialised,
@@ -643,6 +643,7 @@ xfs_agfl_write_verify(
 
 const struct xfs_buf_ops xfs_agfl_buf_ops = {
 	.name = "xfs_agfl",
+	.magic = { cpu_to_be32(XFS_AGFL_MAGIC), cpu_to_be32(XFS_AGFL_MAGIC) },
 	.verify_read = xfs_agfl_read_verify,
 	.verify_write = xfs_agfl_write_verify,
 	.verify_struct = xfs_agfl_verify,
@@ -2587,8 +2588,10 @@ xfs_agf_verify(
 			return __this_address;
 	}
 
-	if (!(agf->agf_magicnum == cpu_to_be32(XFS_AGF_MAGIC) &&
-	      XFS_AGF_GOOD_VERSION(be32_to_cpu(agf->agf_versionnum)) &&
+	if (!xfs_verify_magic(bp, agf->agf_magicnum))
+		return __this_address;
+
+	if (!(XFS_AGF_GOOD_VERSION(be32_to_cpu(agf->agf_versionnum)) &&
 	      be32_to_cpu(agf->agf_freeblks) <= be32_to_cpu(agf->agf_length) &&
 	      be32_to_cpu(agf->agf_flfirst) < xfs_agfl_size(mp) &&
 	      be32_to_cpu(agf->agf_fllast) < xfs_agfl_size(mp) &&
@@ -2670,6 +2673,7 @@ xfs_agf_write_verify(
 
 const struct xfs_buf_ops xfs_agf_buf_ops = {
 	.name = "xfs_agf",
+	.magic = { cpu_to_be32(XFS_AGF_MAGIC), cpu_to_be32(XFS_AGF_MAGIC) },
 	.verify_read = xfs_agf_read_verify,
 	.verify_write = xfs_agf_write_verify,
 	.verify_struct = xfs_agf_verify,
diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index e60eba7f129c..f164f296f1b8 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -248,21 +248,18 @@ xfs_attr3_leaf_verify(
 
 	xfs_attr3_leaf_hdr_from_disk(mp->m_attr_geo, &ichdr, leaf);
 
+	if (!xfs_verify_magic(bp, leaf->hdr.info.magic))
+		return __this_address;
+
 	if (xfs_sb_version_hascrc(&mp->m_sb)) {
 		struct xfs_da3_node_hdr *hdr3 = bp->b_addr;
 
-		if (hdr3->info.hdr.magic != cpu_to_be16(XFS_ATTR3_LEAF_MAGIC))
-			return __this_address;
-
 		if (!uuid_equal(&hdr3->info.uuid, &mp->m_sb.sb_meta_uuid))
 			return __this_address;
 		if (be64_to_cpu(hdr3->info.blkno) != bp->b_bn)
 			return __this_address;
 		if (!xfs_log_check_lsn(mp, be64_to_cpu(hdr3->info.lsn)))
 			return __this_address;
-	} else {
-		if (leaf->hdr.info.magic != cpu_to_be16(XFS_ATTR_LEAF_MAGIC))
-			return __this_address;
 	}
 	/*
 	 * In recovery there is a transient state where count == 0 is valid
@@ -369,6 +366,8 @@ xfs_attr3_leaf_read_verify(
 
 const struct xfs_buf_ops xfs_attr3_leaf_buf_ops = {
 	.name = "xfs_attr3_leaf",
+	.magic = { cpu_to_be16(XFS_ATTR_LEAF_MAGIC),
+		   cpu_to_be16(XFS_ATTR3_LEAF_MAGIC) },
 	.verify_read = xfs_attr3_leaf_read_verify,
 	.verify_write = xfs_attr3_leaf_write_verify,
 	.verify_struct = xfs_attr3_leaf_verify,
diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
index d89363c6b523..65ff600a8067 100644
--- a/fs/xfs/libxfs/xfs_attr_remote.c
+++ b/fs/xfs/libxfs/xfs_attr_remote.c
@@ -79,6 +79,7 @@ xfs_attr3_rmt_hdr_ok(
 static xfs_failaddr_t
 xfs_attr3_rmt_verify(
 	struct xfs_mount	*mp,
+	struct xfs_buf		*bp,
 	void			*ptr,
 	int			fsbsize,
 	xfs_daddr_t		bno)
@@ -87,7 +88,7 @@ xfs_attr3_rmt_verify(
 
 	if (!xfs_sb_version_hascrc(&mp->m_sb))
 		return __this_address;
-	if (rmt->rm_magic != cpu_to_be32(XFS_ATTR3_RMT_MAGIC))
+	if (!xfs_verify_magic(bp, rmt->rm_magic))
 		return __this_address;
 	if (!uuid_equal(&rmt->rm_uuid, &mp->m_sb.sb_meta_uuid))
 		return __this_address;
@@ -131,7 +132,7 @@ __xfs_attr3_rmt_read_verify(
 			*failaddr = __this_address;
 			return -EFSBADCRC;
 		}
-		*failaddr = xfs_attr3_rmt_verify(mp, ptr, blksize, bno);
+		*failaddr = xfs_attr3_rmt_verify(mp, bp, ptr, blksize, bno);
 		if (*failaddr)
 			return -EFSCORRUPTED;
 		len -= blksize;
@@ -193,7 +194,7 @@ xfs_attr3_rmt_write_verify(
 	while (len > 0) {
 		struct xfs_attr3_rmt_hdr *rmt = (struct xfs_attr3_rmt_hdr *)ptr;
 
-		fa = xfs_attr3_rmt_verify(mp, ptr, blksize, bno);
+		fa = xfs_attr3_rmt_verify(mp, bp, ptr, blksize, bno);
 		if (fa) {
 			xfs_verifier_error(bp, -EFSCORRUPTED, fa);
 			return;
@@ -220,6 +221,7 @@ xfs_attr3_rmt_write_verify(
 
 const struct xfs_buf_ops xfs_attr3_rmt_buf_ops = {
 	.name = "xfs_attr3_rmt",
+	.magic = { 0, cpu_to_be32(XFS_ATTR3_RMT_MAGIC) },
 	.verify_read = xfs_attr3_rmt_read_verify,
 	.verify_write = xfs_attr3_rmt_write_verify,
 	.verify_struct = xfs_attr3_rmt_verify_struct,
diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
index cdb74d2e2a43..aff82ed112c9 100644
--- a/fs/xfs/libxfs/xfs_bmap_btree.c
+++ b/fs/xfs/libxfs/xfs_bmap_btree.c
@@ -416,8 +416,10 @@ xfs_bmbt_verify(
 	xfs_failaddr_t		fa;
 	unsigned int		level;
 
-	switch (block->bb_magic) {
-	case cpu_to_be32(XFS_BMAP_CRC_MAGIC):
+	if (!xfs_verify_magic(bp, block->bb_magic))
+		return __this_address;
+
+	if (xfs_sb_version_hascrc(&mp->m_sb)) {
 		/*
 		 * XXX: need a better way of verifying the owner here. Right now
 		 * just make sure there has been one set.
@@ -425,11 +427,6 @@ xfs_bmbt_verify(
 		fa = xfs_btree_lblock_v5hdr_verify(bp, XFS_RMAP_OWN_UNKNOWN);
 		if (fa)
 			return fa;
-		/* fall through */
-	case cpu_to_be32(XFS_BMAP_MAGIC):
-		break;
-	default:
-		return __this_address;
 	}
 
 	/*
@@ -481,6 +478,8 @@ xfs_bmbt_write_verify(
 
 const struct xfs_buf_ops xfs_bmbt_buf_ops = {
 	.name = "xfs_bmbt",
+	.magic = { cpu_to_be32(XFS_BMAP_MAGIC),
+		   cpu_to_be32(XFS_BMAP_CRC_MAGIC) },
 	.verify_read = xfs_bmbt_read_verify,
 	.verify_write = xfs_bmbt_write_verify,
 	.verify_struct = xfs_bmbt_verify,
diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
index 355322688c9f..e02d2f407e12 100644
--- a/fs/xfs/libxfs/xfs_da_btree.c
+++ b/fs/xfs/libxfs/xfs_da_btree.c
@@ -129,21 +129,18 @@ xfs_da3_node_verify(
 
 	ops->node_hdr_from_disk(&ichdr, hdr);
 
+	if (!xfs_verify_magic(bp, hdr->hdr.info.magic))
+		return __this_address;
+
 	if (xfs_sb_version_hascrc(&mp->m_sb)) {
 		struct xfs_da3_node_hdr *hdr3 = bp->b_addr;
 
-		if (hdr3->info.hdr.magic != cpu_to_be16(XFS_DA3_NODE_MAGIC))
-			return __this_address;
-
 		if (!uuid_equal(&hdr3->info.uuid, &mp->m_sb.sb_meta_uuid))
 			return __this_address;
 		if (be64_to_cpu(hdr3->info.blkno) != bp->b_bn)
 			return __this_address;
 		if (!xfs_log_check_lsn(mp, be64_to_cpu(hdr3->info.lsn)))
 			return __this_address;
-	} else {
-		if (hdr->hdr.info.magic != cpu_to_be16(XFS_DA_NODE_MAGIC))
-			return __this_address;
 	}
 	if (ichdr.level == 0)
 		return __this_address;
@@ -257,6 +254,8 @@ xfs_da3_node_verify_struct(
 
 const struct xfs_buf_ops xfs_da3_node_buf_ops = {
 	.name = "xfs_da3_node",
+	.magic = { cpu_to_be16(XFS_DA_NODE_MAGIC),
+		   cpu_to_be16(XFS_DA3_NODE_MAGIC) },
 	.verify_read = xfs_da3_node_read_verify,
 	.verify_write = xfs_da3_node_write_verify,
 	.verify_struct = xfs_da3_node_verify_struct,
diff --git a/fs/xfs/libxfs/xfs_dir2_block.c b/fs/xfs/libxfs/xfs_dir2_block.c
index 30ed5919da72..b7d6d78f4ce2 100644
--- a/fs/xfs/libxfs/xfs_dir2_block.c
+++ b/fs/xfs/libxfs/xfs_dir2_block.c
@@ -53,18 +53,16 @@ xfs_dir3_block_verify(
 	struct xfs_mount	*mp = bp->b_target->bt_mount;
 	struct xfs_dir3_blk_hdr	*hdr3 = bp->b_addr;
 
+	if (!xfs_verify_magic(bp, hdr3->magic))
+		return __this_address;
+
 	if (xfs_sb_version_hascrc(&mp->m_sb)) {
-		if (hdr3->magic != cpu_to_be32(XFS_DIR3_BLOCK_MAGIC))
-			return __this_address;
 		if (!uuid_equal(&hdr3->uuid, &mp->m_sb.sb_meta_uuid))
 			return __this_address;
 		if (be64_to_cpu(hdr3->blkno) != bp->b_bn)
 			return __this_address;
 		if (!xfs_log_check_lsn(mp, be64_to_cpu(hdr3->lsn)))
 			return __this_address;
-	} else {
-		if (hdr3->magic != cpu_to_be32(XFS_DIR2_BLOCK_MAGIC))
-			return __this_address;
 	}
 	return __xfs_dir3_data_check(NULL, bp);
 }
@@ -112,6 +110,8 @@ xfs_dir3_block_write_verify(
 
 const struct xfs_buf_ops xfs_dir3_block_buf_ops = {
 	.name = "xfs_dir3_block",
+	.magic = { cpu_to_be32(XFS_DIR2_BLOCK_MAGIC),
+		   cpu_to_be32(XFS_DIR3_BLOCK_MAGIC) },
 	.verify_read = xfs_dir3_block_read_verify,
 	.verify_write = xfs_dir3_block_write_verify,
 	.verify_struct = xfs_dir3_block_verify,
diff --git a/fs/xfs/libxfs/xfs_dir2_data.c b/fs/xfs/libxfs/xfs_dir2_data.c
index 01162c62ec8f..b7b9ce002cb9 100644
--- a/fs/xfs/libxfs/xfs_dir2_data.c
+++ b/fs/xfs/libxfs/xfs_dir2_data.c
@@ -252,18 +252,16 @@ xfs_dir3_data_verify(
 	struct xfs_mount	*mp = bp->b_target->bt_mount;
 	struct xfs_dir3_blk_hdr	*hdr3 = bp->b_addr;
 
+	if (!xfs_verify_magic(bp, hdr3->magic))
+		return __this_address;
+
 	if (xfs_sb_version_hascrc(&mp->m_sb)) {
-		if (hdr3->magic != cpu_to_be32(XFS_DIR3_DATA_MAGIC))
-			return __this_address;
 		if (!uuid_equal(&hdr3->uuid, &mp->m_sb.sb_meta_uuid))
 			return __this_address;
 		if (be64_to_cpu(hdr3->blkno) != bp->b_bn)
 			return __this_address;
 		if (!xfs_log_check_lsn(mp, be64_to_cpu(hdr3->lsn)))
 			return __this_address;
-	} else {
-		if (hdr3->magic != cpu_to_be32(XFS_DIR2_DATA_MAGIC))
-			return __this_address;
 	}
 	return __xfs_dir3_data_check(NULL, bp);
 }
@@ -339,6 +337,8 @@ xfs_dir3_data_write_verify(
 
 const struct xfs_buf_ops xfs_dir3_data_buf_ops = {
 	.name = "xfs_dir3_data",
+	.magic = { cpu_to_be32(XFS_DIR2_DATA_MAGIC),
+		   cpu_to_be32(XFS_DIR3_DATA_MAGIC) },
 	.verify_read = xfs_dir3_data_read_verify,
 	.verify_write = xfs_dir3_data_write_verify,
 	.verify_struct = xfs_dir3_data_verify,
@@ -346,6 +346,8 @@ const struct xfs_buf_ops xfs_dir3_data_buf_ops = {
 
 static const struct xfs_buf_ops xfs_dir3_data_reada_buf_ops = {
 	.name = "xfs_dir3_data_reada",
+	.magic = { cpu_to_be32(XFS_DIR2_DATA_MAGIC),
+		   cpu_to_be32(XFS_DIR3_DATA_MAGIC) },
 	.verify_read = xfs_dir3_data_reada_verify,
 	.verify_write = xfs_dir3_data_write_verify,
 };
diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
index f1bb3434f51c..3b03703c5c3d 100644
--- a/fs/xfs/libxfs/xfs_dir2_node.c
+++ b/fs/xfs/libxfs/xfs_dir2_node.c
@@ -87,20 +87,18 @@ xfs_dir3_free_verify(
 	struct xfs_mount	*mp = bp->b_target->bt_mount;
 	struct xfs_dir2_free_hdr *hdr = bp->b_addr;
 
+	if (!xfs_verify_magic(bp, hdr->magic))
+		return __this_address;
+
 	if (xfs_sb_version_hascrc(&mp->m_sb)) {
 		struct xfs_dir3_blk_hdr *hdr3 = bp->b_addr;
 
-		if (hdr3->magic != cpu_to_be32(XFS_DIR3_FREE_MAGIC))
-			return __this_address;
 		if (!uuid_equal(&hdr3->uuid, &mp->m_sb.sb_meta_uuid))
 			return __this_address;
 		if (be64_to_cpu(hdr3->blkno) != bp->b_bn)
 			return __this_address;
 		if (!xfs_log_check_lsn(mp, be64_to_cpu(hdr3->lsn)))
 			return __this_address;
-	} else {
-		if (hdr->magic != cpu_to_be32(XFS_DIR2_FREE_MAGIC))
-			return __this_address;
 	}
 
 	/* XXX: should bounds check the xfs_dir3_icfree_hdr here */
@@ -151,6 +149,8 @@ xfs_dir3_free_write_verify(
 
 const struct xfs_buf_ops xfs_dir3_free_buf_ops = {
 	.name = "xfs_dir3_free",
+	.magic = { cpu_to_be32(XFS_DIR2_FREE_MAGIC),
+		   cpu_to_be32(XFS_DIR3_FREE_MAGIC) },
 	.verify_read = xfs_dir3_free_read_verify,
 	.verify_write = xfs_dir3_free_write_verify,
 	.verify_struct = xfs_dir3_free_verify,
diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index d32152fc8a6c..fe9898875097 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -2508,7 +2508,7 @@ xfs_agi_verify(
 	/*
 	 * Validate the magic number of the agi block.
 	 */
-	if (agi->agi_magicnum != cpu_to_be32(XFS_AGI_MAGIC))
+	if (!xfs_verify_magic(bp, agi->agi_magicnum))
 		return __this_address;
 	if (!XFS_AGI_GOOD_VERSION(be32_to_cpu(agi->agi_versionnum)))
 		return __this_address;
@@ -2582,6 +2582,7 @@ xfs_agi_write_verify(
 
 const struct xfs_buf_ops xfs_agi_buf_ops = {
 	.name = "xfs_agi",
+	.magic = { cpu_to_be32(XFS_AGI_MAGIC), cpu_to_be32(XFS_AGI_MAGIC) },
 	.verify_read = xfs_agi_read_verify,
 	.verify_write = xfs_agi_write_verify,
 	.verify_struct = xfs_agi_verify,
diff --git a/fs/xfs/libxfs/xfs_refcount_btree.c b/fs/xfs/libxfs/xfs_refcount_btree.c
index d9eab657b63e..6f47ab876d90 100644
--- a/fs/xfs/libxfs/xfs_refcount_btree.c
+++ b/fs/xfs/libxfs/xfs_refcount_btree.c
@@ -209,7 +209,7 @@ xfs_refcountbt_verify(
 	xfs_failaddr_t		fa;
 	unsigned int		level;
 
-	if (block->bb_magic != cpu_to_be32(XFS_REFC_CRC_MAGIC))
+	if (!xfs_verify_magic(bp, block->bb_magic))
 		return __this_address;
 
 	if (!xfs_sb_version_hasreflink(&mp->m_sb))
@@ -264,6 +264,7 @@ xfs_refcountbt_write_verify(
 
 const struct xfs_buf_ops xfs_refcountbt_buf_ops = {
 	.name			= "xfs_refcountbt",
+	.magic			= { 0, cpu_to_be32(XFS_REFC_CRC_MAGIC) },
 	.verify_read		= xfs_refcountbt_read_verify,
 	.verify_write		= xfs_refcountbt_write_verify,
 	.verify_struct		= xfs_refcountbt_verify,
diff --git a/fs/xfs/libxfs/xfs_rmap_btree.c b/fs/xfs/libxfs/xfs_rmap_btree.c
index f79cf040d745..5738e11055e6 100644
--- a/fs/xfs/libxfs/xfs_rmap_btree.c
+++ b/fs/xfs/libxfs/xfs_rmap_btree.c
@@ -310,7 +310,7 @@ xfs_rmapbt_verify(
 	 * from the on disk AGF. Again, we can only check against maximum limits
 	 * in this case.
 	 */
-	if (block->bb_magic != cpu_to_be32(XFS_RMAP_CRC_MAGIC))
+	if (!xfs_verify_magic(bp, block->bb_magic))
 		return __this_address;
 
 	if (!xfs_sb_version_hasrmapbt(&mp->m_sb))
@@ -365,6 +365,7 @@ xfs_rmapbt_write_verify(
 
 const struct xfs_buf_ops xfs_rmapbt_buf_ops = {
 	.name			= "xfs_rmapbt",
+	.magic			= { 0, cpu_to_be32(XFS_RMAP_CRC_MAGIC) },
 	.verify_read		= xfs_rmapbt_read_verify,
 	.verify_write		= xfs_rmapbt_write_verify,
 	.verify_struct		= xfs_rmapbt_verify,
diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index a2f52a958091..4e5029c37966 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -229,7 +229,7 @@ xfs_validate_sb_common(
 	uint32_t		agcount = 0;
 	uint32_t		rem;
 
-	if (dsb->sb_magicnum != cpu_to_be32(XFS_SB_MAGIC)) {
+	if (!xfs_verify_magic(bp, dsb->sb_magicnum)) {
 		xfs_warn(mp, "bad magic number");
 		return -EWRONGFS;
 	}
@@ -782,12 +782,14 @@ xfs_sb_write_verify(
 
 const struct xfs_buf_ops xfs_sb_buf_ops = {
 	.name = "xfs_sb",
+	.magic = { cpu_to_be32(XFS_SB_MAGIC), cpu_to_be32(XFS_SB_MAGIC) },
 	.verify_read = xfs_sb_read_verify,
 	.verify_write = xfs_sb_write_verify,
 };
 
 const struct xfs_buf_ops xfs_sb_quiet_buf_ops = {
 	.name = "xfs_sb_quiet",
+	.magic = { cpu_to_be32(XFS_SB_MAGIC), cpu_to_be32(XFS_SB_MAGIC) },
 	.verify_read = xfs_sb_quiet_read_verify,
 	.verify_write = xfs_sb_write_verify,
 };
diff --git a/fs/xfs/libxfs/xfs_symlink_remote.c b/fs/xfs/libxfs/xfs_symlink_remote.c
index 77d80106f989..a0ccc253c43d 100644
--- a/fs/xfs/libxfs/xfs_symlink_remote.c
+++ b/fs/xfs/libxfs/xfs_symlink_remote.c
@@ -95,7 +95,7 @@ xfs_symlink_verify(
 
 	if (!xfs_sb_version_hascrc(&mp->m_sb))
 		return __this_address;
-	if (dsl->sl_magic != cpu_to_be32(XFS_SYMLINK_MAGIC))
+	if (!xfs_verify_magic(bp, dsl->sl_magic))
 		return __this_address;
 	if (!uuid_equal(&dsl->sl_uuid, &mp->m_sb.sb_meta_uuid))
 		return __this_address;
@@ -159,6 +159,7 @@ xfs_symlink_write_verify(
 
 const struct xfs_buf_ops xfs_symlink_buf_ops = {
 	.name = "xfs_symlink",
+	.magic = { 0, cpu_to_be32(XFS_SYMLINK_MAGIC) },
 	.verify_read = xfs_symlink_read_verify,
 	.verify_write = xfs_symlink_write_verify,
 	.verify_struct = xfs_symlink_verify,
-- 
2.17.2
