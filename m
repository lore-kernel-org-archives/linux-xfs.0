Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id EFE7F7FB2
	for <xfs@oss.sgi.com>; Wed, 11 Nov 2015 16:13:27 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 51888AC003
	for <xfs@oss.sgi.com>; Wed, 11 Nov 2015 14:13:24 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 0X7gMgE0tKeaJaCE (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 11 Nov 2015 14:13:19 -0800 (PST)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (Postfix) with ESMTPS id BD1E3C06C9C0
	for <xfs@oss.sgi.com>; Wed, 11 Nov 2015 22:13:18 +0000 (UTC)
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com
	[10.5.9.1])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id tABMDHY9022497
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Wed, 11 Nov 2015 17:13:18 -0500
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] xfs: print name of verifier if it fails
Message-ID: <5643BD7D.4000307@redhat.com>
Date: Wed, 11 Nov 2015 16:13:17 -0600
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
failed it.  Should be a slight debugging aid, I hope.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 3479294..e1e7fe3 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -535,6 +535,7 @@ xfs_agfl_write_verify(
 }
 
 const struct xfs_buf_ops xfs_agfl_buf_ops = {
+	.name = "xfs_agfl",
 	.verify_read = xfs_agfl_read_verify,
 	.verify_write = xfs_agfl_write_verify,
 };
@@ -2339,6 +2340,7 @@ xfs_agf_write_verify(
 }
 
 const struct xfs_buf_ops xfs_agf_buf_ops = {
+	.name = "xfs_agf",
 	.verify_read = xfs_agf_read_verify,
 	.verify_write = xfs_agf_write_verify,
 };
diff --git a/fs/xfs/libxfs/xfs_alloc_btree.c b/fs/xfs/libxfs/xfs_alloc_btree.c
index 90de071..eb8bbfe 100644
--- a/fs/xfs/libxfs/xfs_alloc_btree.c
+++ b/fs/xfs/libxfs/xfs_alloc_btree.c
@@ -379,6 +379,7 @@ xfs_allocbt_write_verify(
 }
 
 const struct xfs_buf_ops xfs_allocbt_buf_ops = {
+	.name = "xfs_allocbt",
 	.verify_read = xfs_allocbt_read_verify,
 	.verify_write = xfs_allocbt_write_verify,
 };
diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index aa187f7..01a5ecf 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -328,6 +328,7 @@ xfs_attr3_leaf_read_verify(
 }
 
 const struct xfs_buf_ops xfs_attr3_leaf_buf_ops = {
+	.name = "xfs_attr3_leaf",
 	.verify_read = xfs_attr3_leaf_read_verify,
 	.verify_write = xfs_attr3_leaf_write_verify,
 };
diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
index 5ab95ff..f3ed9bf 100644
--- a/fs/xfs/libxfs/xfs_attr_remote.c
+++ b/fs/xfs/libxfs/xfs_attr_remote.c
@@ -201,6 +201,7 @@ xfs_attr3_rmt_write_verify(
 }
 
 const struct xfs_buf_ops xfs_attr3_rmt_buf_ops = {
+	.name = "xfs_attr3_rmt",
 	.verify_read = xfs_attr3_rmt_read_verify,
 	.verify_write = xfs_attr3_rmt_write_verify,
 };
diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
index 6b0cf65..1637c37 100644
--- a/fs/xfs/libxfs/xfs_bmap_btree.c
+++ b/fs/xfs/libxfs/xfs_bmap_btree.c
@@ -720,6 +720,7 @@ xfs_bmbt_write_verify(
 }
 
 const struct xfs_buf_ops xfs_bmbt_buf_ops = {
+	.name = "xfs_bmbt",
 	.verify_read = xfs_bmbt_read_verify,
 	.verify_write = xfs_bmbt_write_verify,
 };
diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
index e89a0f8..097bf77 100644
--- a/fs/xfs/libxfs/xfs_da_btree.c
+++ b/fs/xfs/libxfs/xfs_da_btree.c
@@ -245,6 +245,7 @@ xfs_da3_node_read_verify(
 }
 
 const struct xfs_buf_ops xfs_da3_node_buf_ops = {
+	.name = "xfs_da3_node",
 	.verify_read = xfs_da3_node_read_verify,
 	.verify_write = xfs_da3_node_write_verify,
 };
diff --git a/fs/xfs/libxfs/xfs_dir2_block.c b/fs/xfs/libxfs/xfs_dir2_block.c
index 9c10e2b..aa17cb7 100644
--- a/fs/xfs/libxfs/xfs_dir2_block.c
+++ b/fs/xfs/libxfs/xfs_dir2_block.c
@@ -123,6 +123,7 @@ xfs_dir3_block_write_verify(
 }
 
 const struct xfs_buf_ops xfs_dir3_block_buf_ops = {
+	.name = "xfs_dir3_block",
 	.verify_read = xfs_dir3_block_read_verify,
 	.verify_write = xfs_dir3_block_write_verify,
 };
diff --git a/fs/xfs/libxfs/xfs_dir2_data.c b/fs/xfs/libxfs/xfs_dir2_data.c
index af71a84..725fc78 100644
--- a/fs/xfs/libxfs/xfs_dir2_data.c
+++ b/fs/xfs/libxfs/xfs_dir2_data.c
@@ -305,11 +305,13 @@ xfs_dir3_data_write_verify(
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
diff --git a/fs/xfs/libxfs/xfs_dir2_leaf.c b/fs/xfs/libxfs/xfs_dir2_leaf.c
index 3923e1f..b887fb2 100644
--- a/fs/xfs/libxfs/xfs_dir2_leaf.c
+++ b/fs/xfs/libxfs/xfs_dir2_leaf.c
@@ -245,11 +245,13 @@ xfs_dir3_leafn_write_verify(
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
diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
index 70b0cb2..63ee03d 100644
--- a/fs/xfs/libxfs/xfs_dir2_node.c
+++ b/fs/xfs/libxfs/xfs_dir2_node.c
@@ -150,6 +150,7 @@ xfs_dir3_free_write_verify(
 }
 
 const struct xfs_buf_ops xfs_dir3_free_buf_ops = {
+	.name = "xfs_dir3_free",
 	.verify_read = xfs_dir3_free_read_verify,
 	.verify_write = xfs_dir3_free_write_verify,
 };
diff --git a/fs/xfs/libxfs/xfs_dquot_buf.c b/fs/xfs/libxfs/xfs_dquot_buf.c
index 5331b7f..11cefb2 100644
--- a/fs/xfs/libxfs/xfs_dquot_buf.c
+++ b/fs/xfs/libxfs/xfs_dquot_buf.c
@@ -282,6 +282,7 @@ xfs_dquot_buf_write_verify(
 }
 
 const struct xfs_buf_ops xfs_dquot_buf_ops = {
+	.name = "xfs_dquot",
 	.verify_read = xfs_dquot_buf_read_verify,
 	.verify_write = xfs_dquot_buf_write_verify,
 };
diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index 70c1db9..66d702e 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -2572,6 +2572,7 @@ xfs_agi_write_verify(
 }
 
 const struct xfs_buf_ops xfs_agi_buf_ops = {
+	.name = "xfs_agi",
 	.verify_read = xfs_agi_read_verify,
 	.verify_write = xfs_agi_write_verify,
 };
diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.c b/fs/xfs/libxfs/xfs_ialloc_btree.c
index f39b285..6dd44f9 100644
--- a/fs/xfs/libxfs/xfs_ialloc_btree.c
+++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
@@ -304,6 +304,7 @@ xfs_inobt_write_verify(
 }
 
 const struct xfs_buf_ops xfs_inobt_buf_ops = {
+	.name = "xfs_inobt",
 	.verify_read = xfs_inobt_read_verify,
 	.verify_write = xfs_inobt_write_verify,
 };
diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index 268c00f..1b8d98a 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -132,11 +132,13 @@ xfs_inode_buf_write_verify(
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
diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index a0b071d..8a53eaa 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -679,11 +679,13 @@ xfs_sb_write_verify(
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
diff --git a/fs/xfs/libxfs/xfs_symlink_remote.c b/fs/xfs/libxfs/xfs_symlink_remote.c
index cb6fd20..2e2c671 100644
--- a/fs/xfs/libxfs/xfs_symlink_remote.c
+++ b/fs/xfs/libxfs/xfs_symlink_remote.c
@@ -168,6 +168,7 @@ xfs_symlink_write_verify(
 }
 
 const struct xfs_buf_ops xfs_symlink_buf_ops = {
+	.name = "xfs_symlink",
 	.verify_read = xfs_symlink_read_verify,
 	.verify_write = xfs_symlink_write_verify,
 };
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index c79b717..c75721a 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -132,6 +132,7 @@ struct xfs_buf_map {
 	struct xfs_buf_map (map) = { .bm_bn = (blkno), .bm_len = (numblk) };
 
 struct xfs_buf_ops {
+	char *name;
 	void (*verify_read)(struct xfs_buf *);
 	void (*verify_write)(struct xfs_buf *);
 };
diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
index 74d0e59..88693a9 100644
--- a/fs/xfs/xfs_error.c
+++ b/fs/xfs/xfs_error.c
@@ -164,9 +164,9 @@ xfs_verifier_error(
 {
 	struct xfs_mount *mp = bp->b_target->bt_mount;
 
-	xfs_alert(mp, "Metadata %s detected at %pF, block 0x%llx",
+	xfs_alert(mp, "Metadata %s detected at %pF, %s block 0x%llx",
 		  bp->b_error == -EFSBADCRC ? "CRC error" : "corruption",
-		  __return_address, bp->b_bn);
+		  __return_address, bp->b_ops->name, bp->b_bn);
 
 	xfs_alert(mp, "Unmount and run xfs_repair");
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
