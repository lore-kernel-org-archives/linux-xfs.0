Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8OCUXdY180830 for <xfs@oss.sgi.com>; Fri, 24 Sep 2010 07:30:33 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3808099EA6
	for <xfs@oss.sgi.com>; Fri, 24 Sep 2010 05:31:26 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail18.adl2.internode.on.net
	[150.101.137.103]) by cuda.sgi.com with ESMTP id
	KxdEYgmLynZw4rv8 for <xfs@oss.sgi.com>;
	Fri, 24 Sep 2010 05:31:26 -0700 (PDT)
Received: from dastard (unverified [121.44.66.70])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	40046895-1927428
	for <xfs@oss.sgi.com>; Fri, 24 Sep 2010 22:01:25 +0930 (CST)
Received: from disturbed ([192.168.1.9]) by dastard with esmtp (Exim 4.71)
	(envelope-from <dave@fromorbit.com>) id 1Oz7Qx-0007UU-T1
	for xfs@oss.sgi.com; Fri, 24 Sep 2010 22:31:23 +1000
Received: from dave by disturbed with local (Exim 4.72)
	(envelope-from <dave@disturbed.disaster>) id 1Oz7Qt-0005zs-LK
	for xfs@oss.sgi.com; Fri, 24 Sep 2010 22:31:19 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 01/18] xfs: force background CIL push under sustained load
Date: Fri, 24 Sep 2010 22:30:59 +1000
Message-Id: <1285331476-23015-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1285331476-23015-1-git-send-email-david@fromorbit.com>
References: <1285331476-23015-1-git-send-email-david@fromorbit.com>
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

From: Dave Chinner <dchinner@redhat.com>

I have been seeing occasional pauses in transaction throughput up to
30s long under heavy parallel workloads. The only notable thing was
that the xfsaild was trying to be active during the pauses, but
making no progress. It was running exactly 20 times a second (on the
50ms no-progress backoff), and the number of pushbuf events was
constant across this time as well.  IOWs, the xfsaild appeared to be
stuck on buffers that it could not push out.

Further investigation indicated that it was trying to push out inode
buffers that were pinned and/or locked. The xfsbufd was also getting
woken at the same frequency (by the xfsaild, no doubt) to push out
delayed write buffers. The xfsbufd was not making any progress
because all the buffers in the delwri queue were pinned. This scan-
and-make-no-progress dance went one in the trace for some seconds,
before the xfssyncd came along an issued a log force, and then
things started going again.

However, I noticed something strange about the log force - there
were way too many IO's issued. 516 log buffers were written, to be
exact. That added up to 129MB of log IO, which got me very
interested because it's almost exactly 25% of the size of the log.
He delayed logging code is suppose to aggregate the minimum of 25%
of the log or 8MB worth of changes before flushing. That's what
really puzzled me - why did a log force write 129MB instead of only
8MB?

Essentially what has happened is that no CIL pushes had occurred
since the previous tail push which cleared out 25% of the log space.
That caused all the new transactions to block because there wasn't
log space for them, but they kick the xfsaild to push the tail.
However, the xfsaild was not making progress because there were
buffers it could not lock and flush, and the xfsbufd could not flush
them because they were pinned. As a result, both the xfsaild and the
xfsbufd could not move the tail of the log forward without the CIL
first committing.

The cause of the problem was that the background CIL push, which
should happen when 8MB of aggregated changes have been committed, is
being held off by the concurrent transaction commit load. The
background push does a down_write_trylock() which will fail if there
is a concurrent transaction commit holding the push lock in read
mode. With 8 CPUs all doing transactions as fast as they can, there
was enough concurrent transaction commits to hold off the background
push until tail-pushing could no longer free log space, and the halt
would occur.

It should be noted that there is no reason why it would halt at 25%
of log space used by a single CIL checkpoint. This bug could
definitely violate the "no transaction should be larger than half
the log" requirement and hence result in corruption if the system
crashed under heavy load. This sort of bug is exactly the reason why
delayed logging was tagged as experimental....

The fix is to start blocking background pushes once the threshold
has been exceeded. Rework the threshold calculations to keep the
amount of log space a CIL checkpoint can use to below that of the
AIL push threshold to avoid the problem completely.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Alex Elder <aelder@sgi.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_log_cil.c  |   12 +++++++++---
 fs/xfs/xfs_log_priv.h |   37 +++++++++++++++++++++----------------
 2 files changed, 30 insertions(+), 19 deletions(-)

diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index ed575fb..7e206fc 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -405,9 +405,15 @@ xlog_cil_push(
 	new_ctx = kmem_zalloc(sizeof(*new_ctx), KM_SLEEP|KM_NOFS);
 	new_ctx->ticket = xlog_cil_ticket_alloc(log);
 
-	/* lock out transaction commit, but don't block on background push */
+	/*
+	 * Lock out transaction commit, but don't block for background pushes
+	 * unless we are well over the CIL space limit. See the definition of
+	 * XLOG_CIL_HARD_SPACE_LIMIT() for the full explanation of the logic
+	 * used here.
+	 */
 	if (!down_write_trylock(&cil->xc_ctx_lock)) {
-		if (!push_seq)
+		if (!push_seq &&
+		    cil->xc_ctx->space_used < XLOG_CIL_HARD_SPACE_LIMIT(log))
 			goto out_free_ticket;
 		down_write(&cil->xc_ctx_lock);
 	}
@@ -422,7 +428,7 @@ xlog_cil_push(
 		goto out_skip;
 
 	/* check for a previously pushed seqeunce */
-	if (push_seq < cil->xc_ctx->sequence)
+	if (push_seq && push_seq < cil->xc_ctx->sequence)
 		goto out_skip;
 
 	/*
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index ced52b9..edcdfe0 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -426,13 +426,13 @@ struct xfs_cil {
 };
 
 /*
- * The amount of log space we should the CIL to aggregate is difficult to size.
- * Whatever we chose we have to make we can get a reservation for the log space
- * effectively, that it is large enough to capture sufficient relogging to
- * reduce log buffer IO significantly, but it is not too large for the log or
- * induces too much latency when writing out through the iclogs. We track both
- * space consumed and the number of vectors in the checkpoint context, so we
- * need to decide which to use for limiting.
+ * The amount of log space we allow the CIL to aggregate is difficult to size.
+ * Whatever we choose, we have to make sure we can get a reservation for the
+ * log space effectively, that it is large enough to capture sufficient
+ * relogging to reduce log buffer IO significantly, but it is not too large for
+ * the log or induces too much latency when writing out through the iclogs. We
+ * track both space consumed and the number of vectors in the checkpoint
+ * context, so we need to decide which to use for limiting.
  *
  * Every log buffer we write out during a push needs a header reserved, which
  * is at least one sector and more for v2 logs. Hence we need a reservation of
@@ -459,16 +459,21 @@ struct xfs_cil {
  * checkpoint transaction ticket is specific to the checkpoint context, rather
  * than the CIL itself.
  *
- * With dynamic reservations, we can basically make up arbitrary limits for the
- * checkpoint size so long as they don't violate any other size rules.  Hence
- * the initial maximum size for the checkpoint transaction will be set to a
- * quarter of the log or 8MB, which ever is smaller. 8MB is an arbitrary limit
- * right now based on the latency of writing out a large amount of data through
- * the circular iclog buffers.
+ * With dynamic reservations, we can effectively make up arbitrary limits for
+ * the checkpoint size so long as they don't violate any other size rules.
+ * Recovery imposes a rule that no transaction exceed half the log, so we are
+ * limited by that.  Furthermore, the log transaction reservation subsystem
+ * tries to keep 25% of the log free, so we need to keep below that limit or we
+ * risk running out of free log space to start any new transactions.
+ *
+ * In order to keep background CIL push efficient, we will set a lower
+ * threshold at which background pushing is attempted without blocking current
+ * transaction commits.  A separate, higher bound defines when CIL pushes are
+ * enforced to ensure we stay within our maximum checkpoint size bounds.
+ * threshold, yet give us plenty of space for aggregation on large logs.
  */
-
-#define XLOG_CIL_SPACE_LIMIT(log)	\
-	(min((log->l_logsize >> 2), (8 * 1024 * 1024)))
+#define XLOG_CIL_SPACE_LIMIT(log)	(log->l_logsize >> 3)
+#define XLOG_CIL_HARD_SPACE_LIMIT(log)	(3 * (log->l_logsize >> 4))
 
 /*
  * The reservation head lsn is not made up of a cycle number and block number.
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
