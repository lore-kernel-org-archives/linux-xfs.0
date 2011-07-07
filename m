Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p67B6lTj160030 for <xfs@oss.sgi.com>; Thu, 7 Jul 2011 06:06:48 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E052615ECDB0
	for <xfs@oss.sgi.com>; Thu,  7 Jul 2011 04:06:46 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	vaANtCb4zlA1IrxG for <xfs@oss.sgi.com>;
	Thu, 07 Jul 2011 04:06:46 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1QemPu-00043f-34
	for xfs@oss.sgi.com; Thu, 07 Jul 2011 11:06:46 +0000
Message-Id: <20110707110646.058715551@bombadil.infradead.org>
Date: Thu, 07 Jul 2011 07:06:03 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 28/28] xfs: avoid a few disk cache flushes
References: <20110707110535.205001532@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-avoid-cache-flushes
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

There is no need for a pre-flush when doing writing the second part of a
split log buffer, and if we are using an external log there is no need
to do a full cache flush of the log device at all given that all writes
to it use the FUA flag.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Alex Elder <aelder@sgi.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>

Index: xfs/fs/xfs/xfs_log.c
===================================================================
--- xfs.orig/fs/xfs/xfs_log.c	2011-07-01 11:35:50.874088428 +0200
+++ xfs/fs/xfs/xfs_log.c	2011-07-01 11:35:51.287421756 +0200
@@ -1371,15 +1371,21 @@ xlog_sync(xlog_t		*log,
 	bp->b_flags |= XBF_SYNCIO;
 
 	if (log->l_mp->m_flags & XFS_MOUNT_BARRIER) {
+		bp->b_flags |= XBF_FUA;
+
 		/*
-		 * If we have an external log device, flush the data device
-		 * before flushing the log to make sure all meta data
-		 * written back from the AIL actually made it to disk
-		 * before writing out the new log tail LSN in the log buffer.
+		 * Flush the data device before flushing the log to make
+		 * sure all meta data written back from the AIL actually made
+		 * it to disk before stamping the new log tail LSN into the
+		 * log buffer.  For an external log we need to issue the
+		 * flush explicitly, and unfortunately synchronously here;
+		 * for an internal log we can simply use the block layer
+		 * state machine for preflushes.
 		 */
 		if (log->l_mp->m_logdev_targp != log->l_mp->m_ddev_targp)
 			xfs_blkdev_issue_flush(log->l_mp->m_ddev_targp);
-		bp->b_flags |= XBF_FUA | XBF_FLUSH;
+		else
+			bp->b_flags |= XBF_FLUSH;
 	}
 
 	ASSERT(XFS_BUF_ADDR(bp) <= log->l_logBBsize-1);
@@ -1414,7 +1420,7 @@ xlog_sync(xlog_t		*log,
 		XFS_BUF_ASYNC(bp);
 		bp->b_flags |= XBF_SYNCIO;
 		if (log->l_mp->m_flags & XFS_MOUNT_BARRIER)
-			bp->b_flags |= XBF_FUA | XBF_FLUSH;
+			bp->b_flags |= XBF_FUA;
 		dptr = XFS_BUF_PTR(bp);
 		/*
 		 * Bump the cycle numbers at the start of each block

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
