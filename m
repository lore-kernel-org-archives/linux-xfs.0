Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3N5xRv3127472 for <xfs@oss.sgi.com>; Mon, 23 Apr 2012 00:59:28 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	No3aS8QShFKLXCg2 for <xfs@oss.sgi.com>;
	Sun, 22 Apr 2012 22:59:25 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1SMCIy-0001aG-OG
	for xfs@oss.sgi.com; Mon, 23 Apr 2012 15:59:20 +1000
Received: from dave by disappointment with local (Exim 4.77)
	(envelope-from <dave@disappointment.disaster>) id 1SMCIo-0004Xy-Kp
	for xfs@oss.sgi.com; Mon, 23 Apr 2012 15:59:10 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 12/37] xfs: Do background CIL flushes via a workqueue
Date: Mon, 23 Apr 2012 15:58:42 +1000
Message-Id: <1335160747-17254-13-git-send-email-david@fromorbit.com>
In-Reply-To: <1335160747-17254-1-git-send-email-david@fromorbit.com>
References: <1335160747-17254-1-git-send-email-david@fromorbit.com>
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

Doing background CIL flushes adds significant latency to whatever
async transaction that triggers it. To avoid blocking async
transactions on things like waiting for log buffer IO to complete,
move the CIL push off into a workqueue.  By moving the push work
into a workqueue, we remove all the latency that the commit adds
from the foreground transaction commit path. This also means that
single threaded workloads won't do the CIL push procssing, leaving
them more CPU to do more async transactions.

To do this, we need to keep track of the sequence number we have
pushed work for. This avoids having many transaction commits
attempting to schedule work for the same sequence, and ensures that
we only ever have one push (background or forced) in progress at a
time. It also means that we don't need to take the CIL lock in write
mode to check for potential background push races, which reduces
lock contention.

To avoid potential issues with "smart" IO schedulers, don't use the
workqueue for log force triggered flushes. Instead, do them directly
so that the log IO is done directly by the process issuing the log
force and so doesn't get stuck on IO elevator queue idling
incorrectly delaying the log IO from the workqueue.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Mark Tinguely <tinguely@sgi.com>
---
 fs/xfs/xfs_log_cil.c  |  241 ++++++++++++++++++++++++++++++-------------------
 fs/xfs/xfs_log_priv.h |    2 +
 fs/xfs/xfs_mount.h    |    1 +
 fs/xfs/xfs_super.c    |    7 ++
 4 files changed, 157 insertions(+), 94 deletions(-)

diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index d4fadbe..566a2d5 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -32,58 +32,6 @@
 #include "xfs_discard.h"
 
 /*
- * Perform initial CIL structure initialisation.
- */
-int
-xlog_cil_init(
-	struct log	*log)
-{
-	struct xfs_cil	*cil;
-	struct xfs_cil_ctx *ctx;
-
-	cil = kmem_zalloc(sizeof(*cil), KM_SLEEP|KM_MAYFAIL);
-	if (!cil)
-		return ENOMEM;
-
-	ctx = kmem_zalloc(sizeof(*ctx), KM_SLEEP|KM_MAYFAIL);
-	if (!ctx) {
-		kmem_free(cil);
-		return ENOMEM;
-	}
-
-	INIT_LIST_HEAD(&cil->xc_cil);
-	INIT_LIST_HEAD(&cil->xc_committing);
-	spin_lock_init(&cil->xc_cil_lock);
-	init_rwsem(&cil->xc_ctx_lock);
-	init_waitqueue_head(&cil->xc_commit_wait);
-
-	INIT_LIST_HEAD(&ctx->committing);
-	INIT_LIST_HEAD(&ctx->busy_extents);
-	ctx->sequence = 1;
-	ctx->cil = cil;
-	cil->xc_ctx = ctx;
-	cil->xc_current_sequence = ctx->sequence;
-
-	cil->xc_log = log;
-	log->l_cilp = cil;
-	return 0;
-}
-
-void
-xlog_cil_destroy(
-	struct log	*log)
-{
-	if (log->l_cilp->xc_ctx) {
-		if (log->l_cilp->xc_ctx->ticket)
-			xfs_log_ticket_put(log->l_cilp->xc_ctx->ticket);
-		kmem_free(log->l_cilp->xc_ctx);
-	}
-
-	ASSERT(list_empty(&log->l_cilp->xc_cil));
-	kmem_free(log->l_cilp);
-}
-
-/*
  * Allocate a new ticket. Failing to get a new ticket makes it really hard to
  * recover, so we don't allow failure here. Also, we allocate in a context that
  * we don't want to be issuing transactions from, so we need to tell the
@@ -426,8 +374,7 @@ xlog_cil_committed(
  */
 STATIC int
 xlog_cil_push(
-	struct log		*log,
-	xfs_lsn_t		push_seq)
+	struct log		*log)
 {
 	struct xfs_cil		*cil = log->l_cilp;
 	struct xfs_log_vec	*lv;
@@ -443,39 +390,35 @@ xlog_cil_push(
 	struct xfs_log_iovec	lhdr;
 	struct xfs_log_vec	lvhdr = { NULL };
 	xfs_lsn_t		commit_lsn;
+	xfs_lsn_t		push_seq;
 
 	if (!cil)
 		return 0;
 
-	ASSERT(!push_seq || push_seq <= cil->xc_ctx->sequence);
-
 	new_ctx = kmem_zalloc(sizeof(*new_ctx), KM_SLEEP|KM_NOFS);
 	new_ctx->ticket = xlog_cil_ticket_alloc(log);
 
-	/*
-	 * Lock out transaction commit, but don't block for background pushes
-	 * unless we are well over the CIL space limit. See the definition of
-	 * XLOG_CIL_HARD_SPACE_LIMIT() for the full explanation of the logic
-	 * used here.
-	 */
-	if (!down_write_trylock(&cil->xc_ctx_lock)) {
-		if (!push_seq &&
-		    cil->xc_ctx->space_used < XLOG_CIL_HARD_SPACE_LIMIT(log))
-			goto out_free_ticket;
-		down_write(&cil->xc_ctx_lock);
-	}
+	down_write(&cil->xc_ctx_lock);
 	ctx = cil->xc_ctx;
 
-	/* check if we've anything to push */
-	if (list_empty(&cil->xc_cil))
-		goto out_skip;
+	spin_lock(&cil->xc_cil_lock);
+	push_seq = cil->xc_push_seq;
+	ASSERT(push_seq > 0 && push_seq <= ctx->sequence);
 
-	/* check for spurious background flush */
-	if (!push_seq && cil->xc_ctx->space_used < XLOG_CIL_SPACE_LIMIT(log))
+	/*
+	 * Check if we've anything to push. If there is nothing, then we don't
+	 * move on to a new sequence number and so we have to be able to push
+	 * this sequence again later.
+	 */
+	if (list_empty(&cil->xc_cil)) {
+		cil->xc_push_seq = 0;
+		spin_unlock(&cil->xc_cil_lock);
 		goto out_skip;
+	}
+	spin_unlock(&cil->xc_cil_lock);
 
 	/* check for a previously pushed seqeunce */
-	if (push_seq && push_seq < cil->xc_ctx->sequence)
+	if (push_seq < cil->xc_ctx->sequence)
 		goto out_skip;
 
 	/*
@@ -629,7 +572,6 @@ restart:
 
 out_skip:
 	up_write(&cil->xc_ctx_lock);
-out_free_ticket:
 	xfs_log_ticket_put(new_ctx->ticket);
 	kmem_free(new_ctx);
 	return 0;
@@ -641,6 +583,80 @@ out_abort:
 	return XFS_ERROR(EIO);
 }
 
+static void
+xlog_cil_push_work(
+	struct work_struct	*work)
+{
+	struct xfs_cil		*cil = container_of(work, struct xfs_cil,
+							xc_push_work);
+	xlog_cil_push(cil->xc_log);
+}
+
+/*
+ * We need to push CIL every so often so we don't cache more than we can fit in
+ * the log. The limit really is that a checkpoint can't be more than half the
+ * log (the current checkpoint is not allowed to overwrite the previous
+ * checkpoint), but commit latency and memory usage limit this to a smaller
+ * size.
+ */
+static void
+xlog_cil_push_background(
+	struct log	*log)
+{
+	struct xfs_cil	*cil = log->l_cilp;
+
+	/*
+	 * The cil won't be empty because we are called while holding the
+	 * context lock so whatever we added to the CIL will still be there
+	 */
+	ASSERT(!list_empty(&cil->xc_cil));
+
+	/*
+	 * don't do a background push if we haven't used up all the
+	 * space available yet.
+	 */
+	if (cil->xc_ctx->space_used < XLOG_CIL_SPACE_LIMIT(log))
+		return;
+
+	spin_lock(&cil->xc_cil_lock);
+	cil->xc_push_seq = cil->xc_current_sequence;
+	queue_work(log->l_mp->m_cil_workqueue, &cil->xc_push_work);
+	spin_unlock(&cil->xc_cil_lock);
+
+}
+
+static void
+xlog_cil_push_foreground(
+	struct log	*log,
+	xfs_lsn_t	push_seq)
+{
+	struct xfs_cil	*cil = log->l_cilp;
+
+	if (!cil)
+		return;
+
+	ASSERT(push_seq && push_seq <= cil->xc_current_sequence);
+
+	/* start on any pending background push to minimise wait time on it */
+	flush_work(&cil->xc_push_work);
+
+	/*
+	 * If the CIL is empty or we've already pushed the sequence then
+	 * there's no work we need to do.
+	 */
+	spin_lock(&cil->xc_cil_lock);
+	if (list_empty(&cil->xc_cil) || push_seq <= cil->xc_push_seq) {
+		spin_unlock(&cil->xc_cil_lock);
+		return;
+	}
+
+	cil->xc_push_seq = push_seq;
+	spin_unlock(&cil->xc_cil_lock);
+
+	/* do the push now */
+	xlog_cil_push(log);
+}
+
 /*
  * Commit a transaction with the given vector to the Committed Item List.
  *
@@ -667,7 +683,6 @@ xfs_log_commit_cil(
 {
 	struct log		*log = mp->m_log;
 	int			log_flags = 0;
-	int			push = 0;
 	struct xfs_log_vec	*log_vector;
 
 	if (flags & XFS_TRANS_RELEASE_LOG_RES)
@@ -719,21 +734,9 @@ xfs_log_commit_cil(
 	 */
 	xfs_trans_free_items(tp, *commit_lsn, 0);
 
-	/* check for background commit before unlock */
-	if (log->l_cilp->xc_ctx->space_used > XLOG_CIL_SPACE_LIMIT(log))
-		push = 1;
+	xlog_cil_push_background(log);
 
 	up_read(&log->l_cilp->xc_ctx_lock);
-
-	/*
-	 * We need to push CIL every so often so we don't cache more than we
-	 * can fit in the log. The limit really is that a checkpoint can't be
-	 * more than half the log (the current checkpoint is not allowed to
-	 * overwrite the previous checkpoint), but commit latency and memory
-	 * usage limit this to a smaller size in most cases.
-	 */
-	if (push)
-		xlog_cil_push(log, 0);
 	return 0;
 }
 
@@ -746,9 +749,6 @@ xfs_log_commit_cil(
  *
  * We return the current commit lsn to allow the callers to determine if a
  * iclog flush is necessary following this call.
- *
- * XXX: Initially, just push the CIL unconditionally and return whatever
- * commit lsn is there. It'll be empty, so this is broken for now.
  */
 xfs_lsn_t
 xlog_cil_force_lsn(
@@ -766,8 +766,7 @@ xlog_cil_force_lsn(
 	 * xlog_cil_push() handles racing pushes for the same sequence,
 	 * so no need to deal with it here.
 	 */
-	if (sequence == cil->xc_current_sequence)
-		xlog_cil_push(log, sequence);
+	xlog_cil_push_foreground(log, sequence);
 
 	/*
 	 * See if we can find a previous sequence still committing.
@@ -826,3 +825,57 @@ xfs_log_item_in_current_chkpt(
 		return false;
 	return true;
 }
+
+/*
+ * Perform initial CIL structure initialisation.
+ */
+int
+xlog_cil_init(
+	struct log	*log)
+{
+	struct xfs_cil	*cil;
+	struct xfs_cil_ctx *ctx;
+
+	cil = kmem_zalloc(sizeof(*cil), KM_SLEEP|KM_MAYFAIL);
+	if (!cil)
+		return ENOMEM;
+
+	ctx = kmem_zalloc(sizeof(*ctx), KM_SLEEP|KM_MAYFAIL);
+	if (!ctx) {
+		kmem_free(cil);
+		return ENOMEM;
+	}
+
+	INIT_WORK(&cil->xc_push_work, xlog_cil_push_work);
+	INIT_LIST_HEAD(&cil->xc_cil);
+	INIT_LIST_HEAD(&cil->xc_committing);
+	spin_lock_init(&cil->xc_cil_lock);
+	init_rwsem(&cil->xc_ctx_lock);
+	init_waitqueue_head(&cil->xc_commit_wait);
+
+	INIT_LIST_HEAD(&ctx->committing);
+	INIT_LIST_HEAD(&ctx->busy_extents);
+	ctx->sequence = 1;
+	ctx->cil = cil;
+	cil->xc_ctx = ctx;
+	cil->xc_current_sequence = ctx->sequence;
+
+	cil->xc_log = log;
+	log->l_cilp = cil;
+	return 0;
+}
+
+void
+xlog_cil_destroy(
+	struct log	*log)
+{
+	if (log->l_cilp->xc_ctx) {
+		if (log->l_cilp->xc_ctx->ticket)
+			xfs_log_ticket_put(log->l_cilp->xc_ctx->ticket);
+		kmem_free(log->l_cilp->xc_ctx);
+	}
+
+	ASSERT(list_empty(&log->l_cilp->xc_cil));
+	kmem_free(log->l_cilp);
+}
+
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index 2152900..735ff1e 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -417,6 +417,8 @@ struct xfs_cil {
 	struct list_head	xc_committing;
 	wait_queue_head_t	xc_commit_wait;
 	xfs_lsn_t		xc_current_sequence;
+	struct work_struct	xc_push_work;
+	xfs_lsn_t		xc_push_seq;
 };
 
 /*
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index dbd9d42..401ca2e 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -214,6 +214,7 @@ typedef struct xfs_mount {
 
 	struct workqueue_struct	*m_data_workqueue;
 	struct workqueue_struct	*m_unwritten_workqueue;
+	struct workqueue_struct	*m_cil_workqueue;
 } xfs_mount_t;
 
 /*
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index eb19efb..21db0d5 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -773,8 +773,14 @@ xfs_init_mount_workqueues(
 	if (!mp->m_unwritten_workqueue)
 		goto out_destroy_data_iodone_queue;
 
+	mp->m_cil_workqueue = alloc_workqueue("xfs-cil/%s",
+			WQ_MEM_RECLAIM, 0, mp->m_fsname);
+	if (!mp->m_cil_workqueue)
+		goto out_destroy_unwritten;
 	return 0;
 
+out_destroy_unwritten:
+	destroy_workqueue(mp->m_unwritten_workqueue);
 out_destroy_data_iodone_queue:
 	destroy_workqueue(mp->m_data_workqueue);
 out:
@@ -785,6 +791,7 @@ STATIC void
 xfs_destroy_mount_workqueues(
 	struct xfs_mount	*mp)
 {
+	destroy_workqueue(mp->m_cil_workqueue);
 	destroy_workqueue(mp->m_data_workqueue);
 	destroy_workqueue(mp->m_unwritten_workqueue);
 }
-- 
1.7.9.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
