Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mB2G6r8V031650 for <xfs@oss.sgi.com>; Tue, 2 Dec 2008 10:06:53 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 774E9164F1C2
	for <xfs@oss.sgi.com>; Tue,  2 Dec 2008 08:06:52 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id zwOlQSMZZqVIroYd for
	<xfs@oss.sgi.com>; Tue, 02 Dec 2008 08:06:52 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.68 #1 (Red Hat
	Linux)) id 1L7Xm0-0007Wb-2l
	for xfs@oss.sgi.com; Tue, 02 Dec 2008 16:06:52 +0000
Message-Id: <20081202160651.992698000@bombadil.infradead.org>
References: <20081202160430.775774000@bombadil.infradead.org>
Date: Tue, 02 Dec 2008 11:04:47 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [patch 17/22] no explicit xfs_iflush for special inodes during unmount
Content-Disposition: inline; filename=xfs-stop-flushing-special-inodes
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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

Currently we explicitly call xfs_iflush on the quota, real-time and root
inodes from xfs_unmount_flush.  But we just called xfs_sync_inodes with
SYNC_ATTR and do an XFS_bflush aka xfs_flush_buftarg to make sure all inodes
are on disk already, so there is no need for these special cases.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs-master/fs/xfs/quota/xfs_qm.c
===================================================================
--- xfs-master.orig/fs/xfs/quota/xfs_qm.c	2008-12-01 21:33:53.000000000 +0100
+++ xfs-master/fs/xfs/quota/xfs_qm.c	2008-12-02 11:26:22.000000000 +0100
@@ -395,13 +395,10 @@ xfs_qm_mount_quotas(
 /*
  * Called from the vfsops layer.
  */
-int
+void
 xfs_qm_unmount_quotas(
 	xfs_mount_t	*mp)
 {
-	xfs_inode_t	*uqp, *gqp;
-	int		error = 0;
-
 	/*
 	 * Release the dquots that root inode, et al might be holding,
 	 * before we flush quotas and blow away the quotainfo structure.
@@ -414,43 +411,18 @@ xfs_qm_unmount_quotas(
 		xfs_qm_dqdetach(mp->m_rsumip);
 
 	/*
-	 * Flush out the quota inodes.
+	 * Release the quota inodes.
 	 */
-	uqp = gqp = NULL;
 	if (mp->m_quotainfo) {
-		if ((uqp = mp->m_quotainfo->qi_uquotaip) != NULL) {
-			xfs_ilock(uqp, XFS_ILOCK_EXCL);
-			xfs_iflock(uqp);
-			error = xfs_iflush(uqp, XFS_IFLUSH_SYNC);
-			xfs_iunlock(uqp, XFS_ILOCK_EXCL);
-			if (unlikely(error == EFSCORRUPTED)) {
-				XFS_ERROR_REPORT("xfs_qm_unmount_quotas(1)",
-						 XFS_ERRLEVEL_LOW, mp);
-				goto out;
-			}
-		}
-		if ((gqp = mp->m_quotainfo->qi_gquotaip) != NULL) {
-			xfs_ilock(gqp, XFS_ILOCK_EXCL);
-			xfs_iflock(gqp);
-			error = xfs_iflush(gqp, XFS_IFLUSH_SYNC);
-			xfs_iunlock(gqp, XFS_ILOCK_EXCL);
-			if (unlikely(error == EFSCORRUPTED)) {
-				XFS_ERROR_REPORT("xfs_qm_unmount_quotas(2)",
-						 XFS_ERRLEVEL_LOW, mp);
-				goto out;
-			}
+		if (mp->m_quotainfo->qi_uquotaip) {
+			IRELE(mp->m_quotainfo->qi_uquotaip);
+			mp->m_quotainfo->qi_uquotaip = NULL;
+		}
+		if (mp->m_quotainfo->qi_gquotaip) {
+			IRELE(mp->m_quotainfo->qi_gquotaip);
+			mp->m_quotainfo->qi_gquotaip = NULL;
 		}
 	}
-	if (uqp) {
-		 IRELE(uqp);
-		 mp->m_quotainfo->qi_uquotaip = NULL;
-	}
-	if (gqp) {
-		IRELE(gqp);
-		mp->m_quotainfo->qi_gquotaip = NULL;
-	}
-out:
-	return XFS_ERROR(error);
 }
 
 /*
Index: xfs-master/fs/xfs/xfs_vfsops.c
===================================================================
--- xfs-master.orig/fs/xfs/xfs_vfsops.c	2008-12-01 21:33:53.000000000 +0100
+++ xfs-master/fs/xfs/xfs_vfsops.c	2008-12-02 11:24:59.000000000 +0100
@@ -68,74 +68,16 @@ xfs_unmount_flush(
 					   rid of. */
 	int             relocation)	/* Called from vfs relocation. */
 {
-	xfs_inode_t	*rip = mp->m_rootip;
-	xfs_inode_t	*rbmip;
-	xfs_inode_t	*rsumip = NULL;
-	int		error;
-
-	xfs_ilock(rip, XFS_ILOCK_EXCL | XFS_ILOCK_PARENT);
-	xfs_iflock(rip);
-
-	/*
-	 * Flush out the real time inodes.
-	 */
-	if ((rbmip = mp->m_rbmip) != NULL) {
-		xfs_ilock(rbmip, XFS_ILOCK_EXCL);
-		xfs_iflock(rbmip);
-		error = xfs_iflush(rbmip, XFS_IFLUSH_SYNC);
-		xfs_iunlock(rbmip, XFS_ILOCK_EXCL);
-
-		if (error == EFSCORRUPTED)
-			goto fscorrupt_out;
-
-		ASSERT(vn_count(VFS_I(rbmip)) == 1);
-
-		rsumip = mp->m_rsumip;
-		xfs_ilock(rsumip, XFS_ILOCK_EXCL);
-		xfs_iflock(rsumip);
-		error = xfs_iflush(rsumip, XFS_IFLUSH_SYNC);
-		xfs_iunlock(rsumip, XFS_ILOCK_EXCL);
-
-		if (error == EFSCORRUPTED)
-			goto fscorrupt_out;
-
-		ASSERT(vn_count(VFS_I(rsumip)) == 1);
-	}
-
-	/*
-	 * Synchronously flush root inode to disk
-	 */
-	error = xfs_iflush(rip, XFS_IFLUSH_SYNC);
-	if (error == EFSCORRUPTED)
-		goto fscorrupt_out2;
-
-	if (vn_count(VFS_I(rip)) != 1 && !relocation) {
-		xfs_iunlock(rip, XFS_ILOCK_EXCL);
-		return XFS_ERROR(EBUSY);
-	}
-
 	/*
 	 * Release dquot that rootinode, rbmino and rsumino might be holding,
 	 * flush and purge the quota inodes.
 	 */
-	error = XFS_QM_UNMOUNT(mp);
-	if (error == EFSCORRUPTED)
-		goto fscorrupt_out2;
+	XFS_QM_UNMOUNT(mp);
 
-	if (rbmip) {
-		IRELE(rbmip);
-		IRELE(rsumip);
-	}
+	if (mp->m_rbmip)
+		IRELE(mp->m_rbmip);
+	if (mp->m_rsumip)
+		IRELE(mp->m_rsumip);
 
-	xfs_iunlock(rip, XFS_ILOCK_EXCL);
 	return 0;
-
-fscorrupt_out:
-	xfs_ifunlock(rip);
-
-fscorrupt_out2:
-	xfs_iunlock(rip, XFS_ILOCK_EXCL);
-
-	return XFS_ERROR(EFSCORRUPTED);
 }
-
Index: xfs-master/fs/xfs/quota/xfs_qm.h
===================================================================
--- xfs-master.orig/fs/xfs/quota/xfs_qm.h	2008-12-01 21:33:53.000000000 +0100
+++ xfs-master/fs/xfs/quota/xfs_qm.h	2008-12-02 11:24:59.000000000 +0100
@@ -167,7 +167,7 @@ extern void		xfs_qm_destroy_quotainfo(xf
 extern void		xfs_qm_mount_quotas(xfs_mount_t *);
 extern int		xfs_qm_quotacheck(xfs_mount_t *);
 extern void		xfs_qm_unmount_quotadestroy(xfs_mount_t *);
-extern int		xfs_qm_unmount_quotas(xfs_mount_t *);
+extern void		xfs_qm_unmount_quotas(xfs_mount_t *);
 extern int		xfs_qm_write_sb_changes(xfs_mount_t *, __int64_t);
 extern int		xfs_qm_sync(xfs_mount_t *, int);
 
Index: xfs-master/fs/xfs/xfs_mount.h
===================================================================
--- xfs-master.orig/fs/xfs/xfs_mount.h	2008-12-02 11:22:46.000000000 +0100
+++ xfs-master/fs/xfs/xfs_mount.h	2008-12-02 11:24:59.000000000 +0100
@@ -117,7 +117,7 @@ struct xfs_quotainfo;
 
 typedef int	(*xfs_qminit_t)(struct xfs_mount *, uint *, uint *);
 typedef int	(*xfs_qmmount_t)(struct xfs_mount *, uint, uint);
-typedef int	(*xfs_qmunmount_t)(struct xfs_mount *);
+typedef void	(*xfs_qmunmount_t)(struct xfs_mount *);
 typedef void	(*xfs_qmdone_t)(struct xfs_mount *);
 typedef void	(*xfs_dqrele_t)(struct xfs_dquot *);
 typedef int	(*xfs_dqattach_t)(struct xfs_inode *, uint);
Index: xfs-master/fs/xfs/linux-2.6/xfs_vnode.h
===================================================================
--- xfs-master.orig/fs/xfs/linux-2.6/xfs_vnode.h	2008-12-02 11:24:34.000000000 +0100
+++ xfs-master/fs/xfs/linux-2.6/xfs_vnode.h	2008-12-02 11:24:59.000000000 +0100
@@ -65,11 +65,6 @@ extern void	vn_iowait(struct xfs_inode *
 extern void	vn_iowake(struct xfs_inode *ip);
 extern void	vn_ioerror(struct xfs_inode *ip, int error, char *f, int l);
 
-static inline int vn_count(struct inode *vp)
-{
-	return atomic_read(&vp->i_count);
-}
-
 #define IHOLD(ip) \
 do { \
 	ASSERT(atomic_read(&VFS_I(ip)->i_count) > 0) ; \

-- 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
