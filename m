Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with SMTP id
	p371saN5067158 for <xfs@oss.sgi.com>; Wed, 6 Apr 2011 20:54:36 -0500
Received: from ipmail04.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5A4061493635
	for <xfs@oss.sgi.com>; Wed,  6 Apr 2011 18:57:52 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	yeKjAFwv4tylV09u for <xfs@oss.sgi.com>;
	Wed, 06 Apr 2011 18:57:52 -0700 (PDT)
Received: from chute ([192.168.1.1] helo=disappointment)
	by dastard with esmtp (Exim 4.72)
	(envelope-from <dave@fromorbit.com>) id 1Q7eTY-00063i-5I
	for xfs@oss.sgi.com; Thu, 07 Apr 2011 11:57:36 +1000
Received: from dave by disappointment with local (Exim 4.72)
	(envelope-from <dave@disappointment.disaster>) id 1Q7eTa-0007A2-Pz
	for xfs@oss.sgi.com; Thu, 07 Apr 2011 11:57:38 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 9/9] xfs: convert log tail checking to a warning
Date: Thu,  7 Apr 2011 11:57:25 +1000
Message-Id: <1302141445-27457-10-git-send-email-david@fromorbit.com>
In-Reply-To: <1302141445-27457-1-git-send-email-david@fromorbit.com>
References: <1302141445-27457-1-git-send-email-david@fromorbit.com>
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

On the Power platform, the log tail debug checks fire excessively
causing the system to panic early in testing. The debug checks are
known to be racy, though on x86_64 there is no evidence that they
trigger at all.

We want to keep the checks active on debug systems to alert us to
problems with log space accounting, but we need to reduce the impact
of a racy check on testing on the Power platform.

As a result, convert the ASSERT conditions to warnings, and
allow them to fire only once per filesystem mount. This will prevent
false positives from interfering with testing, whilst still
providing us with the indication that they may be a problem with log
space accounting should that occur.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_log.c      |   32 ++++++++++++++++++++++++--------
 fs/xfs/xfs_log_priv.h |    1 +
 2 files changed, 25 insertions(+), 8 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 2464316..b612ce4 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -3407,6 +3407,17 @@ xlog_verify_dest_ptr(
 		xfs_emerg(log->l_mp, "%s: invalid ptr", __func__);
 }
 
+/*
+ * Check to make sure the grant write head didn't just over lap the tail.  If
+ * the cycles are the same, we can't be overlapping.  Otherwise, make sure that
+ * the cycles differ by exactly one and check the byte count.
+ *
+ * This check is run unlocked, so can give false positives. Rather than assert
+ * on failures, use a warn-once flag and a panic tag to allow the admin to
+ * determine if they want to panic the machine when such an error occurs. For
+ * debug kernels this will have the same effect as using an assert but, unlinke
+ * an assert, it can be turned off at runtime.
+ */
 STATIC void
 xlog_verify_grant_tail(
 	struct log	*log)
@@ -3414,17 +3425,22 @@ xlog_verify_grant_tail(
 	int		tail_cycle, tail_blocks;
 	int		cycle, space;
 
-	/*
-	 * Check to make sure the grant write head didn't just over lap the
-	 * tail.  If the cycles are the same, we can't be overlapping.
-	 * Otherwise, make sure that the cycles differ by exactly one and
-	 * check the byte count.
-	 */
 	xlog_crack_grant_head(&log->l_grant_write_head, &cycle, &space);
 	xlog_crack_atomic_lsn(&log->l_tail_lsn, &tail_cycle, &tail_blocks);
 	if (tail_cycle != cycle) {
-		ASSERT(cycle - 1 == tail_cycle);
-		ASSERT(space <= BBTOB(tail_blocks));
+		if (cycle - 1 != tail_cycle &&
+		    !(log->l_flags & XLOG_TAIL_WARN)) {
+			xfs_alert_tag(log->l_mp, XFS_PTAG_LOGRES,
+				"%s: cycle - 1 != tail_cycle", __func__);
+			log->l_flags |= XLOG_TAIL_WARN;
+		}
+
+		if (space > BBTOB(tail_blocks) &&
+		    !(log->l_flags & XLOG_TAIL_WARN)) {
+			xfs_alert_tag(log->l_mp, XFS_PTAG_LOGRES,
+				"%s: space > BBTOB(tail_blocks)", __func__);
+			log->l_flags |= XLOG_TAIL_WARN;
+		}
 	}
 }
 
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index 15dbf1f..bc988d4 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -144,6 +144,7 @@ static inline uint xlog_get_client_id(__be32 i)
 #define	XLOG_RECOVERY_NEEDED	0x4	/* log was recovered */
 #define XLOG_IO_ERROR		0x8	/* log hit an I/O error, and being
 					   shutdown */
+#define XLOG_TAIL_WARN		0x10	/* log tail verify warning issued */
 
 #ifdef __KERNEL__
 /*
-- 
1.7.2.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
