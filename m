Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 9E0B47FC1
	for <xfs@oss.sgi.com>; Wed, 11 Nov 2015 16:15:47 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 88AFC30404E
	for <xfs@oss.sgi.com>; Wed, 11 Nov 2015 14:15:44 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id lKDkHg5bO51nvjel (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 11 Nov 2015 14:15:43 -0800 (PST)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (Postfix) with ESMTPS id 72D5446B
	for <xfs@oss.sgi.com>; Wed, 11 Nov 2015 22:15:42 +0000 (UTC)
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com
	[10.5.9.1])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id tABMFfW1023885
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Wed, 11 Nov 2015 17:15:42 -0500
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] xfsprogs: print name of verifier if it fails
Message-ID: <5643BE0D.5030805@redhat.com>
Date: Wed, 11 Nov 2015 16:15:41 -0600
MIME-Version: 1.0
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
To: xfs@oss.sgi.com

This adds a name to each buf_ops structure, so that if
a verifier fails we can print the type of verifier that
failed it. Should be a slight debugging aid, I hope.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---



diff --git a/db/attr.c b/db/attr.c
index 5e69100..e26ac67 100644
--- a/db/attr.c
+++ b/db/attr.c
@@ -570,6 +570,7 @@ xfs_attr3_db_write_verify(
 }
 
 const struct xfs_buf_ops xfs_attr3_db_buf_ops = {
+	.name = "xfs_attr3",
 	.verify_read = xfs_attr3_db_read_verify,
 	.verify_write = xfs_attr3_db_write_verify,
 };
diff --git a/db/dir2.c b/db/dir2.c
index cc76662..533f705 100644
--- a/db/dir2.c
+++ b/db/dir2.c
@@ -1037,6 +1037,7 @@ xfs_dir3_db_write_verify(
 }
 
 const struct xfs_buf_ops xfs_dir3_db_buf_ops = {
+	.name = "xfs_dir3",
 	.verify_read = xfs_dir3_db_read_verify,
 	.verify_write = xfs_dir3_db_write_verify,
 };
diff --git a/db/metadump.c b/db/metadump.c
index e503d6f..8cdcb92 100644
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -221,7 +221,8 @@ write_buf(
 		bp->b_ops->verify_write(bp);
 		if (bp->b_error) {
 			print_warning(
-				"obfuscation corrupted block at bno 0x%llx/0x%x",
+			    "obfuscation corrupted block at %s bno 0x%llx/0x%x",
+				bp->b_ops->name,
 				(long long)bp->b_bn, bp->b_bcount);
 		}
 	}
diff --git a/libxfs/libxfs_io.h b/libxfs/libxfs_io.h
index 38b4c6f..86b18a0 100644
--- a/libxfs/libxfs_io.h
+++ b/libxfs/libxfs_io.h
@@ -52,6 +52,7 @@ struct xfs_buf_map {
 	struct xfs_buf_map (map) = { .bm_bn = (blkno), .bm_len = (numblk) };
 
 struct xfs_buf_ops {
+	char *name;
 	void (*verify_read)(struct xfs_buf *);
 	void (*verify_write)(struct xfs_buf *);
 };
diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
index c19070f..0804285 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -1075,8 +1075,9 @@ libxfs_writebufr(xfs_buf_t *bp)
 		bp->b_ops->verify_write(bp);
 		if (bp->b_error) {
 			fprintf(stderr,
-	_("%s: write verifer failed on bno 0x%llx/0x%x\n"),
-				__func__, (long long)bp->b_bn, bp->b_bcount);
+	_("%s: write verifer failed on %s bno 0x%llx/0x%x\n"),
+				__func__, bp->b_ops->name,
+				(long long)bp->b_bn, bp->b_bcount);
 			return bp->b_error;
 		}
 	}
diff --git a/libxfs/util.c b/libxfs/util.c
index 6192e6c..0609ba4 100644
--- a/libxfs/util.c
+++ b/libxfs/util.c
@@ -725,9 +725,9 @@ void
 xfs_verifier_error(
 	struct xfs_buf		*bp)
 {
-	xfs_alert(NULL, "Metadata %s detected at block 0x%llx/0x%x",
+	xfs_alert(NULL, "Metadata %s detected at %s block 0x%llx/0x%x",
 		  bp->b_error == -EFSBADCRC ? "CRC error" : "corruption",
-		  bp->b_bn, BBTOB(bp->b_length));
+		  bp->b_ops->name, bp->b_bn, BBTOB(bp->b_length));
 }
 
 /*
diff --git a/libxfs/xfs_alloc.c b/libxfs/xfs_alloc.c
index 95c8d44..b43655c 100644
--- a/libxfs/xfs_alloc.c
+++ b/libxfs/xfs_alloc.c
@@ -531,6 +531,7 @@ xfs_agfl_write_verify(
 }
 
 const struct xfs_buf_ops xfs_agfl_buf_ops = {
+	.name = "xfs_agfl",
 	.verify_read = xfs_agfl_read_verify,
 	.verify_write = xfs_agfl_write_verify,
 };
@@ -2335,6 +2336,7 @@ xfs_agf_write_verify(
 }
 
 const struct xfs_buf_ops xfs_agf_buf_ops = {
+	.name = "xfs_agf",
 	.verify_read = xfs_agf_read_verify,
 	.verify_write = xfs_agf_write_verify,
 };
diff --git a/libxfs/xfs_alloc_btree.c b/libxfs/xfs_alloc_btree.c
index e60538a..f583bd1 100644
--- a/libxfs/xfs_alloc_btree.c
+++ b/libxfs/xfs_alloc_btree.c
@@ -377,6 +377,7 @@ xfs_allocbt_write_verify(
 }
 
 const struct xfs_buf_ops xfs_allocbt_buf_ops = {
+	.name = "xfs_allocbt",
 	.verify_read = xfs_allocbt_read_verify,
 	.verify_write = xfs_allocbt_write_verify,
 };
diff --git a/libxfs/xfs_attr_leaf.c b/libxfs/xfs_attr_leaf.c
index bf473eb..1186cac 100644
--- a/libxfs/xfs_attr_leaf.c
+++ b/libxfs/xfs_attr_leaf.c
@@ -323,6 +323,7 @@ xfs_attr3_leaf_read_verify(
 }
 
 const struct xfs_buf_ops xfs_attr3_leaf_buf_ops = {
+	.name = "xfs_attr3_leaf",
 	.verify_read = xfs_attr3_leaf_read_verify,
 	.verify_write = xfs_attr3_leaf_write_verify,
 };
diff --git a/libxfs/xfs_attr_remote.c b/libxfs/xfs_attr_remote.c
index 39ab350..95383e3 100644
--- a/libxfs/xfs_attr_remote.c
+++ b/libxfs/xfs_attr_remote.c
@@ -196,6 +196,7 @@ xfs_attr3_rmt_write_verify(
 }
 
 const struct xfs_buf_ops xfs_attr3_rmt_buf_ops = {
+	.name = "xfs_attr3_rmt",
 	.verify_read = xfs_attr3_rmt_read_verify,
 	.verify_write = xfs_attr3_rmt_write_verify,
 };
diff --git a/libxfs/xfs_bmap_btree.c b/libxfs/xfs_bmap_btree.c
index f42bc2d..52c9c75 100644
--- a/libxfs/xfs_bmap_btree.c
+++ b/libxfs/xfs_bmap_btree.c
@@ -717,6 +717,7 @@ xfs_bmbt_write_verify(
 }
 
 const struct xfs_buf_ops xfs_bmbt_buf_ops = {
+	.name = "xfs_bmbt",
 	.verify_read = xfs_bmbt_read_verify,
 	.verify_write = xfs_bmbt_write_verify,
 };
diff --git a/libxfs/xfs_da_btree.c b/libxfs/xfs_da_btree.c
index bdd60a0..bf5fe21 100644
--- a/libxfs/xfs_da_btree.c
+++ b/libxfs/xfs_da_btree.c
@@ -240,6 +240,7 @@ xfs_da3_node_read_verify(
 }
 
 const struct xfs_buf_ops xfs_da3_node_buf_ops = {
+	.name = "xfs_da3_node",
 	.verify_read = xfs_da3_node_read_verify,
 	.verify_write = xfs_da3_node_write_verify,
 };
diff --git a/libxfs/xfs_dir2_block.c b/libxfs/xfs_dir2_block.c
index d7ba0e9..32bde31 100644
--- a/libxfs/xfs_dir2_block.c
+++ b/libxfs/xfs_dir2_block.c
@@ -119,6 +119,7 @@ xfs_dir3_block_write_verify(
 }
 
 const struct xfs_buf_ops xfs_dir3_block_buf_ops = {
+	.name = "xfs_dir3_block",
 	.verify_read = xfs_dir3_block_read_verify,
 	.verify_write = xfs_dir3_block_write_verify,
 };
diff --git a/libxfs/xfs_dir2_data.c b/libxfs/xfs_dir2_data.c
index 37b3b68..6ae5cd2 100644
--- a/libxfs/xfs_dir2_data.c
+++ b/libxfs/xfs_dir2_data.c
@@ -302,11 +302,13 @@ xfs_dir3_data_write_verify(
 }
 
 const struct xfs_buf_ops xfs_dir3_data_buf_ops = {
+	.name = "xfs_dir3_data",
 	.verify_read = xfs_dir3_data_read_verify,
 	.verify_write = xfs_dir3_data_write_verify,
 };
 
 static const struct xfs_buf_ops xfs_dir3_data_reada_buf_ops = {
+	.name = "xfs_dir3_data_reada",
 	.verify_read = xfs_dir3_data_reada_verify,
 	.verify_write = xfs_dir3_data_write_verify,
 };
diff --git a/libxfs/xfs_dir2_leaf.c b/libxfs/xfs_dir2_leaf.c
index 77c2e65..f80d91f 100644
--- a/libxfs/xfs_dir2_leaf.c
+++ b/libxfs/xfs_dir2_leaf.c
@@ -242,11 +242,13 @@ xfs_dir3_leafn_write_verify(
 }
 
 const struct xfs_buf_ops xfs_dir3_leaf1_buf_ops = {
+	.name = "xfs_dir3_leaf1",
 	.verify_read = xfs_dir3_leaf1_read_verify,
 	.verify_write = xfs_dir3_leaf1_write_verify,
 };
 
 const struct xfs_buf_ops xfs_dir3_leafn_buf_ops = {
+	.name = "xfs_dir3_leafn",
 	.verify_read = xfs_dir3_leafn_read_verify,
 	.verify_write = xfs_dir3_leafn_write_verify,
 };
diff --git a/libxfs/xfs_dir2_node.c b/libxfs/xfs_dir2_node.c
index 689a3fd..224daa6 100644
--- a/libxfs/xfs_dir2_node.c
+++ b/libxfs/xfs_dir2_node.c
@@ -147,6 +147,7 @@ xfs_dir3_free_write_verify(
 }
 
 const struct xfs_buf_ops xfs_dir3_free_buf_ops = {
+	.name = "xfs_dir3_free",
 	.verify_read = xfs_dir3_free_read_verify,
 	.verify_write = xfs_dir3_free_write_verify,
 };
diff --git a/libxfs/xfs_dquot_buf.c b/libxfs/xfs_dquot_buf.c
index 1a2546b..38f9703 100644
--- a/libxfs/xfs_dquot_buf.c
+++ b/libxfs/xfs_dquot_buf.c
@@ -290,6 +290,7 @@ xfs_dquot_buf_write_verify(
 }
 
 const struct xfs_buf_ops xfs_dquot_buf_ops = {
+	.name = "xfs_dquot",
 	.verify_read = xfs_dquot_buf_read_verify,
 	.verify_write = xfs_dquot_buf_write_verify,
 };
diff --git a/libxfs/xfs_ialloc.c b/libxfs/xfs_ialloc.c
index d39f9b6..5039f4b 100644
--- a/libxfs/xfs_ialloc.c
+++ b/libxfs/xfs_ialloc.c
@@ -2566,6 +2566,7 @@ xfs_agi_write_verify(
 }
 
 const struct xfs_buf_ops xfs_agi_buf_ops = {
+	.name = "xfs_agi",
 	.verify_read = xfs_agi_read_verify,
 	.verify_write = xfs_agi_write_verify,
 };
diff --git a/libxfs/xfs_ialloc_btree.c b/libxfs/xfs_ialloc_btree.c
index 09ffdb4..f592ad1 100644
--- a/libxfs/xfs_ialloc_btree.c
+++ b/libxfs/xfs_ialloc_btree.c
@@ -303,6 +303,7 @@ xfs_inobt_write_verify(
 }
 
 const struct xfs_buf_ops xfs_inobt_buf_ops = {
+	.name = "xfs_inobt",
 	.verify_read = xfs_inobt_read_verify,
 	.verify_write = xfs_inobt_write_verify,
 };
diff --git a/libxfs/xfs_inode_buf.c b/libxfs/xfs_inode_buf.c
index 747a879..324715e 100644
--- a/libxfs/xfs_inode_buf.c
+++ b/libxfs/xfs_inode_buf.c
@@ -141,11 +141,13 @@ xfs_inode_buf_write_verify(
 }
 
 const struct xfs_buf_ops xfs_inode_buf_ops = {
+	.name = "xfs_inode",
 	.verify_read = xfs_inode_buf_read_verify,
 	.verify_write = xfs_inode_buf_write_verify,
 };
 
 const struct xfs_buf_ops xfs_inode_buf_ra_ops = {
+	.name = "xxfs_inode_ra",
 	.verify_read = xfs_inode_buf_readahead_verify,
 	.verify_write = xfs_inode_buf_write_verify,
 };
diff --git a/libxfs/xfs_sb.c b/libxfs/xfs_sb.c
index c293d68..78ad889 100644
--- a/libxfs/xfs_sb.c
+++ b/libxfs/xfs_sb.c
@@ -661,11 +661,13 @@ xfs_sb_write_verify(
 }
 
 const struct xfs_buf_ops xfs_sb_buf_ops = {
+	.name = "xfs_sb",
 	.verify_read = xfs_sb_read_verify,
 	.verify_write = xfs_sb_write_verify,
 };
 
 const struct xfs_buf_ops xfs_sb_quiet_buf_ops = {
+	.name = "xfs_sb_quiet",
 	.verify_read = xfs_sb_quiet_read_verify,
 	.verify_write = xfs_sb_write_verify,
 };
diff --git a/libxfs/xfs_symlink_remote.c b/libxfs/xfs_symlink_remote.c
index 647444a..fb9ece8 100644
--- a/libxfs/xfs_symlink_remote.c
+++ b/libxfs/xfs_symlink_remote.c
@@ -164,6 +164,7 @@ xfs_symlink_write_verify(
 }
 
 const struct xfs_buf_ops xfs_symlink_buf_ops = {
+	.name = "xfs_symlink",
 	.verify_read = xfs_symlink_read_verify,
 	.verify_write = xfs_symlink_write_verify,
 };

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
