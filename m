Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 05FF329E06
	for <xfs@oss.sgi.com>; Tue, 21 Jan 2014 16:46:26 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id BBBC0304048
	for <xfs@oss.sgi.com>; Tue, 21 Jan 2014 14:46:25 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id En28vBrRAAXvifHG for <xfs@oss.sgi.com>;
	Tue, 21 Jan 2014 14:46:24 -0800 (PST)
Message-ID: <52DEF8BF.5070106@sandeen.net>
Date: Tue, 21 Jan 2014 16:46:23 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH 3/3 V3] xfs: allow logical-sector sized O_DIRECT
References: <52DEF81D.4090100@redhat.com>
In-Reply-To: <52DEF81D.4090100@redhat.com>
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

Some time ago, mkfs.xfs started picking the storage physical
sector size as the default filesystem "sector size" in order
to avoid RMW costs incurred by doing IOs at logical sector
size alignments.

However, this means that for a filesystem made with i.e.
a 4k sector size on an "advanced format" 4k/512 disk,
512-byte direct IOs are no longer allowed.  This means
that XFS has essentially turned this AF drive into a hard
4K device, from the filesystem on up.

XFS's mkfs-specified "sector size" is really just controlling
the minimum size & alignment of filesystem metadata.

There is no real need to tightly couple XFS's minimal
metadata size to the minimum allowed direct IO size;
XFS can continue doing metadata in optimal sizes, but
still allow smaller DIOs for apps which issue them,
for whatever reason.

This patch adds a new field to the xfs_buftarg, so that
we now track 2 sizes:

 1) The metadata sector size, which is the minimum unit and
    alignment of IO which will be performed by metadata operations.
 2) The device logical sector size

The first is used internally by the file system for metadata
alignment and IOs.
The second is used for the minimum allowed direct IO alignment.

This has passed xfstests on filesystems made with 4k sectors,
including when run under the patch I sent to ignore
XFS_IOC_DIOINFO, and issue 512 DIOs anyway.  I also directly
tested end of block behavior on preallocated, sparse, and
existing files when we do a 512 IO into a 4k file on a 
4k-sector filesystem, to be sure there were no unexpected
behaviors.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index a526f8d..5175711 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1599,6 +1599,7 @@ xfs_setsize_buftarg(
 	unsigned int		blocksize,
 	unsigned int		sectorsize)
 {
+	/* Set up metadata sector size info */
 	btp->bt_meta_sectorsize = sectorsize;
 	btp->bt_meta_sectormask = sectorsize - 1;
 
@@ -1613,6 +1614,10 @@ xfs_setsize_buftarg(
 		return EINVAL;
 	}
 
+	/* Set up device logical sector size mask */
+	btp->bt_logical_sectorsize = bdev_logical_block_size(btp->bt_bdev);
+	btp->bt_logical_sectormask = bdev_logical_block_size(btp->bt_bdev) - 1;
+
 	return 0;
 }
 
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index d5d88dd..9953395 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -88,6 +88,19 @@ typedef unsigned int xfs_buf_flags_t;
  */
 #define XFS_BSTATE_DISPOSE	 (1 << 0)	/* buffer being discarded */
 
+/*
+ * The xfs_buftarg contains 2 notions of "sector size" -
+ *
+ * 1) The metadata sector size, which is the minimum unit and
+ *    alignment of IO which will be performed by metadata operations.
+ * 2) The device logical sector size
+ *
+ * The first is specified at mkfs time, and is stored on-disk in the
+ * superblock's sb_sectsize.
+ *
+ * The latter is derived from the underlying device, and controls direct IO
+ * alignment constraints.
+ */
 typedef struct xfs_buftarg {
 	dev_t			bt_dev;
 	struct block_device	*bt_bdev;
@@ -95,6 +108,8 @@ typedef struct xfs_buftarg {
 	struct xfs_mount	*bt_mount;
 	unsigned int		bt_meta_sectorsize;
 	size_t			bt_meta_sectormask;
+	size_t			bt_logical_sectorsize;
+	size_t			bt_logical_sectormask;
 
 	/* LRU control structures */
 	struct shrinker		bt_shrinker;
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index ef0c933..57725b4 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -261,7 +261,8 @@ xfs_file_aio_read(
 		xfs_buftarg_t	*target =
 			XFS_IS_REALTIME_INODE(ip) ?
 				mp->m_rtdev_targp : mp->m_ddev_targp;
-		if ((pos | size) & target->bt_meta_sectormask) {
+		/* DIO must be aligned to device logical sector size */
+		if ((pos | size) & target->bt_logical_sectormask) {
 			if (pos == i_size_read(inode))
 				return 0;
 			return -XFS_ERROR(EINVAL);
@@ -641,9 +642,11 @@ xfs_file_dio_aio_write(
 	struct xfs_buftarg	*target = XFS_IS_REALTIME_INODE(ip) ?
 					mp->m_rtdev_targp : mp->m_ddev_targp;
 
-	if ((pos | count) & target->bt_meta_sectormask)
+	/* DIO must be aligned to device logical sector size */
+	if ((pos | count) & target->bt_logical_sectormask)
 		return -XFS_ERROR(EINVAL);
 
+	/* "unaligned" here means not aligned to a filesystem block */
 	if ((pos & mp->m_blockmask) || ((pos + count) & mp->m_blockmask))
 		unaligned_io = 1;
 
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 64ca8e9..f7ac335 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1587,7 +1587,7 @@ xfs_file_ioctl(
 			XFS_IS_REALTIME_INODE(ip) ?
 			mp->m_rtdev_targp : mp->m_ddev_targp;
 
-		da.d_mem = da.d_miniosz = target->bt_meta_sectorsize;
+		da.d_mem =  da.d_miniosz = target->bt_logical_sectorsize;
 		da.d_maxiosz = INT_MAX & ~(da.d_miniosz - 1);
 
 		if (copy_to_user(arg, &da, sizeof(da)))

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
