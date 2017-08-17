Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:49013 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753775AbdHQXct (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Aug 2017 19:32:49 -0400
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v7HNWlgZ027700
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 17 Aug 2017 23:32:48 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id v7HNWlPE009201
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 17 Aug 2017 23:32:47 GMT
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id v7HNWlSL016960
        for <linux-xfs@vger.kernel.org>; Thu, 17 Aug 2017 23:32:47 GMT
Subject: [PATCH 12/12] xfs: create a new buf_ops pointer to verify structure
 metadata
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 17 Aug 2017 16:32:45 -0700
Message-ID: <150301276585.5851.10650491013456649407.stgit@magnolia>
In-Reply-To: <150301268960.5851.2513223883233763065.stgit@magnolia>
References: <150301268960.5851.2513223883233763065.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org, darrick.wong@oracle.com

From: Darrick J. Wong <darrick.wong@oracle.com>

Expose all metadata structure buffer verifier functions via buf_ops.
These will be used by the online scrub mechanism to look for problems
with buffers that are already sitting around in memory.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_alloc.c          |   14 ++++++++------
 fs/xfs/libxfs/xfs_alloc_btree.c    |    1 +
 fs/xfs/libxfs/xfs_attr_leaf.c      |    1 +
 fs/xfs/libxfs/xfs_attr_remote.c    |   32 ++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_bmap_btree.c     |    1 +
 fs/xfs/libxfs/xfs_da_btree.c       |   25 +++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_dir2_block.c     |    1 +
 fs/xfs/libxfs/xfs_dir2_data.c      |    1 +
 fs/xfs/libxfs/xfs_dir2_leaf.c      |   16 ++++++++++++++++
 fs/xfs/libxfs/xfs_dir2_node.c      |    1 +
 fs/xfs/libxfs/xfs_dquot_buf.c      |   12 ++++++++++++
 fs/xfs/libxfs/xfs_ialloc.c         |    1 +
 fs/xfs/libxfs/xfs_ialloc_btree.c   |    1 +
 fs/xfs/libxfs/xfs_refcount_btree.c |    1 +
 fs/xfs/libxfs/xfs_rmap_btree.c     |    1 +
 fs/xfs/libxfs/xfs_symlink_remote.c |    1 +
 fs/xfs/xfs_buf.h                   |    1 +
 17 files changed, 105 insertions(+), 6 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index d49b1e3..21a1c21 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -604,6 +604,7 @@ const struct xfs_buf_ops xfs_agfl_buf_ops = {
 	.name = "xfs_agfl",
 	.verify_read = xfs_agfl_read_verify,
 	.verify_write = xfs_agfl_write_verify,
+	.verify_struct = xfs_agfl_verify,
 };
 
 /*
@@ -2393,10 +2394,10 @@ xfs_alloc_put_freelist(
 
 static void *
 xfs_agf_verify(
-	struct xfs_mount *mp,
-	struct xfs_buf	*bp)
- {
-	struct xfs_agf	*agf = XFS_BUF_TO_AGF(bp);
+	struct xfs_buf		*bp)
+{
+	struct xfs_mount	*mp = bp->b_target->bt_mount;
+	struct xfs_agf		*agf = XFS_BUF_TO_AGF(bp);
 
 	if (xfs_sb_version_hascrc(&mp->m_sb)) {
 		if (!uuid_equal(&agf->agf_uuid, &mp->m_sb.sb_meta_uuid))
@@ -2457,7 +2458,7 @@ xfs_agf_read_verify(
 	if (xfs_sb_version_hascrc(&mp->m_sb) &&
 	    !xfs_buf_verify_cksum(bp, XFS_AGF_CRC_OFF))
 		xfs_buf_ioerror(bp, -EFSBADCRC);
-	else if (XFS_TEST_ERROR((failed_at = xfs_agf_verify(mp, bp)), mp,
+	else if (XFS_TEST_ERROR((failed_at = xfs_agf_verify(bp)), mp,
 				XFS_ERRTAG_ALLOC_READ_AGF))
 		xfs_buf_ioerror(bp, -EFSCORRUPTED);
 
@@ -2473,7 +2474,7 @@ xfs_agf_write_verify(
 	struct xfs_buf_log_item	*bip = bp->b_fspriv;
 	void			*failed_at;
 
-	if ((failed_at = xfs_agf_verify(mp, bp))) {
+	if ((failed_at = xfs_agf_verify(bp))) {
 		xfs_buf_ioerror(bp, -EFSCORRUPTED);
 		xfs_verifier_error(bp, failed_at);
 		return;
@@ -2492,6 +2493,7 @@ const struct xfs_buf_ops xfs_agf_buf_ops = {
 	.name = "xfs_agf",
 	.verify_read = xfs_agf_read_verify,
 	.verify_write = xfs_agf_write_verify,
+	.verify_struct = xfs_agf_verify,
 };
 
 /*
diff --git a/fs/xfs/libxfs/xfs_alloc_btree.c b/fs/xfs/libxfs/xfs_alloc_btree.c
index 8d4c004..eb79f6c 100644
--- a/fs/xfs/libxfs/xfs_alloc_btree.c
+++ b/fs/xfs/libxfs/xfs_alloc_btree.c
@@ -397,6 +397,7 @@ const struct xfs_buf_ops xfs_allocbt_buf_ops = {
 	.name = "xfs_allocbt",
 	.verify_read = xfs_allocbt_read_verify,
 	.verify_write = xfs_allocbt_write_verify,
+	.verify_struct = xfs_allocbt_verify,
 };
 
 
diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index bde5269..3a563c5 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -339,6 +339,7 @@ const struct xfs_buf_ops xfs_attr3_leaf_buf_ops = {
 	.name = "xfs_attr3_leaf",
 	.verify_read = xfs_attr3_leaf_read_verify,
 	.verify_write = xfs_attr3_leaf_write_verify,
+	.verify_struct = xfs_attr3_leaf_verify,
 };
 
 int
diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
index d33a4d3..164c366 100644
--- a/fs/xfs/libxfs/xfs_attr_remote.c
+++ b/fs/xfs/libxfs/xfs_attr_remote.c
@@ -203,10 +203,42 @@ xfs_attr3_rmt_write_verify(
 	ASSERT(len == 0);
 }
 
+static void *
+xfs_attr3_rmt_verify_struct(
+	struct xfs_buf	*bp)
+{
+	struct xfs_mount *mp = bp->b_target->bt_mount;
+	char		*ptr;
+	void		*failed_at;
+	int		len;
+	xfs_daddr_t	bno;
+	int		blksize = mp->m_attr_geo->blksize;
+
+	/* no verification of non-crc buffers */
+	if (!xfs_sb_version_hascrc(&mp->m_sb))
+		return NULL;
+
+	ptr = bp->b_addr;
+	bno = bp->b_bn;
+	len = BBTOB(bp->b_length);
+	ASSERT(len >= blksize);
+
+	while (len > 0) {
+		if ((failed_at = xfs_attr3_rmt_verify(mp, ptr, blksize, bno)))
+			return failed_at;
+		len -= blksize;
+		ptr += blksize;
+		bno += BTOBB(blksize);
+	}
+
+	return NULL;
+}
+
 const struct xfs_buf_ops xfs_attr3_rmt_buf_ops = {
 	.name = "xfs_attr3_rmt",
 	.verify_read = xfs_attr3_rmt_read_verify,
 	.verify_write = xfs_attr3_rmt_write_verify,
+	.verify_struct = xfs_attr3_rmt_verify_struct,
 };
 
 STATIC int
diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
index d613080..0d5dd7b 100644
--- a/fs/xfs/libxfs/xfs_bmap_btree.c
+++ b/fs/xfs/libxfs/xfs_bmap_btree.c
@@ -692,6 +692,7 @@ const struct xfs_buf_ops xfs_bmbt_buf_ops = {
 	.name = "xfs_bmbt",
 	.verify_read = xfs_bmbt_read_verify,
 	.verify_write = xfs_bmbt_write_verify,
+	.verify_struct = xfs_bmbt_verify,
 };
 
 
diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
index f3544fb..af738bf 100644
--- a/fs/xfs/libxfs/xfs_da_btree.c
+++ b/fs/xfs/libxfs/xfs_da_btree.c
@@ -247,10 +247,35 @@ xfs_da3_node_read_verify(
 	xfs_verifier_error(bp, failed_at);
 }
 
+/* Verify the structure of a da3 block. */
+static void *
+xfs_da3_node_verify_struct(
+	struct xfs_buf		*bp)
+{
+	struct xfs_da_blkinfo	*info = bp->b_addr;
+
+	switch (be16_to_cpu(info->magic)) {
+	case XFS_DA3_NODE_MAGIC:
+	case XFS_DA_NODE_MAGIC:
+		return xfs_da3_node_verify(bp);
+	case XFS_ATTR_LEAF_MAGIC:
+	case XFS_ATTR3_LEAF_MAGIC:
+		bp->b_ops = &xfs_attr3_leaf_buf_ops;
+		return bp->b_ops->verify_struct(bp);
+	case XFS_DIR2_LEAFN_MAGIC:
+	case XFS_DIR3_LEAFN_MAGIC:
+		bp->b_ops = &xfs_dir3_leafn_buf_ops;
+		return bp->b_ops->verify_struct(bp);
+	default:
+		return __this_address;
+	}
+}
+
 const struct xfs_buf_ops xfs_da3_node_buf_ops = {
 	.name = "xfs_da3_node",
 	.verify_read = xfs_da3_node_read_verify,
 	.verify_write = xfs_da3_node_write_verify,
+	.verify_struct = xfs_da3_node_verify_struct,
 };
 
 int
diff --git a/fs/xfs/libxfs/xfs_dir2_block.c b/fs/xfs/libxfs/xfs_dir2_block.c
index 6c54d03..6dce935 100644
--- a/fs/xfs/libxfs/xfs_dir2_block.c
+++ b/fs/xfs/libxfs/xfs_dir2_block.c
@@ -126,6 +126,7 @@ const struct xfs_buf_ops xfs_dir3_block_buf_ops = {
 	.name = "xfs_dir3_block",
 	.verify_read = xfs_dir3_block_read_verify,
 	.verify_write = xfs_dir3_block_write_verify,
+	.verify_struct = xfs_dir3_block_verify,
 };
 
 int
diff --git a/fs/xfs/libxfs/xfs_dir2_data.c b/fs/xfs/libxfs/xfs_dir2_data.c
index 5e27b71..d08a7ac 100644
--- a/fs/xfs/libxfs/xfs_dir2_data.c
+++ b/fs/xfs/libxfs/xfs_dir2_data.c
@@ -318,6 +318,7 @@ const struct xfs_buf_ops xfs_dir3_data_buf_ops = {
 	.name = "xfs_dir3_data",
 	.verify_read = xfs_dir3_data_read_verify,
 	.verify_write = xfs_dir3_data_write_verify,
+	.verify_struct = xfs_dir3_data_verify,
 };
 
 static const struct xfs_buf_ops xfs_dir3_data_reada_buf_ops = {
diff --git a/fs/xfs/libxfs/xfs_dir2_leaf.c b/fs/xfs/libxfs/xfs_dir2_leaf.c
index 00dcfef..792fd98 100644
--- a/fs/xfs/libxfs/xfs_dir2_leaf.c
+++ b/fs/xfs/libxfs/xfs_dir2_leaf.c
@@ -218,6 +218,13 @@ __write_verify(
 	xfs_buf_update_cksum(bp, XFS_DIR3_LEAF_CRC_OFF);
 }
 
+static void *
+xfs_dir3_leaf1_verify(
+	struct xfs_buf	*bp)
+{
+	return xfs_dir3_leaf_verify(bp, XFS_DIR2_LEAF1_MAGIC);
+}
+
 static void
 xfs_dir3_leaf1_read_verify(
 	struct xfs_buf	*bp)
@@ -232,6 +239,13 @@ xfs_dir3_leaf1_write_verify(
 	__write_verify(bp, XFS_DIR2_LEAF1_MAGIC);
 }
 
+static void *
+xfs_dir3_leafn_verify(
+	struct xfs_buf	*bp)
+{
+	return xfs_dir3_leaf_verify(bp, XFS_DIR2_LEAFN_MAGIC);
+}
+
 static void
 xfs_dir3_leafn_read_verify(
 	struct xfs_buf	*bp)
@@ -250,12 +264,14 @@ const struct xfs_buf_ops xfs_dir3_leaf1_buf_ops = {
 	.name = "xfs_dir3_leaf1",
 	.verify_read = xfs_dir3_leaf1_read_verify,
 	.verify_write = xfs_dir3_leaf1_write_verify,
+	.verify_struct = xfs_dir3_leaf1_verify,
 };
 
 const struct xfs_buf_ops xfs_dir3_leafn_buf_ops = {
 	.name = "xfs_dir3_leafn",
 	.verify_read = xfs_dir3_leafn_read_verify,
 	.verify_write = xfs_dir3_leafn_write_verify,
+	.verify_struct = xfs_dir3_leafn_verify,
 };
 
 int
diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
index a11585b..1a5e383 100644
--- a/fs/xfs/libxfs/xfs_dir2_node.c
+++ b/fs/xfs/libxfs/xfs_dir2_node.c
@@ -155,6 +155,7 @@ const struct xfs_buf_ops xfs_dir3_free_buf_ops = {
 	.name = "xfs_dir3_free",
 	.verify_read = xfs_dir3_free_read_verify,
 	.verify_write = xfs_dir3_free_write_verify,
+	.verify_struct = xfs_dir3_free_verify,
 };
 
 /* Everything ok in the free block header? */
diff --git a/fs/xfs/libxfs/xfs_dquot_buf.c b/fs/xfs/libxfs/xfs_dquot_buf.c
index 5561011..8ce5239 100644
--- a/fs/xfs/libxfs/xfs_dquot_buf.c
+++ b/fs/xfs/libxfs/xfs_dquot_buf.c
@@ -242,6 +242,17 @@ xfs_dquot_buf_verify(
 	return true;
 }
 
+static void *
+xfs_dquot_buf_verify_struct(
+	struct xfs_buf	*bp)
+{
+	struct xfs_mount	*mp = bp->b_target->bt_mount;
+
+	if (!xfs_dquot_buf_verify(mp, bp, 0))
+		return __this_address;
+	return NULL;
+}
+
 static void
 xfs_dquot_buf_read_verify(
 	struct xfs_buf	*bp)
@@ -298,6 +309,7 @@ const struct xfs_buf_ops xfs_dquot_buf_ops = {
 	.name = "xfs_dquot",
 	.verify_read = xfs_dquot_buf_read_verify,
 	.verify_write = xfs_dquot_buf_write_verify,
+	.verify_struct = xfs_dquot_buf_verify_struct,
 };
 
 const struct xfs_buf_ops xfs_dquot_buf_ra_ops = {
diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index f27edc9..1c316f8 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -2586,6 +2586,7 @@ const struct xfs_buf_ops xfs_agi_buf_ops = {
 	.name = "xfs_agi",
 	.verify_read = xfs_agi_read_verify,
 	.verify_write = xfs_agi_write_verify,
+	.verify_struct = xfs_agi_verify,
 };
 
 /*
diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.c b/fs/xfs/libxfs/xfs_ialloc_btree.c
index 38d6a50..f920ca6 100644
--- a/fs/xfs/libxfs/xfs_ialloc_btree.c
+++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
@@ -327,6 +327,7 @@ const struct xfs_buf_ops xfs_inobt_buf_ops = {
 	.name = "xfs_inobt",
 	.verify_read = xfs_inobt_read_verify,
 	.verify_write = xfs_inobt_write_verify,
+	.verify_struct = xfs_inobt_verify,
 };
 
 STATIC int
diff --git a/fs/xfs/libxfs/xfs_refcount_btree.c b/fs/xfs/libxfs/xfs_refcount_btree.c
index 8d6c0fc..a151b4d 100644
--- a/fs/xfs/libxfs/xfs_refcount_btree.c
+++ b/fs/xfs/libxfs/xfs_refcount_btree.c
@@ -288,6 +288,7 @@ const struct xfs_buf_ops xfs_refcountbt_buf_ops = {
 	.name			= "xfs_refcountbt",
 	.verify_read		= xfs_refcountbt_read_verify,
 	.verify_write		= xfs_refcountbt_write_verify,
+	.verify_struct		= xfs_refcountbt_verify,
 };
 
 STATIC int
diff --git a/fs/xfs/libxfs/xfs_rmap_btree.c b/fs/xfs/libxfs/xfs_rmap_btree.c
index 4fd77e7..ec7b216 100644
--- a/fs/xfs/libxfs/xfs_rmap_btree.c
+++ b/fs/xfs/libxfs/xfs_rmap_btree.c
@@ -380,6 +380,7 @@ const struct xfs_buf_ops xfs_rmapbt_buf_ops = {
 	.name			= "xfs_rmapbt",
 	.verify_read		= xfs_rmapbt_read_verify,
 	.verify_write		= xfs_rmapbt_write_verify,
+	.verify_struct		= xfs_rmapbt_verify,
 };
 
 STATIC int
diff --git a/fs/xfs/libxfs/xfs_symlink_remote.c b/fs/xfs/libxfs/xfs_symlink_remote.c
index ef5e754..53732f4 100644
--- a/fs/xfs/libxfs/xfs_symlink_remote.c
+++ b/fs/xfs/libxfs/xfs_symlink_remote.c
@@ -173,6 +173,7 @@ const struct xfs_buf_ops xfs_symlink_buf_ops = {
 	.name = "xfs_symlink",
 	.verify_read = xfs_symlink_read_verify,
 	.verify_write = xfs_symlink_write_verify,
+	.verify_struct = xfs_symlink_verify,
 };
 
 void
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index 2072126..094e3e7 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -139,6 +139,7 @@ struct xfs_buf_ops {
 	char *name;
 	void (*verify_read)(struct xfs_buf *);
 	void (*verify_write)(struct xfs_buf *);
+	void *(*verify_struct)(struct xfs_buf *);
 };
 
 typedef struct xfs_buf {

