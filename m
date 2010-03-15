Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o2F2Xwwm004816 for <xfs@oss.sgi.com>; Sun, 14 Mar 2010 21:33:58 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2562B142D329
	for <xfs@oss.sgi.com>; Sun, 14 Mar 2010 19:35:32 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail17.adl2.internode.on.net
	[150.101.137.102]) by cuda.sgi.com with ESMTP id
	ehG7fFFzCvHLFnNc for <xfs@oss.sgi.com>;
	Sun, 14 Mar 2010 19:35:32 -0700 (PDT)
Received: from dastard (unverified [121.44.103.80])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	16864291-1927428
	for <xfs@oss.sgi.com>; Mon, 15 Mar 2010 13:05:28 +1030 (CDT)
Received: from disturbed ([192.168.1.9]) by dastard with esmtp (Exim 4.71)
	(envelope-from <dave@fromorbit.com>) id 1Nr09M-00016O-Go
	for xfs@oss.sgi.com; Mon, 15 Mar 2010 13:35:24 +1100
Received: from dave by disturbed with local (Exim 4.71)
	(envelope-from <dave@disturbed.disaster>) id 1Nr09B-0002pc-OL
	for xfs@oss.sgi.com; Mon, 15 Mar 2010 13:35:13 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 5/9] xfs: split out iclog writing from xfs_trans_commit()
Date: Mon, 15 Mar 2010 13:35:02 +1100
Message-Id: <1268620506-10799-6-git-send-email-david@fromorbit.com>
In-Reply-To: <1268620506-10799-1-git-send-email-david@fromorbit.com>
References: <1268620506-10799-1-git-send-email-david@fromorbit.com>
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

Split the the part of xfs_trans_commit() that deals with writing the
transaction into the iclog into a separate function. This isolates the
physical commit process from the logical commit operation and makes
it easier to insert different transaction commit paths without affecting
the existing algorithm adversely.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_trans.c |  387 +++++++++++++++++++++++++++-------------------------
 1 files changed, 199 insertions(+), 188 deletions(-)

diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 6962f2b..e07b329 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -47,8 +47,6 @@
 
 
 STATIC void	xfs_trans_apply_sb_deltas(xfs_trans_t *);
-STATIC uint	xfs_trans_count_vecs(xfs_trans_t *);
-STATIC void	xfs_trans_fill_vecs(xfs_trans_t *, xfs_log_iovec_t *);
 STATIC void	xfs_trans_uncommit(xfs_trans_t *, uint);
 STATIC void	xfs_trans_committed(xfs_trans_t *, int);
 STATIC void	xfs_trans_chunk_committed(xfs_log_item_chunk_t *, xfs_lsn_t, int);
@@ -764,94 +762,126 @@ xfs_trans_unreserve_and_mod_sb(
 	}
 }
 
-
 /*
- * xfs_trans_commit
- *
- * Commit the given transaction to the log a/synchronously.
- *
- * XFS disk error handling mechanism is not based on a typical
- * transaction abort mechanism. Logically after the filesystem
- * gets marked 'SHUTDOWN', we can't let any new transactions
- * be durable - ie. committed to disk - because some metadata might
- * be inconsistent. In such cases, this returns an error, and the
- * caller may assume that all locked objects joined to the transaction
- * have already been unlocked as if the commit had succeeded.
- * Do not reference the transaction structure after this call.
+ * Total up the number of log iovecs needed to commit this
+ * transaction.  The transaction itself needs one for the
+ * transaction header.  Ask each dirty item in turn how many
+ * it needs to get the total.
  */
- /*ARGSUSED*/
-int
-_xfs_trans_commit(
-	xfs_trans_t	*tp,
-	uint		flags,
-	int		*log_flushed)
+static uint
+xfs_trans_count_vecs(
+	xfs_trans_t	*tp)
 {
-	xfs_log_iovec_t		*log_vector;
-	int			nvec;
-	xfs_mount_t		*mp;
-	xfs_lsn_t		commit_lsn;
-	/* REFERENCED */
-	int			error;
-	int			log_flags;
-	int			sync;
-#define	XFS_TRANS_LOGVEC_COUNT	16
-	xfs_log_iovec_t		log_vector_fast[XFS_TRANS_LOGVEC_COUNT];
-	struct xlog_in_core	*commit_iclog;
-	int			shutdown;
+	int			nvecs;
+	xfs_log_item_desc_t	*lidp;
 
-	commit_lsn = -1;
+	nvecs = 1;
+	lidp = xfs_trans_first_item(tp);
+	ASSERT(lidp != NULL);
 
-	/*
-	 * Determine whether this commit is releasing a permanent
-	 * log reservation or not.
+	/* In the non-debug case we need to start bailing out if we
+	 * didn't find a log_item here, return zero and let trans_commit
+	 * deal with it.
 	 */
-	if (flags & XFS_TRANS_RELEASE_LOG_RES) {
-		ASSERT(tp->t_flags & XFS_TRANS_PERM_LOG_RES);
-		log_flags = XFS_LOG_REL_PERM_RESERV;
-	} else {
-		log_flags = 0;
+	if (lidp == NULL)
+		return 0;
+
+	while (lidp != NULL) {
+		/*
+		 * Skip items which aren't dirty in this transaction.
+		 */
+		if (!(lidp->lid_flags & XFS_LID_DIRTY)) {
+			lidp = xfs_trans_next_item(tp, lidp);
+			continue;
+		}
+		lidp->lid_size = IOP_SIZE(lidp->lid_item);
+		nvecs += lidp->lid_size;
+		lidp = xfs_trans_next_item(tp, lidp);
 	}
-	mp = tp->t_mountp;
+
+	return nvecs;
+}
+
+/*
+ * Fill in the vector with pointers to data to be logged
+ * by this transaction.  The transaction header takes
+ * the first vector, and then each dirty item takes the
+ * number of vectors it indicated it needed in xfs_trans_count_vecs().
+ *
+ * As each item fills in the entries it needs, also pin the item
+ * so that it cannot be flushed out until the log write completes.
+ */
+static void
+xfs_trans_fill_vecs(
+	struct xfs_trans	*tp,
+	struct xfs_log_iovec	*log_vector)
+{
+	xfs_log_item_desc_t	*lidp;
+	struct xfs_log_iovec	*vecp;
+	uint			nitems;
 
 	/*
-	 * If there is nothing to be logged by the transaction,
-	 * then unlock all of the items associated with the
-	 * transaction and free the transaction structure.
-	 * Also make sure to return any reserved blocks to
-	 * the free pool.
+	 * Skip over the entry for the transaction header, we'll
+	 * fill that in at the end.
 	 */
-shut_us_down:
-	shutdown = XFS_FORCED_SHUTDOWN(mp) ? EIO : 0;
-	if (!(tp->t_flags & XFS_TRANS_DIRTY) || shutdown) {
-		xfs_trans_unreserve_and_mod_sb(tp);
+	vecp = log_vector + 1;
+
+	nitems = 0;
+	lidp = xfs_trans_first_item(tp);
+	ASSERT(lidp);
+	while (lidp) {
+		/* Skip items which aren't dirty in this transaction. */
+		if (!(lidp->lid_flags & XFS_LID_DIRTY)) {
+			lidp = xfs_trans_next_item(tp, lidp);
+			continue;
+		}
+
 		/*
-		 * It is indeed possible for the transaction to be
-		 * not dirty but the dqinfo portion to be. All that
-		 * means is that we have some (non-persistent) quota
-		 * reservations that need to be unreserved.
+		 * The item may be marked dirty but not log anything.  This can
+		 * be used to get called when a transaction is committed.
 		 */
-		xfs_trans_unreserve_and_mod_dquots(tp);
-		if (tp->t_ticket) {
-			commit_lsn = xfs_log_done(mp, tp->t_ticket,
-							NULL, log_flags);
-			if (commit_lsn == -1 && !shutdown)
-				shutdown = XFS_ERROR(EIO);
-		}
-		current_restore_flags_nested(&tp->t_pflags, PF_FSTRANS);
-		xfs_trans_free_items(tp, shutdown? XFS_TRANS_ABORT : 0);
-		xfs_trans_free_busy(tp);
-		xfs_trans_free(tp);
-		XFS_STATS_INC(xs_trans_empty);
-		return (shutdown);
+		if (lidp->lid_size)
+			nitems++;
+		IOP_FORMAT(lidp->lid_item, vecp);
+		vecp += lidp->lid_size;
+		IOP_PIN(lidp->lid_item);
+		lidp = xfs_trans_next_item(tp, lidp);
 	}
-	ASSERT(tp->t_ticket != NULL);
 
 	/*
-	 * If we need to update the superblock, then do it now.
+	 * Now that we've counted the number of items in this transaction, fill
+	 * in the transaction header. Note that the transaction header does not
+	 * have a log item.
 	 */
-	if (tp->t_flags & XFS_TRANS_SB_DIRTY)
-		xfs_trans_apply_sb_deltas(tp);
-	xfs_trans_apply_dquot_deltas(tp);
+	tp->t_header.th_magic = XFS_TRANS_HEADER_MAGIC;
+	tp->t_header.th_type = tp->t_type;
+	tp->t_header.th_num_items = nitems;
+	log_vector->i_addr = (xfs_caddr_t)&tp->t_header;
+	log_vector->i_len = sizeof(xfs_trans_header_t);
+	log_vector->i_type = XLOG_REG_TYPE_TRANSHDR;
+}
+
+/*
+ * Format the transaction direct to the iclog. This isolates the physical
+ * transaction commit operation from the logical operation and hence allows
+ * other methods to be introduced without affecting the existing commit path.
+ */
+static int
+xfs_trans_commit_iclog(
+	struct xfs_mount	*mp,
+	struct xfs_trans	*tp,
+	xfs_lsn_t		*commit_lsn,
+	int			flags)
+{
+	int			shutdown;
+	int			error;
+	int			log_flags = 0;
+	struct xlog_in_core	*commit_iclog;
+#define XFS_TRANS_LOGVEC_COUNT  16
+	struct xfs_log_iovec	log_vector_fast[XFS_TRANS_LOGVEC_COUNT];
+	struct xfs_log_iovec	*log_vector;
+	uint			nvec;
+
 
 	/*
 	 * Ask each log item how many log_vector entries it will
@@ -861,8 +891,7 @@ shut_us_down:
 	 */
 	nvec = xfs_trans_count_vecs(tp);
 	if (nvec == 0) {
-		xfs_force_shutdown(mp, SHUTDOWN_LOG_IO_ERROR);
-		goto shut_us_down;
+		return ENOMEM;	/* triggers a shutdown! */
 	} else if (nvec <= XFS_TRANS_LOGVEC_COUNT) {
 		log_vector = log_vector_fast;
 	} else {
@@ -877,6 +906,9 @@ shut_us_down:
 	 */
 	xfs_trans_fill_vecs(tp, log_vector);
 
+	if (flags & XFS_TRANS_RELEASE_LOG_RES)
+		log_flags = XFS_LOG_REL_PERM_RESERV;
+
 	error = xfs_log_write(mp, log_vector, nvec, tp->t_ticket, &(tp->t_lsn));
 
 	/*
@@ -884,18 +916,17 @@ shut_us_down:
 	 * at any time after this call.  However, all the items associated
 	 * with the transaction are still locked and pinned in memory.
 	 */
-	commit_lsn = xfs_log_done(mp, tp->t_ticket, &commit_iclog, log_flags);
+	*commit_lsn = xfs_log_done(mp, tp->t_ticket, &commit_iclog, log_flags);
 
-	tp->t_commit_lsn = commit_lsn;
-	if (nvec > XFS_TRANS_LOGVEC_COUNT) {
+	tp->t_commit_lsn = *commit_lsn;
+	if (nvec > XFS_TRANS_LOGVEC_COUNT)
 		kmem_free(log_vector);
-	}
 
 	/*
 	 * If we got a log write error. Unpin the logitems that we
 	 * had pinned, clean up, free trans structure, and return error.
 	 */
-	if (error || commit_lsn == -1) {
+	if (error || *commit_lsn == -1) {
 		current_restore_flags_nested(&tp->t_pflags, PF_FSTRANS);
 		xfs_trans_uncommit(tp, flags|XFS_TRANS_ABORT);
 		return XFS_ERROR(EIO);
@@ -909,8 +940,6 @@ shut_us_down:
 	 */
 	xfs_trans_unreserve_and_mod_sb(tp);
 
-	sync = tp->t_flags & XFS_TRANS_SYNC;
-
 	/*
 	 * Tell the LM to call the transaction completion routine
 	 * when the log write with LSN commit_lsn completes (e.g.
@@ -953,7 +982,7 @@ shut_us_down:
 	 * the commit lsn of this transaction for dependency tracking
 	 * purposes.
 	 */
-	xfs_trans_unlock_items(tp, commit_lsn);
+	xfs_trans_unlock_items(tp, *commit_lsn);
 
 	/*
 	 * If we detected a log error earlier, finish committing
@@ -973,7 +1002,92 @@ shut_us_down:
 	 * and the items are released we can finally allow the iclog to
 	 * go to disk.
 	 */
-	error = xfs_log_release_iclog(mp, commit_iclog);
+	return xfs_log_release_iclog(mp, commit_iclog);
+}
+
+
+/*
+ * xfs_trans_commit
+ *
+ * Commit the given transaction to the log a/synchronously.
+ *
+ * XFS disk error handling mechanism is not based on a typical
+ * transaction abort mechanism. Logically after the filesystem
+ * gets marked 'SHUTDOWN', we can't let any new transactions
+ * be durable - ie. committed to disk - because some metadata might
+ * be inconsistent. In such cases, this returns an error, and the
+ * caller may assume that all locked objects joined to the transaction
+ * have already been unlocked as if the commit had succeeded.
+ * Do not reference the transaction structure after this call.
+ */
+ /*ARGSUSED*/
+int
+_xfs_trans_commit(
+	xfs_trans_t	*tp,
+	uint		flags,
+	int		*log_flushed)
+{
+	xfs_mount_t		*mp = tp->t_mountp;
+	xfs_lsn_t		commit_lsn = -1;
+	int			error;
+	int			log_flags = 0;
+	int			sync = tp->t_flags & XFS_TRANS_SYNC;
+	int			shutdown;
+
+	/*
+	 * Determine whether this commit is releasing a permanent
+	 * log reservation or not.
+	 */
+	if (flags & XFS_TRANS_RELEASE_LOG_RES) {
+		ASSERT(tp->t_flags & XFS_TRANS_PERM_LOG_RES);
+		log_flags = XFS_LOG_REL_PERM_RESERV;
+	}
+
+	/*
+	 * If there is nothing to be logged by the transaction,
+	 * then unlock all of the items associated with the
+	 * transaction and free the transaction structure.
+	 * Also make sure to return any reserved blocks to
+	 * the free pool.
+	 */
+shut_us_down:
+	shutdown = XFS_FORCED_SHUTDOWN(mp) ? EIO : 0;
+	if (!(tp->t_flags & XFS_TRANS_DIRTY) || shutdown) {
+		xfs_trans_unreserve_and_mod_sb(tp);
+		/*
+		 * It is indeed possible for the transaction to be
+		 * not dirty but the dqinfo portion to be. All that
+		 * means is that we have some (non-persistent) quota
+		 * reservations that need to be unreserved.
+		 */
+		xfs_trans_unreserve_and_mod_dquots(tp);
+		if (tp->t_ticket) {
+			commit_lsn = xfs_log_done(mp, tp->t_ticket,
+							NULL, log_flags);
+			if (commit_lsn == -1 && !shutdown)
+				shutdown = XFS_ERROR(EIO);
+		}
+		current_restore_flags_nested(&tp->t_pflags, PF_FSTRANS);
+		xfs_trans_free_items(tp, shutdown? XFS_TRANS_ABORT : 0);
+		xfs_trans_free_busy(tp);
+		xfs_trans_free(tp);
+		XFS_STATS_INC(xs_trans_empty);
+		return (shutdown);
+	}
+	ASSERT(tp->t_ticket != NULL);
+
+	/*
+	 * If we need to update the superblock, then do it now.
+	 */
+	if (tp->t_flags & XFS_TRANS_SB_DIRTY)
+		xfs_trans_apply_sb_deltas(tp);
+	xfs_trans_apply_dquot_deltas(tp);
+
+	error = xfs_trans_commit_iclog(mp, tp, &commit_lsn, flags);
+	if (error == ENOMEM) {
+		xfs_force_shutdown(mp, SHUTDOWN_LOG_IO_ERROR);
+		goto shut_us_down;
+	}
 
 	/*
 	 * If the transaction needs to be synchronous, then force the
@@ -992,47 +1106,6 @@ shut_us_down:
 	return (error);
 }
 
-
-/*
- * Total up the number of log iovecs needed to commit this
- * transaction.  The transaction itself needs one for the
- * transaction header.  Ask each dirty item in turn how many
- * it needs to get the total.
- */
-STATIC uint
-xfs_trans_count_vecs(
-	xfs_trans_t	*tp)
-{
-	int			nvecs;
-	xfs_log_item_desc_t	*lidp;
-
-	nvecs = 1;
-	lidp = xfs_trans_first_item(tp);
-	ASSERT(lidp != NULL);
-
-	/* In the non-debug case we need to start bailing out if we
-	 * didn't find a log_item here, return zero and let trans_commit
-	 * deal with it.
-	 */
-	if (lidp == NULL)
-		return 0;
-
-	while (lidp != NULL) {
-		/*
-		 * Skip items which aren't dirty in this transaction.
-		 */
-		if (!(lidp->lid_flags & XFS_LID_DIRTY)) {
-			lidp = xfs_trans_next_item(tp, lidp);
-			continue;
-		}
-		lidp->lid_size = IOP_SIZE(lidp->lid_item);
-		nvecs += lidp->lid_size;
-		lidp = xfs_trans_next_item(tp, lidp);
-	}
-
-	return nvecs;
-}
-
 /*
  * Called from the trans_commit code when we notice that
  * the filesystem is in the middle of a forced shutdown.
@@ -1063,68 +1136,6 @@ xfs_trans_uncommit(
 }
 
 /*
- * Fill in the vector with pointers to data to be logged
- * by this transaction.  The transaction header takes
- * the first vector, and then each dirty item takes the
- * number of vectors it indicated it needed in xfs_trans_count_vecs().
- *
- * As each item fills in the entries it needs, also pin the item
- * so that it cannot be flushed out until the log write completes.
- */
-STATIC void
-xfs_trans_fill_vecs(
-	xfs_trans_t		*tp,
-	xfs_log_iovec_t		*log_vector)
-{
-	xfs_log_item_desc_t	*lidp;
-	xfs_log_iovec_t		*vecp;
-	uint			nitems;
-
-	/*
-	 * Skip over the entry for the transaction header, we'll
-	 * fill that in at the end.
-	 */
-	vecp = log_vector + 1;		/* pointer arithmetic */
-
-	nitems = 0;
-	lidp = xfs_trans_first_item(tp);
-	ASSERT(lidp != NULL);
-	while (lidp != NULL) {
-		/*
-		 * Skip items which aren't dirty in this transaction.
-		 */
-		if (!(lidp->lid_flags & XFS_LID_DIRTY)) {
-			lidp = xfs_trans_next_item(tp, lidp);
-			continue;
-		}
-		/*
-		 * The item may be marked dirty but not log anything.
-		 * This can be used to get called when a transaction
-		 * is committed.
-		 */
-		if (lidp->lid_size) {
-			nitems++;
-		}
-		IOP_FORMAT(lidp->lid_item, vecp);
-		vecp += lidp->lid_size;		/* pointer arithmetic */
-		IOP_PIN(lidp->lid_item);
-		lidp = xfs_trans_next_item(tp, lidp);
-	}
-
-	/*
-	 * Now that we've counted the number of items in this
-	 * transaction, fill in the transaction header.
-	 */
-	tp->t_header.th_magic = XFS_TRANS_HEADER_MAGIC;
-	tp->t_header.th_type = tp->t_type;
-	tp->t_header.th_num_items = nitems;
-	log_vector->i_addr = (xfs_caddr_t)&tp->t_header;
-	log_vector->i_len = sizeof(xfs_trans_header_t);
-	log_vector->i_type = XLOG_REG_TYPE_TRANSHDR;
-}
-
-
-/*
  * Unlock all of the transaction's items and free the transaction.
  * The transaction must not have modified any of its items, because
  * there is no way to restore them to their previous state.
-- 
1.6.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
