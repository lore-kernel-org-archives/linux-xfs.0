Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 2FA947F67
	for <xfs@oss.sgi.com>; Thu, 28 May 2015 18:46:14 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 1F07E304053
	for <xfs@oss.sgi.com>; Thu, 28 May 2015 16:46:14 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	Haz2TkGpgMzf1er0 for <xfs@oss.sgi.com>;
	Thu, 28 May 2015 16:46:12 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1Yy7Uy-0006cu-Bw
	for xfs@oss.sgi.com; Fri, 29 May 2015 09:46:04 +1000
Received: from dave by disappointment with local (Exim 4.82_1-5b7a7c0-XX)
	(envelope-from <dave@disappointment.disaster>) id 1Yy7Uy-00024k-Ai
	for xfs@oss.sgi.com; Fri, 29 May 2015 09:46:04 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 7/8] xfs: add DAX IO path support
Date: Fri, 29 May 2015 09:45:54 +1000
Message-Id: <1432856755-7859-8-git-send-email-david@fromorbit.com>
In-Reply-To: <1432856755-7859-1-git-send-email-david@fromorbit.com>
References: <1432856755-7859-1-git-send-email-david@fromorbit.com>
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

DAX does not do buffered IO (can't buffer direct access!) and hence
all read/write IO is vectored through the direct IO path.  Hence we
need to add the DAX IO path callouts to the direct IO
infrastructure.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/xfs_aops.c | 36 +++++++++++++++++++++++++++---------
 1 file changed, 27 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 1d195e8..e5e9fc2 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -1657,6 +1657,29 @@ xfs_end_io_dax_write(
 void xfs_end_io_dax_write(struct buffer_head *bh, int uptodate) { }
 #endif
 
+static inline ssize_t
+xfs_vm_do_dio(
+	struct inode		*inode,
+	struct kiocb		*iocb,
+	struct iov_iter		*iter,
+	loff_t			offset,
+	void			(*endio)(struct kiocb	*iocb,
+					 loff_t		offset,
+					 ssize_t	size,
+					 void		*private),
+	int			flags)
+{
+	struct block_device	*bdev;
+
+	if (IS_DAX(inode))
+		return dax_do_io(iocb, inode, iter, offset,
+				 xfs_get_blocks_direct, endio, 0);
+
+	bdev = xfs_find_bdev_for_inode(inode);
+	return  __blockdev_direct_IO(iocb, inode, bdev, iter, offset,
+				     xfs_get_blocks_direct, endio, NULL, flags);
+}
+
 STATIC ssize_t
 xfs_vm_direct_IO(
 	struct kiocb		*iocb,
@@ -1664,16 +1687,11 @@ xfs_vm_direct_IO(
 	loff_t			offset)
 {
 	struct inode		*inode = iocb->ki_filp->f_mapping->host;
-	struct block_device	*bdev = xfs_find_bdev_for_inode(inode);
 
-	if (iov_iter_rw(iter) == WRITE) {
-		return __blockdev_direct_IO(iocb, inode, bdev, iter, offset,
-					    xfs_get_blocks_direct,
-					    xfs_end_io_direct_write, NULL,
-					    DIO_ASYNC_EXTEND);
-	}
-	return __blockdev_direct_IO(iocb, inode, bdev, iter, offset,
-				    xfs_get_blocks_direct, NULL, NULL, 0);
+	if (iov_iter_rw(iter) == WRITE)
+		return xfs_vm_do_dio(inode, iocb, iter, offset,
+				     xfs_end_io_direct_write, DIO_ASYNC_EXTEND);
+	return xfs_vm_do_dio(inode, iocb, iter, offset, NULL, 0);
 }
 
 /*
-- 
2.0.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
