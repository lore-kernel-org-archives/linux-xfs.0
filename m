Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45984 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727607AbfA2Sdx (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 29 Jan 2019 13:33:53 -0500
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id AE2D489AE3
        for <linux-xfs@vger.kernel.org>; Tue, 29 Jan 2019 18:33:52 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-66.bos.redhat.com [10.18.41.66])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 656C05D717
        for <linux-xfs@vger.kernel.org>; Tue, 29 Jan 2019 18:33:52 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 4/5] xfs: miscellaneous verifier magic value fixups
Date: Tue, 29 Jan 2019 13:33:49 -0500
Message-Id: <20190129183350.27302-5-bfoster@redhat.com>
In-Reply-To: <20190129183350.27302-1-bfoster@redhat.com>
References: <20190129183350.27302-1-bfoster@redhat.com>
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
 fs/xfs/libxfs/xfs_alloc.c          | 12 ++++++++----
 fs/xfs/libxfs/xfs_attr_leaf.c      | 10 ++++------
 fs/xfs/libxfs/xfs_attr_remote.c    |  8 +++++---
 fs/xfs/libxfs/xfs_bmap_btree.c     | 12 +++++-------
 fs/xfs/libxfs/xfs_da_btree.c       | 10 ++++------
 fs/xfs/libxfs/xfs_dir2_block.c     |  9 ++++-----
 fs/xfs/libxfs/xfs_dir2_data.c      |  9 ++++-----
 fs/xfs/libxfs/xfs_dir2_node.c      | 10 +++++-----
 fs/xfs/libxfs/xfs_ialloc.c         |  3 ++-
 fs/xfs/libxfs/xfs_refcount_btree.c |  3 ++-
 fs/xfs/libxfs/xfs_rmap_btree.c     |  3 ++-
 fs/xfs/libxfs/xfs_sb.c             |  4 +++-
 fs/xfs/libxfs/xfs_symlink_remote.c |  3 ++-
 13 files changed, 50 insertions(+), 46 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index b715668886a4..6a68bd5cf42d 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -568,9 +568,9 @@ xfs_agfl_verify(
 	if (!xfs_sb_version_hascrc(&mp->m_sb))
 		return NULL;
 
-	if (!uuid_equal(&agfl->agfl_uuid, &mp->m_sb.sb_meta_uuid))
+	if (!xfs_verify_magic(bp, be32_to_cpu(agfl->agfl_magicnum)))
 		return __this_address;
-	if (be32_to_cpu(agfl->agfl_magicnum) != XFS_AGFL_MAGIC)
+	if (!uuid_equal(&agfl->agfl_uuid, &mp->m_sb.sb_meta_uuid))
 		return __this_address;
 	/*
 	 * during growfs operations, the perag is not fully initialised,
@@ -643,6 +643,7 @@ xfs_agfl_write_verify(
 
 const struct xfs_buf_ops xfs_agfl_buf_ops = {
 	.name = "xfs_agfl",
+	.magic = { XFS_AGFL_MAGIC, XFS_AGFL_MAGIC },
 	.verify_read = xfs_agfl_read_verify,
 	.verify_write = xfs_agfl_write_verify,
 	.verify_struct = xfs_agfl_verify,
@@ -2587,8 +2588,10 @@ xfs_agf_verify(
 			return __this_address;
 	}
 
-	if (!(agf->agf_magicnum == cpu_to_be32(XFS_AGF_MAGIC) &&
-	      XFS_AGF_GOOD_VERSION(be32_to_cpu(agf->agf_versionnum)) &&
+	if (!xfs_verify_magic(bp, be32_to_cpu(agf->agf_magicnum)))
+		return __this_address;
+
+	if (!(XFS_AGF_GOOD_VERSION(be32_to_cpu(agf->agf_versionnum)) &&
 	      be32_to_cpu(agf->agf_freeblks) <= be32_to_cpu(agf->agf_length) &&
 	      be32_to_cpu(agf->agf_flfirst) < xfs_agfl_size(mp) &&
 	      be32_to_cpu(agf->agf_fllast) < xfs_agfl_size(mp) &&
@@ -2670,6 +2673,7 @@ xfs_agf_write_verify(
 
 const struct xfs_buf_ops xfs_agf_buf_ops = {
 	.name = "xfs_agf",
+	.magic = { XFS_AGF_MAGIC, XFS_AGF_MAGIC },
 	.verify_read = xfs_agf_read_verify,
 	.verify_write = xfs_agf_write_verify,
 	.verify_struct = xfs_agf_verify,
diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index 2652d00842d6..d3b515674c21 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -248,21 +248,18 @@ xfs_attr3_leaf_verify(
 
 	xfs_attr3_leaf_hdr_from_disk(mp->m_attr_geo, &ichdr, leaf);
 
+	if (!xfs_verify_magic(bp, ichdr.magic))
+		return __this_address;
+
 	if (xfs_sb_version_hascrc(&mp->m_sb)) {
 		struct xfs_da3_node_hdr *hdr3 = bp->b_addr;
 
-		if (ichdr.magic != XFS_ATTR3_LEAF_MAGIC)
-			return __this_address;
-
 		if (!uuid_equal(&hdr3->info.uuid, &mp->m_sb.sb_meta_uuid))
 			return __this_address;
 		if (be64_to_cpu(hdr3->info.blkno) != bp->b_bn)
 			return __this_address;
 		if (!xfs_log_check_lsn(mp, be64_to_cpu(hdr3->info.lsn)))
 			return __this_address;
-	} else {
-		if (ichdr.magic != XFS_ATTR_LEAF_MAGIC)
-			return __this_address;
 	}
 	/*
 	 * In recovery there is a transient state where count == 0 is valid
@@ -369,6 +366,7 @@ xfs_attr3_leaf_read_verify(
 
 const struct xfs_buf_ops xfs_attr3_leaf_buf_ops = {
 	.name = "xfs_attr3_leaf",
+	.magic = { XFS_ATTR_LEAF_MAGIC, XFS_ATTR3_LEAF_MAGIC },
 	.verify_read = xfs_attr3_leaf_read_verify,
 	.verify_write = xfs_attr3_leaf_write_verify,
 	.verify_struct = xfs_attr3_leaf_verify,
diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
index d89363c6b523..d04587bec82b 100644
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
+	if (!xfs_verify_magic(bp, be32_to_cpu(rmt->rm_magic)))
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
+	.magic = { 0, XFS_ATTR3_RMT_MAGIC },
 	.verify_read = xfs_attr3_rmt_read_verify,
 	.verify_write = xfs_attr3_rmt_write_verify,
 	.verify_struct = xfs_attr3_rmt_verify_struct,
diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
index cdb74d2e2a43..bc5c5f1c66f3 100644
--- a/fs/xfs/libxfs/xfs_bmap_btree.c
+++ b/fs/xfs/libxfs/xfs_bmap_btree.c
@@ -416,8 +416,10 @@ xfs_bmbt_verify(
 	xfs_failaddr_t		fa;
 	unsigned int		level;
 
-	switch (block->bb_magic) {
-	case cpu_to_be32(XFS_BMAP_CRC_MAGIC):
+	if (!xfs_verify_magic(bp, be32_to_cpu(block->bb_magic)))
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
@@ -481,6 +478,7 @@ xfs_bmbt_write_verify(
 
 const struct xfs_buf_ops xfs_bmbt_buf_ops = {
 	.name = "xfs_bmbt",
+	.magic = { XFS_BMAP_MAGIC, XFS_BMAP_CRC_MAGIC },
 	.verify_read = xfs_bmbt_read_verify,
 	.verify_write = xfs_bmbt_write_verify,
 	.verify_struct = xfs_bmbt_verify,
diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
index 376bee94b5dd..ad5e7e2cfe2d 100644
--- a/fs/xfs/libxfs/xfs_da_btree.c
+++ b/fs/xfs/libxfs/xfs_da_btree.c
@@ -129,21 +129,18 @@ xfs_da3_node_verify(
 
 	ops->node_hdr_from_disk(&ichdr, hdr);
 
+	if (!xfs_verify_magic(bp, ichdr.magic))
+		return __this_address;
+
 	if (xfs_sb_version_hascrc(&mp->m_sb)) {
 		struct xfs_da3_node_hdr *hdr3 = bp->b_addr;
 
-		if (ichdr.magic != XFS_DA3_NODE_MAGIC)
-			return __this_address;
-
 		if (!uuid_equal(&hdr3->info.uuid, &mp->m_sb.sb_meta_uuid))
 			return __this_address;
 		if (be64_to_cpu(hdr3->info.blkno) != bp->b_bn)
 			return __this_address;
 		if (!xfs_log_check_lsn(mp, be64_to_cpu(hdr3->info.lsn)))
 			return __this_address;
-	} else {
-		if (ichdr.magic != XFS_DA_NODE_MAGIC)
-			return __this_address;
 	}
 	if (ichdr.level == 0)
 		return __this_address;
@@ -257,6 +254,7 @@ xfs_da3_node_verify_struct(
 
 const struct xfs_buf_ops xfs_da3_node_buf_ops = {
 	.name = "xfs_da3_node",
+	.magic = { XFS_DA_NODE_MAGIC, XFS_DA3_NODE_MAGIC },
 	.verify_read = xfs_da3_node_read_verify,
 	.verify_write = xfs_da3_node_write_verify,
 	.verify_struct = xfs_da3_node_verify_struct,
diff --git a/fs/xfs/libxfs/xfs_dir2_block.c b/fs/xfs/libxfs/xfs_dir2_block.c
index 30ed5919da72..14cb124ef809 100644
--- a/fs/xfs/libxfs/xfs_dir2_block.c
+++ b/fs/xfs/libxfs/xfs_dir2_block.c
@@ -53,18 +53,16 @@ xfs_dir3_block_verify(
 	struct xfs_mount	*mp = bp->b_target->bt_mount;
 	struct xfs_dir3_blk_hdr	*hdr3 = bp->b_addr;
 
+	if (!xfs_verify_magic(bp, be32_to_cpu(hdr3->magic)))
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
@@ -112,6 +110,7 @@ xfs_dir3_block_write_verify(
 
 const struct xfs_buf_ops xfs_dir3_block_buf_ops = {
 	.name = "xfs_dir3_block",
+	.magic = { XFS_DIR2_BLOCK_MAGIC, XFS_DIR3_BLOCK_MAGIC },
 	.verify_read = xfs_dir3_block_read_verify,
 	.verify_write = xfs_dir3_block_write_verify,
 	.verify_struct = xfs_dir3_block_verify,
diff --git a/fs/xfs/libxfs/xfs_dir2_data.c b/fs/xfs/libxfs/xfs_dir2_data.c
index 01162c62ec8f..14927c2d8b3d 100644
--- a/fs/xfs/libxfs/xfs_dir2_data.c
+++ b/fs/xfs/libxfs/xfs_dir2_data.c
@@ -252,18 +252,16 @@ xfs_dir3_data_verify(
 	struct xfs_mount	*mp = bp->b_target->bt_mount;
 	struct xfs_dir3_blk_hdr	*hdr3 = bp->b_addr;
 
+	if (!xfs_verify_magic(bp, be32_to_cpu(hdr3->magic)))
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
@@ -339,6 +337,7 @@ xfs_dir3_data_write_verify(
 
 const struct xfs_buf_ops xfs_dir3_data_buf_ops = {
 	.name = "xfs_dir3_data",
+	.magic = { XFS_DIR2_DATA_MAGIC, XFS_DIR3_DATA_MAGIC },
 	.verify_read = xfs_dir3_data_read_verify,
 	.verify_write = xfs_dir3_data_write_verify,
 	.verify_struct = xfs_dir3_data_verify,
diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
index f1bb3434f51c..3a6b34a246c6 100644
--- a/fs/xfs/libxfs/xfs_dir2_node.c
+++ b/fs/xfs/libxfs/xfs_dir2_node.c
@@ -87,20 +87,19 @@ xfs_dir3_free_verify(
 	struct xfs_mount	*mp = bp->b_target->bt_mount;
 	struct xfs_dir2_free_hdr *hdr = bp->b_addr;
 
+	if (!xfs_verify_magic(bp, be32_to_cpu(hdr->magic)))
+		return __this_address;
+
 	if (xfs_sb_version_hascrc(&mp->m_sb)) {
 		struct xfs_dir3_blk_hdr *hdr3 = bp->b_addr;
 
-		if (hdr3->magic != cpu_to_be32(XFS_DIR3_FREE_MAGIC))
-			return __this_address;
+		ASSERT(hdr3->magic == hdr->magic);
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
@@ -151,6 +150,7 @@ xfs_dir3_free_write_verify(
 
 const struct xfs_buf_ops xfs_dir3_free_buf_ops = {
 	.name = "xfs_dir3_free",
+	.magic = { XFS_DIR2_FREE_MAGIC, XFS_DIR3_FREE_MAGIC },
 	.verify_read = xfs_dir3_free_read_verify,
 	.verify_write = xfs_dir3_free_write_verify,
 	.verify_struct = xfs_dir3_free_verify,
diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index d32152fc8a6c..d8141c02b1eb 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -2508,7 +2508,7 @@ xfs_agi_verify(
 	/*
 	 * Validate the magic number of the agi block.
 	 */
-	if (agi->agi_magicnum != cpu_to_be32(XFS_AGI_MAGIC))
+	if (!xfs_verify_magic(bp, be32_to_cpu(agi->agi_magicnum)))
 		return __this_address;
 	if (!XFS_AGI_GOOD_VERSION(be32_to_cpu(agi->agi_versionnum)))
 		return __this_address;
@@ -2582,6 +2582,7 @@ xfs_agi_write_verify(
 
 const struct xfs_buf_ops xfs_agi_buf_ops = {
 	.name = "xfs_agi",
+	.magic = { XFS_AGI_MAGIC, XFS_AGI_MAGIC },
 	.verify_read = xfs_agi_read_verify,
 	.verify_write = xfs_agi_write_verify,
 	.verify_struct = xfs_agi_verify,
diff --git a/fs/xfs/libxfs/xfs_refcount_btree.c b/fs/xfs/libxfs/xfs_refcount_btree.c
index d9eab657b63e..62698cafd2a8 100644
--- a/fs/xfs/libxfs/xfs_refcount_btree.c
+++ b/fs/xfs/libxfs/xfs_refcount_btree.c
@@ -209,7 +209,7 @@ xfs_refcountbt_verify(
 	xfs_failaddr_t		fa;
 	unsigned int		level;
 
-	if (block->bb_magic != cpu_to_be32(XFS_REFC_CRC_MAGIC))
+	if (!xfs_verify_magic(bp, be32_to_cpu(block->bb_magic)))
 		return __this_address;
 
 	if (!xfs_sb_version_hasreflink(&mp->m_sb))
@@ -264,6 +264,7 @@ xfs_refcountbt_write_verify(
 
 const struct xfs_buf_ops xfs_refcountbt_buf_ops = {
 	.name			= "xfs_refcountbt",
+	.magic			= { 0, XFS_REFC_CRC_MAGIC },
 	.verify_read		= xfs_refcountbt_read_verify,
 	.verify_write		= xfs_refcountbt_write_verify,
 	.verify_struct		= xfs_refcountbt_verify,
diff --git a/fs/xfs/libxfs/xfs_rmap_btree.c b/fs/xfs/libxfs/xfs_rmap_btree.c
index f79cf040d745..94999a9abafe 100644
--- a/fs/xfs/libxfs/xfs_rmap_btree.c
+++ b/fs/xfs/libxfs/xfs_rmap_btree.c
@@ -310,7 +310,7 @@ xfs_rmapbt_verify(
 	 * from the on disk AGF. Again, we can only check against maximum limits
 	 * in this case.
 	 */
-	if (block->bb_magic != cpu_to_be32(XFS_RMAP_CRC_MAGIC))
+	if (!xfs_verify_magic(bp, be32_to_cpu(block->bb_magic)))
 		return __this_address;
 
 	if (!xfs_sb_version_hasrmapbt(&mp->m_sb))
@@ -365,6 +365,7 @@ xfs_rmapbt_write_verify(
 
 const struct xfs_buf_ops xfs_rmapbt_buf_ops = {
 	.name			= "xfs_rmapbt",
+	.magic			= { 0, XFS_RMAP_CRC_MAGIC },
 	.verify_read		= xfs_rmapbt_read_verify,
 	.verify_write		= xfs_rmapbt_write_verify,
 	.verify_struct		= xfs_rmapbt_verify,
diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index b5a82acd7dfe..aff54794cd98 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -228,7 +228,7 @@ xfs_validate_sb_common(
 	uint32_t		agcount = 0;
 	uint32_t		rem;
 
-	if (sbp->sb_magicnum != XFS_SB_MAGIC) {
+	if (!xfs_verify_magic(bp, sbp->sb_magicnum)) {
 		xfs_warn(mp, "bad magic number");
 		return -EWRONGFS;
 	}
@@ -781,12 +781,14 @@ xfs_sb_write_verify(
 
 const struct xfs_buf_ops xfs_sb_buf_ops = {
 	.name = "xfs_sb",
+	.magic = { XFS_SB_MAGIC, XFS_SB_MAGIC },
 	.verify_read = xfs_sb_read_verify,
 	.verify_write = xfs_sb_write_verify,
 };
 
 const struct xfs_buf_ops xfs_sb_quiet_buf_ops = {
 	.name = "xfs_sb_quiet",
+	.magic = { XFS_SB_MAGIC, XFS_SB_MAGIC },
 	.verify_read = xfs_sb_quiet_read_verify,
 	.verify_write = xfs_sb_write_verify,
 };
diff --git a/fs/xfs/libxfs/xfs_symlink_remote.c b/fs/xfs/libxfs/xfs_symlink_remote.c
index 77d80106f989..bece8ac767de 100644
--- a/fs/xfs/libxfs/xfs_symlink_remote.c
+++ b/fs/xfs/libxfs/xfs_symlink_remote.c
@@ -95,7 +95,7 @@ xfs_symlink_verify(
 
 	if (!xfs_sb_version_hascrc(&mp->m_sb))
 		return __this_address;
-	if (dsl->sl_magic != cpu_to_be32(XFS_SYMLINK_MAGIC))
+	if (!xfs_verify_magic(bp, be32_to_cpu(dsl->sl_magic)))
 		return __this_address;
 	if (!uuid_equal(&dsl->sl_uuid, &mp->m_sb.sb_meta_uuid))
 		return __this_address;
@@ -159,6 +159,7 @@ xfs_symlink_write_verify(
 
 const struct xfs_buf_ops xfs_symlink_buf_ops = {
 	.name = "xfs_symlink",
+	.magic = { 0, XFS_SYMLINK_MAGIC },
 	.verify_read = xfs_symlink_read_verify,
 	.verify_write = xfs_symlink_write_verify,
 	.verify_struct = xfs_symlink_verify,
-- 
2.17.2
