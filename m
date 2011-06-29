Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5TE3gKL104892 for <xfs@oss.sgi.com>; Wed, 29 Jun 2011 09:03:43 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 42C77409ED
	for <xfs@oss.sgi.com>; Wed, 29 Jun 2011 07:03:42 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	t3viMJZqtjaSeOLE for <xfs@oss.sgi.com>;
	Wed, 29 Jun 2011 07:03:42 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1QbvMj-0008Nq-PW
	for xfs@oss.sgi.com; Wed, 29 Jun 2011 14:03:41 +0000
Message-Id: <20110629140341.756763307@bombadil.infradead.org>
Date: Wed, 29 Jun 2011 10:01:36 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 27/27] xfs: avoid a few disk cache flushes
References: <20110629140109.003209430@bombadil.infradead.org>
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

Index: xfs/fs/xfs/xfs_log.c
===================================================================
--- xfs.orig/fs/xfs/xfs_log.c	2011-06-29 14:27:59.166808258 +0200
+++ xfs/fs/xfs/xfs_log.c	2011-06-29 14:30:22.779363576 +0200
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
