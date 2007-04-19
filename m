Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 19 Apr 2007 00:53:49 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l3J7rifB013002
	for <xfs@oss.sgi.com>; Thu, 19 Apr 2007 00:53:46 -0700
Date: Thu, 19 Apr 2007 17:53:38 +1000
From: David Chinner <dgc@sgi.com>
Subject: review: fix use after free of log buffers on shutdown.
Message-ID: <20070419075338.GV48531920@melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-dev <xfs-dev@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>


When unmounting the filesystem we write an unmount record into the
log just before we start freeing up in memory structures.

When we wait for the unmount record to hit the disk, we don't
wait for the log buffers to be finished with, we only wait for part of
the iodone callback to be run - the bit that processes the
unmount record completion.

Hence when the unmount wakes up, it races with the remainder of the
log io completion and pretty much the first thing it does is free
the log buffers.

As a result, when iodone processing completes and we check the
buffer's async status, the buffer can already have been freed.

Luckily, all log I/O is issued asynchronously, so we don't really
need the async check and so we can avoid this use after free
easily.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group


---
 fs/xfs/xfs_log.c |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

Index: 2.6.x-xfs-new/fs/xfs/xfs_log.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_log.c	2007-04-19 17:18:14.097380099 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_log.c	2007-04-19 17:51:03.017078512 +1000
@@ -988,14 +988,16 @@ xlog_iodone(xfs_buf_t *bp)
 	} else if (iclog->ic_state & XLOG_STATE_IOERROR) {
 		aborted = XFS_LI_ABORTED;
 	}
+
+	/* log I/O is always issued ASYNC */
+	ASSERT(XFS_BUF_ISASYNC(bp));
 	xlog_state_done_syncing(iclog, aborted);
-	if (!(XFS_BUF_ISASYNC(bp))) {
-		/*
-		 * Corresponding psema() will be done in bwrite().  If we don't
-		 * vsema() here, panic.
-		 */
-		XFS_BUF_V_IODONESEMA(bp);
-	}
+	/*
+	 * do not reference the buffer (bp) here as we could race
+	 * with it being freed after writing the unmount record to the
+	 * log.
+	 */
+
 }	/* xlog_iodone */
 
 /*
