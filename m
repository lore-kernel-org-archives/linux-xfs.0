Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nACJ9Ds2015595 for <xfs@oss.sgi.com>; Thu, 12 Nov 2009 13:09:14 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 41B87D1DCC8
	for <xfs@oss.sgi.com>; Thu, 12 Nov 2009 11:09:33 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id t7yHJ8UZ23YNmfb5 for
	<xfs@oss.sgi.com>; Thu, 12 Nov 2009 11:09:33 -0800 (PST)
Date: Thu, 12 Nov 2009 14:09:31 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] xfs: improve metadata I/O merging in the elevator
Message-ID: <20091112190930.GB32110@infradead.org>
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

I had the patch below from Dave in my queue for a while, but previously
couldn't really reproduce his numbers.  After some discussions of the
bio types I've reteseted it again and can see constant improvements when
using cfq on my large array box with it (5-10% for the sequential create
workloads), but still nothing on deadline.  Given that people also want
it for better marking in blktrace it might be time to put it in.

Comments?

-- 

From: Dave Chinner <dgc@sgi.com>
Subject: xfs: improve metadata I/O merging in the elevator

Change all async metadata buffers to use [READ|WRITE]_META I/O types
so that the I/O doesn't get issued immediately. This allows merging
of adjacent metadata requests but still prioritises them over bulk
data. This shows a 10-15% improvement in sequential create speed of
small files.

Don't include the log buffers in this classification - leave them
as sync types so they are issued immediately.

Signed-off-by: Dave Chinner <dgc@sgi.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/linux-2.6/xfs_buf.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_buf.c	2009-11-12 17:10:19.852253847 +0100
+++ xfs/fs/xfs/linux-2.6/xfs_buf.c	2009-11-12 17:13:55.334003777 +0100
@@ -1177,10 +1177,14 @@ _xfs_buf_ioapply(
 	if (bp->b_flags & XBF_ORDERED) {
 		ASSERT(!(bp->b_flags & XBF_READ));
 		rw = WRITE_BARRIER;
-	} else if (bp->b_flags & _XBF_RUN_QUEUES) {
+	} else if (bp->b_flags & XBF_LOG_BUFFER) {
 		ASSERT(!(bp->b_flags & XBF_READ_AHEAD));
 		bp->b_flags &= ~_XBF_RUN_QUEUES;
 		rw = (bp->b_flags & XBF_WRITE) ? WRITE_SYNC : READ_SYNC;
+	} else if (bp->b_flags & _XBF_RUN_QUEUES) {
+		ASSERT(!(bp->b_flags & XBF_READ_AHEAD));
+		bp->b_flags &= ~_XBF_RUN_QUEUES;
+		rw = (bp->b_flags & XBF_WRITE) ? WRITE : READ_META;
 	} else {
 		rw = (bp->b_flags & XBF_WRITE) ? WRITE :
 		     (bp->b_flags & XBF_READ_AHEAD) ? READA : READ;
Index: xfs/fs/xfs/linux-2.6/xfs_buf.h
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_buf.h	2009-11-12 17:10:19.857278370 +0100
+++ xfs/fs/xfs/linux-2.6/xfs_buf.h	2009-11-12 17:13:55.334003777 +0100
@@ -55,6 +55,7 @@ typedef enum {
 	XBF_FS_MANAGED = (1 << 8),  /* filesystem controls freeing memory  */
  	XBF_ORDERED = (1 << 11),    /* use ordered writes		   */
 	XBF_READ_AHEAD = (1 << 12), /* asynchronous read-ahead		   */
+	XBF_LOG_BUFFER = (1 << 13), /* this is a buffer used for the log   */
 
 	/* flags used only as arguments to access routines */
 	XBF_LOCK = (1 << 14),       /* lock requested			   */
Index: xfs/fs/xfs/xfs_log.c
===================================================================
--- xfs.orig/fs/xfs/xfs_log.c	2009-11-12 17:10:20.267254560 +0100
+++ xfs/fs/xfs/xfs_log.c	2009-11-12 17:13:55.335004184 +0100
@@ -1524,6 +1524,7 @@ xlog_sync(xlog_t		*log,
 	XFS_BUF_ZEROFLAGS(bp);
 	XFS_BUF_BUSY(bp);
 	XFS_BUF_ASYNC(bp);
+	bp->b_flags |= XBF_LOG_BUFFER;
 	/*
 	 * Do an ordered write for the log block.
 	 * Its unnecessary to flush the first split block in the log wrap case.
@@ -1561,6 +1562,7 @@ xlog_sync(xlog_t		*log,
 		XFS_BUF_ZEROFLAGS(bp);
 		XFS_BUF_BUSY(bp);
 		XFS_BUF_ASYNC(bp);
+		bp->b_flags |= XBF_LOG_BUFFER;
 		if (log->l_mp->m_flags & XFS_MOUNT_BARRIER)
 			XFS_BUF_ORDERED(bp);
 		dptr = XFS_BUF_PTR(bp);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
