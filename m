Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B9A8E7F6C
	for <xfs@oss.sgi.com>; Fri,  7 Jun 2013 00:46:08 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 36BCEAC007
	for <xfs@oss.sgi.com>; Thu,  6 Jun 2013 22:46:08 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	FScWgm6sR7xgvqc7 for <xfs@oss.sgi.com>;
	Thu, 06 Jun 2013 22:46:06 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1UkpUn-0004YS-Or
	for xfs@oss.sgi.com; Fri, 07 Jun 2013 15:45:53 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1UkpUd-0003lU-LX
	for xfs@oss.sgi.com; Fri, 07 Jun 2013 15:45:43 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 15/17] xfs: reshuffle dir2 definitions around for userspace
Date: Fri,  7 Jun 2013 15:45:27 +1000
Message-Id: <1370583929-14276-16-git-send-email-david@fromorbit.com>
In-Reply-To: <1370583929-14276-1-git-send-email-david@fromorbit.com>
References: <1370583929-14276-1-git-send-email-david@fromorbit.com>
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
 fs/xfs/xfs_dir2.h        |   71 ++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_dir2_data.c   |    1 +
 fs/xfs/xfs_dir2_format.h |   24 ----------------
 fs/xfs/xfs_dir2_leaf.c   |    1 +
 fs/xfs/xfs_dir2_node.c   |    1 +
 fs/xfs/xfs_dir2_priv.h   |   31 --------------------
 fs/xfs/xfs_dir2_sf.c     |    4 +--
 fs/xfs/xfs_file.c        |    3 +-
 fs/xfs/xfs_log_recover.c |    2 +-
 9 files changed, 78 insertions(+), 60 deletions(-)

diff --git a/fs/xfs/xfs_dir2.h b/fs/xfs/xfs_dir2.h
index e937d99..df3e20b 100644
--- a/fs/xfs/xfs_dir2.h
+++ b/fs/xfs/xfs_dir2.h
@@ -23,10 +23,35 @@ struct xfs_da_args;
 struct xfs_inode;
 struct xfs_mount;
 struct xfs_trans;
+struct xfs_dir2_sf_hdr;
+struct xfs_dir2_sf_entry;
+struct xfs_dir2_data_hdr;
+struct xfs_dir2_data_entry;
+struct xfs_dir2_data_unused;
 
 extern struct xfs_name	xfs_name_dotdot;
 
 /*
+ * Directory type definitions
+ */
+
+/* Byte offset in data block and shortform entry.  */
+typedef	__uint16_t	xfs_dir2_data_off_t;
+#define	NULLDATAOFF	0xffffU
+typedef uint		xfs_dir2_data_aoff_t;	/* argument form */
+
+/* Offset in data space of a data entry.  */
+typedef	__uint32_t	xfs_dir2_dataptr_t;
+#define	XFS_DIR2_MAX_DATAPTR	((xfs_dir2_dataptr_t)0xffffffff)
+#define	XFS_DIR2_NULL_DATAPTR	((xfs_dir2_dataptr_t)0)
+
+/* Byte offset in a directory. */
+typedef	xfs_off_t	xfs_dir2_off_t;
+
+/* Directory block number (logical dirblk in file) */
+typedef	__uint32_t	xfs_dir2_db_t;
+
+/*
  * Generic directory interface routines
  */
 extern void xfs_dir_startup(void);
@@ -57,4 +82,50 @@ extern int xfs_dir_canenter(struct xfs_trans *tp, struct xfs_inode *dp,
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
diff --git a/fs/xfs/xfs_dir2_data.c b/fs/xfs/xfs_dir2_data.c
index c293023..465027b 100644
--- a/fs/xfs/xfs_dir2_data.c
+++ b/fs/xfs/xfs_dir2_data.c
@@ -28,6 +28,7 @@
 #include "xfs_bmap_btree.h"
 #include "xfs_dinode.h"
 #include "xfs_inode.h"
+#include "xfs_dir2.h"
 #include "xfs_dir2_format.h"
 #include "xfs_dir2_priv.h"
 #include "xfs_error.h"
diff --git a/fs/xfs/xfs_dir2_format.h b/fs/xfs/xfs_dir2_format.h
index 995f1f5..18ca87d 100644
--- a/fs/xfs/xfs_dir2_format.h
+++ b/fs/xfs/xfs_dir2_format.h
@@ -69,36 +69,12 @@
 #define	XFS_DIR3_FREE_MAGIC	0x58444633	/* XDF3: free index blocks */
 
 /*
- * Byte offset in data block and shortform entry.
- */
-typedef	__uint16_t	xfs_dir2_data_off_t;
-#define	NULLDATAOFF	0xffffU
-typedef uint		xfs_dir2_data_aoff_t;	/* argument form */
-
-/*
  * Normalized offset (in a data block) of the entry, really xfs_dir2_data_off_t.
  * Only need 16 bits, this is the byte offset into the single block form.
  */
 typedef struct { __uint8_t i[2]; } __arch_pack xfs_dir2_sf_off_t;
 
 /*
- * Offset in data space of a data entry.
- */
-typedef	__uint32_t	xfs_dir2_dataptr_t;
-#define	XFS_DIR2_MAX_DATAPTR	((xfs_dir2_dataptr_t)0xffffffff)
-#define	XFS_DIR2_NULL_DATAPTR	((xfs_dir2_dataptr_t)0)
-
-/*
- * Byte offset in a directory.
- */
-typedef	xfs_off_t	xfs_dir2_off_t;
-
-/*
- * Directory block number (logical dirblk in file)
- */
-typedef	__uint32_t	xfs_dir2_db_t;
-
-/*
  * Inode number stored as 8 8-bit values.
  */
 typedef	struct { __uint8_t i[8]; } xfs_dir2_ino8_t;
diff --git a/fs/xfs/xfs_dir2_leaf.c b/fs/xfs/xfs_dir2_leaf.c
index e1aed21..c60e3a7 100644
--- a/fs/xfs/xfs_dir2_leaf.c
+++ b/fs/xfs/xfs_dir2_leaf.c
@@ -30,6 +30,7 @@
 #include "xfs_dinode.h"
 #include "xfs_inode.h"
 #include "xfs_bmap.h"
+#include "xfs_dir2.h"
 #include "xfs_dir2_format.h"
 #include "xfs_dir2_priv.h"
 #include "xfs_error.h"
diff --git a/fs/xfs/xfs_dir2_node.c b/fs/xfs/xfs_dir2_node.c
index 2226a00..7b448f5 100644
--- a/fs/xfs/xfs_dir2_node.c
+++ b/fs/xfs/xfs_dir2_node.c
@@ -29,6 +29,7 @@
 #include "xfs_dinode.h"
 #include "xfs_inode.h"
 #include "xfs_bmap.h"
+#include "xfs_dir2.h"
 #include "xfs_dir2_format.h"
 #include "xfs_dir2_priv.h"
 #include "xfs_error.h"
diff --git a/fs/xfs/xfs_dir2_priv.h b/fs/xfs/xfs_dir2_priv.h
index 1f949df..134e19e 100644
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
@@ -50,39 +44,17 @@ extern int xfs_dir2_leaf_to_block(struct xfs_da_args *args,
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
@@ -146,9 +118,6 @@ extern int xfs_dir2_free_read(struct xfs_trans *tp, struct xfs_inode *dp,
 		xfs_dablk_t fbno, struct xfs_buf **bpp);
 
 /* xfs_dir2_sf.c */
-extern xfs_ino_t xfs_dir2_sf_get_parent_ino(struct xfs_dir2_sf_hdr *sfp);
-extern xfs_ino_t xfs_dir2_sfe_get_ino(struct xfs_dir2_sf_hdr *sfp,
-		struct xfs_dir2_sf_entry *sfep);
 extern int xfs_dir2_block_sfsize(struct xfs_inode *dp,
 		struct xfs_dir2_data_hdr *block, struct xfs_dir2_sf_hdr *sfhp);
 extern int xfs_dir2_block_to_sf(struct xfs_da_args *args, struct xfs_buf *bp,
diff --git a/fs/xfs/xfs_dir2_sf.c b/fs/xfs/xfs_dir2_sf.c
index f24ce90..40bf17e 100644
--- a/fs/xfs/xfs_dir2_sf.c
+++ b/fs/xfs/xfs_dir2_sf.c
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
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index a5f2042..5190689 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -31,8 +31,7 @@
 #include "xfs_error.h"
 #include "xfs_vnodeops.h"
 #include "xfs_da_btree.h"
-#include "xfs_dir2_format.h"
-#include "xfs_dir2_priv.h"
+#include "xfs_dir2.h"
 #include "xfs_ioctl.h"
 #include "xfs_trace.h"
 
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index a8428b6..8c01546 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -50,8 +50,8 @@
 /* Need all the magic numbers and buffer ops structures from these headers */
 #include "xfs_symlink.h"
 #include "xfs_da_btree.h"
+#include "xfs_dir2.h"
 #include "xfs_dir2_format.h"
-#include "xfs_dir2_priv.h"
 #include "xfs_attr_leaf.h"
 #include "xfs_attr_remote.h"
 
-- 
1.7.10.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
