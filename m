Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id AC63F7F4E
	for <xfs@oss.sgi.com>; Mon,  8 Sep 2014 20:43:27 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 2CCF3AC001
	for <xfs@oss.sgi.com>; Mon,  8 Sep 2014 18:43:23 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	V61rOizSW5KIJVkj for <xfs@oss.sgi.com>;
	Mon, 08 Sep 2014 18:43:18 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1XRASh-0003E4-21
	for xfs@oss.sgi.com; Tue, 09 Sep 2014 11:43:15 +1000
Received: from dave by disappointment with local (Exim 4.82_1-5b7a7c0-XX)
	(envelope-from <dave@disappointment.disaster>) id 1XRASh-000464-0g
	for xfs@oss.sgi.com; Tue, 09 Sep 2014 11:43:15 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH] xfs: xlog_cil_force_lsn doesn't always wait correctly
Date: Tue,  9 Sep 2014 11:43:15 +1000
Message-Id: <1410226995-15714-1-git-send-email-david@fromorbit.com>
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

When running a tight mount/unmount loop on an older kernel, RedHat
QE found that unmount would occasionally hang in
xfs_buf_unpin_wait() on the superblock buffer. Tracing and other
debug work by Eric Sandeen indicated that it was hanging on the
writing of the superblock during unmount immediately after logging
the superblock counters in a synchronous transaction. Further debug
indicated that the synchronous transaction was not waiting for
completion correctly, and we narrowed it down to
xlog_cil_force_lsn() returning NULLCOMMITLSN and hence not pushing
the transaction in the iclog buffer to disk correctly.

While this unmount superblock write code is now very different in
mainline kernels, the xlog_cil_force_lsn() code is identical, and it
was bisected to the backport of commit f876e44 ("xfs: always do log
forces via the workqueue"). This commit made the CIL push
asynchronous for log forces and hence exposed a race condition that
couldn't occur on a synchronous push.

Essentially, the xlog_cil_force_lsn() relied implicitly on the fact
that the sequence push would be complete by the time
xlog_cil_push_now() returned, resulting in the context being pushed
being in the committing list. When it was made asynchronous, it was
recognised that there was a race condition in detecting whether an
asynchronous push has started or not and code was added to handle
it.

Unfortunately, the fix was not quite right and left a race condition
where it it would detect an empty CIL while a push was in progress
before the context had been added to the committing list. This was
incorrectly seen as a "nothing to do" condition and so would tell
xfs_log_force_lsn() that there is nothing to wait for, and hence it
would push the iclogbufs in memory.

The fix is simple, but explaining the logic and the race condition
is a lot more complex. The fix is to add the context to the
committing list before we start emptying the CIL. This allows us to
detect the difference between an empty "do nothing" push and a push
that has not started by adding a discrete "emptying the CIL" state
to avoid the transient, incorrect "empty" condition that the
(unchanged) waiting code was seeing.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Tested-by: Eric Sandeen <esandeen@redhat.com>
---
 fs/xfs/xfs_log_cil.c | 47 ++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 38 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index f6b79e5..f506c45 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -463,12 +463,40 @@ xlog_cil_push(
 		spin_unlock(&cil->xc_push_lock);
 		goto out_skip;
 	}
-	spin_unlock(&cil->xc_push_lock);
 
 
 	/* check for a previously pushed seqeunce */
-	if (push_seq < cil->xc_ctx->sequence)
+	if (push_seq < cil->xc_ctx->sequence) {
+		spin_unlock(&cil->xc_push_lock);
 		goto out_skip;
+	}
+
+	/*
+	 * We are now going to push this context, so add it to the committing
+	 * list before we do anything else. This ensures that anyone waiting on
+	 * this push can easily detect the difference between a "push in
+	 * progress" and "CIL is empty, nothing to do".
+	 *
+	 * IOWs, a wait loop can now check for:
+	 *	the current sequence not being found on the committing list;
+	 *	an empty CIL; and
+	 *	an unchanged sequence number
+	 * to detect a push that had nothing to do and therefore does not need
+	 * waiting on. If the CIL is not empty, we get put on the committing
+	 * list before emptying the CIL and bumping the sequence number. Hence
+	 * an empty CIL and an unchanged sequence number means we jumped out
+	 * above after doing nothing.
+	 *
+	 * Hence the waiter will either find the commit sequence on the
+	 * committing list or the sequence number will be unchanged and the CIL
+	 * still dirty. In that latter case, the push has not yet started, and
+	 * so the waiter will have to continue trying to check the CIL
+	 * committing list until it is found. In extreme cases of delay, the
+	 * sequence may fully commit between the attempts the wait makes to wait
+	 * on the commit sequence.
+	 */
+	list_add(&ctx->committing, &cil->xc_committing);
+	spin_unlock(&cil->xc_push_lock);
 
 	/*
 	 * pull all the log vectors off the items in the CIL, and
@@ -532,7 +560,6 @@ xlog_cil_push(
 	 */
 	spin_lock(&cil->xc_push_lock);
 	cil->xc_current_sequence = new_ctx->sequence;
-	list_add(&ctx->committing, &cil->xc_committing);
 	spin_unlock(&cil->xc_push_lock);
 	up_write(&cil->xc_ctx_lock);
 
@@ -855,13 +882,15 @@ restart:
 	 * Hence by the time we have got here it our sequence may not have been
 	 * pushed yet. This is true if the current sequence still matches the
 	 * push sequence after the above wait loop and the CIL still contains
-	 * dirty objects.
+	 * dirty objects. This is guaranteed by the push code first adding the
+	 * context to the committing list before emptying the CIL.
 	 *
-	 * When the push occurs, it will empty the CIL and atomically increment
-	 * the currect sequence past the push sequence and move it into the
-	 * committing list. Of course, if the CIL is clean at the time of the
-	 * push, it won't have pushed the CIL at all, so in that case we should
-	 * try the push for this sequence again from the start just in case.
+	 * Hence if we don't find the context in the committing list and the
+	 * current sequence number is unchanged then the CIL contents are
+	 * significant.  If the CIL is empty, if means there was nothing to push
+	 * and that means there is nothing to wait for. If the CIL is not empty,
+	 * it means we haven't yet started the push, because if it had started
+	 * we would have found the context on the committing list.
 	 */
 	if (sequence == cil->xc_current_sequence &&
 	    !list_empty(&cil->xc_cil)) {
-- 
2.0.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
