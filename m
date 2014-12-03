Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 0157E7F3F
	for <xfs@oss.sgi.com>; Wed,  3 Dec 2014 13:24:28 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E4D3D304032
	for <xfs@oss.sgi.com>; Wed,  3 Dec 2014 11:24:24 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id jvyEPALwIMDQNG9V (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 03 Dec 2014 11:24:23 -0800 (PST)
Received: from int-mx10.intmail.prod.int.phx2.redhat.com
	(int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id sB3JOLYU006917
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=FAIL) for <xfs@oss.sgi.com>; Wed, 3 Dec 2014 14:24:22 -0500
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id sB3JOLLn011187
	for <xfs@oss.sgi.com>; Wed, 3 Dec 2014 14:24:21 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v2] xfs: split metadata and log buffer completion to separate
	workqueues
Date: Wed,  3 Dec 2014 14:24:19 -0500
Message-Id: <1417634659-16386-1-git-send-email-bfoster@redhat.com>
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

XFS traditionally sends all buffer I/O completion work to a single
workqueue. This includes metadata buffer completion and log buffer
completion. The log buffer completion requires a high priority queue to
prevent stalls due to log forces getting stuck behind other queued work.

Rather than continue to prioritize all buffer I/O completion due to the
needs of log completion, split log buffer completion off to
m_log_workqueue and move the high priority flag from m_buf_workqueue to
m_log_workqueue.

Add a b_ioend_wq wq pointer to xfs_buf to allow completion workqueue
customization on a per-buffer basis. Initialize b_ioend_wq to
m_buf_workqueue by default in the generic buffer I/O submission path.
Finally, override the default wq with the high priority m_log_workqueue
in the log buffer I/O submission path.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---

v2:
- Add bp->b_ioend_wq pointer to multiplex buffer I/O completion
  workqueues.
v1/rfc: http://oss.sgi.com/archives/xfs/2014-11/msg00240.html

 fs/xfs/xfs_buf.c   | 13 ++++++++++---
 fs/xfs/xfs_buf.h   |  3 ++-
 fs/xfs/xfs_log.c   |  4 ++++
 fs/xfs/xfs_super.c |  5 ++---
 4 files changed, 18 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index a4ce390..bb502a3 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1041,7 +1041,7 @@ xfs_buf_ioend_work(
 	struct work_struct	*work)
 {
 	struct xfs_buf		*bp =
-		container_of(work, xfs_buf_t, b_iodone_work);
+		container_of(work, xfs_buf_t, b_ioend_work);
 
 	xfs_buf_ioend(bp);
 }
@@ -1050,8 +1050,8 @@ void
 xfs_buf_ioend_async(
 	struct xfs_buf	*bp)
 {
-	INIT_WORK(&bp->b_iodone_work, xfs_buf_ioend_work);
-	queue_work(bp->b_target->bt_mount->m_buf_workqueue, &bp->b_iodone_work);
+	INIT_WORK(&bp->b_ioend_work, xfs_buf_ioend_work);
+	queue_work(bp->b_ioend_wq, &bp->b_ioend_work);
 }
 
 void
@@ -1220,6 +1220,13 @@ _xfs_buf_ioapply(
 	 */
 	bp->b_error = 0;
 
+	/*
+	 * Initialize the I/O completion workqueue if we haven't yet or the
+	 * submitter has not opted to specify a custom one.
+	 */
+	if (!bp->b_ioend_wq)
+		bp->b_ioend_wq = bp->b_target->bt_mount->m_buf_workqueue;
+
 	if (bp->b_flags & XBF_WRITE) {
 		if (bp->b_flags & XBF_SYNCIO)
 			rw = WRITE_SYNC;
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index 82002c0..75ff5d5 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -164,7 +164,8 @@ typedef struct xfs_buf {
 	struct xfs_perag	*b_pag;		/* contains rbtree root */
 	xfs_buftarg_t		*b_target;	/* buffer target (device) */
 	void			*b_addr;	/* virtual address of buffer */
-	struct work_struct	b_iodone_work;
+	struct work_struct	b_ioend_work;
+	struct workqueue_struct	*b_ioend_wq;	/* I/O completion wq */
 	xfs_buf_iodone_t	b_iodone;	/* I/O completion function */
 	struct completion	b_iowait;	/* queue for I/O waiters */
 	void			*b_fspriv;
diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index f6d6b8b..e408bf5 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1806,6 +1806,8 @@ xlog_sync(
 	XFS_BUF_ZEROFLAGS(bp);
 	XFS_BUF_ASYNC(bp);
 	bp->b_flags |= XBF_SYNCIO;
+	/* use high priority completion wq */
+	bp->b_ioend_wq = log->l_mp->m_log_workqueue;
 
 	if (log->l_mp->m_flags & XFS_MOUNT_BARRIER) {
 		bp->b_flags |= XBF_FUA;
@@ -1854,6 +1856,8 @@ xlog_sync(
 		bp->b_flags |= XBF_SYNCIO;
 		if (log->l_mp->m_flags & XFS_MOUNT_BARRIER)
 			bp->b_flags |= XBF_FUA;
+		/* use high priority completion wq */
+		bp->b_ioend_wq = log->l_mp->m_log_workqueue;
 
 		ASSERT(XFS_BUF_ADDR(bp) <= log->l_logBBsize-1);
 		ASSERT(XFS_BUF_ADDR(bp) + BTOBB(count) <= log->l_logBBsize);
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index fee11c8..7a833c3 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -839,8 +839,7 @@ xfs_init_mount_workqueues(
 	struct xfs_mount	*mp)
 {
 	mp->m_buf_workqueue = alloc_workqueue("xfs-buf/%s",
-			WQ_MEM_RECLAIM|WQ_HIGHPRI|WQ_FREEZABLE, 1,
-			mp->m_fsname);
+			WQ_MEM_RECLAIM|WQ_FREEZABLE, 1, mp->m_fsname);
 	if (!mp->m_buf_workqueue)
 		goto out;
 
@@ -865,7 +864,7 @@ xfs_init_mount_workqueues(
 		goto out_destroy_cil;
 
 	mp->m_log_workqueue = alloc_workqueue("xfs-log/%s",
-			WQ_FREEZABLE, 0, mp->m_fsname);
+			WQ_FREEZABLE|WQ_HIGHPRI, 0, mp->m_fsname);
 	if (!mp->m_log_workqueue)
 		goto out_destroy_reclaim;
 
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
