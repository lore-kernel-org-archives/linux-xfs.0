Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3O6XxPx031600 for <xfs@oss.sgi.com>; Tue, 24 Apr 2012 01:33:59 -0500
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	q1oGaPIFfZ3nFCnS for <xfs@oss.sgi.com>;
	Mon, 23 Apr 2012 23:33:57 -0700 (PDT)
Received: from [192.168.1.1] (helo=disappointment)
	by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1SMZJy-0004Nc-EO
	for xfs@oss.sgi.com; Tue, 24 Apr 2012 16:33:54 +1000
Received: from dave by disappointment with local (Exim 4.77)
	(envelope-from <dave@disappointment.disaster>) id 1SMZJo-0005tK-C4
	for xfs@oss.sgi.com; Tue, 24 Apr 2012 16:33:44 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 06/10] xfs: struct xfs_buf_log_format isn't variable sized.
Date: Tue, 24 Apr 2012 16:33:36 +1000
Message-Id: <1335249220-22274-7-git-send-email-david@fromorbit.com>
In-Reply-To: <1335249220-22274-1-git-send-email-david@fromorbit.com>
References: <1335249220-22274-1-git-send-email-david@fromorbit.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

The struct xfs_buf_log_format wants to think the dirty bitmap is
variable sized.  In fact, it is variable size on disk simply due to
the way we map it from the in-memory structure, but we still just
use a fixed size memory allocation for the in-memory structure.

Hence it makes no sense to set the function up as a variable sized
structure when we already know it's maximum size, and we always
allocate it as such. Simplify the structure by making the dirty
bitmap a fixed sized array and just using the size of the structure
for the allocation size.

This will make it much simpler to allocate and manipulate an array
of format structures for discontiguous buffer support.

The previous struct xfs_buf_log_item size according to
/proc/slabinfo was 224 bytes. pahole doesn't give the same size
because of the variable size definition. With this modification,
pahole reports the same as /proc/slabinfo:

	/* size: 224, cachelines: 4, members: 6 */

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_alloc_btree.h |   14 --------------
 fs/xfs/xfs_buf_item.h    |   36 ++++++++++++++++++------------------
 fs/xfs/xfs_super.c       |    5 ++---
 fs/xfs/xfs_types.h       |   14 ++++++++++++++
 4 files changed, 34 insertions(+), 35 deletions(-)

diff --git a/fs/xfs/xfs_alloc_btree.h b/fs/xfs/xfs_alloc_btree.h
index a6caa00..359fb86 100644
--- a/fs/xfs/xfs_alloc_btree.h
+++ b/fs/xfs/xfs_alloc_btree.h
@@ -51,20 +51,6 @@ typedef struct xfs_alloc_rec_incore {
 typedef __be32 xfs_alloc_ptr_t;
 
 /*
- * Minimum and maximum blocksize and sectorsize.
- * The blocksize upper limit is pretty much arbitrary.
- * The sectorsize upper limit is due to sizeof(sb_sectsize).
- */
-#define XFS_MIN_BLOCKSIZE_LOG	9	/* i.e. 512 bytes */
-#define XFS_MAX_BLOCKSIZE_LOG	16	/* i.e. 65536 bytes */
-#define XFS_MIN_BLOCKSIZE	(1 << XFS_MIN_BLOCKSIZE_LOG)
-#define XFS_MAX_BLOCKSIZE	(1 << XFS_MAX_BLOCKSIZE_LOG)
-#define XFS_MIN_SECTORSIZE_LOG	9	/* i.e. 512 bytes */
-#define XFS_MAX_SECTORSIZE_LOG	15	/* i.e. 32768 bytes */
-#define XFS_MIN_SECTORSIZE	(1 << XFS_MIN_SECTORSIZE_LOG)
-#define XFS_MAX_SECTORSIZE	(1 << XFS_MAX_SECTORSIZE_LOG)
-
-/*
  * Block numbers in the AG:
  * SB is sector 0, AGF is sector 1, AGI is sector 2, AGFL is sector 3.
  */
diff --git a/fs/xfs/xfs_buf_item.h b/fs/xfs/xfs_buf_item.h
index b6ecd20..ff26867 100644
--- a/fs/xfs/xfs_buf_item.h
+++ b/fs/xfs/xfs_buf_item.h
@@ -21,23 +21,6 @@
 extern kmem_zone_t	*xfs_buf_item_zone;
 
 /*
- * This is the structure used to lay out a buf log item in the
- * log.  The data map describes which 128 byte chunks of the buffer
- * have been logged.
- * For 6.2 and beyond, this is XFS_LI_BUF.  We use this to log everything.
- */
-typedef struct xfs_buf_log_format {
-	unsigned short	blf_type;	/* buf log item type indicator */
-	unsigned short	blf_size;	/* size of this item */
-	ushort		blf_flags;	/* misc state */
-	ushort		blf_len;	/* number of blocks in this buf */
-	__int64_t	blf_blkno;	/* starting blkno of this buf */
-	unsigned int	blf_map_size;	/* size of data bitmap in words */
-	unsigned int	blf_data_map[1];/* variable size bitmap of */
-					/*   regions of buffer in this item */
-} xfs_buf_log_format_t;
-
-/*
  * This flag indicates that the buffer contains on disk inodes
  * and requires special recovery handling.
  */
@@ -61,6 +44,23 @@ typedef struct xfs_buf_log_format {
 #define	NBWORD			(NBBY * sizeof(unsigned int))
 
 /*
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
  * buf log item flags
  */
 #define	XFS_BLI_HOLD		0x01
@@ -102,7 +102,7 @@ typedef struct xfs_buf_log_item {
 	char			*bli_orig;	/* original buffer copy */
 	char			*bli_logged;	/* bytes logged (bitmap) */
 #endif
-	xfs_buf_log_format_t	bli_format;	/* in-log header */
+	struct xfs_buf_log_format bli_format;	/* embedded in-log header */
 } xfs_buf_log_item_t;
 
 void	xfs_buf_item_init(struct xfs_buf *, struct xfs_mount *);
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 36528d2..65b51d2 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1514,9 +1514,8 @@ xfs_init_zones(void)
 	 * size possible under XFS.  This wastes a little bit of memory,
 	 * but it is much faster.
 	 */
-	xfs_buf_item_zone = kmem_zone_init((sizeof(xfs_buf_log_item_t) +
-				(((XFS_MAX_BLOCKSIZE / XFS_BLF_CHUNK) /
-				  NBWORD) * sizeof(int))), "xfs_buf_item");
+	xfs_buf_item_zone = kmem_zone_init(sizeof(struct xfs_buf_log_item),
+					   "xfs_buf_item");
 	if (!xfs_buf_item_zone)
 		goto out_destroy_log_item_desc_zone;
 
diff --git a/fs/xfs/xfs_types.h b/fs/xfs/xfs_types.h
index 398cf68..7a41874 100644
--- a/fs/xfs/xfs_types.h
+++ b/fs/xfs/xfs_types.h
@@ -133,6 +133,20 @@ typedef __uint64_t	xfs_filblks_t;	/* number of blocks in a file */
 #define	MAXAEXTNUM	((xfs_aextnum_t)0x7fff)		/* signed short */
 
 /*
+ * Minimum and maximum blocksize and sectorsize.
+ * The blocksize upper limit is pretty much arbitrary.
+ * The sectorsize upper limit is due to sizeof(sb_sectsize).
+ */
+#define XFS_MIN_BLOCKSIZE_LOG	9	/* i.e. 512 bytes */
+#define XFS_MAX_BLOCKSIZE_LOG	16	/* i.e. 65536 bytes */
+#define XFS_MIN_BLOCKSIZE	(1 << XFS_MIN_BLOCKSIZE_LOG)
+#define XFS_MAX_BLOCKSIZE	(1 << XFS_MAX_BLOCKSIZE_LOG)
+#define XFS_MIN_SECTORSIZE_LOG	9	/* i.e. 512 bytes */
+#define XFS_MAX_SECTORSIZE_LOG	15	/* i.e. 32768 bytes */
+#define XFS_MIN_SECTORSIZE	(1 << XFS_MIN_SECTORSIZE_LOG)
+#define XFS_MAX_SECTORSIZE	(1 << XFS_MAX_SECTORSIZE_LOG)
+
+/*
  * Min numbers of data/attr fork btree root pointers.
  */
 #define MINDBTPTRS	3
-- 
1.7.9.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
