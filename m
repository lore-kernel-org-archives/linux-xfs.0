Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46360 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727257AbeLEVLF (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 5 Dec 2018 16:11:05 -0500
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id A4C0913A9B
        for <linux-xfs@vger.kernel.org>; Wed,  5 Dec 2018 21:11:04 +0000 (UTC)
Subject: [PATCH 09/10] xfs: add errno to verifier context and populate it
References: <542b81dc-b564-c5fa-86b4-b4dc8ac50b63@redhat.com>
From: Eric Sandeen <sandeen@redhat.com>
Message-ID: <cc218ca1-a572-0dd0-d01b-89b33eeace4b@redhat.com>
Date: Wed, 5 Dec 2018 15:11:00 -0600
MIME-Version: 1.0
In-Reply-To: <542b81dc-b564-c5fa-86b4-b4dc8ac50b63@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

Add errno to verifier context and set it on verifier failures;
now rather than passing errno and vc->fa to xfs_verifier_error,
we pass vc directly and let xfs_verifier_error suss out the
errno and failaddr.

Also make 3 new macros, XFS_CORRUPTED, XFS_BADCRC, and
XFS_VERIFIED which set errno and failaddr into the verifier context
without returning.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 fs/xfs/libxfs/xfs_alloc.c          | 12 ++++----
 fs/xfs/libxfs/xfs_alloc_btree.c    |  6 ++--
 fs/xfs/libxfs/xfs_attr_leaf.c      |  6 ++--
 fs/xfs/libxfs/xfs_attr_remote.c    | 49 ++++++++++++------------------
 fs/xfs/libxfs/xfs_bmap_btree.c     |  6 ++--
 fs/xfs/libxfs/xfs_da_btree.c       |  9 +++---
 fs/xfs/libxfs/xfs_dir2_block.c     |  6 ++--
 fs/xfs/libxfs/xfs_dir2_data.c      |  9 +++---
 fs/xfs/libxfs/xfs_dir2_leaf.c      |  6 ++--
 fs/xfs/libxfs/xfs_dir2_node.c      |  8 ++---
 fs/xfs/libxfs/xfs_ialloc.c         |  6 ++--
 fs/xfs/libxfs/xfs_ialloc_btree.c   |  6 ++--
 fs/xfs/libxfs/xfs_refcount_btree.c |  6 ++--
 fs/xfs/libxfs/xfs_rmap_btree.c     |  6 ++--
 fs/xfs/libxfs/xfs_sb.c             | 14 ++++++---
 fs/xfs/libxfs/xfs_symlink_remote.c |  6 ++--
 fs/xfs/libxfs/xfs_types.h          | 16 ++++++++--
 fs/xfs/xfs_error.c                 |  7 ++---
 fs/xfs/xfs_error.h                 |  3 +-
 19 files changed, 96 insertions(+), 91 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 14611b12220a..213a3078113c 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -610,10 +610,10 @@ xfs_agfl_read_verify(
 		return;
 
 	if (!xfs_buf_verify_cksum(vc, bp, XFS_AGFL_CRC_OFF))
-		xfs_verifier_error(bp, -EFSBADCRC, vc->fa);
+		xfs_verifier_error(bp, vc);
 	else {
 		if (!xfs_agfl_verify(vc, bp))
-			xfs_verifier_error(bp, -EFSCORRUPTED, vc->fa);
+			xfs_verifier_error(bp, vc);
 	}
 }
 
@@ -630,7 +630,7 @@ xfs_agfl_write_verify(
 		return;
 
 	if (!xfs_agfl_verify(vc, bp)) {
-		xfs_verifier_error(bp, -EFSCORRUPTED, vc->fa);
+		xfs_verifier_error(bp, vc);
 		return;
 	}
 
@@ -2637,11 +2637,11 @@ xfs_agf_read_verify(
 
 	if (xfs_sb_version_hascrc(&mp->m_sb) &&
 	    !xfs_buf_verify_cksum(vc, bp, XFS_AGF_CRC_OFF))
-		xfs_verifier_error(bp, -EFSBADCRC, vc->fa);
+		xfs_verifier_error(bp, vc);
 	else {
 		if (XFS_TEST_ERROR(!xfs_agf_verify(vc, bp),
 				   mp, XFS_ERRTAG_ALLOC_READ_AGF))
-			xfs_verifier_error(bp, -EFSCORRUPTED, vc->fa);
+			xfs_verifier_error(bp, vc);
 	}
 }
 
@@ -2654,7 +2654,7 @@ xfs_agf_write_verify(
 	struct xfs_buf_log_item	*bip = bp->b_log_item;
 
 	if (!xfs_agf_verify(vc, bp)) {
-		xfs_verifier_error(bp, -EFSCORRUPTED, vc->fa);
+		xfs_verifier_error(bp, vc);
 		return;
 	}
 
diff --git a/fs/xfs/libxfs/xfs_alloc_btree.c b/fs/xfs/libxfs/xfs_alloc_btree.c
index 40040505794a..9f56821b49af 100644
--- a/fs/xfs/libxfs/xfs_alloc_btree.c
+++ b/fs/xfs/libxfs/xfs_alloc_btree.c
@@ -347,10 +347,10 @@ xfs_allocbt_read_verify(
 	struct xfs_buf	*bp)
 {
 	if (!xfs_btree_sblock_verify_crc(vc, bp))
-		xfs_verifier_error(bp, -EFSBADCRC, vc->fa);
+		xfs_verifier_error(bp, vc);
 	else {
 		if (!xfs_allocbt_verify(vc, bp))
-			xfs_verifier_error(bp, -EFSCORRUPTED, vc->fa);
+			xfs_verifier_error(bp, vc);
 	}
 
 	if (bp->b_error)
@@ -364,7 +364,7 @@ xfs_allocbt_write_verify(
 {
 	if (!xfs_allocbt_verify(vc, bp)) {
 		trace_xfs_btree_corrupt(bp, _RET_IP_);
-		xfs_verifier_error(bp, -EFSCORRUPTED, vc->fa);
+		xfs_verifier_error(bp, vc);
 		return;
 	}
 	xfs_btree_sblock_calc_crc(bp);
diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index a69ff26a4558..34958aa7fe5f 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -331,7 +331,7 @@ xfs_attr3_leaf_write_verify(
 	struct xfs_attr3_leaf_hdr *hdr3 = bp->b_addr;
 
 	if (!xfs_attr3_leaf_verify(vc, bp)) {
-		xfs_verifier_error(bp, -EFSCORRUPTED, vc->fa);
+		xfs_verifier_error(bp, vc);
 		return;
 	}
 
@@ -359,10 +359,10 @@ xfs_attr3_leaf_read_verify(
 
 	if (xfs_sb_version_hascrc(&mp->m_sb) &&
 	     !xfs_buf_verify_cksum(vc, bp, XFS_ATTR3_LEAF_CRC_OFF))
-		xfs_verifier_error(bp, -EFSBADCRC, vc->fa);
+		xfs_verifier_error(bp, vc);
 	else {
 		if (!xfs_attr3_leaf_verify(vc, bp))
-			xfs_verifier_error(bp, -EFSCORRUPTED, vc->fa);
+			xfs_verifier_error(bp, vc);
 	}
 }
 
diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
index 9987330424e9..8c29745afa5c 100644
--- a/fs/xfs/libxfs/xfs_attr_remote.c
+++ b/fs/xfs/libxfs/xfs_attr_remote.c
@@ -105,12 +105,11 @@ xfs_attr3_rmt_verify(
 	return XFS_VERIFIED_RETURN(vc);
 }
 
-static int
+static bool
 __xfs_attr3_rmt_read_verify(
 	struct xfs_vc	*vc,
 	struct xfs_buf	*bp,
-	bool		check_crc,
-	xfs_failaddr_t	*failaddr)
+	bool		check_crc)
 {
 	struct xfs_mount *mp = bp->b_target->bt_mount;
 	char		*ptr;
@@ -120,7 +119,7 @@ __xfs_attr3_rmt_read_verify(
 
 	/* no verification of non-crc buffers */
 	if (!xfs_sb_version_hascrc(&mp->m_sb))
-		return 0;
+		return XFS_VERIFIED_RETURN(vc);
 
 	ptr = bp->b_addr;
 	bno = bp->b_bn;
@@ -130,24 +129,19 @@ __xfs_attr3_rmt_read_verify(
 	while (len > 0) {
 		if (check_crc &&
 		    !xfs_verify_cksum(vc, ptr, blksize, XFS_ATTR3_RMT_CRC_OFF)) {
-			*failaddr = __this_address;
-			return -EFSBADCRC;
-		}
-		if (!xfs_attr3_rmt_verify(vc, mp, ptr, blksize, bno)) {
-			*failaddr = vc->fa;
-			return -EFSCORRUPTED;
+			return XFS_BADCRC_RETURN(vc);
 		}
+		if (!xfs_attr3_rmt_verify(vc, mp, ptr, blksize, bno))
+			return XFS_CORRUPTED_RETURN(vc);
 		len -= blksize;
 		ptr += blksize;
 		bno += BTOBB(blksize);
 	}
 
-	if (len != 0) {
-		*failaddr = __this_address;
-		return -EFSCORRUPTED;
-	}
+	if (len != 0)
+		return XFS_CORRUPTED_RETURN(vc);
 
-	return 0;
+	return XFS_VERIFIED_RETURN(vc);
 }
 
 static void
@@ -155,12 +149,8 @@ xfs_attr3_rmt_read_verify(
 	struct xfs_vc	*vc,
 	struct xfs_buf	*bp)
 {
-	xfs_failaddr_t	fa;
-	int		error;
-
-	error = __xfs_attr3_rmt_read_verify(vc, bp, true, &fa);
-	if (error)
-		xfs_verifier_error(bp, error, fa);
+	if (!__xfs_attr3_rmt_read_verify(vc, bp, true))
+		xfs_verifier_error(bp, vc);
 }
 
 static bool
@@ -168,11 +158,7 @@ xfs_attr3_rmt_verify_struct(
 	struct xfs_vc	*vc,
 	struct xfs_buf	*bp)
 {
-	xfs_failaddr_t	fa;
-	int		error;
-
-	error = __xfs_attr3_rmt_read_verify(vc, bp, false, &fa);
-	return error ? fa : NULL;
+	return __xfs_attr3_rmt_read_verify(vc, bp, false);
 }
 
 static void
@@ -199,7 +185,7 @@ xfs_attr3_rmt_write_verify(
 		struct xfs_attr3_rmt_hdr *rmt = (struct xfs_attr3_rmt_hdr *)ptr;
 
 		if (!xfs_attr3_rmt_verify(vc, mp, ptr, blksize, bno)) {
-			xfs_verifier_error(bp, -EFSCORRUPTED, vc->fa);
+			xfs_verifier_error(bp, vc);
 			return;
 		}
 
@@ -208,7 +194,8 @@ xfs_attr3_rmt_write_verify(
 		 * xfs_attr3_rmt_hdr_set() for the explanation.
 		 */
 		if (rmt->rm_lsn != cpu_to_be64(NULLCOMMITLSN)) {
-			xfs_verifier_error(bp, -EFSCORRUPTED, __this_address);
+			XFS_CORRUPTED(vc);
+			xfs_verifier_error(bp, vc);
 			return;
 		}
 		xfs_update_cksum(ptr, blksize, XFS_ATTR3_RMT_CRC_OFF);
@@ -218,8 +205,10 @@ xfs_attr3_rmt_write_verify(
 		bno += BTOBB(blksize);
 	}
 
-	if (len != 0)
-		xfs_verifier_error(bp, -EFSCORRUPTED, __this_address);
+	if (len != 0) {
+		XFS_CORRUPTED(vc);
+		xfs_verifier_error(bp, vc);
+	}
 }
 
 const struct xfs_buf_ops xfs_attr3_rmt_buf_ops = {
diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
index 485b207f715f..44c98c35dd3a 100644
--- a/fs/xfs/libxfs/xfs_bmap_btree.c
+++ b/fs/xfs/libxfs/xfs_bmap_btree.c
@@ -451,10 +451,10 @@ xfs_bmbt_read_verify(
 	struct xfs_buf	*bp)
 {
 	if (!xfs_btree_lblock_verify_crc(vc, bp))
-		xfs_verifier_error(bp, -EFSBADCRC, vc->fa);
+		xfs_verifier_error(bp, vc);
 	else {
 		if (!xfs_bmbt_verify(vc, bp))
-			xfs_verifier_error(bp, -EFSCORRUPTED, vc->fa);
+			xfs_verifier_error(bp, vc);
 	}
 
 	if (bp->b_error)
@@ -468,7 +468,7 @@ xfs_bmbt_write_verify(
 {
 	if (!xfs_bmbt_verify(vc, bp)) {
 		trace_xfs_btree_corrupt(bp, _RET_IP_);
-		xfs_verifier_error(bp, -EFSCORRUPTED, vc->fa);
+		xfs_verifier_error(bp, vc);
 		return;
 	}
 	xfs_btree_lblock_calc_crc(bp);
diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
index b26ae562c8c7..a800dbbd5c88 100644
--- a/fs/xfs/libxfs/xfs_da_btree.c
+++ b/fs/xfs/libxfs/xfs_da_btree.c
@@ -176,7 +176,7 @@ xfs_da3_node_write_verify(
 	struct xfs_da3_node_hdr *hdr3 = bp->b_addr;
 
 	if (!xfs_da3_node_verify(vc, bp)) {
-		xfs_verifier_error(bp, -EFSCORRUPTED, vc->fa);
+		xfs_verifier_error(bp, vc);
 		return;
 	}
 
@@ -205,13 +205,13 @@ xfs_da3_node_read_verify(
 	switch (be16_to_cpu(info->magic)) {
 		case XFS_DA3_NODE_MAGIC:
 			if (!xfs_buf_verify_cksum(vc, bp, XFS_DA3_NODE_CRC_OFF)) {
-				xfs_verifier_error(bp, -EFSBADCRC, vc->fa);
+				xfs_verifier_error(bp, vc);
 				break;
 			}
 			/* fall through */
 		case XFS_DA_NODE_MAGIC:
 			if (!xfs_da3_node_verify(vc, bp))
-				xfs_verifier_error(bp, -EFSCORRUPTED, vc->fa);
+				xfs_verifier_error(bp, vc);
 			return;
 		case XFS_ATTR_LEAF_MAGIC:
 		case XFS_ATTR3_LEAF_MAGIC:
@@ -224,7 +224,8 @@ xfs_da3_node_read_verify(
 			bp->b_ops->verify_read(vc, bp);
 			return;
 		default:
-			xfs_verifier_error(bp, -EFSCORRUPTED, __this_address);
+			XFS_CORRUPTED(vc);
+			xfs_verifier_error(bp, vc);
 			break;
 	}
 }
diff --git a/fs/xfs/libxfs/xfs_dir2_block.c b/fs/xfs/libxfs/xfs_dir2_block.c
index 4f0cd0dbc564..46db4a7269d8 100644
--- a/fs/xfs/libxfs/xfs_dir2_block.c
+++ b/fs/xfs/libxfs/xfs_dir2_block.c
@@ -79,10 +79,10 @@ xfs_dir3_block_read_verify(
 
 	if (xfs_sb_version_hascrc(&mp->m_sb) &&
 	     !xfs_buf_verify_cksum(vc, bp, XFS_DIR3_DATA_CRC_OFF))
-		xfs_verifier_error(bp, -EFSBADCRC, vc->fa);
+		xfs_verifier_error(bp, vc);
 	else {
 		if (!xfs_dir3_block_verify(vc, bp))
-			xfs_verifier_error(bp, -EFSCORRUPTED, vc->fa);
+			xfs_verifier_error(bp, vc);
 	}
 }
 
@@ -96,7 +96,7 @@ xfs_dir3_block_write_verify(
 	struct xfs_dir3_blk_hdr	*hdr3 = bp->b_addr;
 
 	if (!xfs_dir3_block_verify(vc, bp)) {
-		xfs_verifier_error(bp, -EFSCORRUPTED, vc->fa);
+		xfs_verifier_error(bp, vc);
 		return;
 	}
 
diff --git a/fs/xfs/libxfs/xfs_dir2_data.c b/fs/xfs/libxfs/xfs_dir2_data.c
index ad78bfd5eea6..9904571a76d0 100644
--- a/fs/xfs/libxfs/xfs_dir2_data.c
+++ b/fs/xfs/libxfs/xfs_dir2_data.c
@@ -291,7 +291,8 @@ xfs_dir3_data_reada_verify(
 		bp->b_ops->verify_read(vc, bp);
 		return;
 	default:
-		xfs_verifier_error(bp, -EFSCORRUPTED, __this_address);
+		XFS_CORRUPTED(vc);
+		xfs_verifier_error(bp, vc);
 		break;
 	}
 }
@@ -305,10 +306,10 @@ xfs_dir3_data_read_verify(
 
 	if (xfs_sb_version_hascrc(&mp->m_sb) &&
 	    !xfs_buf_verify_cksum(vc, bp, XFS_DIR3_DATA_CRC_OFF))
-		xfs_verifier_error(bp, -EFSBADCRC, vc->fa);
+		xfs_verifier_error(bp, vc);
 	else {
 		if (!xfs_dir3_data_verify(vc, bp))
-			xfs_verifier_error(bp, -EFSCORRUPTED, vc->fa);
+			xfs_verifier_error(bp, vc);
 	}
 }
 
@@ -322,7 +323,7 @@ xfs_dir3_data_write_verify(
 	struct xfs_dir3_blk_hdr	*hdr3 = bp->b_addr;
 
 	if (!xfs_dir3_data_verify(vc, bp)) {
-		xfs_verifier_error(bp, -EFSCORRUPTED, vc->fa);
+		xfs_verifier_error(bp, vc);
 		return;
 	}
 
diff --git a/fs/xfs/libxfs/xfs_dir2_leaf.c b/fs/xfs/libxfs/xfs_dir2_leaf.c
index ad1af1eeda53..aa423cd57bd7 100644
--- a/fs/xfs/libxfs/xfs_dir2_leaf.c
+++ b/fs/xfs/libxfs/xfs_dir2_leaf.c
@@ -185,10 +185,10 @@ __read_verify(
 
 	if (xfs_sb_version_hascrc(&mp->m_sb) &&
 	     !xfs_buf_verify_cksum(vc, bp, XFS_DIR3_LEAF_CRC_OFF))
-		xfs_verifier_error(bp, -EFSBADCRC, vc->fa);
+		xfs_verifier_error(bp, vc);
 	else {
 		if (!xfs_dir3_leaf_verify(vc, bp, magic))
-			xfs_verifier_error(bp, -EFSCORRUPTED, vc->fa);
+			xfs_verifier_error(bp, vc);
 	}
 }
 
@@ -203,7 +203,7 @@ __write_verify(
 	struct xfs_dir3_leaf_hdr *hdr3 = bp->b_addr;
 
 	if (!xfs_dir3_leaf_verify(vc, bp, magic)) {
-		xfs_verifier_error(bp, -EFSCORRUPTED, vc->fa);
+		xfs_verifier_error(bp, vc);
 		return;
 	}
 
diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
index 784534734485..8a78233bff9d 100644
--- a/fs/xfs/libxfs/xfs_dir2_node.c
+++ b/fs/xfs/libxfs/xfs_dir2_node.c
@@ -118,10 +118,10 @@ xfs_dir3_free_read_verify(
 
 	if (xfs_sb_version_hascrc(&mp->m_sb) &&
 	    !xfs_buf_verify_cksum(vc, bp, XFS_DIR3_FREE_CRC_OFF))
-		xfs_verifier_error(bp, -EFSBADCRC, vc->fa);
+		xfs_verifier_error(bp, vc);
 	else {
 		if (!xfs_dir3_free_verify(vc, bp))
-			xfs_verifier_error(bp, -EFSCORRUPTED, vc->fa);
+			xfs_verifier_error(bp, vc);
 	}
 }
 
@@ -135,7 +135,7 @@ xfs_dir3_free_write_verify(
 	struct xfs_dir3_blk_hdr	*hdr3 = bp->b_addr;
 
 	if (!xfs_dir3_free_verify(vc, bp)) {
-		xfs_verifier_error(bp, -EFSCORRUPTED, vc->fa);
+		xfs_verifier_error(bp, vc);
 		return;
 	}
 
@@ -211,7 +211,7 @@ __xfs_dir3_free_read(
 
 	/* Check things that we can't do in the verifier. */
 	if (!xfs_dir3_free_header_check(&vc, dp, fbno, *bpp)) {
-		xfs_verifier_error(*bpp, -EFSCORRUPTED, vc.fa);
+		xfs_verifier_error(*bpp, &vc);
 		xfs_trans_brelse(tp, *bpp);
 		return -EFSCORRUPTED;
 	}
diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index 71745ec0d92f..99df9cb8161e 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -2557,11 +2557,11 @@ xfs_agi_read_verify(
 
 	if (xfs_sb_version_hascrc(&mp->m_sb) &&
 	    !xfs_buf_verify_cksum(vc, bp, XFS_AGI_CRC_OFF))
-		xfs_verifier_error(bp, -EFSBADCRC, vc->fa);
+		xfs_verifier_error(bp, vc);
 	else {
 		if (XFS_TEST_ERROR(!xfs_agi_verify(vc, bp),
 				   mp, XFS_ERRTAG_IALLOC_READ_AGI))
-			xfs_verifier_error(bp, -EFSCORRUPTED, vc->fa);
+			xfs_verifier_error(bp, vc);
 	}
 }
 
@@ -2574,7 +2574,7 @@ xfs_agi_write_verify(
 	struct xfs_buf_log_item	*bip = bp->b_log_item;
 
 	if (!xfs_agi_verify(vc, bp)) {
-		xfs_verifier_error(bp, -EFSCORRUPTED, vc->fa);
+		xfs_verifier_error(bp, vc);
 		return;
 	}
 
diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.c b/fs/xfs/libxfs/xfs_ialloc_btree.c
index a0bb695944e9..e1d5551aa57d 100644
--- a/fs/xfs/libxfs/xfs_ialloc_btree.c
+++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
@@ -300,10 +300,10 @@ xfs_inobt_read_verify(
 	struct xfs_buf	*bp)
 {
 	if (!xfs_btree_sblock_verify_crc(vc, bp))
-		xfs_verifier_error(bp, -EFSBADCRC, vc->fa);
+		xfs_verifier_error(bp, vc);
 	else {
 		if (!xfs_inobt_verify(vc, bp))
-			xfs_verifier_error(bp, -EFSCORRUPTED, vc->fa);
+			xfs_verifier_error(bp, vc);
 	}
 
 	if (bp->b_error)
@@ -317,7 +317,7 @@ xfs_inobt_write_verify(
 {
 	if (!xfs_inobt_verify(vc, bp)) {
 		trace_xfs_btree_corrupt(bp, _RET_IP_);
-		xfs_verifier_error(bp, -EFSCORRUPTED, vc->fa);
+		xfs_verifier_error(bp, vc);
 		return;
 	}
 	xfs_btree_sblock_calc_crc(bp);
diff --git a/fs/xfs/libxfs/xfs_refcount_btree.c b/fs/xfs/libxfs/xfs_refcount_btree.c
index 748074c5ebeb..de921233202d 100644
--- a/fs/xfs/libxfs/xfs_refcount_btree.c
+++ b/fs/xfs/libxfs/xfs_refcount_btree.c
@@ -235,10 +235,10 @@ xfs_refcountbt_read_verify(
 	struct xfs_buf	*bp)
 {
 	if (!xfs_btree_sblock_verify_crc(vc, bp))
-		xfs_verifier_error(bp, -EFSBADCRC, vc->fa);
+		xfs_verifier_error(bp, vc);
 	else {
 		if (!xfs_refcountbt_verify(vc, bp))
-			xfs_verifier_error(bp, -EFSCORRUPTED, vc->fa);
+			xfs_verifier_error(bp, vc);
 	}
 
 	if (bp->b_error)
@@ -252,7 +252,7 @@ xfs_refcountbt_write_verify(
 {
 	if (!xfs_refcountbt_verify(vc, bp)) {
 		trace_xfs_btree_corrupt(bp, _RET_IP_);
-		xfs_verifier_error(bp, -EFSCORRUPTED, vc->fa);
+		xfs_verifier_error(bp, vc);
 		return;
 	}
 	xfs_btree_sblock_calc_crc(bp);
diff --git a/fs/xfs/libxfs/xfs_rmap_btree.c b/fs/xfs/libxfs/xfs_rmap_btree.c
index 6d2eba7b44bc..4e5449681686 100644
--- a/fs/xfs/libxfs/xfs_rmap_btree.c
+++ b/fs/xfs/libxfs/xfs_rmap_btree.c
@@ -334,10 +334,10 @@ xfs_rmapbt_read_verify(
 	struct xfs_buf	*bp)
 {
 	if (!xfs_btree_sblock_verify_crc(vc, bp))
-		xfs_verifier_error(bp, -EFSBADCRC, vc->fa);
+		xfs_verifier_error(bp, vc);
 	else {
 		if (!xfs_rmapbt_verify(vc, bp))
-			xfs_verifier_error(bp, -EFSCORRUPTED, vc->fa);
+			xfs_verifier_error(bp, vc);
 	}
 
 	if (bp->b_error)
@@ -351,7 +351,7 @@ xfs_rmapbt_write_verify(
 {
 	if (!xfs_rmapbt_verify(vc, bp)) {
 		trace_xfs_btree_corrupt(bp, _RET_IP_);
-		xfs_verifier_error(bp, -EFSCORRUPTED, vc->fa);
+		xfs_verifier_error(bp, vc);
 		return;
 	}
 	xfs_btree_sblock_calc_crc(bp);
diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index 07e866103dc2..50726c54c2ca 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -719,9 +719,13 @@ xfs_sb_read_verify(
 	error = xfs_validate_sb_read(mp, &sb);
 
 out_error:
-	if (error == -EFSCORRUPTED || error == -EFSBADCRC)
-		xfs_verifier_error(bp, error, __this_address);
-	else if (error)
+	if (error == -EFSCORRUPTED) {
+		XFS_CORRUPTED(vc);
+		xfs_verifier_error(bp, vc);
+	} else if (error == -EFSBADCRC) {
+		XFS_BADCRC(vc);
+		xfs_verifier_error(bp, vc);
+	} else if (error)
 		xfs_buf_ioerror(bp, error);
 }
 
@@ -779,7 +783,9 @@ xfs_sb_write_verify(
 	return;
 
 out_error:
-	xfs_verifier_error(bp, error, __this_address);
+	vc->fa = __this_address;
+	vc->errno = error;
+	xfs_verifier_error(bp, vc);
 }
 
 const struct xfs_buf_ops xfs_sb_buf_ops = {
diff --git a/fs/xfs/libxfs/xfs_symlink_remote.c b/fs/xfs/libxfs/xfs_symlink_remote.c
index d6516068bbe7..0c708fb92e89 100644
--- a/fs/xfs/libxfs/xfs_symlink_remote.c
+++ b/fs/xfs/libxfs/xfs_symlink_remote.c
@@ -125,10 +125,10 @@ xfs_symlink_read_verify(
 		return;
 
 	if (!xfs_buf_verify_cksum(vc, bp, XFS_SYMLINK_CRC_OFF))
-		xfs_verifier_error(bp, -EFSBADCRC, vc->fa);
+		xfs_verifier_error(bp, vc);
 	else {
 		if (!xfs_symlink_verify(vc, bp))
-			xfs_verifier_error(bp, -EFSCORRUPTED, vc->fa);
+			xfs_verifier_error(bp, vc);
 	}
 }
 
@@ -145,7 +145,7 @@ xfs_symlink_write_verify(
 		return;
 
 	if (!xfs_symlink_verify(vc, bp)) {
-		xfs_verifier_error(bp, -EFSCORRUPTED, vc->fa);
+		xfs_verifier_error(bp, vc);
 		return;
 	}
 
diff --git a/fs/xfs/libxfs/xfs_types.h b/fs/xfs/libxfs/xfs_types.h
index ab045e8dfcb9..4f0b8c73b599 100644
--- a/fs/xfs/libxfs/xfs_types.h
+++ b/fs/xfs/libxfs/xfs_types.h
@@ -41,7 +41,13 @@ typedef int64_t		xfs_sfiloff_t;	/* signed block number in a file */
  */
 typedef void *		xfs_failaddr_t;
 
+#ifndef EFSCORRUPTED
+#define EFSCORRUPTED    EUCLEAN         /* Filesystem is corrupted */
+#define EFSBADCRC       EBADMSG         /* Bad CRC detected */
+#endif
+
 struct xfs_vc {
+	int		errno;
 	xfs_failaddr_t	fa;
 };
 
@@ -51,10 +57,14 @@ struct xfs_vc {
  * return, which throws off the reported address.
  */
 #define __this_address ({ __label__ __here; __here: barrier(); &&__here; })
+
+#define XFS_CORRUPTED(vc)	({(vc)->fa = __this_address; (vc)->errno = -EFSCORRUPTED;})
+#define XFS_BADCRC(vc)		({(vc)->fa = __this_address; (vc)->errno = -EFSBADCRC;})
+#define XFS_VERIFIED(vc)	({(vc)->fa = NULL; (vc)->errno = 0;})
  
-#define XFS_CORRUPTED_RETURN(vc)	({(vc)->fa = __this_address; false;})
-#define XFS_BADCRC_RETURN(vc)		({(vc)->fa = __this_address; false;})
-#define XFS_VERIFIED_RETURN(vc)		({(vc)->fa = NULL; true;})
+#define XFS_CORRUPTED_RETURN(vc)	({(vc)->fa = __this_address; (vc)->errno = -EFSCORRUPTED; false;})
+#define XFS_BADCRC_RETURN(vc)		({(vc)->fa = __this_address; (vc)->errno = -EFSBADCRC; false;})
+#define XFS_VERIFIED_RETURN(vc)		({(vc)->fa = NULL; (vc)->errno = 0;  true;})
 
 /*
  * Null values for the types.
diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
index 9866f542e77b..4d305287823c 100644
--- a/fs/xfs/xfs_error.c
+++ b/fs/xfs/xfs_error.c
@@ -381,11 +381,10 @@ xfs_buf_verifier_error(
 void
 xfs_verifier_error(
 	struct xfs_buf		*bp,
-	int			error,
-	xfs_failaddr_t		failaddr)
+	struct xfs_vc		*vc)
 {
-	return xfs_buf_verifier_error(bp, error, "", xfs_buf_offset(bp, 0),
-			XFS_CORRUPTION_DUMP_LEN, failaddr);
+	return xfs_buf_verifier_error(bp, vc->errno, "", xfs_buf_offset(bp, 0),
+			XFS_CORRUPTION_DUMP_LEN, vc->fa);
 }
 
 /*
diff --git a/fs/xfs/xfs_error.h b/fs/xfs/xfs_error.h
index 246d3e989c6c..9b0ac387007d 100644
--- a/fs/xfs/xfs_error.h
+++ b/fs/xfs/xfs_error.h
@@ -18,8 +18,7 @@ extern void xfs_corruption_error(const char *tag, int level,
 extern void xfs_buf_verifier_error(struct xfs_buf *bp, int error,
 			const char *name, void *buf, size_t bufsz,
 			xfs_failaddr_t failaddr);
-extern void xfs_verifier_error(struct xfs_buf *bp, int error,
-			xfs_failaddr_t failaddr);
+extern void xfs_verifier_error(struct xfs_buf *bp, struct xfs_vc *vc);
 extern void xfs_inode_verifier_error(struct xfs_inode *ip, int error,
 			const char *name, void *buf, size_t bufsz,
 			xfs_failaddr_t failaddr);
-- 
2.17.0
