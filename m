Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q64FEjJP223593 for <xfs@oss.sgi.com>; Wed, 4 Jul 2012 10:14:45 -0500
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	UAOQ8aEBMGrb70hd (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 04 Jul 2012 08:14:44 -0700 (PDT)
Message-Id: <20120704151443.421487431@bombadil.infradead.org>
Date: Wed, 04 Jul 2012 11:13:30 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 2/5] xfs: remove xfs_inactive_attrs
References: <20120704151328.928543446@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-cleanup-evict-transactions-2
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
Cc: sage@newdream.net

Remove this helper as the code flow is a lot more obvious when it gets
merged into its only caller.

Signed-off-by: Christoph Hellwig <hch@lst.de>

---
 fs/xfs/xfs_vnodeops.c |   97 ++++++++++++++++++--------------------------------
 1 file changed, 36 insertions(+), 61 deletions(-)

Index: xfs/fs/xfs/xfs_vnodeops.c
===================================================================
--- xfs.orig/fs/xfs/xfs_vnodeops.c	2012-07-04 09:50:20.683705323 +0200
+++ xfs/fs/xfs/xfs_vnodeops.c	2012-07-04 09:51:01.347038413 +0200
@@ -388,54 +388,6 @@ xfs_inactive_symlink_rmt(
 	return error;
 }
 
-STATIC int
-xfs_inactive_attrs(
-	xfs_inode_t	*ip,
-	xfs_trans_t	**tpp)
-{
-	xfs_trans_t	*tp;
-	int		error;
-	xfs_mount_t	*mp;
-
-	ASSERT(xfs_isilocked(ip, XFS_IOLOCK_EXCL));
-	tp = *tpp;
-	mp = ip->i_mount;
-	ASSERT(ip->i_d.di_forkoff != 0);
-	error = xfs_trans_commit(tp, XFS_TRANS_RELEASE_LOG_RES);
-	xfs_iunlock(ip, XFS_ILOCK_EXCL);
-	if (error)
-		goto error_unlock;
-
-	error = xfs_attr_inactive(ip);
-	if (error)
-		goto error_unlock;
-
-	tp = xfs_trans_alloc(mp, XFS_TRANS_INACTIVE);
-	error = xfs_trans_reserve(tp, 0,
-				  XFS_IFREE_LOG_RES(mp),
-				  0, XFS_TRANS_PERM_LOG_RES,
-				  XFS_INACTIVE_LOG_COUNT);
-	if (error)
-		goto error_cancel;
-
-	xfs_ilock(ip, XFS_ILOCK_EXCL);
-	xfs_trans_ijoin(tp, ip, 0);
-	xfs_idestroy_fork(ip, XFS_ATTR_FORK);
-
-	ASSERT(ip->i_d.di_anextents == 0);
-
-	*tpp = tp;
-	return 0;
-
-error_cancel:
-	ASSERT(XFS_FORCED_SHUTDOWN(mp));
-	xfs_trans_cancel(tp, 0);
-error_unlock:
-	*tpp = NULL;
-	xfs_iunlock(ip, XFS_IOLOCK_EXCL);
-	return error;
-}
-
 int
 xfs_release(
 	xfs_inode_t	*ip)
@@ -630,24 +582,40 @@ xfs_inactive(
 	}
 
 	/*
-	 * If there are attributes associated with the file
-	 * then blow them away now.  The code calls a routine
-	 * that recursively deconstructs the attribute fork.
-	 * We need to just commit the current transaction
+	 * If there are attributes associated with the file then blow them away
+	 * now.  The code calls a routine that recursively deconstructs the
+	 * attribute fork.  We need to just commit the current transaction
 	 * because we can't use it for xfs_attr_inactive().
 	 */
 	if (ip->i_d.di_anextents > 0) {
-		error = xfs_inactive_attrs(ip, &tp);
-		/*
-		 * If we got an error, the transaction is already
-		 * cancelled, and the inode is unlocked. Just get out.
-		 */
-		 if (error)
-			 return VN_INACTIVE_CACHE;
-	} else if (ip->i_afp) {
-		xfs_idestroy_fork(ip, XFS_ATTR_FORK);
+		ASSERT(ip->i_d.di_forkoff != 0);
+
+		error = xfs_trans_commit(tp, XFS_TRANS_RELEASE_LOG_RES);
+		xfs_iunlock(ip, XFS_ILOCK_EXCL);
+		if (error)
+			goto error_unlock;
+
+		error = xfs_attr_inactive(ip);
+		if (error)
+			goto error_unlock;
+
+		tp = xfs_trans_alloc(mp, XFS_TRANS_INACTIVE);
+		error = xfs_trans_reserve(tp, 0,
+					  XFS_IFREE_LOG_RES(mp),
+					  0, XFS_TRANS_PERM_LOG_RES,
+					  XFS_INACTIVE_LOG_COUNT);
+		if (error)
+			goto error_cancel;
+
+		xfs_ilock(ip, XFS_ILOCK_EXCL);
+		xfs_trans_ijoin(tp, ip, 0);
 	}
 
+	if (ip->i_afp)
+		xfs_idestroy_fork(ip, XFS_ATTR_FORK);
+
+	ASSERT(ip->i_d.di_anextents == 0);
+
 	/*
 	 * Free the inode.
 	 */
@@ -698,6 +666,13 @@ out_cancel:
 	xfs_trans_cancel(tp, XFS_TRANS_RELEASE_LOG_RES | XFS_TRANS_ABORT);
 	xfs_iunlock(ip, XFS_IOLOCK_EXCL | XFS_ILOCK_EXCL);
 	return VN_INACTIVE_CACHE;
+
+error_cancel:
+	ASSERT(XFS_FORCED_SHUTDOWN(mp));
+	xfs_trans_cancel(tp, 0);
+error_unlock:
+	xfs_iunlock(ip, XFS_IOLOCK_EXCL);
+	return VN_INACTIVE_CACHE;
 }
 
 /*

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
