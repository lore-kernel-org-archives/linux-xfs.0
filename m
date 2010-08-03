Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o73279ro217622 for <xfs@oss.sgi.com>; Mon, 2 Aug 2010 21:07:10 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C73991687749
	for <xfs@oss.sgi.com>; Mon,  2 Aug 2010 19:07:26 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail19.adl2.internode.on.net
	[150.101.137.104]) by cuda.sgi.com with ESMTP id
	uDyTGA8ERe480xcz for <xfs@oss.sgi.com>;
	Mon, 02 Aug 2010 19:07:26 -0700 (PDT)
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH] xfs: Reduce log force overhead for delayed logging
Date: Tue,  3 Aug 2010 12:07:14 +1000
Message-Id: <1280801234-23568-1-git-send-email-david@fromorbit.com>
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
Cc: npiggin@kernel.de

From: Dave Chinner <dchinner@redhat.com>

Delayed logging adds some serialisation to the log force process to
ensure that it does not deference a bad commit context structure
when determining if a CIl push is necessary or not. It does this by
grabing the CIl contrext lock exclusively, then dropping it before
pushing the CIL if necessary. This causes serialisation of all log
forces and pushes regardless of whether a force is necessary or not.
As a result fsync heavy workloads (like dbench) can be significantly
slower with delayed logging than without.

To avoid this penalty, copy the current sequence from the context to
the CIL structure when they are swapped. This allows us to do
unlocked checks on the current sequence without having to worry
about dereferencing context structures that may have already been
freed. Hence we can remove the CIL context locking in the forcing
code and only call into the push code if the current context matches
the sequence we need to force.

By passing the sequence into the push code, we can check the
sequence again once we have the CIL lock held exclusive and abort if
the sequence has already been pushed. This avoids a lock round-trip
and unnecessary CIL pushes when we have racing push calls.

The result is that the regression in dbench performance goes away -
this change improves dbench performance on a ramdisk from ~2100MB/s
to ~2500MB/s. This compares favourably to not using delayed logging
which retuns ~2500MB/s for the same workload.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_log.c      |    6 +-
 fs/xfs/xfs_log_cil.c  |  243 ++++++++++++++++++++++++++-----------------------
 fs/xfs/xfs_log_priv.h |   15 +++-
 3 files changed, 147 insertions(+), 117 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 925d572..88b81f2 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -3015,7 +3015,7 @@ _xfs_log_force(
 
 	XFS_STATS_INC(xs_log_force);
 
-	xlog_cil_push(log, 1);
+	xlog_cil_force(log);
 
 	spin_lock(&log->l_icloglock);
 
@@ -3167,7 +3167,7 @@ _xfs_log_force_lsn(
 	XFS_STATS_INC(xs_log_force);
 
 	if (log->l_cilp) {
-		lsn = xlog_cil_push_lsn(log, lsn);
+		lsn = xlog_cil_force_lsn(log, lsn);
 		if (lsn == NULLCOMMITLSN)
 			return 0;
 	}
@@ -3724,7 +3724,7 @@ xfs_log_force_umount(
 	 * call below.
 	 */
 	if (!logerror && (mp->m_flags & XFS_MOUNT_DELAYLOG))
-		xlog_cil_push(log, 1);
+		xlog_cil_force(log);
 
 	/*
 	 * We must hold both the GRANT lock and the LOG lock,
diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index ef8e7d9..5650a97 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -68,6 +68,7 @@ xlog_cil_init(
 	ctx->sequence = 1;
 	ctx->cil = cil;
 	cil->xc_ctx = ctx;
+	cil->xc_current_sequence = ctx->sequence;
 
 	cil->xc_log = log;
 	log->l_cilp = cil;
@@ -321,94 +322,6 @@ xlog_cil_free_logvec(
 }
 
 /*
- * Commit a transaction with the given vector to the Committed Item List.
- *
- * To do this, we need to format the item, pin it in memory if required and
- * account for the space used by the transaction. Once we have done that we
- * need to release the unused reservation for the transaction, attach the
- * transaction to the checkpoint context so we carry the busy extents through
- * to checkpoint completion, and then unlock all the items in the transaction.
- *
- * For more specific information about the order of operations in
- * xfs_log_commit_cil() please refer to the comments in
- * xfs_trans_commit_iclog().
- *
- * Called with the context lock already held in read mode to lock out
- * background commit, returns without it held once background commits are
- * allowed again.
- */
-int
-xfs_log_commit_cil(
-	struct xfs_mount	*mp,
-	struct xfs_trans	*tp,
-	struct xfs_log_vec	*log_vector,
-	xfs_lsn_t		*commit_lsn,
-	int			flags)
-{
-	struct log		*log = mp->m_log;
-	int			log_flags = 0;
-	int			push = 0;
-
-	if (flags & XFS_TRANS_RELEASE_LOG_RES)
-		log_flags = XFS_LOG_REL_PERM_RESERV;
-
-	if (XLOG_FORCED_SHUTDOWN(log)) {
-		xlog_cil_free_logvec(log_vector);
-		return XFS_ERROR(EIO);
-	}
-
-	/* lock out background commit */
-	down_read(&log->l_cilp->xc_ctx_lock);
-	xlog_cil_format_items(log, log_vector, tp->t_ticket, commit_lsn);
-
-	/* check we didn't blow the reservation */
-	if (tp->t_ticket->t_curr_res < 0)
-		xlog_print_tic_res(log->l_mp, tp->t_ticket);
-
-	/* attach the transaction to the CIL if it has any busy extents */
-	if (!list_empty(&tp->t_busy)) {
-		spin_lock(&log->l_cilp->xc_cil_lock);
-		list_splice_init(&tp->t_busy,
-					&log->l_cilp->xc_ctx->busy_extents);
-		spin_unlock(&log->l_cilp->xc_cil_lock);
-	}
-
-	tp->t_commit_lsn = *commit_lsn;
-	xfs_log_done(mp, tp->t_ticket, NULL, log_flags);
-	xfs_trans_unreserve_and_mod_sb(tp);
-
-	/*
-	 * Once all the items of the transaction have been copied to the CIL,
-	 * the items can be unlocked and freed.
-	 *
-	 * This needs to be done before we drop the CIL context lock because we
-	 * have to update state in the log items and unlock them before they go
-	 * to disk. If we don't, then the CIL checkpoint can race with us and
-	 * we can run checkpoint completion before we've updated and unlocked
-	 * the log items. This affects (at least) processing of stale buffers,
-	 * inodes and EFIs.
-	 */
-	xfs_trans_free_items(tp, *commit_lsn, 0);
-
-	/* check for background commit before unlock */
-	if (log->l_cilp->xc_ctx->space_used > XLOG_CIL_SPACE_LIMIT(log))
-		push = 1;
-
-	up_read(&log->l_cilp->xc_ctx_lock);
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
-	return 0;
-}
-
-/*
  * Mark all items committed and clear busy extents. We free the log vector
  * chains in a separate pass so that we unpin the log items as quickly as
  * possible.
@@ -441,13 +354,23 @@ xlog_cil_committed(
 }
 
 /*
- * Push the Committed Item List to the log. If the push_now flag is not set,
- * then it is a background flush and so we can chose to ignore it.
+ * Push the Committed Item List to the log. If @push_seq flag is zero, then it
+ * is a background flush and so we can chose to ignore it. Otherwise, if the
+ * current sequence is the same as @push_seq we need to do a flush. If
+ * @push_seq is less than the current sequence, then it has already been
+ * flushed and we don't need to do anything - the caller will wait for it to
+ * complete if necessary.
+ *
+ * @push_seq is a value rather than a flag because that allows us to do an
+ * unlocked check of the sequence number for a match. Hence we can allows log
+ * forces to run racily and not issue pushes for the same sequence twice. If we
+ * get a race between multiple pushes for the same sequence they will block on
+ * the first one and then abort, hence avoiding needless pushes.
  */
 int
 xlog_cil_push(
 	struct log		*log,
-	int			push_now)
+	xfs_lsn_t		push_seq)
 {
 	struct xfs_cil		*cil = log->l_cilp;
 	struct xfs_log_vec	*lv;
@@ -467,12 +390,14 @@ xlog_cil_push(
 	if (!cil)
 		return 0;
 
+	ASSERT(!push_seq || push_seq <= cil->xc_ctx->sequence);
+
 	new_ctx = kmem_zalloc(sizeof(*new_ctx), KM_SLEEP|KM_NOFS);
 	new_ctx->ticket = xlog_cil_ticket_alloc(log);
 
 	/* lock out transaction commit, but don't block on background push */
 	if (!down_write_trylock(&cil->xc_ctx_lock)) {
-		if (!push_now)
+		if (!push_seq)
 			goto out_free_ticket;
 		down_write(&cil->xc_ctx_lock);
 	}
@@ -483,7 +408,11 @@ xlog_cil_push(
 		goto out_skip;
 
 	/* check for spurious background flush */
-	if (!push_now && cil->xc_ctx->space_used < XLOG_CIL_SPACE_LIMIT(log))
+	if (!push_seq && cil->xc_ctx->space_used < XLOG_CIL_SPACE_LIMIT(log))
+		goto out_skip;
+
+	/* check for a previously pushed seqeunce */
+	if (push_seq < cil->xc_ctx->sequence)
 		goto out_skip;
 
 	/*
@@ -529,6 +458,13 @@ xlog_cil_push(
 	cil->xc_ctx = new_ctx;
 
 	/*
+	 * mirror the new sequence into the cil structure so that we can do
+	 * unlocked checks against the current sequence in log forces without
+	 * risking deferencing a freed context pointer.
+	 */
+	cil->xc_current_sequence = new_ctx->sequence;
+
+	/*
 	 * The switch is now done, so we can drop the context lock and move out
 	 * of a shared context. We can't just go straight to the commit record,
 	 * though - we need to synchronise with previous and future commits so
@@ -640,6 +576,94 @@ out_abort:
 }
 
 /*
+ * Commit a transaction with the given vector to the Committed Item List.
+ *
+ * To do this, we need to format the item, pin it in memory if required and
+ * account for the space used by the transaction. Once we have done that we
+ * need to release the unused reservation for the transaction, attach the
+ * transaction to the checkpoint context so we carry the busy extents through
+ * to checkpoint completion, and then unlock all the items in the transaction.
+ *
+ * For more specific information about the order of operations in
+ * xfs_log_commit_cil() please refer to the comments in
+ * xfs_trans_commit_iclog().
+ *
+ * Called with the context lock already held in read mode to lock out
+ * background commit, returns without it held once background commits are
+ * allowed again.
+ */
+int
+xfs_log_commit_cil(
+	struct xfs_mount	*mp,
+	struct xfs_trans	*tp,
+	struct xfs_log_vec	*log_vector,
+	xfs_lsn_t		*commit_lsn,
+	int			flags)
+{
+	struct log		*log = mp->m_log;
+	int			log_flags = 0;
+	int			push = 0;
+
+	if (flags & XFS_TRANS_RELEASE_LOG_RES)
+		log_flags = XFS_LOG_REL_PERM_RESERV;
+
+	if (XLOG_FORCED_SHUTDOWN(log)) {
+		xlog_cil_free_logvec(log_vector);
+		return XFS_ERROR(EIO);
+	}
+
+	/* lock out background commit */
+	down_read(&log->l_cilp->xc_ctx_lock);
+	xlog_cil_format_items(log, log_vector, tp->t_ticket, commit_lsn);
+
+	/* check we didn't blow the reservation */
+	if (tp->t_ticket->t_curr_res < 0)
+		xlog_print_tic_res(log->l_mp, tp->t_ticket);
+
+	/* attach the transaction to the CIL if it has any busy extents */
+	if (!list_empty(&tp->t_busy)) {
+		spin_lock(&log->l_cilp->xc_cil_lock);
+		list_splice_init(&tp->t_busy,
+					&log->l_cilp->xc_ctx->busy_extents);
+		spin_unlock(&log->l_cilp->xc_cil_lock);
+	}
+
+	tp->t_commit_lsn = *commit_lsn;
+	xfs_log_done(mp, tp->t_ticket, NULL, log_flags);
+	xfs_trans_unreserve_and_mod_sb(tp);
+
+	/*
+	 * Once all the items of the transaction have been copied to the CIL,
+	 * the items can be unlocked and freed.
+	 *
+	 * This needs to be done before we drop the CIL context lock because we
+	 * have to update state in the log items and unlock them before they go
+	 * to disk. If we don't, then the CIL checkpoint can race with us and
+	 * we can run checkpoint completion before we've updated and unlocked
+	 * the log items. This affects (at least) processing of stale buffers,
+	 * inodes and EFIs.
+	 */
+	xfs_trans_free_items(tp, *commit_lsn, 0);
+
+	/* check for background commit before unlock */
+	if (log->l_cilp->xc_ctx->space_used > XLOG_CIL_SPACE_LIMIT(log))
+		push = 1;
+
+	up_read(&log->l_cilp->xc_ctx_lock);
+
+	/*
+	 * We need to push CIL every so often so we don't cache more than we
+	 * can fit in the log. The limit really is that a checkpoint can't be
+	 * more than half the log (the current checkpoint is not allowed to
+	 * overwrite the previous checkpoint), but commit latency and memory
+	 * usage limit this to a smaller size in most cases.
+	 */
+	if (push)
+		xlog_cil_push(log, 0);
+	return 0;
+}
+
+/*
  * Conditionally push the CIL based on the sequence passed in.
  *
  * We only need to push if we haven't already pushed the sequence
@@ -653,39 +677,34 @@ out_abort:
  * commit lsn is there. It'll be empty, so this is broken for now.
  */
 xfs_lsn_t
-xlog_cil_push_lsn(
+xlog_cil_force_lsn(
 	struct log	*log,
-	xfs_lsn_t	push_seq)
+	xfs_lsn_t	sequence)
 {
 	struct xfs_cil		*cil = log->l_cilp;
 	struct xfs_cil_ctx	*ctx;
 	xfs_lsn_t		commit_lsn = NULLCOMMITLSN;
 
-restart:
-	down_write(&cil->xc_ctx_lock);
-	ASSERT(push_seq <= cil->xc_ctx->sequence);
-
-	/* check to see if we need to force out the current context */
-	if (push_seq == cil->xc_ctx->sequence) {
-		up_write(&cil->xc_ctx_lock);
-		xlog_cil_push(log, 1);
-		goto restart;
-	}
+	ASSERT(sequence <= cil->xc_current_sequence);
+
+	/*
+	 * check to see if we need to force out the current context.
+	 * xlog_cil_push() handles racing pushes for the same sequence,
+	 * so no need to deal with it here.
+	 */
+	if (sequence == cil->xc_current_sequence)
+		xlog_cil_push(log, sequence);
 
 	/*
 	 * See if we can find a previous sequence still committing.
-	 * We can drop the flush lock as soon as we have the cil lock
-	 * because we are now only comparing contexts protected by
-	 * the cil lock.
-	 *
 	 * We need to wait for all previous sequence commits to complete
 	 * before allowing the force of push_seq to go ahead. Hence block
 	 * on commits for those as well.
 	 */
+restart:
 	spin_lock(&cil->xc_cil_lock);
-	up_write(&cil->xc_ctx_lock);
 	list_for_each_entry(ctx, &cil->xc_committing, committing) {
-		if (ctx->sequence > push_seq)
+		if (ctx->sequence > sequence)
 			continue;
 		if (!ctx->commit_lsn) {
 			/*
@@ -695,7 +714,7 @@ restart:
 			sv_wait(&cil->xc_commit_wait, 0, &cil->xc_cil_lock, 0);
 			goto restart;
 		}
-		if (ctx->sequence != push_seq)
+		if (ctx->sequence != sequence)
 			continue;
 		/* found it! */
 		commit_lsn = ctx->commit_lsn;
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index 8c07261..750334d 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -422,6 +422,7 @@ struct xfs_cil {
 	struct rw_semaphore	xc_ctx_lock;
 	struct list_head	xc_committing;
 	sv_t			xc_commit_wait;
+	xfs_lsn_t		xc_current_sequence;
 };
 
 /*
@@ -562,8 +563,18 @@ int	xlog_cil_init(struct log *log);
 void	xlog_cil_init_post_recovery(struct log *log);
 void	xlog_cil_destroy(struct log *log);
 
-int	xlog_cil_push(struct log *log, int push_now);
-xfs_lsn_t xlog_cil_push_lsn(struct log *log, xfs_lsn_t push_sequence);
+/*
+ * CIL force routines
+ */
+xfs_lsn_t xlog_cil_force_lsn(struct log *log, xfs_lsn_t sequence);
+
+static inline void
+xlog_cil_force(struct log	*log)
+{
+	if (log->l_cilp)
+		xlog_cil_force_lsn(log, log->l_cilp->xc_current_sequence);
+}
+
 
 /*
  * Unmount record type is used as a pseudo transaction type for the ticket.
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
