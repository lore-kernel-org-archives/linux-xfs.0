Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:52410 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732619AbfBRRVo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 Feb 2019 12:21:44 -0500
Date: Mon, 18 Feb 2019 09:21:37 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] xfs: fix xfs_buf magic number endian checks
Message-ID: <20190218172137.GA32253@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: xfs <linux-xfs@vger.kernel.org>
Cc: Brian Foster <bfoster@redhat.com>

From: Darrick J. Wong <darrick.wong@oracle.com>

Create a separate magic16 check function so that we don't run afoul of
static checkers.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_attr_leaf.c |    4 ++--
 fs/xfs/libxfs/xfs_da_btree.c  |    8 ++++----
 fs/xfs/libxfs/xfs_dir2_leaf.c |    8 ++++----
 fs/xfs/libxfs/xfs_dquot_buf.c |    8 ++++----
 fs/xfs/libxfs/xfs_inode_buf.c |   10 +++++-----
 fs/xfs/xfs_buf.c              |   20 +++++++++++++++++++-
 fs/xfs/xfs_buf.h              |    8 ++++++--
 fs/xfs/xfs_log_recover.c      |    2 +-
 8 files changed, 45 insertions(+), 23 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index 0c92987f57fc..1f6e3965ff74 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -358,8 +358,8 @@ xfs_attr3_leaf_read_verify(
 
 const struct xfs_buf_ops xfs_attr3_leaf_buf_ops = {
 	.name = "xfs_attr3_leaf",
-	.magic = { cpu_to_be16(XFS_ATTR_LEAF_MAGIC),
-		   cpu_to_be16(XFS_ATTR3_LEAF_MAGIC) },
+	.magic16 = { cpu_to_be16(XFS_ATTR_LEAF_MAGIC),
+		     cpu_to_be16(XFS_ATTR3_LEAF_MAGIC) },
 	.verify_read = xfs_attr3_leaf_read_verify,
 	.verify_write = xfs_attr3_leaf_write_verify,
 	.verify_struct = xfs_attr3_leaf_verify,
diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
index eb2cee428f26..e2737e2ac2ae 100644
--- a/fs/xfs/libxfs/xfs_da_btree.c
+++ b/fs/xfs/libxfs/xfs_da_btree.c
@@ -129,7 +129,7 @@ xfs_da3_blkinfo_verify(
 	struct xfs_mount	*mp = bp->b_target->bt_mount;
 	struct xfs_da_blkinfo	*hdr = &hdr3->hdr;
 
-	if (!xfs_verify_magic(bp, hdr->magic))
+	if (!xfs_verify_magic16(bp, hdr->magic))
 		return __this_address;
 
 	if (xfs_sb_version_hascrc(&mp->m_sb)) {
@@ -141,7 +141,7 @@ xfs_da3_blkinfo_verify(
 			return __this_address;
 	}
 
-	return 0;
+	return NULL;
 }
 
 static xfs_failaddr_t
@@ -274,8 +274,8 @@ xfs_da3_node_verify_struct(
 
 const struct xfs_buf_ops xfs_da3_node_buf_ops = {
 	.name = "xfs_da3_node",
-	.magic = { cpu_to_be16(XFS_DA_NODE_MAGIC),
-		   cpu_to_be16(XFS_DA3_NODE_MAGIC) },
+	.magic16 = { cpu_to_be16(XFS_DA_NODE_MAGIC),
+		     cpu_to_be16(XFS_DA3_NODE_MAGIC) },
 	.verify_read = xfs_da3_node_read_verify,
 	.verify_write = xfs_da3_node_write_verify,
 	.verify_struct = xfs_da3_node_verify_struct,
diff --git a/fs/xfs/libxfs/xfs_dir2_leaf.c b/fs/xfs/libxfs/xfs_dir2_leaf.c
index 094028b7b162..9a3767818c50 100644
--- a/fs/xfs/libxfs/xfs_dir2_leaf.c
+++ b/fs/xfs/libxfs/xfs_dir2_leaf.c
@@ -198,8 +198,8 @@ xfs_dir3_leaf_write_verify(
 
 const struct xfs_buf_ops xfs_dir3_leaf1_buf_ops = {
 	.name = "xfs_dir3_leaf1",
-	.magic = { cpu_to_be16(XFS_DIR2_LEAF1_MAGIC),
-		   cpu_to_be16(XFS_DIR3_LEAF1_MAGIC) },
+	.magic16 = { cpu_to_be16(XFS_DIR2_LEAF1_MAGIC),
+		     cpu_to_be16(XFS_DIR3_LEAF1_MAGIC) },
 	.verify_read = xfs_dir3_leaf_read_verify,
 	.verify_write = xfs_dir3_leaf_write_verify,
 	.verify_struct = xfs_dir3_leaf_verify,
@@ -207,8 +207,8 @@ const struct xfs_buf_ops xfs_dir3_leaf1_buf_ops = {
 
 const struct xfs_buf_ops xfs_dir3_leafn_buf_ops = {
 	.name = "xfs_dir3_leafn",
-	.magic = { cpu_to_be16(XFS_DIR2_LEAFN_MAGIC),
-		   cpu_to_be16(XFS_DIR3_LEAFN_MAGIC) },
+	.magic16 = { cpu_to_be16(XFS_DIR2_LEAFN_MAGIC),
+		     cpu_to_be16(XFS_DIR3_LEAFN_MAGIC) },
 	.verify_read = xfs_dir3_leaf_read_verify,
 	.verify_write = xfs_dir3_leaf_write_verify,
 	.verify_struct = xfs_dir3_leaf_verify,
diff --git a/fs/xfs/libxfs/xfs_dquot_buf.c b/fs/xfs/libxfs/xfs_dquot_buf.c
index b956638a3532..fb5bd9a804f6 100644
--- a/fs/xfs/libxfs/xfs_dquot_buf.c
+++ b/fs/xfs/libxfs/xfs_dquot_buf.c
@@ -277,8 +277,8 @@ xfs_dquot_buf_write_verify(
 
 const struct xfs_buf_ops xfs_dquot_buf_ops = {
 	.name = "xfs_dquot",
-	.magic = { cpu_to_be16(XFS_DQUOT_MAGIC),
-		   cpu_to_be16(XFS_DQUOT_MAGIC) },
+	.magic16 = { cpu_to_be16(XFS_DQUOT_MAGIC),
+		     cpu_to_be16(XFS_DQUOT_MAGIC) },
 	.verify_read = xfs_dquot_buf_read_verify,
 	.verify_write = xfs_dquot_buf_write_verify,
 	.verify_struct = xfs_dquot_buf_verify_struct,
@@ -286,8 +286,8 @@ const struct xfs_buf_ops xfs_dquot_buf_ops = {
 
 const struct xfs_buf_ops xfs_dquot_buf_ra_ops = {
 	.name = "xfs_dquot_ra",
-	.magic = { cpu_to_be16(XFS_DQUOT_MAGIC),
-		   cpu_to_be16(XFS_DQUOT_MAGIC) },
+	.magic16 = { cpu_to_be16(XFS_DQUOT_MAGIC),
+		     cpu_to_be16(XFS_DQUOT_MAGIC) },
 	.verify_read = xfs_dquot_buf_readahead_verify,
 	.verify_write = xfs_dquot_buf_write_verify,
 };
diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index f92f14e93ad3..e021d5133ccb 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -97,7 +97,7 @@ xfs_inode_buf_verify(
 
 		dip = xfs_buf_offset(bp, (i << mp->m_sb.sb_inodelog));
 		unlinked_ino = be32_to_cpu(dip->di_next_unlinked);
-		di_ok = xfs_verify_magic(bp, dip->di_magic) &&
+		di_ok = xfs_verify_magic16(bp, dip->di_magic) &&
 			xfs_dinode_good_version(mp, dip->di_version) &&
 			xfs_verify_agino_or_null(mp, agno, unlinked_ino);
 		if (unlikely(XFS_TEST_ERROR(!di_ok, mp,
@@ -146,16 +146,16 @@ xfs_inode_buf_write_verify(
 
 const struct xfs_buf_ops xfs_inode_buf_ops = {
 	.name = "xfs_inode",
-	.magic = { cpu_to_be16(XFS_DINODE_MAGIC),
-		   cpu_to_be16(XFS_DINODE_MAGIC) },
+	.magic16 = { cpu_to_be16(XFS_DINODE_MAGIC),
+		     cpu_to_be16(XFS_DINODE_MAGIC) },
 	.verify_read = xfs_inode_buf_read_verify,
 	.verify_write = xfs_inode_buf_write_verify,
 };
 
 const struct xfs_buf_ops xfs_inode_buf_ra_ops = {
 	.name = "xfs_inode_ra",
-	.magic = { cpu_to_be16(XFS_DINODE_MAGIC),
-		   cpu_to_be16(XFS_DINODE_MAGIC) },
+	.magic16 = { cpu_to_be16(XFS_DINODE_MAGIC),
+		     cpu_to_be16(XFS_DINODE_MAGIC) },
 	.verify_read = xfs_inode_buf_readahead_verify,
 	.verify_write = xfs_inode_buf_write_verify,
 };
diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 52a382b8cbce..548344e25128 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -2213,7 +2213,7 @@ void xfs_buf_set_ref(struct xfs_buf *bp, int lru_ref)
 bool
 xfs_verify_magic(
 	struct xfs_buf		*bp,
-	uint32_t		dmagic)
+	__be32			dmagic)
 {
 	struct xfs_mount	*mp = bp->b_target->bt_mount;
 	int			idx;
@@ -2223,3 +2223,21 @@ xfs_verify_magic(
 		return false;
 	return dmagic == bp->b_ops->magic[idx];
 }
+/*
+ * Verify an on-disk magic value against the magic value specified in the
+ * verifier structure. The verifier magic is in disk byte order so the caller is
+ * expected to pass the value directly from disk.
+ */
+bool
+xfs_verify_magic16(
+	struct xfs_buf		*bp,
+	__be16			dmagic)
+{
+	struct xfs_mount	*mp = bp->b_target->bt_mount;
+	int			idx;
+
+	idx = xfs_sb_version_hascrc(&mp->m_sb);
+	if (unlikely(WARN_ON(!bp->b_ops || !bp->b_ops->magic16[idx])))
+		return false;
+	return dmagic == bp->b_ops->magic16[idx];
+}
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index 44f9423a1861..d0b96e071cec 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -125,7 +125,10 @@ struct xfs_buf_map {
 
 struct xfs_buf_ops {
 	char *name;
-	uint32_t magic[2];		/* v4 and v5 on disk magic values */
+	union {
+		__be32 magic[2];	/* v4 and v5 on disk magic values */
+		__be16 magic16[2];	/* v4 and v5 on disk magic values */
+	};
 	void (*verify_read)(struct xfs_buf *);
 	void (*verify_write)(struct xfs_buf *);
 	xfs_failaddr_t (*verify_struct)(struct xfs_buf *bp);
@@ -387,6 +390,7 @@ extern int xfs_setsize_buftarg(xfs_buftarg_t *, unsigned int);
 #define xfs_readonly_buftarg(buftarg)	bdev_read_only((buftarg)->bt_bdev)
 
 int xfs_buf_reverify(struct xfs_buf *bp, const struct xfs_buf_ops *ops);
-bool xfs_verify_magic(struct xfs_buf *bp, uint32_t dmagic);
+bool xfs_verify_magic(struct xfs_buf *bp, __be32 dmagic);
+bool xfs_verify_magic16(struct xfs_buf *bp, __be16 dmagic);
 
 #endif	/* __XFS_BUF_H__ */
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index f5948d16015b..3371d1ff27c4 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -3049,7 +3049,7 @@ xlog_recover_inode_pass2(
 	 * Make sure the place we're flushing out to really looks
 	 * like an inode!
 	 */
-	if (unlikely(!xfs_verify_magic(bp, dip->di_magic))) {
+	if (unlikely(!xfs_verify_magic16(bp, dip->di_magic))) {
 		xfs_alert(mp,
 	"%s: Bad inode magic number, dip = "PTR_FMT", dino bp = "PTR_FMT", ino = %Ld",
 			__func__, dip, bp, in_f->ilf_ino);
