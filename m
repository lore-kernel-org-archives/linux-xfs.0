Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 8906729E4F
	for <xfs@oss.sgi.com>; Tue, 18 Jun 2013 23:51:57 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 832C48F8035
	for <xfs@oss.sgi.com>; Tue, 18 Jun 2013 21:51:57 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	vmPx0EcPkN7k3SbV for <xfs@oss.sgi.com>;
	Tue, 18 Jun 2013 21:51:54 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1UpAMv-0002yy-Me
	for xfs@oss.sgi.com; Wed, 19 Jun 2013 14:51:41 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1UpAMq-0008WM-Ie
	for xfs@oss.sgi.com; Wed, 19 Jun 2013 14:51:36 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 15/60] xfs: reshuffle dir2 definitions around for userspace
Date: Wed, 19 Jun 2013 14:50:23 +1000
Message-Id: <1371617468-32559-16-git-send-email-david@fromorbit.com>
In-Reply-To: <1371617468-32559-1-git-send-email-david@fromorbit.com>
References: <1371617468-32559-1-git-send-email-david@fromorbit.com>
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

Many of the definitions within xfs_dir2_priv.h are needed in
userspace outside libxfs. Definitions within xfs_dir2_priv.h are
wholly contained within libxfs, so we need to shuffle some of the
definitions around to keep consistency across files shared between
user and kernel space.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_bmap.c         |    3 ++-
 fs/xfs/xfs_da_btree.c     |    2 +-
 fs/xfs/xfs_dir2.c         |    2 +-
 fs/xfs/xfs_dir2.h         |   51 +++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_dir2_block.c   |    2 +-
 fs/xfs/xfs_dir2_data.c    |    6 ++----
 fs/xfs/xfs_dir2_leaf.c    |    1 +
 fs/xfs/xfs_dir2_node.c    |    1 +
 fs/xfs/xfs_dir2_priv.h    |   31 ---------------------------
 fs/xfs/xfs_dir2_readdir.c |    1 +
 fs/xfs/xfs_dir2_sf.c      |    6 +++---
 fs/xfs/xfs_export.c       |    4 +++-
 fs/xfs/xfs_file.c         |    2 +-
 fs/xfs/xfs_icreate_item.c |   12 -----------
 fs/xfs/xfs_log_recover.c  |    2 +-
 fs/xfs/xfs_mount.c        |    4 +++-
 fs/xfs/xfs_rename.c       |    3 ++-
 fs/xfs/xfs_rtalloc.c      |    1 -
 fs/xfs/xfs_super.c        |    3 ++-
 fs/xfs/xfs_symlink.c      |    3 ++-
 fs/xfs/xfs_utils.c        |    4 +++-
 fs/xfs/xfs_vnodeops.c     |    3 ++-
 22 files changed, 83 insertions(+), 64 deletions(-)

diff --git a/fs/xfs/xfs_bmap.c b/fs/xfs/xfs_bmap.c
index 05c698c..2ddeb43 100644
--- a/fs/xfs/xfs_bmap.c
+++ b/fs/xfs/xfs_bmap.c
@@ -24,9 +24,10 @@
 #include "xfs_trans.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
-#include "xfs_dir2.h"
 #include "xfs_mount.h"
 #include "xfs_da_btree.h"
+#include "xfs_dir2_format.h"
+#include "xfs_dir2.h"
 #include "xfs_bmap_btree.h"
 #include "xfs_alloc_btree.h"
 #include "xfs_ialloc_btree.h"
diff --git a/fs/xfs/xfs_da_btree.c b/fs/xfs/xfs_da_btree.c
index 0b8b2a1..8bbd7ef 100644
--- a/fs/xfs/xfs_da_btree.c
+++ b/fs/xfs/xfs_da_btree.c
@@ -27,8 +27,8 @@
 #include "xfs_mount.h"
 #include "xfs_da_btree.h"
 #include "xfs_bmap_btree.h"
-#include "xfs_dir2.h"
 #include "xfs_dir2_format.h"
+#include "xfs_dir2.h"
 #include "xfs_dir2_priv.h"
 #include "xfs_dinode.h"
 #include "xfs_inode.h"
diff --git a/fs/xfs/xfs_dir2.c b/fs/xfs/xfs_dir2.c
index 431be44..c3263a5 100644
--- a/fs/xfs/xfs_dir2.c
+++ b/fs/xfs/xfs_dir2.c
@@ -31,8 +31,8 @@
 #include "xfs_inode.h"
 #include "xfs_inode_item.h"
 #include "xfs_bmap.h"
-#include "xfs_dir2.h"
 #include "xfs_dir2_format.h"
+#include "xfs_dir2.h"
 #include "xfs_dir2_priv.h"
 #include "xfs_error.h"
 #include "xfs_vnodeops.h"
diff --git a/fs/xfs/xfs_dir2.h b/fs/xfs/xfs_dir2.h
index e937d99..7ef6b0f 100644
--- a/fs/xfs/xfs_dir2.h
+++ b/fs/xfs/xfs_dir2.h
@@ -23,6 +23,11 @@ struct xfs_da_args;
 struct xfs_inode;
 struct xfs_mount;
 struct xfs_trans;
+struct xfs_dir2_sf_hdr;
+struct xfs_dir2_sf_entry;
+struct xfs_dir2_data_hdr;
+struct xfs_dir2_data_entry;
+struct xfs_dir2_data_unused;
 
 extern struct xfs_name	xfs_name_dotdot;
 
@@ -57,4 +62,50 @@ extern int xfs_dir_canenter(struct xfs_trans *tp, struct xfs_inode *dp,
  */
 extern int xfs_dir2_sf_to_block(struct xfs_da_args *args);
 
+/*
+ * Direct call on directory open, before entering the readdir code.
+ */
+extern int xfs_dir3_data_readahead(struct xfs_trans *tp, struct xfs_inode *dp,
+		xfs_dablk_t bno, xfs_daddr_t mapped_bno);
+
+/*
+ * Interface routines used by userspace utilities
+ */
+extern xfs_ino_t xfs_dir2_sf_get_parent_ino(struct xfs_dir2_sf_hdr *sfp);
+extern void xfs_dir2_sf_put_parent_ino(struct xfs_dir2_sf_hdr *sfp,
+		xfs_ino_t ino);
+extern xfs_ino_t xfs_dir2_sfe_get_ino(struct xfs_dir2_sf_hdr *sfp,
+		struct xfs_dir2_sf_entry *sfep);
+extern void xfs_dir2_sfe_put_ino( struct xfs_dir2_sf_hdr *,
+		struct xfs_dir2_sf_entry *sfep, xfs_ino_t ino);
+
+extern int xfs_dir2_isblock(struct xfs_trans *tp, struct xfs_inode *dp, int *r);
+extern int xfs_dir2_isleaf(struct xfs_trans *tp, struct xfs_inode *dp, int *r);
+extern int xfs_dir2_shrink_inode(struct xfs_da_args *args, xfs_dir2_db_t db,
+				struct xfs_buf *bp);
+
+extern void xfs_dir2_data_freescan(struct xfs_mount *mp,
+		struct xfs_dir2_data_hdr *hdr, int *loghead);
+extern void xfs_dir2_data_log_entry(struct xfs_trans *tp, struct xfs_buf *bp,
+		struct xfs_dir2_data_entry *dep);
+extern void xfs_dir2_data_log_header(struct xfs_trans *tp,
+		struct xfs_buf *bp);
+extern void xfs_dir2_data_log_unused(struct xfs_trans *tp, struct xfs_buf *bp,
+		struct xfs_dir2_data_unused *dup);
+extern void xfs_dir2_data_make_free(struct xfs_trans *tp, struct xfs_buf *bp,
+		xfs_dir2_data_aoff_t offset, xfs_dir2_data_aoff_t len,
+		int *needlogp, int *needscanp);
+extern void xfs_dir2_data_use_free(struct xfs_trans *tp, struct xfs_buf *bp,
+		struct xfs_dir2_data_unused *dup, xfs_dir2_data_aoff_t offset,
+		xfs_dir2_data_aoff_t len, int *needlogp, int *needscanp);
+
+extern struct xfs_dir2_data_free *xfs_dir2_data_freefind(
+		struct xfs_dir2_data_hdr *hdr, struct xfs_dir2_data_unused *dup);
+
+extern const struct xfs_buf_ops xfs_dir3_block_buf_ops;
+extern const struct xfs_buf_ops xfs_dir3_leafn_buf_ops;
+extern const struct xfs_buf_ops xfs_dir3_leaf1_buf_ops;
+extern const struct xfs_buf_ops xfs_dir3_free_buf_ops;
+extern const struct xfs_buf_ops xfs_dir3_data_buf_ops;
+
 #endif	/* __XFS_DIR2_H__ */
diff --git a/fs/xfs/xfs_dir2_block.c b/fs/xfs/xfs_dir2_block.c
index 5e84000..becd69f 100644
--- a/fs/xfs/xfs_dir2_block.c
+++ b/fs/xfs/xfs_dir2_block.c
@@ -31,8 +31,8 @@
 #include "xfs_inode_item.h"
 #include "xfs_bmap.h"
 #include "xfs_buf_item.h"
-#include "xfs_dir2.h"
 #include "xfs_dir2_format.h"
+#include "xfs_dir2.h"
 #include "xfs_dir2_priv.h"
 #include "xfs_error.h"
 #include "xfs_trace.h"
diff --git a/fs/xfs/xfs_dir2_data.c b/fs/xfs/xfs_dir2_data.c
index c293023..4e1917d 100644
--- a/fs/xfs/xfs_dir2_data.c
+++ b/fs/xfs/xfs_dir2_data.c
@@ -29,14 +29,12 @@
 #include "xfs_dinode.h"
 #include "xfs_inode.h"
 #include "xfs_dir2_format.h"
+#include "xfs_dir2.h"
 #include "xfs_dir2_priv.h"
 #include "xfs_error.h"
 #include "xfs_buf_item.h"
 #include "xfs_cksum.h"
 
-STATIC xfs_dir2_data_free_t *
-xfs_dir2_data_freefind(xfs_dir2_data_hdr_t *hdr, xfs_dir2_data_unused_t *dup);
-
 /*
  * Check the consistency of the data block.
  * The input can also be a block-format directory.
@@ -325,7 +323,7 @@ xfs_dir3_data_readahead(
  * Given a data block and an unused entry from that block,
  * return the bestfree entry if any that corresponds to it.
  */
-STATIC xfs_dir2_data_free_t *
+xfs_dir2_data_free_t *
 xfs_dir2_data_freefind(
 	xfs_dir2_data_hdr_t	*hdr,		/* data block */
 	xfs_dir2_data_unused_t	*dup)		/* data unused entry */
diff --git a/fs/xfs/xfs_dir2_leaf.c b/fs/xfs/xfs_dir2_leaf.c
index e1aed21..005a6b3 100644
--- a/fs/xfs/xfs_dir2_leaf.c
+++ b/fs/xfs/xfs_dir2_leaf.c
@@ -31,6 +31,7 @@
 #include "xfs_inode.h"
 #include "xfs_bmap.h"
 #include "xfs_dir2_format.h"
+#include "xfs_dir2.h"
 #include "xfs_dir2_priv.h"
 #include "xfs_error.h"
 #include "xfs_trace.h"
diff --git a/fs/xfs/xfs_dir2_node.c b/fs/xfs/xfs_dir2_node.c
index 2226a00..b4bd9b6 100644
--- a/fs/xfs/xfs_dir2_node.c
+++ b/fs/xfs/xfs_dir2_node.c
@@ -30,6 +30,7 @@
 #include "xfs_inode.h"
 #include "xfs_bmap.h"
 #include "xfs_dir2_format.h"
+#include "xfs_dir2.h"
 #include "xfs_dir2_priv.h"
 #include "xfs_error.h"
 #include "xfs_trace.h"
diff --git a/fs/xfs/xfs_dir2_priv.h b/fs/xfs/xfs_dir2_priv.h
index 72ff8d7..807eb65 100644
--- a/fs/xfs/xfs_dir2_priv.h
+++ b/fs/xfs/xfs_dir2_priv.h
@@ -20,18 +20,12 @@
 
 /* xfs_dir2.c */
 extern int xfs_dir_ino_validate(struct xfs_mount *mp, xfs_ino_t ino);
-extern int xfs_dir2_isblock(struct xfs_trans *tp, struct xfs_inode *dp, int *r);
-extern int xfs_dir2_isleaf(struct xfs_trans *tp, struct xfs_inode *dp, int *r);
 extern int xfs_dir2_grow_inode(struct xfs_da_args *args, int space,
 				xfs_dir2_db_t *dbp);
-extern int xfs_dir2_shrink_inode(struct xfs_da_args *args, xfs_dir2_db_t db,
-				struct xfs_buf *bp);
 extern int xfs_dir_cilookup_result(struct xfs_da_args *args,
 				const unsigned char *name, int len);
 
 /* xfs_dir2_block.c */
-extern const struct xfs_buf_ops xfs_dir3_block_buf_ops;
-
 extern int xfs_dir3_block_read(struct xfs_trans *tp, struct xfs_inode *dp,
 			       struct xfs_buf **bpp);
 extern int xfs_dir2_block_addname(struct xfs_da_args *args);
@@ -48,39 +42,17 @@ extern int xfs_dir2_leaf_to_block(struct xfs_da_args *args,
 #define	xfs_dir3_data_check(dp,bp)
 #endif
 
-extern const struct xfs_buf_ops xfs_dir3_data_buf_ops;
-extern const struct xfs_buf_ops xfs_dir3_free_buf_ops;
-
 extern int __xfs_dir3_data_check(struct xfs_inode *dp, struct xfs_buf *bp);
 extern int xfs_dir3_data_read(struct xfs_trans *tp, struct xfs_inode *dp,
 		xfs_dablk_t bno, xfs_daddr_t mapped_bno, struct xfs_buf **bpp);
-extern int xfs_dir3_data_readahead(struct xfs_trans *tp, struct xfs_inode *dp,
-		xfs_dablk_t bno, xfs_daddr_t mapped_bno);
 
 extern struct xfs_dir2_data_free *
 xfs_dir2_data_freeinsert(struct xfs_dir2_data_hdr *hdr,
 		struct xfs_dir2_data_unused *dup, int *loghead);
-extern void xfs_dir2_data_freescan(struct xfs_mount *mp,
-		struct xfs_dir2_data_hdr *hdr, int *loghead);
 extern int xfs_dir3_data_init(struct xfs_da_args *args, xfs_dir2_db_t blkno,
 		struct xfs_buf **bpp);
-extern void xfs_dir2_data_log_entry(struct xfs_trans *tp, struct xfs_buf *bp,
-		struct xfs_dir2_data_entry *dep);
-extern void xfs_dir2_data_log_header(struct xfs_trans *tp,
-		struct xfs_buf *bp);
-extern void xfs_dir2_data_log_unused(struct xfs_trans *tp, struct xfs_buf *bp,
-		struct xfs_dir2_data_unused *dup);
-extern void xfs_dir2_data_make_free(struct xfs_trans *tp, struct xfs_buf *bp,
-		xfs_dir2_data_aoff_t offset, xfs_dir2_data_aoff_t len,
-		int *needlogp, int *needscanp);
-extern void xfs_dir2_data_use_free(struct xfs_trans *tp, struct xfs_buf *bp,
-		struct xfs_dir2_data_unused *dup, xfs_dir2_data_aoff_t offset,
-		xfs_dir2_data_aoff_t len, int *needlogp, int *needscanp);
 
 /* xfs_dir2_leaf.c */
-extern const struct xfs_buf_ops xfs_dir3_leaf1_buf_ops;
-extern const struct xfs_buf_ops xfs_dir3_leafn_buf_ops;
-
 extern int xfs_dir3_leafn_read(struct xfs_trans *tp, struct xfs_inode *dp,
 		xfs_dablk_t fbno, xfs_daddr_t mappedbno, struct xfs_buf **bpp);
 extern int xfs_dir2_block_to_leaf(struct xfs_da_args *args,
@@ -142,9 +114,6 @@ extern int xfs_dir2_free_read(struct xfs_trans *tp, struct xfs_inode *dp,
 		xfs_dablk_t fbno, struct xfs_buf **bpp);
 
 /* xfs_dir2_sf.c */
-extern xfs_ino_t xfs_dir2_sf_get_parent_ino(struct xfs_dir2_sf_hdr *sfp);
-extern xfs_ino_t xfs_dir2_sfe_get_ino(struct xfs_dir2_sf_hdr *sfp,
-		struct xfs_dir2_sf_entry *sfep);
 extern int xfs_dir2_block_sfsize(struct xfs_inode *dp,
 		struct xfs_dir2_data_hdr *block, struct xfs_dir2_sf_hdr *sfhp);
 extern int xfs_dir2_block_to_sf(struct xfs_da_args *args, struct xfs_buf *bp,
diff --git a/fs/xfs/xfs_dir2_readdir.c b/fs/xfs/xfs_dir2_readdir.c
index af17c00..88da6b8 100644
--- a/fs/xfs/xfs_dir2_readdir.c
+++ b/fs/xfs/xfs_dir2_readdir.c
@@ -30,6 +30,7 @@
 #include "xfs_dinode.h"
 #include "xfs_inode.h"
 #include "xfs_dir2_format.h"
+#include "xfs_dir2.h"
 #include "xfs_dir2_priv.h"
 #include "xfs_error.h"
 #include "xfs_trace.h"
diff --git a/fs/xfs/xfs_dir2_sf.c b/fs/xfs/xfs_dir2_sf.c
index f24ce90..65b65c5 100644
--- a/fs/xfs/xfs_dir2_sf.c
+++ b/fs/xfs/xfs_dir2_sf.c
@@ -29,8 +29,8 @@
 #include "xfs_inode.h"
 #include "xfs_inode_item.h"
 #include "xfs_error.h"
-#include "xfs_dir2.h"
 #include "xfs_dir2_format.h"
+#include "xfs_dir2.h"
 #include "xfs_dir2_priv.h"
 #include "xfs_trace.h"
 
@@ -95,7 +95,7 @@ xfs_dir2_sf_get_parent_ino(
 	return xfs_dir2_sf_get_ino(hdr, &hdr->parent);
 }
 
-static void
+void
 xfs_dir2_sf_put_parent_ino(
 	struct xfs_dir2_sf_hdr	*hdr,
 	xfs_ino_t		ino)
@@ -123,7 +123,7 @@ xfs_dir2_sfe_get_ino(
 	return xfs_dir2_sf_get_ino(hdr, xfs_dir2_sfe_inop(sfep));
 }
 
-static void
+void
 xfs_dir2_sfe_put_ino(
 	struct xfs_dir2_sf_hdr	*hdr,
 	struct xfs_dir2_sf_entry *sfep,
diff --git a/fs/xfs/xfs_export.c b/fs/xfs/xfs_export.c
index c585bc6..29c880f 100644
--- a/fs/xfs/xfs_export.c
+++ b/fs/xfs/xfs_export.c
@@ -21,8 +21,10 @@
 #include "xfs_trans.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
-#include "xfs_dir2.h"
 #include "xfs_mount.h"
+#include "xfs_da_btree.h"
+#include "xfs_dir2_format.h"
+#include "xfs_dir2.h"
 #include "xfs_export.h"
 #include "xfs_vnodeops.h"
 #include "xfs_bmap_btree.h"
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index a5f2042..16521f1 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -32,7 +32,7 @@
 #include "xfs_vnodeops.h"
 #include "xfs_da_btree.h"
 #include "xfs_dir2_format.h"
-#include "xfs_dir2_priv.h"
+#include "xfs_dir2.h"
 #include "xfs_ioctl.h"
 #include "xfs_trace.h"
 
diff --git a/fs/xfs/xfs_icreate_item.c b/fs/xfs/xfs_icreate_item.c
index 7716a4e..441a78a 100644
--- a/fs/xfs/xfs_icreate_item.c
+++ b/fs/xfs/xfs_icreate_item.c
@@ -20,23 +20,11 @@
 #include "xfs_types.h"
 #include "xfs_bit.h"
 #include "xfs_log.h"
-#include "xfs_inum.h"
 #include "xfs_trans.h"
-#include "xfs_buf_item.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
-#include "xfs_dir2.h"
 #include "xfs_mount.h"
 #include "xfs_trans_priv.h"
-#include "xfs_bmap_btree.h"
-#include "xfs_alloc_btree.h"
-#include "xfs_ialloc_btree.h"
-#include "xfs_attr_sf.h"
-#include "xfs_dinode.h"
-#include "xfs_inode.h"
-#include "xfs_inode_item.h"
-#include "xfs_btree.h"
-#include "xfs_ialloc.h"
 #include "xfs_error.h"
 #include "xfs_icreate_item.h"
 
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 6fcc910a..ffa519d 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -51,7 +51,7 @@
 #include "xfs_symlink.h"
 #include "xfs_da_btree.h"
 #include "xfs_dir2_format.h"
-#include "xfs_dir2_priv.h"
+#include "xfs_dir2.h"
 #include "xfs_attr_leaf.h"
 #include "xfs_attr_remote.h"
 
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index e8e310c..e7253e2 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -25,8 +25,10 @@
 #include "xfs_trans_priv.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
-#include "xfs_dir2.h"
 #include "xfs_mount.h"
+#include "xfs_da_btree.h"
+#include "xfs_dir2_format.h"
+#include "xfs_dir2.h"
 #include "xfs_bmap_btree.h"
 #include "xfs_alloc_btree.h"
 #include "xfs_ialloc_btree.h"
diff --git a/fs/xfs/xfs_rename.c b/fs/xfs/xfs_rename.c
index 30ff5f4..b0ac54f 100644
--- a/fs/xfs/xfs_rename.c
+++ b/fs/xfs/xfs_rename.c
@@ -22,9 +22,10 @@
 #include "xfs_trans.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
-#include "xfs_dir2.h"
 #include "xfs_mount.h"
 #include "xfs_da_btree.h"
+#include "xfs_dir2_format.h"
+#include "xfs_dir2.h"
 #include "xfs_bmap_btree.h"
 #include "xfs_dinode.h"
 #include "xfs_inode.h"
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 98dc670..7fed9c2 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -23,7 +23,6 @@
 #include "xfs_trans.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
-#include "xfs_dir2.h"
 #include "xfs_mount.h"
 #include "xfs_bmap_btree.h"
 #include "xfs_dinode.h"
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index f59e27f..1496094 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -22,7 +22,6 @@
 #include "xfs_trans.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
-#include "xfs_dir2.h"
 #include "xfs_alloc.h"
 #include "xfs_quota.h"
 #include "xfs_mount.h"
@@ -46,6 +45,8 @@
 #include "xfs_trans_priv.h"
 #include "xfs_filestream.h"
 #include "xfs_da_btree.h"
+#include "xfs_dir2_format.h"
+#include "xfs_dir2.h"
 #include "xfs_extfree_item.h"
 #include "xfs_mru_cache.h"
 #include "xfs_inode_item.h"
diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
index 195a403..996925b 100644
--- a/fs/xfs/xfs_symlink.c
+++ b/fs/xfs/xfs_symlink.c
@@ -24,9 +24,10 @@
 #include "xfs_trans.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
-#include "xfs_dir2.h"
 #include "xfs_mount.h"
 #include "xfs_da_btree.h"
+#include "xfs_dir2_format.h"
+#include "xfs_dir2.h"
 #include "xfs_bmap_btree.h"
 #include "xfs_ialloc_btree.h"
 #include "xfs_dinode.h"
diff --git a/fs/xfs/xfs_utils.c b/fs/xfs/xfs_utils.c
index 0025c78..7bf8f13 100644
--- a/fs/xfs/xfs_utils.c
+++ b/fs/xfs/xfs_utils.c
@@ -22,8 +22,10 @@
 #include "xfs_trans.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
-#include "xfs_dir2.h"
 #include "xfs_mount.h"
+#include "xfs_da_btree.h"
+#include "xfs_dir2_format.h"
+#include "xfs_dir2.h"
 #include "xfs_bmap_btree.h"
 #include "xfs_dinode.h"
 #include "xfs_inode.h"
diff --git a/fs/xfs/xfs_vnodeops.c b/fs/xfs/xfs_vnodeops.c
index 0176bb2..acec328 100644
--- a/fs/xfs/xfs_vnodeops.c
+++ b/fs/xfs/xfs_vnodeops.c
@@ -25,9 +25,10 @@
 #include "xfs_trans.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
-#include "xfs_dir2.h"
 #include "xfs_mount.h"
 #include "xfs_da_btree.h"
+#include "xfs_dir2_format.h"
+#include "xfs_dir2.h"
 #include "xfs_bmap_btree.h"
 #include "xfs_ialloc_btree.h"
 #include "xfs_dinode.h"
-- 
1.7.10.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
