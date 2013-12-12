Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 290177F52
	for <xfs@oss.sgi.com>; Wed, 11 Dec 2013 23:34:47 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id A01E2AC008
	for <xfs@oss.sgi.com>; Wed, 11 Dec 2013 21:34:46 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	9vzJXBvfqbdZMYyS for <xfs@oss.sgi.com>;
	Wed, 11 Dec 2013 21:34:44 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1Vqyv2-0000bn-Ac
	for xfs@oss.sgi.com; Thu, 12 Dec 2013 16:34:40 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1Vqyv2-0003cU-9c
	for xfs@oss.sgi.com; Thu, 12 Dec 2013 16:34:40 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 3/6] xfs: prevent spurious "space > BBTOB(tail_blocks)"
	warnings
Date: Thu, 12 Dec 2013 16:34:35 +1100
Message-Id: <1386826478-13846-4-git-send-email-david@fromorbit.com>
In-Reply-To: <1386826478-13846-1-git-send-email-david@fromorbit.com>
References: <1386826478-13846-1-git-send-email-david@fromorbit.com>
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

When xlog_verify_grant_tail() cracks the grant head and the log
tail, it does so without locking to synchronise the sampling of the
variables. A delay between samples can give the wrong results,
sometimes leading to false warnings being emitted.

To avoid spurious output in this situation, disable preemption to
minimise the potential delays between them being sampled. This means
that the log tail may still move, but it won't trigger warnings
unless it moves beyond the current head cycle. If we see delays like
that we probably should be throwing a warning, anyway.

Further, the write head can validly pass the tail in certain
circumstances. Document those circumstances in the commentsx, and
remove the xlog_verify_grant_tail() call in xfs_log_reserve() that
is guaranteed to emit false positive warnings due it being the
source of temporary overcommit conditions.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_log.c | 94 +++++++++++++++++++++++++++++++++++++++++---------------
 1 file changed, 69 insertions(+), 25 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 97b2705..f4ccc10 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -472,7 +472,6 @@ xfs_log_reserve(
 	xlog_grant_add_space(log, &log->l_reserve_head.grant, need_bytes);
 	xlog_grant_add_space(log, &log->l_write_head.grant, need_bytes);
 	trace_xfs_log_reserve_exit(log, tic);
-	xlog_verify_grant_tail(log);
 	return 0;
 
 out_error:
@@ -3651,36 +3650,81 @@ xlog_verify_dest_ptr(
  * the cycles are the same, we can't be overlapping.  Otherwise, make sure that
  * the cycles differ by exactly one and check the byte count.
  *
- * This check is run unlocked, so can give false positives. Rather than assert
- * on failures, use a warn-once flag and a panic tag to allow the admin to
- * determine if they want to panic the machine when such an error occurs. For
- * debug kernels this will have the same effect as using an assert but, unlinke
- * an assert, it can be turned off at runtime.
+ * We only do this check when regranting write space because xfs_log_reserve can
+ * race with a regrant and a reserve space overcommit can result in a write
+ * space overcommit from xfs_log_reserve() once log space becomes available
+ * again. This is only a temporary situation, but it means that checking the
+ * write grant head and log tail from xfs_log_reserve gives false positives.
+ *
+ * If we only call from xfs_log_regrant(), we are only called after overcommit
+ * situations have been resolved by sleeping. If the head and tail overlap at
+ * this point, then we have a problem.
+ *
+ * Because we always want to know about this issue if there is a filesystem hang
+ * due to log space availability, use a warn-once flag and a panic tag to allow
+ * the admin to determine if they want to panic the machine when such an error
+ * occurs. For debug kernels this will have the same effect as using an assert
+ * but, unlike an assert, it can be turned off at runtime.
  */
 STATIC void
 xlog_verify_grant_tail(
 	struct xlog	*log)
 {
-	int		tail_cycle, tail_blocks;
-	int		cycle, space;
-
-	xlog_crack_grant_head(&log->l_write_head.grant, &cycle, &space);
-	xlog_crack_atomic_lsn(&log->l_tail_lsn, &tail_cycle, &tail_blocks);
-	if (tail_cycle != cycle) {
-		if (cycle - 1 != tail_cycle &&
-		    !(log->l_flags & XLOG_TAIL_WARN)) {
-			xfs_alert_tag(log->l_mp, XFS_PTAG_LOGRES,
-				"%s: cycle - 1 != tail_cycle", __func__);
-			log->l_flags |= XLOG_TAIL_WARN;
-		}
+	int		tail_cycle;
+	int		tail_blocks;
+	int		head_cycle;
+	int		head_bytes;
 
-		if (space > BBTOB(tail_blocks) &&
-		    !(log->l_flags & XLOG_TAIL_WARN)) {
-			xfs_alert_tag(log->l_mp, XFS_PTAG_LOGRES,
-				"%s: space > BBTOB(tail_blocks)", __func__);
-			log->l_flags |= XLOG_TAIL_WARN;
-		}
-	}
+	/*
+	 * If we've already detected an problem here, don't bother checking
+	 * again.
+	 */
+	if (log->l_flags & XLOG_TAIL_WARN)
+		return;
+
+	/*
+	 * Sample the tail before head to avoid spurious warnings due to racing
+	 * tail updates. We disable preemption and dump a memory barrier here to
+	 * make sure we pick up the latest values with as little latency between
+	 * the samples as possible.
+	 */
+	preempt_disable();
+	smp_mb();
+	xlog_crack_atomic_lsn(&log->l_tail_lsn, &tail_cycle,
+			      &tail_blocks);
+	xlog_crack_grant_head(&log->l_write_head.grant, &head_cycle,
+			      &head_bytes);
+	preempt_enable();
+
+	/*
+	 * if the cycles are the same, the head and tail can't be
+	 * overlapping, so everything is ok and we are done.
+	 */
+	if (tail_cycle == head_cycle)
+		return;
+
+	/*
+	 * if the tail is on the previous cycle to the head and the head
+	 * is before the tail, then all is good.
+	 */
+	if (tail_cycle == head_cycle - 1 &&
+	    BBTOB(tail_blocks) >= head_bytes)
+		return;
+
+	/*
+	 * OK, we're in trouble now - the head and tail are out of sync. Time to
+	 * issue a warning about it
+	 */
+	xfs_alert(log->l_mp,
+		  "%s: Write head overlaps the tail, caller %pF\n"
+		  "  tail_cycle = %d, tail_bytes = %d\n"
+		  "  GH   cycle = %d, GH   bytes = %d",
+		  __func__, (void *)_RET_IP_,
+		  tail_cycle, BBTOB(tail_blocks), head_cycle, head_bytes);
+#ifdef DEBUG
+	dump_stack();
+#endif
+	log->l_flags |= XLOG_TAIL_WARN;
 }
 
 /* check if it will fit */
-- 
1.8.4.rc3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
