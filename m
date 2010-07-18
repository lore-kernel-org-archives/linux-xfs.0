Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6IKaRwv163629 for <xfs@oss.sgi.com>; Sun, 18 Jul 2010 15:36:27 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 16CEF453E27
	for <xfs@oss.sgi.com>; Sun, 18 Jul 2010 13:39:26 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id TuGvgkMHqwLWOs20 for
	<xfs@oss.sgi.com>; Sun, 18 Jul 2010 13:39:26 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.72 #1 (Red Hat
	Linux)) id 1Oaady-0003vp-NG
	for xfs@oss.sgi.com; Sun, 18 Jul 2010 20:39:26 +0000
Message-Id: <20100718203926.590752918@bombadil.infradead.org>
Date: Sun, 18 Jul 2010 16:38:53 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 5/6] xfs: simplify xfs_truncate_file
References: <20100718203848.927859114@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-simplify-xfs_truncate_file
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

xfs_truncate_file is only used for truncating quota files.  Move it to
xfs_qm_syscalls.c so it can be marked static and take advatange of the
fact by removing the unused page cache validation and taking the iget
into the helper.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/quota/xfs_qm_syscalls.c
===================================================================
--- xfs.orig/fs/xfs/quota/xfs_qm_syscalls.c	2010-06-19 22:35:53.198254580 +0200
+++ xfs/fs/xfs/quota/xfs_qm_syscalls.c	2010-06-19 22:36:27.215004336 +0200
@@ -238,40 +238,74 @@ out_unlock:
 	return error;
 }
 
+STATIC int
+xfs_qm_scall_trunc_qfile(
+	struct xfs_mount	*mp,
+	xfs_ino_t		ino)
+{
+	struct xfs_inode	*ip;
+	struct xfs_trans	*tp;
+	int			error;
+
+	if (ino == NULLFSINO)
+		return 0;
+
+	error = xfs_iget(mp, NULL, ino, 0, 0, &ip);
+	if (error)
+		return error;
+
+	xfs_ilock(ip, XFS_IOLOCK_EXCL);
+
+	tp = xfs_trans_alloc(mp, XFS_TRANS_TRUNCATE_FILE);
+	error = xfs_trans_reserve(tp, 0, XFS_ITRUNCATE_LOG_RES(mp), 0,
+				  XFS_TRANS_PERM_LOG_RES,
+				  XFS_ITRUNCATE_LOG_COUNT);
+	if (error) {
+		xfs_trans_cancel(tp, 0);
+		xfs_iunlock(ip, XFS_IOLOCK_EXCL);
+		goto out_put;
+	}
+
+	xfs_ilock(ip, XFS_ILOCK_EXCL);
+	xfs_trans_ijoin(tp, ip);
+
+	error = xfs_itruncate_finish(&tp, ip, 0, XFS_DATA_FORK, 1);
+	if (error) {
+		xfs_trans_cancel(tp, XFS_TRANS_RELEASE_LOG_RES |
+				     XFS_TRANS_ABORT);
+		goto out_unlock;
+	}
+
+	xfs_ichgtime(ip, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
+	error = xfs_trans_commit(tp, XFS_TRANS_RELEASE_LOG_RES);
+
+out_unlock:
+	xfs_iunlock(ip, XFS_ILOCK_EXCL | XFS_IOLOCK_EXCL);
+out_put:
+	IRELE(ip);
+	return error;
+}
+
 int
 xfs_qm_scall_trunc_qfiles(
 	xfs_mount_t	*mp,
 	uint		flags)
 {
 	int		error = 0, error2 = 0;
-	xfs_inode_t	*qip;
 
 	if (!xfs_sb_version_hasquota(&mp->m_sb) || flags == 0) {
 		qdprintk("qtrunc flags=%x m_qflags=%x\n", flags, mp->m_qflags);
 		return XFS_ERROR(EINVAL);
 	}
 
-	if ((flags & XFS_DQ_USER) && mp->m_sb.sb_uquotino != NULLFSINO) {
-		error = xfs_iget(mp, NULL, mp->m_sb.sb_uquotino, 0, 0, &qip);
-		if (!error) {
-			error = xfs_truncate_file(mp, qip);
-			IRELE(qip);
-		}
-	}
-
-	if ((flags & (XFS_DQ_GROUP|XFS_DQ_PROJ)) &&
-	    mp->m_sb.sb_gquotino != NULLFSINO) {
-		error2 = xfs_iget(mp, NULL, mp->m_sb.sb_gquotino, 0, 0, &qip);
-		if (!error2) {
-			error2 = xfs_truncate_file(mp, qip);
-			IRELE(qip);
-		}
-	}
+	if (flags & XFS_DQ_USER)
+		error = xfs_qm_scall_trunc_qfile(mp, mp->m_sb.sb_uquotino);
+	if (flags & (XFS_DQ_GROUP|XFS_DQ_PROJ))
+		error2 = xfs_qm_scall_trunc_qfile(mp, mp->m_sb.sb_gquotino);
 
 	return error ? error : error2;
 }
 
-
 /*
  * Switch on (a given) quota enforcement for a filesystem.  This takes
  * effect immediately.
Index: xfs/fs/xfs/xfs_utils.c
===================================================================
--- xfs.orig/fs/xfs/xfs_utils.c	2010-06-19 22:35:53.205004127 +0200
+++ xfs/fs/xfs/xfs_utils.c	2010-06-19 22:36:27.215004336 +0200
@@ -320,86 +320,3 @@ xfs_bumplink(
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 	return 0;
 }
-
-/*
- * Try to truncate the given file to 0 length.  Currently called
- * only out of xfs_remove when it has to truncate a file to free
- * up space for the remove to proceed.
- */
-int
-xfs_truncate_file(
-	xfs_mount_t	*mp,
-	xfs_inode_t	*ip)
-{
-	xfs_trans_t	*tp;
-	int		error;
-
-#ifdef QUOTADEBUG
-	/*
-	 * This is called to truncate the quotainodes too.
-	 */
-	if (XFS_IS_UQUOTA_ON(mp)) {
-		if (ip->i_ino != mp->m_sb.sb_uquotino)
-			ASSERT(ip->i_udquot);
-	}
-	if (XFS_IS_OQUOTA_ON(mp)) {
-		if (ip->i_ino != mp->m_sb.sb_gquotino)
-			ASSERT(ip->i_gdquot);
-	}
-#endif
-	/*
-	 * Make the call to xfs_itruncate_start before starting the
-	 * transaction, because we cannot make the call while we're
-	 * in a transaction.
-	 */
-	xfs_ilock(ip, XFS_IOLOCK_EXCL);
-	error = xfs_itruncate_start(ip, XFS_ITRUNC_DEFINITE, (xfs_fsize_t)0);
-	if (error) {
-		xfs_iunlock(ip, XFS_IOLOCK_EXCL);
-		return error;
-	}
-
-	tp = xfs_trans_alloc(mp, XFS_TRANS_TRUNCATE_FILE);
-	if ((error = xfs_trans_reserve(tp, 0, XFS_ITRUNCATE_LOG_RES(mp), 0,
-				      XFS_TRANS_PERM_LOG_RES,
-				      XFS_ITRUNCATE_LOG_COUNT))) {
-		xfs_trans_cancel(tp, 0);
-		xfs_iunlock(ip, XFS_IOLOCK_EXCL);
-		return error;
-	}
-
-	/*
-	 * Follow the normal truncate locking protocol.  Since we
-	 * hold the inode in the transaction, we know that its number
-	 * of references will stay constant.
-	 */
-	xfs_ilock(ip, XFS_ILOCK_EXCL);
-	xfs_trans_ijoin(tp, ip);
-
-	/*
-	 * Signal a sync xaction.  The only case where that isn't
-	 * the case is if we're truncating an already unlinked file
-	 * on a wsync fs.  In that case, we know the blocks can't
-	 * reappear in the file because the links to file are
-	 * permanently toast.  Currently, we're always going to
-	 * want a sync transaction because this code is being
-	 * called from places where nlink is guaranteed to be 1
-	 * but I'm leaving the tests in to protect against future
-	 * changes -- rcc.
-	 */
-	error = xfs_itruncate_finish(&tp, ip, (xfs_fsize_t)0,
-				     XFS_DATA_FORK,
-				     ((ip->i_d.di_nlink != 0 ||
-				       !(mp->m_flags & XFS_MOUNT_WSYNC))
-				      ? 1 : 0));
-	if (error) {
-		xfs_trans_cancel(tp, XFS_TRANS_RELEASE_LOG_RES |
-				 XFS_TRANS_ABORT);
-	} else {
-		xfs_ichgtime(ip, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
-		error = xfs_trans_commit(tp, XFS_TRANS_RELEASE_LOG_RES);
-	}
-	xfs_iunlock(ip, XFS_ILOCK_EXCL | XFS_IOLOCK_EXCL);
-
-	return error;
-}
Index: xfs/fs/xfs/xfs_utils.h
===================================================================
--- xfs.orig/fs/xfs/xfs_utils.h	2010-06-19 22:35:53.222003778 +0200
+++ xfs/fs/xfs/xfs_utils.h	2010-06-19 22:36:27.218012367 +0200
@@ -18,7 +18,6 @@
 #ifndef __XFS_UTILS_H__
 #define __XFS_UTILS_H__
 
-extern int xfs_truncate_file(xfs_mount_t *, xfs_inode_t *);
 extern int xfs_dir_ialloc(xfs_trans_t **, xfs_inode_t *, mode_t, xfs_nlink_t,
 				xfs_dev_t, cred_t *, prid_t, int,
 				xfs_inode_t **, int *);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
