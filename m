Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:39882 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757161AbdLWBOG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 22 Dec 2017 20:14:06 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.21/8.16.0.21) with SMTP id vBN1C7j5079460
        for <linux-xfs@vger.kernel.org>; Sat, 23 Dec 2017 01:14:05 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp2120.oracle.com with ESMTP id 2f1cvd81jw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 23 Dec 2017 01:14:04 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id vBN17nED010862
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Sat, 23 Dec 2017 01:07:50 GMT
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id vBN17nev009368
        for <linux-xfs@vger.kernel.org>; Sat, 23 Dec 2017 01:07:49 GMT
Subject: [PATCH 07/20] xfs: refactor verifier callers to print address of
 failing check
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 22 Dec 2017 17:07:48 -0800
Message-ID: <151399126849.23543.12256432171396478044.stgit@magnolia>
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

Refactor the callers of verifiers to print the instruction address of a
failing check.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_alloc.c          |   33 ++++++++++++++++++++++-----------
 fs/xfs/libxfs/xfs_alloc_btree.c    |   18 +++++++++++++-----
 fs/xfs/libxfs/xfs_attr_leaf.c      |   16 +++++++++++-----
 fs/xfs/libxfs/xfs_attr_remote.c    |   22 +++++++++++++---------
 fs/xfs/libxfs/xfs_bmap_btree.c     |   18 +++++++++++++-----
 fs/xfs/libxfs/xfs_da_btree.c       |   17 +++++++++++------
 fs/xfs/libxfs/xfs_dir2_block.c     |   16 +++++++++++-----
 fs/xfs/libxfs/xfs_dir2_data.c      |   18 ++++++++++++------
 fs/xfs/libxfs/xfs_dir2_leaf.c      |   16 +++++++++++-----
 fs/xfs/libxfs/xfs_dir2_node.c      |   24 ++++++++++++++++--------
 fs/xfs/libxfs/xfs_dquot_buf.c      |    6 +++---
 fs/xfs/libxfs/xfs_ialloc.c         |   17 +++++++++++------
 fs/xfs/libxfs/xfs_ialloc_btree.c   |   18 +++++++++++++-----
 fs/xfs/libxfs/xfs_inode_buf.c      |    2 +-
 fs/xfs/libxfs/xfs_refcount_btree.c |   18 +++++++++++++-----
 fs/xfs/libxfs/xfs_rmap_btree.c     |   18 +++++++++++++-----
 fs/xfs/libxfs/xfs_sb.c             |    4 ++--
 fs/xfs/libxfs/xfs_symlink_remote.c |   16 +++++++++++-----
 fs/xfs/xfs_error.c                 |    9 ++++++---
 fs/xfs/xfs_error.h                 |    3 ++-
 20 files changed, 208 insertions(+), 101 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index e730aca..e1ef1b2 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -557,6 +557,7 @@ xfs_agfl_read_verify(
 	struct xfs_buf	*bp)
 {
 	struct xfs_mount *mp = bp->b_target->bt_mount;
+	xfs_failaddr_t	fa;
 
 	/*
 	 * There is no verification of non-crc AGFLs because mkfs does not
@@ -568,9 +569,12 @@ xfs_agfl_read_verify(
 		return;
 
 	if (!xfs_buf_verify_cksum(bp, XFS_AGFL_CRC_OFF))
-		xfs_verifier_error(bp, -EFSBADCRC);
-	else if (xfs_agfl_verify(bp))
-		xfs_verifier_error(bp, -EFSCORRUPTED);
+		xfs_verifier_error(bp, -EFSBADCRC, __this_address);
+	else {
+		fa = xfs_agfl_verify(bp);
+		if (fa)
+			xfs_verifier_error(bp, -EFSCORRUPTED, fa);
+	}
 }
 
 static void
@@ -579,13 +583,15 @@ xfs_agfl_write_verify(
 {
 	struct xfs_mount *mp = bp->b_target->bt_mount;
 	struct xfs_buf_log_item	*bip = bp->b_fspriv;
+	xfs_failaddr_t		fa;
 
 	/* no verification of non-crc AGFLs */
 	if (!xfs_sb_version_hascrc(&mp->m_sb))
 		return;
 
-	if (xfs_agfl_verify(bp)) {
-		xfs_verifier_error(bp, -EFSCORRUPTED);
+	fa = xfs_agfl_verify(bp);
+	if (fa) {
+		xfs_verifier_error(bp, -EFSCORRUPTED, fa);
 		return;
 	}
 
@@ -2455,13 +2461,16 @@ xfs_agf_read_verify(
 	struct xfs_buf	*bp)
 {
 	struct xfs_mount *mp = bp->b_target->bt_mount;
+	xfs_failaddr_t	fa;
 
 	if (xfs_sb_version_hascrc(&mp->m_sb) &&
 	    !xfs_buf_verify_cksum(bp, XFS_AGF_CRC_OFF))
-		xfs_verifier_error(bp, -EFSBADCRC);
-	else if (XFS_TEST_ERROR(xfs_agf_verify(mp, bp), mp,
-				XFS_ERRTAG_ALLOC_READ_AGF))
-		xfs_verifier_error(bp, -EFSCORRUPTED);
+		xfs_verifier_error(bp, -EFSBADCRC, __this_address);
+	else {
+		fa = xfs_agf_verify(mp, bp);
+		if (XFS_TEST_ERROR(fa, mp, XFS_ERRTAG_ALLOC_READ_AGF))
+			xfs_verifier_error(bp, -EFSCORRUPTED, fa);
+	}
 }
 
 static void
@@ -2470,9 +2479,11 @@ xfs_agf_write_verify(
 {
 	struct xfs_mount *mp = bp->b_target->bt_mount;
 	struct xfs_buf_log_item	*bip = bp->b_fspriv;
+	xfs_failaddr_t		fa;
 
-	if (xfs_agf_verify(mp, bp)) {
-		xfs_verifier_error(bp, -EFSCORRUPTED);
+	fa = xfs_agf_verify(mp, bp);
+	if (fa) {
+		xfs_verifier_error(bp, -EFSCORRUPTED, fa);
 		return;
 	}
 
diff --git a/fs/xfs/libxfs/xfs_alloc_btree.c b/fs/xfs/libxfs/xfs_alloc_btree.c
index 4383c05..060d6fa 100644
--- a/fs/xfs/libxfs/xfs_alloc_btree.c
+++ b/fs/xfs/libxfs/xfs_alloc_btree.c
@@ -366,10 +366,15 @@ static void
 xfs_allocbt_read_verify(
 	struct xfs_buf	*bp)
 {
+	xfs_failaddr_t	fa;
+
 	if (!xfs_btree_sblock_verify_crc(bp))
-		xfs_verifier_error(bp, -EFSBADCRC);
-	else if (xfs_allocbt_verify(bp))
-		xfs_verifier_error(bp, -EFSCORRUPTED);
+		xfs_verifier_error(bp, -EFSBADCRC, __this_address);
+	else {
+		fa = xfs_allocbt_verify(bp);
+		if (fa)
+			xfs_verifier_error(bp, -EFSCORRUPTED, fa);
+	}
 
 	if (bp->b_error)
 		trace_xfs_btree_corrupt(bp, _RET_IP_);
@@ -379,9 +384,12 @@ static void
 xfs_allocbt_write_verify(
 	struct xfs_buf	*bp)
 {
-	if (xfs_allocbt_verify(bp)) {
+	xfs_failaddr_t	fa;
+
+	fa = xfs_allocbt_verify(bp);
+	if (fa) {
 		trace_xfs_btree_corrupt(bp, _RET_IP_);
-		xfs_verifier_error(bp, -EFSCORRUPTED);
+		xfs_verifier_error(bp, -EFSCORRUPTED, fa);
 		return;
 	}
 	xfs_btree_sblock_calc_crc(bp);
diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index f6281e1..68c66fa 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -295,9 +295,11 @@ xfs_attr3_leaf_write_verify(
 	struct xfs_mount	*mp = bp->b_target->bt_mount;
 	struct xfs_buf_log_item	*bip = bp->b_fspriv;
 	struct xfs_attr3_leaf_hdr *hdr3 = bp->b_addr;
+	xfs_failaddr_t		fa;
 
-	if (xfs_attr3_leaf_verify(bp)) {
-		xfs_verifier_error(bp, -EFSCORRUPTED);
+	fa = xfs_attr3_leaf_verify(bp);
+	if (fa) {
+		xfs_verifier_error(bp, -EFSCORRUPTED, fa);
 		return;
 	}
 
@@ -321,12 +323,16 @@ xfs_attr3_leaf_read_verify(
 	struct xfs_buf		*bp)
 {
 	struct xfs_mount	*mp = bp->b_target->bt_mount;
+	xfs_failaddr_t		fa;
 
 	if (xfs_sb_version_hascrc(&mp->m_sb) &&
 	     !xfs_buf_verify_cksum(bp, XFS_ATTR3_LEAF_CRC_OFF))
-		xfs_verifier_error(bp, -EFSBADCRC);
-	else if (xfs_attr3_leaf_verify(bp))
-		xfs_verifier_error(bp, -EFSCORRUPTED);
+		xfs_verifier_error(bp, -EFSBADCRC, __this_address);
+	else {
+		fa = xfs_attr3_leaf_verify(bp);
+		if (fa)
+			xfs_verifier_error(bp, -EFSCORRUPTED, fa);
+	}
 }
 
 const struct xfs_buf_ops xfs_attr3_leaf_buf_ops = {
diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
index 06858db..55514b3 100644
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
@@ -137,12 +138,13 @@ xfs_attr3_rmt_read_verify(
 
 	while (len > 0) {
 		if (!xfs_verify_cksum(ptr, blksize, XFS_ATTR3_RMT_CRC_OFF)) {
-			xfs_verifier_error(bp, -EFSBADCRC);
+			xfs_verifier_error(bp, -EFSBADCRC, __this_address);
 			return;
 		}
-		if (xfs_attr3_rmt_verify(mp, ptr, blksize, bno)) {
-			xfs_verifier_error(bp, -EFSCORRUPTED);
-			return;
+		fa = xfs_attr3_rmt_verify(mp, ptr, blksize, bno);
+		if (fa) {
+			xfs_verifier_error(bp, -EFSCORRUPTED, fa);
+			break;
 		}
 		len -= blksize;
 		ptr += blksize;
@@ -150,7 +152,7 @@ xfs_attr3_rmt_read_verify(
 	}
 
 	if (len != 0)
-		xfs_verifier_error(bp, -EFSCORRUPTED);
+		xfs_verifier_error(bp, -EFSCORRUPTED, __this_address);
 }
 
 static void
@@ -158,6 +160,7 @@ xfs_attr3_rmt_write_verify(
 	struct xfs_buf	*bp)
 {
 	struct xfs_mount *mp = bp->b_target->bt_mount;
+	xfs_failaddr_t	fa;
 	int		blksize = mp->m_attr_geo->blksize;
 	char		*ptr;
 	int		len;
@@ -175,8 +178,9 @@ xfs_attr3_rmt_write_verify(
 	while (len > 0) {
 		struct xfs_attr3_rmt_hdr *rmt = (struct xfs_attr3_rmt_hdr *)ptr;
 
-		if (xfs_attr3_rmt_verify(mp, ptr, blksize, bno)) {
-			xfs_verifier_error(bp, -EFSCORRUPTED);
+		fa = xfs_attr3_rmt_verify(mp, ptr, blksize, bno);
+		if (fa) {
+			xfs_verifier_error(bp, -EFSCORRUPTED, fa);
 			return;
 		}
 
@@ -185,7 +189,7 @@ xfs_attr3_rmt_write_verify(
 		 * xfs_attr3_rmt_hdr_set() for the explanation.
 		 */
 		if (rmt->rm_lsn != cpu_to_be64(NULLCOMMITLSN)) {
-			xfs_verifier_error(bp, -EFSCORRUPTED);
+			xfs_verifier_error(bp, -EFSCORRUPTED, __this_address);
 			return;
 		}
 		xfs_update_cksum(ptr, blksize, XFS_ATTR3_RMT_CRC_OFF);
@@ -196,7 +200,7 @@ xfs_attr3_rmt_write_verify(
 	}
 
 	if (len != 0)
-		xfs_verifier_error(bp, -EFSCORRUPTED);
+		xfs_verifier_error(bp, -EFSCORRUPTED, __this_address);
 }
 
 const struct xfs_buf_ops xfs_attr3_rmt_buf_ops = {
diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
index 0fdae57..64ae0ee 100644
--- a/fs/xfs/libxfs/xfs_bmap_btree.c
+++ b/fs/xfs/libxfs/xfs_bmap_btree.c
@@ -468,10 +468,15 @@ static void
 xfs_bmbt_read_verify(
 	struct xfs_buf	*bp)
 {
+	xfs_failaddr_t	fa;
+
 	if (!xfs_btree_lblock_verify_crc(bp))
-		xfs_verifier_error(bp, -EFSBADCRC);
-	else if (xfs_bmbt_verify(bp))
-		xfs_verifier_error(bp, -EFSCORRUPTED);
+		xfs_verifier_error(bp, -EFSBADCRC, __this_address);
+	else {
+		fa = xfs_bmbt_verify(bp);
+		if (fa)
+			xfs_verifier_error(bp, -EFSCORRUPTED, fa);
+	}
 
 	if (bp->b_error)
 		trace_xfs_btree_corrupt(bp, _RET_IP_);
@@ -481,9 +486,12 @@ static void
 xfs_bmbt_write_verify(
 	struct xfs_buf	*bp)
 {
-	if (xfs_bmbt_verify(bp)) {
+	xfs_failaddr_t	fa;
+
+	fa = xfs_bmbt_verify(bp);
+	if (fa) {
 		trace_xfs_btree_corrupt(bp, _RET_IP_);
-		xfs_verifier_error(bp, -EFSCORRUPTED);
+		xfs_verifier_error(bp, -EFSCORRUPTED, fa);
 		return;
 	}
 	xfs_btree_lblock_calc_crc(bp);
diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
index 60a2572..0ae3961 100644
--- a/fs/xfs/libxfs/xfs_da_btree.c
+++ b/fs/xfs/libxfs/xfs_da_btree.c
@@ -184,9 +184,11 @@ xfs_da3_node_write_verify(
 	struct xfs_mount	*mp = bp->b_target->bt_mount;
 	struct xfs_buf_log_item	*bip = bp->b_fspriv;
 	struct xfs_da3_node_hdr *hdr3 = bp->b_addr;
+	xfs_failaddr_t		fa;
 
-	if (xfs_da3_node_verify(bp)) {
-		xfs_verifier_error(bp, -EFSCORRUPTED);
+	fa = xfs_da3_node_verify(bp);
+	if (fa) {
+		xfs_verifier_error(bp, -EFSCORRUPTED, fa);
 		return;
 	}
 
@@ -210,17 +212,20 @@ xfs_da3_node_read_verify(
 	struct xfs_buf		*bp)
 {
 	struct xfs_da_blkinfo	*info = bp->b_addr;
+	xfs_failaddr_t		fa;
 
 	switch (be16_to_cpu(info->magic)) {
 		case XFS_DA3_NODE_MAGIC:
 			if (!xfs_buf_verify_cksum(bp, XFS_DA3_NODE_CRC_OFF)) {
-				xfs_verifier_error(bp, -EFSBADCRC);
+				xfs_verifier_error(bp, -EFSBADCRC,
+						__this_address);
 				break;
 			}
 			/* fall through */
 		case XFS_DA_NODE_MAGIC:
-			if (xfs_da3_node_verify(bp))
-				xfs_verifier_error(bp, -EFSCORRUPTED);
+			fa = xfs_da3_node_verify(bp);
+			if (fa)
+				xfs_verifier_error(bp, -EFSCORRUPTED, fa);
 			return;
 		case XFS_ATTR_LEAF_MAGIC:
 		case XFS_ATTR3_LEAF_MAGIC:
@@ -233,7 +238,7 @@ xfs_da3_node_read_verify(
 			bp->b_ops->verify_read(bp);
 			return;
 		default:
-			xfs_verifier_error(bp, -EFSCORRUPTED);
+			xfs_verifier_error(bp, -EFSCORRUPTED, __this_address);
 			break;
 	}
 }
diff --git a/fs/xfs/libxfs/xfs_dir2_block.c b/fs/xfs/libxfs/xfs_dir2_block.c
index 3b72879..cfd2777 100644
--- a/fs/xfs/libxfs/xfs_dir2_block.c
+++ b/fs/xfs/libxfs/xfs_dir2_block.c
@@ -86,12 +86,16 @@ xfs_dir3_block_read_verify(
 	struct xfs_buf	*bp)
 {
 	struct xfs_mount	*mp = bp->b_target->bt_mount;
+	xfs_failaddr_t		fa;
 
 	if (xfs_sb_version_hascrc(&mp->m_sb) &&
 	     !xfs_buf_verify_cksum(bp, XFS_DIR3_DATA_CRC_OFF))
-		xfs_verifier_error(bp, -EFSBADCRC);
-	else if (xfs_dir3_block_verify(bp))
-		xfs_verifier_error(bp, -EFSCORRUPTED);
+		xfs_verifier_error(bp, -EFSBADCRC, __this_address);
+	else {
+		fa = xfs_dir3_block_verify(bp);
+		if (fa)
+			xfs_verifier_error(bp, -EFSCORRUPTED, fa);
+	}
 }
 
 static void
@@ -101,9 +105,11 @@ xfs_dir3_block_write_verify(
 	struct xfs_mount	*mp = bp->b_target->bt_mount;
 	struct xfs_buf_log_item	*bip = bp->b_fspriv;
 	struct xfs_dir3_blk_hdr	*hdr3 = bp->b_addr;
+	xfs_failaddr_t		fa;
 
-	if (xfs_dir3_block_verify(bp)) {
-		xfs_verifier_error(bp, -EFSCORRUPTED);
+	fa = xfs_dir3_block_verify(bp);
+	if (fa) {
+		xfs_verifier_error(bp, -EFSCORRUPTED, fa);
 		return;
 	}
 
diff --git a/fs/xfs/libxfs/xfs_dir2_data.c b/fs/xfs/libxfs/xfs_dir2_data.c
index 3eda247..2fa7c34 100644
--- a/fs/xfs/libxfs/xfs_dir2_data.c
+++ b/fs/xfs/libxfs/xfs_dir2_data.c
@@ -284,7 +284,7 @@ xfs_dir3_data_reada_verify(
 		bp->b_ops->verify_read(bp);
 		return;
 	default:
-		xfs_verifier_error(bp, -EFSCORRUPTED);
+		xfs_verifier_error(bp, -EFSCORRUPTED, __this_address);
 		break;
 	}
 }
@@ -294,12 +294,16 @@ xfs_dir3_data_read_verify(
 	struct xfs_buf	*bp)
 {
 	struct xfs_mount	*mp = bp->b_target->bt_mount;
+	xfs_failaddr_t		fa;
 
 	if (xfs_sb_version_hascrc(&mp->m_sb) &&
 	    !xfs_buf_verify_cksum(bp, XFS_DIR3_DATA_CRC_OFF))
-		xfs_verifier_error(bp, -EFSBADCRC);
-	else if (xfs_dir3_data_verify(bp))
-		xfs_verifier_error(bp, -EFSCORRUPTED);
+		xfs_verifier_error(bp, -EFSBADCRC, __this_address);
+	else {
+		fa = xfs_dir3_data_verify(bp);
+		if (fa)
+			xfs_verifier_error(bp, -EFSCORRUPTED, fa);
+	}
 }
 
 static void
@@ -309,9 +313,11 @@ xfs_dir3_data_write_verify(
 	struct xfs_mount	*mp = bp->b_target->bt_mount;
 	struct xfs_buf_log_item	*bip = bp->b_fspriv;
 	struct xfs_dir3_blk_hdr	*hdr3 = bp->b_addr;
+	xfs_failaddr_t		fa;
 
-	if (xfs_dir3_data_verify(bp)) {
-		xfs_verifier_error(bp, -EFSCORRUPTED);
+	fa = xfs_dir3_data_verify(bp);
+	if (fa) {
+		xfs_verifier_error(bp, -EFSCORRUPTED, fa);
 		return;
 	}
 
diff --git a/fs/xfs/libxfs/xfs_dir2_leaf.c b/fs/xfs/libxfs/xfs_dir2_leaf.c
index a869486..a03d679 100644
--- a/fs/xfs/libxfs/xfs_dir2_leaf.c
+++ b/fs/xfs/libxfs/xfs_dir2_leaf.c
@@ -190,12 +190,16 @@ __read_verify(
 	uint16_t	magic)
 {
 	struct xfs_mount	*mp = bp->b_target->bt_mount;
+	xfs_failaddr_t		fa;
 
 	if (xfs_sb_version_hascrc(&mp->m_sb) &&
 	     !xfs_buf_verify_cksum(bp, XFS_DIR3_LEAF_CRC_OFF))
-		xfs_verifier_error(bp, -EFSBADCRC);
-	else if (xfs_dir3_leaf_verify(bp, magic))
-		xfs_verifier_error(bp, -EFSCORRUPTED);
+		xfs_verifier_error(bp, -EFSBADCRC, __this_address);
+	else {
+		fa = xfs_dir3_leaf_verify(bp, magic);
+		if (fa)
+			xfs_verifier_error(bp, -EFSCORRUPTED, fa);
+	}
 }
 
 static void
@@ -206,9 +210,11 @@ __write_verify(
 	struct xfs_mount	*mp = bp->b_target->bt_mount;
 	struct xfs_buf_log_item	*bip = bp->b_fspriv;
 	struct xfs_dir3_leaf_hdr *hdr3 = bp->b_addr;
+	xfs_failaddr_t		fa;
 
-	if (xfs_dir3_leaf_verify(bp, magic)) {
-		xfs_verifier_error(bp, -EFSCORRUPTED);
+	fa = xfs_dir3_leaf_verify(bp, magic);
+	if (fa) {
+		xfs_verifier_error(bp, -EFSCORRUPTED, fa);
 		return;
 	}
 
diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
index 051a21f..3bdbe189 100644
--- a/fs/xfs/libxfs/xfs_dir2_node.c
+++ b/fs/xfs/libxfs/xfs_dir2_node.c
@@ -124,12 +124,16 @@ xfs_dir3_free_read_verify(
 	struct xfs_buf	*bp)
 {
 	struct xfs_mount	*mp = bp->b_target->bt_mount;
+	xfs_failaddr_t		fa;
 
 	if (xfs_sb_version_hascrc(&mp->m_sb) &&
 	    !xfs_buf_verify_cksum(bp, XFS_DIR3_FREE_CRC_OFF))
-		xfs_verifier_error(bp, -EFSBADCRC);
-	else if (xfs_dir3_free_verify(bp))
-		xfs_verifier_error(bp, -EFSCORRUPTED);
+		xfs_verifier_error(bp, -EFSBADCRC, __this_address);
+	else {
+		fa = xfs_dir3_free_verify(bp);
+		if (fa)
+			xfs_verifier_error(bp, -EFSCORRUPTED, fa);
+	}
 }
 
 static void
@@ -139,9 +143,11 @@ xfs_dir3_free_write_verify(
 	struct xfs_mount	*mp = bp->b_target->bt_mount;
 	struct xfs_buf_log_item	*bip = bp->b_fspriv;
 	struct xfs_dir3_blk_hdr	*hdr3 = bp->b_addr;
+	xfs_failaddr_t		fa;
 
-	if (xfs_dir3_free_verify(bp)) {
-		xfs_verifier_error(bp, -EFSCORRUPTED);
+	fa = xfs_dir3_free_verify(bp);
+	if (fa) {
+		xfs_verifier_error(bp, -EFSCORRUPTED, fa);
 		return;
 	}
 
@@ -161,7 +167,7 @@ const struct xfs_buf_ops xfs_dir3_free_buf_ops = {
 };
 
 /* Everything ok in the free block header? */
-static bool
+static xfs_failaddr_t
 xfs_dir3_free_header_check(
 	struct xfs_inode	*dp,
 	xfs_dablk_t		fbno,
@@ -205,6 +211,7 @@ __xfs_dir3_free_read(
 	xfs_daddr_t		mappedbno,
 	struct xfs_buf		**bpp)
 {
+	xfs_failaddr_t		fa;
 	int			err;
 
 	err = xfs_da_read_buf(tp, dp, fbno, mappedbno, bpp,
@@ -213,8 +220,9 @@ __xfs_dir3_free_read(
 		return err;
 
 	/* Check things that we can't do in the verifier. */
-	if (xfs_dir3_free_header_check(dp, fbno, *bpp)) {
-		xfs_verifier_error(*bpp, -EFSCORRUPTED);
+	fa = xfs_dir3_free_header_check(dp, fbno, *bpp);
+	if (fa) {
+		xfs_verifier_error(*bpp, -EFSCORRUPTED, fa);
 		xfs_trans_brelse(tp, *bpp);
 		return -EFSCORRUPTED;
 	}
diff --git a/fs/xfs/libxfs/xfs_dquot_buf.c b/fs/xfs/libxfs/xfs_dquot_buf.c
index a3f1ecc..5e022c1 100644
--- a/fs/xfs/libxfs/xfs_dquot_buf.c
+++ b/fs/xfs/libxfs/xfs_dquot_buf.c
@@ -249,9 +249,9 @@ xfs_dquot_buf_read_verify(
 	struct xfs_mount	*mp = bp->b_target->bt_mount;
 
 	if (!xfs_dquot_buf_verify_crc(mp, bp))
-		xfs_verifier_error(bp, -EFSBADCRC);
+		xfs_verifier_error(bp, -EFSBADCRC, __this_address);
 	else if (!xfs_dquot_buf_verify(mp, bp, XFS_QMOPT_DOWARN))
-		xfs_verifier_error(bp, -EFSCORRUPTED);
+		xfs_verifier_error(bp, -EFSCORRUPTED, __this_address);
 }
 
 /*
@@ -285,7 +285,7 @@ xfs_dquot_buf_write_verify(
 	struct xfs_mount	*mp = bp->b_target->bt_mount;
 
 	if (!xfs_dquot_buf_verify(mp, bp, XFS_QMOPT_DOWARN)) {
-		xfs_verifier_error(bp, -EFSCORRUPTED);
+		xfs_verifier_error(bp, -EFSCORRUPTED, __this_address);
 		return;
 	}
 }
diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index 5a6e6ae..3ded1f3 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -2541,13 +2541,16 @@ xfs_agi_read_verify(
 	struct xfs_buf	*bp)
 {
 	struct xfs_mount *mp = bp->b_target->bt_mount;
+	xfs_failaddr_t	fa;
 
 	if (xfs_sb_version_hascrc(&mp->m_sb) &&
 	    !xfs_buf_verify_cksum(bp, XFS_AGI_CRC_OFF))
-		xfs_verifier_error(bp, -EFSBADCRC);
-	else if (XFS_TEST_ERROR(xfs_agi_verify(bp), mp,
-				XFS_ERRTAG_IALLOC_READ_AGI))
-		xfs_verifier_error(bp, -EFSCORRUPTED);
+		xfs_verifier_error(bp, -EFSBADCRC, __this_address);
+	else {
+		fa = xfs_agi_verify(bp);
+		if (XFS_TEST_ERROR(fa, mp, XFS_ERRTAG_IALLOC_READ_AGI))
+			xfs_verifier_error(bp, -EFSCORRUPTED, fa);
+	}
 }
 
 static void
@@ -2556,9 +2559,11 @@ xfs_agi_write_verify(
 {
 	struct xfs_mount *mp = bp->b_target->bt_mount;
 	struct xfs_buf_log_item	*bip = bp->b_fspriv;
+	xfs_failaddr_t		fa;
 
-	if (xfs_agi_verify(bp)) {
-		xfs_verifier_error(bp, -EFSCORRUPTED);
+	fa = xfs_agi_verify(bp);
+	if (fa) {
+		xfs_verifier_error(bp, -EFSCORRUPTED, fa);
 		return;
 	}
 
diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.c b/fs/xfs/libxfs/xfs_ialloc_btree.c
index 8fe126b..9c691ad 100644
--- a/fs/xfs/libxfs/xfs_ialloc_btree.c
+++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
@@ -295,10 +295,15 @@ static void
 xfs_inobt_read_verify(
 	struct xfs_buf	*bp)
 {
+	xfs_failaddr_t	fa;
+
 	if (!xfs_btree_sblock_verify_crc(bp))
-		xfs_verifier_error(bp, -EFSBADCRC);
-	else if (xfs_inobt_verify(bp))
-		xfs_verifier_error(bp, -EFSCORRUPTED);
+		xfs_verifier_error(bp, -EFSBADCRC, __this_address);
+	else {
+		fa = xfs_inobt_verify(bp);
+		if (fa)
+			xfs_verifier_error(bp, -EFSCORRUPTED, fa);
+	}
 
 	if (bp->b_error)
 		trace_xfs_btree_corrupt(bp, _RET_IP_);
@@ -308,9 +313,12 @@ static void
 xfs_inobt_write_verify(
 	struct xfs_buf	*bp)
 {
-	if (xfs_inobt_verify(bp)) {
+	xfs_failaddr_t	fa;
+
+	fa = xfs_inobt_verify(bp);
+	if (fa) {
 		trace_xfs_btree_corrupt(bp, _RET_IP_);
-		xfs_verifier_error(bp, -EFSCORRUPTED);
+		xfs_verifier_error(bp, -EFSCORRUPTED, fa);
 		return;
 	}
 	xfs_btree_sblock_calc_crc(bp);
diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index 607dcca..a43a370 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -113,7 +113,7 @@ xfs_inode_buf_verify(
 				return;
 			}
 
-			xfs_verifier_error(bp, -EFSCORRUPTED);
+			xfs_verifier_error(bp, -EFSCORRUPTED, __this_address);
 #ifdef DEBUG
 			xfs_alert(mp,
 				"bad inode magic/vsn daddr %lld #%d (magic=%x)",
diff --git a/fs/xfs/libxfs/xfs_refcount_btree.c b/fs/xfs/libxfs/xfs_refcount_btree.c
index aa09051..715c272 100644
--- a/fs/xfs/libxfs/xfs_refcount_btree.c
+++ b/fs/xfs/libxfs/xfs_refcount_btree.c
@@ -256,10 +256,15 @@ STATIC void
 xfs_refcountbt_read_verify(
 	struct xfs_buf	*bp)
 {
+	xfs_failaddr_t	fa;
+
 	if (!xfs_btree_sblock_verify_crc(bp))
-		xfs_verifier_error(bp, -EFSBADCRC);
-	else if (xfs_refcountbt_verify(bp))
-		xfs_verifier_error(bp, -EFSCORRUPTED);
+		xfs_verifier_error(bp, -EFSBADCRC, __this_address);
+	else {
+		fa = xfs_refcountbt_verify(bp);
+		if (fa)
+			xfs_verifier_error(bp, -EFSCORRUPTED, fa);
+	}
 
 	if (bp->b_error)
 		trace_xfs_btree_corrupt(bp, _RET_IP_);
@@ -269,9 +274,12 @@ STATIC void
 xfs_refcountbt_write_verify(
 	struct xfs_buf	*bp)
 {
-	if (xfs_refcountbt_verify(bp)) {
+	xfs_failaddr_t	fa;
+
+	fa = xfs_refcountbt_verify(bp);
+	if (fa) {
 		trace_xfs_btree_corrupt(bp, _RET_IP_);
-		xfs_verifier_error(bp, -EFSCORRUPTED);
+		xfs_verifier_error(bp, -EFSCORRUPTED, fa);
 		return;
 	}
 	xfs_btree_sblock_calc_crc(bp);
diff --git a/fs/xfs/libxfs/xfs_rmap_btree.c b/fs/xfs/libxfs/xfs_rmap_btree.c
index 333fd5c..d089a48 100644
--- a/fs/xfs/libxfs/xfs_rmap_btree.c
+++ b/fs/xfs/libxfs/xfs_rmap_btree.c
@@ -348,10 +348,15 @@ static void
 xfs_rmapbt_read_verify(
 	struct xfs_buf	*bp)
 {
+	xfs_failaddr_t	fa;
+
 	if (!xfs_btree_sblock_verify_crc(bp))
-		xfs_verifier_error(bp, -EFSBADCRC);
-	else if (xfs_rmapbt_verify(bp))
-		xfs_verifier_error(bp, -EFSCORRUPTED);
+		xfs_verifier_error(bp, -EFSBADCRC, __this_address);
+	else {
+		fa = xfs_rmapbt_verify(bp);
+		if (fa)
+			xfs_verifier_error(bp, -EFSCORRUPTED, fa);
+	}
 
 	if (bp->b_error)
 		trace_xfs_btree_corrupt(bp, _RET_IP_);
@@ -361,9 +366,12 @@ static void
 xfs_rmapbt_write_verify(
 	struct xfs_buf	*bp)
 {
-	if (xfs_rmapbt_verify(bp)) {
+	xfs_failaddr_t	fa;
+
+	fa = xfs_rmapbt_verify(bp);
+	if (fa) {
 		trace_xfs_btree_corrupt(bp, _RET_IP_);
-		xfs_verifier_error(bp, -EFSCORRUPTED);
+		xfs_verifier_error(bp, -EFSCORRUPTED, fa);
 		return;
 	}
 	xfs_btree_sblock_calc_crc(bp);
diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index 96a8267..63e0331 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -641,7 +641,7 @@ xfs_sb_read_verify(
 
 out_error:
 	if (error == -EFSCORRUPTED || error == -EFSBADCRC)
-		xfs_verifier_error(bp, error);
+		xfs_verifier_error(bp, error, __this_address);
 	else if (error)
 		xfs_buf_ioerror(bp, error);
 }
@@ -677,7 +677,7 @@ xfs_sb_write_verify(
 
 	error = xfs_sb_verify(bp, false);
 	if (error) {
-		xfs_verifier_error(bp, error);
+		xfs_verifier_error(bp, error, __this_address);
 		return;
 	}
 
diff --git a/fs/xfs/libxfs/xfs_symlink_remote.c b/fs/xfs/libxfs/xfs_symlink_remote.c
index 64db737..5497014 100644
--- a/fs/xfs/libxfs/xfs_symlink_remote.c
+++ b/fs/xfs/libxfs/xfs_symlink_remote.c
@@ -129,15 +129,19 @@ xfs_symlink_read_verify(
 	struct xfs_buf	*bp)
 {
 	struct xfs_mount *mp = bp->b_target->bt_mount;
+	xfs_failaddr_t	fa;
 
 	/* no verification of non-crc buffers */
 	if (!xfs_sb_version_hascrc(&mp->m_sb))
 		return;
 
 	if (!xfs_buf_verify_cksum(bp, XFS_SYMLINK_CRC_OFF))
-		xfs_verifier_error(bp, -EFSBADCRC);
-	else if (xfs_symlink_verify(bp))
-		xfs_verifier_error(bp, -EFSCORRUPTED);
+		xfs_verifier_error(bp, -EFSBADCRC, __this_address);
+	else {
+		fa = xfs_symlink_verify(bp);
+		if (fa)
+			xfs_verifier_error(bp, -EFSCORRUPTED, fa);
+	}
 }
 
 static void
@@ -146,13 +150,15 @@ xfs_symlink_write_verify(
 {
 	struct xfs_mount *mp = bp->b_target->bt_mount;
 	struct xfs_buf_log_item	*bip = bp->b_fspriv;
+	xfs_failaddr_t		fa;
 
 	/* no verification of non-crc buffers */
 	if (!xfs_sb_version_hascrc(&mp->m_sb))
 		return;
 
-	if (xfs_symlink_verify(bp)) {
-		xfs_verifier_error(bp, -EFSCORRUPTED);
+	fa = xfs_symlink_verify(bp);
+	if (fa) {
+		xfs_verifier_error(bp, -EFSCORRUPTED, fa);
 		return;
 	}
 
diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
index c0a98c4..7e58a99 100644
--- a/fs/xfs/xfs_error.c
+++ b/fs/xfs/xfs_error.c
@@ -348,15 +348,18 @@ xfs_corruption_error(
 void
 xfs_verifier_error(
 	struct xfs_buf		*bp,
-	int			error)
+	int			error,
+	xfs_failaddr_t		failaddr)
 {
 	struct xfs_mount *mp = bp->b_target->bt_mount;
+	xfs_failaddr_t		fa;
 
-	__xfs_buf_ioerror(bp, error, __return_address);
+	fa = failaddr ? failaddr : __return_address;
+	__xfs_buf_ioerror(bp, error, failaddr);
 
 	xfs_alert(mp, "Metadata %s detected at %pS, %s block 0x%llx",
 		  bp->b_error == -EFSBADCRC ? "CRC error" : "corruption",
-		  __return_address, bp->b_ops->name, bp->b_bn);
+		  fa, bp->b_ops->name, bp->b_bn);
 
 	xfs_alert(mp, "Unmount and run xfs_repair");
 
diff --git a/fs/xfs/xfs_error.h b/fs/xfs/xfs_error.h
index 5987562..11f80e0 100644
--- a/fs/xfs/xfs_error.h
+++ b/fs/xfs/xfs_error.h
@@ -25,7 +25,8 @@ extern void xfs_error_report(const char *tag, int level, struct xfs_mount *mp,
 extern void xfs_corruption_error(const char *tag, int level,
 			struct xfs_mount *mp, void *p, const char *filename,
 			int linenum, void *ra);
-extern void xfs_verifier_error(struct xfs_buf *bp, int error);
+extern void xfs_verifier_error(struct xfs_buf *bp, int error,
+			xfs_failaddr_t failaddr);
 
 #define	XFS_ERROR_REPORT(e, lvl, mp)	\
 	xfs_error_report(e, lvl, mp, __FILE__, __LINE__, __return_address)

