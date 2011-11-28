Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pAS8PwxY225719 for <xfs@oss.sgi.com>; Mon, 28 Nov 2011 02:25:58 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B9B974FAA8B
	for <xfs@oss.sgi.com>; Mon, 28 Nov 2011 00:25:57 -0800 (PST)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	qSy3TC0VRAtMwvjS for <xfs@oss.sgi.com>;
	Mon, 28 Nov 2011 00:25:57 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1RUwXF-0000hC-49
	for xfs@oss.sgi.com; Mon, 28 Nov 2011 08:25:57 +0000
Message-Id: <20111128082557.082085349@bombadil.infradead.org>
Date: Mon, 28 Nov 2011 03:25:24 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 2/3] xfs: cleanup the transaction commit path a bit
References: <20111128082522.224645690@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-cleanup-trans-commit
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

Now that the nodelaylog mode is gone we can simplify the transaction commit
path a bit by removing the xfs_trans_commit_cil routine.  Restoring the
process flags is merged into xfs_trans_commit which already does it for
the error path, and allocating the log vectors is merged into
xlog_cil_format_items, which already fills them with data, thus avoiding
one loop over all log items.

Signed-off-by: Christoph Hellwig <hch@lst.de>

---
 fs/xfs/xfs_log.h     |    3 -
 fs/xfs/xfs_log_cil.c |   82 +++++++++++++++++++++++++++++++++++++--------------
 fs/xfs/xfs_trans.c   |   81 ++------------------------------------------------
 3 files changed, 66 insertions(+), 100 deletions(-)

Index: xfs/fs/xfs/xfs_log_cil.c
===================================================================
--- xfs.orig/fs/xfs/xfs_log_cil.c	2011-11-28 09:17:38.320029780 +0100
+++ xfs/fs/xfs/xfs_log_cil.c	2011-11-28 09:21:33.195424016 +0100
@@ -161,38 +161,75 @@ xlog_cil_init_post_recovery(
  * to the copied region inside the buffer we just allocated. This allows us to
  * format the regions into the iclog as though they are being formatted
  * directly out of the objects themselves.
+ *
+ * Note that this format differs from the old log vector format in that there
+ * is no transaction header in these log vectors.
  */
-static void
-xlog_cil_format_items(
-	struct log		*log,
-	struct xfs_log_vec	*log_vector)
+static struct xfs_log_vec *
+xlog_cil_prepare_log_vecs(
+	struct xfs_trans	*tp)
 {
-	struct xfs_log_vec *lv;
+	struct xfs_log_item_desc *lidp;
+	struct xfs_log_vec	*lv = NULL;
+	struct xfs_log_vec	*ret_lv = NULL;
 
-	ASSERT(log_vector);
-	for (lv = log_vector; lv; lv = lv->lv_next) {
+
+	/* Bail out if we didn't find a log item.  */
+	if (list_empty(&tp->t_items)) {
+		ASSERT(0);
+		return NULL;
+	}
+
+	list_for_each_entry(lidp, &tp->t_items, lid_trans) {
+		struct xfs_log_vec *new_lv;
 		void	*ptr;
 		int	index;
 		int	len = 0;
 
+		/* Skip items which aren't dirty in this transaction. */
+		if (!(lidp->lid_flags & XFS_LID_DIRTY))
+			continue;
+
+		/* Skip items that do not have any vectors for writing */
+		lidp->lid_size = IOP_SIZE(lidp->lid_item);
+		if (!lidp->lid_size)
+			continue;
+
+		new_lv = kmem_zalloc(sizeof(*new_lv) +
+				lidp->lid_size * sizeof(struct xfs_log_iovec),
+				KM_SLEEP);
+
+		/* The allocated iovec region lies beyond the log vector. */
+		new_lv->lv_iovecp = (struct xfs_log_iovec *)&new_lv[1];
+		new_lv->lv_niovecs = lidp->lid_size;
+		new_lv->lv_item = lidp->lid_item;
+
 		/* build the vector array and calculate it's length */
-		IOP_FORMAT(lv->lv_item, lv->lv_iovecp);
-		for (index = 0; index < lv->lv_niovecs; index++)
-			len += lv->lv_iovecp[index].i_len;
-
-		lv->lv_buf_len = len;
-		lv->lv_buf = kmem_alloc(lv->lv_buf_len, KM_SLEEP|KM_NOFS);
-		ptr = lv->lv_buf;
+		IOP_FORMAT(new_lv->lv_item, new_lv->lv_iovecp);
+		for (index = 0; index < new_lv->lv_niovecs; index++)
+			len += new_lv->lv_iovecp[index].i_len;
+
+		new_lv->lv_buf_len = len;
+		new_lv->lv_buf = kmem_alloc(new_lv->lv_buf_len, KM_SLEEP|KM_NOFS);
+		ptr = new_lv->lv_buf;
 
-		for (index = 0; index < lv->lv_niovecs; index++) {
-			struct xfs_log_iovec *vec = &lv->lv_iovecp[index];
+		for (index = 0; index < new_lv->lv_niovecs; index++) {
+			struct xfs_log_iovec *vec = &new_lv->lv_iovecp[index];
 
 			memcpy(ptr, vec->i_addr, vec->i_len);
 			vec->i_addr = ptr;
 			ptr += vec->i_len;
 		}
-		ASSERT(ptr == lv->lv_buf + lv->lv_buf_len);
+		ASSERT(ptr == new_lv->lv_buf + new_lv->lv_buf_len);
+
+		if (!ret_lv)
+			ret_lv = new_lv;
+		else
+			lv->lv_next = new_lv;
+		lv = new_lv;
 	}
+
+	return ret_lv;
 }
 
 /*
@@ -625,28 +662,30 @@ out_abort:
  * background commit, returns without it held once background commits are
  * allowed again.
  */
-void
+int
 xfs_log_commit_cil(
 	struct xfs_mount	*mp,
 	struct xfs_trans	*tp,
-	struct xfs_log_vec	*log_vector,
 	xfs_lsn_t		*commit_lsn,
 	int			flags)
 {
 	struct log		*log = mp->m_log;
 	int			log_flags = 0;
 	int			push = 0;
+	struct xfs_log_vec	*log_vector;
 
 	if (flags & XFS_TRANS_RELEASE_LOG_RES)
 		log_flags = XFS_LOG_REL_PERM_RESERV;
 
 	/*
-	 * do all the hard work of formatting items (including memory
+	 * Do all the hard work of formatting items (including memory
 	 * allocation) outside the CIL context lock. This prevents stalling CIL
 	 * pushes when we are low on memory and a transaction commit spends a
 	 * lot of time in memory reclaim.
 	 */
-	xlog_cil_format_items(log, log_vector);
+	log_vector = xlog_cil_prepare_log_vecs(tp);
+	if (!log_vector)
+		return ENOMEM;
 
 	/* lock out background commit */
 	down_read(&log->l_cilp->xc_ctx_lock);
@@ -699,6 +738,7 @@ xfs_log_commit_cil(
 	 */
 	if (push)
 		xlog_cil_push(log, 0);
+	return 0;
 }
 
 /*
Index: xfs/fs/xfs/xfs_trans.c
===================================================================
--- xfs.orig/fs/xfs/xfs_trans.c	2011-11-28 09:17:38.330029725 +0100
+++ xfs/fs/xfs/xfs_trans.c	2011-11-28 09:21:33.205423962 +0100
@@ -1325,82 +1325,6 @@ xfs_trans_committed_bulk(
 }
 
 /*
- * Walk the log items and allocate log vector structures for
- * each item large enough to fit all the vectors they require.
- * Note that this format differs from the old log vector format in
- * that there is no transaction header in these log vectors.
- */
-STATIC struct xfs_log_vec *
-xfs_trans_alloc_log_vecs(
-	xfs_trans_t	*tp)
-{
-	struct xfs_log_item_desc *lidp;
-	struct xfs_log_vec	*lv = NULL;
-	struct xfs_log_vec	*ret_lv = NULL;
-
-
-	/* Bail out if we didn't find a log item.  */
-	if (list_empty(&tp->t_items)) {
-		ASSERT(0);
-		return NULL;
-	}
-
-	list_for_each_entry(lidp, &tp->t_items, lid_trans) {
-		struct xfs_log_vec *new_lv;
-
-		/* Skip items which aren't dirty in this transaction. */
-		if (!(lidp->lid_flags & XFS_LID_DIRTY))
-			continue;
-
-		/* Skip items that do not have any vectors for writing */
-		lidp->lid_size = IOP_SIZE(lidp->lid_item);
-		if (!lidp->lid_size)
-			continue;
-
-		new_lv = kmem_zalloc(sizeof(*new_lv) +
-				lidp->lid_size * sizeof(struct xfs_log_iovec),
-				KM_SLEEP);
-
-		/* The allocated iovec region lies beyond the log vector. */
-		new_lv->lv_iovecp = (struct xfs_log_iovec *)&new_lv[1];
-		new_lv->lv_niovecs = lidp->lid_size;
-		new_lv->lv_item = lidp->lid_item;
-		if (!ret_lv)
-			ret_lv = new_lv;
-		else
-			lv->lv_next = new_lv;
-		lv = new_lv;
-	}
-
-	return ret_lv;
-}
-
-static int
-xfs_trans_commit_cil(
-	struct xfs_mount	*mp,
-	struct xfs_trans	*tp,
-	xfs_lsn_t		*commit_lsn,
-	int			flags)
-{
-	struct xfs_log_vec	*log_vector;
-
-	/*
-	 * Get each log item to allocate a vector structure for
-	 * the log item to to pass to the log write code. The
-	 * CIL commit code will format the vector and save it away.
-	 */
-	log_vector = xfs_trans_alloc_log_vecs(tp);
-	if (!log_vector)
-		return ENOMEM;
-
-	xfs_log_commit_cil(mp, tp, log_vector, commit_lsn, flags);
-
-	current_restore_flags_nested(&tp->t_pflags, PF_FSTRANS);
-	xfs_trans_free(tp);
-	return 0;
-}
-
-/*
  * Commit the given transaction to the log.
  *
  * XFS disk error handling mechanism is not based on a typical
@@ -1456,13 +1380,16 @@ xfs_trans_commit(
 		xfs_trans_apply_sb_deltas(tp);
 	xfs_trans_apply_dquot_deltas(tp);
 
-	error = xfs_trans_commit_cil(mp, tp, &commit_lsn, flags);
+	error = xfs_log_commit_cil(mp, tp, &commit_lsn, flags);
 	if (error == ENOMEM) {
 		xfs_force_shutdown(mp, SHUTDOWN_LOG_IO_ERROR);
 		error = XFS_ERROR(EIO);
 		goto out_unreserve;
 	}
 
+	current_restore_flags_nested(&tp->t_pflags, PF_FSTRANS);
+	xfs_trans_free(tp);
+
 	/*
 	 * If the transaction needs to be synchronous, then force the
 	 * log out now and wait for it.
Index: xfs/fs/xfs/xfs_log.h
===================================================================
--- xfs.orig/fs/xfs/xfs_log.h	2011-11-28 09:17:38.346696302 +0100
+++ xfs/fs/xfs/xfs_log.h	2011-11-28 09:17:45.893322084 +0100
@@ -184,8 +184,7 @@ void	  xlog_iodone(struct xfs_buf *);
 struct xlog_ticket *xfs_log_ticket_get(struct xlog_ticket *ticket);
 void	  xfs_log_ticket_put(struct xlog_ticket *ticket);
 
-void	xfs_log_commit_cil(struct xfs_mount *mp, struct xfs_trans *tp,
-				struct xfs_log_vec *log_vector,
+int	xfs_log_commit_cil(struct xfs_mount *mp, struct xfs_trans *tp,
 				xfs_lsn_t *commit_lsn, int flags);
 bool	xfs_log_item_in_current_chkpt(struct xfs_log_item *lip);
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
