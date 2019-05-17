Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:44106 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728365AbfEQHch (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 May 2019 03:32:37 -0400
Received: from 089144210233.atnat0019.highway.a1.net ([89.144.210.233] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hRXM4-0000mP-0q
        for linux-xfs@vger.kernel.org; Fri, 17 May 2019 07:32:36 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 11/20] xfs: use a list_head for iclog callbacks
Date: Fri, 17 May 2019 09:31:10 +0200
Message-Id: <20190517073119.30178-12-hch@lst.de>
In-Reply-To: <20190517073119.30178-1-hch@lst.de>
References: <20190517073119.30178-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Replace the hand grown linked list handling and cil context attachment
with the standard list_head structure.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_log.c      | 51 ++++++++-----------------------------------
 fs/xfs/xfs_log.h      | 15 +++----------
 fs/xfs/xfs_log_cil.c  | 31 ++++++++++++++++++++------
 fs/xfs/xfs_log_priv.h | 10 +++------
 4 files changed, 39 insertions(+), 68 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 1eb0938165fc..0d6fb374dbe8 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -538,32 +538,6 @@ xfs_log_done(
 	return lsn;
 }
 
-/*
- * Attaches a new iclog I/O completion callback routine during
- * transaction commit.  If the log is in error state, a non-zero
- * return code is handed back and the caller is responsible for
- * executing the callback at an appropriate time.
- */
-int
-xfs_log_notify(
-	struct xlog_in_core	*iclog,
-	xfs_log_callback_t	*cb)
-{
-	int	abortflg;
-
-	spin_lock(&iclog->ic_callback_lock);
-	abortflg = (iclog->ic_state & XLOG_STATE_IOERROR);
-	if (!abortflg) {
-		ASSERT_ALWAYS((iclog->ic_state == XLOG_STATE_ACTIVE) ||
-			      (iclog->ic_state == XLOG_STATE_WANT_SYNC));
-		cb->cb_next = NULL;
-		*(iclog->ic_callback_tail) = cb;
-		iclog->ic_callback_tail = &(cb->cb_next);
-	}
-	spin_unlock(&iclog->ic_callback_lock);
-	return abortflg;
-}
-
 int
 xfs_log_release_iclog(
 	struct xfs_mount	*mp,
@@ -1554,7 +1528,7 @@ xlog_alloc_log(
 		iclog->ic_log = log;
 		atomic_set(&iclog->ic_refcnt, 0);
 		spin_lock_init(&iclog->ic_callback_lock);
-		iclog->ic_callback_tail = &(iclog->ic_callback);
+		INIT_LIST_HEAD(&iclog->ic_callbacks);
 		iclog->ic_datap = (char *)iclog->ic_data + log->l_iclog_hsize;
 
 		init_waitqueue_head(&iclog->ic_force_wait);
@@ -2600,7 +2574,7 @@ xlog_state_clean_log(
 		if (iclog->ic_state == XLOG_STATE_DIRTY) {
 			iclog->ic_state	= XLOG_STATE_ACTIVE;
 			iclog->ic_offset       = 0;
-			ASSERT(iclog->ic_callback == NULL);
+			ASSERT(list_empty_careful(&iclog->ic_callbacks));
 			/*
 			 * If the number of ops in this iclog indicate it just
 			 * contains the dummy transaction, we can
@@ -2700,7 +2674,6 @@ xlog_state_do_callback(
 	xlog_in_core_t	   *iclog;
 	xlog_in_core_t	   *first_iclog;	/* used to know when we've
 						 * processed all iclogs once */
-	xfs_log_callback_t *cb, *cb_next;
 	int		   flushcnt = 0;
 	xfs_lsn_t	   lowest_lsn;
 	int		   ioerrors;	/* counter: iclogs with errors */
@@ -2811,7 +2784,7 @@ xlog_state_do_callback(
 				 */
 				ASSERT(XFS_LSN_CMP(atomic64_read(&log->l_last_sync_lsn),
 					be64_to_cpu(iclog->ic_header.h_lsn)) <= 0);
-				if (iclog->ic_callback)
+				if (!list_empty_careful(&iclog->ic_callbacks))
 					atomic64_set(&log->l_last_sync_lsn,
 						be64_to_cpu(iclog->ic_header.h_lsn));
 
@@ -2828,26 +2801,20 @@ xlog_state_do_callback(
 			 * callbacks being added.
 			 */
 			spin_lock(&iclog->ic_callback_lock);
-			cb = iclog->ic_callback;
-			while (cb) {
-				iclog->ic_callback_tail = &(iclog->ic_callback);
-				iclog->ic_callback = NULL;
-				spin_unlock(&iclog->ic_callback_lock);
+			while (!list_empty(&iclog->ic_callbacks)) {
+				LIST_HEAD(tmp);
 
-				/* perform callbacks in the order given */
-				for (; cb; cb = cb_next) {
-					cb_next = cb->cb_next;
-					cb->cb_func(cb->cb_arg, aborted);
-				}
+				list_splice_init(&iclog->ic_callbacks, &tmp);
+
+				spin_unlock(&iclog->ic_callback_lock);
+				xlog_cil_process_commited(&tmp, aborted);
 				spin_lock(&iclog->ic_callback_lock);
-				cb = iclog->ic_callback;
 			}
 
 			loopdidcallbacks++;
 			funcdidcallbacks++;
 
 			spin_lock(&log->l_icloglock);
-			ASSERT(iclog->ic_callback == NULL);
 			spin_unlock(&iclog->ic_callback_lock);
 			if (!(iclog->ic_state & XLOG_STATE_IOERROR))
 				iclog->ic_state = XLOG_STATE_DIRTY;
diff --git a/fs/xfs/xfs_log.h b/fs/xfs/xfs_log.h
index 4450a2a26a1a..fac46af28cf5 100644
--- a/fs/xfs/xfs_log.h
+++ b/fs/xfs/xfs_log.h
@@ -6,6 +6,8 @@
 #ifndef	__XFS_LOG_H__
 #define __XFS_LOG_H__
 
+struct xfs_cil_ctx;
+
 struct xfs_log_vec {
 	struct xfs_log_vec	*lv_next;	/* next lv in build list */
 	int			lv_niovecs;	/* number of iovecs in lv */
@@ -71,16 +73,6 @@ xlog_copy_iovec(struct xfs_log_vec *lv, struct xfs_log_iovec **vecp,
 	return buf;
 }
 
-/*
- * Structure used to pass callback function and the function's argument
- * to the log manager.
- */
-typedef struct xfs_log_callback {
-	struct xfs_log_callback	*cb_next;
-	void			(*cb_func)(void *, bool);
-	void			*cb_arg;
-} xfs_log_callback_t;
-
 /*
  * By comparing each component, we don't have to worry about extra
  * endian issues in treating two 32 bit numbers as one 64 bit number
@@ -129,8 +121,6 @@ int	xfs_log_mount_cancel(struct xfs_mount *);
 xfs_lsn_t xlog_assign_tail_lsn(struct xfs_mount *mp);
 xfs_lsn_t xlog_assign_tail_lsn_locked(struct xfs_mount *mp);
 void	  xfs_log_space_wake(struct xfs_mount *mp);
-int	  xfs_log_notify(struct xlog_in_core	*iclog,
-			 struct xfs_log_callback *callback_entry);
 int	  xfs_log_release_iclog(struct xfs_mount *mp,
 			 struct xlog_in_core	 *iclog);
 int	  xfs_log_reserve(struct xfs_mount *mp,
@@ -148,6 +138,7 @@ void	  xfs_log_ticket_put(struct xlog_ticket *ticket);
 
 void	xfs_log_commit_cil(struct xfs_mount *mp, struct xfs_trans *tp,
 				xfs_lsn_t *commit_lsn, bool regrant);
+void	xlog_cil_process_commited(struct list_head *list, bool aborted);
 bool	xfs_log_item_in_current_chkpt(struct xfs_log_item *lip);
 
 void	xfs_log_work_queue(struct xfs_mount *mp);
diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index 4cb459f21ad4..b6b30b8e22af 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -577,10 +577,9 @@ xlog_discard_busy_extents(
  */
 static void
 xlog_cil_committed(
-	void	*args,
-	bool	abort)
+	struct xfs_cil_ctx	*ctx,
+	bool			abort)
 {
-	struct xfs_cil_ctx	*ctx = args;
 	struct xfs_mount	*mp = ctx->cil->xc_log->l_mp;
 
 	/*
@@ -615,6 +614,20 @@ xlog_cil_committed(
 		kmem_free(ctx);
 }
 
+void
+xlog_cil_process_commited(
+	struct list_head	*list,
+	bool			aborted)
+{
+	struct xfs_cil_ctx	*ctx;
+
+	while ((ctx = list_first_entry_or_null(list,
+			struct xfs_cil_ctx, iclog_entry))) {
+		list_del(&ctx->iclog_entry);
+		xlog_cil_committed(ctx, aborted);
+	}
+}
+
 /*
  * Push the Committed Item List to the log. If @push_seq flag is zero, then it
  * is a background flush and so we can chose to ignore it. Otherwise, if the
@@ -837,11 +850,15 @@ xlog_cil_push(
 		goto out_abort;
 
 	/* attach all the transactions w/ busy extents to iclog */
-	ctx->log_cb.cb_func = xlog_cil_committed;
-	ctx->log_cb.cb_arg = ctx;
-	error = xfs_log_notify(commit_iclog, &ctx->log_cb);
-	if (error)
+	spin_lock(&commit_iclog->ic_callback_lock);
+	if (commit_iclog->ic_state & XLOG_STATE_IOERROR) {
+		spin_unlock(&commit_iclog->ic_callback_lock);
 		goto out_abort;
+	}
+	ASSERT_ALWAYS(commit_iclog->ic_state == XLOG_STATE_ACTIVE ||
+		      commit_iclog->ic_state == XLOG_STATE_WANT_SYNC);
+	list_add_tail(&ctx->iclog_entry, &commit_iclog->ic_callbacks);
+	spin_unlock(&commit_iclog->ic_callback_lock);
 
 	/*
 	 * now the checkpoint commit is complete and we've attached the
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index b5f82cb36202..5c188ccb8568 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -10,7 +10,6 @@ struct xfs_buf;
 struct xlog;
 struct xlog_ticket;
 struct xfs_mount;
-struct xfs_log_callback;
 
 /*
  * Flags for log structure
@@ -181,8 +180,6 @@ typedef struct xlog_ticket {
  * - ic_next is the pointer to the next iclog in the ring.
  * - ic_bp is a pointer to the buffer used to write this incore log to disk.
  * - ic_log is a pointer back to the global log structure.
- * - ic_callback is a linked list of callback function/argument pairs to be
- *	called after an iclog finishes writing.
  * - ic_size is the full size of the header plus data.
  * - ic_offset is the current number of bytes written to in this iclog.
  * - ic_refcnt is bumped when someone is writing to the log.
@@ -193,7 +190,7 @@ typedef struct xlog_ticket {
  * structure cacheline aligned. The following fields can be contended on
  * by independent processes:
  *
- *	- ic_callback_*
+ *	- ic_callbacks
  *	- ic_refcnt
  *	- fields protected by the global l_icloglock
  *
@@ -216,8 +213,7 @@ typedef struct xlog_in_core {
 
 	/* Callback structures need their own cacheline */
 	spinlock_t		ic_callback_lock ____cacheline_aligned_in_smp;
-	struct xfs_log_callback	*ic_callback;
-	struct xfs_log_callback	**ic_callback_tail;
+	struct list_head	ic_callbacks;
 
 	/* reference counts need their own cacheline */
 	atomic_t		ic_refcnt ____cacheline_aligned_in_smp;
@@ -243,7 +239,7 @@ struct xfs_cil_ctx {
 	int			space_used;	/* aggregate size of regions */
 	struct list_head	busy_extents;	/* busy extents in chkpt */
 	struct xfs_log_vec	*lv_chain;	/* logvecs being pushed */
-	struct xfs_log_callback	log_cb;		/* completion callback hook. */
+	struct list_head	iclog_entry;
 	struct list_head	committing;	/* ctx committing list */
 	struct work_struct	discard_endio_work;
 };
-- 
2.20.1
