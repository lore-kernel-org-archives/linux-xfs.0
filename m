Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46985 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727592AbeLEVMC (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 5 Dec 2018 16:12:02 -0500
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 94FAD30026CB
        for <linux-xfs@vger.kernel.org>; Wed,  5 Dec 2018 21:12:01 +0000 (UTC)
Subject: [PATCH 10/10] xfs: condense crc and verifier checks where possible
References: <542b81dc-b564-c5fa-86b4-b4dc8ac50b63@redhat.com>
From: Eric Sandeen <sandeen@redhat.com>
Message-ID: <5ef4acb1-ce08-2246-8ac2-54da58e6c1b3@redhat.com>
Date: Wed, 5 Dec 2018 15:11:51 -0600
MIME-Version: 1.0
In-Reply-To: <542b81dc-b564-c5fa-86b4-b4dc8ac50b63@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

Now that failaddr and errno are set within the validating functions, the
if/else is unnecessary and we can do a compound test of crc || validated,
i.e.

	if (!xfs_buf_verify_cksum(vc, bp, XFS_AGFL_CRC_OFF) ||
	    !xfs_agfl_verify(vc, bp))
		xfs_verifier_error(bp, vc);

This condenses the code a bit and makes it a little nicer.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 fs/xfs/libxfs/xfs_alloc.c          | 18 ++++++------------
 fs/xfs/libxfs/xfs_alloc_btree.c    |  7 ++-----
 fs/xfs/libxfs/xfs_attr_leaf.c      |  9 +++------
 fs/xfs/libxfs/xfs_dir2_block.c     |  9 +++------
 fs/xfs/libxfs/xfs_dir2_data.c      |  9 +++------
 fs/xfs/libxfs/xfs_dir2_leaf.c      |  9 +++------
 fs/xfs/libxfs/xfs_dir2_node.c      |  9 +++------
 fs/xfs/libxfs/xfs_ialloc.c         | 11 ++++-------
 fs/xfs/libxfs/xfs_symlink_remote.c |  7 ++-----
 9 files changed, 29 insertions(+), 59 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 213a3078113c..5499438e6ee1 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -609,12 +609,9 @@ xfs_agfl_read_verify(
 	if (!xfs_sb_version_hascrc(&mp->m_sb))
 		return;
 
-	if (!xfs_buf_verify_cksum(vc, bp, XFS_AGFL_CRC_OFF))
+	if (!xfs_buf_verify_cksum(vc, bp, XFS_AGFL_CRC_OFF) ||
+	    !xfs_agfl_verify(vc, bp))
 		xfs_verifier_error(bp, vc);
-	else {
-		if (!xfs_agfl_verify(vc, bp))
-			xfs_verifier_error(bp, vc);
-	}
 }
 
 static void
@@ -2635,14 +2632,11 @@ xfs_agf_read_verify(
 {
 	struct xfs_mount *mp = bp->b_target->bt_mount;
 
-	if (xfs_sb_version_hascrc(&mp->m_sb) &&
-	    !xfs_buf_verify_cksum(vc, bp, XFS_AGF_CRC_OFF))
+	if ((xfs_sb_version_hascrc(&mp->m_sb) &&
+			!xfs_buf_verify_cksum(vc, bp, XFS_AGF_CRC_OFF)) ||
+	    XFS_TEST_ERROR(!xfs_agf_verify(vc, bp),
+			mp, XFS_ERRTAG_ALLOC_READ_AGF))
 		xfs_verifier_error(bp, vc);
-	else {
-		if (XFS_TEST_ERROR(!xfs_agf_verify(vc, bp),
-				   mp, XFS_ERRTAG_ALLOC_READ_AGF))
-			xfs_verifier_error(bp, vc);
-	}
 }
 
 static void
diff --git a/fs/xfs/libxfs/xfs_alloc_btree.c b/fs/xfs/libxfs/xfs_alloc_btree.c
index 9f56821b49af..84f3f9542279 100644
--- a/fs/xfs/libxfs/xfs_alloc_btree.c
+++ b/fs/xfs/libxfs/xfs_alloc_btree.c
@@ -346,12 +346,9 @@ xfs_allocbt_read_verify(
 	struct xfs_vc	*vc,
 	struct xfs_buf	*bp)
 {
-	if (!xfs_btree_sblock_verify_crc(vc, bp))
+	if (!xfs_btree_sblock_verify_crc(vc, bp) ||
+	    !xfs_allocbt_verify(vc, bp))
 		xfs_verifier_error(bp, vc);
-	else {
-		if (!xfs_allocbt_verify(vc, bp))
-			xfs_verifier_error(bp, vc);
-	}
 
 	if (bp->b_error)
 		trace_xfs_btree_corrupt(bp, _RET_IP_);
diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index 34958aa7fe5f..3f116f57c57d 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -357,13 +357,10 @@ xfs_attr3_leaf_read_verify(
 {
 	struct xfs_mount	*mp = bp->b_target->bt_mount;
 
-	if (xfs_sb_version_hascrc(&mp->m_sb) &&
-	     !xfs_buf_verify_cksum(vc, bp, XFS_ATTR3_LEAF_CRC_OFF))
+	if ((xfs_sb_version_hascrc(&mp->m_sb) &&
+			!xfs_buf_verify_cksum(vc, bp, XFS_ATTR3_LEAF_CRC_OFF)) ||
+	    !xfs_attr3_leaf_verify(vc, bp))
 		xfs_verifier_error(bp, vc);
-	else {
-		if (!xfs_attr3_leaf_verify(vc, bp))
-			xfs_verifier_error(bp, vc);
-	}
 }
 
 const struct xfs_buf_ops xfs_attr3_leaf_buf_ops = {
diff --git a/fs/xfs/libxfs/xfs_dir2_block.c b/fs/xfs/libxfs/xfs_dir2_block.c
index 46db4a7269d8..b59d2331ee24 100644
--- a/fs/xfs/libxfs/xfs_dir2_block.c
+++ b/fs/xfs/libxfs/xfs_dir2_block.c
@@ -77,13 +77,10 @@ xfs_dir3_block_read_verify(
 {
 	struct xfs_mount	*mp = bp->b_target->bt_mount;
 
-	if (xfs_sb_version_hascrc(&mp->m_sb) &&
-	     !xfs_buf_verify_cksum(vc, bp, XFS_DIR3_DATA_CRC_OFF))
+	if ((xfs_sb_version_hascrc(&mp->m_sb) &&
+			!xfs_buf_verify_cksum(vc, bp, XFS_DIR3_DATA_CRC_OFF)) ||
+	    !xfs_dir3_block_verify(vc, bp))
 		xfs_verifier_error(bp, vc);
-	else {
-		if (!xfs_dir3_block_verify(vc, bp))
-			xfs_verifier_error(bp, vc);
-	}
 }
 
 static void
diff --git a/fs/xfs/libxfs/xfs_dir2_data.c b/fs/xfs/libxfs/xfs_dir2_data.c
index 9904571a76d0..554d2b0f06b4 100644
--- a/fs/xfs/libxfs/xfs_dir2_data.c
+++ b/fs/xfs/libxfs/xfs_dir2_data.c
@@ -304,13 +304,10 @@ xfs_dir3_data_read_verify(
 {
 	struct xfs_mount	*mp = bp->b_target->bt_mount;
 
-	if (xfs_sb_version_hascrc(&mp->m_sb) &&
-	    !xfs_buf_verify_cksum(vc, bp, XFS_DIR3_DATA_CRC_OFF))
+	if ((xfs_sb_version_hascrc(&mp->m_sb) &&
+			!xfs_buf_verify_cksum(vc, bp, XFS_DIR3_DATA_CRC_OFF)) ||
+	    !xfs_dir3_data_verify(vc, bp))
 		xfs_verifier_error(bp, vc);
-	else {
-		if (!xfs_dir3_data_verify(vc, bp))
-			xfs_verifier_error(bp, vc);
-	}
 }
 
 static void
diff --git a/fs/xfs/libxfs/xfs_dir2_leaf.c b/fs/xfs/libxfs/xfs_dir2_leaf.c
index aa423cd57bd7..b316f3d63e89 100644
--- a/fs/xfs/libxfs/xfs_dir2_leaf.c
+++ b/fs/xfs/libxfs/xfs_dir2_leaf.c
@@ -183,13 +183,10 @@ __read_verify(
 {
 	struct xfs_mount	*mp = bp->b_target->bt_mount;
 
-	if (xfs_sb_version_hascrc(&mp->m_sb) &&
-	     !xfs_buf_verify_cksum(vc, bp, XFS_DIR3_LEAF_CRC_OFF))
+	if ((xfs_sb_version_hascrc(&mp->m_sb) &&
+			!xfs_buf_verify_cksum(vc, bp, XFS_DIR3_LEAF_CRC_OFF)) ||
+	    !xfs_dir3_leaf_verify(vc, bp, magic))
 		xfs_verifier_error(bp, vc);
-	else {
-		if (!xfs_dir3_leaf_verify(vc, bp, magic))
-			xfs_verifier_error(bp, vc);
-	}
 }
 
 static void
diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
index 8a78233bff9d..b88452362247 100644
--- a/fs/xfs/libxfs/xfs_dir2_node.c
+++ b/fs/xfs/libxfs/xfs_dir2_node.c
@@ -116,13 +116,10 @@ xfs_dir3_free_read_verify(
 {
 	struct xfs_mount	*mp = bp->b_target->bt_mount;
 
-	if (xfs_sb_version_hascrc(&mp->m_sb) &&
-	    !xfs_buf_verify_cksum(vc, bp, XFS_DIR3_FREE_CRC_OFF))
+	if ((xfs_sb_version_hascrc(&mp->m_sb) &&
+			!xfs_buf_verify_cksum(vc, bp, XFS_DIR3_FREE_CRC_OFF)) ||
+	    !xfs_dir3_free_verify(vc, bp))
 		xfs_verifier_error(bp, vc);
-	else {
-		if (!xfs_dir3_free_verify(vc, bp))
-			xfs_verifier_error(bp, vc);
-	}
 }
 
 static void
diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index 99df9cb8161e..ec6b32da1217 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -2555,14 +2555,11 @@ xfs_agi_read_verify(
 {
 	struct xfs_mount *mp = bp->b_target->bt_mount;
 
-	if (xfs_sb_version_hascrc(&mp->m_sb) &&
-	    !xfs_buf_verify_cksum(vc, bp, XFS_AGI_CRC_OFF))
+	if ((xfs_sb_version_hascrc(&mp->m_sb) &&
+			!xfs_buf_verify_cksum(vc, bp, XFS_AGI_CRC_OFF)) ||
+	    XFS_TEST_ERROR(!xfs_agi_verify(vc, bp),
+			   mp, XFS_ERRTAG_IALLOC_READ_AGI))
 		xfs_verifier_error(bp, vc);
-	else {
-		if (XFS_TEST_ERROR(!xfs_agi_verify(vc, bp),
-				   mp, XFS_ERRTAG_IALLOC_READ_AGI))
-			xfs_verifier_error(bp, vc);
-	}
 }
 
 static void
diff --git a/fs/xfs/libxfs/xfs_symlink_remote.c b/fs/xfs/libxfs/xfs_symlink_remote.c
index 0c708fb92e89..9f251b5205a9 100644
--- a/fs/xfs/libxfs/xfs_symlink_remote.c
+++ b/fs/xfs/libxfs/xfs_symlink_remote.c
@@ -124,12 +124,9 @@ xfs_symlink_read_verify(
 	if (!xfs_sb_version_hascrc(&mp->m_sb))
 		return;
 
-	if (!xfs_buf_verify_cksum(vc, bp, XFS_SYMLINK_CRC_OFF))
+	if (!xfs_buf_verify_cksum(vc, bp, XFS_SYMLINK_CRC_OFF) ||
+	    !xfs_symlink_verify(vc, bp))
 		xfs_verifier_error(bp, vc);
-	else {
-		if (!xfs_symlink_verify(vc, bp))
-			xfs_verifier_error(bp, vc);
-	}
 }
 
 static void
-- 
2.17.0
