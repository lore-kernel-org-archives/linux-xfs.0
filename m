Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:49015 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751476AbdIQVHh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 17 Sep 2017 17:07:37 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 44/47] xfs: fix incorrect log_flushed on fsync
Date: Sun, 17 Sep 2017 14:07:09 -0700
Message-Id: <20170917210712.10804-45-hch@lst.de>
In-Reply-To: <20170917210712.10804-1-hch@lst.de>
References: <20170917210712.10804-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>, Josef Bacik <jbacik@fb.com>, "Darrick J . Wong" <darrick.wong@oracle.com>

From: Amir Goldstein <amir73il@gmail.com>

commit 47c7d0b19502583120c3f396c7559e7a77288a68 upstream.

When calling into _xfs_log_force{,_lsn}() with a pointer
to log_flushed variable, log_flushed will be set to 1 if:
1. xlog_sync() is called to flush the active log buffer
AND/OR
2. xlog_wait() is called to wait on a syncing log buffers

xfs_file_fsync() checks the value of log_flushed after
_xfs_log_force_lsn() call to optimize away an explicit
PREFLUSH request to the data block device after writing
out all the file's pages to disk.

This optimization is incorrect in the following sequence of events:

 Task A                    Task B
 -------------------------------------------------------
 xfs_file_fsync()
   _xfs_log_force_lsn()
     xlog_sync()
        [submit PREFLUSH]
                           xfs_file_fsync()
                             file_write_and_wait_range()
                               [submit WRITE X]
                               [endio  WRITE X]
                             _xfs_log_force_lsn()
                               xlog_wait()
        [endio  PREFLUSH]

The write X is not guarantied to be on persistent storage
when PREFLUSH request in completed, because write A was submitted
after the PREFLUSH request, but xfs_file_fsync() of task A will
be notified of log_flushed=1 and will skip explicit flush.

If the system crashes after fsync of task A, write X may not be
present on disk after reboot.

This bug was discovered and demonstrated using Josef Bacik's
dm-log-writes target, which can be used to record block io operations
and then replay a subset of these operations onto the target device.
The test goes something like this:
- Use fsx to execute ops of a file and record ops on log device
- Every now and then fsync the file, store md5 of file and mark
  the location in the log
- Then replay log onto device for each mark, mount fs and compare
  md5 of file to stored value

Cc: Christoph Hellwig <hch@lst.de>
Cc: Josef Bacik <jbacik@fb.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_log.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index fe5f3df8b253..33c9a3aae948 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -3337,8 +3337,6 @@ _xfs_log_force(
 		 */
 		if (iclog->ic_state & XLOG_STATE_IOERROR)
 			return -EIO;
-		if (log_flushed)
-			*log_flushed = 1;
 	} else {
 
 no_sleep:
@@ -3442,8 +3440,6 @@ _xfs_log_force_lsn(
 
 				xlog_wait(&iclog->ic_prev->ic_write_wait,
 							&log->l_icloglock);
-				if (log_flushed)
-					*log_flushed = 1;
 				already_slept = 1;
 				goto try_again;
 			}
@@ -3477,9 +3473,6 @@ _xfs_log_force_lsn(
 			 */
 			if (iclog->ic_state & XLOG_STATE_IOERROR)
 				return -EIO;
-
-			if (log_flushed)
-				*log_flushed = 1;
 		} else {		/* just return */
 			spin_unlock(&log->l_icloglock);
 		}
-- 
2.14.1

