Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7N53W66135134 for <xfs@oss.sgi.com>; Thu, 23 Aug 2012 00:03:32 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	C99ZZm4AMwkq2box for <xfs@oss.sgi.com>;
	Wed, 22 Aug 2012 22:04:17 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1T4PaV-0003Gu-6C
	for xfs@oss.sgi.com; Thu, 23 Aug 2012 15:04:11 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1T4PaV-0003el-2D
	for xfs@oss.sgi.com; Thu, 23 Aug 2012 15:04:11 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 043/102] xfs: add xlog_grant_head_wake_all
Date: Thu, 23 Aug 2012 15:02:01 +1000
Message-Id: <1345698180-13612-44-git-send-email-david@fromorbit.com>
In-Reply-To: <1345698180-13612-1-git-send-email-david@fromorbit.com>
References: <1345698180-13612-1-git-send-email-david@fromorbit.com>
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

From: Christoph Hellwig <hch@infradead.org>

Upstream commit: a79bf2d75b8f96bcdb6714138cd53cb3c358669c

Reviewed-by: Mark Tinguely <tinguely@sgi.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Ben Myers <bpm@sgi.com>
---
 fs/xfs/xfs_log.c |   24 ++++++++++++++----------
 1 file changed, 14 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 6ef0264..eb19abf 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -159,6 +159,18 @@ xlog_grant_head_init(
 	spin_lock_init(&head->lock);
 }
 
+STATIC void
+xlog_grant_head_wake_all(
+	struct xlog_grant_head	*head)
+{
+	struct xlog_ticket	*tic;
+
+	spin_lock(&head->lock);
+	list_for_each_entry(tic, &head->waiters, t_queue)
+		wake_up_process(tic->t_task);
+	spin_unlock(&head->lock);
+}
+
 STATIC bool
 xlog_reserveq_wake(
 	struct log		*log,
@@ -3608,7 +3620,6 @@ xfs_log_force_umount(
 	struct xfs_mount	*mp,
 	int			logerror)
 {
-	xlog_ticket_t	*tic;
 	xlog_t		*log;
 	int		retval;
 
@@ -3676,15 +3687,8 @@ xfs_log_force_umount(
 	 * we don't enqueue anything once the SHUTDOWN flag is set, and this
 	 * action is protected by the grant locks.
 	 */
-	spin_lock(&log->l_reserve_head.lock);
-	list_for_each_entry(tic, &log->l_reserve_head.waiters, t_queue)
-		wake_up_process(tic->t_task);
-	spin_unlock(&log->l_reserve_head.lock);
-
-	spin_lock(&log->l_write_head.lock);
-	list_for_each_entry(tic, &log->l_write_head.waiters, t_queue)
-		wake_up_process(tic->t_task);
-	spin_unlock(&log->l_write_head.lock);
+	xlog_grant_head_wake_all(&log->l_reserve_head);
+	xlog_grant_head_wake_all(&log->l_write_head);
 
 	if (!(log->l_iclog->ic_state & XLOG_STATE_IOERROR)) {
 		ASSERT(!logerror);
-- 
1.7.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
