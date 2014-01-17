Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 4A0367F52
	for <xfs@oss.sgi.com>; Fri, 17 Jan 2014 14:26:16 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id B2C2DAC005
	for <xfs@oss.sgi.com>; Fri, 17 Jan 2014 12:26:15 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id RwJTQioaXVUaPiW3 for <xfs@oss.sgi.com>;
	Fri, 17 Jan 2014 12:26:14 -0800 (PST)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 2363163BEBCB
	for <xfs@oss.sgi.com>; Fri, 17 Jan 2014 14:26:14 -0600 (CST)
Message-ID: <52D991E5.1010300@sandeen.net>
Date: Fri, 17 Jan 2014 14:26:13 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH 2/3] xfs: rename xfs_buftarg structure members
References: <52D6CC91.6000408@redhat.com> <52D9910C.9000205@sandeen.net>
In-Reply-To: <52D9910C.9000205@sandeen.net>
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

In preparation for adding new members to the xfs_buftarg
structure, give these old ones more descriptive names:

	bt_ssize -> bt_meta_sectorsize
	bt_smask -> bt_meta_sectormask

(Note the slight change in logic format in xfs_file_aio_read(()
and xfs_file_dio_aio_write(); this was done just for formatting,
and should not change actual logic or behavior.)

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index b664bce..a526f8d 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -445,8 +445,8 @@ _xfs_buf_find(
 	numbytes = BBTOB(numblks);
 
 	/* Check for IOs smaller than the sector size / not sector aligned */
-	ASSERT(!(numbytes < btp->bt_ssize));
-	ASSERT(!(BBTOB(blkno) & (xfs_off_t)btp->bt_smask));
+	ASSERT(!(numbytes < btp->bt_meta_sectorsize));
+	ASSERT(!(BBTOB(blkno) & (xfs_off_t)btp->bt_meta_sectormask));
 
 	/*
 	 * Corrupted block numbers can get through to here, unfortunately, so we
@@ -1599,8 +1599,8 @@ xfs_setsize_buftarg(
 	unsigned int		blocksize,
 	unsigned int		sectorsize)
 {
-	btp->bt_ssize = sectorsize;
-	btp->bt_smask = sectorsize - 1;
+	btp->bt_meta_sectorsize = sectorsize;
+	btp->bt_meta_sectormask = sectorsize - 1;
 
 	if (set_blocksize(btp->bt_bdev, sectorsize)) {
 		char name[BDEVNAME_SIZE];
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index 4ef949a..d5d88dd 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -93,8 +93,8 @@ typedef struct xfs_buftarg {
 	struct block_device	*bt_bdev;
 	struct backing_dev_info	*bt_bdi;
 	struct xfs_mount	*bt_mount;
-	unsigned int		bt_ssize;
-	size_t			bt_smask;
+	unsigned int		bt_meta_sectorsize;
+	size_t			bt_meta_sectormask;
 
 	/* LRU control structures */
 	struct shrinker		bt_shrinker;
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 52c91e1..61a7de0 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -261,7 +261,7 @@ xfs_file_aio_read(
 		xfs_buftarg_t	*target =
 			XFS_IS_REALTIME_INODE(ip) ?
 				mp->m_rtdev_targp : mp->m_ddev_targp;
-		if ((pos & target->bt_smask) || (size & target->bt_smask)) {
+		if ((pos || size) & target->bt_meta_sectormask) {
 			if (pos == i_size_read(inode))
 				return 0;
 			return -XFS_ERROR(EINVAL);
@@ -641,7 +641,7 @@ xfs_file_dio_aio_write(
 	struct xfs_buftarg	*target = XFS_IS_REALTIME_INODE(ip) ?
 					mp->m_rtdev_targp : mp->m_ddev_targp;
 
-	if ((pos & target->bt_smask) || (count & target->bt_smask))
+	if ((pos || count) & target->bt_meta_sectormask)
 		return -XFS_ERROR(EINVAL);
 
 	if ((pos & mp->m_blockmask) || ((pos + count) & mp->m_blockmask))
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 39c38ee..64ca8e9 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1587,7 +1587,7 @@ xfs_file_ioctl(
 			XFS_IS_REALTIME_INODE(ip) ?
 			mp->m_rtdev_targp : mp->m_ddev_targp;
 
-		da.d_mem = da.d_miniosz = target->bt_ssize;
+		da.d_mem = da.d_miniosz = target->bt_meta_sectorsize;
 		da.d_maxiosz = INT_MAX & ~(da.d_miniosz - 1);
 
 		if (copy_to_user(arg, &da, sizeof(da)))


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
