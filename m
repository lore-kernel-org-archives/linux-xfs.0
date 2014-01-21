Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id BEE5E29DF8
	for <xfs@oss.sgi.com>; Tue, 21 Jan 2014 16:45:02 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 1EA28AC004
	for <xfs@oss.sgi.com>; Tue, 21 Jan 2014 14:44:58 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id STufCGqWOa0aDtIL for <xfs@oss.sgi.com>;
	Tue, 21 Jan 2014 14:44:57 -0800 (PST)
Message-ID: <52DEF869.6040107@sandeen.net>
Date: Tue, 21 Jan 2014 16:44:57 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH 1/3 V3] xfs: clean up xfs_buftarg
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

Clean up the xfs_buftarg structure a bit:
- remove bt_bsize which is never used
- replace bt_sshift with bt_ssize; we only ever shift it back

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 9fccfb5..b664bce 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -445,7 +445,7 @@ _xfs_buf_find(
 	numbytes = BBTOB(numblks);
 
 	/* Check for IOs smaller than the sector size / not sector aligned */
-	ASSERT(!(numbytes < (1 << btp->bt_sshift)));
+	ASSERT(!(numbytes < btp->bt_ssize));
 	ASSERT(!(BBTOB(blkno) & (xfs_off_t)btp->bt_smask));
 
 	/*
@@ -1599,8 +1599,7 @@ xfs_setsize_buftarg(
 	unsigned int		blocksize,
 	unsigned int		sectorsize)
 {
-	btp->bt_bsize = blocksize;
-	btp->bt_sshift = ffs(sectorsize) - 1;
+	btp->bt_ssize = sectorsize;
 	btp->bt_smask = sectorsize - 1;
 
 	if (set_blocksize(btp->bt_bdev, sectorsize)) {
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index 1cf21a4..4ef949a 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -93,8 +93,7 @@ typedef struct xfs_buftarg {
 	struct block_device	*bt_bdev;
 	struct backing_dev_info	*bt_bdi;
 	struct xfs_mount	*bt_mount;
-	unsigned int		bt_bsize;
-	unsigned int		bt_sshift;
+	unsigned int		bt_ssize;
 	size_t			bt_smask;
 
 	/* LRU control structures */
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 33ad9a7..39c38ee 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1587,7 +1587,7 @@ xfs_file_ioctl(
 			XFS_IS_REALTIME_INODE(ip) ?
 			mp->m_rtdev_targp : mp->m_ddev_targp;
 
-		da.d_mem = da.d_miniosz = 1 << target->bt_sshift;
+		da.d_mem = da.d_miniosz = target->bt_ssize;
 		da.d_maxiosz = INT_MAX & ~(da.d_miniosz - 1);
 
 		if (copy_to_user(arg, &da, sizeof(da)))

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
