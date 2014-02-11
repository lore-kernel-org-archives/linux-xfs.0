Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id AD3407F4E
	for <xfs@oss.sgi.com>; Mon, 10 Feb 2014 21:11:51 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 2DE08AC009
	for <xfs@oss.sgi.com>; Mon, 10 Feb 2014 19:11:50 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id vhArXxzarFfYe5Es for <xfs@oss.sgi.com>;
	Mon, 10 Feb 2014 19:11:49 -0800 (PST)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 15E0B63CE389
	for <xfs@oss.sgi.com>; Mon, 10 Feb 2014 21:11:49 -0600 (CST)
Message-ID: <52F994F4.907@sandeen.net>
Date: Mon, 10 Feb 2014 21:11:48 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH 4/7] xfs: add helper for verifying checksums on xfs_bufs
References: <52F99426.3010409@sandeen.net>
In-Reply-To: <52F99426.3010409@sandeen.net>
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
To: xfs-oss <xfs@oss.sgi.com>

Many/most callers of xfs_verify_cksum() pass bp->b_addr and
BBTOB(bp->b_length) as the first 2 args.  Add a helper
which can just accept the bp and the crc offset, and work
it out on its own, for brevity.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 fs/xfs/xfs_alloc.c          |    6 ++----
 fs/xfs/xfs_attr_leaf.c      |    3 +--
 fs/xfs/xfs_btree.c          |    8 ++++----
 fs/xfs/xfs_buf.h            |    7 +++++++
 fs/xfs/xfs_da_btree.c       |    3 +--
 fs/xfs/xfs_dir2_block.c     |    3 +--
 fs/xfs/xfs_dir2_data.c      |    3 +--
 fs/xfs/xfs_dir2_leaf.c      |    3 +--
 fs/xfs/xfs_dir2_node.c      |    3 +--
 fs/xfs/xfs_ialloc.c         |    4 ++--
 fs/xfs/xfs_linux.h          |    1 +
 fs/xfs/xfs_symlink_remote.c |    3 +--
 12 files changed, 23 insertions(+), 24 deletions(-)

V2: move helper to xfs_buf.h

diff --git a/fs/xfs/xfs_alloc.c b/fs/xfs/xfs_alloc.c
index 72ea855..5050c9a 100644
--- a/fs/xfs/xfs_alloc.c
+++ b/fs/xfs/xfs_alloc.c
@@ -485,8 +485,7 @@ xfs_agfl_read_verify(
 	if (!xfs_sb_version_hascrc(&mp->m_sb))
 		return;
 
-	agfl_ok = xfs_verify_cksum(bp->b_addr, BBTOB(bp->b_length),
-				   XFS_AGFL_CRC_OFF);
+	agfl_ok = xfs_buf_verify_cksum(bp, XFS_AGFL_CRC_OFF);
 
 	agfl_ok = agfl_ok && xfs_agfl_verify(bp);
 
@@ -2240,8 +2239,7 @@ xfs_agf_read_verify(
 	int		agf_ok = 1;
 
 	if (xfs_sb_version_hascrc(&mp->m_sb))
-		agf_ok = xfs_verify_cksum(bp->b_addr, BBTOB(bp->b_length),
-					  XFS_AGF_CRC_OFF);
+		agf_ok = xfs_buf_verify_cksum(bp, XFS_AGF_CRC_OFF);
 
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
 
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index 9953395..5edcfba 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -369,6 +369,13 @@ static inline void xfs_buf_relse(xfs_buf_t *bp)
 	xfs_buf_rele(bp);
 }
 
+static inline int
+xfs_buf_verify_cksum(struct xfs_buf *bp, unsigned long cksum_offset)
+{
+	return xfs_verify_cksum(bp->b_addr, BBTOB(bp->b_length),
+				cksum_offset);
+}
+
 /*
  *	Handling of buftargs.
  */
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
index d79210b..d6a879d 100644
--- a/fs/xfs/xfs_ialloc.c
+++ b/fs/xfs/xfs_ialloc.c
@@ -1571,8 +1571,8 @@ xfs_agi_read_verify(
 	int		agi_ok = 1;
 
 	if (xfs_sb_version_hascrc(&mp->m_sb))
-		agi_ok = xfs_verify_cksum(bp->b_addr, BBTOB(bp->b_length),
-					  XFS_AGI_CRC_OFF);
+		agi_ok = xfs_buf_verify_cksum(bp, XFS_AGI_CRC_OFF);
+
 	agi_ok = agi_ok && xfs_agi_verify(bp);
 
 	if (unlikely(XFS_TEST_ERROR(!agi_ok, mp, XFS_ERRTAG_IALLOC_READ_AGI,
diff --git a/fs/xfs/xfs_linux.h b/fs/xfs/xfs_linux.h
index f9bb590..e8fed74 100644
--- a/fs/xfs/xfs_linux.h
+++ b/fs/xfs/xfs_linux.h
@@ -119,6 +119,7 @@ typedef __uint64_t __psunsigned_t;
 #include "xfs_iops.h"
 #include "xfs_aops.h"
 #include "xfs_super.h"
+#include "xfs_cksum.h"
 #include "xfs_buf.h"
 #include "xfs_message.h"
 
diff --git a/fs/xfs/xfs_symlink_remote.c b/fs/xfs/xfs_symlink_remote.c
index 7a705a4..b172955 100644
--- a/fs/xfs/xfs_symlink_remote.c
+++ b/fs/xfs/xfs_symlink_remote.c
@@ -133,8 +133,7 @@ xfs_symlink_read_verify(
 	if (!xfs_sb_version_hascrc(&mp->m_sb))
 		return;
 
-	if (!xfs_verify_cksum(bp->b_addr, BBTOB(bp->b_length),
-				  XFS_SYMLINK_CRC_OFF) ||
+	if (!xfs_buf_verify_cksum(bp, XFS_SYMLINK_CRC_OFF) ||
 	    !xfs_symlink_verify(bp)) {
 		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp, bp->b_addr);
 		xfs_buf_ioerror(bp, EFSCORRUPTED);
-- 1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
