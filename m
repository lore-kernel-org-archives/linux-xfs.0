Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 14D2A29DF8
	for <xfs@oss.sgi.com>; Mon,  5 May 2014 20:05:04 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E149D8F8035
	for <xfs@oss.sgi.com>; Mon,  5 May 2014 18:05:00 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	DKbrct0cWKAuCfQV for <xfs@oss.sgi.com>;
	Mon, 05 May 2014 18:04:55 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1WhToG-00027r-BX
	for xfs@oss.sgi.com; Tue, 06 May 2014 11:04:40 +1000
Received: from dave by disappointment with local (Exim 4.82)
	(envelope-from <dave@disappointment.disaster>) id 1WhToG-0002c7-AZ
	for xfs@oss.sgi.com; Tue, 06 May 2014 11:04:40 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH] xfs: don't sleep in xlog_cil_force_lsn on shutdown
Date: Tue,  6 May 2014 11:04:40 +1000
Message-Id: <1399338280-10013-1-git-send-email-david@fromorbit.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

Reports of a shutdown hang when fsyncing a directory have surfaced,
such as this:

[ 3663.394472] Call Trace:
[ 3663.397199]  [<ffffffff815f1889>] schedule+0x29/0x70
[ 3663.402743]  [<ffffffffa01feda5>] xlog_cil_force_lsn+0x185/0x1a0 [xfs]
[ 3663.416249]  [<ffffffffa01fd3af>] _xfs_log_force_lsn+0x6f/0x2f0 [xfs]
[ 3663.429271]  [<ffffffffa01a339d>] xfs_dir_fsync+0x7d/0xe0 [xfs]
[ 3663.435873]  [<ffffffff811df8c5>] do_fsync+0x65/0xa0
[ 3663.441408]  [<ffffffff811dfbc0>] SyS_fsync+0x10/0x20
[ 3663.447043]  [<ffffffff815fc7d9>] system_call_fastpath+0x16/0x1b

If we trigger a shutdown in xlog_cil_push() from xlog_write(), we
will never wake waiters on the current push sequence number, so
anything waiting in xlog_cil_force_lsn() for that push sequence
number to come up will not get woken and hence stall the shutdown.

Fix this by ensuring we call wake_up_all(&cil->xc_commit_wait) in
the push abort handling, in the log shutdown code when waking all
waiters, and adding a shutdown check in the sequence completion wait
loops to ensure they abort when a wakeup due to a shutdown occurs.

Reported-by: Boris Ranto <branto@redhat.com>
Reported-by: Eric Sandeen <esandeen@redhat.com>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_log.c     |  7 +++++--
 fs/xfs/xfs_log_cil.c | 50 ++++++++++++++++++++++++++++++++++++++++++--------
 2 files changed, 47 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index a5f8bd9..dbba2d7 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -3952,11 +3952,14 @@ xfs_log_force_umount(
 		retval = xlog_state_ioerror(log);
 		spin_unlock(&log->l_icloglock);
 	}
+
 	/*
-	 * Wake up everybody waiting on xfs_log_force.
-	 * Callback all log item committed functions as if the
+	 * Wake up everybody waiting on xfs_log_force. This needs to wake anyone
+	 * waiting on a CIL push that is issued as part of a log force first
+	 * before running the log item committed callback functions as if the
 	 * log writes were completed.
 	 */
+	wake_up_all(&log->l_cilp->xc_commit_wait);
 	xlog_state_do_callback(log, XFS_LI_ABORTED, NULL);
 
 #ifdef XFSERRORDEBUG
diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index 7e54553..039c873 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -385,7 +385,15 @@ xlog_cil_committed(
 	xfs_extent_busy_clear(mp, &ctx->busy_extents,
 			     (mp->m_flags & XFS_MOUNT_DISCARD) && !abort);
 
+	/*
+	 * If we are aborting the commit, wake up anyone waiting on the
+	 * committing list.  If we don't, then a shutdown we can leave processes
+	 * waiting in xlog_cil_force_lsn() waiting on a sequence commit that
+	 * will never happen because we aborted it.
+	 */
 	spin_lock(&ctx->cil->xc_push_lock);
+	if (abort)
+		wake_up_all(&ctx->cil->xc_commit_wait);
 	list_del(&ctx->committing);
 	spin_unlock(&ctx->cil->xc_push_lock);
 
@@ -564,8 +572,18 @@ restart:
 	spin_lock(&cil->xc_push_lock);
 	list_for_each_entry(new_ctx, &cil->xc_committing, committing) {
 		/*
+		 * Avoid getting stuck in this loop because we were woken by the
+		 * shutdown, but then went back to sleep once already in the
+		 * shutdown state.
+		 */
+		if (XLOG_FORCED_SHUTDOWN(log)) {
+			spin_unlock(&cil->xc_push_lock);
+			goto out_abort_free_ticket;
+		}
+
+		/*
 		 * Higher sequences will wait for this one so skip them.
-		 * Don't wait for own own sequence, either.
+		 * Don't wait for our own sequence, either.
 		 */
 		if (new_ctx->sequence >= ctx->sequence)
 			continue;
@@ -810,6 +828,13 @@ restart:
 	 */
 	spin_lock(&cil->xc_push_lock);
 	list_for_each_entry(ctx, &cil->xc_committing, committing) {
+		/*
+		 * Avoid getting stuck in this loop because we were woken by the
+		 * shutdown, but then went back to sleep once already in the
+		 * shutdown state.
+		 */
+		if (XLOG_FORCED_SHUTDOWN(log))
+			goto out_shutdown;
 		if (ctx->sequence > sequence)
 			continue;
 		if (!ctx->commit_lsn) {
@@ -833,14 +858,12 @@ restart:
 	 * push sequence after the above wait loop and the CIL still contains
 	 * dirty objects.
 	 *
-	 * When the push occurs, it will empty the CIL and
-	 * atomically increment the currect sequence past the push sequence and
-	 * move it into the committing list. Of course, if the CIL is clean at
-	 * the time of the push, it won't have pushed the CIL at all, so in that
-	 * case we should try the push for this sequence again from the start
-	 * just in case.
+	 * When the push occurs, it will empty the CIL and atomically increment
+	 * the currect sequence past the push sequence and move it into the
+	 * committing list. Of course, if the CIL is clean at the time of the
+	 * push, it won't have pushed the CIL at all, so in that case we should
+	 * try the push for this sequence again from the start just in case.
 	 */
-
 	if (sequence == cil->xc_current_sequence &&
 	    !list_empty(&cil->xc_cil)) {
 		spin_unlock(&cil->xc_push_lock);
@@ -849,6 +872,17 @@ restart:
 
 	spin_unlock(&cil->xc_push_lock);
 	return commit_lsn;
+
+	/*
+	 * We detected a shutdown in progress. We need to trigger the log force
+	 * to pass through it's iclog state machine error handling, even though
+	 * we are already in a shutdown state. Hence we can't return
+	 * NULLCOMMITLSN here as that has special meaning to log forces (i.e.
+	 * LSN is already stable), so we return a zero LSN instead.
+	 */
+out_shutdown:
+	spin_unlock(&cil->xc_push_lock);
+	return 0;
 }
 
 /*
-- 
1.9.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
