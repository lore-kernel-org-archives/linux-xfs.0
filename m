Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:38954 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750737AbdLMX6l (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 13 Dec 2017 18:58:41 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.21/8.16.0.21) with SMTP id vBDNl93M024466
        for <linux-xfs@vger.kernel.org>; Wed, 13 Dec 2017 23:58:41 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp2120.oracle.com with ESMTP id 2eudq605hf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 13 Dec 2017 23:58:41 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id vBDNweKf002150
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 13 Dec 2017 23:58:40 GMT
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id vBDNwedV011807
        for <linux-xfs@vger.kernel.org>; Wed, 13 Dec 2017 23:58:40 GMT
Subject: [PATCH 04/13] xfs: refactor verifier callers to print address of
 failing check
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 13 Dec 2017 15:58:37 -0800
Message-ID: <151320951732.30654.12381419566973424218.stgit@magnolia>
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

Refactor the callers of verifiers to print the instruction address of a
failing check.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_alloc.c          |   28 +++++++++++++++++-----------
 fs/xfs/libxfs/xfs_alloc_btree.c    |   15 ++++++++++-----
 fs/xfs/libxfs/xfs_attr_leaf.c      |   13 ++++++++-----
 fs/xfs/libxfs/xfs_attr_remote.c    |   13 ++++++++-----
 fs/xfs/libxfs/xfs_bmap_btree.c     |   15 ++++++++++-----
 fs/xfs/libxfs/xfs_da_btree.c       |   12 ++++++++----
 fs/xfs/libxfs/xfs_dir2_block.c     |   13 ++++++++-----
 fs/xfs/libxfs/xfs_dir2_data.c      |   17 ++++++++++-------
 fs/xfs/libxfs/xfs_dir2_leaf.c      |   13 ++++++++-----
 fs/xfs/libxfs/xfs_dir2_node.c      |   20 ++++++++++++--------
 fs/xfs/libxfs/xfs_dquot_buf.c      |    4 ++--
 fs/xfs/libxfs/xfs_ialloc.c         |   15 +++++++++------
 fs/xfs/libxfs/xfs_ialloc_btree.c   |   15 ++++++++++-----
 fs/xfs/libxfs/xfs_inode_buf.c      |   24 +++++++++++++-----------
 fs/xfs/libxfs/xfs_refcount_btree.c |   15 ++++++++++-----
 fs/xfs/libxfs/xfs_rmap_btree.c     |   15 ++++++++++-----
 fs/xfs/libxfs/xfs_sb.c             |    4 ++--
 fs/xfs/libxfs/xfs_symlink_remote.c |   13 ++++++++-----
 fs/xfs/xfs_error.c                 |    6 ++++--
 fs/xfs/xfs_error.h                 |    2 +-
 20 files changed, 168 insertions(+), 104 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 81ed3c8..d600dcb 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -557,6 +557,7 @@ xfs_agfl_read_verify(
 	struct xfs_buf	*bp)
 {
 	struct xfs_mount *mp = bp->b_target->bt_mount;
+	xfs_failaddr_t	fa;
 
 	/*
 	 * There is no verification of non-crc AGFLs because mkfs does not
@@ -567,13 +568,14 @@ xfs_agfl_read_verify(
 	if (!xfs_sb_version_hascrc(&mp->m_sb))
 		return;
 
-	if (!xfs_buf_verify_cksum(bp, XFS_AGFL_CRC_OFF))
+	if (!xfs_buf_verify_cksum(bp, XFS_AGFL_CRC_OFF)) {
+		fa = __this_address;
 		xfs_buf_ioerror(bp, -EFSBADCRC);
-	else if (xfs_agfl_verify(bp))
+	} else if ((fa = xfs_agfl_verify(bp)))
 		xfs_buf_ioerror(bp, -EFSCORRUPTED);
 
 	if (bp->b_error)
-		xfs_verifier_error(bp);
+		xfs_verifier_error(bp, fa);
 }
 
 static void
@@ -582,14 +584,15 @@ xfs_agfl_write_verify(
 {
 	struct xfs_mount *mp = bp->b_target->bt_mount;
 	struct xfs_buf_log_item	*bip = bp->b_fspriv;
+	xfs_failaddr_t		fa;
 
 	/* no verification of non-crc AGFLs */
 	if (!xfs_sb_version_hascrc(&mp->m_sb))
 		return;
 
-	if (xfs_agfl_verify(bp)) {
+	if ((fa = xfs_agfl_verify(bp))) {
 		xfs_buf_ioerror(bp, -EFSCORRUPTED);
-		xfs_verifier_error(bp);
+		xfs_verifier_error(bp, fa);
 		return;
 	}
 
@@ -2459,16 +2462,18 @@ xfs_agf_read_verify(
 	struct xfs_buf	*bp)
 {
 	struct xfs_mount *mp = bp->b_target->bt_mount;
+	xfs_failaddr_t	fa;
 
 	if (xfs_sb_version_hascrc(&mp->m_sb) &&
-	    !xfs_buf_verify_cksum(bp, XFS_AGF_CRC_OFF))
+	    !xfs_buf_verify_cksum(bp, XFS_AGF_CRC_OFF)) {
+		fa = __this_address;
 		xfs_buf_ioerror(bp, -EFSBADCRC);
-	else if (XFS_TEST_ERROR(xfs_agf_verify(mp, bp), mp,
-				XFS_ERRTAG_ALLOC_READ_AGF))
+	} else if (XFS_TEST_ERROR((fa = xfs_agf_verify(mp, bp)), mp,
+				  XFS_ERRTAG_ALLOC_READ_AGF))
 		xfs_buf_ioerror(bp, -EFSCORRUPTED);
 
 	if (bp->b_error)
-		xfs_verifier_error(bp);
+		xfs_verifier_error(bp, fa);
 }
 
 static void
@@ -2477,10 +2482,11 @@ xfs_agf_write_verify(
 {
 	struct xfs_mount *mp = bp->b_target->bt_mount;
 	struct xfs_buf_log_item	*bip = bp->b_fspriv;
+	xfs_failaddr_t		fa;
 
-	if (xfs_agf_verify(mp, bp)) {
+	if ((fa = xfs_agf_verify(mp, bp))) {
 		xfs_buf_ioerror(bp, -EFSCORRUPTED);
-		xfs_verifier_error(bp);
+		xfs_verifier_error(bp, fa);
 		return;
 	}
 
diff --git a/fs/xfs/libxfs/xfs_alloc_btree.c b/fs/xfs/libxfs/xfs_alloc_btree.c
index 153fe98..a646fc4 100644
--- a/fs/xfs/libxfs/xfs_alloc_btree.c
+++ b/fs/xfs/libxfs/xfs_alloc_btree.c
@@ -364,14 +364,17 @@ static void
 xfs_allocbt_read_verify(
 	struct xfs_buf	*bp)
 {
-	if (!xfs_btree_sblock_verify_crc(bp))
+	xfs_failaddr_t	fa;
+
+	if (!xfs_btree_sblock_verify_crc(bp)) {
+		fa = __this_address;
 		xfs_buf_ioerror(bp, -EFSBADCRC);
-	else if (xfs_allocbt_verify(bp))
+	} else if ((fa = xfs_allocbt_verify(bp)))
 		xfs_buf_ioerror(bp, -EFSCORRUPTED);
 
 	if (bp->b_error) {
 		trace_xfs_btree_corrupt(bp, _RET_IP_);
-		xfs_verifier_error(bp);
+		xfs_verifier_error(bp, fa);
 	}
 }
 
@@ -379,10 +382,12 @@ static void
 xfs_allocbt_write_verify(
 	struct xfs_buf	*bp)
 {
-	if (xfs_allocbt_verify(bp)) {
+	xfs_failaddr_t	fa;
+
+	if ((fa = xfs_allocbt_verify(bp))) {
 		trace_xfs_btree_corrupt(bp, _RET_IP_);
 		xfs_buf_ioerror(bp, -EFSCORRUPTED);
-		xfs_verifier_error(bp);
+		xfs_verifier_error(bp, fa);
 		return;
 	}
 	xfs_btree_sblock_calc_crc(bp);
diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index 2c675f5..1274872 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -295,10 +295,11 @@ xfs_attr3_leaf_write_verify(
 	struct xfs_mount	*mp = bp->b_target->bt_mount;
 	struct xfs_buf_log_item	*bip = bp->b_fspriv;
 	struct xfs_attr3_leaf_hdr *hdr3 = bp->b_addr;
+	xfs_failaddr_t		fa;
 
-	if (xfs_attr3_leaf_verify(bp)) {
+	if ((fa = xfs_attr3_leaf_verify(bp))) {
 		xfs_buf_ioerror(bp, -EFSCORRUPTED);
-		xfs_verifier_error(bp);
+		xfs_verifier_error(bp, fa);
 		return;
 	}
 
@@ -322,15 +323,17 @@ xfs_attr3_leaf_read_verify(
 	struct xfs_buf		*bp)
 {
 	struct xfs_mount	*mp = bp->b_target->bt_mount;
+	xfs_failaddr_t		fa;
 
 	if (xfs_sb_version_hascrc(&mp->m_sb) &&
-	     !xfs_buf_verify_cksum(bp, XFS_ATTR3_LEAF_CRC_OFF))
+	     !xfs_buf_verify_cksum(bp, XFS_ATTR3_LEAF_CRC_OFF)) {
+		fa = __this_address;
 		xfs_buf_ioerror(bp, -EFSBADCRC);
-	else if (xfs_attr3_leaf_verify(bp))
+	} else if ((fa = xfs_attr3_leaf_verify(bp)))
 		xfs_buf_ioerror(bp, -EFSCORRUPTED);
 
 	if (bp->b_error)
-		xfs_verifier_error(bp);
+		xfs_verifier_error(bp, fa);
 }
 
 const struct xfs_buf_ops xfs_attr3_leaf_buf_ops = {
diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
index 8647fda..d4d2902 100644
--- a/fs/xfs/libxfs/xfs_attr_remote.c
+++ b/fs/xfs/libxfs/xfs_attr_remote.c
@@ -122,6 +122,7 @@ xfs_attr3_rmt_read_verify(
 {
 	struct xfs_mount *mp = bp->b_target->bt_mount;
 	char		*ptr;
+	xfs_failaddr_t	fa;
 	int		len;
 	xfs_daddr_t	bno;
 	int		blksize = mp->m_attr_geo->blksize;
@@ -137,10 +138,11 @@ xfs_attr3_rmt_read_verify(
 
 	while (len > 0) {
 		if (!xfs_verify_cksum(ptr, blksize, XFS_ATTR3_RMT_CRC_OFF)) {
+			fa = __this_address;
 			xfs_buf_ioerror(bp, -EFSBADCRC);
 			break;
 		}
-		if (xfs_attr3_rmt_verify(mp, ptr, blksize, bno)) {
+		if ((fa = xfs_attr3_rmt_verify(mp, ptr, blksize, bno))) {
 			xfs_buf_ioerror(bp, -EFSCORRUPTED);
 			break;
 		}
@@ -150,7 +152,7 @@ xfs_attr3_rmt_read_verify(
 	}
 
 	if (bp->b_error)
-		xfs_verifier_error(bp);
+		xfs_verifier_error(bp, fa);
 	else
 		ASSERT(len == 0);
 }
@@ -160,6 +162,7 @@ xfs_attr3_rmt_write_verify(
 	struct xfs_buf	*bp)
 {
 	struct xfs_mount *mp = bp->b_target->bt_mount;
+	xfs_failaddr_t	fa;
 	int		blksize = mp->m_attr_geo->blksize;
 	char		*ptr;
 	int		len;
@@ -177,9 +180,9 @@ xfs_attr3_rmt_write_verify(
 	while (len > 0) {
 		struct xfs_attr3_rmt_hdr *rmt = (struct xfs_attr3_rmt_hdr *)ptr;
 
-		if (xfs_attr3_rmt_verify(mp, ptr, blksize, bno)) {
+		if ((fa = xfs_attr3_rmt_verify(mp, ptr, blksize, bno))) {
 			xfs_buf_ioerror(bp, -EFSCORRUPTED);
-			xfs_verifier_error(bp);
+			xfs_verifier_error(bp, fa);
 			return;
 		}
 
@@ -189,7 +192,7 @@ xfs_attr3_rmt_write_verify(
 		 */
 		if (rmt->rm_lsn != cpu_to_be64(NULLCOMMITLSN)) {
 			xfs_buf_ioerror(bp, -EFSCORRUPTED);
-			xfs_verifier_error(bp);
+			xfs_verifier_error(bp, __this_address);
 			return;
 		}
 		xfs_update_cksum(ptr, blksize, XFS_ATTR3_RMT_CRC_OFF);
diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
index d44f1ad..c1ddb4c 100644
--- a/fs/xfs/libxfs/xfs_bmap_btree.c
+++ b/fs/xfs/libxfs/xfs_bmap_btree.c
@@ -468,14 +468,17 @@ static void
 xfs_bmbt_read_verify(
 	struct xfs_buf	*bp)
 {
-	if (!xfs_btree_lblock_verify_crc(bp))
+	xfs_failaddr_t	fa;
+
+	if (!xfs_btree_lblock_verify_crc(bp)) {
+		fa = __this_address;
 		xfs_buf_ioerror(bp, -EFSBADCRC);
-	else if (xfs_bmbt_verify(bp))
+	} else if ((fa = xfs_bmbt_verify(bp)))
 		xfs_buf_ioerror(bp, -EFSCORRUPTED);
 
 	if (bp->b_error) {
 		trace_xfs_btree_corrupt(bp, _RET_IP_);
-		xfs_verifier_error(bp);
+		xfs_verifier_error(bp, fa);
 	}
 }
 
@@ -483,10 +486,12 @@ static void
 xfs_bmbt_write_verify(
 	struct xfs_buf	*bp)
 {
-	if (xfs_bmbt_verify(bp)) {
+	xfs_failaddr_t	fa;
+
+	if ((fa = xfs_bmbt_verify(bp))) {
 		trace_xfs_btree_corrupt(bp, _RET_IP_);
 		xfs_buf_ioerror(bp, -EFSCORRUPTED);
-		xfs_verifier_error(bp);
+		xfs_verifier_error(bp, fa);
 		return;
 	}
 	xfs_btree_lblock_calc_crc(bp);
diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
index 2d06036..6d6a9ef 100644
--- a/fs/xfs/libxfs/xfs_da_btree.c
+++ b/fs/xfs/libxfs/xfs_da_btree.c
@@ -184,10 +184,11 @@ xfs_da3_node_write_verify(
 	struct xfs_mount	*mp = bp->b_target->bt_mount;
 	struct xfs_buf_log_item	*bip = bp->b_fspriv;
 	struct xfs_da3_node_hdr *hdr3 = bp->b_addr;
+	xfs_failaddr_t		fa;
 
-	if (xfs_da3_node_verify(bp)) {
+	if ((fa = xfs_da3_node_verify(bp))) {
 		xfs_buf_ioerror(bp, -EFSCORRUPTED);
-		xfs_verifier_error(bp);
+		xfs_verifier_error(bp, fa);
 		return;
 	}
 
@@ -211,16 +212,18 @@ xfs_da3_node_read_verify(
 	struct xfs_buf		*bp)
 {
 	struct xfs_da_blkinfo	*info = bp->b_addr;
+	xfs_failaddr_t		fa;
 
 	switch (be16_to_cpu(info->magic)) {
 		case XFS_DA3_NODE_MAGIC:
 			if (!xfs_buf_verify_cksum(bp, XFS_DA3_NODE_CRC_OFF)) {
+				fa = __this_address;
 				xfs_buf_ioerror(bp, -EFSBADCRC);
 				break;
 			}
 			/* fall through */
 		case XFS_DA_NODE_MAGIC:
-			if (xfs_da3_node_verify(bp)) {
+			if ((fa = xfs_da3_node_verify(bp))) {
 				xfs_buf_ioerror(bp, -EFSCORRUPTED);
 				break;
 			}
@@ -236,12 +239,13 @@ xfs_da3_node_read_verify(
 			bp->b_ops->verify_read(bp);
 			return;
 		default:
+			fa = __this_address;
 			xfs_buf_ioerror(bp, -EFSCORRUPTED);
 			break;
 	}
 
 	/* corrupt block */
-	xfs_verifier_error(bp);
+	xfs_verifier_error(bp, fa);
 }
 
 const struct xfs_buf_ops xfs_da3_node_buf_ops = {
diff --git a/fs/xfs/libxfs/xfs_dir2_block.c b/fs/xfs/libxfs/xfs_dir2_block.c
index ceae3ad..7a18777 100644
--- a/fs/xfs/libxfs/xfs_dir2_block.c
+++ b/fs/xfs/libxfs/xfs_dir2_block.c
@@ -86,15 +86,17 @@ xfs_dir3_block_read_verify(
 	struct xfs_buf	*bp)
 {
 	struct xfs_mount	*mp = bp->b_target->bt_mount;
+	xfs_failaddr_t		fa;
 
 	if (xfs_sb_version_hascrc(&mp->m_sb) &&
-	     !xfs_buf_verify_cksum(bp, XFS_DIR3_DATA_CRC_OFF))
+	     !xfs_buf_verify_cksum(bp, XFS_DIR3_DATA_CRC_OFF)) {
+		fa = __this_address;
 		xfs_buf_ioerror(bp, -EFSBADCRC);
-	else if (xfs_dir3_block_verify(bp))
+	} else if ((fa = xfs_dir3_block_verify(bp)))
 		xfs_buf_ioerror(bp, -EFSCORRUPTED);
 
 	if (bp->b_error)
-		xfs_verifier_error(bp);
+		xfs_verifier_error(bp, fa);
 }
 
 static void
@@ -104,10 +106,11 @@ xfs_dir3_block_write_verify(
 	struct xfs_mount	*mp = bp->b_target->bt_mount;
 	struct xfs_buf_log_item	*bip = bp->b_fspriv;
 	struct xfs_dir3_blk_hdr	*hdr3 = bp->b_addr;
+	xfs_failaddr_t		fa;
 
-	if (xfs_dir3_block_verify(bp)) {
+	if ((fa = xfs_dir3_block_verify(bp))) {
 		xfs_buf_ioerror(bp, -EFSCORRUPTED);
-		xfs_verifier_error(bp);
+		xfs_verifier_error(bp, fa);
 		return;
 	}
 
diff --git a/fs/xfs/libxfs/xfs_dir2_data.c b/fs/xfs/libxfs/xfs_dir2_data.c
index cd3c1ee..f31bfd9 100644
--- a/fs/xfs/libxfs/xfs_dir2_data.c
+++ b/fs/xfs/libxfs/xfs_dir2_data.c
@@ -268,7 +268,7 @@ xfs_dir3_data_reada_verify(
 		return;
 	default:
 		xfs_buf_ioerror(bp, -EFSCORRUPTED);
-		xfs_verifier_error(bp);
+		xfs_verifier_error(bp, __this_address);
 		break;
 	}
 }
@@ -278,15 +278,17 @@ xfs_dir3_data_read_verify(
 	struct xfs_buf	*bp)
 {
 	struct xfs_mount	*mp = bp->b_target->bt_mount;
+	xfs_failaddr_t		fa;
 
 	if (xfs_sb_version_hascrc(&mp->m_sb) &&
-	     !xfs_buf_verify_cksum(bp, XFS_DIR3_DATA_CRC_OFF))
-		 xfs_buf_ioerror(bp, -EFSBADCRC);
-	else if (xfs_dir3_data_verify(bp))
+	     !xfs_buf_verify_cksum(bp, XFS_DIR3_DATA_CRC_OFF)) {
+		fa = __this_address;
+		xfs_buf_ioerror(bp, -EFSBADCRC);
+	} else if ((fa = xfs_dir3_data_verify(bp)))
 		xfs_buf_ioerror(bp, -EFSCORRUPTED);
 
 	if (bp->b_error)
-		xfs_verifier_error(bp);
+		xfs_verifier_error(bp, fa);
 }
 
 static void
@@ -296,10 +298,11 @@ xfs_dir3_data_write_verify(
 	struct xfs_mount	*mp = bp->b_target->bt_mount;
 	struct xfs_buf_log_item	*bip = bp->b_fspriv;
 	struct xfs_dir3_blk_hdr	*hdr3 = bp->b_addr;
+	xfs_failaddr_t		fa;
 
-	if (xfs_dir3_data_verify(bp)) {
+	if ((fa = xfs_dir3_data_verify(bp))) {
 		xfs_buf_ioerror(bp, -EFSCORRUPTED);
-		xfs_verifier_error(bp);
+		xfs_verifier_error(bp, fa);
 		return;
 	}
 
diff --git a/fs/xfs/libxfs/xfs_dir2_leaf.c b/fs/xfs/libxfs/xfs_dir2_leaf.c
index 87565b6..e3fad8d 100644
--- a/fs/xfs/libxfs/xfs_dir2_leaf.c
+++ b/fs/xfs/libxfs/xfs_dir2_leaf.c
@@ -181,15 +181,17 @@ __read_verify(
 	uint16_t	magic)
 {
 	struct xfs_mount	*mp = bp->b_target->bt_mount;
+	xfs_failaddr_t		fa;
 
 	if (xfs_sb_version_hascrc(&mp->m_sb) &&
-	     !xfs_buf_verify_cksum(bp, XFS_DIR3_LEAF_CRC_OFF))
+	     !xfs_buf_verify_cksum(bp, XFS_DIR3_LEAF_CRC_OFF)) {
+		fa = __this_address;
 		xfs_buf_ioerror(bp, -EFSBADCRC);
-	else if (xfs_dir3_leaf_verify(bp, magic))
+	} else if ((fa = xfs_dir3_leaf_verify(bp, magic)))
 		xfs_buf_ioerror(bp, -EFSCORRUPTED);
 
 	if (bp->b_error)
-		xfs_verifier_error(bp);
+		xfs_verifier_error(bp, fa);
 }
 
 static void
@@ -200,10 +202,11 @@ __write_verify(
 	struct xfs_mount	*mp = bp->b_target->bt_mount;
 	struct xfs_buf_log_item	*bip = bp->b_fspriv;
 	struct xfs_dir3_leaf_hdr *hdr3 = bp->b_addr;
+	xfs_failaddr_t		fa;
 
-	if (xfs_dir3_leaf_verify(bp, magic)) {
+	if ((fa = xfs_dir3_leaf_verify(bp, magic))) {
 		xfs_buf_ioerror(bp, -EFSCORRUPTED);
-		xfs_verifier_error(bp);
+		xfs_verifier_error(bp, fa);
 		return;
 	}
 
diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
index 00ded0a..8a6a2e1 100644
--- a/fs/xfs/libxfs/xfs_dir2_node.c
+++ b/fs/xfs/libxfs/xfs_dir2_node.c
@@ -115,15 +115,17 @@ xfs_dir3_free_read_verify(
 	struct xfs_buf	*bp)
 {
 	struct xfs_mount	*mp = bp->b_target->bt_mount;
+	xfs_failaddr_t		fa;
 
 	if (xfs_sb_version_hascrc(&mp->m_sb) &&
-	    !xfs_buf_verify_cksum(bp, XFS_DIR3_FREE_CRC_OFF))
+	    !xfs_buf_verify_cksum(bp, XFS_DIR3_FREE_CRC_OFF)) {
+		fa = __this_address;
 		xfs_buf_ioerror(bp, -EFSBADCRC);
-	else if (xfs_dir3_free_verify(bp))
+	} else if ((fa = xfs_dir3_free_verify(bp)))
 		xfs_buf_ioerror(bp, -EFSCORRUPTED);
 
 	if (bp->b_error)
-		xfs_verifier_error(bp);
+		xfs_verifier_error(bp, fa);
 }
 
 static void
@@ -133,10 +135,11 @@ xfs_dir3_free_write_verify(
 	struct xfs_mount	*mp = bp->b_target->bt_mount;
 	struct xfs_buf_log_item	*bip = bp->b_fspriv;
 	struct xfs_dir3_blk_hdr	*hdr3 = bp->b_addr;
+	xfs_failaddr_t		fa;
 
-	if (xfs_dir3_free_verify(bp)) {
+	if ((fa = xfs_dir3_free_verify(bp))) {
 		xfs_buf_ioerror(bp, -EFSCORRUPTED);
-		xfs_verifier_error(bp);
+		xfs_verifier_error(bp, fa);
 		return;
 	}
 
@@ -156,7 +159,7 @@ const struct xfs_buf_ops xfs_dir3_free_buf_ops = {
 };
 
 /* Everything ok in the free block header? */
-static bool
+static xfs_failaddr_t
 xfs_dir3_free_header_check(
 	struct xfs_inode	*dp,
 	xfs_dablk_t		fbno,
@@ -200,6 +203,7 @@ __xfs_dir3_free_read(
 	xfs_daddr_t		mappedbno,
 	struct xfs_buf		**bpp)
 {
+	xfs_failaddr_t		fa;
 	int			err;
 
 	err = xfs_da_read_buf(tp, dp, fbno, mappedbno, bpp,
@@ -208,9 +212,9 @@ __xfs_dir3_free_read(
 		return err;
 
 	/* Check things that we can't do in the verifier. */
-	if (xfs_dir3_free_header_check(dp, fbno, *bpp)) {
+	if ((fa = xfs_dir3_free_header_check(dp, fbno, *bpp))) {
 		xfs_buf_ioerror(*bpp, -EFSCORRUPTED);
-		xfs_verifier_error(*bpp);
+		xfs_verifier_error(*bpp, fa);
 		xfs_trans_brelse(tp, *bpp);
 		return -EFSCORRUPTED;
 	}
diff --git a/fs/xfs/libxfs/xfs_dquot_buf.c b/fs/xfs/libxfs/xfs_dquot_buf.c
index 747085b..5561011 100644
--- a/fs/xfs/libxfs/xfs_dquot_buf.c
+++ b/fs/xfs/libxfs/xfs_dquot_buf.c
@@ -254,7 +254,7 @@ xfs_dquot_buf_read_verify(
 		xfs_buf_ioerror(bp, -EFSCORRUPTED);
 
 	if (bp->b_error)
-		xfs_verifier_error(bp);
+		xfs_verifier_error(bp, __this_address);
 }
 
 /*
@@ -289,7 +289,7 @@ xfs_dquot_buf_write_verify(
 
 	if (!xfs_dquot_buf_verify(mp, bp, XFS_QMOPT_DOWARN)) {
 		xfs_buf_ioerror(bp, -EFSCORRUPTED);
-		xfs_verifier_error(bp);
+		xfs_verifier_error(bp, __this_address);
 		return;
 	}
 }
diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index 0186cc0..a616212 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -2545,16 +2545,18 @@ xfs_agi_read_verify(
 	struct xfs_buf	*bp)
 {
 	struct xfs_mount *mp = bp->b_target->bt_mount;
+	xfs_failaddr_t	fa;
 
 	if (xfs_sb_version_hascrc(&mp->m_sb) &&
-	    !xfs_buf_verify_cksum(bp, XFS_AGI_CRC_OFF))
+	    !xfs_buf_verify_cksum(bp, XFS_AGI_CRC_OFF)) {
+		fa = __this_address;
 		xfs_buf_ioerror(bp, -EFSBADCRC);
-	else if (XFS_TEST_ERROR(xfs_agi_verify(bp), mp,
-				XFS_ERRTAG_IALLOC_READ_AGI))
+	} else if (XFS_TEST_ERROR((fa = xfs_agi_verify(bp)), mp,
+				  XFS_ERRTAG_IALLOC_READ_AGI))
 		xfs_buf_ioerror(bp, -EFSCORRUPTED);
 
 	if (bp->b_error)
-		xfs_verifier_error(bp);
+		xfs_verifier_error(bp, fa);
 }
 
 static void
@@ -2563,10 +2565,11 @@ xfs_agi_write_verify(
 {
 	struct xfs_mount *mp = bp->b_target->bt_mount;
 	struct xfs_buf_log_item	*bip = bp->b_fspriv;
+	xfs_failaddr_t		fa;
 
-	if (xfs_agi_verify(bp)) {
+	if ((fa = xfs_agi_verify(bp))) {
 		xfs_buf_ioerror(bp, -EFSCORRUPTED);
-		xfs_verifier_error(bp);
+		xfs_verifier_error(bp, fa);
 		return;
 	}
 
diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.c b/fs/xfs/libxfs/xfs_ialloc_btree.c
index d9267d8..032613a 100644
--- a/fs/xfs/libxfs/xfs_ialloc_btree.c
+++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
@@ -294,14 +294,17 @@ static void
 xfs_inobt_read_verify(
 	struct xfs_buf	*bp)
 {
-	if (!xfs_btree_sblock_verify_crc(bp))
+	xfs_failaddr_t	fa;
+
+	if (!xfs_btree_sblock_verify_crc(bp)) {
+		fa = __this_address;
 		xfs_buf_ioerror(bp, -EFSBADCRC);
-	else if (xfs_inobt_verify(bp))
+	} else if ((fa = xfs_inobt_verify(bp)))
 		xfs_buf_ioerror(bp, -EFSCORRUPTED);
 
 	if (bp->b_error) {
 		trace_xfs_btree_corrupt(bp, _RET_IP_);
-		xfs_verifier_error(bp);
+		xfs_verifier_error(bp, fa);
 	}
 }
 
@@ -309,10 +312,12 @@ static void
 xfs_inobt_write_verify(
 	struct xfs_buf	*bp)
 {
-	if (xfs_inobt_verify(bp)) {
+	xfs_failaddr_t	fa;
+
+	if ((fa = xfs_inobt_verify(bp))) {
 		trace_xfs_btree_corrupt(bp, _RET_IP_);
 		xfs_buf_ioerror(bp, -EFSCORRUPTED);
-		xfs_verifier_error(bp);
+		xfs_verifier_error(bp, fa);
 		return;
 	}
 	xfs_btree_sblock_calc_crc(bp);
diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index 145c47d..a965448 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -114,7 +114,7 @@ xfs_inode_buf_verify(
 			}
 
 			xfs_buf_ioerror(bp, -EFSCORRUPTED);
-			xfs_verifier_error(bp);
+			xfs_verifier_error(bp, __this_address);
 #ifdef DEBUG
 			xfs_alert(mp,
 				"bad inode magic/vsn daddr %lld #%d (magic=%x)",
@@ -469,14 +469,15 @@ xfs_dinode_calc_crc(
  */
 int
 xfs_iread(
-	xfs_mount_t	*mp,
-	xfs_trans_t	*tp,
-	xfs_inode_t	*ip,
-	uint		iget_flags)
+	struct xfs_mount	*mp,
+	struct xfs_trans	*tp,
+	struct xfs_inode	*ip,
+	uint			iget_flags)
 {
-	xfs_buf_t	*bp;
-	xfs_dinode_t	*dip;
-	int		error;
+	struct xfs_buf		*bp;
+	struct xfs_dinode	*dip;
+	xfs_failaddr_t		fa;
+	int			error;
 
 	/*
 	 * Fill in the location information in the in-core inode.
@@ -507,9 +508,10 @@ xfs_iread(
 		return error;
 
 	/* even unallocated inodes are verified */
-	if (xfs_dinode_verify(mp, ip->i_ino, dip)) {
-		xfs_alert(mp, "%s: validation failed for inode %lld",
-				__func__, ip->i_ino);
+	fa = xfs_dinode_verify(mp, ip->i_ino, dip);
+	if (fa) {
+		xfs_alert(mp, "%s: validation failed for inode %lld at %pF",
+				__func__, ip->i_ino, fa);
 
 		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp, dip);
 		error = -EFSCORRUPTED;
diff --git a/fs/xfs/libxfs/xfs_refcount_btree.c b/fs/xfs/libxfs/xfs_refcount_btree.c
index 66ecdb91..68d4021 100644
--- a/fs/xfs/libxfs/xfs_refcount_btree.c
+++ b/fs/xfs/libxfs/xfs_refcount_btree.c
@@ -255,14 +255,17 @@ STATIC void
 xfs_refcountbt_read_verify(
 	struct xfs_buf	*bp)
 {
-	if (!xfs_btree_sblock_verify_crc(bp))
+	xfs_failaddr_t	fa;
+
+	if (!xfs_btree_sblock_verify_crc(bp)) {
+		fa = __this_address;
 		xfs_buf_ioerror(bp, -EFSBADCRC);
-	else if (xfs_refcountbt_verify(bp))
+	} else if ((fa = xfs_refcountbt_verify(bp)))
 		xfs_buf_ioerror(bp, -EFSCORRUPTED);
 
 	if (bp->b_error) {
 		trace_xfs_btree_corrupt(bp, _RET_IP_);
-		xfs_verifier_error(bp);
+		xfs_verifier_error(bp, fa);
 	}
 }
 
@@ -270,10 +273,12 @@ STATIC void
 xfs_refcountbt_write_verify(
 	struct xfs_buf	*bp)
 {
-	if (xfs_refcountbt_verify(bp)) {
+	xfs_failaddr_t	fa;
+
+	if ((fa = xfs_refcountbt_verify(bp))) {
 		trace_xfs_btree_corrupt(bp, _RET_IP_);
 		xfs_buf_ioerror(bp, -EFSCORRUPTED);
-		xfs_verifier_error(bp);
+		xfs_verifier_error(bp, fa);
 		return;
 	}
 	xfs_btree_sblock_calc_crc(bp);
diff --git a/fs/xfs/libxfs/xfs_rmap_btree.c b/fs/xfs/libxfs/xfs_rmap_btree.c
index 506482f..ab358b9 100644
--- a/fs/xfs/libxfs/xfs_rmap_btree.c
+++ b/fs/xfs/libxfs/xfs_rmap_btree.c
@@ -347,14 +347,17 @@ static void
 xfs_rmapbt_read_verify(
 	struct xfs_buf	*bp)
 {
-	if (!xfs_btree_sblock_verify_crc(bp))
+	xfs_failaddr_t	fa;
+
+	if (!xfs_btree_sblock_verify_crc(bp)) {
+		fa = __this_address;
 		xfs_buf_ioerror(bp, -EFSBADCRC);
-	else if (xfs_rmapbt_verify(bp))
+	} else if ((fa = xfs_rmapbt_verify(bp)))
 		xfs_buf_ioerror(bp, -EFSCORRUPTED);
 
 	if (bp->b_error) {
 		trace_xfs_btree_corrupt(bp, _RET_IP_);
-		xfs_verifier_error(bp);
+		xfs_verifier_error(bp, fa);
 	}
 }
 
@@ -362,10 +365,12 @@ static void
 xfs_rmapbt_write_verify(
 	struct xfs_buf	*bp)
 {
-	if (xfs_rmapbt_verify(bp)) {
+	xfs_failaddr_t	fa;
+
+	if ((fa = xfs_rmapbt_verify(bp))) {
 		trace_xfs_btree_corrupt(bp, _RET_IP_);
 		xfs_buf_ioerror(bp, -EFSCORRUPTED);
-		xfs_verifier_error(bp);
+		xfs_verifier_error(bp, fa);
 		return;
 	}
 	xfs_btree_sblock_calc_crc(bp);
diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index 9b5aae2..9b49640 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -643,7 +643,7 @@ xfs_sb_read_verify(
 	if (error) {
 		xfs_buf_ioerror(bp, error);
 		if (error == -EFSCORRUPTED || error == -EFSBADCRC)
-			xfs_verifier_error(bp);
+			xfs_verifier_error(bp, __this_address);
 	}
 }
 
@@ -679,7 +679,7 @@ xfs_sb_write_verify(
 	error = xfs_sb_verify(bp, false);
 	if (error) {
 		xfs_buf_ioerror(bp, error);
-		xfs_verifier_error(bp);
+		xfs_verifier_error(bp, __this_address);
 		return;
 	}
 
diff --git a/fs/xfs/libxfs/xfs_symlink_remote.c b/fs/xfs/libxfs/xfs_symlink_remote.c
index 7ac900b..b6ef6cb 100644
--- a/fs/xfs/libxfs/xfs_symlink_remote.c
+++ b/fs/xfs/libxfs/xfs_symlink_remote.c
@@ -129,18 +129,20 @@ xfs_symlink_read_verify(
 	struct xfs_buf	*bp)
 {
 	struct xfs_mount *mp = bp->b_target->bt_mount;
+	xfs_failaddr_t	fa;
 
 	/* no verification of non-crc buffers */
 	if (!xfs_sb_version_hascrc(&mp->m_sb))
 		return;
 
-	if (!xfs_buf_verify_cksum(bp, XFS_SYMLINK_CRC_OFF))
+	if (!xfs_buf_verify_cksum(bp, XFS_SYMLINK_CRC_OFF)) {
+		fa = __this_address;
 		xfs_buf_ioerror(bp, -EFSBADCRC);
-	else if (xfs_symlink_verify(bp))
+	} else if ((fa = xfs_symlink_verify(bp)))
 		xfs_buf_ioerror(bp, -EFSCORRUPTED);
 
 	if (bp->b_error)
-		xfs_verifier_error(bp);
+		xfs_verifier_error(bp, fa);
 }
 
 static void
@@ -149,14 +151,15 @@ xfs_symlink_write_verify(
 {
 	struct xfs_mount *mp = bp->b_target->bt_mount;
 	struct xfs_buf_log_item	*bip = bp->b_fspriv;
+	xfs_failaddr_t		fa;
 
 	/* no verification of non-crc buffers */
 	if (!xfs_sb_version_hascrc(&mp->m_sb))
 		return;
 
-	if (xfs_symlink_verify(bp)) {
+	if ((fa = xfs_symlink_verify(bp))) {
 		xfs_buf_ioerror(bp, -EFSCORRUPTED);
-		xfs_verifier_error(bp);
+		xfs_verifier_error(bp, fa);
 		return;
 	}
 
diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
index 4c9f35d..0bbbf0b 100644
--- a/fs/xfs/xfs_error.c
+++ b/fs/xfs/xfs_error.c
@@ -347,13 +347,15 @@ xfs_corruption_error(
  */
 void
 xfs_verifier_error(
-	struct xfs_buf		*bp)
+	struct xfs_buf		*bp,
+	xfs_failaddr_t		fa)
 {
 	struct xfs_mount *mp = bp->b_target->bt_mount;
 
 	xfs_alert(mp, "Metadata %s detected at %pS, %s block 0x%llx",
 		  bp->b_error == -EFSBADCRC ? "CRC error" : "corruption",
-		  __return_address, bp->b_ops->name, bp->b_bn);
+		  fa ? fa : __return_address, bp->b_ops->name,
+		  bp->b_bn);
 
 	xfs_alert(mp, "Unmount and run xfs_repair");
 
diff --git a/fs/xfs/xfs_error.h b/fs/xfs/xfs_error.h
index ea816c1..c13b3b4 100644
--- a/fs/xfs/xfs_error.h
+++ b/fs/xfs/xfs_error.h
@@ -25,7 +25,7 @@ extern void xfs_error_report(const char *tag, int level, struct xfs_mount *mp,
 extern void xfs_corruption_error(const char *tag, int level,
 			struct xfs_mount *mp, void *p, const char *filename,
 			int linenum, void *ra);
-extern void xfs_verifier_error(struct xfs_buf *bp);
+extern void xfs_verifier_error(struct xfs_buf *bp, xfs_failaddr_t fa);
 
 #define	XFS_ERROR_REPORT(e, lvl, mp)	\
 	xfs_error_report(e, lvl, mp, __FILE__, __LINE__, __return_address)

