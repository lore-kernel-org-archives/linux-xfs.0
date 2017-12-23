Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:40174 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756968AbdLWBOH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 22 Dec 2017 20:14:07 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.21/8.16.0.21) with SMTP id vBN1CJcO079506
        for <linux-xfs@vger.kernel.org>; Sat, 23 Dec 2017 01:14:07 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp2120.oracle.com with ESMTP id 2f1cvd81sg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 23 Dec 2017 01:14:06 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id vBN18dtE012293
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Sat, 23 Dec 2017 01:08:39 GMT
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id vBN18dmC009657
        for <linux-xfs@vger.kernel.org>; Sat, 23 Dec 2017 01:08:39 GMT
Subject: [PATCH 15/20] xfs: create a new buf_ops pointer to verify structure
 metadata
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 22 Dec 2017 17:08:37 -0800
Message-ID: <151399131789.23543.12974482465966519677.stgit@magnolia>
In-Reply-To: <151399122361.23543.15718507168231759645.stgit@magnolia>
References: <151399122361.23543.15718507168231759645.stgit@magnolia>
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
 fs/xfs/libxfs/xfs_alloc.c          |   23 +++++++++++---
 fs/xfs/libxfs/xfs_alloc_btree.c    |    1 +
 fs/xfs/libxfs/xfs_attr_leaf.c      |    1 +
 fs/xfs/libxfs/xfs_attr_remote.c    |   58 +++++++++++++++++++++++++++---------
 fs/xfs/libxfs/xfs_bmap_btree.c     |    1 +
 fs/xfs/libxfs/xfs_da_btree.c       |   25 ++++++++++++++++
 fs/xfs/libxfs/xfs_dir2_block.c     |    1 +
 fs/xfs/libxfs/xfs_dir2_data.c      |    1 +
 fs/xfs/libxfs/xfs_dir2_leaf.c      |   16 ++++++++++
 fs/xfs/libxfs/xfs_dir2_node.c      |    1 +
 fs/xfs/libxfs/xfs_dquot_buf.c      |   12 +++++++
 fs/xfs/libxfs/xfs_ialloc.c         |    1 +
 fs/xfs/libxfs/xfs_ialloc_btree.c   |    1 +
 fs/xfs/libxfs/xfs_refcount_btree.c |    1 +
 fs/xfs/libxfs/xfs_rmap_btree.c     |    1 +
 fs/xfs/libxfs/xfs_symlink_remote.c |    1 +
 fs/xfs/xfs_buf.h                   |    1 +
 17 files changed, 125 insertions(+), 21 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index e1ef1b2..6883a76 100644
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
@@ -605,6 +614,7 @@ const struct xfs_buf_ops xfs_agfl_buf_ops = {
 	.name = "xfs_agfl",
 	.verify_read = xfs_agfl_read_verify,
 	.verify_write = xfs_agfl_write_verify,
+	.verify_struct = xfs_agfl_verify,
 };
 
 /*
@@ -2402,10 +2412,10 @@ xfs_alloc_put_freelist(
 
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
@@ -2467,7 +2477,7 @@ xfs_agf_read_verify(
 	    !xfs_buf_verify_cksum(bp, XFS_AGF_CRC_OFF))
 		xfs_verifier_error(bp, -EFSBADCRC, __this_address);
 	else {
-		fa = xfs_agf_verify(mp, bp);
+		fa = xfs_agf_verify(bp);
 		if (XFS_TEST_ERROR(fa, mp, XFS_ERRTAG_ALLOC_READ_AGF))
 			xfs_verifier_error(bp, -EFSCORRUPTED, fa);
 	}
@@ -2481,7 +2491,7 @@ xfs_agf_write_verify(
 	struct xfs_buf_log_item	*bip = bp->b_fspriv;
 	xfs_failaddr_t		fa;
 
-	fa = xfs_agf_verify(mp, bp);
+	fa = xfs_agf_verify(bp);
 	if (fa) {
 		xfs_verifier_error(bp, -EFSCORRUPTED, fa);
 		return;
@@ -2500,6 +2510,7 @@ const struct xfs_buf_ops xfs_agf_buf_ops = {
 	.name = "xfs_agf",
 	.verify_read = xfs_agf_read_verify,
 	.verify_write = xfs_agf_write_verify,
+	.verify_struct = xfs_agf_verify,
 };
 
 /*
diff --git a/fs/xfs/libxfs/xfs_alloc_btree.c b/fs/xfs/libxfs/xfs_alloc_btree.c
index 060d6fa..6840b58 100644
--- a/fs/xfs/libxfs/xfs_alloc_btree.c
+++ b/fs/xfs/libxfs/xfs_alloc_btree.c
@@ -400,6 +400,7 @@ const struct xfs_buf_ops xfs_allocbt_buf_ops = {
 	.name = "xfs_allocbt",
 	.verify_read = xfs_allocbt_read_verify,
 	.verify_write = xfs_allocbt_write_verify,
+	.verify_struct = xfs_allocbt_verify,
 };
 
 
diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index 7168827..6fddce7 100644
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
index 55514b3..21be186 100644
--- a/fs/xfs/libxfs/xfs_attr_remote.c
+++ b/fs/xfs/libxfs/xfs_attr_remote.c
@@ -116,20 +116,21 @@ xfs_attr3_rmt_verify(
 	return NULL;
 }
 
-static void
-xfs_attr3_rmt_read_verify(
-	struct xfs_buf	*bp)
+static int
+__xfs_attr3_rmt_read_verify(
+	struct xfs_buf	*bp,
+	bool		check_crc,
+	xfs_failaddr_t	*failaddr)
 {
 	struct xfs_mount *mp = bp->b_target->bt_mount;
 	char		*ptr;
-	xfs_failaddr_t	fa;
 	int		len;
 	xfs_daddr_t	bno;
 	int		blksize = mp->m_attr_geo->blksize;
 
 	/* no verification of non-crc buffers */
 	if (!xfs_sb_version_hascrc(&mp->m_sb))
-		return;
+		return 0;
 
 	ptr = bp->b_addr;
 	bno = bp->b_bn;
@@ -137,22 +138,48 @@ xfs_attr3_rmt_read_verify(
 	ASSERT(len >= blksize);
 
 	while (len > 0) {
-		if (!xfs_verify_cksum(ptr, blksize, XFS_ATTR3_RMT_CRC_OFF)) {
-			xfs_verifier_error(bp, -EFSBADCRC, __this_address);
-			return;
-		}
-		fa = xfs_attr3_rmt_verify(mp, ptr, blksize, bno);
-		if (fa) {
-			xfs_verifier_error(bp, -EFSCORRUPTED, fa);
-			break;
+		if (check_crc &&
+		    !xfs_verify_cksum(ptr, blksize, XFS_ATTR3_RMT_CRC_OFF)) {
+			*failaddr = __this_address;
+			return -EFSBADCRC;
 		}
+		*failaddr = xfs_attr3_rmt_verify(mp, ptr, blksize, bno);
+		if (*failaddr)
+			return -EFSCORRUPTED;
 		len -= blksize;
 		ptr += blksize;
 		bno += BTOBB(blksize);
 	}
 
-	if (len != 0)
-		xfs_verifier_error(bp, -EFSCORRUPTED, __this_address);
+	if (len != 0) {
+		*failaddr = __this_address;
+		return -EFSCORRUPTED;
+	}
+
+	return 0;
+}
+
+static void
+xfs_attr3_rmt_read_verify(
+	struct xfs_buf	*bp)
+{
+	xfs_failaddr_t	fa;
+	int		error;
+
+	error = __xfs_attr3_rmt_read_verify(bp, true, &fa);
+	if (error)
+		xfs_verifier_error(bp, error, fa);
+}
+
+static xfs_failaddr_t
+xfs_attr3_rmt_verify_struct(
+	struct xfs_buf	*bp)
+{
+	xfs_failaddr_t	fa;
+	int		error;
+
+	error = __xfs_attr3_rmt_read_verify(bp, false, &fa);
+	return error ? fa : NULL;
 }
 
 static void
@@ -207,6 +234,7 @@ const struct xfs_buf_ops xfs_attr3_rmt_buf_ops = {
 	.name = "xfs_attr3_rmt",
 	.verify_read = xfs_attr3_rmt_read_verify,
 	.verify_write = xfs_attr3_rmt_write_verify,
+	.verify_struct = xfs_attr3_rmt_verify_struct,
 };
 
 STATIC int
diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
index 64ae0ee..9faf479 100644
--- a/fs/xfs/libxfs/xfs_bmap_btree.c
+++ b/fs/xfs/libxfs/xfs_bmap_btree.c
@@ -501,6 +501,7 @@ const struct xfs_buf_ops xfs_bmbt_buf_ops = {
 	.name = "xfs_bmbt",
 	.verify_read = xfs_bmbt_read_verify,
 	.verify_write = xfs_bmbt_write_verify,
+	.verify_struct = xfs_bmbt_verify,
 };
 
 
diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
index 0ae3961..cf07585 100644
--- a/fs/xfs/libxfs/xfs_da_btree.c
+++ b/fs/xfs/libxfs/xfs_da_btree.c
@@ -243,10 +243,35 @@ xfs_da3_node_read_verify(
 	}
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
index cfd2777..fe951fa 100644
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
index 2fa7c34..3237812 100644
--- a/fs/xfs/libxfs/xfs_dir2_data.c
+++ b/fs/xfs/libxfs/xfs_dir2_data.c
@@ -334,6 +334,7 @@ const struct xfs_buf_ops xfs_dir3_data_buf_ops = {
 	.name = "xfs_dir3_data",
 	.verify_read = xfs_dir3_data_read_verify,
 	.verify_write = xfs_dir3_data_write_verify,
+	.verify_struct = xfs_dir3_data_verify,
 };
 
 static const struct xfs_buf_ops xfs_dir3_data_reada_buf_ops = {
diff --git a/fs/xfs/libxfs/xfs_dir2_leaf.c b/fs/xfs/libxfs/xfs_dir2_leaf.c
index a03d679..a7ad649 100644
--- a/fs/xfs/libxfs/xfs_dir2_leaf.c
+++ b/fs/xfs/libxfs/xfs_dir2_leaf.c
@@ -227,6 +227,13 @@ __write_verify(
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
@@ -241,6 +248,13 @@ xfs_dir3_leaf1_write_verify(
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
@@ -259,12 +273,14 @@ const struct xfs_buf_ops xfs_dir3_leaf1_buf_ops = {
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
index 3bdbe189..915c4fe 100644
--- a/fs/xfs/libxfs/xfs_dir2_node.c
+++ b/fs/xfs/libxfs/xfs_dir2_node.c
@@ -164,6 +164,7 @@ const struct xfs_buf_ops xfs_dir3_free_buf_ops = {
 	.name = "xfs_dir3_free",
 	.verify_read = xfs_dir3_free_read_verify,
 	.verify_write = xfs_dir3_free_write_verify,
+	.verify_struct = xfs_dir3_free_verify,
 };
 
 /* Everything ok in the free block header? */
diff --git a/fs/xfs/libxfs/xfs_dquot_buf.c b/fs/xfs/libxfs/xfs_dquot_buf.c
index 5e022c1..f8b62fc 100644
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
@@ -294,6 +305,7 @@ const struct xfs_buf_ops xfs_dquot_buf_ops = {
 	.name = "xfs_dquot",
 	.verify_read = xfs_dquot_buf_read_verify,
 	.verify_write = xfs_dquot_buf_write_verify,
+	.verify_struct = xfs_dquot_buf_verify_struct,
 };
 
 const struct xfs_buf_ops xfs_dquot_buf_ra_ops = {
diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index 3ded1f3..a46f2e1 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -2579,6 +2579,7 @@ const struct xfs_buf_ops xfs_agi_buf_ops = {
 	.name = "xfs_agi",
 	.verify_read = xfs_agi_read_verify,
 	.verify_write = xfs_agi_write_verify,
+	.verify_struct = xfs_agi_verify,
 };
 
 /*
diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.c b/fs/xfs/libxfs/xfs_ialloc_btree.c
index 9c691ad..47f44d6 100644
--- a/fs/xfs/libxfs/xfs_ialloc_btree.c
+++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
@@ -329,6 +329,7 @@ const struct xfs_buf_ops xfs_inobt_buf_ops = {
 	.name = "xfs_inobt",
 	.verify_read = xfs_inobt_read_verify,
 	.verify_write = xfs_inobt_write_verify,
+	.verify_struct = xfs_inobt_verify,
 };
 
 STATIC int
diff --git a/fs/xfs/libxfs/xfs_refcount_btree.c b/fs/xfs/libxfs/xfs_refcount_btree.c
index 715c272..8479769 100644
--- a/fs/xfs/libxfs/xfs_refcount_btree.c
+++ b/fs/xfs/libxfs/xfs_refcount_btree.c
@@ -290,6 +290,7 @@ const struct xfs_buf_ops xfs_refcountbt_buf_ops = {
 	.name			= "xfs_refcountbt",
 	.verify_read		= xfs_refcountbt_read_verify,
 	.verify_write		= xfs_refcountbt_write_verify,
+	.verify_struct		= xfs_refcountbt_verify,
 };
 
 STATIC int
diff --git a/fs/xfs/libxfs/xfs_rmap_btree.c b/fs/xfs/libxfs/xfs_rmap_btree.c
index d089a48..e829c3e 100644
--- a/fs/xfs/libxfs/xfs_rmap_btree.c
+++ b/fs/xfs/libxfs/xfs_rmap_btree.c
@@ -382,6 +382,7 @@ const struct xfs_buf_ops xfs_rmapbt_buf_ops = {
 	.name			= "xfs_rmapbt",
 	.verify_read		= xfs_rmapbt_read_verify,
 	.verify_write		= xfs_rmapbt_write_verify,
+	.verify_struct		= xfs_rmapbt_verify,
 };
 
 STATIC int
diff --git a/fs/xfs/libxfs/xfs_symlink_remote.c b/fs/xfs/libxfs/xfs_symlink_remote.c
index adf2d78..091e3cf 100644
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
index 6f907a3..5b5b486 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -140,6 +140,7 @@ struct xfs_buf_ops {
 	char *name;
 	void (*verify_read)(struct xfs_buf *);
 	void (*verify_write)(struct xfs_buf *);
+	xfs_failaddr_t (*verify_struct)(struct xfs_buf *bp);
 };
 
 typedef struct xfs_buf {

