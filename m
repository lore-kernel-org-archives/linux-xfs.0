Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7VKcMSo226731 for <xfs@oss.sgi.com>; Wed, 31 Aug 2011 15:38:22 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 764FA1E81C23
	for <xfs@oss.sgi.com>; Wed, 31 Aug 2011 13:38:21 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	47UUtjaouuRDBjOw for <xfs@oss.sgi.com>;
	Wed, 31 Aug 2011 13:38:21 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1QyrYC-000748-TP
	for xfs@oss.sgi.com; Wed, 31 Aug 2011 20:38:20 +0000
Message-Id: <20110831203820.852785179@bombadil.infradead.org>
Date: Wed, 31 Aug 2011 16:37:00 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 13/14] xfs: kill xfs_qm_idtodq
References: <20110831203647.455809764@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-cleanup-quota-read
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

This function doesn't help the code flow, so merge the dquot allocation and
transaction handling into xfs_qm_dqread.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/xfs_dquot.c
===================================================================
--- xfs.orig/fs/xfs/xfs_dquot.c	2011-08-31 13:11:50.323387642 +0200
+++ xfs/fs/xfs/xfs_dquot.c	2011-08-31 13:35:20.250045899 +0200
@@ -548,36 +548,59 @@ xfs_qm_dqtobp(
  * Read in the ondisk dquot using dqtobp() then copy it to an incore version,
  * and release the buffer immediately.
  *
+ * If XFS_QMOPT_DQALLOC is set, allocate a dquot on disk if it needed.
  */
-/* ARGSUSED */
 STATIC int
 xfs_qm_dqread(
-	xfs_trans_t	**tpp,
-	xfs_dqid_t	id,
-	xfs_dquot_t	*dqp,	/* dquot to get filled in */
-	uint		flags)
+	struct xfs_mount	*mp,
+	xfs_dqid_t   		id,
+	uint	     		type,
+	uint			flags,
+	struct xfs_dquot	**O_dqpp)
 {
-	xfs_disk_dquot_t *ddqp;
-	xfs_buf_t	 *bp;
-	int		 error;
-	xfs_trans_t	 *tp;
+	struct xfs_dquot	*dqp;
+	struct xfs_disk_dquot	*ddqp;
+	struct xfs_buf		 *bp;
+	struct xfs_trans	 *tp = NULL;
+	int			 error;
+	int			cancelflags = 0;
 
-	ASSERT(tpp);
+	dqp = xfs_qm_dqinit(mp, id, type);
 
 	trace_xfs_dqread(dqp);
 
+	if (flags & XFS_QMOPT_DQALLOC) {
+		tp = xfs_trans_alloc(mp, XFS_TRANS_QM_DQALLOC);
+		error = xfs_trans_reserve(tp, XFS_QM_DQALLOC_SPACE_RES(mp),
+				XFS_WRITE_LOG_RES(mp) +
+				BBTOB(mp->m_quotainfo->qi_dqchunklen) - 1 +
+				128,
+				0,
+				XFS_TRANS_PERM_LOG_RES,
+				XFS_WRITE_LOG_COUNT);
+		if (error)
+			goto error1;
+		cancelflags = XFS_TRANS_RELEASE_LOG_RES;
+	}
+
 	/*
 	 * get a pointer to the on-disk dquot and the buffer containing it
 	 * dqp already knows its own type (GROUP/USER).
 	 */
-	if ((error = xfs_qm_dqtobp(tpp, dqp, &ddqp, &bp, flags))) {
-		return (error);
+	error = xfs_qm_dqtobp(&tp, dqp, &ddqp, &bp, flags);
+	if (error) {
+		/*
+		 * This can happen if quotas got turned off (ESRCH),
+		 * or if the dquot didn't exist on disk and we ask to
+		 * allocate (ENOENT).
+		 */
+		trace_xfs_dqread_fail(dqp);
+		cancelflags |= XFS_TRANS_ABORT;
+		goto error1;
 	}
-	tp = *tpp;
 
 	/* copy everything from disk dquot to the incore dquot */
 	memcpy(&dqp->q_core, ddqp, sizeof(xfs_disk_dquot_t));
-	ASSERT(be32_to_cpu(dqp->q_core.d_id) == id);
 	xfs_qm_dquot_logitem_init(dqp);
 
 	/*
@@ -606,77 +629,22 @@ xfs_qm_dqread(
 	ASSERT(xfs_buf_islocked(bp));
 	xfs_trans_brelse(tp, bp);
 
-	return (error);
-}
-
-
-/*
- * allocate an incore dquot from the kernel heap,
- * and fill its core with quota information kept on disk.
- * If XFS_QMOPT_DQALLOC is set, it'll allocate a dquot on disk
- * if it wasn't already allocated.
- */
-STATIC int
-xfs_qm_idtodq(
-	xfs_mount_t	*mp,
-	xfs_dqid_t	id,	 /* gid or uid, depending on type */
-	uint		type,	 /* UDQUOT or GDQUOT */
-	uint		flags,	 /* DQALLOC, DQREPAIR */
-	xfs_dquot_t	**O_dqpp)/* OUT : incore dquot, not locked */
-{
-	xfs_dquot_t	*dqp;
-	int		error;
-	xfs_trans_t	*tp;
-	int		cancelflags=0;
-
-	dqp = xfs_qm_dqinit(mp, id, type);
-	tp = NULL;
-	if (flags & XFS_QMOPT_DQALLOC) {
-		tp = xfs_trans_alloc(mp, XFS_TRANS_QM_DQALLOC);
-		error = xfs_trans_reserve(tp, XFS_QM_DQALLOC_SPACE_RES(mp),
-				XFS_WRITE_LOG_RES(mp) +
-				BBTOB(mp->m_quotainfo->qi_dqchunklen) - 1 +
-				128,
-				0,
-				XFS_TRANS_PERM_LOG_RES,
-				XFS_WRITE_LOG_COUNT);
-		if (error) {
-			cancelflags = 0;
-			goto error0;
-		}
-		cancelflags = XFS_TRANS_RELEASE_LOG_RES;
-	}
-
-	/*
-	 * Read it from disk; xfs_dqread() takes care of
-	 * all the necessary initialization of dquot's fields (locks, etc)
-	 */
-	if ((error = xfs_qm_dqread(&tp, id, dqp, flags))) {
-		/*
-		 * This can happen if quotas got turned off (ESRCH),
-		 * or if the dquot didn't exist on disk and we ask to
-		 * allocate (ENOENT).
-		 */
-		trace_xfs_dqread_fail(dqp);
-		cancelflags |= XFS_TRANS_ABORT;
-		goto error0;
-	}
 	if (tp) {
-		if ((error = xfs_trans_commit(tp, XFS_TRANS_RELEASE_LOG_RES)))
-			goto error1;
+		error = xfs_trans_commit(tp, XFS_TRANS_RELEASE_LOG_RES);
+		if (error)
+			goto error0;
 	}
 
 	*O_dqpp = dqp;
-	return (0);
+	return error;
 
- error0:
-	ASSERT(error);
+error1:
 	if (tp)
 		xfs_trans_cancel(tp, cancelflags);
- error1:
+error0:
 	xfs_qm_dqdestroy(dqp);
 	*O_dqpp = NULL;
-	return (error);
+	return error;
 }
 
 /*
@@ -829,19 +797,11 @@ restart:
 	version = h->qh_version;
 	mutex_unlock(&h->qh_lock);
 
-	/*
-	 * Allocate the dquot on the kernel heap, and read the ondisk
-	 * portion off the disk. Also, do all the necessary initialization
-	 * This can return ENOENT if dquot didn't exist on disk and we didn't
-	 * ask it to allocate; ESRCH if quotas got turned off suddenly.
-	 */
-	if ((error = xfs_qm_idtodq(mp, id, type,
-				  flags & (XFS_QMOPT_DQALLOC|XFS_QMOPT_DQREPAIR|
-					   XFS_QMOPT_DOWARN),
-				  &dqp))) {
+	error = xfs_qm_dqread(mp, id, type, flags, &dqp);
+	if (error) {
 		if (ip)
 			xfs_ilock(ip, XFS_ILOCK_EXCL);
-		return (error);
+		return error;
 	}
 
 	/*

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
