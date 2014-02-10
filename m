Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C2E387F3F
	for <xfs@oss.sgi.com>; Sun,  9 Feb 2014 20:27:23 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 57EAEAC004
	for <xfs@oss.sgi.com>; Sun,  9 Feb 2014 18:27:23 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id yyY8L8wWysrCjBII for <xfs@oss.sgi.com>;
	Sun, 09 Feb 2014 18:27:21 -0800 (PST)
Message-ID: <52F83907.9070004@sandeen.net>
Date: Sun, 09 Feb 2014 20:27:19 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH 3/6] xfs: add helper for verifying checksums on xfs_bufs
References: <52F83630.4020008@redhat.com>
In-Reply-To: <52F83630.4020008@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>

Many/most callers of xfs_verify_cksum() pass bp->b_addr and
BBTOB(bp->b_length) as the first 2 args.  Add a helper
which can just accept the bp and the crc offset, and work
it out on its own, for brevity.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

I'm not wedded to this; seems helpful and cleaner, but
if there's a reason not to, *shrug*

 fs/xfs/xfs_alloc.c          |    7 +++----
 fs/xfs/xfs_attr_leaf.c      |    3 +--
 fs/xfs/xfs_btree.c          |    8 ++++----
 fs/xfs/xfs_cksum.h          |    7 +++++++
 fs/xfs/xfs_da_btree.c       |    3 +--
 fs/xfs/xfs_dir2_block.c     |    3 +--
 fs/xfs/xfs_dir2_data.c      |    3 +--
 fs/xfs/xfs_dir2_leaf.c      |    3 +--
 fs/xfs/xfs_dir2_node.c      |    3 +--
 fs/xfs/xfs_ialloc.c         |    4 ++--
 fs/xfs/xfs_symlink_remote.c |    2 +-
 11 files changed, 23 insertions(+), 23 deletions(-)

diff --git a/fs/xfs/xfs_alloc.c b/fs/xfs/xfs_alloc.c
index 9eab2df..ab33714 100644
--- a/fs/xfs/xfs_alloc.c
+++ b/fs/xfs/xfs_alloc.c
@@ -485,8 +485,7 @@ xfs_agfl_read_verify(
 	if (!xfs_sb_version_hascrc(&mp->m_sb))
 		return;
 
-	agfl_ok = xfs_verify_cksum(bp->b_addr, BBTOB(bp->b_length),
-				   offsetof(struct xfs_agfl, agfl_crc));
+	agfl_ok = xfs_buf_verify_cksum(bp, offsetof(struct xfs_agfl, agfl_crc));
 
 	agfl_ok = agfl_ok && xfs_agfl_verify(bp);
 
@@ -2241,8 +2240,8 @@ xfs_agf_read_verify(
 	int		agf_ok = 1;
 
 	if (xfs_sb_version_hascrc(&mp->m_sb))
-		agf_ok = xfs_verify_cksum(bp->b_addr, BBTOB(bp->b_length),
-					  offsetof(struct xfs_agf, agf_crc));
+		agf_ok = xfs_buf_verify_cksum(bp,
+					      offsetof(struct xfs_agf, agf_crc));
 
 	agf_ok = agf_ok && xfs_agf_verify(mp, bp);
 
diff --git a/fs/xfs/xfs_attr_leaf.c b/fs/xfs/xfs_attr_leaf.c
index 7b126f4..a19a023 100644
--- a/fs/xfs/xfs_attr_leaf.c
+++ b/fs/xfs/xfs_attr_leaf.c
@@ -240,8 +240,7 @@ xfs_attr3_leaf_read_verify(
 	struct xfs_mount	*mp = bp->b_target->bt_mount;
 
 	if ((xfs_sb_version_hascrc(&mp->m_sb) &&
-	     !xfs_verify_cksum(bp->b_addr, BBTOB(bp->b_length),
-					  XFS_ATTR3_LEAF_CRC_OFF)) ||
+	     !xfs_buf_verify_cksum(bp, XFS_ATTR3_LEAF_CRC_OFF)) ||
 	    !xfs_attr3_leaf_verify(bp)) {
 		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp, bp->b_addr);
 		xfs_buf_ioerror(bp, EFSCORRUPTED);
diff --git a/fs/xfs/xfs_btree.c b/fs/xfs/xfs_btree.c
index 9adaae4..4e8524d 100644
--- a/fs/xfs/xfs_btree.c
+++ b/fs/xfs/xfs_btree.c
@@ -243,8 +243,8 @@ xfs_btree_lblock_verify_crc(
 	struct xfs_buf		*bp)
 {
 	if (xfs_sb_version_hascrc(&bp->b_target->bt_mount->m_sb))
-		return xfs_verify_cksum(bp->b_addr, BBTOB(bp->b_length),
-					XFS_BTREE_LBLOCK_CRC_OFF);
+		return xfs_buf_verify_cksum(bp, XFS_BTREE_LBLOCK_CRC_OFF);
+
 	return true;
 }
 
@@ -276,8 +276,8 @@ xfs_btree_sblock_verify_crc(
 	struct xfs_buf		*bp)
 {
 	if (xfs_sb_version_hascrc(&bp->b_target->bt_mount->m_sb))
-		return xfs_verify_cksum(bp->b_addr, BBTOB(bp->b_length),
-					XFS_BTREE_SBLOCK_CRC_OFF);
+		return xfs_buf_verify_cksum(bp, XFS_BTREE_SBLOCK_CRC_OFF);
+
 	return true;
 }
 
diff --git a/fs/xfs/xfs_cksum.h b/fs/xfs/xfs_cksum.h
index fad1676..f605d64 100644
--- a/fs/xfs/xfs_cksum.h
+++ b/fs/xfs/xfs_cksum.h
@@ -60,4 +60,11 @@ xfs_verify_cksum(char *buffer, size_t length, unsigned long cksum_offset)
 	return *(__le32 *)(buffer + cksum_offset) == xfs_end_cksum(crc);
 }
 
+static inline int
+xfs_buf_verify_cksum(struct xfs_buf *bp, unsigned long cksum_offset)
+{
+	return xfs_verify_cksum(bp->b_addr, BBTOB(bp->b_length),
+				cksum_offset);
+}
+
 #endif /* _XFS_CKSUM_H */
diff --git a/fs/xfs/xfs_da_btree.c b/fs/xfs/xfs_da_btree.c
index 796272a..6cece55 100644
--- a/fs/xfs/xfs_da_btree.c
+++ b/fs/xfs/xfs_da_btree.c
@@ -214,8 +214,7 @@ xfs_da3_node_read_verify(
 
 	switch (be16_to_cpu(info->magic)) {
 		case XFS_DA3_NODE_MAGIC:
-			if (!xfs_verify_cksum(bp->b_addr, BBTOB(bp->b_length),
-					      XFS_DA3_NODE_CRC_OFF))
+			if (!xfs_buf_verify_cksum(bp, XFS_DA3_NODE_CRC_OFF))
 				break;
 			/* fall through */
 		case XFS_DA_NODE_MAGIC:
diff --git a/fs/xfs/xfs_dir2_block.c b/fs/xfs/xfs_dir2_block.c
index 90cdbf4..948dc39 100644
--- a/fs/xfs/xfs_dir2_block.c
+++ b/fs/xfs/xfs_dir2_block.c
@@ -90,8 +90,7 @@ xfs_dir3_block_read_verify(
 	struct xfs_mount	*mp = bp->b_target->bt_mount;
 
 	if ((xfs_sb_version_hascrc(&mp->m_sb) &&
-	     !xfs_verify_cksum(bp->b_addr, BBTOB(bp->b_length),
-					  XFS_DIR3_DATA_CRC_OFF)) ||
+	     !xfs_buf_verify_cksum(bp, XFS_DIR3_DATA_CRC_OFF)) ||
 	    !xfs_dir3_block_verify(bp)) {
 		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp, bp->b_addr);
 		xfs_buf_ioerror(bp, EFSCORRUPTED);
diff --git a/fs/xfs/xfs_dir2_data.c b/fs/xfs/xfs_dir2_data.c
index 70acff4..1952f00 100644
--- a/fs/xfs/xfs_dir2_data.c
+++ b/fs/xfs/xfs_dir2_data.c
@@ -268,8 +268,7 @@ xfs_dir3_data_read_verify(
 	struct xfs_mount	*mp = bp->b_target->bt_mount;
 
 	if ((xfs_sb_version_hascrc(&mp->m_sb) &&
-	     !xfs_verify_cksum(bp->b_addr, BBTOB(bp->b_length),
-					  XFS_DIR3_DATA_CRC_OFF)) ||
+	     !xfs_buf_verify_cksum(bp, XFS_DIR3_DATA_CRC_OFF)) ||
 	    !xfs_dir3_data_verify(bp)) {
 		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp, bp->b_addr);
 		xfs_buf_ioerror(bp, EFSCORRUPTED);
diff --git a/fs/xfs/xfs_dir2_leaf.c b/fs/xfs/xfs_dir2_leaf.c
index ae47ec6..1a412eb 100644
--- a/fs/xfs/xfs_dir2_leaf.c
+++ b/fs/xfs/xfs_dir2_leaf.c
@@ -180,8 +180,7 @@ __read_verify(
 	struct xfs_mount	*mp = bp->b_target->bt_mount;
 
 	if ((xfs_sb_version_hascrc(&mp->m_sb) &&
-	     !xfs_verify_cksum(bp->b_addr, BBTOB(bp->b_length),
-					  XFS_DIR3_LEAF_CRC_OFF)) ||
+	     !xfs_buf_verify_cksum(bp, XFS_DIR3_LEAF_CRC_OFF)) ||
 	    !xfs_dir3_leaf_verify(bp, magic)) {
 		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp, bp->b_addr);
 		xfs_buf_ioerror(bp, EFSCORRUPTED);
diff --git a/fs/xfs/xfs_dir2_node.c b/fs/xfs/xfs_dir2_node.c
index 48c7d18..875e7c0 100644
--- a/fs/xfs/xfs_dir2_node.c
+++ b/fs/xfs/xfs_dir2_node.c
@@ -116,8 +116,7 @@ xfs_dir3_free_read_verify(
 	struct xfs_mount	*mp = bp->b_target->bt_mount;
 
 	if ((xfs_sb_version_hascrc(&mp->m_sb) &&
-	     !xfs_verify_cksum(bp->b_addr, BBTOB(bp->b_length),
-					  XFS_DIR3_FREE_CRC_OFF)) ||
+	     !xfs_buf_verify_cksum(bp, XFS_DIR3_FREE_CRC_OFF)) ||
 	    !xfs_dir3_free_verify(bp)) {
 		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp, bp->b_addr);
 		xfs_buf_ioerror(bp, EFSCORRUPTED);
diff --git a/fs/xfs/xfs_ialloc.c b/fs/xfs/xfs_ialloc.c
index 5d7f105..7321e49 100644
--- a/fs/xfs/xfs_ialloc.c
+++ b/fs/xfs/xfs_ialloc.c
@@ -1571,8 +1571,8 @@ xfs_agi_read_verify(
 	int		agi_ok = 1;
 
 	if (xfs_sb_version_hascrc(&mp->m_sb))
-		agi_ok = xfs_verify_cksum(bp->b_addr, BBTOB(bp->b_length),
-					  offsetof(struct xfs_agi, agi_crc));
+		agi_ok = xfs_buf_verify_cksum(bp,
+					offsetof(struct xfs_agi, agi_crc));
 	agi_ok = agi_ok && xfs_agi_verify(bp);
 
 	if (unlikely(XFS_TEST_ERROR(!agi_ok, mp, XFS_ERRTAG_IALLOC_READ_AGI,
diff --git a/fs/xfs/xfs_symlink_remote.c b/fs/xfs/xfs_symlink_remote.c
index bf59a2b..3f09957 100644
--- a/fs/xfs/xfs_symlink_remote.c
+++ b/fs/xfs/xfs_symlink_remote.c
@@ -133,7 +133,7 @@ xfs_symlink_read_verify(
 	if (!xfs_sb_version_hascrc(&mp->m_sb))
 		return;
 
-	if (!xfs_verify_cksum(bp->b_addr, BBTOB(bp->b_length),
+	if (!xfs_buf_verify_cksum(bp,
 				  offsetof(struct xfs_dsymlink_hdr, sl_crc)) ||
 	    !xfs_symlink_verify(bp)) {
 		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp, bp->b_addr);
-- 1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
