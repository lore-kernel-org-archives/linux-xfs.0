Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A4F637F3F
	for <xfs@oss.sgi.com>; Sun,  9 Feb 2014 20:29:51 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 595DB8F8033
	for <xfs@oss.sgi.com>; Sun,  9 Feb 2014 18:29:51 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id OOnNXppKXM1cc43N for <xfs@oss.sgi.com>;
	Sun, 09 Feb 2014 18:29:49 -0800 (PST)
Message-ID: <52F8399B.3050204@sandeen.net>
Date: Sun, 09 Feb 2014 20:29:47 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH 4/6] xfs: add helper for verifying checksums on xfs_bufs
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

Many/most callers of xfs_update_cksum() pass bp->b_addr and
BBTOB(bp->b_length) as the first 2 args.  Add a helper
which can just accept the bp and the crc offset, and work
it out on its own, for brevity.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

 fs/xfs/xfs_alloc.c          |    6 ++----
 fs/xfs/xfs_attr_leaf.c      |    2 +-
 fs/xfs/xfs_btree.c          |    6 ++----
 fs/xfs/xfs_cksum.h          |    6 ++++++
 fs/xfs/xfs_da_btree.c       |    2 +-
 fs/xfs/xfs_dir2_block.c     |    2 +-
 fs/xfs/xfs_dir2_data.c      |    2 +-
 fs/xfs/xfs_dir2_leaf.c      |    2 +-
 fs/xfs/xfs_dir2_node.c      |    2 +-
 fs/xfs/xfs_ialloc.c         |    4 ++--
 fs/xfs/xfs_sb.c             |    3 +--
 fs/xfs/xfs_symlink_remote.c |    3 +--
 12 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/fs/xfs/xfs_alloc.c b/fs/xfs/xfs_alloc.c
index ab33714..72b9451 100644
--- a/fs/xfs/xfs_alloc.c
+++ b/fs/xfs/xfs_alloc.c
@@ -515,8 +515,7 @@ xfs_agfl_write_verify(
 	if (bip)
 		XFS_BUF_TO_AGFL(bp)->agfl_lsn = cpu_to_be64(bip->bli_item.li_lsn);
 
-	xfs_update_cksum(bp->b_addr, BBTOB(bp->b_length),
-			 offsetof(struct xfs_agfl, agfl_crc));
+	xfs_buf_update_cksum(bp, offsetof(struct xfs_agfl, agfl_crc));
 }
 
 const struct xfs_buf_ops xfs_agfl_buf_ops = {
@@ -2271,8 +2270,7 @@ xfs_agf_write_verify(
 	if (bip)
 		XFS_BUF_TO_AGF(bp)->agf_lsn = cpu_to_be64(bip->bli_item.li_lsn);
 
-	xfs_update_cksum(bp->b_addr, BBTOB(bp->b_length),
-			 offsetof(struct xfs_agf, agf_crc));
+	xfs_buf_update_cksum(bp, offsetof(struct xfs_agf, agf_crc));
 }
 
 const struct xfs_buf_ops xfs_agf_buf_ops = {
diff --git a/fs/xfs/xfs_attr_leaf.c b/fs/xfs/xfs_attr_leaf.c
index a19a023..b552378 100644
--- a/fs/xfs/xfs_attr_leaf.c
+++ b/fs/xfs/xfs_attr_leaf.c
@@ -224,7 +224,7 @@ xfs_attr3_leaf_write_verify(
 	if (bip)
 		hdr3->info.lsn = cpu_to_be64(bip->bli_item.li_lsn);
 
-	xfs_update_cksum(bp->b_addr, BBTOB(bp->b_length), XFS_ATTR3_LEAF_CRC_OFF);
+	xfs_buf_update_cksum(bp, XFS_ATTR3_LEAF_CRC_OFF);
 }
 
 /*
diff --git a/fs/xfs/xfs_btree.c b/fs/xfs/xfs_btree.c
index 4e8524d..e80d59f 100644
--- a/fs/xfs/xfs_btree.c
+++ b/fs/xfs/xfs_btree.c
@@ -234,8 +234,7 @@ xfs_btree_lblock_calc_crc(
 		return;
 	if (bip)
 		block->bb_u.l.bb_lsn = cpu_to_be64(bip->bli_item.li_lsn);
-	xfs_update_cksum(bp->b_addr, BBTOB(bp->b_length),
-			 XFS_BTREE_LBLOCK_CRC_OFF);
+	xfs_buf_update_cksum(bp, XFS_BTREE_LBLOCK_CRC_OFF);
 }
 
 bool
@@ -267,8 +266,7 @@ xfs_btree_sblock_calc_crc(
 		return;
 	if (bip)
 		block->bb_u.s.bb_lsn = cpu_to_be64(bip->bli_item.li_lsn);
-	xfs_update_cksum(bp->b_addr, BBTOB(bp->b_length),
-			 XFS_BTREE_SBLOCK_CRC_OFF);
+	xfs_buf_update_cksum(bp, XFS_BTREE_SBLOCK_CRC_OFF);
 }
 
 bool
diff --git a/fs/xfs/xfs_cksum.h b/fs/xfs/xfs_cksum.h
index f605d64..7886d05 100644
--- a/fs/xfs/xfs_cksum.h
+++ b/fs/xfs/xfs_cksum.h
@@ -49,6 +49,12 @@ xfs_update_cksum(char *buffer, size_t length, unsigned long cksum_offset)
 	*(__le32 *)(buffer + cksum_offset) = xfs_end_cksum(crc);
 }
 
+static inline void
+xfs_buf_update_cksum(struct xfs_buf *bp, unsigned long cksum_offset)
+{
+	xfs_update_cksum(bp->b_addr, BBTOB(bp->b_length),
+			 cksum_offset);
+}
 /*
  * Helper to verify the checksum for a buffer.
  */
diff --git a/fs/xfs/xfs_da_btree.c b/fs/xfs/xfs_da_btree.c
index 6cece55..75ef990 100644
--- a/fs/xfs/xfs_da_btree.c
+++ b/fs/xfs/xfs_da_btree.c
@@ -196,7 +196,7 @@ xfs_da3_node_write_verify(
 	if (bip)
 		hdr3->info.lsn = cpu_to_be64(bip->bli_item.li_lsn);
 
-	xfs_update_cksum(bp->b_addr, BBTOB(bp->b_length), XFS_DA3_NODE_CRC_OFF);
+	xfs_buf_update_cksum(bp, XFS_DA3_NODE_CRC_OFF);
 }
 
 /*
diff --git a/fs/xfs/xfs_dir2_block.c b/fs/xfs/xfs_dir2_block.c
index 948dc39..724377e 100644
--- a/fs/xfs/xfs_dir2_block.c
+++ b/fs/xfs/xfs_dir2_block.c
@@ -117,7 +117,7 @@ xfs_dir3_block_write_verify(
 	if (bip)
 		hdr3->lsn = cpu_to_be64(bip->bli_item.li_lsn);
 
-	xfs_update_cksum(bp->b_addr, BBTOB(bp->b_length), XFS_DIR3_DATA_CRC_OFF);
+	xfs_buf_update_cksum(bp, XFS_DIR3_DATA_CRC_OFF);
 }
 
 const struct xfs_buf_ops xfs_dir3_block_buf_ops = {
diff --git a/fs/xfs/xfs_dir2_data.c b/fs/xfs/xfs_dir2_data.c
index 1952f00..74ae85e 100644
--- a/fs/xfs/xfs_dir2_data.c
+++ b/fs/xfs/xfs_dir2_data.c
@@ -295,7 +295,7 @@ xfs_dir3_data_write_verify(
 	if (bip)
 		hdr3->lsn = cpu_to_be64(bip->bli_item.li_lsn);
 
-	xfs_update_cksum(bp->b_addr, BBTOB(bp->b_length), XFS_DIR3_DATA_CRC_OFF);
+	xfs_buf_update_cksum(bp, XFS_DIR3_DATA_CRC_OFF);
 }
 
 const struct xfs_buf_ops xfs_dir3_data_buf_ops = {
diff --git a/fs/xfs/xfs_dir2_leaf.c b/fs/xfs/xfs_dir2_leaf.c
index 1a412eb..dffb61b 100644
--- a/fs/xfs/xfs_dir2_leaf.c
+++ b/fs/xfs/xfs_dir2_leaf.c
@@ -208,7 +208,7 @@ __write_verify(
 	if (bip)
 		hdr3->info.lsn = cpu_to_be64(bip->bli_item.li_lsn);
 
-	xfs_update_cksum(bp->b_addr, BBTOB(bp->b_length), XFS_DIR3_LEAF_CRC_OFF);
+	xfs_buf_update_cksum(bp, XFS_DIR3_LEAF_CRC_OFF);
 }
 
 static void
diff --git a/fs/xfs/xfs_dir2_node.c b/fs/xfs/xfs_dir2_node.c
index 875e7c0..0904b20 100644
--- a/fs/xfs/xfs_dir2_node.c
+++ b/fs/xfs/xfs_dir2_node.c
@@ -143,7 +143,7 @@ xfs_dir3_free_write_verify(
 	if (bip)
 		hdr3->lsn = cpu_to_be64(bip->bli_item.li_lsn);
 
-	xfs_update_cksum(bp->b_addr, BBTOB(bp->b_length), XFS_DIR3_FREE_CRC_OFF);
+	xfs_buf_update_cksum(bp, XFS_DIR3_FREE_CRC_OFF);
 }
 
 const struct xfs_buf_ops xfs_dir3_free_buf_ops = {
diff --git a/fs/xfs/xfs_ialloc.c b/fs/xfs/xfs_ialloc.c
index 7321e49..0f03405 100644
--- a/fs/xfs/xfs_ialloc.c
+++ b/fs/xfs/xfs_ialloc.c
@@ -1600,8 +1600,8 @@ xfs_agi_write_verify(
 
 	if (bip)
 		XFS_BUF_TO_AGI(bp)->agi_lsn = cpu_to_be64(bip->bli_item.li_lsn);
-	xfs_update_cksum(bp->b_addr, BBTOB(bp->b_length),
-			 offsetof(struct xfs_agi, agi_crc));
+
+	xfs_buf_update_cksum(bp, offsetof(struct xfs_agi, agi_crc));
 }
 
 const struct xfs_buf_ops xfs_agi_buf_ops = {
diff --git a/fs/xfs/xfs_sb.c b/fs/xfs/xfs_sb.c
index efaef71..7bbaf20 100644
--- a/fs/xfs/xfs_sb.c
+++ b/fs/xfs/xfs_sb.c
@@ -675,8 +675,7 @@ xfs_sb_write_verify(
 	if (bip)
 		XFS_BUF_TO_SBP(bp)->sb_lsn = cpu_to_be64(bip->bli_item.li_lsn);
 
-	xfs_update_cksum(bp->b_addr, BBTOB(bp->b_length),
-			 offsetof(struct xfs_sb, sb_crc));
+	xfs_buf_update_cksum(bp, offsetof(struct xfs_sb, sb_crc));
 }
 
 const struct xfs_buf_ops xfs_sb_buf_ops = {
diff --git a/fs/xfs/xfs_symlink_remote.c b/fs/xfs/xfs_symlink_remote.c
index 3f09957..7d53c5d 100644
--- a/fs/xfs/xfs_symlink_remote.c
+++ b/fs/xfs/xfs_symlink_remote.c
@@ -162,8 +162,7 @@ xfs_symlink_write_verify(
 		struct xfs_dsymlink_hdr *dsl = bp->b_addr;
 		dsl->sl_lsn = cpu_to_be64(bip->bli_item.li_lsn);
 	}
-	xfs_update_cksum(bp->b_addr, BBTOB(bp->b_length),
-			 offsetof(struct xfs_dsymlink_hdr, sl_crc));
+	xfs_buf_update_cksum(bp, offsetof(struct xfs_dsymlink_hdr, sl_crc));
 }
 
 const struct xfs_buf_ops xfs_symlink_buf_ops = {
-- 1.7.1


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
