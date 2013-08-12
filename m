Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 9EB907F81
	for <xfs@oss.sgi.com>; Mon, 12 Aug 2013 05:50:58 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 7F13A304043
	for <xfs@oss.sgi.com>; Mon, 12 Aug 2013 03:50:58 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	nmHM1NGjKgOlB8gL for <xfs@oss.sgi.com>;
	Mon, 12 Aug 2013 03:50:56 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1V8phX-0004YA-LN
	for xfs@oss.sgi.com; Mon, 12 Aug 2013 20:50:15 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1V8phX-00064N-Jf
	for xfs@oss.sgi.com; Mon, 12 Aug 2013 20:50:15 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: ***** SUSPECTED SPAM *****  [PATCH 47/50] xfs: split the CIL lock
Date: Mon, 12 Aug 2013 20:50:08 +1000
Message-Id: <1376304611-22994-48-git-send-email-david@fromorbit.com>
In-Reply-To: <1376304611-22994-1-git-send-email-david@fromorbit.com>
References: <1376304611-22994-1-git-send-email-david@fromorbit.com>
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

The xc_cil_lock is used for two purposes - to protect the CIL
itself, and to protect the push/commit state and lists. These are
two logically separate structures and operations, so can have their
own locks. This means that pushing on the CIL and the commit wait
ordering won't contend for a lock with other transactions that are
completing concurrently. As the CIL insertion is the hottest path
throught eh CIL, this is a big win.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Mark Tinguely <tinguely@sgi.com>
---
 fs/xfs/xfs_log_cil.c  | 41 +++++++++++++++++++++--------------------
 fs/xfs/xfs_log_priv.h |  9 ++++++---
 2 files changed, 27 insertions(+), 23 deletions(-)

diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index c1a3384..cfe9797 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -402,9 +402,9 @@ xlog_cil_committed(
 	xfs_extent_busy_clear(mp, &ctx->busy_extents,
 			     (mp->m_flags & XFS_MOUNT_DISCARD) && !abort);
 
-	spin_lock(&ctx->cil->xc_cil_lock);
+	spin_lock(&ctx->cil->xc_push_lock);
 	list_del(&ctx->committing);
-	spin_unlock(&ctx->cil->xc_cil_lock);
+	spin_unlock(&ctx->cil->xc_push_lock);
 
 	xlog_cil_free_logvec(ctx->lv_chain);
 
@@ -459,7 +459,7 @@ xlog_cil_push(
 	down_write(&cil->xc_ctx_lock);
 	ctx = cil->xc_ctx;
 
-	spin_lock(&cil->xc_cil_lock);
+	spin_lock(&cil->xc_push_lock);
 	push_seq = cil->xc_push_seq;
 	ASSERT(push_seq <= ctx->sequence);
 
@@ -470,10 +470,10 @@ xlog_cil_push(
 	 */
 	if (list_empty(&cil->xc_cil)) {
 		cil->xc_push_seq = 0;
-		spin_unlock(&cil->xc_cil_lock);
+		spin_unlock(&cil->xc_push_lock);
 		goto out_skip;
 	}
-	spin_unlock(&cil->xc_cil_lock);
+	spin_unlock(&cil->xc_push_lock);
 
 
 	/* check for a previously pushed seqeunce */
@@ -541,9 +541,9 @@ xlog_cil_push(
 	 * that higher sequences will wait for us to write out a commit record
 	 * before they do.
 	 */
-	spin_lock(&cil->xc_cil_lock);
+	spin_lock(&cil->xc_push_lock);
 	list_add(&ctx->committing, &cil->xc_committing);
-	spin_unlock(&cil->xc_cil_lock);
+	spin_unlock(&cil->xc_push_lock);
 	up_write(&cil->xc_ctx_lock);
 
 	/*
@@ -578,7 +578,7 @@ xlog_cil_push(
 	 * order the commit records so replay will get them in the right order.
 	 */
 restart:
-	spin_lock(&cil->xc_cil_lock);
+	spin_lock(&cil->xc_push_lock);
 	list_for_each_entry(new_ctx, &cil->xc_committing, committing) {
 		/*
 		 * Higher sequences will wait for this one so skip them.
@@ -591,11 +591,11 @@ restart:
 			 * It is still being pushed! Wait for the push to
 			 * complete, then start again from the beginning.
 			 */
-			xlog_wait(&cil->xc_commit_wait, &cil->xc_cil_lock);
+			xlog_wait(&cil->xc_commit_wait, &cil->xc_push_lock);
 			goto restart;
 		}
 	}
-	spin_unlock(&cil->xc_cil_lock);
+	spin_unlock(&cil->xc_push_lock);
 
 	/* xfs_log_done always frees the ticket on error. */
 	commit_lsn = xfs_log_done(log->l_mp, tic, &commit_iclog, 0);
@@ -614,10 +614,10 @@ restart:
 	 * callbacks to the iclog we can assign the commit LSN to the context
 	 * and wake up anyone who is waiting for the commit to complete.
 	 */
-	spin_lock(&cil->xc_cil_lock);
+	spin_lock(&cil->xc_push_lock);
 	ctx->commit_lsn = commit_lsn;
 	wake_up_all(&cil->xc_commit_wait);
-	spin_unlock(&cil->xc_cil_lock);
+	spin_unlock(&cil->xc_push_lock);
 
 	/* release the hounds! */
 	return xfs_log_release_iclog(log->l_mp, commit_iclog);
@@ -670,12 +670,12 @@ xlog_cil_push_background(
 	if (cil->xc_ctx->space_used < XLOG_CIL_SPACE_LIMIT(log))
 		return;
 
-	spin_lock(&cil->xc_cil_lock);
+	spin_lock(&cil->xc_push_lock);
 	if (cil->xc_push_seq < cil->xc_current_sequence) {
 		cil->xc_push_seq = cil->xc_current_sequence;
 		queue_work(log->l_mp->m_cil_workqueue, &cil->xc_push_work);
 	}
-	spin_unlock(&cil->xc_cil_lock);
+	spin_unlock(&cil->xc_push_lock);
 
 }
 
@@ -698,14 +698,14 @@ xlog_cil_push_foreground(
 	 * If the CIL is empty or we've already pushed the sequence then
 	 * there's no work we need to do.
 	 */
-	spin_lock(&cil->xc_cil_lock);
+	spin_lock(&cil->xc_push_lock);
 	if (list_empty(&cil->xc_cil) || push_seq <= cil->xc_push_seq) {
-		spin_unlock(&cil->xc_cil_lock);
+		spin_unlock(&cil->xc_push_lock);
 		return;
 	}
 
 	cil->xc_push_seq = push_seq;
-	spin_unlock(&cil->xc_cil_lock);
+	spin_unlock(&cil->xc_push_lock);
 
 	/* do the push now */
 	xlog_cil_push(log);
@@ -808,7 +808,7 @@ xlog_cil_force_lsn(
 	 * on commits for those as well.
 	 */
 restart:
-	spin_lock(&cil->xc_cil_lock);
+	spin_lock(&cil->xc_push_lock);
 	list_for_each_entry(ctx, &cil->xc_committing, committing) {
 		if (ctx->sequence > sequence)
 			continue;
@@ -817,7 +817,7 @@ restart:
 			 * It is still being pushed! Wait for the push to
 			 * complete, then start again from the beginning.
 			 */
-			xlog_wait(&cil->xc_commit_wait, &cil->xc_cil_lock);
+			xlog_wait(&cil->xc_commit_wait, &cil->xc_push_lock);
 			goto restart;
 		}
 		if (ctx->sequence != sequence)
@@ -825,7 +825,7 @@ restart:
 		/* found it! */
 		commit_lsn = ctx->commit_lsn;
 	}
-	spin_unlock(&cil->xc_cil_lock);
+	spin_unlock(&cil->xc_push_lock);
 	return commit_lsn;
 }
 
@@ -883,6 +883,7 @@ xlog_cil_init(
 	INIT_LIST_HEAD(&cil->xc_cil);
 	INIT_LIST_HEAD(&cil->xc_committing);
 	spin_lock_init(&cil->xc_cil_lock);
+	spin_lock_init(&cil->xc_push_lock);
 	init_rwsem(&cil->xc_ctx_lock);
 	init_waitqueue_head(&cil->xc_commit_wait);
 
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index edd0964..136654b 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -278,14 +278,17 @@ struct xfs_cil {
 	struct xlog		*xc_log;
 	struct list_head	xc_cil;
 	spinlock_t		xc_cil_lock;
+
+	struct rw_semaphore	xc_ctx_lock ____cacheline_aligned_in_smp;
 	struct xfs_cil_ctx	*xc_ctx;
-	struct rw_semaphore	xc_ctx_lock;
+
+	spinlock_t		xc_push_lock ____cacheline_aligned_in_smp;
+	xfs_lsn_t		xc_push_seq;
 	struct list_head	xc_committing;
 	wait_queue_head_t	xc_commit_wait;
 	xfs_lsn_t		xc_current_sequence;
 	struct work_struct	xc_push_work;
-	xfs_lsn_t		xc_push_seq;
-};
+} ____cacheline_aligned_in_smp;
 
 /*
  * The amount of log space we allow the CIL to aggregate is difficult to size.
-- 
1.8.3.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
