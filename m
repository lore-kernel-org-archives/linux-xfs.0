Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 45EA37F50
	for <xfs@oss.sgi.com>; Wed, 11 Dec 2013 23:34:45 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 23D7D8F8035
	for <xfs@oss.sgi.com>; Wed, 11 Dec 2013 21:34:45 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	O1HBOlc1Q4Bwch59 for <xfs@oss.sgi.com>;
	Wed, 11 Dec 2013 21:34:43 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1Vqyv2-0000bm-A0
	for xfs@oss.sgi.com; Thu, 12 Dec 2013 16:34:40 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1Vqyv2-0003cP-92
	for xfs@oss.sgi.com; Thu, 12 Dec 2013 16:34:40 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 2/6] xfs: prevent spurious "head behind tail" warnings
Date: Thu, 12 Dec 2013 16:34:34 +1100
Message-Id: <1386826478-13846-3-git-send-email-david@fromorbit.com>
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

From: Dave Chinner <dchinner@redhat.com>

When xlog_space_left() cracks the grant head and the log tail, it
does so without locking to synchronise the sampling of the
variables. It samples the grant head first, so if there is a delay
before it smaples the log tail, there is a window where the log tail
could have moved onwards and be moved past the sampled value of the
grant head. This then leads to the "xlog_space_left: head behind
tail" warning message.

To avoid spurious output in this situation, swap the order in which
the variables are cracked and disable preemption to minimise the
potential delays between them being sampled. This means that the
head may grant head may move if there is a delay but the log tail
will be stable, hence ensuring the tail does not jump the head
accidentally. The code also handles this condition without problems
or warnings.

While there, update the code with detailed comments on the cases
that it is handling so it is easier to understand in future.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_log.c | 99 +++++++++++++++++++++++++++++++++++++-------------------
 1 file changed, 66 insertions(+), 33 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 8497a00..97b2705 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1095,55 +1095,88 @@ xlog_assign_tail_lsn(
 }
 
 /*
- * Return the space in the log between the tail and the head.  The head
- * is passed in the cycle/bytes formal parms.  In the special case where
- * the reserve head has wrapped passed the tail, this calculation is no
- * longer valid.  In this case, just return 0 which means there is no space
- * in the log.  This works for all places where this function is called
- * with the reserve head.  Of course, if the write head were to ever
- * wrap the tail, we should blow up.  Rather than catch this case here,
- * we depend on other ASSERTions in other parts of the code.   XXXmiken
+ * Return the space in the log between the tail and the head.
  *
- * This code also handles the case where the reservation head is behind
- * the tail.  The details of this case are described below, but the end
- * result is that we return the size of the log as the amount of space left.
+ * This has two special cases where head and tail overlap
+ *	- head wraps passed the tail; the log is considered full
+ *	- tail overtakes the head;  the log is considered empty.
+ *	  This should never happen, so warn when it does.
  */
 STATIC int
 xlog_space_left(
 	struct xlog	*log,
 	atomic64_t	*head)
 {
-	int		free_bytes;
 	int		tail_bytes;
 	int		tail_cycle;
 	int		head_cycle;
 	int		head_bytes;
 
+	/*
+	 * Sample the tail before head to avoid spurious "head behind tail"
+	 * warnings due to racing tail updates. We disable preemption and dump a
+	 * memory barrier here to make sure we pick up the latest values with as
+	 * little latency between the samples as possible.
+	 */
+	preempt_disable();
+	smp_mb();
+	xlog_crack_atomic_lsn(&log->l_tail_lsn, &tail_cycle,
+			      &tail_bytes);
 	xlog_crack_grant_head(head, &head_cycle, &head_bytes);
-	xlog_crack_atomic_lsn(&log->l_tail_lsn, &tail_cycle, &tail_bytes);
+	preempt_enable();
+
 	tail_bytes = BBTOB(tail_bytes);
-	if (tail_cycle == head_cycle && head_bytes >= tail_bytes)
-		free_bytes = log->l_logsize - (head_bytes - tail_bytes);
-	else if (tail_cycle + 1 < head_cycle)
+
+	/*
+	 * If the tail cycle is not within one count of head, we are in grant
+	 * space overcommit situation and so there is no log space available to
+	 * anyone right now.
+	 */
+	if (tail_cycle + 1 < head_cycle)
 		return 0;
-	else if (tail_cycle < head_cycle) {
+
+	/*
+	 * If the tail is in previous cycle, space available is the region
+	 * between the tail and the head.
+	 *
+	 *	     H		 T
+	 *    +2222222111111111111111+
+	 *            +-- free --+
+	 */
+	if (tail_cycle < head_cycle) {
 		ASSERT(tail_cycle == (head_cycle - 1));
-		free_bytes = tail_bytes - head_bytes;
-	} else {
-		/*
-		 * The reservation head is behind the tail.
-		 * In this case we just want to return the size of the
-		 * log as the amount of space left.
-		 */
-		xfs_alert(log->l_mp,
-			"xlog_space_left: head behind tail\n"
-			"  tail_cycle = %d, tail_bytes = %d\n"
-			"  GH   cycle = %d, GH   bytes = %d",
-			tail_cycle, tail_bytes, head_cycle, head_bytes);
-		ASSERT(0);
-		free_bytes = log->l_logsize;
-	}
-	return free_bytes;
+		return tail_bytes - head_bytes;
+	}
+
+	/*
+	 * If the tail is in the same cycle, space available is the regions
+	 * outside the range between the tail and the head:
+	 *
+	 *	   T	       H
+	 *    +2222222222222222211111+
+	 *          +-- used --+
+	 *    +free+		+free+
+	 *
+	 * If the head and tail are the same, then the whole log is free.
+	 */
+	if (tail_cycle == head_cycle && head_bytes >= tail_bytes)
+		return log->l_logsize - (head_bytes - tail_bytes);
+
+	/*
+	 * The head is behind the tail. That's not supposed to happen, but we
+	 * need to handle it. In this case, it's the equivalent of the entire
+	 * log being empty and available for use.
+	 */
+	xfs_alert(log->l_mp,
+		  "%s: Head behind log tail, caller %pF\n"
+		  "  tail_cycle = %d, tail_bytes = %d\n"
+		  "  GH   cycle = %d, GH   bytes = %d",
+		  __func__, (void *)_RET_IP_,
+		  tail_cycle, tail_bytes, head_cycle, head_bytes);
+#ifdef DEBUG
+	dump_stack();
+#endif
+	return log->l_logsize;
 }
 
 
-- 
1.8.4.rc3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
