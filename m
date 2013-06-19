Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 9A8F929E65
	for <xfs@oss.sgi.com>; Tue, 18 Jun 2013 23:52:21 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 69C2D304043
	for <xfs@oss.sgi.com>; Tue, 18 Jun 2013 21:52:21 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	l1Xqz0VOFrOIetmJ for <xfs@oss.sgi.com>;
	Tue, 18 Jun 2013 21:52:19 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1UpANV-0002zs-LD
	for xfs@oss.sgi.com; Wed, 19 Jun 2013 14:52:17 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1UpANV-00005u-I4
	for xfs@oss.sgi.com; Wed, 19 Jun 2013 14:52:17 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 31/60] xfs: split out buf log item format definitions
Date: Wed, 19 Jun 2013 14:50:39 +1000
Message-Id: <1371617468-32559-32-git-send-email-david@fromorbit.com>
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

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_buf_item.h        |  100 ++-----------------------------------
 fs/xfs/xfs_buf_item_format.h |  111 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 115 insertions(+), 96 deletions(-)
 create mode 100644 fs/xfs/xfs_buf_item_format.h

diff --git a/fs/xfs/xfs_buf_item.h b/fs/xfs/xfs_buf_item.h
index 0f1c247..97cbb01 100644
--- a/fs/xfs/xfs_buf_item.h
+++ b/fs/xfs/xfs_buf_item.h
@@ -18,101 +18,11 @@
 #ifndef	__XFS_BUF_ITEM_H__
 #define	__XFS_BUF_ITEM_H__
 
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
+#include "xfs_buf_item_format.h"
 
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
+/* kernel only definitions */
 
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
+/* buf log item flags */
 #define	XFS_BLI_HOLD		0x01
 #define	XFS_BLI_DIRTY		0x02
 #define	XFS_BLI_STALE		0x04
@@ -133,8 +43,6 @@ xfs_blft_from_flags(struct xfs_buf_log_format *blf)
 	{ XFS_BLI_ORDERED,	"ORDERED" }
 
 
-#ifdef __KERNEL__
-
 struct xfs_buf;
 struct xfs_mount;
 struct xfs_buf_log_item;
@@ -169,6 +77,6 @@ void	xfs_trans_buf_set_type(struct xfs_trans *, struct xfs_buf *,
 			       enum xfs_blft);
 void	xfs_trans_buf_copy_type(struct xfs_buf *dst_bp, struct xfs_buf *src_bp);
 
-#endif	/* __KERNEL__ */
+extern kmem_zone_t	*xfs_buf_item_zone;
 
 #endif	/* __XFS_BUF_ITEM_H__ */
diff --git a/fs/xfs/xfs_buf_item_format.h b/fs/xfs/xfs_buf_item_format.h
new file mode 100644
index 0000000..e2e9474
--- /dev/null
+++ b/fs/xfs/xfs_buf_item_format.h
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
