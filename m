Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 354017F6B
	for <xfs@oss.sgi.com>; Tue,  4 Mar 2014 02:52:21 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 98558AC004
	for <xfs@oss.sgi.com>; Tue,  4 Mar 2014 00:52:20 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	XadoHnSj8UdJbxPB for <xfs@oss.sgi.com>;
	Tue, 04 Mar 2014 00:52:18 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1WKl4w-0006Hc-Nb
	for xfs@oss.sgi.com; Tue, 04 Mar 2014 19:51:58 +1100
Received: from dave by disappointment with local (Exim 4.82)
	(envelope-from <dave@disappointment.disaster>) id 1WKl4w-0006zd-Mp
	for xfs@oss.sgi.com; Tue, 04 Mar 2014 19:51:58 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 09/13] libxfs: add helper for updating checksums on xfs_bufs
Date: Tue,  4 Mar 2014 19:51:53 +1100
Message-Id: <1393923117-9559-10-git-send-email-david@fromorbit.com>
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

Many/most callers of xfs_update_cksum() pass bp->b_addr and
BBTOB(bp->b_length) as the first 2 args.  Add a helper
which can just accept the bp and the crc offset, and work
it out on its own, for brevity.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 include/libxfs.h            | 7 +++++++
 libxfs/xfs_alloc.c          | 4 ++--
 libxfs/xfs_attr_leaf.c      | 2 +-
 libxfs/xfs_btree.c          | 6 ++----
 libxfs/xfs_da_btree.c       | 2 +-
 libxfs/xfs_dir2_block.c     | 2 +-
 libxfs/xfs_dir2_data.c      | 2 +-
 libxfs/xfs_dir2_leaf.c      | 2 +-
 libxfs/xfs_dir2_node.c      | 2 +-
 libxfs/xfs_ialloc.c         | 2 +-
 libxfs/xfs_sb.c             | 2 +-
 libxfs/xfs_symlink_remote.c | 2 +-
 12 files changed, 20 insertions(+), 15 deletions(-)

diff --git a/include/libxfs.h b/include/libxfs.h
index 610e7d5..7500903 100644
--- a/include/libxfs.h
+++ b/include/libxfs.h
@@ -786,6 +786,13 @@ xfs_buf_verify_cksum(struct xfs_buf *bp, unsigned long cksum_offset)
 				cksum_offset);
 }
 
+static inline void
+xfs_buf_update_cksum(struct xfs_buf *bp, unsigned long cksum_offset)
+{
+	xfs_update_cksum(bp->b_addr, BBTOB(bp->b_length),
+			 cksum_offset);
+}
+
 #define xfs_notice(mp,fmt,args...)		cmn_err(CE_NOTE,fmt, ## args)
 #define xfs_warn(mp,fmt,args...)		cmn_err(CE_WARN,fmt, ## args)
 #define xfs_alert(mp,fmt,args...)		cmn_err(CE_ALERT,fmt, ## args)
diff --git a/libxfs/xfs_alloc.c b/libxfs/xfs_alloc.c
index 2f6a241..dca612b 100644
--- a/libxfs/xfs_alloc.c
+++ b/libxfs/xfs_alloc.c
@@ -493,7 +493,7 @@ xfs_agfl_write_verify(
 	if (bip)
 		XFS_BUF_TO_AGFL(bp)->agfl_lsn = cpu_to_be64(bip->bli_item.li_lsn);
 
-	xfs_update_cksum(bp->b_addr, BBTOB(bp->b_length), XFS_AGFL_CRC_OFF);
+	xfs_buf_update_cksum(bp, XFS_AGFL_CRC_OFF);
 }
 
 const struct xfs_buf_ops xfs_agfl_buf_ops = {
@@ -2249,7 +2249,7 @@ xfs_agf_write_verify(
 	if (bip)
 		XFS_BUF_TO_AGF(bp)->agf_lsn = cpu_to_be64(bip->bli_item.li_lsn);
 
-	xfs_update_cksum(bp->b_addr, BBTOB(bp->b_length), XFS_AGF_CRC_OFF);
+	xfs_buf_update_cksum(bp, XFS_AGF_CRC_OFF);
 }
 
 const struct xfs_buf_ops xfs_agf_buf_ops = {
diff --git a/libxfs/xfs_attr_leaf.c b/libxfs/xfs_attr_leaf.c
index 0bd3169..90937d6 100644
--- a/libxfs/xfs_attr_leaf.c
+++ b/libxfs/xfs_attr_leaf.c
@@ -198,7 +198,7 @@ xfs_attr3_leaf_write_verify(
 	if (bip)
 		hdr3->info.lsn = cpu_to_be64(bip->bli_item.li_lsn);
 
-	xfs_update_cksum(bp->b_addr, BBTOB(bp->b_length), XFS_ATTR3_LEAF_CRC_OFF);
+	xfs_buf_update_cksum(bp, XFS_ATTR3_LEAF_CRC_OFF);
 }
 
 /*
diff --git a/libxfs/xfs_btree.c b/libxfs/xfs_btree.c
index fffed0a..9be4abd 100644
--- a/libxfs/xfs_btree.c
+++ b/libxfs/xfs_btree.c
@@ -218,8 +218,7 @@ xfs_btree_lblock_calc_crc(
 		return;
 	if (bip)
 		block->bb_u.l.bb_lsn = cpu_to_be64(bip->bli_item.li_lsn);
-	xfs_update_cksum(bp->b_addr, BBTOB(bp->b_length),
-			 XFS_BTREE_LBLOCK_CRC_OFF);
+	xfs_buf_update_cksum(bp, XFS_BTREE_LBLOCK_CRC_OFF);
 }
 
 bool
@@ -251,8 +250,7 @@ xfs_btree_sblock_calc_crc(
 		return;
 	if (bip)
 		block->bb_u.s.bb_lsn = cpu_to_be64(bip->bli_item.li_lsn);
-	xfs_update_cksum(bp->b_addr, BBTOB(bp->b_length),
-			 XFS_BTREE_SBLOCK_CRC_OFF);
+	xfs_buf_update_cksum(bp, XFS_BTREE_SBLOCK_CRC_OFF);
 }
 
 bool
diff --git a/libxfs/xfs_da_btree.c b/libxfs/xfs_da_btree.c
index 4e8b41a..0c0c5e0 100644
--- a/libxfs/xfs_da_btree.c
+++ b/libxfs/xfs_da_btree.c
@@ -220,7 +220,7 @@ xfs_da3_node_write_verify(
 	if (bip)
 		hdr3->info.lsn = cpu_to_be64(bip->bli_item.li_lsn);
 
-	xfs_update_cksum(bp->b_addr, BBTOB(bp->b_length), XFS_DA3_NODE_CRC_OFF);
+	xfs_buf_update_cksum(bp, XFS_DA3_NODE_CRC_OFF);
 }
 
 /*
diff --git a/libxfs/xfs_dir2_block.c b/libxfs/xfs_dir2_block.c
index 13561c3..3fe10ea 100644
--- a/libxfs/xfs_dir2_block.c
+++ b/libxfs/xfs_dir2_block.c
@@ -98,7 +98,7 @@ xfs_dir3_block_write_verify(
 	if (bip)
 		hdr3->lsn = cpu_to_be64(bip->bli_item.li_lsn);
 
-	xfs_update_cksum(bp->b_addr, BBTOB(bp->b_length), XFS_DIR3_DATA_CRC_OFF);
+	xfs_buf_update_cksum(bp, XFS_DIR3_DATA_CRC_OFF);
 }
 
 const struct xfs_buf_ops xfs_dir3_block_buf_ops = {
diff --git a/libxfs/xfs_dir2_data.c b/libxfs/xfs_dir2_data.c
index 2a0de28..bcb4c7f 100644
--- a/libxfs/xfs_dir2_data.c
+++ b/libxfs/xfs_dir2_data.c
@@ -262,7 +262,7 @@ xfs_dir3_data_write_verify(
 	if (bip)
 		hdr3->lsn = cpu_to_be64(bip->bli_item.li_lsn);
 
-	xfs_update_cksum(bp->b_addr, BBTOB(bp->b_length), XFS_DIR3_DATA_CRC_OFF);
+	xfs_buf_update_cksum(bp, XFS_DIR3_DATA_CRC_OFF);
 }
 
 const struct xfs_buf_ops xfs_dir3_data_buf_ops = {
diff --git a/libxfs/xfs_dir2_leaf.c b/libxfs/xfs_dir2_leaf.c
index 0fa147f..710f005 100644
--- a/libxfs/xfs_dir2_leaf.c
+++ b/libxfs/xfs_dir2_leaf.c
@@ -235,7 +235,7 @@ __write_verify(
 	if (bip)
 		hdr3->info.lsn = cpu_to_be64(bip->bli_item.li_lsn);
 
-	xfs_update_cksum(bp->b_addr, BBTOB(bp->b_length), XFS_DIR3_LEAF_CRC_OFF);
+	xfs_buf_update_cksum(bp, XFS_DIR3_LEAF_CRC_OFF);
 }
 
 static void
diff --git a/libxfs/xfs_dir2_node.c b/libxfs/xfs_dir2_node.c
index 78c77ed..f4260ea 100644
--- a/libxfs/xfs_dir2_node.c
+++ b/libxfs/xfs_dir2_node.c
@@ -126,7 +126,7 @@ xfs_dir3_free_write_verify(
 	if (bip)
 		hdr3->lsn = cpu_to_be64(bip->bli_item.li_lsn);
 
-	xfs_update_cksum(bp->b_addr, BBTOB(bp->b_length), XFS_DIR3_FREE_CRC_OFF);
+	xfs_buf_update_cksum(bp, XFS_DIR3_FREE_CRC_OFF);
 }
 
 const struct xfs_buf_ops xfs_dir3_free_buf_ops = {
diff --git a/libxfs/xfs_ialloc.c b/libxfs/xfs_ialloc.c
index 21683b5..b1382d6 100644
--- a/libxfs/xfs_ialloc.c
+++ b/libxfs/xfs_ialloc.c
@@ -1583,7 +1583,7 @@ xfs_agi_write_verify(
 
 	if (bip)
 		XFS_BUF_TO_AGI(bp)->agi_lsn = cpu_to_be64(bip->bli_item.li_lsn);
-	xfs_update_cksum(bp->b_addr, BBTOB(bp->b_length), XFS_AGI_CRC_OFF);
+	xfs_buf_update_cksum(bp, XFS_AGI_CRC_OFF);
 }
 
 const struct xfs_buf_ops xfs_agi_buf_ops = {
diff --git a/libxfs/xfs_sb.c b/libxfs/xfs_sb.c
index 43fdb59..db267c2 100644
--- a/libxfs/xfs_sb.c
+++ b/libxfs/xfs_sb.c
@@ -628,7 +628,7 @@ xfs_sb_write_verify(
 	if (bip)
 		XFS_BUF_TO_SBP(bp)->sb_lsn = cpu_to_be64(bip->bli_item.li_lsn);
 
-	xfs_update_cksum(bp->b_addr, BBTOB(bp->b_length), XFS_SB_CRC_OFF);
+	xfs_buf_update_cksum(bp, XFS_SB_CRC_OFF);
 }
 
 const struct xfs_buf_ops xfs_sb_buf_ops = {
diff --git a/libxfs/xfs_symlink_remote.c b/libxfs/xfs_symlink_remote.c
index 716f8a3..b59bf14 100644
--- a/libxfs/xfs_symlink_remote.c
+++ b/libxfs/xfs_symlink_remote.c
@@ -144,7 +144,7 @@ xfs_symlink_write_verify(
 		struct xfs_dsymlink_hdr *dsl = bp->b_addr;
 		dsl->sl_lsn = cpu_to_be64(bip->bli_item.li_lsn);
 	}
-	xfs_update_cksum(bp->b_addr, BBTOB(bp->b_length), XFS_SYMLINK_CRC_OFF);
+	xfs_buf_update_cksum(bp, XFS_SYMLINK_CRC_OFF);
 }
 
 const struct xfs_buf_ops xfs_symlink_buf_ops = {
-- 
1.9.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
