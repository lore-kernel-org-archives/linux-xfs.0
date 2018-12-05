Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39396 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728356AbeLEVEo (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 5 Dec 2018 16:04:44 -0500
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id AB627C025D28
        for <linux-xfs@vger.kernel.org>; Wed,  5 Dec 2018 21:04:43 +0000 (UTC)
Subject: [PATCH 04/10] xfs: pass a verifier context to crc validation
 functions
References: <542b81dc-b564-c5fa-86b4-b4dc8ac50b63@redhat.com>
From: Eric Sandeen <sandeen@redhat.com>
Message-ID: <ed5ace72-9a3a-48a2-f4d0-bd4b0fd84ba7@redhat.com>
Date: Wed, 5 Dec 2018 15:04:39 -0600
MIME-Version: 1.0
In-Reply-To: <542b81dc-b564-c5fa-86b4-b4dc8ac50b63@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

Pass the new verifier context to crc checking funtions as well.

Still not used at this point in the series.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 fs/xfs/libxfs/xfs_alloc.c          | 4 ++--
 fs/xfs/libxfs/xfs_attr_leaf.c      | 2 +-
 fs/xfs/libxfs/xfs_attr_remote.c    | 2 +-
 fs/xfs/libxfs/xfs_bmap_btree.c     | 2 +-
 fs/xfs/libxfs/xfs_btree.c          | 5 +++--
 fs/xfs/libxfs/xfs_btree.h          | 2 +-
 fs/xfs/libxfs/xfs_cksum.h          | 3 ++-
 fs/xfs/libxfs/xfs_da_btree.c       | 2 +-
 fs/xfs/libxfs/xfs_dir2_block.c     | 2 +-
 fs/xfs/libxfs/xfs_dir2_data.c      | 2 +-
 fs/xfs/libxfs/xfs_dir2_leaf.c      | 2 +-
 fs/xfs/libxfs/xfs_dir2_node.c      | 2 +-
 fs/xfs/libxfs/xfs_dquot_buf.c      | 3 ++-
 fs/xfs/libxfs/xfs_ialloc.c         | 2 +-
 fs/xfs/libxfs/xfs_inode_buf.c      | 2 +-
 fs/xfs/libxfs/xfs_sb.c             | 2 +-
 fs/xfs/libxfs/xfs_symlink_remote.c | 2 +-
 fs/xfs/xfs_buf.h                   | 5 +++--
 18 files changed, 25 insertions(+), 21 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 59b8ab08dabd..15312fb37c02 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -610,7 +610,7 @@ xfs_agfl_read_verify(
 	if (!xfs_sb_version_hascrc(&mp->m_sb))
 		return;
 
-	if (!xfs_buf_verify_cksum(bp, XFS_AGFL_CRC_OFF))
+	if (!xfs_buf_verify_cksum(vc, bp, XFS_AGFL_CRC_OFF))
 		xfs_verifier_error(bp, -EFSBADCRC, __this_address);
 	else {
 		fa = xfs_agfl_verify(vc, bp);
@@ -2642,7 +2642,7 @@ xfs_agf_read_verify(
 	xfs_failaddr_t	fa;
 
 	if (xfs_sb_version_hascrc(&mp->m_sb) &&
-	    !xfs_buf_verify_cksum(bp, XFS_AGF_CRC_OFF))
+	    !xfs_buf_verify_cksum(vc, bp, XFS_AGF_CRC_OFF))
 		xfs_verifier_error(bp, -EFSBADCRC, __this_address);
 	else {
 		fa = xfs_agf_verify(vc, bp);
diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index 5b146c909389..d7909e45800c 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -361,7 +361,7 @@ xfs_attr3_leaf_read_verify(
 	xfs_failaddr_t		fa;
 
 	if (xfs_sb_version_hascrc(&mp->m_sb) &&
-	     !xfs_buf_verify_cksum(bp, XFS_ATTR3_LEAF_CRC_OFF))
+	     !xfs_buf_verify_cksum(vc, bp, XFS_ATTR3_LEAF_CRC_OFF))
 		xfs_verifier_error(bp, -EFSBADCRC, __this_address);
 	else {
 		fa = xfs_attr3_leaf_verify(vc, bp);
diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
index e8d629de2cf5..96a1b67f4fb9 100644
--- a/fs/xfs/libxfs/xfs_attr_remote.c
+++ b/fs/xfs/libxfs/xfs_attr_remote.c
@@ -129,7 +129,7 @@ __xfs_attr3_rmt_read_verify(
 
 	while (len > 0) {
 		if (check_crc &&
-		    !xfs_verify_cksum(ptr, blksize, XFS_ATTR3_RMT_CRC_OFF)) {
+		    !xfs_verify_cksum(vc, ptr, blksize, XFS_ATTR3_RMT_CRC_OFF)) {
 			*failaddr = __this_address;
 			return -EFSBADCRC;
 		}
diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
index 4c8e97709704..3cc9c6610c05 100644
--- a/fs/xfs/libxfs/xfs_bmap_btree.c
+++ b/fs/xfs/libxfs/xfs_bmap_btree.c
@@ -454,7 +454,7 @@ xfs_bmbt_read_verify(
 {
 	xfs_failaddr_t	fa;
 
-	if (!xfs_btree_lblock_verify_crc(bp))
+	if (!xfs_btree_lblock_verify_crc(vc, bp))
 		xfs_verifier_error(bp, -EFSBADCRC, __this_address);
 	else {
 		fa = xfs_bmbt_verify(vc, bp);
diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index 755ac16e90c5..a618e0251a55 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -289,6 +289,7 @@ xfs_btree_lblock_calc_crc(
 
 bool
 xfs_btree_lblock_verify_crc(
+	struct xfs_vc		*vc,
 	struct xfs_buf		*bp)
 {
 	struct xfs_btree_block	*block = XFS_BUF_TO_BLOCK(bp);
@@ -297,7 +298,7 @@ xfs_btree_lblock_verify_crc(
 	if (xfs_sb_version_hascrc(&mp->m_sb)) {
 		if (!xfs_log_check_lsn(mp, be64_to_cpu(block->bb_u.l.bb_lsn)))
 			return false;
-		return xfs_buf_verify_cksum(bp, XFS_BTREE_LBLOCK_CRC_OFF);
+		return xfs_buf_verify_cksum(vc, bp, XFS_BTREE_LBLOCK_CRC_OFF);
 	}
 
 	return true;
@@ -336,7 +337,7 @@ xfs_btree_sblock_verify_crc(
 	if (xfs_sb_version_hascrc(&mp->m_sb)) {
 		if (!xfs_log_check_lsn(mp, be64_to_cpu(block->bb_u.s.bb_lsn)))
 			return false;
-		return xfs_buf_verify_cksum(bp, XFS_BTREE_SBLOCK_CRC_OFF);
+		return xfs_buf_verify_cksum(vc, bp, XFS_BTREE_SBLOCK_CRC_OFF);
 	}
 
 	return true;
diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
index 86cc17f1bf3f..a585293798f3 100644
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
@@ -415,7 +415,7 @@ int xfs_btree_change_owner(struct xfs_btree_cur *cur, uint64_t new_owner,
  * btree block CRC helpers
  */
 void xfs_btree_lblock_calc_crc(struct xfs_buf *);
-bool xfs_btree_lblock_verify_crc(struct xfs_buf *);
+bool xfs_btree_lblock_verify_crc(struct xfs_vc *vc, struct xfs_buf *);
 void xfs_btree_sblock_calc_crc(struct xfs_buf *);
 bool xfs_btree_sblock_verify_crc(struct xfs_vc *vc, struct xfs_buf *);
 
diff --git a/fs/xfs/libxfs/xfs_cksum.h b/fs/xfs/libxfs/xfs_cksum.h
index 1e3802a99867..888ef9ec4c57 100644
--- a/fs/xfs/libxfs/xfs_cksum.h
+++ b/fs/xfs/libxfs/xfs_cksum.h
@@ -72,7 +72,8 @@ xfs_update_cksum(char *buffer, size_t length, unsigned long cksum_offset)
  * Helper to verify the checksum for a buffer.
  */
 static inline bool
-xfs_verify_cksum(char *buffer, size_t length, unsigned long cksum_offset)
+xfs_verify_cksum(struct xfs_vc *vc, char *buffer, size_t length,
+		 unsigned long cksum_offset)
 {
 	uint32_t crc = xfs_start_cksum_safe(buffer, length, cksum_offset);
 
diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
index 38862a0990d4..eb19d6aa85ca 100644
--- a/fs/xfs/libxfs/xfs_da_btree.c
+++ b/fs/xfs/libxfs/xfs_da_btree.c
@@ -207,7 +207,7 @@ xfs_da3_node_read_verify(
 
 	switch (be16_to_cpu(info->magic)) {
 		case XFS_DA3_NODE_MAGIC:
-			if (!xfs_buf_verify_cksum(bp, XFS_DA3_NODE_CRC_OFF)) {
+			if (!xfs_buf_verify_cksum(vc, bp, XFS_DA3_NODE_CRC_OFF)) {
 				xfs_verifier_error(bp, -EFSBADCRC,
 						__this_address);
 				break;
diff --git a/fs/xfs/libxfs/xfs_dir2_block.c b/fs/xfs/libxfs/xfs_dir2_block.c
index 65ba4eccce8b..53cc0e151a75 100644
--- a/fs/xfs/libxfs/xfs_dir2_block.c
+++ b/fs/xfs/libxfs/xfs_dir2_block.c
@@ -79,7 +79,7 @@ xfs_dir3_block_read_verify(
 	xfs_failaddr_t		fa;
 
 	if (xfs_sb_version_hascrc(&mp->m_sb) &&
-	     !xfs_buf_verify_cksum(bp, XFS_DIR3_DATA_CRC_OFF))
+	     !xfs_buf_verify_cksum(vc, bp, XFS_DIR3_DATA_CRC_OFF))
 		xfs_verifier_error(bp, -EFSBADCRC, __this_address);
 	else {
 		fa = xfs_dir3_block_verify(vc, bp);
diff --git a/fs/xfs/libxfs/xfs_dir2_data.c b/fs/xfs/libxfs/xfs_dir2_data.c
index 6530621d8144..661615f253b2 100644
--- a/fs/xfs/libxfs/xfs_dir2_data.c
+++ b/fs/xfs/libxfs/xfs_dir2_data.c
@@ -310,7 +310,7 @@ xfs_dir3_data_read_verify(
 	xfs_failaddr_t		fa;
 
 	if (xfs_sb_version_hascrc(&mp->m_sb) &&
-	    !xfs_buf_verify_cksum(bp, XFS_DIR3_DATA_CRC_OFF))
+	    !xfs_buf_verify_cksum(vc, bp, XFS_DIR3_DATA_CRC_OFF))
 		xfs_verifier_error(bp, -EFSBADCRC, __this_address);
 	else {
 		fa = xfs_dir3_data_verify(vc, bp);
diff --git a/fs/xfs/libxfs/xfs_dir2_leaf.c b/fs/xfs/libxfs/xfs_dir2_leaf.c
index 1122a639b603..a225dcdc11c8 100644
--- a/fs/xfs/libxfs/xfs_dir2_leaf.c
+++ b/fs/xfs/libxfs/xfs_dir2_leaf.c
@@ -187,7 +187,7 @@ __read_verify(
 	xfs_failaddr_t		fa;
 
 	if (xfs_sb_version_hascrc(&mp->m_sb) &&
-	     !xfs_buf_verify_cksum(bp, XFS_DIR3_LEAF_CRC_OFF))
+	     !xfs_buf_verify_cksum(vc, bp, XFS_DIR3_LEAF_CRC_OFF))
 		xfs_verifier_error(bp, -EFSBADCRC, __this_address);
 	else {
 		fa = xfs_dir3_leaf_verify(vc, bp, magic);
diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
index 70f54145d0b0..8174e469b14f 100644
--- a/fs/xfs/libxfs/xfs_dir2_node.c
+++ b/fs/xfs/libxfs/xfs_dir2_node.c
@@ -120,7 +120,7 @@ xfs_dir3_free_read_verify(
 	xfs_failaddr_t		fa;
 
 	if (xfs_sb_version_hascrc(&mp->m_sb) &&
-	    !xfs_buf_verify_cksum(bp, XFS_DIR3_FREE_CRC_OFF))
+	    !xfs_buf_verify_cksum(vc, bp, XFS_DIR3_FREE_CRC_OFF))
 		xfs_verifier_error(bp, -EFSBADCRC, __this_address);
 	else {
 		fa = xfs_dir3_free_verify(vc, bp);
diff --git a/fs/xfs/libxfs/xfs_dquot_buf.c b/fs/xfs/libxfs/xfs_dquot_buf.c
index 0dc0a8d7ffc4..bbc63656a6d2 100644
--- a/fs/xfs/libxfs/xfs_dquot_buf.c
+++ b/fs/xfs/libxfs/xfs_dquot_buf.c
@@ -147,6 +147,7 @@ xfs_dquot_buf_verify_crc(
 {
 	struct xfs_dqblk	*d = (struct xfs_dqblk *)bp->b_addr;
 	int			ndquots;
+	struct xfs_vc		vc;
 	int			i;
 
 	if (!xfs_sb_version_hascrc(&mp->m_sb))
@@ -163,7 +164,7 @@ xfs_dquot_buf_verify_crc(
 		ndquots = xfs_calc_dquots_per_chunk(bp->b_length);
 
 	for (i = 0; i < ndquots; i++, d++) {
-		if (!xfs_verify_cksum((char *)d, sizeof(struct xfs_dqblk),
+		if (!xfs_verify_cksum(&vc, (char *)d, sizeof(struct xfs_dqblk),
 				 XFS_DQUOT_CRC_OFF)) {
 			if (!readahead)
 				xfs_buf_verifier_error(bp, -EFSBADCRC, __func__,
diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index 1b2b3b63b207..a204112c8c90 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -2557,7 +2557,7 @@ xfs_agi_read_verify(
 	xfs_failaddr_t	fa;
 
 	if (xfs_sb_version_hascrc(&mp->m_sb) &&
-	    !xfs_buf_verify_cksum(bp, XFS_AGI_CRC_OFF))
+	    !xfs_buf_verify_cksum(vc, bp, XFS_AGI_CRC_OFF))
 		xfs_verifier_error(bp, -EFSBADCRC, __this_address);
 	else {
 		fa = xfs_agi_verify(vc, bp);
diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index 7d9b4ea6eba9..d7a8199d5f36 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -466,7 +466,7 @@ xfs_dinode_verify(
 	if (dip->di_version >= 3) {
 		if (!xfs_sb_version_hascrc(&mp->m_sb))
 			return __this_address;
-		if (!xfs_verify_cksum((char *)dip, mp->m_sb.sb_inodesize,
+		if (!xfs_verify_cksum(vc, (char *)dip, mp->m_sb.sb_inodesize,
 				      XFS_DINODE_CRC_OFF))
 			return __this_address;
 		if (be64_to_cpu(dip->di_ino) != ino)
diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index 0f8197c368a9..07e866103dc2 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -698,7 +698,7 @@ xfs_sb_read_verify(
 						XFS_SB_VERSION_5) ||
 	     dsb->sb_crc != 0)) {
 
-		if (!xfs_buf_verify_cksum(bp, XFS_SB_CRC_OFF)) {
+		if (!xfs_buf_verify_cksum(vc, bp, XFS_SB_CRC_OFF)) {
 			/* Only fail bad secondaries on a known V5 filesystem */
 			if (bp->b_bn == XFS_SB_DADDR ||
 			    xfs_sb_version_hascrc(&mp->m_sb)) {
diff --git a/fs/xfs/libxfs/xfs_symlink_remote.c b/fs/xfs/libxfs/xfs_symlink_remote.c
index e0ff80797942..0405f17aae6f 100644
--- a/fs/xfs/libxfs/xfs_symlink_remote.c
+++ b/fs/xfs/libxfs/xfs_symlink_remote.c
@@ -125,7 +125,7 @@ xfs_symlink_read_verify(
 	if (!xfs_sb_version_hascrc(&mp->m_sb))
 		return;
 
-	if (!xfs_buf_verify_cksum(bp, XFS_SYMLINK_CRC_OFF))
+	if (!xfs_buf_verify_cksum(vc, bp, XFS_SYMLINK_CRC_OFF))
 		xfs_verifier_error(bp, -EFSBADCRC, __this_address);
 	else {
 		fa = xfs_symlink_verify(vc, bp);
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index d1c6c92b7104..e7e1e070f76e 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -360,9 +360,10 @@ static inline void xfs_buf_relse(xfs_buf_t *bp)
 }
 
 static inline bool
-xfs_buf_verify_cksum(struct xfs_buf *bp, unsigned long cksum_offset)
+xfs_buf_verify_cksum(struct xfs_vc *vc, struct xfs_buf *bp,
+		     unsigned long cksum_offset)
 {
-	return xfs_verify_cksum(bp->b_addr, BBTOB(bp->b_length),
+	return xfs_verify_cksum(vc, bp->b_addr, BBTOB(bp->b_length),
 				cksum_offset);
 }
 
-- 
2.17.0
