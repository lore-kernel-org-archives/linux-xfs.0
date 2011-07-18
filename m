Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6I3nwlh078334 for <xfs@oss.sgi.com>; Sun, 17 Jul 2011 22:49:58 -0500
Received: from ipmail06.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 566F1ECC775
	for <xfs@oss.sgi.com>; Sun, 17 Jul 2011 20:49:55 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	FBlhSCrCAHG4qmYz for <xfs@oss.sgi.com>;
	Sun, 17 Jul 2011 20:49:55 -0700 (PDT)
Received: from chute ([192.168.1.1] helo=disappointment)
	by dastard with esmtp (Exim 4.72)
	(envelope-from <dave@fromorbit.com>) id 1Qieq9-0008Cy-3z
	for xfs@oss.sgi.com; Mon, 18 Jul 2011 13:49:53 +1000
Received: from dave by disappointment with local (Exim 4.76)
	(envelope-from <dave@disappointment.disaster>) id 1Qieq8-0002ha-Sx
	for xfs@oss.sgi.com; Mon, 18 Jul 2011 13:49:52 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 3/3] xfs: flush the CIL via a workqueue
Date: Mon, 18 Jul 2011 13:49:49 +1000
Message-Id: <1310960989-10284-4-git-send-email-david@fromorbit.com>
In-Reply-To: <1310960989-10284-1-git-send-email-david@fromorbit.com>
References: <1310960989-10284-1-git-send-email-david@fromorbit.com>
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

To do this, we need to keep track of the sequence nnumber we have
pushed work for. This avoids having many transaction commits
attempting to schedule work for the same sequence, and ensures that
we only ever have one push (background or forced) in progress at a
time. It also means that we don't need to take the CIL lock in write
mode to check for potential background push races, which reduces
lock contention.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/linux-2.6/xfs_super.c |    7 +
 fs/xfs/xfs_log_cil.c         |  260 +++++++++++++++++++++++++-----------------
 fs/xfs/xfs_log_priv.h        |    4 +
 3 files changed, 166 insertions(+), 105 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_super.c b/fs/xfs/linux-2.6/xfs_super.c
index 6a6d4d9..b3ace86 100644
--- a/fs/xfs/linux-2.6/xfs_super.c
+++ b/fs/xfs/linux-2.6/xfs_super.c
@@ -1683,8 +1683,14 @@ xfs_init_workqueues(void)
 	if (!xfs_alloc_wq)
 		goto out_destroy_ail;
 
+	xfs_cil_wq = alloc_workqueue("xfscil", WQ_MEM_RECLAIM, 8);
+	if (!xfs_ail_wq)
+		goto out_destroy_alloc;
+
 	return 0;
 
+out_destroy_alloc:
+	destroy_workqueue(xfs_alloc_wq);
 out_destroy_ail:
 	destroy_workqueue(xfs_ail_wq);
 out_destroy_syncd:
@@ -1696,6 +1702,7 @@ out:
 STATIC void
 xfs_destroy_workqueues(void)
 {
+	destroy_workqueue(xfs_cil_wq);
 	destroy_workqueue(xfs_ail_wq);
 	destroy_workqueue(xfs_syncd_wq);
 }
diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index c7755d5..9e652d2 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -31,67 +31,7 @@
 #include "xfs_alloc.h"
 #include "xfs_discard.h"
 
-/*
- * Perform initial CIL structure initialisation. If the CIL is not
- * enabled in this filesystem, ensure the log->l_cilp is null so
- * we can check this conditional to determine if we are doing delayed
- * logging or not.
- */
-int
-xlog_cil_init(
-	struct log	*log)
-{
-	struct xfs_cil	*cil;
-	struct xfs_cil_ctx *ctx;
-
-	log->l_cilp = NULL;
-	if (!(log->l_mp->m_flags & XFS_MOUNT_DELAYLOG))
-		return 0;
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
-	if (!log->l_cilp)
-		return;
-
-	if (log->l_cilp->xc_ctx) {
-		if (log->l_cilp->xc_ctx->ticket)
-			xfs_log_ticket_put(log->l_cilp->xc_ctx->ticket);
-		kmem_free(log->l_cilp->xc_ctx);
-	}
-
-	ASSERT(list_empty(&log->l_cilp->xc_cil));
-	kmem_free(log->l_cilp);
-}
+struct workqueue_struct *xfs_cil_wq;
 
 /*
  * Allocate a new ticket. Failing to get a new ticket makes it really hard to
@@ -401,12 +341,58 @@ xlog_cil_committed(
  * get a race between multiple pushes for the same sequence they will block on
  * the first one and then abort, hence avoiding needless pushes.
  */
-STATIC int
+static void
 xlog_cil_push(
-	struct log		*log,
-	xfs_lsn_t		push_seq)
+	struct log	*log,
+	xfs_lsn_t	push_seq)
 {
-	struct xfs_cil		*cil = log->l_cilp;
+	struct xfs_cil	*cil = log->l_cilp;
+
+	if (!cil)
+		return;
+
+	ASSERT(!push_seq || push_seq <= cil->xc_current_sequence);
+
+	/*
+	 * don't do a background push if we haven't used up all the
+	 * space available yet.
+	 */
+	if (!push_seq && cil->xc_ctx->space_used < XLOG_CIL_SPACE_LIMIT(log))
+		return;
+
+	/*
+	 * if we are being asked to push to a specific sequence, and we have
+	 * already queued a larger push, then nothing to do.
+	 */
+	if (push_seq && push_seq <= cil->xc_push_seq)
+		return;
+
+	spin_lock(&cil->xc_cil_lock);
+	if (!push_seq)
+		push_seq = cil->xc_current_sequence;
+
+	/*
+	 * if the CIL is empty,  or we've already pushed the sequence, then
+	 * there's no work we need to do.
+	 */
+	if (list_empty(&cil->xc_cil) || push_seq <= cil->xc_push_seq) {
+		spin_unlock(&cil->xc_cil_lock);
+		return;
+	}
+
+	cil->xc_push_seq = push_seq;
+	queue_work(xfs_cil_wq, &cil->xc_push_work);
+	spin_unlock(&cil->xc_cil_lock);
+
+}
+
+static void
+xlog_cil_push_work(
+	struct work_struct	*work)
+{
+	struct xfs_cil		*cil = container_of(work, struct xfs_cil,
+							xc_push_work);
+	struct log		*log = cil->xc_log;
 	struct xfs_log_vec	*lv;
 	struct xfs_cil_ctx	*ctx;
 	struct xfs_cil_ctx	*new_ctx;
@@ -419,40 +405,34 @@ xlog_cil_push(
 	struct xfs_trans_header thdr;
 	struct xfs_log_iovec	lhdr;
 	struct xfs_log_vec	lvhdr = { NULL };
+	xfs_lsn_t		push_seq;
 	xfs_lsn_t		commit_lsn;
 
-	if (!cil)
-		return 0;
-
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
+	/* Lock out transaction commiti until we've switch contexts */
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
+	if (push_seq < ctx->sequence)
 		goto out_skip;
 
 	/*
@@ -602,20 +582,19 @@ restart:
 	spin_unlock(&cil->xc_cil_lock);
 
 	/* release the hounds! */
-	return xfs_log_release_iclog(log->l_mp, commit_iclog);
+	xfs_log_release_iclog(log->l_mp, commit_iclog);
+	return;
 
 out_skip:
 	up_write(&cil->xc_ctx_lock);
-out_free_ticket:
 	xfs_log_ticket_put(new_ctx->ticket);
 	kmem_free(new_ctx);
-	return 0;
+	return;
 
 out_abort_free_ticket:
 	xfs_log_ticket_put(tic);
 out_abort:
 	xlog_cil_committed(ctx, XFS_LI_ABORTED);
-	return XFS_ERROR(EIO);
 }
 
 /*
@@ -645,7 +624,6 @@ xfs_log_commit_cil(
 {
 	struct log		*log = mp->m_log;
 	int			log_flags = 0;
-	int			push = 0;
 
 	if (flags & XFS_TRANS_RELEASE_LOG_RES)
 		log_flags = XFS_LOG_REL_PERM_RESERV;
@@ -694,12 +672,6 @@ xfs_log_commit_cil(
 	 */
 	xfs_trans_free_items(tp, *commit_lsn, 0);
 
-	/* check for background commit before unlock */
-	if (log->l_cilp->xc_ctx->space_used > XLOG_CIL_SPACE_LIMIT(log))
-		push = 1;
-
-	up_read(&log->l_cilp->xc_ctx_lock);
-
 	/*
 	 * We need to push CIL every so often so we don't cache more than we
 	 * can fit in the log. The limit really is that a checkpoint can't be
@@ -707,8 +679,8 @@ xfs_log_commit_cil(
 	 * overwrite the previous checkpoint), but commit latency and memory
 	 * usage limit this to a smaller size in most cases.
 	 */
-	if (push)
-		xlog_cil_push(log, 0);
+	xlog_cil_push(log, 0);
+	up_read(&log->l_cilp->xc_ctx_lock);
 }
 
 /*
@@ -720,9 +692,6 @@ xfs_log_commit_cil(
  *
  * We return the current commit lsn to allow the callers to determine if a
  * iclog flush is necessary following this call.
- *
- * XXX: Initially, just push the CIL unconditionally and return whatever
- * commit lsn is there. It'll be empty, so this is broken for now.
  */
 xfs_lsn_t
 xlog_cil_force_lsn(
@@ -733,6 +702,8 @@ xlog_cil_force_lsn(
 	struct xfs_cil_ctx	*ctx;
 	xfs_lsn_t		commit_lsn = NULLCOMMITLSN;
 
+	/* lock out background commit */
+	down_read(&log->l_cilp->xc_ctx_lock);
 	ASSERT(sequence <= cil->xc_current_sequence);
 
 	/*
@@ -740,8 +711,23 @@ xlog_cil_force_lsn(
 	 * xlog_cil_push() handles racing pushes for the same sequence,
 	 * so no need to deal with it here.
 	 */
-	if (sequence == cil->xc_current_sequence)
+	if (sequence == cil->xc_current_sequence) {
 		xlog_cil_push(log, sequence);
+		up_read(&log->l_cilp->xc_ctx_lock);
+
+		/*
+		 * We have to block waiting for the push to execute even if we
+		 * didn't push the sequence out as we need to wait for the push
+		 * to get queued into the committing list. Once it is in the
+		 * committing list, we can harvest the commit_lsn of the
+		 * checkpoint issued by the push.
+		 *
+		 * We don't hold the ctx lock while doing this as the push work
+		 * needs to hold it.
+		 */
+		flush_work_sync(&cil->xc_push_work);
+	} else
+		up_read(&log->l_cilp->xc_ctx_lock);
 
 	/*
 	 * See if we can find a previous sequence still committing.
@@ -802,3 +788,67 @@ xfs_log_item_in_current_chkpt(
 		return false;
 	return true;
 }
+
+/*
+ * Perform initial CIL structure initialisation. If the CIL is not
+ * enabled in this filesystem, ensure the log->l_cilp is null so
+ * we can check this conditional to determine if we are doing delayed
+ * logging or not.
+ */
+int
+xlog_cil_init(
+	struct log	*log)
+{
+	struct xfs_cil	*cil;
+	struct xfs_cil_ctx *ctx;
+
+	log->l_cilp = NULL;
+	if (!(log->l_mp->m_flags & XFS_MOUNT_DELAYLOG))
+		return 0;
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
+	if (!log->l_cilp)
+		return;
+
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
index 2d3b6a4..61d55f9 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -417,8 +417,12 @@ struct xfs_cil {
 	struct list_head	xc_committing;
 	wait_queue_head_t	xc_commit_wait;
 	xfs_lsn_t		xc_current_sequence;
+	struct work_struct	xc_push_work;
+	xfs_lsn_t		xc_push_seq;
 };
 
+extern struct workqueue_struct *xfs_cil_wq;
+
 /*
  * The amount of log space we allow the CIL to aggregate is difficult to size.
  * Whatever we choose, we have to make sure we can get a reservation for the
-- 
1.7.5.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
