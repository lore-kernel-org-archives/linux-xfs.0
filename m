Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o861heMV144503 for <xfs@oss.sgi.com>; Sun, 5 Sep 2010 20:43:41 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B819C4E9EE
	for <xfs@oss.sgi.com>; Sun,  5 Sep 2010 18:44:23 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id lOHtog89qZCtMl68 for
	<xfs@oss.sgi.com>; Sun, 05 Sep 2010 18:44:23 -0700 (PDT)
Date: Sun, 5 Sep 2010 21:44:22 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] xfs: simplify xfs_qm_dqusage_adjust
Message-ID: <20100906014422.GA1587@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

There is no need to have the users and group/project quota locked at the
same time.  Get rid of xfs_qm_dqget_noattach and just do a xfs_qm_dqget
inside xfs_qm_quotacheck_dqadjust for the quota we are operating on
right now.  The new version of xfs_qm_quotacheck_dqadjust holds the
inode lock over it's operations, which is not a problem as it simply
increments counters and there is no concern about log contention
during mount time.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/quota/xfs_qm.c
===================================================================
--- xfs.orig/fs/xfs/quota/xfs_qm.c	2010-09-05 17:23:15.392004632 -0300
+++ xfs/fs/xfs/quota/xfs_qm.c	2010-09-05 22:33:14.374005609 -0300
@@ -1199,87 +1199,6 @@ xfs_qm_list_destroy(
 	mutex_destroy(&(list->qh_lock));
 }
 
-
-/*
- * Stripped down version of dqattach. This doesn't attach, or even look at the
- * dquots attached to the inode. The rationale is that there won't be any
- * attached at the time this is called from quotacheck.
- */
-STATIC int
-xfs_qm_dqget_noattach(
-	xfs_inode_t	*ip,
-	xfs_dquot_t	**O_udqpp,
-	xfs_dquot_t	**O_gdqpp)
-{
-	int		error;
-	xfs_mount_t	*mp;
-	xfs_dquot_t	*udqp, *gdqp;
-
-	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
-	mp = ip->i_mount;
-	udqp = NULL;
-	gdqp = NULL;
-
-	if (XFS_IS_UQUOTA_ON(mp)) {
-		ASSERT(ip->i_udquot == NULL);
-		/*
-		 * We want the dquot allocated if it doesn't exist.
-		 */
-		if ((error = xfs_qm_dqget(mp, ip, ip->i_d.di_uid, XFS_DQ_USER,
-					 XFS_QMOPT_DQALLOC | XFS_QMOPT_DOWARN,
-					 &udqp))) {
-			/*
-			 * Shouldn't be able to turn off quotas here.
-			 */
-			ASSERT(error != ESRCH);
-			ASSERT(error != ENOENT);
-			return error;
-		}
-		ASSERT(udqp);
-	}
-
-	if (XFS_IS_OQUOTA_ON(mp)) {
-		ASSERT(ip->i_gdquot == NULL);
-		if (udqp)
-			xfs_dqunlock(udqp);
-		error = XFS_IS_GQUOTA_ON(mp) ?
-				xfs_qm_dqget(mp, ip,
-					     ip->i_d.di_gid, XFS_DQ_GROUP,
-					     XFS_QMOPT_DQALLOC|XFS_QMOPT_DOWARN,
-					     &gdqp) :
-				xfs_qm_dqget(mp, ip,
-					     ip->i_d.di_projid, XFS_DQ_PROJ,
-					     XFS_QMOPT_DQALLOC|XFS_QMOPT_DOWARN,
-					     &gdqp);
-		if (error) {
-			if (udqp)
-				xfs_qm_dqrele(udqp);
-			ASSERT(error != ESRCH);
-			ASSERT(error != ENOENT);
-			return error;
-		}
-		ASSERT(gdqp);
-
-		/* Reacquire the locks in the right order */
-		if (udqp) {
-			if (! xfs_qm_dqlock_nowait(udqp)) {
-				xfs_dqunlock(gdqp);
-				xfs_dqlock(udqp);
-				xfs_dqlock(gdqp);
-			}
-		}
-	}
-
-	*O_udqpp = udqp;
-	*O_gdqpp = gdqp;
-
-#ifdef QUOTADEBUG
-	if (udqp) ASSERT(XFS_DQ_IS_LOCKED(udqp));
-	if (gdqp) ASSERT(XFS_DQ_IS_LOCKED(gdqp));
-#endif
-	return 0;
-}
-
 /*
  * Create an inode and return with a reference already taken, but unlocked
  * This is how we create quota inodes
@@ -1546,18 +1465,34 @@ xfs_qm_dqiterate(
 
 /*
  * Called by dqusage_adjust in doing a quotacheck.
- * Given the inode, and a dquot (either USR or GRP, doesn't matter),
- * this updates its incore copy as well as the buffer copy. This is
- * so that once the quotacheck is done, we can just log all the buffers,
- * as opposed to logging numerous updates to individual dquots.
+ *
+ * Given the inode, and a dquot id this updates both the incore dqout as well
+ * as the buffer copy. This is so that once the quotacheck is done, we can
+ * just log all the buffers, as opposed to logging numerous updates to
+ * individual dquots.
  */
-STATIC void
+STATIC int
 xfs_qm_quotacheck_dqadjust(
-	xfs_dquot_t		*dqp,
+	struct xfs_inode	*ip,
+	xfs_dqid_t		id,
+	uint			type,
 	xfs_qcnt_t		nblks,
 	xfs_qcnt_t		rtblks)
 {
-	ASSERT(XFS_DQ_IS_LOCKED(dqp));
+	struct xfs_mount	*mp = ip->i_mount;
+	struct xfs_dquot	*dqp;
+	int			error;
+
+	error = xfs_qm_dqget(mp, ip, id, type,
+			     XFS_QMOPT_DQALLOC | XFS_QMOPT_DOWARN, &dqp);
+	if (error) {
+		/*
+		 * Shouldn't be able to turn off quotas here.
+		 */
+		ASSERT(error != ESRCH);
+		ASSERT(error != ENOENT);
+		return error;
+	}
 
 	trace_xfs_dqadjust(dqp);
 
@@ -1582,11 +1517,13 @@ xfs_qm_quotacheck_dqadjust(
 	 * There are no timers for the default values set in the root dquot.
 	 */
 	if (dqp->q_core.d_id) {
-		xfs_qm_adjust_dqlimits(dqp->q_mount, &dqp->q_core);
-		xfs_qm_adjust_dqtimers(dqp->q_mount, &dqp->q_core);
+		xfs_qm_adjust_dqlimits(mp, &dqp->q_core);
+		xfs_qm_adjust_dqtimers(mp, &dqp->q_core);
 	}
 
 	dqp->dq_flags |= XFS_DQ_DIRTY;
+	xfs_qm_dqput(dqp);
+	return 0;
 }
 
 STATIC int
@@ -1629,8 +1566,7 @@ xfs_qm_dqusage_adjust(
 	int		*res)		/* result code value */
 {
 	xfs_inode_t	*ip;
-	xfs_dquot_t	*udqp, *gdqp;
-	xfs_qcnt_t	nblks, rtblks;
+	xfs_qcnt_t	nblks, rtblks = 0;
 	int		error;
 
 	ASSERT(XFS_IS_QUOTA_RUNNING(mp));
@@ -1650,51 +1586,24 @@ xfs_qm_dqusage_adjust(
 	 * the case in all other instances. It's OK that we do this because
 	 * quotacheck is done only at mount time.
 	 */
-	if ((error = xfs_iget(mp, NULL, ino, 0, XFS_ILOCK_EXCL, &ip))) {
+	error = xfs_iget(mp, NULL, ino, 0, XFS_ILOCK_EXCL, &ip);
+	if (error) {
 		*res = BULKSTAT_RV_NOTHING;
 		return error;
 	}
 
-	/*
-	 * Obtain the locked dquots. In case of an error (eg. allocation
-	 * fails for ENOSPC), we return the negative of the error number
-	 * to bulkstat, so that it can get propagated to quotacheck() and
-	 * making us disable quotas for the file system.
-	 */
-	if ((error = xfs_qm_dqget_noattach(ip, &udqp, &gdqp))) {
-		xfs_iunlock(ip, XFS_ILOCK_EXCL);
-		IRELE(ip);
-		*res = BULKSTAT_RV_GIVEUP;
-		return error;
-	}
+	ASSERT(ip->i_delayed_blks == 0);
 
-	rtblks = 0;
-	if (! XFS_IS_REALTIME_INODE(ip)) {
-		nblks = (xfs_qcnt_t)ip->i_d.di_nblocks;
-	} else {
+	if (XFS_IS_REALTIME_INODE(ip)) {
 		/*
 		 * Walk thru the extent list and count the realtime blocks.
 		 */
-		if ((error = xfs_qm_get_rtblks(ip, &rtblks))) {
-			xfs_iunlock(ip, XFS_ILOCK_EXCL);
-			IRELE(ip);
-			if (udqp)
-				xfs_qm_dqput(udqp);
-			if (gdqp)
-				xfs_qm_dqput(gdqp);
-			*res = BULKSTAT_RV_GIVEUP;
-			return error;
-		}
-		nblks = (xfs_qcnt_t)ip->i_d.di_nblocks - rtblks;
+		error = xfs_qm_get_rtblks(ip, &rtblks);
+		if (error)
+			goto error0;
 	}
-	ASSERT(ip->i_delayed_blks == 0);
 
-	/*
-	 * We can't release the inode while holding its dquot locks.
-	 * The inode can go into inactive and might try to acquire the dquotlocks.
-	 * So, just unlock here and do a vn_rele at the end.
-	 */
-	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+	nblks = (xfs_qcnt_t)ip->i_d.di_nblocks - rtblks;
 
 	/*
 	 * Add the (disk blocks and inode) resources occupied by this
@@ -1709,26 +1618,36 @@ xfs_qm_dqusage_adjust(
 	 * and quotaoffs don't race. (Quotachecks happen at mount time only).
 	 */
 	if (XFS_IS_UQUOTA_ON(mp)) {
-		ASSERT(udqp);
-		xfs_qm_quotacheck_dqadjust(udqp, nblks, rtblks);
-		xfs_qm_dqput(udqp);
-	}
-	if (XFS_IS_OQUOTA_ON(mp)) {
-		ASSERT(gdqp);
-		xfs_qm_quotacheck_dqadjust(gdqp, nblks, rtblks);
-		xfs_qm_dqput(gdqp);
+		error = xfs_qm_quotacheck_dqadjust(ip, ip->i_d.di_uid,
+						   XFS_DQ_USER, nblks, rtblks);
+		if (error)
+			goto error0;
 	}
-	/*
-	 * Now release the inode. This will send it to 'inactive', and
-	 * possibly even free blocks.
-	 */
-	IRELE(ip);
 
-	/*
-	 * Goto next inode.
-	 */
+	if (XFS_IS_GQUOTA_ON(mp)) {
+		error = xfs_qm_quotacheck_dqadjust(ip, ip->i_d.di_gid,
+						   XFS_DQ_GROUP, nblks, rtblks);
+		if (error)
+			goto error0;
+	}
+
+	if (XFS_IS_PQUOTA_ON(mp)) {
+		error = xfs_qm_quotacheck_dqadjust(ip, ip->i_d.di_projid,
+						   XFS_DQ_PROJ, nblks, rtblks);
+		if (error)
+			goto error0;
+	}
+
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+	IRELE(ip);
 	*res = BULKSTAT_RV_DIDONE;
 	return 0;
+
+error0:
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+	IRELE(ip);
+	*res = BULKSTAT_RV_GIVEUP;
+	return error;
 }
 
 /*

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
