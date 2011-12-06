Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pB6LwtFs003930 for <xfs@oss.sgi.com>; Tue, 6 Dec 2011 15:58:56 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D09411566FC9
	for <xfs@oss.sgi.com>; Tue,  6 Dec 2011 13:58:53 -0800 (PST)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	44EkPEaqtw8N5ZrM for <xfs@oss.sgi.com>;
	Tue, 06 Dec 2011 13:58:53 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1RY32K-0006LP-OB
	for xfs@oss.sgi.com; Tue, 06 Dec 2011 21:58:52 +0000
Message-Id: <20111206215852.699758135@bombadil.infradead.org>
Date: Tue, 06 Dec 2011 16:58:07 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [patch 01/19] xfs: remove the deprecated nodelaylog option
References: <20111206215806.844405397@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-remove-nodelaylog
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

The delaylog mode has been the default for a long time, and the nodelaylog
option has been scheduled for removal in Linux 3.3.  Remove it and code
only used by it now that we have opened the 3.3 window.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>

---
 fs/xfs/xfs_log.c     |   79 ++--------
 fs/xfs/xfs_log.h     |    5 
 fs/xfs/xfs_log_cil.c |   12 -
 fs/xfs/xfs_mount.h   |    1 
 fs/xfs/xfs_super.c   |   15 -
 fs/xfs/xfs_trans.c   |  395 ---------------------------------------------------
 6 files changed, 25 insertions(+), 482 deletions(-)

Index: xfs/fs/xfs/xfs_log.c
===================================================================
--- xfs.orig/fs/xfs/xfs_log.c	2011-11-28 09:13:10.671479755 +0100
+++ xfs/fs/xfs/xfs_log.c	2011-11-28 09:16:21.330446868 +0100
@@ -760,38 +760,6 @@ xfs_log_item_init(
 	INIT_LIST_HEAD(&item->li_cil);
 }
 
-/*
- * Write region vectors to log.  The write happens using the space reservation
- * of the ticket (tic).  It is not a requirement that all writes for a given
- * transaction occur with one call to xfs_log_write(). However, it is important
- * to note that the transaction reservation code makes an assumption about the
- * number of log headers a transaction requires that may be violated if you
- * don't pass all the transaction vectors in one call....
- */
-int
-xfs_log_write(
-	struct xfs_mount	*mp,
-	struct xfs_log_iovec	reg[],
-	int			nentries,
-	struct xlog_ticket	*tic,
-	xfs_lsn_t		*start_lsn)
-{
-	struct log		*log = mp->m_log;
-	int			error;
-	struct xfs_log_vec	vec = {
-		.lv_niovecs = nentries,
-		.lv_iovecp = reg,
-	};
-
-	if (XLOG_FORCED_SHUTDOWN(log))
-		return XFS_ERROR(EIO);
-
-	error = xlog_write(log, &vec, tic, start_lsn, NULL, 0);
-	if (error)
-		xfs_force_shutdown(mp, SHUTDOWN_LOG_IO_ERROR);
-	return error;
-}
-
 void
 xfs_log_move_tail(xfs_mount_t	*mp,
 		  xfs_lsn_t	tail_lsn)
@@ -1685,7 +1653,7 @@ xlog_print_tic_res(
 	};
 
 	xfs_warn(mp,
-		"xfs_log_write: reservation summary:\n"
+		"xlog_write: reservation summary:\n"
 		"  trans type  = %s (%u)\n"
 		"  unit res    = %d bytes\n"
 		"  current res = %d bytes\n"
@@ -1714,7 +1682,7 @@ xlog_print_tic_res(
 	}
 
 	xfs_alert_tag(mp, XFS_PTAG_LOGRES,
-		"xfs_log_write: reservation ran out. Need to up reservation");
+		"xlog_write: reservation ran out. Need to up reservation");
 	xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
 }
 
@@ -1968,23 +1936,21 @@ xlog_write(
 	*start_lsn = 0;
 
 	len = xlog_write_calc_vec_length(ticket, log_vector);
-	if (log->l_cilp) {
-		/*
-		 * Region headers and bytes are already accounted for.
-		 * We only need to take into account start records and
-		 * split regions in this function.
-		 */
-		if (ticket->t_flags & XLOG_TIC_INITED)
-			ticket->t_curr_res -= sizeof(xlog_op_header_t);
 
-		/*
-		 * Commit record headers need to be accounted for. These
-		 * come in as separate writes so are easy to detect.
-		 */
-		if (flags & (XLOG_COMMIT_TRANS | XLOG_UNMOUNT_TRANS))
-			ticket->t_curr_res -= sizeof(xlog_op_header_t);
-	} else
-		ticket->t_curr_res -= len;
+	/*
+	 * Region headers and bytes are already accounted for.
+	 * We only need to take into account start records and
+	 * split regions in this function.
+	 */
+	if (ticket->t_flags & XLOG_TIC_INITED)
+		ticket->t_curr_res -= sizeof(xlog_op_header_t);
+
+	/*
+	 * Commit record headers need to be accounted for. These
+	 * come in as separate writes so are easy to detect.
+	 */
+	if (flags & (XLOG_COMMIT_TRANS | XLOG_UNMOUNT_TRANS))
+		ticket->t_curr_res -= sizeof(xlog_op_header_t);
 
 	if (ticket->t_curr_res < 0)
 		xlog_print_tic_res(log->l_mp, ticket);
@@ -2931,8 +2897,7 @@ _xfs_log_force(
 
 	XFS_STATS_INC(xs_log_force);
 
-	if (log->l_cilp)
-		xlog_cil_force(log);
+	xlog_cil_force(log);
 
 	spin_lock(&log->l_icloglock);
 
@@ -3081,11 +3046,9 @@ _xfs_log_force_lsn(
 
 	XFS_STATS_INC(xs_log_force);
 
-	if (log->l_cilp) {
-		lsn = xlog_cil_force_lsn(log, lsn);
-		if (lsn == NULLCOMMITLSN)
-			return 0;
-	}
+	lsn = xlog_cil_force_lsn(log, lsn);
+	if (lsn == NULLCOMMITLSN)
+		return 0;
 
 try_again:
 	spin_lock(&log->l_icloglock);
@@ -3653,7 +3616,7 @@ xfs_log_force_umount(
 	 * completed transactions are flushed to disk with the xfs_log_force()
 	 * call below.
 	 */
-	if (!logerror && (mp->m_flags & XFS_MOUNT_DELAYLOG))
+	if (!logerror)
 		xlog_cil_force(log);
 
 	/*
Index: xfs/fs/xfs/xfs_log_cil.c
===================================================================
--- xfs.orig/fs/xfs/xfs_log_cil.c	2011-11-28 09:13:10.684813018 +0100
+++ xfs/fs/xfs/xfs_log_cil.c	2011-11-28 09:17:38.320029780 +0100
@@ -44,10 +44,6 @@ xlog_cil_init(
 	struct xfs_cil	*cil;
 	struct xfs_cil_ctx *ctx;
 
-	log->l_cilp = NULL;
-	if (!(log->l_mp->m_flags & XFS_MOUNT_DELAYLOG))
-		return 0;
-
 	cil = kmem_zalloc(sizeof(*cil), KM_SLEEP|KM_MAYFAIL);
 	if (!cil)
 		return ENOMEM;
@@ -80,9 +76,6 @@ void
 xlog_cil_destroy(
 	struct log	*log)
 {
-	if (!log->l_cilp)
-		return;
-
 	if (log->l_cilp->xc_ctx) {
 		if (log->l_cilp->xc_ctx->ticket)
 			xfs_log_ticket_put(log->l_cilp->xc_ctx->ticket);
@@ -137,9 +130,6 @@ void
 xlog_cil_init_post_recovery(
 	struct log	*log)
 {
-	if (!log->l_cilp)
-		return;
-
 	log->l_cilp->xc_ctx->ticket = xlog_cil_ticket_alloc(log);
 	log->l_cilp->xc_ctx->sequence = 1;
 	log->l_cilp->xc_ctx->commit_lsn = xlog_assign_lsn(log->l_curr_cycle,
@@ -786,8 +776,6 @@ xfs_log_item_in_current_chkpt(
 {
 	struct xfs_cil_ctx *ctx;
 
-	if (!(lip->li_mountp->m_flags & XFS_MOUNT_DELAYLOG))
-		return false;
 	if (list_empty(&lip->li_cil))
 		return false;
 
Index: xfs/fs/xfs/xfs_mount.h
===================================================================
--- xfs.orig/fs/xfs/xfs_mount.h	2011-11-28 09:13:10.694812963 +0100
+++ xfs/fs/xfs/xfs_mount.h	2011-11-28 09:16:21.333780183 +0100
@@ -219,7 +219,6 @@ typedef struct xfs_mount {
 #define XFS_MOUNT_WSYNC		(1ULL << 0)	/* for nfs - all metadata ops
 						   must be synchronous except
 						   for space allocations */
-#define XFS_MOUNT_DELAYLOG	(1ULL << 1)	/* delayed logging is enabled */
 #define XFS_MOUNT_WAS_CLEAN	(1ULL << 3)
 #define XFS_MOUNT_FS_SHUTDOWN	(1ULL << 4)	/* atomic stop of all filesystem
 						   operations, typically for
Index: xfs/fs/xfs/xfs_super.c
===================================================================
--- xfs.orig/fs/xfs/xfs_super.c	2011-11-28 09:13:10.708146223 +0100
+++ xfs/fs/xfs/xfs_super.c	2011-11-28 09:16:21.333780183 +0100
@@ -199,7 +199,6 @@ xfs_parseargs(
 	mp->m_flags |= XFS_MOUNT_BARRIER;
 	mp->m_flags |= XFS_MOUNT_COMPAT_IOSIZE;
 	mp->m_flags |= XFS_MOUNT_SMALL_INUMS;
-	mp->m_flags |= XFS_MOUNT_DELAYLOG;
 
 	/*
 	 * These can be overridden by the mount option parsing.
@@ -353,11 +352,11 @@ xfs_parseargs(
 			mp->m_qflags |= (XFS_GQUOTA_ACCT | XFS_GQUOTA_ACTIVE);
 			mp->m_qflags &= ~XFS_OQUOTA_ENFD;
 		} else if (!strcmp(this_char, MNTOPT_DELAYLOG)) {
-			mp->m_flags |= XFS_MOUNT_DELAYLOG;
+			xfs_warn(mp,
+	"delaylog is the default now, option is deprecated.");
 		} else if (!strcmp(this_char, MNTOPT_NODELAYLOG)) {
-			mp->m_flags &= ~XFS_MOUNT_DELAYLOG;
 			xfs_warn(mp,
-	"nodelaylog is deprecated and will be removed in Linux 3.3");
+	"nodelaylog support has been removed, option is deprecated.");
 		} else if (!strcmp(this_char, MNTOPT_DISCARD)) {
 			mp->m_flags |= XFS_MOUNT_DISCARD;
 		} else if (!strcmp(this_char, MNTOPT_NODISCARD)) {
@@ -395,13 +394,6 @@ xfs_parseargs(
 		return EINVAL;
 	}
 
-	if ((mp->m_flags & XFS_MOUNT_DISCARD) &&
-	    !(mp->m_flags & XFS_MOUNT_DELAYLOG)) {
-		xfs_warn(mp,
-	"the discard option is incompatible with the nodelaylog option");
-		return EINVAL;
-	}
-
 #ifndef CONFIG_XFS_QUOTA
 	if (XFS_IS_QUOTA_RUNNING(mp)) {
 		xfs_warn(mp, "quota support not available in this kernel.");
@@ -501,7 +493,6 @@ xfs_showargs(
 		{ XFS_MOUNT_ATTR2,		"," MNTOPT_ATTR2 },
 		{ XFS_MOUNT_FILESTREAMS,	"," MNTOPT_FILESTREAM },
 		{ XFS_MOUNT_GRPID,		"," MNTOPT_GRPID },
-		{ XFS_MOUNT_DELAYLOG,		"," MNTOPT_DELAYLOG },
 		{ XFS_MOUNT_DISCARD,		"," MNTOPT_DISCARD },
 		{ 0, NULL }
 	};
Index: xfs/fs/xfs/xfs_log.h
===================================================================
--- xfs.orig/fs/xfs/xfs_log.h	2011-11-28 09:13:10.718146170 +0100
+++ xfs/fs/xfs/xfs_log.h	2011-11-28 09:17:38.346696302 +0100
@@ -174,11 +174,6 @@ int	  xfs_log_reserve(struct xfs_mount *
 			  __uint8_t	   clientid,
 			  uint		   flags,
 			  uint		   t_type);
-int	  xfs_log_write(struct xfs_mount *mp,
-			xfs_log_iovec_t  region[],
-			int		 nentries,
-			struct xlog_ticket *ticket,
-			xfs_lsn_t	 *start_lsn);
 int	  xfs_log_unmount_write(struct xfs_mount *mp);
 void      xfs_log_unmount(struct xfs_mount *mp);
 int	  xfs_log_force_umount(struct xfs_mount *mp, int logerror);
Index: xfs/fs/xfs/xfs_trans.c
===================================================================
--- xfs.orig/fs/xfs/xfs_trans.c	2011-11-28 09:13:10.734812746 +0100
+++ xfs/fs/xfs/xfs_trans.c	2011-11-28 09:17:38.330029725 +0100
@@ -1210,219 +1210,6 @@ xfs_trans_free_items(
 	}
 }
 
-/*
- * Unlock the items associated with a transaction.
- *
- * Items which were not logged should be freed.  Those which were logged must
- * still be tracked so they can be unpinned when the transaction commits.
- */
-STATIC void
-xfs_trans_unlock_items(
-	struct xfs_trans	*tp,
-	xfs_lsn_t		commit_lsn)
-{
-	struct xfs_log_item_desc *lidp, *next;
-
-	list_for_each_entry_safe(lidp, next, &tp->t_items, lid_trans) {
-		struct xfs_log_item	*lip = lidp->lid_item;
-
-		lip->li_desc = NULL;
-
-		if (commit_lsn != NULLCOMMITLSN)
-			IOP_COMMITTING(lip, commit_lsn);
-		IOP_UNLOCK(lip);
-
-		/*
-		 * Free the descriptor if the item is not dirty
-		 * within this transaction.
-		 */
-		if (!(lidp->lid_flags & XFS_LID_DIRTY))
-			xfs_trans_free_item_desc(lidp);
-	}
-}
-
-/*
- * Total up the number of log iovecs needed to commit this
- * transaction.  The transaction itself needs one for the
- * transaction header.  Ask each dirty item in turn how many
- * it needs to get the total.
- */
-static uint
-xfs_trans_count_vecs(
-	struct xfs_trans	*tp)
-{
-	int			nvecs;
-	struct xfs_log_item_desc *lidp;
-
-	nvecs = 1;
-
-	/* In the non-debug case we need to start bailing out if we
-	 * didn't find a log_item here, return zero and let trans_commit
-	 * deal with it.
-	 */
-	if (list_empty(&tp->t_items)) {
-		ASSERT(0);
-		return 0;
-	}
-
-	list_for_each_entry(lidp, &tp->t_items, lid_trans) {
-		/*
-		 * Skip items which aren't dirty in this transaction.
-		 */
-		if (!(lidp->lid_flags & XFS_LID_DIRTY))
-			continue;
-		lidp->lid_size = IOP_SIZE(lidp->lid_item);
-		nvecs += lidp->lid_size;
-	}
-
-	return nvecs;
-}
-
-/*
- * Fill in the vector with pointers to data to be logged
- * by this transaction.  The transaction header takes
- * the first vector, and then each dirty item takes the
- * number of vectors it indicated it needed in xfs_trans_count_vecs().
- *
- * As each item fills in the entries it needs, also pin the item
- * so that it cannot be flushed out until the log write completes.
- */
-static void
-xfs_trans_fill_vecs(
-	struct xfs_trans	*tp,
-	struct xfs_log_iovec	*log_vector)
-{
-	struct xfs_log_item_desc *lidp;
-	struct xfs_log_iovec	*vecp;
-	uint			nitems;
-
-	/*
-	 * Skip over the entry for the transaction header, we'll
-	 * fill that in at the end.
-	 */
-	vecp = log_vector + 1;
-
-	nitems = 0;
-	ASSERT(!list_empty(&tp->t_items));
-	list_for_each_entry(lidp, &tp->t_items, lid_trans) {
-		/* Skip items which aren't dirty in this transaction. */
-		if (!(lidp->lid_flags & XFS_LID_DIRTY))
-			continue;
-
-		/*
-		 * The item may be marked dirty but not log anything.  This can
-		 * be used to get called when a transaction is committed.
-		 */
-		if (lidp->lid_size)
-			nitems++;
-		IOP_FORMAT(lidp->lid_item, vecp);
-		vecp += lidp->lid_size;
-		IOP_PIN(lidp->lid_item);
-	}
-
-	/*
-	 * Now that we've counted the number of items in this transaction, fill
-	 * in the transaction header. Note that the transaction header does not
-	 * have a log item.
-	 */
-	tp->t_header.th_magic = XFS_TRANS_HEADER_MAGIC;
-	tp->t_header.th_type = tp->t_type;
-	tp->t_header.th_num_items = nitems;
-	log_vector->i_addr = (xfs_caddr_t)&tp->t_header;
-	log_vector->i_len = sizeof(xfs_trans_header_t);
-	log_vector->i_type = XLOG_REG_TYPE_TRANSHDR;
-}
-
-/*
- * The committed item processing consists of calling the committed routine of
- * each logged item, updating the item's position in the AIL if necessary, and
- * unpinning each item.  If the committed routine returns -1, then do nothing
- * further with the item because it may have been freed.
- *
- * Since items are unlocked when they are copied to the incore log, it is
- * possible for two transactions to be completing and manipulating the same
- * item simultaneously.  The AIL lock will protect the lsn field of each item.
- * The value of this field can never go backwards.
- *
- * We unpin the items after repositioning them in the AIL, because otherwise
- * they could be immediately flushed and we'd have to race with the flusher
- * trying to pull the item from the AIL as we add it.
- */
-static void
-xfs_trans_item_committed(
-	struct xfs_log_item	*lip,
-	xfs_lsn_t		commit_lsn,
-	int			aborted)
-{
-	xfs_lsn_t		item_lsn;
-	struct xfs_ail		*ailp;
-
-	if (aborted)
-		lip->li_flags |= XFS_LI_ABORTED;
-	item_lsn = IOP_COMMITTED(lip, commit_lsn);
-
-	/* item_lsn of -1 means the item needs no further processing */
-	if (XFS_LSN_CMP(item_lsn, (xfs_lsn_t)-1) == 0)
-		return;
-
-	/*
-	 * If the returned lsn is greater than what it contained before, update
-	 * the location of the item in the AIL.  If it is not, then do nothing.
-	 * Items can never move backwards in the AIL.
-	 *
-	 * While the new lsn should usually be greater, it is possible that a
-	 * later transaction completing simultaneously with an earlier one
-	 * using the same item could complete first with a higher lsn.  This
-	 * would cause the earlier transaction to fail the test below.
-	 */
-	ailp = lip->li_ailp;
-	spin_lock(&ailp->xa_lock);
-	if (XFS_LSN_CMP(item_lsn, lip->li_lsn) > 0) {
-		/*
-		 * This will set the item's lsn to item_lsn and update the
-		 * position of the item in the AIL.
-		 *
-		 * xfs_trans_ail_update() drops the AIL lock.
-		 */
-		xfs_trans_ail_update(ailp, lip, item_lsn);
-	} else {
-		spin_unlock(&ailp->xa_lock);
-	}
-
-	/*
-	 * Now that we've repositioned the item in the AIL, unpin it so it can
-	 * be flushed. Pass information about buffer stale state down from the
-	 * log item flags, if anyone else stales the buffer we do not want to
-	 * pay any attention to it.
-	 */
-	IOP_UNPIN(lip, 0);
-}
-
-/*
- * This is typically called by the LM when a transaction has been fully
- * committed to disk.  It needs to unpin the items which have
- * been logged by the transaction and update their positions
- * in the AIL if necessary.
- *
- * This also gets called when the transactions didn't get written out
- * because of an I/O error. Abortflag & XFS_LI_ABORTED is set then.
- */
-STATIC void
-xfs_trans_committed(
-	void			*arg,
-	int			abortflag)
-{
-	struct xfs_trans	*tp = arg;
-	struct xfs_log_item_desc *lidp, *next;
-
-	list_for_each_entry_safe(lidp, next, &tp->t_items, lid_trans) {
-		xfs_trans_item_committed(lidp->lid_item, tp->t_lsn, abortflag);
-		xfs_trans_free_item_desc(lidp);
-	}
-
-	xfs_trans_free(tp);
-}
-
 static inline void
 xfs_log_item_batch_insert(
 	struct xfs_ail		*ailp,
@@ -1538,182 +1325,6 @@ xfs_trans_committed_bulk(
 }
 
 /*
- * Called from the trans_commit code when we notice that the filesystem is in
- * the middle of a forced shutdown.
- *
- * When we are called here, we have already pinned all the items in the
- * transaction. However, neither IOP_COMMITTING or IOP_UNLOCK has been called
- * so we can simply walk the items in the transaction, unpin them with an abort
- * flag and then free the items. Note that unpinning the items can result in
- * them being freed immediately, so we need to use a safe list traversal method
- * here.
- */
-STATIC void
-xfs_trans_uncommit(
-	struct xfs_trans	*tp,
-	uint			flags)
-{
-	struct xfs_log_item_desc *lidp, *n;
-
-	list_for_each_entry_safe(lidp, n, &tp->t_items, lid_trans) {
-		if (lidp->lid_flags & XFS_LID_DIRTY)
-			IOP_UNPIN(lidp->lid_item, 1);
-	}
-
-	xfs_trans_unreserve_and_mod_sb(tp);
-	xfs_trans_unreserve_and_mod_dquots(tp);
-
-	xfs_trans_free_items(tp, NULLCOMMITLSN, flags);
-	xfs_trans_free(tp);
-}
-
-/*
- * Format the transaction direct to the iclog. This isolates the physical
- * transaction commit operation from the logical operation and hence allows
- * other methods to be introduced without affecting the existing commit path.
- */
-static int
-xfs_trans_commit_iclog(
-	struct xfs_mount	*mp,
-	struct xfs_trans	*tp,
-	xfs_lsn_t		*commit_lsn,
-	int			flags)
-{
-	int			shutdown;
-	int			error;
-	int			log_flags = 0;
-	struct xlog_in_core	*commit_iclog;
-#define XFS_TRANS_LOGVEC_COUNT  16
-	struct xfs_log_iovec	log_vector_fast[XFS_TRANS_LOGVEC_COUNT];
-	struct xfs_log_iovec	*log_vector;
-	uint			nvec;
-
-
-	/*
-	 * Ask each log item how many log_vector entries it will
-	 * need so we can figure out how many to allocate.
-	 * Try to avoid the kmem_alloc() call in the common case
-	 * by using a vector from the stack when it fits.
-	 */
-	nvec = xfs_trans_count_vecs(tp);
-	if (nvec == 0) {
-		return ENOMEM;	/* triggers a shutdown! */
-	} else if (nvec <= XFS_TRANS_LOGVEC_COUNT) {
-		log_vector = log_vector_fast;
-	} else {
-		log_vector = (xfs_log_iovec_t *)kmem_alloc(nvec *
-						   sizeof(xfs_log_iovec_t),
-						   KM_SLEEP);
-	}
-
-	/*
-	 * Fill in the log_vector and pin the logged items, and
-	 * then write the transaction to the log.
-	 */
-	xfs_trans_fill_vecs(tp, log_vector);
-
-	if (flags & XFS_TRANS_RELEASE_LOG_RES)
-		log_flags = XFS_LOG_REL_PERM_RESERV;
-
-	error = xfs_log_write(mp, log_vector, nvec, tp->t_ticket, &(tp->t_lsn));
-
-	/*
-	 * The transaction is committed incore here, and can go out to disk
-	 * at any time after this call.  However, all the items associated
-	 * with the transaction are still locked and pinned in memory.
-	 */
-	*commit_lsn = xfs_log_done(mp, tp->t_ticket, &commit_iclog, log_flags);
-
-	tp->t_commit_lsn = *commit_lsn;
-	trace_xfs_trans_commit_lsn(tp);
-
-	if (nvec > XFS_TRANS_LOGVEC_COUNT)
-		kmem_free(log_vector);
-
-	/*
-	 * If we got a log write error. Unpin the logitems that we
-	 * had pinned, clean up, free trans structure, and return error.
-	 */
-	if (error || *commit_lsn == -1) {
-		current_restore_flags_nested(&tp->t_pflags, PF_FSTRANS);
-		xfs_trans_uncommit(tp, flags|XFS_TRANS_ABORT);
-		return XFS_ERROR(EIO);
-	}
-
-	/*
-	 * Once the transaction has committed, unused
-	 * reservations need to be released and changes to
-	 * the superblock need to be reflected in the in-core
-	 * version.  Do that now.
-	 */
-	xfs_trans_unreserve_and_mod_sb(tp);
-
-	/*
-	 * Tell the LM to call the transaction completion routine
-	 * when the log write with LSN commit_lsn completes (e.g.
-	 * when the transaction commit really hits the on-disk log).
-	 * After this call we cannot reference tp, because the call
-	 * can happen at any time and the call will free the transaction
-	 * structure pointed to by tp.  The only case where we call
-	 * the completion routine (xfs_trans_committed) directly is
-	 * if the log is turned off on a debug kernel or we're
-	 * running in simulation mode (the log is explicitly turned
-	 * off).
-	 */
-	tp->t_logcb.cb_func = xfs_trans_committed;
-	tp->t_logcb.cb_arg = tp;
-
-	/*
-	 * We need to pass the iclog buffer which was used for the
-	 * transaction commit record into this function, and attach
-	 * the callback to it. The callback must be attached before
-	 * the items are unlocked to avoid racing with other threads
-	 * waiting for an item to unlock.
-	 */
-	shutdown = xfs_log_notify(mp, commit_iclog, &(tp->t_logcb));
-
-	/*
-	 * Mark this thread as no longer being in a transaction
-	 */
-	current_restore_flags_nested(&tp->t_pflags, PF_FSTRANS);
-
-	/*
-	 * Once all the items of the transaction have been copied
-	 * to the in core log and the callback is attached, the
-	 * items can be unlocked.
-	 *
-	 * This will free descriptors pointing to items which were
-	 * not logged since there is nothing more to do with them.
-	 * For items which were logged, we will keep pointers to them
-	 * so they can be unpinned after the transaction commits to disk.
-	 * This will also stamp each modified meta-data item with
-	 * the commit lsn of this transaction for dependency tracking
-	 * purposes.
-	 */
-	xfs_trans_unlock_items(tp, *commit_lsn);
-
-	/*
-	 * If we detected a log error earlier, finish committing
-	 * the transaction now (unpin log items, etc).
-	 *
-	 * Order is critical here, to avoid using the transaction
-	 * pointer after its been freed (by xfs_trans_committed
-	 * either here now, or as a callback).  We cannot do this
-	 * step inside xfs_log_notify as was done earlier because
-	 * of this issue.
-	 */
-	if (shutdown)
-		xfs_trans_committed(tp, XFS_LI_ABORTED);
-
-	/*
-	 * Now that the xfs_trans_committed callback has been attached,
-	 * and the items are released we can finally allow the iclog to
-	 * go to disk.
-	 */
-	return xfs_log_release_iclog(mp, commit_iclog);
-}
-
-/*
  * Walk the log items and allocate log vector structures for
  * each item large enough to fit all the vectors they require.
  * Note that this format differs from the old log vector format in
@@ -1845,11 +1456,7 @@ xfs_trans_commit(
 		xfs_trans_apply_sb_deltas(tp);
 	xfs_trans_apply_dquot_deltas(tp);
 
-	if (mp->m_flags & XFS_MOUNT_DELAYLOG)
-		error = xfs_trans_commit_cil(mp, tp, &commit_lsn, flags);
-	else
-		error = xfs_trans_commit_iclog(mp, tp, &commit_lsn, flags);
-
+	error = xfs_trans_commit_cil(mp, tp, &commit_lsn, flags);
 	if (error == ENOMEM) {
 		xfs_force_shutdown(mp, SHUTDOWN_LOG_IO_ERROR);
 		error = XFS_ERROR(EIO);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
