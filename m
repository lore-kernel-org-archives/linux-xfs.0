Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1K2nuDA042717 for <xfs@oss.sgi.com>; Sun, 19 Feb 2012 20:49:56 -0600
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	LJJJatU2DfSmaMJN (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Sun, 19 Feb 2012 18:31:54 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1RzJ2f-0005gV-Fa
	for xfs@oss.sgi.com; Mon, 20 Feb 2012 02:31:53 +0000
Message-Id: <20120220023153.452467104@bombadil.infradead.org>
Date: Sun, 19 Feb 2012 21:31:27 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 08/12] xfs: add xlog_grant_head_wake_all
References: <20120220023119.435889631@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-add-xlog_grant_head_wake_all
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

Reviewed-by: Ben Myers <bpm@sgi.com>
Reviewed-by: Mark Tinguely <tinguely@sgi.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>

---
 fs/xfs/xfs_log.c |   24 ++++++++++++++----------
 1 file changed, 14 insertions(+), 10 deletions(-)

Index: xfs/fs/xfs/xfs_log.c
===================================================================
--- xfs.orig/fs/xfs/xfs_log.c	2011-12-11 21:28:56.364682358 +0100
+++ xfs/fs/xfs/xfs_log.c	2011-12-11 21:28:57.128011556 +0100
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
@@ -3557,7 +3569,6 @@ xfs_log_force_umount(
 	struct xfs_mount	*mp,
 	int			logerror)
 {
-	xlog_ticket_t	*tic;
 	xlog_t		*log;
 	int		retval;
 
@@ -3625,15 +3636,8 @@ xfs_log_force_umount(
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

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
