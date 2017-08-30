Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr0-f179.google.com ([209.85.128.179]:34820 "EHLO
        mail-wr0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751317AbdH3NiB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 30 Aug 2017 09:38:01 -0400
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH] xfs: fix incorrect log_flushed on fsync
Date: Wed, 30 Aug 2017 16:38:22 +0300
Message-Id: <1504100302-3297-1-git-send-email-amir73il@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J . Wong" <darrick.wong@oracle.com>, Christoph Hellwig <hch@lst.de>, Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, Josef Bacik <jbacik@fb.com>, stable@vger.kernel.org

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
---

Christoph, Dave,

It's hard to believe, but I think the reported bug has been around
since 2005 f538d4da8d52 ("[XFS] write barrier support"), but I did
not try to test old kernels.

I tripped over this aleged bug a week ago when I started testing
crash consistecy with dm-log-writes:
https://marc.info/?l=linux-fsdevel&m=150350333427447&w=2
Since then, I have been trying to prove that dm-log-writes was
false accusing, but turned out that it wasn't.

The reproducer is an xfstest, which I am going to re-post soon
and is also available here:
https://github.com/amir73il/xfstests/commits/dm-log-writes
On a system with spinning disk it reproduces the issue with close
100% probability within less than a minute.

Anyway, with Darrick going on vacation, let's expedite review
of this fix and try to merge some fix for v4.14-rc1 (although this
bug fix may be eligible to later rc's as well).

The change obviously changes behavior for the worse for workload
of intensive parallel fsyncing tasks, but I don't see another quick
way to fix correctness without hurting this workload.
It might be worth to get a feedback from file_write_and_wait_range(),
whether dirty pages writes have been issued at all.

I started running full xftests cycle, but wanted to send this one out
early for comments. I can test other patches if needed.

Cheers,
Amir.

 fs/xfs/xfs_log.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 0053bcf..ec159c5 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -3342,8 +3342,6 @@ _xfs_log_force(
 		 */
 		if (iclog->ic_state & XLOG_STATE_IOERROR)
 			return -EIO;
-		if (log_flushed)
-			*log_flushed = 1;
 	} else {
 
 no_sleep:
@@ -3447,8 +3445,6 @@ _xfs_log_force_lsn(
 
 				xlog_wait(&iclog->ic_prev->ic_write_wait,
 							&log->l_icloglock);
-				if (log_flushed)
-					*log_flushed = 1;
 				already_slept = 1;
 				goto try_again;
 			}
@@ -3482,9 +3478,6 @@ _xfs_log_force_lsn(
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
2.7.4

