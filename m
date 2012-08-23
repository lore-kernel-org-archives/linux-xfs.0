Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7N52eXw134591 for <xfs@oss.sgi.com>; Thu, 23 Aug 2012 00:02:40 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	gqr2xCTIlEUPX8hu for <xfs@oss.sgi.com>;
	Wed, 22 Aug 2012 22:03:26 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1T4PZk-0003EF-NF
	for xfs@oss.sgi.com; Thu, 23 Aug 2012 15:03:24 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1T4PZa-0003bd-Kv
	for xfs@oss.sgi.com; Thu, 23 Aug 2012 15:03:14 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 006/102] xfs: improve ioend error handling
Date: Thu, 23 Aug 2012 15:01:24 +1000
Message-Id: <1345698180-13612-7-git-send-email-david@fromorbit.com>
In-Reply-To: <1345698180-13612-1-git-send-email-david@fromorbit.com>
References: <1345698180-13612-1-git-send-email-david@fromorbit.com>
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

From: Christoph Hellwig <hch@infradead.org>

Upstream commit: 04f658ee229f60dbb9a0dc2f3d6871b12b758051

Return unwritten extent conversion errors to aio_complete.

Skip both unwritten extent conversion and size updates if we had an
I/O error or the filesystem has been shut down.

Return -EIO to the aio/buffer completion handlers in case of a
forced shutdown.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Alex Elder <aelder@sgi.com>
---
 fs/xfs/linux-2.6/xfs_aops.c |   27 +++++++++++++++++----------
 1 file changed, 17 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_aops.c b/fs/xfs/linux-2.6/xfs_aops.c
index 20f356d..f16207b 100644
--- a/fs/xfs/linux-2.6/xfs_aops.c
+++ b/fs/xfs/linux-2.6/xfs_aops.c
@@ -123,8 +123,10 @@ xfs_destroy_ioend(
 	}
 
 	if (ioend->io_iocb) {
-		if (ioend->io_isasync)
-			aio_complete(ioend->io_iocb, ioend->io_result, 0);
+		if (ioend->io_isasync) {
+			aio_complete(ioend->io_iocb, ioend->io_error ?
+					ioend->io_error : ioend->io_result, 0);
+		}
 	}
 	xfs_ioend_wake(ip);
 	mempool_free(ioend, xfs_ioend_pool);
@@ -175,9 +177,6 @@ xfs_setfilesize(
 	xfs_inode_t		*ip = XFS_I(ioend->io_inode);
 	xfs_fsize_t		isize;
 
-	if (unlikely(ioend->io_error))
-		return 0;
-
 	if (!xfs_ilock_nowait(ip, XFS_ILOCK_EXCL))
 		return EAGAIN;
 
@@ -222,17 +221,24 @@ xfs_end_io(
 	struct xfs_inode *ip = XFS_I(ioend->io_inode);
 	int		error = 0;
 
+	if (XFS_FORCED_SHUTDOWN(ip->i_mount)) {
+		error = -EIO;
+		goto done;
+	}
+	if (ioend->io_error)
+		goto done;
+
 	/*
 	 * For unwritten extents we need to issue transactions to convert a
 	 * range to normal written extens after the data I/O has finished.
 	 */
-	if (ioend->io_type == IO_UNWRITTEN &&
-	    likely(!ioend->io_error && !XFS_FORCED_SHUTDOWN(ip->i_mount))) {
-
+	if (ioend->io_type == IO_UNWRITTEN) {
 		error = xfs_iomap_write_unwritten(ip, ioend->io_offset,
 						 ioend->io_size);
-		if (error)
-			ioend->io_error = error;
+		if (error) {
+			ioend->io_error = -error;
+			goto done;
+		}
 	}
 
 	/*
@@ -242,6 +248,7 @@ xfs_end_io(
 	error = xfs_setfilesize(ioend);
 	ASSERT(!error || error == EAGAIN);
 
+done:
 	/*
 	 * If we didn't complete processing of the ioend, requeue it to the
 	 * tail of the workqueue for another attempt later. Otherwise destroy
-- 
1.7.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
