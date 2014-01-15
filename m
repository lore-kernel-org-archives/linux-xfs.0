Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B28F029DF8
	for <xfs@oss.sgi.com>; Wed, 15 Jan 2014 11:59:46 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 9A2A68F8035
	for <xfs@oss.sgi.com>; Wed, 15 Jan 2014 09:59:46 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id S0tEmvoCc92xG7JV for
	<xfs@oss.sgi.com>; Wed, 15 Jan 2014 09:59:45 -0800 (PST)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s0FHxjOC003064
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Wed, 15 Jan 2014 12:59:45 -0500
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com
	[10.5.9.1])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id s0FHxhAs014285
	(version=TLSv1/SSLv3 cipher=DHE-RSA-CAMELLIA256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Wed, 15 Jan 2014 12:59:44 -0500
Message-ID: <52D6CC91.6000408@redhat.com>
Date: Wed, 15 Jan 2014 11:59:45 -0600
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH] xfs: allow logical-sector sized O_DIRECT for any fs sector
	size
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
To: xfs-oss <xfs@oss.sgi.com>

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
the minimum size & alignment of filesystem metadata IO.

There is no real need to tightly couple XFS's minimal
metadata size to the minimum allowed direct IO size;
XFS can continue doing metadata in optimal sizes, but
still allow smaller DIOs for apps which issue them,
for whatever reason.

This patch adds 2 new fields to the xfs_buftarg, so that
we now track 3 sizes:

 1) The device logical sector size
 2) The device physical sector size
 3) The filesystem sector size, which is the minimum unit and
    alignment of IO which will be performed by metadata operations.

The first is used for the minimum allowed direct IO alignment,
the 2nd is used to report DIO sizes in XFS_IOC_DIOINFO
(the theory being, if an app actually asks, we can give them
the optimal answer, even if we allow smaller IOs), and the
3rd is used internally by the filesystem for metadata IOs.

This has passed xfstests on filesystems made with 4k sectors,
including when run under the patch I sent to ignore
XFS_IOC_DIOINFO, and issue 512 DIOs anyway.  I also directly
tested end of block behavior on preallocated, sparse, and
existing files when we do a 512 IO into a 4k file on a 
4k-sector filesystem, to be sure there were no unexpected
behaviors.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

NB: This depends on this patch which is in the xfs tree,
but not yet upstream:
 xfs: simplify xfs_setsize_buftarg callchain; remove unused arg



diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 9fccfb5..a89dcdf 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1599,6 +1599,7 @@ xfs_setsize_buftarg(
 	unsigned int		blocksize,
 	unsigned int		sectorsize)
 {
+	/* Set up filesystem block and sector sizes */
 	btp->bt_bsize = blocksize;
 	btp->bt_sshift = ffs(sectorsize) - 1;
 	btp->bt_smask = sectorsize - 1;
@@ -1614,6 +1615,9 @@ xfs_setsize_buftarg(
 		return EINVAL;
 	}
 
+	/* Set up device logical & physical sector size info */
+	btp->bt_lsmask = bdev_logical_block_size(btp->bt_bdev) - 1;
+	btp->bt_pssize = bdev_physical_block_size(btp->bt_bdev);
 	return 0;
 }
 
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index 1cf21a4..29a0db9 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -88,14 +88,28 @@ typedef unsigned int xfs_buf_flags_t;
  */
 #define XFS_BSTATE_DISPOSE	 (1 << 0)	/* buffer being discarded */
 
+/*
+ * The xfs_buftarg contains 3 notions of "sector size" -
+ *
+ * 1) The device logical sector size
+ * 2) The device physical sector size
+ * 3) The filesystem sector size, which is the minimum unit and
+ *    alignment of IO which will be performed by metadata operations.
+ *
+ * The latter is specified at mkfs time, stored on-disk in the
+ * superblock's sb_sectsize, and is set from there.
+ */
+
 typedef struct xfs_buftarg {
 	dev_t			bt_dev;
 	struct block_device	*bt_bdev;
 	struct backing_dev_info	*bt_bdi;
 	struct xfs_mount	*bt_mount;
-	unsigned int		bt_bsize;
-	unsigned int		bt_sshift;
-	size_t			bt_smask;
+	unsigned int		bt_bsize;	/* fs block size */
+	unsigned int		bt_sshift;	/* fs sector size shift */
+	size_t			bt_smask;	/* fs sector size mask */
+	size_t			bt_lsmask;	/* dev logical sectsz mask */
+	unsigned int		bt_pssize;	/* dev physical sector size */
 
 	/* LRU control structures */
 	struct shrinker		bt_shrinker;
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 52c91e1..09f9df9 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -261,7 +261,8 @@ xfs_file_aio_read(
 		xfs_buftarg_t	*target =
 			XFS_IS_REALTIME_INODE(ip) ?
 				mp->m_rtdev_targp : mp->m_ddev_targp;
-		if ((pos & target->bt_smask) || (size & target->bt_smask)) {
+		/* DIO must be aligned to device logical sector size */
+		if ((pos & target->bt_lsmask) || (size & target->bt_lsmask)) {
 			if (pos == i_size_read(inode))
 				return 0;
 			return -XFS_ERROR(EINVAL);
@@ -641,9 +642,11 @@ xfs_file_dio_aio_write(
 	struct xfs_buftarg	*target = XFS_IS_REALTIME_INODE(ip) ?
 					mp->m_rtdev_targp : mp->m_ddev_targp;
 
-	if ((pos & target->bt_smask) || (count & target->bt_smask))
+	/* DIO must be aligned to device logical sector size */
+	if ((pos & target->bt_lsmask) || (count & target->bt_lsmask))
 		return -XFS_ERROR(EINVAL);
 
+	/* "unaligned" here means not aligned to a filesystem block */
 	if ((pos & mp->m_blockmask) || ((pos + count) & mp->m_blockmask))
 		unaligned_io = 1;
 
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 33ad9a7..1f3431f 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1587,7 +1587,12 @@ xfs_file_ioctl(
 			XFS_IS_REALTIME_INODE(ip) ?
 			mp->m_rtdev_targp : mp->m_ddev_targp;
 
-		da.d_mem = da.d_miniosz = 1 << target->bt_sshift;
+		/*
+		 * Report device physical sector size as "optimal" minimum,
+		 * unless blocksize is smaller than that.
+		 */
+		da.d_miniosz = min(target->bt_pssize, target->bt_bsize);
+		da.d_mem = da.d_miniosz;
 		da.d_maxiosz = INT_MAX & ~(da.d_miniosz - 1);
 
 		if (copy_to_user(arg, &da, sizeof(da)))

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
