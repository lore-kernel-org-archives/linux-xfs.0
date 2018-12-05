Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58560 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727575AbeLEVJx (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 5 Dec 2018 16:09:53 -0500
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E14A6811D5
        for <linux-xfs@vger.kernel.org>; Wed,  5 Dec 2018 21:09:52 +0000 (UTC)
Subject: [PATCH 08/10] xfs: set failaddr into vc for checksum failures
References: <542b81dc-b564-c5fa-86b4-b4dc8ac50b63@redhat.com>
From: Eric Sandeen <sandeen@redhat.com>
Message-ID: <d380b0b8-b88f-fc96-8515-c5bd97918317@redhat.com>
Date: Wed, 5 Dec 2018 15:09:48 -0600
MIME-Version: 1.0
In-Reply-To: <542b81dc-b564-c5fa-86b4-b4dc8ac50b63@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

Modify CRC checking functions to set __this_address into the
verifier context failaddr vc->fa using new macro XFS_BADCRC_RETURN,
and pass that to failure handlers as well.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 fs/xfs/libxfs/xfs_alloc.c          |  4 ++--
 fs/xfs/libxfs/xfs_alloc_btree.c    |  2 +-
 fs/xfs/libxfs/xfs_attr_leaf.c      |  2 +-
 fs/xfs/libxfs/xfs_bmap_btree.c     |  2 +-
 fs/xfs/libxfs/xfs_cksum.h          |  5 ++++-
 fs/xfs/libxfs/xfs_da_btree.c       |  3 +--
 fs/xfs/libxfs/xfs_dir2_block.c     |  2 +-
 fs/xfs/libxfs/xfs_dir2_data.c      |  2 +-
 fs/xfs/libxfs/xfs_dir2_leaf.c      |  2 +-
 fs/xfs/libxfs/xfs_dir2_node.c      |  2 +-
 fs/xfs/libxfs/xfs_ialloc.c         |  2 +-
 fs/xfs/libxfs/xfs_ialloc_btree.c   |  2 +-
 fs/xfs/libxfs/xfs_refcount_btree.c |  2 +-
 fs/xfs/libxfs/xfs_rmap_btree.c     |  2 +-
 fs/xfs/libxfs/xfs_symlink_remote.c |  2 +-
 fs/xfs/libxfs/xfs_types.h          | 12 ++++++++++--
 fs/xfs/xfs_linux.h                 |  7 -------
 17 files changed, 29 insertions(+), 26 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index b9e3c69490eb..14611b12220a 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -610,7 +610,7 @@ xfs_agfl_read_verify(
 		return;
 
 	if (!xfs_buf_verify_cksum(vc, bp, XFS_AGFL_CRC_OFF))
-		xfs_verifier_error(bp, -EFSBADCRC, __this_address);
+		xfs_verifier_error(bp, -EFSBADCRC, vc->fa);
 	else {
 		if (!xfs_agfl_verify(vc, bp))
 			xfs_verifier_error(bp, -EFSCORRUPTED, vc->fa);
@@ -2637,7 +2637,7 @@ xfs_agf_read_verify(
 
 	if (xfs_sb_version_hascrc(&mp->m_sb) &&
 	    !xfs_buf_verify_cksum(vc, bp, XFS_AGF_CRC_OFF))
-		xfs_verifier_error(bp, -EFSBADCRC, __this_address);
+		xfs_verifier_error(bp, -EFSBADCRC, vc->fa);
 	else {
 		if (XFS_TEST_ERROR(!xfs_agf_verify(vc, bp),
 				   mp, XFS_ERRTAG_ALLOC_READ_AGF))
diff --git a/fs/xfs/libxfs/xfs_alloc_btree.c b/fs/xfs/libxfs/xfs_alloc_btree.c
index 87d96e66d4ca..40040505794a 100644
--- a/fs/xfs/libxfs/xfs_alloc_btree.c
+++ b/fs/xfs/libxfs/xfs_alloc_btree.c
@@ -347,7 +347,7 @@ xfs_allocbt_read_verify(
 	struct xfs_buf	*bp)
 {
 	if (!xfs_btree_sblock_verify_crc(vc, bp))
-		xfs_verifier_error(bp, -EFSBADCRC, __this_address);
+		xfs_verifier_error(bp, -EFSBADCRC, vc->fa);
 	else {
 		if (!xfs_allocbt_verify(vc, bp))
 			xfs_verifier_error(bp, -EFSCORRUPTED, vc->fa);
diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index 724b13f61da6..a69ff26a4558 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -359,7 +359,7 @@ xfs_attr3_leaf_read_verify(
 
 	if (xfs_sb_version_hascrc(&mp->m_sb) &&
 	     !xfs_buf_verify_cksum(vc, bp, XFS_ATTR3_LEAF_CRC_OFF))
-		xfs_verifier_error(bp, -EFSBADCRC, __this_address);
+		xfs_verifier_error(bp, -EFSBADCRC, vc->fa);
 	else {
 		if (!xfs_attr3_leaf_verify(vc, bp))
 			xfs_verifier_error(bp, -EFSCORRUPTED, vc->fa);
diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
index fc4ea15ca6c1..485b207f715f 100644
--- a/fs/xfs/libxfs/xfs_bmap_btree.c
+++ b/fs/xfs/libxfs/xfs_bmap_btree.c
@@ -451,7 +451,7 @@ xfs_bmbt_read_verify(
 	struct xfs_buf	*bp)
 {
 	if (!xfs_btree_lblock_verify_crc(vc, bp))
-		xfs_verifier_error(bp, -EFSBADCRC, __this_address);
+		xfs_verifier_error(bp, -EFSBADCRC, vc->fa);
 	else {
 		if (!xfs_bmbt_verify(vc, bp))
 			xfs_verifier_error(bp, -EFSCORRUPTED, vc->fa);
diff --git a/fs/xfs/libxfs/xfs_cksum.h b/fs/xfs/libxfs/xfs_cksum.h
index 888ef9ec4c57..ea4a2474e64b 100644
--- a/fs/xfs/libxfs/xfs_cksum.h
+++ b/fs/xfs/libxfs/xfs_cksum.h
@@ -77,7 +77,10 @@ xfs_verify_cksum(struct xfs_vc *vc, char *buffer, size_t length,
 {
 	uint32_t crc = xfs_start_cksum_safe(buffer, length, cksum_offset);
 
-	return *(__le32 *)(buffer + cksum_offset) == xfs_end_cksum(crc);
+	if (*(__le32 *)(buffer + cksum_offset) != xfs_end_cksum(crc))
+		return XFS_BADCRC_RETURN(vc);
+
+	return XFS_VERIFIED_RETURN(vc);
 }
 
 #endif /* _XFS_CKSUM_H */
diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
index 0b4f084766e3..b26ae562c8c7 100644
--- a/fs/xfs/libxfs/xfs_da_btree.c
+++ b/fs/xfs/libxfs/xfs_da_btree.c
@@ -205,8 +205,7 @@ xfs_da3_node_read_verify(
 	switch (be16_to_cpu(info->magic)) {
 		case XFS_DA3_NODE_MAGIC:
 			if (!xfs_buf_verify_cksum(vc, bp, XFS_DA3_NODE_CRC_OFF)) {
-				xfs_verifier_error(bp, -EFSBADCRC,
-						__this_address);
+				xfs_verifier_error(bp, -EFSBADCRC, vc->fa);
 				break;
 			}
 			/* fall through */
diff --git a/fs/xfs/libxfs/xfs_dir2_block.c b/fs/xfs/libxfs/xfs_dir2_block.c
index 534d5fcf13b3..4f0cd0dbc564 100644
--- a/fs/xfs/libxfs/xfs_dir2_block.c
+++ b/fs/xfs/libxfs/xfs_dir2_block.c
@@ -79,7 +79,7 @@ xfs_dir3_block_read_verify(
 
 	if (xfs_sb_version_hascrc(&mp->m_sb) &&
 	     !xfs_buf_verify_cksum(vc, bp, XFS_DIR3_DATA_CRC_OFF))
-		xfs_verifier_error(bp, -EFSBADCRC, __this_address);
+		xfs_verifier_error(bp, -EFSBADCRC, vc->fa);
 	else {
 		if (!xfs_dir3_block_verify(vc, bp))
 			xfs_verifier_error(bp, -EFSCORRUPTED, vc->fa);
diff --git a/fs/xfs/libxfs/xfs_dir2_data.c b/fs/xfs/libxfs/xfs_dir2_data.c
index a215c7adb480..ad78bfd5eea6 100644
--- a/fs/xfs/libxfs/xfs_dir2_data.c
+++ b/fs/xfs/libxfs/xfs_dir2_data.c
@@ -305,7 +305,7 @@ xfs_dir3_data_read_verify(
 
 	if (xfs_sb_version_hascrc(&mp->m_sb) &&
 	    !xfs_buf_verify_cksum(vc, bp, XFS_DIR3_DATA_CRC_OFF))
-		xfs_verifier_error(bp, -EFSBADCRC, __this_address);
+		xfs_verifier_error(bp, -EFSBADCRC, vc->fa);
 	else {
 		if (!xfs_dir3_data_verify(vc, bp))
 			xfs_verifier_error(bp, -EFSCORRUPTED, vc->fa);
diff --git a/fs/xfs/libxfs/xfs_dir2_leaf.c b/fs/xfs/libxfs/xfs_dir2_leaf.c
index e757e1f950e4..ad1af1eeda53 100644
--- a/fs/xfs/libxfs/xfs_dir2_leaf.c
+++ b/fs/xfs/libxfs/xfs_dir2_leaf.c
@@ -185,7 +185,7 @@ __read_verify(
 
 	if (xfs_sb_version_hascrc(&mp->m_sb) &&
 	     !xfs_buf_verify_cksum(vc, bp, XFS_DIR3_LEAF_CRC_OFF))
-		xfs_verifier_error(bp, -EFSBADCRC, __this_address);
+		xfs_verifier_error(bp, -EFSBADCRC, vc->fa);
 	else {
 		if (!xfs_dir3_leaf_verify(vc, bp, magic))
 			xfs_verifier_error(bp, -EFSCORRUPTED, vc->fa);
diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
index 8105544c44fb..784534734485 100644
--- a/fs/xfs/libxfs/xfs_dir2_node.c
+++ b/fs/xfs/libxfs/xfs_dir2_node.c
@@ -118,7 +118,7 @@ xfs_dir3_free_read_verify(
 
 	if (xfs_sb_version_hascrc(&mp->m_sb) &&
 	    !xfs_buf_verify_cksum(vc, bp, XFS_DIR3_FREE_CRC_OFF))
-		xfs_verifier_error(bp, -EFSBADCRC, __this_address);
+		xfs_verifier_error(bp, -EFSBADCRC, vc->fa);
 	else {
 		if (!xfs_dir3_free_verify(vc, bp))
 			xfs_verifier_error(bp, -EFSCORRUPTED, vc->fa);
diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index 32fb58c929f0..71745ec0d92f 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -2557,7 +2557,7 @@ xfs_agi_read_verify(
 
 	if (xfs_sb_version_hascrc(&mp->m_sb) &&
 	    !xfs_buf_verify_cksum(vc, bp, XFS_AGI_CRC_OFF))
-		xfs_verifier_error(bp, -EFSBADCRC, __this_address);
+		xfs_verifier_error(bp, -EFSBADCRC, vc->fa);
 	else {
 		if (XFS_TEST_ERROR(!xfs_agi_verify(vc, bp),
 				   mp, XFS_ERRTAG_IALLOC_READ_AGI))
diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.c b/fs/xfs/libxfs/xfs_ialloc_btree.c
index 30a1fcf24767..a0bb695944e9 100644
--- a/fs/xfs/libxfs/xfs_ialloc_btree.c
+++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
@@ -300,7 +300,7 @@ xfs_inobt_read_verify(
 	struct xfs_buf	*bp)
 {
 	if (!xfs_btree_sblock_verify_crc(vc, bp))
-		xfs_verifier_error(bp, -EFSBADCRC, __this_address);
+		xfs_verifier_error(bp, -EFSBADCRC, vc->fa);
 	else {
 		if (!xfs_inobt_verify(vc, bp))
 			xfs_verifier_error(bp, -EFSCORRUPTED, vc->fa);
diff --git a/fs/xfs/libxfs/xfs_refcount_btree.c b/fs/xfs/libxfs/xfs_refcount_btree.c
index 4b4c80fd3d6c..748074c5ebeb 100644
--- a/fs/xfs/libxfs/xfs_refcount_btree.c
+++ b/fs/xfs/libxfs/xfs_refcount_btree.c
@@ -235,7 +235,7 @@ xfs_refcountbt_read_verify(
 	struct xfs_buf	*bp)
 {
 	if (!xfs_btree_sblock_verify_crc(vc, bp))
-		xfs_verifier_error(bp, -EFSBADCRC, __this_address);
+		xfs_verifier_error(bp, -EFSBADCRC, vc->fa);
 	else {
 		if (!xfs_refcountbt_verify(vc, bp))
 			xfs_verifier_error(bp, -EFSCORRUPTED, vc->fa);
diff --git a/fs/xfs/libxfs/xfs_rmap_btree.c b/fs/xfs/libxfs/xfs_rmap_btree.c
index ed0022fb03f6..6d2eba7b44bc 100644
--- a/fs/xfs/libxfs/xfs_rmap_btree.c
+++ b/fs/xfs/libxfs/xfs_rmap_btree.c
@@ -334,7 +334,7 @@ xfs_rmapbt_read_verify(
 	struct xfs_buf	*bp)
 {
 	if (!xfs_btree_sblock_verify_crc(vc, bp))
-		xfs_verifier_error(bp, -EFSBADCRC, __this_address);
+		xfs_verifier_error(bp, -EFSBADCRC, vc->fa);
 	else {
 		if (!xfs_rmapbt_verify(vc, bp))
 			xfs_verifier_error(bp, -EFSCORRUPTED, vc->fa);
diff --git a/fs/xfs/libxfs/xfs_symlink_remote.c b/fs/xfs/libxfs/xfs_symlink_remote.c
index 401398d0235a..d6516068bbe7 100644
--- a/fs/xfs/libxfs/xfs_symlink_remote.c
+++ b/fs/xfs/libxfs/xfs_symlink_remote.c
@@ -125,7 +125,7 @@ xfs_symlink_read_verify(
 		return;
 
 	if (!xfs_buf_verify_cksum(vc, bp, XFS_SYMLINK_CRC_OFF))
-		xfs_verifier_error(bp, -EFSBADCRC, __this_address);
+		xfs_verifier_error(bp, -EFSBADCRC, vc->fa);
 	else {
 		if (!xfs_symlink_verify(vc, bp))
 			xfs_verifier_error(bp, -EFSCORRUPTED, vc->fa);
diff --git a/fs/xfs/libxfs/xfs_types.h b/fs/xfs/libxfs/xfs_types.h
index 29b0d354d9b7..ab045e8dfcb9 100644
--- a/fs/xfs/libxfs/xfs_types.h
+++ b/fs/xfs/libxfs/xfs_types.h
@@ -45,8 +45,16 @@ struct xfs_vc {
 	xfs_failaddr_t	fa;
 };
 
-#define XFS_CORRUPTED_RETURN(vc) ({(vc)->fa = __this_address; false;})
-#define XFS_VERIFIED_RETURN(vc) ({(vc)->fa = NULL; true;})
+/*
+ * Return the address of a label.  Use barrier() so that the optimizer
+ * won't reorder code to refactor the error jumpouts into a single
+ * return, which throws off the reported address.
+ */
+#define __this_address ({ __label__ __here; __here: barrier(); &&__here; })
+ 
+#define XFS_CORRUPTED_RETURN(vc)	({(vc)->fa = __this_address; false;})
+#define XFS_BADCRC_RETURN(vc)		({(vc)->fa = __this_address; false;})
+#define XFS_VERIFIED_RETURN(vc)		({(vc)->fa = NULL; true;})
 
 /*
  * Null values for the types.
diff --git a/fs/xfs/xfs_linux.h b/fs/xfs/xfs_linux.h
index edbd5a210df2..4141e70bb3fa 100644
--- a/fs/xfs/xfs_linux.h
+++ b/fs/xfs/xfs_linux.h
@@ -131,13 +131,6 @@ typedef __u32			xfs_nlink_t;
 #define SYNCHRONIZE()	barrier()
 #define __return_address __builtin_return_address(0)
 
-/*
- * Return the address of a label.  Use barrier() so that the optimizer
- * won't reorder code to refactor the error jumpouts into a single
- * return, which throws off the reported address.
- */
-#define __this_address	({ __label__ __here; __here: barrier(); &&__here; })
-
 #define XFS_PROJID_DEFAULT	0
 
 #define howmany(x, y)	(((x)+((y)-1))/(y))
-- 
2.17.0
