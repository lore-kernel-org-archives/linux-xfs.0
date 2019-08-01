Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:32911 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728880AbfHACSH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 31 Jul 2019 22:18:07 -0400
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 10/24] xfs: fix missed wakeup on l_flush_wait
Date: Thu,  1 Aug 2019 12:17:38 +1000
Message-Id: <20190801021752.4986-11-david@fromorbit.com>
In-Reply-To: <20190801021752.4986-1-david@fromorbit.com>
References: <20190801021752.4986-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org

From: Rik van Riel <riel@surriel.com>

The code in xlog_wait uses the spinlock to make adding the task to
the wait queue, and setting the task state to UNINTERRUPTIBLE atomic
with respect to the waker.

Doing the wakeup after releasing the spinlock opens up the following
race condition:

Task 1					task 2
add task to wait queue
					wake up task
set task state to UNINTERRUPTIBLE

This issue was found through code inspection as a result of kworkers
being observed stuck in UNINTERRUPTIBLE state with an empty
wait queue. It is rare and largely unreproducable.

Simply moving the spin_unlock to after the wake_up_all results
in the waker not being able to see a task on the waitqueue before
it has set its state to UNINTERRUPTIBLE.

This bug dates back to the conversion of this code to generic
waitqueue infrastructure from a counting semaphore back in 2008
which didn't place the wakeups consistently w.r.t. to the relevant
spin locks.

[dchinner: Also fix a similar issue in the shutdown path on
xc_commit_wait. Update commit log with more details of the issue.]

Fixes: d748c62367eb ("[XFS] Convert l_flushsema to a sv_t")
Reported-by: Chris Mason <clm@fb.com>
Signed-off-by: Rik van Riel <riel@surriel.com>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_log.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 7bdea629e749..b78c5e95bbba 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -2630,7 +2630,6 @@ xlog_state_do_callback(
 	int		   funcdidcallbacks; /* flag: function did callbacks */
 	int		   repeats;	/* for issuing console warnings if
 					 * looping too many times */
-	int		   wake = 0;
 
 	spin_lock(&log->l_icloglock);
 	first_iclog = iclog = log->l_iclog;
@@ -2826,11 +2825,9 @@ xlog_state_do_callback(
 #endif
 
 	if (log->l_iclog->ic_state & (XLOG_STATE_ACTIVE|XLOG_STATE_IOERROR))
-		wake = 1;
-	spin_unlock(&log->l_icloglock);
-
-	if (wake)
 		wake_up_all(&log->l_flush_wait);
+
+	spin_unlock(&log->l_icloglock);
 }
 
 
@@ -3930,7 +3927,9 @@ xfs_log_force_umount(
 	 * item committed callback functions will do this again under lock to
 	 * avoid races.
 	 */
+	spin_lock(&log->l_cilp->xc_push_lock);
 	wake_up_all(&log->l_cilp->xc_commit_wait);
+	spin_unlock(&log->l_cilp->xc_push_lock);
 	xlog_state_do_callback(log, true, NULL);
 
 #ifdef XFSERRORDEBUG
-- 
2.22.0
