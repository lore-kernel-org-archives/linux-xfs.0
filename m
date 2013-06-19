Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E35CC7FB2
	for <xfs@oss.sgi.com>; Wed, 19 Jun 2013 00:37:01 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D17F6304039
	for <xfs@oss.sgi.com>; Tue, 18 Jun 2013 22:37:01 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	2ZdwbRtqtfCt7eet for <xfs@oss.sgi.com>;
	Tue, 18 Jun 2013 22:36:59 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1UpB4e-0003Bq-AU
	for xfs@oss.sgi.com; Wed, 19 Jun 2013 15:36:52 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1UpB4U-0000FN-1F
	for xfs@oss.sgi.com; Wed, 19 Jun 2013 15:36:42 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 25/50] xfs: split out buf log item format definitions
Date: Wed, 19 Jun 2013 15:35:48 +1000
Message-Id: <1371620173-712-26-git-send-email-david@fromorbit.com>
In-Reply-To: <1371620173-712-1-git-send-email-david@fromorbit.com>
References: <1371620173-712-1-git-send-email-david@fromorbit.com>
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

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 include/Makefile              |    2 +-
 include/libxfs.h              |    8 +-
 include/libxlog.h             |    2 +-
 include/xfs_buf_item.h        |  174 -----------------------------------------
 include/xfs_buf_item_format.h |  111 ++++++++++++++++++++++++++
 5 files changed, 120 insertions(+), 177 deletions(-)
 delete mode 100644 include/xfs_buf_item.h
 create mode 100644 include/xfs_buf_item_format.h

diff --git a/include/Makefile b/include/Makefile
index 6ff2749..91ee0e3 100644
--- a/include/Makefile
+++ b/include/Makefile
@@ -23,7 +23,7 @@ QAHFILES = libxfs.h libxlog.h \
 	swab.h \
 	xfs_ag.h xfs_alloc.h xfs_alloc_btree.h xfs_arch.h xfs_attr_leaf.h \
 	xfs_attr_sf.h xfs_bit.h xfs_bmap.h xfs_bmap_btree.h xfs_btree.h \
-	xfs_btree_trace.h xfs_buf_item.h xfs_cksum.h xfs_da_btree.h \
+	xfs_btree_trace.h xfs_buf_item_format.h xfs_cksum.h xfs_da_btree.h \
 	xfs_dinode.h xfs_dir2.h xfs_dir2_format.h \
 	xfs_extfree_item.h xfs_ialloc.h xfs_ialloc_btree.h \
 	xfs_icreate_item.h xfs_inode.h xfs_inode_item_format.h xfs_inum.h \
diff --git a/include/libxfs.h b/include/libxfs.h
index 0c0291b..7be9b1f 100644
--- a/include/libxfs.h
+++ b/include/libxfs.h
@@ -47,7 +47,7 @@
 #include <xfs/xfs_attr_sf.h>
 #include <xfs/xfs_dinode.h>
 #include <xfs/xfs_inode.h>
-#include <xfs/xfs_buf_item.h>
+#include <xfs/xfs_buf_item_format.h>
 #include <xfs/xfs_inode_item_format.h>
 #include <xfs/xfs_alloc.h>
 #include <xfs/xfs_btree.h>
@@ -444,6 +444,12 @@ typedef struct xfs_buf_log_item {
 	xfs_buf_log_format_t	bli_format;	/* in-log header */
 } xfs_buf_log_item_t;
 
+/* buf log item flags */
+#define	XFS_BLI_HOLD		0x01
+#define	XFS_BLI_DIRTY		0x02
+#define	XFS_BLI_STALE		0x04
+#define	XFS_BLI_INODE_ALLOC_BUF	0x10
+
 typedef struct xfs_dq_logitem {
 	xfs_log_item_t		qli_item;	/* common portion */
 	struct xfs_dquot	*qli_dquot;	/* dquot ptr */
diff --git a/include/libxlog.h b/include/libxlog.h
index e003b30..9227a3a 100644
--- a/include/libxlog.h
+++ b/include/libxlog.h
@@ -48,7 +48,7 @@ struct xlog {
 };
 
 #include <xfs/xfs_log_recover.h>
-#include <xfs/xfs_buf_item.h>
+#include <xfs/xfs_buf_item_format.h>
 #include <xfs/xfs_inode_item_format.h>
 #include <xfs/xfs_extfree_item.h>
 #include <xfs/xfs_icreate_item.h>
diff --git a/include/xfs_buf_item.h b/include/xfs_buf_item.h
deleted file mode 100644
index 0f1c247..0000000
--- a/include/xfs_buf_item.h
+++ /dev/null
@@ -1,174 +0,0 @@
-/*
- * Copyright (c) 2000-2001,2005 Silicon Graphics, Inc.
- * All Rights Reserved.
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it would be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write the Free Software Foundation,
- * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
- */
-#ifndef	__XFS_BUF_ITEM_H__
-#define	__XFS_BUF_ITEM_H__
-
-extern kmem_zone_t	*xfs_buf_item_zone;
-
-/*
- * This flag indicates that the buffer contains on disk inodes
- * and requires special recovery handling.
- */
-#define	XFS_BLF_INODE_BUF	(1<<0)
-/*
- * This flag indicates that the buffer should not be replayed
- * during recovery because its blocks are being freed.
- */
-#define	XFS_BLF_CANCEL		(1<<1)
-
-/*
- * This flag indicates that the buffer contains on disk
- * user or group dquots and may require special recovery handling.
- */
-#define	XFS_BLF_UDQUOT_BUF	(1<<2)
-#define XFS_BLF_PDQUOT_BUF	(1<<3)
-#define	XFS_BLF_GDQUOT_BUF	(1<<4)
-
-#define	XFS_BLF_CHUNK		128
-#define	XFS_BLF_SHIFT		7
-#define	BIT_TO_WORD_SHIFT	5
-#define	NBWORD			(NBBY * sizeof(unsigned int))
-
-/*
- * This is the structure used to lay out a buf log item in the
- * log.  The data map describes which 128 byte chunks of the buffer
- * have been logged.
- */
-#define XFS_BLF_DATAMAP_SIZE	((XFS_MAX_BLOCKSIZE / XFS_BLF_CHUNK) / NBWORD)
-
-typedef struct xfs_buf_log_format {
-	unsigned short	blf_type;	/* buf log item type indicator */
-	unsigned short	blf_size;	/* size of this item */
-	ushort		blf_flags;	/* misc state */
-	ushort		blf_len;	/* number of blocks in this buf */
-	__int64_t	blf_blkno;	/* starting blkno of this buf */
-	unsigned int	blf_map_size;	/* used size of data bitmap in words */
-	unsigned int	blf_data_map[XFS_BLF_DATAMAP_SIZE]; /* dirty bitmap */
-} xfs_buf_log_format_t;
-
-/*
- * All buffers now need to tell recovery where the magic number
- * is so that it can verify and calculate the CRCs on the buffer correctly
- * once the changes have been replayed into the buffer.
- *
- * The type value is held in the upper 5 bits of the blf_flags field, which is
- * an unsigned 16 bit field. Hence we need to shift it 11 bits up and down.
- */
-#define XFS_BLFT_BITS	5
-#define XFS_BLFT_SHIFT	11
-#define XFS_BLFT_MASK	(((1 << XFS_BLFT_BITS) - 1) << XFS_BLFT_SHIFT)
-
-enum xfs_blft {
-	XFS_BLFT_UNKNOWN_BUF = 0,
-	XFS_BLFT_UDQUOT_BUF,
-	XFS_BLFT_PDQUOT_BUF,
-	XFS_BLFT_GDQUOT_BUF,
-	XFS_BLFT_BTREE_BUF,
-	XFS_BLFT_AGF_BUF,
-	XFS_BLFT_AGFL_BUF,
-	XFS_BLFT_AGI_BUF,
-	XFS_BLFT_DINO_BUF,
-	XFS_BLFT_SYMLINK_BUF,
-	XFS_BLFT_DIR_BLOCK_BUF,
-	XFS_BLFT_DIR_DATA_BUF,
-	XFS_BLFT_DIR_FREE_BUF,
-	XFS_BLFT_DIR_LEAF1_BUF,
-	XFS_BLFT_DIR_LEAFN_BUF,
-	XFS_BLFT_DA_NODE_BUF,
-	XFS_BLFT_ATTR_LEAF_BUF,
-	XFS_BLFT_ATTR_RMT_BUF,
-	XFS_BLFT_SB_BUF,
-	XFS_BLFT_MAX_BUF = (1 << XFS_BLFT_BITS),
-};
-
-static inline void
-xfs_blft_to_flags(struct xfs_buf_log_format *blf, enum xfs_blft type)
-{
-	ASSERT(type > XFS_BLFT_UNKNOWN_BUF && type < XFS_BLFT_MAX_BUF);
-	blf->blf_flags &= ~XFS_BLFT_MASK;
-	blf->blf_flags |= ((type << XFS_BLFT_SHIFT) & XFS_BLFT_MASK);
-}
-
-static inline __uint16_t
-xfs_blft_from_flags(struct xfs_buf_log_format *blf)
-{
-	return (blf->blf_flags & XFS_BLFT_MASK) >> XFS_BLFT_SHIFT;
-}
-
-/*
- * buf log item flags
- */
-#define	XFS_BLI_HOLD		0x01
-#define	XFS_BLI_DIRTY		0x02
-#define	XFS_BLI_STALE		0x04
-#define	XFS_BLI_LOGGED		0x08
-#define	XFS_BLI_INODE_ALLOC_BUF	0x10
-#define XFS_BLI_STALE_INODE	0x20
-#define	XFS_BLI_INODE_BUF	0x40
-#define	XFS_BLI_ORDERED		0x80
-
-#define XFS_BLI_FLAGS \
-	{ XFS_BLI_HOLD,		"HOLD" }, \
-	{ XFS_BLI_DIRTY,	"DIRTY" }, \
-	{ XFS_BLI_STALE,	"STALE" }, \
-	{ XFS_BLI_LOGGED,	"LOGGED" }, \
-	{ XFS_BLI_INODE_ALLOC_BUF, "INODE_ALLOC" }, \
-	{ XFS_BLI_STALE_INODE,	"STALE_INODE" }, \
-	{ XFS_BLI_INODE_BUF,	"INODE_BUF" }, \
-	{ XFS_BLI_ORDERED,	"ORDERED" }
-
-
-#ifdef __KERNEL__
-
-struct xfs_buf;
-struct xfs_mount;
-struct xfs_buf_log_item;
-
-/*
- * This is the in core log item structure used to track information
- * needed to log buffers.  It tracks how many times the lock has been
- * locked, and which 128 byte chunks of the buffer are dirty.
- */
-typedef struct xfs_buf_log_item {
-	xfs_log_item_t		bli_item;	/* common item structure */
-	struct xfs_buf		*bli_buf;	/* real buffer pointer */
-	unsigned int		bli_flags;	/* misc flags */
-	unsigned int		bli_recur;	/* lock recursion count */
-	atomic_t		bli_refcount;	/* cnt of tp refs */
-	int			bli_format_count;	/* count of headers */
-	struct xfs_buf_log_format *bli_formats;	/* array of in-log header ptrs */
-	struct xfs_buf_log_format __bli_format;	/* embedded in-log header */
-} xfs_buf_log_item_t;
-
-void	xfs_buf_item_init(struct xfs_buf *, struct xfs_mount *);
-void	xfs_buf_item_relse(struct xfs_buf *);
-void	xfs_buf_item_log(xfs_buf_log_item_t *, uint, uint);
-uint	xfs_buf_item_dirty(xfs_buf_log_item_t *);
-void	xfs_buf_attach_iodone(struct xfs_buf *,
-			      void(*)(struct xfs_buf *, xfs_log_item_t *),
-			      xfs_log_item_t *);
-void	xfs_buf_iodone_callbacks(struct xfs_buf *);
-void	xfs_buf_iodone(struct xfs_buf *, struct xfs_log_item *);
-
-void	xfs_trans_buf_set_type(struct xfs_trans *, struct xfs_buf *,
-			       enum xfs_blft);
-void	xfs_trans_buf_copy_type(struct xfs_buf *dst_bp, struct xfs_buf *src_bp);
-
-#endif	/* __KERNEL__ */
-
-#endif	/* __XFS_BUF_ITEM_H__ */
diff --git a/include/xfs_buf_item_format.h b/include/xfs_buf_item_format.h
new file mode 100644
index 0000000..e2e9474
--- /dev/null
+++ b/include/xfs_buf_item_format.h
@@ -0,0 +1,111 @@
+/*
+ * Copyright (c) 2000-2001,2005 Silicon Graphics, Inc.
+ * All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+#ifndef	__XFS_BUF_ITEM_FORMAT_H__
+#define	__XFS_BUF_ITEM_FORMAT_H__
+
+/*
+ * This flag indicates that the buffer contains on disk inodes
+ * and requires special recovery handling.
+ */
+#define	XFS_BLF_INODE_BUF	(1<<0)
+/*
+ * This flag indicates that the buffer should not be replayed
+ * during recovery because its blocks are being freed.
+ */
+#define	XFS_BLF_CANCEL		(1<<1)
+
+/*
+ * This flag indicates that the buffer contains on disk
+ * user or group dquots and may require special recovery handling.
+ */
+#define	XFS_BLF_UDQUOT_BUF	(1<<2)
+#define XFS_BLF_PDQUOT_BUF	(1<<3)
+#define	XFS_BLF_GDQUOT_BUF	(1<<4)
+
+#define	XFS_BLF_CHUNK		128
+#define	XFS_BLF_SHIFT		7
+#define	BIT_TO_WORD_SHIFT	5
+#define	NBWORD			(NBBY * sizeof(unsigned int))
+
+/*
+ * This is the structure used to lay out a buf log item in the
+ * log.  The data map describes which 128 byte chunks of the buffer
+ * have been logged.
+ */
+#define XFS_BLF_DATAMAP_SIZE	((XFS_MAX_BLOCKSIZE / XFS_BLF_CHUNK) / NBWORD)
+
+typedef struct xfs_buf_log_format {
+	unsigned short	blf_type;	/* buf log item type indicator */
+	unsigned short	blf_size;	/* size of this item */
+	ushort		blf_flags;	/* misc state */
+	ushort		blf_len;	/* number of blocks in this buf */
+	__int64_t	blf_blkno;	/* starting blkno of this buf */
+	unsigned int	blf_map_size;	/* used size of data bitmap in words */
+	unsigned int	blf_data_map[XFS_BLF_DATAMAP_SIZE]; /* dirty bitmap */
+} xfs_buf_log_format_t;
+
+/*
+ * All buffers now need to tell recovery where the magic number
+ * is so that it can verify and calculate the CRCs on the buffer correctly
+ * once the changes have been replayed into the buffer.
+ *
+ * The type value is held in the upper 5 bits of the blf_flags field, which is
+ * an unsigned 16 bit field. Hence we need to shift it 11 bits up and down.
+ */
+#define XFS_BLFT_BITS	5
+#define XFS_BLFT_SHIFT	11
+#define XFS_BLFT_MASK	(((1 << XFS_BLFT_BITS) - 1) << XFS_BLFT_SHIFT)
+
+enum xfs_blft {
+	XFS_BLFT_UNKNOWN_BUF = 0,
+	XFS_BLFT_UDQUOT_BUF,
+	XFS_BLFT_PDQUOT_BUF,
+	XFS_BLFT_GDQUOT_BUF,
+	XFS_BLFT_BTREE_BUF,
+	XFS_BLFT_AGF_BUF,
+	XFS_BLFT_AGFL_BUF,
+	XFS_BLFT_AGI_BUF,
+	XFS_BLFT_DINO_BUF,
+	XFS_BLFT_SYMLINK_BUF,
+	XFS_BLFT_DIR_BLOCK_BUF,
+	XFS_BLFT_DIR_DATA_BUF,
+	XFS_BLFT_DIR_FREE_BUF,
+	XFS_BLFT_DIR_LEAF1_BUF,
+	XFS_BLFT_DIR_LEAFN_BUF,
+	XFS_BLFT_DA_NODE_BUF,
+	XFS_BLFT_ATTR_LEAF_BUF,
+	XFS_BLFT_ATTR_RMT_BUF,
+	XFS_BLFT_SB_BUF,
+	XFS_BLFT_MAX_BUF = (1 << XFS_BLFT_BITS),
+};
+
+static inline void
+xfs_blft_to_flags(struct xfs_buf_log_format *blf, enum xfs_blft type)
+{
+	ASSERT(type > XFS_BLFT_UNKNOWN_BUF && type < XFS_BLFT_MAX_BUF);
+	blf->blf_flags &= ~XFS_BLFT_MASK;
+	blf->blf_flags |= ((type << XFS_BLFT_SHIFT) & XFS_BLFT_MASK);
+}
+
+static inline __uint16_t
+xfs_blft_from_flags(struct xfs_buf_log_format *blf)
+{
+	return (blf->blf_flags & XFS_BLFT_MASK) >> XFS_BLFT_SHIFT;
+}
+
+#endif	/* __XFS_BUF_ITEM_FORMAT_H__ */
-- 
1.7.10.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
