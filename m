Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o2CAw8s3245560 for <xfs@oss.sgi.com>; Fri, 12 Mar 2010 04:58:08 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EF8F31D2F674
	for <xfs@oss.sgi.com>; Fri, 12 Mar 2010 02:59:40 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 4wHmJ4WkoKBmeLmj for
	<xfs@oss.sgi.com>; Fri, 12 Mar 2010 02:59:40 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1Nq2ai-0002Ig-Lr
	for xfs@oss.sgi.com; Fri, 12 Mar 2010 10:59:40 +0000
Date: Fri, 12 Mar 2010 05:59:40 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 2/2] xfs: enforce synchronous writes in xfs_bwrite
Message-ID: <20100312105940.GB8643@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

xfs_bwrite is used with the intention of synchronously writing out buffers,
but currently it does not actually clear the async flag if that's left
from previous writes but instead implements async behaviour if it finds it.
Remove the code handling asynchronous writes as we've got rid of those
entirely outside of the log and delwri buffers, and make sure that we
clear the async and read flags before writing the buffer.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/linux-2.6/xfs_buf.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_buf.c	2010-03-11 11:42:41.596003157 +0100
+++ xfs/fs/xfs/linux-2.6/xfs_buf.c	2010-03-11 11:44:34.473008395 +0100
@@ -1056,25 +1056,20 @@ xfs_bwrite(
 	struct xfs_mount	*mp,
 	struct xfs_buf		*bp)
 {
-	int			iowait = (bp->b_flags & XBF_ASYNC) == 0;
-	int			error = 0;
+	int			error;
 
 	bp->b_strat = xfs_bdstrat_cb;
 	bp->b_mount = mp;
 	bp->b_flags |= XBF_WRITE;
-	if (!iowait)
-		bp->b_flags |= _XBF_RUN_QUEUES;
+	bp->b_flags &= ~(XBF_ASYNC | XBF_READ);
 
 	xfs_buf_delwri_dequeue(bp);
 	xfs_buf_iostrategy(bp);
 
-	if (iowait) {
-		error = xfs_buf_iowait(bp);
-		if (error)
-			xfs_force_shutdown(mp, SHUTDOWN_META_IO_ERROR);
-		xfs_buf_relse(bp);
-	}
-
+	error = xfs_buf_iowait(bp);
+	if (error)
+		xfs_force_shutdown(mp, SHUTDOWN_META_IO_ERROR);
+	xfs_buf_relse(bp);
 	return error;
 }
 
Index: xfs/fs/xfs/linux-2.6/xfs_sync.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_sync.c	2010-03-11 11:44:58.473010700 +0100
+++ xfs/fs/xfs/linux-2.6/xfs_sync.c	2010-03-11 11:45:03.199256475 +0100
@@ -364,7 +364,6 @@ xfs_sync_fsdata(
 	if (XFS_BUF_ISPINNED(bp))
 		xfs_log_force(mp, 0);
 
-	XFS_BUF_UNASYNC(bp);
 	return xfs_bwrite(mp, bp);
 }
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
