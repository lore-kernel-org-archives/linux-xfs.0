Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 4FEDF7F83
	for <xfs@oss.sgi.com>; Tue,  4 Mar 2014 02:52:23 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E2F2D8F8071
	for <xfs@oss.sgi.com>; Tue,  4 Mar 2014 00:52:22 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	7IWnv2sGozF4uIGT for <xfs@oss.sgi.com>;
	Tue, 04 Mar 2014 00:52:20 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1WKl4w-0006He-Os
	for xfs@oss.sgi.com; Tue, 04 Mar 2014 19:51:58 +1100
Received: from dave by disappointment with local (Exim 4.82)
	(envelope-from <dave@disappointment.disaster>) id 1WKl4w-0006zt-O3
	for xfs@oss.sgi.com; Tue, 04 Mar 2014 19:51:58 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 11/13] libxfs: modify verifiers to differentiate CRC from
	other errors
Date: Tue,  4 Mar 2014 19:51:55 +1100
Message-Id: <1393923117-9559-12-git-send-email-david@fromorbit.com>
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

Modify all read & write verifiers to differentiate
between CRC errors and other inconsistencies.

This sets the appropriate error number on bp->b_error,
and then calls xfs_verifier_error() if something went
wrong.  That function will issue the appropriate message
to the user.

Also, fix the silly bug in xfs_buf_ioerror() that this patch
exposes.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 include/libxfs.h            |  2 +-
 libxfs/xfs_alloc.c          | 37 +++++++++++++++++--------------------
 libxfs/xfs_alloc_btree.c    | 15 ++++++++-------
 libxfs/xfs_attr_leaf.c      | 14 ++++++++------
 libxfs/xfs_attr_remote.c    | 15 ++++++---------
 libxfs/xfs_bmap_btree.c     | 16 ++++++++--------
 libxfs/xfs_da_btree.c       | 14 ++++++++------
 libxfs/xfs_dir2_block.c     | 14 ++++++++------
 libxfs/xfs_dir2_data.c      | 17 +++++++++--------
 libxfs/xfs_dir2_leaf.c      | 14 ++++++++------
 libxfs/xfs_dir2_node.c      | 14 ++++++++------
 libxfs/xfs_dquot_buf.c      | 11 +++++++----
 libxfs/xfs_ialloc.c         | 21 ++++++++++-----------
 libxfs/xfs_ialloc_btree.c   | 15 ++++++++-------
 libxfs/xfs_inode_buf.c      |  3 +--
 libxfs/xfs_sb.c             | 10 ++++------
 libxfs/xfs_symlink_remote.c | 12 +++++++-----
 17 files changed, 126 insertions(+), 118 deletions(-)

diff --git a/include/libxfs.h b/include/libxfs.h
index 7500903..6bc6c94 100644
--- a/include/libxfs.h
+++ b/include/libxfs.h
@@ -365,7 +365,7 @@ enum xfs_buf_flags_t {	/* b_flags bits */
 #define XFS_BUF_PRIORITY(bp)		(cache_node_get_priority( \
 						(struct cache_node *)(bp)))
 #define xfs_buf_set_ref(bp,ref)		((void) 0)
-#define xfs_buf_ioerror(bp,err)		(bp)->b_error = (err);
+#define xfs_buf_ioerror(bp,err)		((bp)->b_error = (err))
 
 #define xfs_daddr_to_agno(mp,d) \
 	((xfs_agnumber_t)(XFS_BB_TO_FSBT(mp, d) / (mp)->m_sb.sb_agblocks))
diff --git a/libxfs/xfs_alloc.c b/libxfs/xfs_alloc.c
index dca612b..6c82be0 100644
--- a/libxfs/xfs_alloc.c
+++ b/libxfs/xfs_alloc.c
@@ -452,7 +452,6 @@ xfs_agfl_read_verify(
 	struct xfs_buf	*bp)
 {
 	struct xfs_mount *mp = bp->b_target->bt_mount;
-	int		agfl_ok = 1;
 
 	/*
 	 * There is no verification of non-crc AGFLs because mkfs does not
@@ -463,14 +462,13 @@ xfs_agfl_read_verify(
 	if (!xfs_sb_version_hascrc(&mp->m_sb))
 		return;
 
-	agfl_ok = xfs_buf_verify_cksum(bp, XFS_AGFL_CRC_OFF);
-
-	agfl_ok = agfl_ok && xfs_agfl_verify(bp);
-
-	if (!agfl_ok) {
-		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp, bp->b_addr);
+	if (!xfs_buf_verify_cksum(bp, XFS_AGFL_CRC_OFF))
+		xfs_buf_ioerror(bp, EFSBADCRC);
+	else if (!xfs_agfl_verify(bp))
 		xfs_buf_ioerror(bp, EFSCORRUPTED);
-	}
+
+	if (bp->b_error)
+		xfs_verifier_error(bp);
 }
 
 static void
@@ -485,8 +483,8 @@ xfs_agfl_write_verify(
 		return;
 
 	if (!xfs_agfl_verify(bp)) {
-		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp, bp->b_addr);
 		xfs_buf_ioerror(bp, EFSCORRUPTED);
+		xfs_verifier_error(bp);
 		return;
 	}
 
@@ -2216,18 +2214,17 @@ xfs_agf_read_verify(
 	struct xfs_buf	*bp)
 {
 	struct xfs_mount *mp = bp->b_target->bt_mount;
-	int		agf_ok = 1;
-
-	if (xfs_sb_version_hascrc(&mp->m_sb))
-		agf_ok = xfs_buf_verify_cksum(bp, XFS_AGF_CRC_OFF);
 
-	agf_ok = agf_ok && xfs_agf_verify(mp, bp);
-
-	if (unlikely(XFS_TEST_ERROR(!agf_ok, mp, XFS_ERRTAG_ALLOC_READ_AGF,
-			XFS_RANDOM_ALLOC_READ_AGF))) {
-		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp, bp->b_addr);
+	if (xfs_sb_version_hascrc(&mp->m_sb) &&
+	    !xfs_buf_verify_cksum(bp, XFS_AGF_CRC_OFF))
+		xfs_buf_ioerror(bp, EFSBADCRC);
+	else if (XFS_TEST_ERROR(!xfs_agf_verify(mp, bp), mp,
+				XFS_ERRTAG_ALLOC_READ_AGF,
+				XFS_RANDOM_ALLOC_READ_AGF))
 		xfs_buf_ioerror(bp, EFSCORRUPTED);
-	}
+
+	if (bp->b_error)
+		xfs_verifier_error(bp);
 }
 
 static void
@@ -2238,8 +2235,8 @@ xfs_agf_write_verify(
 	struct xfs_buf_log_item	*bip = bp->b_fspriv;
 
 	if (!xfs_agf_verify(mp, bp)) {
-		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp, bp->b_addr);
 		xfs_buf_ioerror(bp, EFSCORRUPTED);
+		xfs_verifier_error(bp);
 		return;
 	}
 
diff --git a/libxfs/xfs_alloc_btree.c b/libxfs/xfs_alloc_btree.c
index 5b38c24..215be7e 100644
--- a/libxfs/xfs_alloc_btree.c
+++ b/libxfs/xfs_alloc_btree.c
@@ -337,12 +337,14 @@ static void
 xfs_allocbt_read_verify(
 	struct xfs_buf	*bp)
 {
-	if (!(xfs_btree_sblock_verify_crc(bp) &&
-	      xfs_allocbt_verify(bp))) {
-		trace_xfs_btree_corrupt(bp, _RET_IP_);
-		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW,
-				     bp->b_target->bt_mount, bp->b_addr);
+	if (!xfs_btree_sblock_verify_crc(bp))
+		xfs_buf_ioerror(bp, EFSBADCRC);
+	else if (!xfs_allocbt_verify(bp))
 		xfs_buf_ioerror(bp, EFSCORRUPTED);
+
+	if (bp->b_error) {
+		trace_xfs_btree_corrupt(bp, _RET_IP_);
+		xfs_verifier_error(bp);
 	}
 }
 
@@ -352,9 +354,8 @@ xfs_allocbt_write_verify(
 {
 	if (!xfs_allocbt_verify(bp)) {
 		trace_xfs_btree_corrupt(bp, _RET_IP_);
-		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW,
-				     bp->b_target->bt_mount, bp->b_addr);
 		xfs_buf_ioerror(bp, EFSCORRUPTED);
+		xfs_verifier_error(bp);
 		return;
 	}
 	xfs_btree_sblock_calc_crc(bp);
diff --git a/libxfs/xfs_attr_leaf.c b/libxfs/xfs_attr_leaf.c
index 90937d6..f7f02ae 100644
--- a/libxfs/xfs_attr_leaf.c
+++ b/libxfs/xfs_attr_leaf.c
@@ -187,8 +187,8 @@ xfs_attr3_leaf_write_verify(
 	struct xfs_attr3_leaf_hdr *hdr3 = bp->b_addr;
 
 	if (!xfs_attr3_leaf_verify(bp)) {
-		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp, bp->b_addr);
 		xfs_buf_ioerror(bp, EFSCORRUPTED);
+		xfs_verifier_error(bp);
 		return;
 	}
 
@@ -213,12 +213,14 @@ xfs_attr3_leaf_read_verify(
 {
 	struct xfs_mount	*mp = bp->b_target->bt_mount;
 
-	if ((xfs_sb_version_hascrc(&mp->m_sb) &&
-	     !xfs_buf_verify_cksum(bp, XFS_ATTR3_LEAF_CRC_OFF)) ||
-	    !xfs_attr3_leaf_verify(bp)) {
-		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp, bp->b_addr);
+	if (xfs_sb_version_hascrc(&mp->m_sb) &&
+	     !xfs_buf_verify_cksum(bp, XFS_ATTR3_LEAF_CRC_OFF))
+		xfs_buf_ioerror(bp, EFSBADCRC);
+	else if (!xfs_attr3_leaf_verify(bp))
 		xfs_buf_ioerror(bp, EFSCORRUPTED);
-	}
+
+	if (bp->b_error)
+		xfs_verifier_error(bp);
 }
 
 const struct xfs_buf_ops xfs_attr3_leaf_buf_ops = {
diff --git a/libxfs/xfs_attr_remote.c b/libxfs/xfs_attr_remote.c
index 59bb12d..5cf5c73 100644
--- a/libxfs/xfs_attr_remote.c
+++ b/libxfs/xfs_attr_remote.c
@@ -100,7 +100,6 @@ xfs_attr3_rmt_read_verify(
 	struct xfs_mount *mp = bp->b_target->bt_mount;
 	char		*ptr;
 	int		len;
-	bool		corrupt = false;
 	xfs_daddr_t	bno;
 
 	/* no verification of non-crc buffers */
@@ -115,11 +114,11 @@ xfs_attr3_rmt_read_verify(
 	while (len > 0) {
 		if (!xfs_verify_cksum(ptr, XFS_LBSIZE(mp),
 				      XFS_ATTR3_RMT_CRC_OFF)) {
-			corrupt = true;
+			xfs_buf_ioerror(bp, EFSBADCRC);
 			break;
 		}
 		if (!xfs_attr3_rmt_verify(mp, ptr, XFS_LBSIZE(mp), bno)) {
-			corrupt = true;
+			xfs_buf_ioerror(bp, EFSCORRUPTED);
 			break;
 		}
 		len -= XFS_LBSIZE(mp);
@@ -127,10 +126,9 @@ xfs_attr3_rmt_read_verify(
 		bno += mp->m_bsize;
 	}
 
-	if (corrupt) {
-		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp, bp->b_addr);
-		xfs_buf_ioerror(bp, EFSCORRUPTED);
-	} else
+	if (bp->b_error)
+		xfs_verifier_error(bp);
+	else
 		ASSERT(len == 0);
 }
 
@@ -155,9 +153,8 @@ xfs_attr3_rmt_write_verify(
 
 	while (len > 0) {
 		if (!xfs_attr3_rmt_verify(mp, ptr, XFS_LBSIZE(mp), bno)) {
-			XFS_CORRUPTION_ERROR(__func__,
-					    XFS_ERRLEVEL_LOW, mp, bp->b_addr);
 			xfs_buf_ioerror(bp, EFSCORRUPTED);
+			xfs_verifier_error(bp);
 			return;
 		}
 		if (bip) {
diff --git a/libxfs/xfs_bmap_btree.c b/libxfs/xfs_bmap_btree.c
index 3136e4f..a4bd69d 100644
--- a/libxfs/xfs_bmap_btree.c
+++ b/libxfs/xfs_bmap_btree.c
@@ -759,12 +759,14 @@ static void
 xfs_bmbt_read_verify(
 	struct xfs_buf	*bp)
 {
-	if (!(xfs_btree_lblock_verify_crc(bp) &&
-	      xfs_bmbt_verify(bp))) {
-		trace_xfs_btree_corrupt(bp, _RET_IP_);
-		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW,
-				     bp->b_target->bt_mount, bp->b_addr);
+	if (!xfs_btree_lblock_verify_crc(bp))
+		xfs_buf_ioerror(bp, EFSBADCRC);
+	else if (!xfs_bmbt_verify(bp))
 		xfs_buf_ioerror(bp, EFSCORRUPTED);
+
+	if (bp->b_error) {
+		trace_xfs_btree_corrupt(bp, _RET_IP_);
+		xfs_verifier_error(bp);
 	}
 }
 
@@ -773,11 +775,9 @@ xfs_bmbt_write_verify(
 	struct xfs_buf	*bp)
 {
 	if (!xfs_bmbt_verify(bp)) {
-		xfs_warn(bp->b_target->bt_mount, "bmbt daddr 0x%llx failed", bp->b_bn);
 		trace_xfs_btree_corrupt(bp, _RET_IP_);
-		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW,
-				     bp->b_target->bt_mount, bp->b_addr);
 		xfs_buf_ioerror(bp, EFSCORRUPTED);
+		xfs_verifier_error(bp);
 		return;
 	}
 	xfs_btree_lblock_calc_crc(bp);
diff --git a/libxfs/xfs_da_btree.c b/libxfs/xfs_da_btree.c
index 0c0c5e0..154adb1 100644
--- a/libxfs/xfs_da_btree.c
+++ b/libxfs/xfs_da_btree.c
@@ -209,8 +209,8 @@ xfs_da3_node_write_verify(
 	struct xfs_da3_node_hdr *hdr3 = bp->b_addr;
 
 	if (!xfs_da3_node_verify(bp)) {
-		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp, bp->b_addr);
 		xfs_buf_ioerror(bp, EFSCORRUPTED);
+		xfs_verifier_error(bp);
 		return;
 	}
 
@@ -233,17 +233,20 @@ static void
 xfs_da3_node_read_verify(
 	struct xfs_buf		*bp)
 {
-	struct xfs_mount	*mp = bp->b_target->bt_mount;
 	struct xfs_da_blkinfo	*info = bp->b_addr;
 
 	switch (be16_to_cpu(info->magic)) {
 		case XFS_DA3_NODE_MAGIC:
-			if (!xfs_buf_verify_cksum(bp, XFS_DA3_NODE_CRC_OFF))
+			if (!xfs_buf_verify_cksum(bp, XFS_DA3_NODE_CRC_OFF)) {
+				xfs_buf_ioerror(bp, EFSBADCRC);
 				break;
+			}
 			/* fall through */
 		case XFS_DA_NODE_MAGIC:
-			if (!xfs_da3_node_verify(bp))
+			if (!xfs_da3_node_verify(bp)) {
+				xfs_buf_ioerror(bp, EFSCORRUPTED);
 				break;
+			}
 			return;
 		case XFS_ATTR_LEAF_MAGIC:
 		case XFS_ATTR3_LEAF_MAGIC:
@@ -260,8 +263,7 @@ xfs_da3_node_read_verify(
 	}
 
 	/* corrupt block */
-	XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp, bp->b_addr);
-	xfs_buf_ioerror(bp, EFSCORRUPTED);
+	xfs_verifier_error(bp);
 }
 
 const struct xfs_buf_ops xfs_da3_node_buf_ops = {
diff --git a/libxfs/xfs_dir2_block.c b/libxfs/xfs_dir2_block.c
index 3fe10ea..cede01f 100644
--- a/libxfs/xfs_dir2_block.c
+++ b/libxfs/xfs_dir2_block.c
@@ -70,12 +70,14 @@ xfs_dir3_block_read_verify(
 {
 	struct xfs_mount	*mp = bp->b_target->bt_mount;
 
-	if ((xfs_sb_version_hascrc(&mp->m_sb) &&
-	     !xfs_buf_verify_cksum(bp, XFS_DIR3_DATA_CRC_OFF)) ||
-	    !xfs_dir3_block_verify(bp)) {
-		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp, bp->b_addr);
+	if (xfs_sb_version_hascrc(&mp->m_sb) &&
+	     !xfs_buf_verify_cksum(bp, XFS_DIR3_DATA_CRC_OFF))
+		xfs_buf_ioerror(bp, EFSBADCRC);
+	else if (!xfs_dir3_block_verify(bp))
 		xfs_buf_ioerror(bp, EFSCORRUPTED);
-	}
+
+	if (bp->b_error)
+		xfs_verifier_error(bp);
 }
 
 static void
@@ -87,8 +89,8 @@ xfs_dir3_block_write_verify(
 	struct xfs_dir3_blk_hdr	*hdr3 = bp->b_addr;
 
 	if (!xfs_dir3_block_verify(bp)) {
-		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp, bp->b_addr);
 		xfs_buf_ioerror(bp, EFSCORRUPTED);
+		xfs_verifier_error(bp);
 		return;
 	}
 
diff --git a/libxfs/xfs_dir2_data.c b/libxfs/xfs_dir2_data.c
index bcb4c7f..dc9df4d 100644
--- a/libxfs/xfs_dir2_data.c
+++ b/libxfs/xfs_dir2_data.c
@@ -208,7 +208,6 @@ static void
 xfs_dir3_data_reada_verify(
 	struct xfs_buf		*bp)
 {
-	struct xfs_mount	*mp = bp->b_target->bt_mount;
 	struct xfs_dir2_data_hdr *hdr = bp->b_addr;
 
 	switch (hdr->magic) {
@@ -222,8 +221,8 @@ xfs_dir3_data_reada_verify(
 		xfs_dir3_data_verify(bp);
 		return;
 	default:
-		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp, hdr);
 		xfs_buf_ioerror(bp, EFSCORRUPTED);
+		xfs_verifier_error(bp);
 		break;
 	}
 }
@@ -234,12 +233,14 @@ xfs_dir3_data_read_verify(
 {
 	struct xfs_mount	*mp = bp->b_target->bt_mount;
 
-	if ((xfs_sb_version_hascrc(&mp->m_sb) &&
-	     !xfs_buf_verify_cksum(bp, XFS_DIR3_DATA_CRC_OFF)) ||
-	    !xfs_dir3_data_verify(bp)) {
-		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp, bp->b_addr);
+	if (xfs_sb_version_hascrc(&mp->m_sb) &&
+	     !xfs_buf_verify_cksum(bp, XFS_DIR3_DATA_CRC_OFF))
+		 xfs_buf_ioerror(bp, EFSBADCRC);
+	else if (!xfs_dir3_data_verify(bp))
 		xfs_buf_ioerror(bp, EFSCORRUPTED);
-	}
+
+	if (bp->b_error)
+		xfs_verifier_error(bp);
 }
 
 static void
@@ -251,8 +252,8 @@ xfs_dir3_data_write_verify(
 	struct xfs_dir3_blk_hdr	*hdr3 = bp->b_addr;
 
 	if (!xfs_dir3_data_verify(bp)) {
-		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp, bp->b_addr);
 		xfs_buf_ioerror(bp, EFSCORRUPTED);
+		xfs_verifier_error(bp);
 		return;
 	}
 
diff --git a/libxfs/xfs_dir2_leaf.c b/libxfs/xfs_dir2_leaf.c
index 710f005..8e0cbc9 100644
--- a/libxfs/xfs_dir2_leaf.c
+++ b/libxfs/xfs_dir2_leaf.c
@@ -206,12 +206,14 @@ __read_verify(
 {
 	struct xfs_mount	*mp = bp->b_target->bt_mount;
 
-	if ((xfs_sb_version_hascrc(&mp->m_sb) &&
-	     !xfs_buf_verify_cksum(bp, XFS_DIR3_LEAF_CRC_OFF)) ||
-	    !xfs_dir3_leaf_verify(bp, magic)) {
-		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp, bp->b_addr);
+	if (xfs_sb_version_hascrc(&mp->m_sb) &&
+	     !xfs_buf_verify_cksum(bp, XFS_DIR3_LEAF_CRC_OFF))
+		xfs_buf_ioerror(bp, EFSBADCRC);
+	else if (!xfs_dir3_leaf_verify(bp, magic))
 		xfs_buf_ioerror(bp, EFSCORRUPTED);
-	}
+
+	if (bp->b_error)
+		xfs_verifier_error(bp);
 }
 
 static void
@@ -224,8 +226,8 @@ __write_verify(
 	struct xfs_dir3_leaf_hdr *hdr3 = bp->b_addr;
 
 	if (!xfs_dir3_leaf_verify(bp, magic)) {
-		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp, bp->b_addr);
 		xfs_buf_ioerror(bp, EFSCORRUPTED);
+		xfs_verifier_error(bp);
 		return;
 	}
 
diff --git a/libxfs/xfs_dir2_node.c b/libxfs/xfs_dir2_node.c
index f4260ea..3256756 100644
--- a/libxfs/xfs_dir2_node.c
+++ b/libxfs/xfs_dir2_node.c
@@ -98,12 +98,14 @@ xfs_dir3_free_read_verify(
 {
 	struct xfs_mount	*mp = bp->b_target->bt_mount;
 
-	if ((xfs_sb_version_hascrc(&mp->m_sb) &&
-	     !xfs_buf_verify_cksum(bp, XFS_DIR3_FREE_CRC_OFF)) ||
-	    !xfs_dir3_free_verify(bp)) {
-		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp, bp->b_addr);
+	if (xfs_sb_version_hascrc(&mp->m_sb) &&
+	    !xfs_buf_verify_cksum(bp, XFS_DIR3_FREE_CRC_OFF))
+		xfs_buf_ioerror(bp, EFSBADCRC);
+	else if (!xfs_dir3_free_verify(bp))
 		xfs_buf_ioerror(bp, EFSCORRUPTED);
-	}
+
+	if (bp->b_error)
+		xfs_verifier_error(bp);
 }
 
 static void
@@ -115,8 +117,8 @@ xfs_dir3_free_write_verify(
 	struct xfs_dir3_blk_hdr	*hdr3 = bp->b_addr;
 
 	if (!xfs_dir3_free_verify(bp)) {
-		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp, bp->b_addr);
 		xfs_buf_ioerror(bp, EFSCORRUPTED);
+		xfs_verifier_error(bp);
 		return;
 	}
 
diff --git a/libxfs/xfs_dquot_buf.c b/libxfs/xfs_dquot_buf.c
index 6bbb0ff..e089ec8 100644
--- a/libxfs/xfs_dquot_buf.c
+++ b/libxfs/xfs_dquot_buf.c
@@ -237,10 +237,13 @@ xfs_dquot_buf_read_verify(
 {
 	struct xfs_mount	*mp = bp->b_target->bt_mount;
 
-	if (!xfs_dquot_buf_verify_crc(mp, bp) || !xfs_dquot_buf_verify(mp, bp)) {
-		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp, bp->b_addr);
+	if (!xfs_dquot_buf_verify_crc(mp, bp))
+		xfs_buf_ioerror(bp, EFSBADCRC);
+	else if (!xfs_dquot_buf_verify(mp, bp))
 		xfs_buf_ioerror(bp, EFSCORRUPTED);
-	}
+
+	if (bp->b_error)
+		xfs_verifier_error(bp);
 }
 
 /*
@@ -255,8 +258,8 @@ xfs_dquot_buf_write_verify(
 	struct xfs_mount	*mp = bp->b_target->bt_mount;
 
 	if (!xfs_dquot_buf_verify(mp, bp)) {
-		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp, bp->b_addr);
 		xfs_buf_ioerror(bp, EFSCORRUPTED);
+		xfs_verifier_error(bp);
 		return;
 	}
 }
diff --git a/libxfs/xfs_ialloc.c b/libxfs/xfs_ialloc.c
index b1382d6..c19d84a 100644
--- a/libxfs/xfs_ialloc.c
+++ b/libxfs/xfs_ialloc.c
@@ -1551,18 +1551,17 @@ xfs_agi_read_verify(
 	struct xfs_buf	*bp)
 {
 	struct xfs_mount *mp = bp->b_target->bt_mount;
-	int		agi_ok = 1;
 
-	if (xfs_sb_version_hascrc(&mp->m_sb))
-		agi_ok = xfs_buf_verify_cksum(bp, XFS_AGI_CRC_OFF);
-
-	agi_ok = agi_ok && xfs_agi_verify(bp);
-
-	if (unlikely(XFS_TEST_ERROR(!agi_ok, mp, XFS_ERRTAG_IALLOC_READ_AGI,
-			XFS_RANDOM_IALLOC_READ_AGI))) {
-		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp, bp->b_addr);
+	if (xfs_sb_version_hascrc(&mp->m_sb) &&
+	    !xfs_buf_verify_cksum(bp, XFS_AGI_CRC_OFF))
+		xfs_buf_ioerror(bp, EFSBADCRC);
+	else if (XFS_TEST_ERROR(!xfs_agi_verify(bp), mp,
+				XFS_ERRTAG_IALLOC_READ_AGI,
+				XFS_RANDOM_IALLOC_READ_AGI))
 		xfs_buf_ioerror(bp, EFSCORRUPTED);
-	}
+
+	if (bp->b_error)
+		xfs_verifier_error(bp);
 }
 
 static void
@@ -1573,8 +1572,8 @@ xfs_agi_write_verify(
 	struct xfs_buf_log_item	*bip = bp->b_fspriv;
 
 	if (!xfs_agi_verify(bp)) {
-		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp, bp->b_addr);
 		xfs_buf_ioerror(bp, EFSCORRUPTED);
+		xfs_verifier_error(bp);
 		return;
 	}
 
diff --git a/libxfs/xfs_ialloc_btree.c b/libxfs/xfs_ialloc_btree.c
index d9589b7..0a29d73 100644
--- a/libxfs/xfs_ialloc_btree.c
+++ b/libxfs/xfs_ialloc_btree.c
@@ -224,12 +224,14 @@ static void
 xfs_inobt_read_verify(
 	struct xfs_buf	*bp)
 {
-	if (!(xfs_btree_sblock_verify_crc(bp) &&
-	      xfs_inobt_verify(bp))) {
-		trace_xfs_btree_corrupt(bp, _RET_IP_);
-		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW,
-				     bp->b_target->bt_mount, bp->b_addr);
+	if (!xfs_btree_sblock_verify_crc(bp))
+		xfs_buf_ioerror(bp, EFSBADCRC);
+	else if (!xfs_inobt_verify(bp))
 		xfs_buf_ioerror(bp, EFSCORRUPTED);
+
+	if (bp->b_error) {
+		trace_xfs_btree_corrupt(bp, _RET_IP_);
+		xfs_verifier_error(bp);
 	}
 }
 
@@ -239,9 +241,8 @@ xfs_inobt_write_verify(
 {
 	if (!xfs_inobt_verify(bp)) {
 		trace_xfs_btree_corrupt(bp, _RET_IP_);
-		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW,
-				     bp->b_target->bt_mount, bp->b_addr);
 		xfs_buf_ioerror(bp, EFSCORRUPTED);
+		xfs_verifier_error(bp);
 		return;
 	}
 	xfs_btree_sblock_calc_crc(bp);
diff --git a/libxfs/xfs_inode_buf.c b/libxfs/xfs_inode_buf.c
index 4f29033..de16ed9 100644
--- a/libxfs/xfs_inode_buf.c
+++ b/libxfs/xfs_inode_buf.c
@@ -88,8 +88,7 @@ xfs_inode_buf_verify(
 			}
 
 			xfs_buf_ioerror(bp, EFSCORRUPTED);
-			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_HIGH,
-					     mp, dip);
+			xfs_verifier_error(bp);
 #ifdef DEBUG
 			xfs_alert(mp,
 				"bad inode magic/vsn daddr %lld #%d (magic=%x)",
diff --git a/libxfs/xfs_sb.c b/libxfs/xfs_sb.c
index db267c2..7ee4612 100644
--- a/libxfs/xfs_sb.c
+++ b/libxfs/xfs_sb.c
@@ -569,7 +569,7 @@ xfs_sb_read_verify(
 			/* Only fail bad secondaries on a known V5 filesystem */
 			if (bp->b_bn == XFS_SB_DADDR ||
 			    xfs_sb_version_hascrc(&mp->m_sb)) {
-				error = EFSCORRUPTED;
+				error = EFSBADCRC;
 				goto out_error;
 			}
 		}
@@ -578,10 +578,9 @@ xfs_sb_read_verify(
 
 out_error:
 	if (error) {
-		if (error == EFSCORRUPTED)
-			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW,
-					     mp, bp->b_addr);
 		xfs_buf_ioerror(bp, error);
+		if (error == EFSCORRUPTED || error == EFSBADCRC)
+			xfs_verifier_error(bp);
 	}
 }
 
@@ -616,9 +615,8 @@ xfs_sb_write_verify(
 
 	error = xfs_sb_verify(bp, false);
 	if (error) {
-		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW,
-				     mp, bp->b_addr);
 		xfs_buf_ioerror(bp, error);
+		xfs_verifier_error(bp);
 		return;
 	}
 
diff --git a/libxfs/xfs_symlink_remote.c b/libxfs/xfs_symlink_remote.c
index b59bf14..ebf60ac 100644
--- a/libxfs/xfs_symlink_remote.c
+++ b/libxfs/xfs_symlink_remote.c
@@ -116,11 +116,13 @@ xfs_symlink_read_verify(
 	if (!xfs_sb_version_hascrc(&mp->m_sb))
 		return;
 
-	if (!xfs_buf_verify_cksum(bp, XFS_SYMLINK_CRC_OFF) ||
-	    !xfs_symlink_verify(bp)) {
-		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp, bp->b_addr);
+	if (!xfs_buf_verify_cksum(bp, XFS_SYMLINK_CRC_OFF))
+		xfs_buf_ioerror(bp, EFSBADCRC);
+	else if (!xfs_symlink_verify(bp))
 		xfs_buf_ioerror(bp, EFSCORRUPTED);
-	}
+
+	if (bp->b_error)
+		xfs_verifier_error(bp);
 }
 
 static void
@@ -135,8 +137,8 @@ xfs_symlink_write_verify(
 		return;
 
 	if (!xfs_symlink_verify(bp)) {
-		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp, bp->b_addr);
 		xfs_buf_ioerror(bp, EFSCORRUPTED);
+		xfs_verifier_error(bp);
 		return;
 	}
 
-- 
1.9.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
