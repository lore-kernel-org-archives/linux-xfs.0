Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 471427F4E
	for <xfs@oss.sgi.com>; Tue, 19 Nov 2013 16:37:49 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 2415C304039
	for <xfs@oss.sgi.com>; Tue, 19 Nov 2013 14:37:45 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	FPwgjOyK12W76Z2T for <xfs@oss.sgi.com>;
	Tue, 19 Nov 2013 14:37:44 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1VitvP-0006BD-4d
	for xfs@oss.sgi.com; Wed, 20 Nov 2013 09:37:39 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1VitvP-0005mu-3j
	for xfs@oss.sgi.com; Wed, 20 Nov 2013 09:37:39 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH] xfs: prevent spurious "head behind tail" warnings
Date: Wed, 20 Nov 2013 09:37:39 +1100
Message-Id: <1384900659-22215-1-git-send-email-david@fromorbit.com>
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

When xlog_space_left() cracks the grant head and the log tail, it
does so without locking to synchronise the sampling of the
variables. It samples the grant head first, so if there is a delay
before it smaples the log tail, there is a window where the log tail
could have moved onwards and be moved past the sampled value of the
grant head. This then leads to the "xlog_space_left: head behind
tail" warning message.

To avoid spurious output in this situation, swap the order in which
the variables are cracked. This means that the head may grant head
may move if there is a delay, but the log tail will be stable, hence
ensure the tail does not jump the head accidentally.

While this avoids the spurious head behind tail problem, it
introduces the opposite problem - the head can move more than a full
cycle past the tail. The code already handles this case by
indicating that the log is full (i.e. zero space available) but
that's still (generally) a spurious situation.

Hence, if we detect that the head is more than a cycle ahead of the
tail or the head is behind the tail, start the calculation again by
resampling the variables and trying again. If we get too many
resamples, then throw a warning and return a full or empty log
appropriately.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_log.c | 102 ++++++++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 78 insertions(+), 24 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 8497a00..0cfcc20 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1113,37 +1113,91 @@ xlog_space_left(
 	struct xlog	*log,
 	atomic64_t	*head)
 {
-	int		free_bytes;
 	int		tail_bytes;
 	int		tail_cycle;
 	int		head_cycle;
 	int		head_bytes;
+	int		retries = 0;
+#define XLOG_SPACE_MAX_RETRIES	5
+
+	do {
+		/*
+		 * sample tail before head to avoid spurious "head behind tail"
+		 * warnings due to racing tail updates. We dump a memory barrier
+		 * here to make sure we pick up the latest values that have been
+		 * written by other threads each time through.
+		 */
+		smp_mb();
+		xlog_crack_atomic_lsn(&log->l_tail_lsn, &tail_cycle,
+				      &tail_bytes);
+		tail_bytes = BBTOB(tail_bytes);
+		xlog_crack_grant_head(head, &head_cycle, &head_bytes);
+
+		/*
+		 * The tail cycle should always be the same or one less than the
+		 * head cycle. If not, restart again because we've likely had a
+		 * race with an update during sampling.
+		 */
+		if (tail_cycle + 1 < head_cycle || tail_cycle > head_cycle)
+			continue;
+
+		/*
+		 * If the tail is in previous cycle, space available is the
+		 * region between the tail and the head.
+		 *
+		 *	     H		 T
+		 *    +2222222111111111111111+
+		 *            +-- free --+
+		 */
+		if (tail_cycle < head_cycle) {
+			ASSERT(tail_cycle == (head_cycle - 1));
+			return tail_bytes - head_bytes;
+		}
+
+		/*
+		 * If the tail is in the same cycle, space available is the
+		 * regions outside the range between the tail and the head:
+		 *
+		 *	   T	       H
+		 *    +2222222222222222211111+
+		 *          +-- used --+
+		 *    +free+		+free+
+		 *
+		 * If the head and tail are the same, then the whole log is
+		 * free.
+		 */
+		if (tail_cycle == head_cycle && head_bytes >= tail_bytes)
+			return log->l_logsize - (head_bytes - tail_bytes);
 
-	xlog_crack_grant_head(head, &head_cycle, &head_bytes);
-	xlog_crack_atomic_lsn(&log->l_tail_lsn, &tail_cycle, &tail_bytes);
-	tail_bytes = BBTOB(tail_bytes);
-	if (tail_cycle == head_cycle && head_bytes >= tail_bytes)
-		free_bytes = log->l_logsize - (head_bytes - tail_bytes);
-	else if (tail_cycle + 1 < head_cycle)
-		return 0;
-	else if (tail_cycle < head_cycle) {
-		ASSERT(tail_cycle == (head_cycle - 1));
-		free_bytes = tail_bytes - head_bytes;
-	} else {
 		/*
-		 * The reservation head is behind the tail.
-		 * In this case we just want to return the size of the
-		 * log as the amount of space left.
+		 * The head is behind the tail. Invalid, so let's go around
+		 * again and resample.
 		 */
-		xfs_alert(log->l_mp,
-			"xlog_space_left: head behind tail\n"
-			"  tail_cycle = %d, tail_bytes = %d\n"
-			"  GH   cycle = %d, GH   bytes = %d",
-			tail_cycle, tail_bytes, head_cycle, head_bytes);
-		ASSERT(0);
-		free_bytes = log->l_logsize;
-	}
-	return free_bytes;
+	} while (retries++ < XLOG_SPACE_MAX_RETRIES);
+
+	/*
+	 * OK, we're in trouble now - the head and tail are out of sync. Time to
+	 * issue a warning about it and return a default free space value
+	 * depending on whether the tail is ahead or behind the log.
+	 */
+	ASSERT(retries >= XLOG_SPACE_MAX_RETRIES);
+	xfs_alert(log->l_mp,
+		  "%s: The grant head is %s the log tail.\n"
+		  "  tail_cycle = %d, tail_bytes = %d\n"
+		  "  GH   cycle = %d, GH   bytes = %d",
+		  __func__,
+		  tail_cycle + 1 < head_cycle ? "in front of" : "behind",
+		  tail_cycle, tail_bytes, head_cycle, head_bytes);
+	ASSERT(0);
+
+	/*
+	 * If the head is in front, there is not space left to advance it so we
+	 * consider the log as being full. If the tail is behind, then we assume
+	 * that the whole log is available.
+	 */
+	if (tail_cycle + 1 < head_cycle)
+		return 0;
+	return log->l_logsize;
 }
 
 
-- 
1.8.4.rc3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
