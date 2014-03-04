Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id BBFEA7F78
	for <xfs@oss.sgi.com>; Tue,  4 Mar 2014 02:52:21 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 889BD8F8065
	for <xfs@oss.sgi.com>; Tue,  4 Mar 2014 00:52:21 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	oy82aMImDiyG1ysT for <xfs@oss.sgi.com>;
	Tue, 04 Mar 2014 00:52:19 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1WKl4w-0006Hb-NF
	for xfs@oss.sgi.com; Tue, 04 Mar 2014 19:51:58 +1100
Received: from dave by disappointment with local (Exim 4.82)
	(envelope-from <dave@disappointment.disaster>) id 1WKl4w-0006zM-MS
	for xfs@oss.sgi.com; Tue, 04 Mar 2014 19:51:58 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 08/13] libxfs: add helper for verifying checksums on xfs_bufs
Date: Tue,  4 Mar 2014 19:51:52 +1100
Message-Id: <1393923117-9559-9-git-send-email-david@fromorbit.com>
In-Reply-To: <1393923117-9559-1-git-send-email-david@fromorbit.com>
References: <1393923117-9559-1-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

[userspace port]

Many/most callers of xfs_verify_cksum() pass bp->b_addr and
BBTOB(bp->b_length) as the first 2 args.  Add a helper
which can just accept the bp and the crc offset, and work
it out on its own, for brevity.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 include/libxfs.h            | 7 +++++++
 libxfs/xfs_alloc.c          | 6 ++----
 libxfs/xfs_attr_leaf.c      | 3 +--
 libxfs/xfs_btree.c          | 8 ++++----
 libxfs/xfs_da_btree.c       | 3 +--
 libxfs/xfs_dir2_block.c     | 3 +--
 libxfs/xfs_dir2_data.c      | 3 +--
 libxfs/xfs_dir2_leaf.c      | 3 +--
 libxfs/xfs_dir2_node.c      | 3 +--
 libxfs/xfs_ialloc.c         | 4 ++--
 libxfs/xfs_sb.c             | 3 +--
 libxfs/xfs_symlink_remote.c | 3 +--
 12 files changed, 23 insertions(+), 26 deletions(-)

diff --git a/include/libxfs.h b/include/libxfs.h
index f688598..610e7d5 100644
--- a/include/libxfs.h
+++ b/include/libxfs.h
@@ -779,6 +779,13 @@ extern uint32_t crc32c_le(uint32_t crc, unsigned char const *p, size_t len);
 
 #include <xfs/xfs_cksum.h>
 
+static inline int
+xfs_buf_verify_cksum(struct xfs_buf *bp, unsigned long cksum_offset)
+{
+	return xfs_verify_cksum(bp->b_addr, BBTOB(bp->b_length),
+				cksum_offset);
+}
+
 #define xfs_notice(mp,fmt,args...)		cmn_err(CE_NOTE,fmt, ## args)
 #define xfs_warn(mp,fmt,args...)		cmn_err(CE_WARN,fmt, ## args)
 #define xfs_alert(mp,fmt,args...)		cmn_err(CE_ALERT,fmt, ## args)
diff --git a/libxfs/xfs_alloc.c b/libxfs/xfs_alloc.c
index 8a6725e..2f6a241 100644
--- a/libxfs/xfs_alloc.c
+++ b/libxfs/xfs_alloc.c
@@ -463,8 +463,7 @@ xfs_agfl_read_verify(
 	if (!xfs_sb_version_hascrc(&mp->m_sb))
 		return;
 
-	agfl_ok = xfs_verify_cksum(bp->b_addr, BBTOB(bp->b_length),
-				   XFS_AGFL_CRC_OFF);
+	agfl_ok = xfs_buf_verify_cksum(bp, XFS_AGFL_CRC_OFF);
 
 	agfl_ok = agfl_ok && xfs_agfl_verify(bp);
 
@@ -2220,8 +2219,7 @@ xfs_agf_read_verify(
 	int		agf_ok = 1;
 
 	if (xfs_sb_version_hascrc(&mp->m_sb))
-		agf_ok = xfs_verify_cksum(bp->b_addr, BBTOB(bp->b_length),
-					  XFS_AGF_CRC_OFF);
+		agf_ok = xfs_buf_verify_cksum(bp, XFS_AGF_CRC_OFF);
 
 	agf_ok = agf_ok && xfs_agf_verify(mp, bp);
 
diff --git a/libxfs/xfs_attr_leaf.c b/libxfs/xfs_attr_leaf.c
index fd52397..0bd3169 100644
--- a/libxfs/xfs_attr_leaf.c
+++ b/libxfs/xfs_attr_leaf.c
@@ -214,8 +214,7 @@ xfs_attr3_leaf_read_verify(
 	struct xfs_mount	*mp = bp->b_target->bt_mount;
 
 	if ((xfs_sb_version_hascrc(&mp->m_sb) &&
-	     !xfs_verify_cksum(bp->b_addr, BBTOB(bp->b_length),
-					  XFS_ATTR3_LEAF_CRC_OFF)) ||
+	     !xfs_buf_verify_cksum(bp, XFS_ATTR3_LEAF_CRC_OFF)) ||
 	    !xfs_attr3_leaf_verify(bp)) {
 		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp, bp->b_addr);
 		xfs_buf_ioerror(bp, EFSCORRUPTED);
diff --git a/libxfs/xfs_btree.c b/libxfs/xfs_btree.c
index 2dd6fb7..fffed0a 100644
--- a/libxfs/xfs_btree.c
+++ b/libxfs/xfs_btree.c
@@ -227,8 +227,8 @@ xfs_btree_lblock_verify_crc(
 	struct xfs_buf		*bp)
 {
 	if (xfs_sb_version_hascrc(&bp->b_target->bt_mount->m_sb))
-		return xfs_verify_cksum(bp->b_addr, BBTOB(bp->b_length),
-					XFS_BTREE_LBLOCK_CRC_OFF);
+		return xfs_buf_verify_cksum(bp, XFS_BTREE_LBLOCK_CRC_OFF);
+
 	return true;
 }
 
@@ -260,8 +260,8 @@ xfs_btree_sblock_verify_crc(
 	struct xfs_buf		*bp)
 {
 	if (xfs_sb_version_hascrc(&bp->b_target->bt_mount->m_sb))
-		return xfs_verify_cksum(bp->b_addr, BBTOB(bp->b_length),
-					XFS_BTREE_SBLOCK_CRC_OFF);
+		return xfs_buf_verify_cksum(bp, XFS_BTREE_SBLOCK_CRC_OFF);
+
 	return true;
 }
 
diff --git a/libxfs/xfs_da_btree.c b/libxfs/xfs_da_btree.c
index 53414f5..4e8b41a 100644
--- a/libxfs/xfs_da_btree.c
+++ b/libxfs/xfs_da_btree.c
@@ -238,8 +238,7 @@ xfs_da3_node_read_verify(
 
 	switch (be16_to_cpu(info->magic)) {
 		case XFS_DA3_NODE_MAGIC:
-			if (!xfs_verify_cksum(bp->b_addr, BBTOB(bp->b_length),
-					      XFS_DA3_NODE_CRC_OFF))
+			if (!xfs_buf_verify_cksum(bp, XFS_DA3_NODE_CRC_OFF))
 				break;
 			/* fall through */
 		case XFS_DA_NODE_MAGIC:
diff --git a/libxfs/xfs_dir2_block.c b/libxfs/xfs_dir2_block.c
index 1d8f598..13561c3 100644
--- a/libxfs/xfs_dir2_block.c
+++ b/libxfs/xfs_dir2_block.c
@@ -71,8 +71,7 @@ xfs_dir3_block_read_verify(
 	struct xfs_mount	*mp = bp->b_target->bt_mount;
 
 	if ((xfs_sb_version_hascrc(&mp->m_sb) &&
-	     !xfs_verify_cksum(bp->b_addr, BBTOB(bp->b_length),
-					  XFS_DIR3_DATA_CRC_OFF)) ||
+	     !xfs_buf_verify_cksum(bp, XFS_DIR3_DATA_CRC_OFF)) ||
 	    !xfs_dir3_block_verify(bp)) {
 		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp, bp->b_addr);
 		xfs_buf_ioerror(bp, EFSCORRUPTED);
diff --git a/libxfs/xfs_dir2_data.c b/libxfs/xfs_dir2_data.c
index 189699f..2a0de28 100644
--- a/libxfs/xfs_dir2_data.c
+++ b/libxfs/xfs_dir2_data.c
@@ -235,8 +235,7 @@ xfs_dir3_data_read_verify(
 	struct xfs_mount	*mp = bp->b_target->bt_mount;
 
 	if ((xfs_sb_version_hascrc(&mp->m_sb) &&
-	     !xfs_verify_cksum(bp->b_addr, BBTOB(bp->b_length),
-					  XFS_DIR3_DATA_CRC_OFF)) ||
+	     !xfs_buf_verify_cksum(bp, XFS_DIR3_DATA_CRC_OFF)) ||
 	    !xfs_dir3_data_verify(bp)) {
 		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp, bp->b_addr);
 		xfs_buf_ioerror(bp, EFSCORRUPTED);
diff --git a/libxfs/xfs_dir2_leaf.c b/libxfs/xfs_dir2_leaf.c
index 683536e..0fa147f 100644
--- a/libxfs/xfs_dir2_leaf.c
+++ b/libxfs/xfs_dir2_leaf.c
@@ -207,8 +207,7 @@ __read_verify(
 	struct xfs_mount	*mp = bp->b_target->bt_mount;
 
 	if ((xfs_sb_version_hascrc(&mp->m_sb) &&
-	     !xfs_verify_cksum(bp->b_addr, BBTOB(bp->b_length),
-					  XFS_DIR3_LEAF_CRC_OFF)) ||
+	     !xfs_buf_verify_cksum(bp, XFS_DIR3_LEAF_CRC_OFF)) ||
 	    !xfs_dir3_leaf_verify(bp, magic)) {
 		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp, bp->b_addr);
 		xfs_buf_ioerror(bp, EFSCORRUPTED);
diff --git a/libxfs/xfs_dir2_node.c b/libxfs/xfs_dir2_node.c
index ced8c58..78c77ed 100644
--- a/libxfs/xfs_dir2_node.c
+++ b/libxfs/xfs_dir2_node.c
@@ -99,8 +99,7 @@ xfs_dir3_free_read_verify(
 	struct xfs_mount	*mp = bp->b_target->bt_mount;
 
 	if ((xfs_sb_version_hascrc(&mp->m_sb) &&
-	     !xfs_verify_cksum(bp->b_addr, BBTOB(bp->b_length),
-					  XFS_DIR3_FREE_CRC_OFF)) ||
+	     !xfs_buf_verify_cksum(bp, XFS_DIR3_FREE_CRC_OFF)) ||
 	    !xfs_dir3_free_verify(bp)) {
 		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp, bp->b_addr);
 		xfs_buf_ioerror(bp, EFSCORRUPTED);
diff --git a/libxfs/xfs_ialloc.c b/libxfs/xfs_ialloc.c
index b83ad98..21683b5 100644
--- a/libxfs/xfs_ialloc.c
+++ b/libxfs/xfs_ialloc.c
@@ -1554,8 +1554,8 @@ xfs_agi_read_verify(
 	int		agi_ok = 1;
 
 	if (xfs_sb_version_hascrc(&mp->m_sb))
-		agi_ok = xfs_verify_cksum(bp->b_addr, BBTOB(bp->b_length),
-					  XFS_AGI_CRC_OFF);
+		agi_ok = xfs_buf_verify_cksum(bp, XFS_AGI_CRC_OFF);
+
 	agi_ok = agi_ok && xfs_agi_verify(bp);
 
 	if (unlikely(XFS_TEST_ERROR(!agi_ok, mp, XFS_ERRTAG_IALLOC_READ_AGI,
diff --git a/libxfs/xfs_sb.c b/libxfs/xfs_sb.c
index bbcf886..43fdb59 100644
--- a/libxfs/xfs_sb.c
+++ b/libxfs/xfs_sb.c
@@ -565,8 +565,7 @@ xfs_sb_read_verify(
 						XFS_SB_VERSION_5) ||
 	     dsb->sb_crc != 0)) {
 
-		if (!xfs_verify_cksum(bp->b_addr, BBTOB(bp->b_length),
-				      XFS_SB_CRC_OFF)) {
+		if (!xfs_buf_verify_cksum(bp, XFS_SB_CRC_OFF)) {
 			/* Only fail bad secondaries on a known V5 filesystem */
 			if (bp->b_bn == XFS_SB_DADDR ||
 			    xfs_sb_version_hascrc(&mp->m_sb)) {
diff --git a/libxfs/xfs_symlink_remote.c b/libxfs/xfs_symlink_remote.c
index 09ee9d4..716f8a3 100644
--- a/libxfs/xfs_symlink_remote.c
+++ b/libxfs/xfs_symlink_remote.c
@@ -116,8 +116,7 @@ xfs_symlink_read_verify(
 	if (!xfs_sb_version_hascrc(&mp->m_sb))
 		return;
 
-	if (!xfs_verify_cksum(bp->b_addr, BBTOB(bp->b_length),
-				  XFS_SYMLINK_CRC_OFF) ||
+	if (!xfs_buf_verify_cksum(bp, XFS_SYMLINK_CRC_OFF) ||
 	    !xfs_symlink_verify(bp)) {
 		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp, bp->b_addr);
 		xfs_buf_ioerror(bp, EFSCORRUPTED);
-- 
1.9.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
