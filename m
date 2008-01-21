Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 20 Jan 2008 20:16:43 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m0L4GanS005344
	for <xfs@oss.sgi.com>; Sun, 20 Jan 2008 20:16:39 -0800
Date: Mon, 21 Jan 2008 15:16:49 +1100
From: David Chinner <dgc@sgi.com>
Subject: [patch] reduce log I/O latency V2
Message-ID: <20080121041649.GA155259@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-dev <xfs-dev@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>

Reduce log I/O latency

To ensure that log I/O is issued as the highest priority I/O, set
the I/O priority of the log I/O to the highest possible. This will
ensure that log I/O is not held up behind bulk data or other
metadata I/O as delaying log I/O can pause the entire transaction
subsystem. Introduce a new buffer flag to allow us to tag the log
buffers so we can discriminate when issuing the I/O.

Version 2:
- don't use realtime priority class

Signed-off-by: Dave Chinner <dgc@sgi.com>
---
 fs/xfs/linux-2.6/xfs_buf.c |    3 +++
 fs/xfs/linux-2.6/xfs_buf.h |    5 ++++-
 fs/xfs/xfs_log.c           |    2 ++
 3 files changed, 9 insertions(+), 1 deletion(-)

Index: 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_buf.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/linux-2.6/xfs_buf.c	2007-12-19 01:39:42.286538135 +1100
+++ 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_buf.c	2007-12-19 11:56:47.977477993 +1100
@@ -1198,6 +1198,9 @@ next_chunk:
 
 submit_io:
 	if (likely(bio->bi_size)) {
+		/* log I/O should not be delayed by anything except realtime. */
+		if (bp->b_flags & XBF_LOG_BUFFER)
+			bio_set_prio(bio, IOPRIO_PRIO_VALUE(IOPRIO_CLASS_BE, 0));
 		submit_bio(rw, bio);
 		if (size)
 			goto next_chunk;
Index: 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_buf.h
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/linux-2.6/xfs_buf.h	2007-12-19 01:11:16.871181483 +1100
+++ 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_buf.h	2007-12-19 11:55:09.642183801 +1100
@@ -53,7 +53,8 @@ typedef enum {
 	XBF_DELWRI = (1 << 6),  /* buffer has dirty pages                  */
 	XBF_STALE = (1 << 7),	/* buffer has been staled, do not find it  */
 	XBF_FS_MANAGED = (1 << 8),  /* filesystem controls freeing memory  */
- 	XBF_ORDERED = (1 << 11),    /* use ordered writes		   */
+	XBF_LOG_BUFFER = (1 << 9),  /* Buffer issued by the log		   */
+	XBF_ORDERED = (1 << 11),    /* use ordered writes		   */
 	XBF_READ_AHEAD = (1 << 12), /* asynchronous read-ahead		   */
 
 	/* flags used only as arguments to access routines */
@@ -339,6 +340,8 @@ extern void xfs_buf_trace(xfs_buf_t *, c
 #define XFS_BUF_TARGET(bp)		((bp)->b_target)
 #define XFS_BUFTARG_NAME(target)	xfs_buf_target_name(target)
 
+#define XFS_BUF_SET_LOGBUF(bp)	((bp)->b_flags |= XBF_LOG_BUFFER)
+
 static inline int xfs_bawrite(void *mp, xfs_buf_t *bp)
 {
 	bp->b_fspriv3 = mp;
Index: 2.6.x-xfs-new/fs/xfs/xfs_log.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_log.c	2007-12-19 01:11:16.871181483 +1100
+++ 2.6.x-xfs-new/fs/xfs/xfs_log.c	2007-12-19 11:55:09.698176566 +1100
@@ -1443,6 +1443,8 @@ xlog_sync(xlog_t		*log,
 	XFS_BUF_ZEROFLAGS(bp);
 	XFS_BUF_BUSY(bp);
 	XFS_BUF_ASYNC(bp);
+	XFS_BUF_SET_LOGBUF(bp);
+
 	/*
 	 * Do an ordered write for the log block.
 	 * Its unnecessary to flush the first split block in the log wrap case.
