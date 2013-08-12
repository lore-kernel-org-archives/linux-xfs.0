Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 9659A7F3F
	for <xfs@oss.sgi.com>; Mon, 12 Aug 2013 05:50:43 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 813EE304039
	for <xfs@oss.sgi.com>; Mon, 12 Aug 2013 03:50:43 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	nTb6ipq8o0Us6BNB for <xfs@oss.sgi.com>;
	Mon, 12 Aug 2013 03:50:40 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1V8phW-0004XW-N9
	for xfs@oss.sgi.com; Mon, 12 Aug 2013 20:50:14 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1V8phW-00060b-MH
	for xfs@oss.sgi.com; Mon, 12 Aug 2013 20:50:14 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: ***** SUSPECTED SPAM ***** [PATCH 03/50] xfs: split out buf log item
	format definitions
Date: Mon, 12 Aug 2013 20:49:24 +1000
Message-Id: <1376304611-22994-4-git-send-email-david@fromorbit.com>
In-Reply-To: <1376304611-22994-1-git-send-email-david@fromorbit.com>
References: <1376304611-22994-1-git-send-email-david@fromorbit.com>
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
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_buf_item.h   | 100 ++----------------------------------------------
 fs/xfs/xfs_log_format.h |  97 ++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 100 insertions(+), 97 deletions(-)

diff --git a/fs/xfs/xfs_buf_item.h b/fs/xfs/xfs_buf_item.h
index 0f1c247..db63710 100644
--- a/fs/xfs/xfs_buf_item.h
+++ b/fs/xfs/xfs_buf_item.h
@@ -18,101 +18,9 @@
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
+/* kernel only definitions */
 
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
+/* buf log item flags */
 #define	XFS_BLI_HOLD		0x01
 #define	XFS_BLI_DIRTY		0x02
 #define	XFS_BLI_STALE		0x04
@@ -133,8 +41,6 @@ xfs_blft_from_flags(struct xfs_buf_log_format *blf)
 	{ XFS_BLI_ORDERED,	"ORDERED" }
 
 
-#ifdef __KERNEL__
-
 struct xfs_buf;
 struct xfs_mount;
 struct xfs_buf_log_item;
@@ -169,6 +75,6 @@ void	xfs_trans_buf_set_type(struct xfs_trans *, struct xfs_buf *,
 			       enum xfs_blft);
 void	xfs_trans_buf_copy_type(struct xfs_buf *dst_bp, struct xfs_buf *src_bp);
 
-#endif	/* __KERNEL__ */
+extern kmem_zone_t	*xfs_buf_item_zone;
 
 #endif	/* __XFS_BUF_ITEM_H__ */
diff --git a/fs/xfs/xfs_log_format.h b/fs/xfs/xfs_log_format.h
index fd46a7f..77a6024 100644
--- a/fs/xfs/xfs_log_format.h
+++ b/fs/xfs/xfs_log_format.h
@@ -364,4 +364,101 @@ static inline uint xfs_icdinode_size(int version)
 		return sizeof(struct xfs_icdinode);
 	return offsetof(struct xfs_icdinode, di_next_unlinked);
 }
+
+/*
+ * Buffer Log Format defintions
+ *
+ * These are the physical dirty bitmap defintions for the log format structure.
+ */
+#define	XFS_BLF_CHUNK		128
+#define	XFS_BLF_SHIFT		7
+#define	BIT_TO_WORD_SHIFT	5
+#define	NBWORD			(NBBY * sizeof(unsigned int))
+
+/*
+ * This flag indicates that the buffer contains on disk inodes
+ * and requires special recovery handling.
+ */
+#define	XFS_BLF_INODE_BUF	(1<<0)
+
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
 #endif /* __XFS_LOG_FORMAT_H__ */
-- 
1.8.3.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
