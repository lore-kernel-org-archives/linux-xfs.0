Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n2FEx4Ak019320 for <xfs@oss.sgi.com>; Sun, 15 Mar 2009 09:59:25 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0AA661C43C44
	for <xfs@oss.sgi.com>; Sun, 15 Mar 2009 07:58:41 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail02.adl2.internode.on.net
	[203.16.214.66]) by cuda.sgi.com with ESMTP id nCKFtbZpyLuiYsUu
	for <xfs@oss.sgi.com>; Sun, 15 Mar 2009 07:58:41 -0700 (PDT)
Received: from destruction.internal (unverified [203.206.165.193])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	354575425-1927428
	for <xfs@oss.sgi.com>; Sun, 15 Mar 2009 22:10:54 +1030 (CDT)
Received: from dave by destruction.internal with local (Exim 4.69)
	(envelope-from <dave@destruction>) id 1Liohv-0006ky-SV
	for xfs@oss.sgi.com; Sun, 15 Mar 2009 22:40:43 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 1/2] XFS: Prevent unwritten extent conversion from blocking
	I/O completion
Date: Sun, 15 Mar 2009 22:40:42 +1100
Message-Id: <1237117243-25940-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1237117243-25940-1-git-send-email-david@fromorbit.com>
References: <1237117243-25940-1-git-send-email-david@fromorbit.com>
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

Unwritten extent conversion can recurse back into the filesystem due
to memory allocation. Memory reclaim requires I/O completions to be
processed to allow the callers to make progress. If the I/O
completion workqueue thread is doing the recursion, then we have a
deadlock situation.

Move unwritten extent completion into it's own workqueue so it
doesn't block I/O completions for normal delayed allocation or
overwrite data.

Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/linux-2.6/xfs_aops.c |   38 +++++++++++++++++++++-----------------
 fs/xfs/linux-2.6/xfs_aops.h |    1 +
 fs/xfs/linux-2.6/xfs_buf.c  |    9 +++++++++
 3 files changed, 31 insertions(+), 17 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_aops.c b/fs/xfs/linux-2.6/xfs_aops.c
index de3a198..763201d 100644
--- a/fs/xfs/linux-2.6/xfs_aops.c
+++ b/fs/xfs/linux-2.6/xfs_aops.c
@@ -153,23 +153,6 @@ xfs_find_bdev_for_inode(
 }
 
 /*
- * Schedule IO completion handling on a xfsdatad if this was
- * the final hold on this ioend. If we are asked to wait,
- * flush the workqueue.
- */
-STATIC void
-xfs_finish_ioend(
-	xfs_ioend_t	*ioend,
-	int		wait)
-{
-	if (atomic_dec_and_test(&ioend->io_remaining)) {
-		queue_work(xfsdatad_workqueue, &ioend->io_work);
-		if (wait)
-			flush_workqueue(xfsdatad_workqueue);
-	}
-}
-
-/*
  * We're now finished for good with this ioend structure.
  * Update the page state via the associated buffer_heads,
  * release holds on the inode and bio, and finally free
@@ -310,6 +293,27 @@ xfs_end_bio_read(
 }
 
 /*
+ * Schedule IO completion handling on a xfsdatad if this was
+ * the final hold on this ioend. If we are asked to wait,
+ * flush the workqueue.
+ */
+STATIC void
+xfs_finish_ioend(
+	xfs_ioend_t	*ioend,
+	int		wait)
+{
+	if (atomic_dec_and_test(&ioend->io_remaining)) {
+		struct workqueue_struct *wq = xfsdatad_workqueue;
+		if (ioend->io_work.func == xfs_end_bio_unwritten)
+			wq = xfsconvertd_workqueue;
+
+		queue_work(wq, &ioend->io_work);
+		if (wait)
+			flush_workqueue(wq);
+	}
+}
+
+/*
  * Allocate and initialise an IO completion structure.
  * We need to track unwritten extent write completion here initially.
  * We'll need to extend this for updating the ondisk inode size later
diff --git a/fs/xfs/linux-2.6/xfs_aops.h b/fs/xfs/linux-2.6/xfs_aops.h
index 1dd5288..221b3e6 100644
--- a/fs/xfs/linux-2.6/xfs_aops.h
+++ b/fs/xfs/linux-2.6/xfs_aops.h
@@ -19,6 +19,7 @@
 #define __XFS_AOPS_H__
 
 extern struct workqueue_struct *xfsdatad_workqueue;
+extern struct workqueue_struct *xfsconvertd_workqueue;
 extern mempool_t *xfs_ioend_pool;
 
 /*
diff --git a/fs/xfs/linux-2.6/xfs_buf.c b/fs/xfs/linux-2.6/xfs_buf.c
index aa1016b..e28800a 100644
--- a/fs/xfs/linux-2.6/xfs_buf.c
+++ b/fs/xfs/linux-2.6/xfs_buf.c
@@ -51,6 +51,7 @@ static struct shrinker xfs_buf_shake = {
 
 static struct workqueue_struct *xfslogd_workqueue;
 struct workqueue_struct *xfsdatad_workqueue;
+struct workqueue_struct *xfsconvertd_workqueue;
 
 #ifdef XFS_BUF_TRACE
 void
@@ -1775,6 +1776,7 @@ xfs_flush_buftarg(
 	xfs_buf_t	*bp, *n;
 	int		pincount = 0;
 
+	xfs_buf_runall_queues(xfsconvertd_workqueue);
 	xfs_buf_runall_queues(xfsdatad_workqueue);
 	xfs_buf_runall_queues(xfslogd_workqueue);
 
@@ -1831,9 +1833,15 @@ xfs_buf_init(void)
 	if (!xfsdatad_workqueue)
 		goto out_destroy_xfslogd_workqueue;
 
+	xfsconvertd_workqueue = create_workqueue("xfsconvertd");
+	if (!xfsconvertd_workqueue)
+		goto out_destroy_xfsdatad_workqueue;
+
 	register_shrinker(&xfs_buf_shake);
 	return 0;
 
+ out_destroy_xfsdatad_workqueue:
+	destroy_workqueue(xfsdatad_workqueue);
  out_destroy_xfslogd_workqueue:
 	destroy_workqueue(xfslogd_workqueue);
  out_free_buf_zone:
@@ -1849,6 +1857,7 @@ void
 xfs_buf_terminate(void)
 {
 	unregister_shrinker(&xfs_buf_shake);
+	destroy_workqueue(xfsconvertd_workqueue);
 	destroy_workqueue(xfsdatad_workqueue);
 	destroy_workqueue(xfslogd_workqueue);
 	kmem_zone_destroy(xfs_buf_zone);
-- 
1.6.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
