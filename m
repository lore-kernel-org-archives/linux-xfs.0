Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:40952 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750886AbdLMX7q (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 13 Dec 2017 18:59:46 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.21/8.16.0.21) with SMTP id vBDNl9nt024433
        for <linux-xfs@vger.kernel.org>; Wed, 13 Dec 2017 23:59:45 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp2120.oracle.com with ESMTP id 2eudq605u3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 13 Dec 2017 23:59:45 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id vBDNxTMD003702
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 13 Dec 2017 23:59:29 GMT
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id vBDNxTPt012155
        for <linux-xfs@vger.kernel.org>; Wed, 13 Dec 2017 23:59:29 GMT
Subject: [PATCH 12/13] xfs: create a new buf_ops pointer to verify structure
 metadata
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 13 Dec 2017 15:59:25 -0800
Message-ID: <151320956591.30654.3796756077270484760.stgit@magnolia>
In-Reply-To: <151320949282.30654.14805160700975182459.stgit@magnolia>
References: <151320949282.30654.14805160700975182459.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Expose all metadata structure buffer verifier functions via buf_ops.
These will be used by the online scrub mechanism to look for problems
with buffers that are already sitting around in memory.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_alloc.c          |   23 +++++++++++++++++------
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
 17 files changed, 114 insertions(+), 6 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index d600dcb..ae3e33d 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -528,6 +528,15 @@ xfs_agfl_verify(
 	struct xfs_agfl	*agfl = XFS_BUF_TO_AGFL(bp);
 	int		i;
 
+	/*
+	 * There is no verification of non-crc AGFLs because mkfs does not
+	 * initialise the AGFL to zero or NULL. Hence the only valid part of the
+	 * AGFL is what the AGF says is active. We can't get to the AGF, so we
+	 * can't verify just those entries are valid.
+	 */
+	if (!xfs_sb_version_hascrc(&mp->m_sb))
+		return NULL;
+
 	if (!uuid_equal(&agfl->agfl_uuid, &mp->m_sb.sb_meta_uuid))
 		return __this_address;
 	if (be32_to_cpu(agfl->agfl_magicnum) != XFS_AGFL_MAGIC)
@@ -606,6 +615,7 @@ const struct xfs_buf_ops xfs_agfl_buf_ops = {
 	.name = "xfs_agfl",
 	.verify_read = xfs_agfl_read_verify,
 	.verify_write = xfs_agfl_write_verify,
+	.verify_struct = xfs_agfl_verify,
 };
 
 /*
@@ -2403,10 +2413,10 @@ xfs_alloc_put_freelist(
 
 static xfs_failaddr_t
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
@@ -2468,7 +2478,7 @@ xfs_agf_read_verify(
 	    !xfs_buf_verify_cksum(bp, XFS_AGF_CRC_OFF)) {
 		fa = __this_address;
 		xfs_buf_ioerror(bp, -EFSBADCRC);
-	} else if (XFS_TEST_ERROR((fa = xfs_agf_verify(mp, bp)), mp,
+	} else if (XFS_TEST_ERROR((fa = xfs_agf_verify(bp)), mp,
 				  XFS_ERRTAG_ALLOC_READ_AGF))
 		xfs_buf_ioerror(bp, -EFSCORRUPTED);
 
@@ -2484,7 +2494,7 @@ xfs_agf_write_verify(
 	struct xfs_buf_log_item	*bip = bp->b_fspriv;
 	xfs_failaddr_t		fa;
 
-	if ((fa = xfs_agf_verify(mp, bp))) {
+	if ((fa = xfs_agf_verify(bp))) {
 		xfs_buf_ioerror(bp, -EFSCORRUPTED);
 		xfs_verifier_error(bp, fa);
 		return;
@@ -2503,6 +2513,7 @@ const struct xfs_buf_ops xfs_agf_buf_ops = {
 	.name = "xfs_agf",
 	.verify_read = xfs_agf_read_verify,
 	.verify_write = xfs_agf_write_verify,
+	.verify_struct = xfs_agf_verify,
 };
 
 /*
diff --git a/fs/xfs/libxfs/xfs_alloc_btree.c b/fs/xfs/libxfs/xfs_alloc_btree.c
index a646fc4..7d116e8 100644
--- a/fs/xfs/libxfs/xfs_alloc_btree.c
+++ b/fs/xfs/libxfs/xfs_alloc_btree.c
@@ -398,6 +398,7 @@ const struct xfs_buf_ops xfs_allocbt_buf_ops = {
 	.name = "xfs_allocbt",
 	.verify_read = xfs_allocbt_read_verify,
 	.verify_write = xfs_allocbt_write_verify,
+	.verify_struct = xfs_allocbt_verify,
 };
 
 
diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index e130952..ebfa477 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -340,6 +340,7 @@ const struct xfs_buf_ops xfs_attr3_leaf_buf_ops = {
 	.name = "xfs_attr3_leaf",
 	.verify_read = xfs_attr3_leaf_read_verify,
 	.verify_write = xfs_attr3_leaf_write_verify,
+	.verify_struct = xfs_attr3_leaf_verify,
 };
 
 int
diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
index d4d2902..1be995b 100644
--- a/fs/xfs/libxfs/xfs_attr_remote.c
+++ b/fs/xfs/libxfs/xfs_attr_remote.c
@@ -204,10 +204,42 @@ xfs_attr3_rmt_write_verify(
 	ASSERT(len == 0);
 }
 
+static xfs_failaddr_t
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
index c1ddb4c..1adfc52 100644
--- a/fs/xfs/libxfs/xfs_bmap_btree.c
+++ b/fs/xfs/libxfs/xfs_bmap_btree.c
@@ -501,6 +501,7 @@ const struct xfs_buf_ops xfs_bmbt_buf_ops = {
 	.name = "xfs_bmbt",
 	.verify_read = xfs_bmbt_read_verify,
 	.verify_write = xfs_bmbt_write_verify,
+	.verify_struct = xfs_bmbt_verify,
 };
 
 
diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
index 6d6a9ef..62697bc 100644
--- a/fs/xfs/libxfs/xfs_da_btree.c
+++ b/fs/xfs/libxfs/xfs_da_btree.c
@@ -248,10 +248,35 @@ xfs_da3_node_read_verify(
 	xfs_verifier_error(bp, fa);
 }
 
+/* Verify the structure of a da3 block. */
+static xfs_failaddr_t
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
index 7a18777..5e2bade 100644
--- a/fs/xfs/libxfs/xfs_dir2_block.c
+++ b/fs/xfs/libxfs/xfs_dir2_block.c
@@ -127,6 +127,7 @@ const struct xfs_buf_ops xfs_dir3_block_buf_ops = {
 	.name = "xfs_dir3_block",
 	.verify_read = xfs_dir3_block_read_verify,
 	.verify_write = xfs_dir3_block_write_verify,
+	.verify_struct = xfs_dir3_block_verify,
 };
 
 int
diff --git a/fs/xfs/libxfs/xfs_dir2_data.c b/fs/xfs/libxfs/xfs_dir2_data.c
index f31bfd9..b65f915 100644
--- a/fs/xfs/libxfs/xfs_dir2_data.c
+++ b/fs/xfs/libxfs/xfs_dir2_data.c
@@ -319,6 +319,7 @@ const struct xfs_buf_ops xfs_dir3_data_buf_ops = {
 	.name = "xfs_dir3_data",
 	.verify_read = xfs_dir3_data_read_verify,
 	.verify_write = xfs_dir3_data_write_verify,
+	.verify_struct = xfs_dir3_data_verify,
 };
 
 static const struct xfs_buf_ops xfs_dir3_data_reada_buf_ops = {
diff --git a/fs/xfs/libxfs/xfs_dir2_leaf.c b/fs/xfs/libxfs/xfs_dir2_leaf.c
index e3fad8d..75bf3b2b 100644
--- a/fs/xfs/libxfs/xfs_dir2_leaf.c
+++ b/fs/xfs/libxfs/xfs_dir2_leaf.c
@@ -219,6 +219,13 @@ __write_verify(
 	xfs_buf_update_cksum(bp, XFS_DIR3_LEAF_CRC_OFF);
 }
 
+static xfs_failaddr_t
+xfs_dir3_leaf1_verify(
+	struct xfs_buf	*bp)
+{
+	return xfs_dir3_leaf_verify(bp, XFS_DIR2_LEAF1_MAGIC);
+}
+
 static void
 xfs_dir3_leaf1_read_verify(
 	struct xfs_buf	*bp)
@@ -233,6 +240,13 @@ xfs_dir3_leaf1_write_verify(
 	__write_verify(bp, XFS_DIR2_LEAF1_MAGIC);
 }
 
+static xfs_failaddr_t
+xfs_dir3_leafn_verify(
+	struct xfs_buf	*bp)
+{
+	return xfs_dir3_leaf_verify(bp, XFS_DIR2_LEAFN_MAGIC);
+}
+
 static void
 xfs_dir3_leafn_read_verify(
 	struct xfs_buf	*bp)
@@ -251,12 +265,14 @@ const struct xfs_buf_ops xfs_dir3_leaf1_buf_ops = {
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
index 8a6a2e1..22acf79 100644
--- a/fs/xfs/libxfs/xfs_dir2_node.c
+++ b/fs/xfs/libxfs/xfs_dir2_node.c
@@ -156,6 +156,7 @@ const struct xfs_buf_ops xfs_dir3_free_buf_ops = {
 	.name = "xfs_dir3_free",
 	.verify_read = xfs_dir3_free_read_verify,
 	.verify_write = xfs_dir3_free_write_verify,
+	.verify_struct = xfs_dir3_free_verify,
 };
 
 /* Everything ok in the free block header? */
diff --git a/fs/xfs/libxfs/xfs_dquot_buf.c b/fs/xfs/libxfs/xfs_dquot_buf.c
index 5561011..74d377c 100644
--- a/fs/xfs/libxfs/xfs_dquot_buf.c
+++ b/fs/xfs/libxfs/xfs_dquot_buf.c
@@ -242,6 +242,17 @@ xfs_dquot_buf_verify(
 	return true;
 }
 
+static xfs_failaddr_t
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
index a616212..d9c93b6 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -2585,6 +2585,7 @@ const struct xfs_buf_ops xfs_agi_buf_ops = {
 	.name = "xfs_agi",
 	.verify_read = xfs_agi_read_verify,
 	.verify_write = xfs_agi_write_verify,
+	.verify_struct = xfs_agi_verify,
 };
 
 /*
diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.c b/fs/xfs/libxfs/xfs_ialloc_btree.c
index 032613a..e5aee4b 100644
--- a/fs/xfs/libxfs/xfs_ialloc_btree.c
+++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
@@ -328,6 +328,7 @@ const struct xfs_buf_ops xfs_inobt_buf_ops = {
 	.name = "xfs_inobt",
 	.verify_read = xfs_inobt_read_verify,
 	.verify_write = xfs_inobt_write_verify,
+	.verify_struct = xfs_inobt_verify,
 };
 
 STATIC int
diff --git a/fs/xfs/libxfs/xfs_refcount_btree.c b/fs/xfs/libxfs/xfs_refcount_btree.c
index 68d4021..d754af2 100644
--- a/fs/xfs/libxfs/xfs_refcount_btree.c
+++ b/fs/xfs/libxfs/xfs_refcount_btree.c
@@ -289,6 +289,7 @@ const struct xfs_buf_ops xfs_refcountbt_buf_ops = {
 	.name			= "xfs_refcountbt",
 	.verify_read		= xfs_refcountbt_read_verify,
 	.verify_write		= xfs_refcountbt_write_verify,
+	.verify_struct		= xfs_refcountbt_verify,
 };
 
 STATIC int
diff --git a/fs/xfs/libxfs/xfs_rmap_btree.c b/fs/xfs/libxfs/xfs_rmap_btree.c
index ab358b9..e568cfb 100644
--- a/fs/xfs/libxfs/xfs_rmap_btree.c
+++ b/fs/xfs/libxfs/xfs_rmap_btree.c
@@ -381,6 +381,7 @@ const struct xfs_buf_ops xfs_rmapbt_buf_ops = {
 	.name			= "xfs_rmapbt",
 	.verify_read		= xfs_rmapbt_read_verify,
 	.verify_write		= xfs_rmapbt_write_verify,
+	.verify_struct		= xfs_rmapbt_verify,
 };
 
 STATIC int
diff --git a/fs/xfs/libxfs/xfs_symlink_remote.c b/fs/xfs/libxfs/xfs_symlink_remote.c
index 5d9642e..04eae02 100644
--- a/fs/xfs/libxfs/xfs_symlink_remote.c
+++ b/fs/xfs/libxfs/xfs_symlink_remote.c
@@ -174,6 +174,7 @@ const struct xfs_buf_ops xfs_symlink_buf_ops = {
 	.name = "xfs_symlink",
 	.verify_read = xfs_symlink_read_verify,
 	.verify_write = xfs_symlink_write_verify,
+	.verify_struct = xfs_symlink_verify,
 };
 
 void
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index f873bb7..c2fe894 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -140,6 +140,7 @@ struct xfs_buf_ops {
 	char *name;
 	void (*verify_read)(struct xfs_buf *);
 	void (*verify_write)(struct xfs_buf *);
+	xfs_failaddr_t (*verify_struct)(struct xfs_buf *bp);
 };
 
 typedef struct xfs_buf {

