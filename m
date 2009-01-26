Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n0Q7WiRO203697 for <xfs@oss.sgi.com>; Mon, 26 Jan 2009 01:32:45 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 34222B757C
	for <xfs@oss.sgi.com>; Sun, 25 Jan 2009 23:32:01 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id j96gWAEitOcUn6ES for
	<xfs@oss.sgi.com>; Sun, 25 Jan 2009 23:32:01 -0800 (PST)
Message-Id: <20090126073200.459094000@bombadil.infradead.org>
Date: Mon, 26 Jan 2009 02:31:39 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 03/17] xfs: cleanup handling in xfs_swap_extents
References: <20090126073136.384490000@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-cleanup-swapext
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

Use multiple lables for proper error unwinding and get rid of some now
superflous variables.


Signed-off-by: Josef 'Jeff' Sipek <jeffpc@josefsipek.net>
Reviewed-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/xfs_dfrag.c
===================================================================
--- xfs.orig/fs/xfs/xfs_dfrag.c	2008-12-19 15:02:54.003908425 +0100
+++ xfs/fs/xfs/xfs_dfrag.c	2008-12-22 15:59:55.013247371 +0100
@@ -126,19 +126,17 @@ xfs_swap_extents(
 	xfs_bstat_t	*sbp = &sxp->sx_stat;
 	xfs_ifork_t	*tempifp, *ifp, *tifp;
 	int		ilf_fields, tilf_fields;
-	static uint	lock_flags = XFS_ILOCK_EXCL | XFS_IOLOCK_EXCL;
 	int		error = 0;
 	int		aforkblks = 0;
 	int		taforkblks = 0;
 	__uint64_t	tmp;
-	char		locked = 0;
 
 	mp = ip->i_mount;
 
 	tempifp = kmem_alloc(sizeof(xfs_ifork_t), KM_MAYFAIL);
 	if (!tempifp) {
 		error = XFS_ERROR(ENOMEM);
-		goto error0;
+		goto out;
 	}
 
 	sbp = &sxp->sx_stat;
@@ -151,25 +149,24 @@ xfs_swap_extents(
 	 */
 	xfs_lock_two_inodes(ip, tip, XFS_IOLOCK_EXCL);
 	xfs_lock_two_inodes(ip, tip, XFS_ILOCK_EXCL);
-	locked = 1;
 
 	/* Verify that both files have the same format */
 	if ((ip->i_d.di_mode & S_IFMT) != (tip->i_d.di_mode & S_IFMT)) {
 		error = XFS_ERROR(EINVAL);
-		goto error0;
+		goto out_unlock;
 	}
 
 	/* Verify both files are either real-time or non-realtime */
 	if (XFS_IS_REALTIME_INODE(ip) != XFS_IS_REALTIME_INODE(tip)) {
 		error = XFS_ERROR(EINVAL);
-		goto error0;
+		goto out_unlock;
 	}
 
 	/* Should never get a local format */
 	if (ip->i_d.di_format == XFS_DINODE_FMT_LOCAL ||
 	    tip->i_d.di_format == XFS_DINODE_FMT_LOCAL) {
 		error = XFS_ERROR(EINVAL);
-		goto error0;
+		goto out_unlock;
 	}
 
 	if (VN_CACHED(VFS_I(tip)) != 0) {
@@ -177,13 +174,13 @@ xfs_swap_extents(
 		error = xfs_flushinval_pages(tip, 0, -1,
 				FI_REMAPF_LOCKED);
 		if (error)
-			goto error0;
+			goto out_unlock;
 	}
 
 	/* Verify O_DIRECT for ftmp */
 	if (VN_CACHED(VFS_I(tip)) != 0) {
 		error = XFS_ERROR(EINVAL);
-		goto error0;
+		goto out_unlock;
 	}
 
 	/* Verify all data are being swapped */
@@ -191,7 +188,7 @@ xfs_swap_extents(
 	    sxp->sx_length != ip->i_d.di_size ||
 	    sxp->sx_length != tip->i_d.di_size) {
 		error = XFS_ERROR(EFAULT);
-		goto error0;
+		goto out_unlock;
 	}
 
 	/*
@@ -201,7 +198,7 @@ xfs_swap_extents(
 	 */
 	if ( XFS_IFORK_Q(ip) != XFS_IFORK_Q(tip) ) {
 		error = XFS_ERROR(EINVAL);
-		goto error0;
+		goto out_unlock;
 	}
 
 	/*
@@ -216,7 +213,7 @@ xfs_swap_extents(
 	    (sbp->bs_mtime.tv_sec != ip->i_d.di_mtime.t_sec) ||
 	    (sbp->bs_mtime.tv_nsec != ip->i_d.di_mtime.t_nsec)) {
 		error = XFS_ERROR(EBUSY);
-		goto error0;
+		goto out_unlock;
 	}
 
 	/* We need to fail if the file is memory mapped.  Once we have tossed
@@ -227,7 +224,7 @@ xfs_swap_extents(
 	 */
 	if (VN_MAPPED(VFS_I(ip))) {
 		error = XFS_ERROR(EBUSY);
-		goto error0;
+		goto out_unlock;
 	}
 
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
@@ -250,8 +247,7 @@ xfs_swap_extents(
 		xfs_iunlock(ip,  XFS_IOLOCK_EXCL);
 		xfs_iunlock(tip, XFS_IOLOCK_EXCL);
 		xfs_trans_cancel(tp, 0);
-		locked = 0;
-		goto error0;
+		goto out;
 	}
 	xfs_lock_two_inodes(ip, tip, XFS_ILOCK_EXCL);
 
@@ -261,19 +257,15 @@ xfs_swap_extents(
 	if ( ((XFS_IFORK_Q(ip) != 0) && (ip->i_d.di_anextents > 0)) &&
 	     (ip->i_d.di_aformat != XFS_DINODE_FMT_LOCAL)) {
 		error = xfs_bmap_count_blocks(tp, ip, XFS_ATTR_FORK, &aforkblks);
-		if (error) {
-			xfs_trans_cancel(tp, 0);
-			goto error0;
-		}
+		if (error)
+			goto out_trans_cancel;
 	}
 	if ( ((XFS_IFORK_Q(tip) != 0) && (tip->i_d.di_anextents > 0)) &&
 	     (tip->i_d.di_aformat != XFS_DINODE_FMT_LOCAL)) {
 		error = xfs_bmap_count_blocks(tp, tip, XFS_ATTR_FORK,
 			&taforkblks);
-		if (error) {
-			xfs_trans_cancel(tp, 0);
-			goto error0;
-		}
+		if (error)
+			goto out_trans_cancel;
 	}
 
 	/*
@@ -340,10 +332,10 @@ xfs_swap_extents(
 
 
 	IHOLD(ip);
-	xfs_trans_ijoin(tp, ip, lock_flags);
+	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL | XFS_IOLOCK_EXCL);
 
 	IHOLD(tip);
-	xfs_trans_ijoin(tp, tip, lock_flags);
+	xfs_trans_ijoin(tp, tip, XFS_ILOCK_EXCL | XFS_IOLOCK_EXCL);
 
 	xfs_trans_log_inode(tp, ip,  ilf_fields);
 	xfs_trans_log_inode(tp, tip, tilf_fields);
@@ -352,19 +344,19 @@ xfs_swap_extents(
 	 * If this is a synchronous mount, make sure that the
 	 * transaction goes to disk before returning to the user.
 	 */
-	if (mp->m_flags & XFS_MOUNT_WSYNC) {
+	if (mp->m_flags & XFS_MOUNT_WSYNC)
 		xfs_trans_set_sync(tp);
-	}
 
 	error = xfs_trans_commit(tp, XFS_TRANS_SWAPEXT);
-	locked = 0;
 
- error0:
-	if (locked) {
-		xfs_iunlock(ip,  lock_flags);
-		xfs_iunlock(tip, lock_flags);
-	}
-	if (tempifp != NULL)
-		kmem_free(tempifp);
+out_unlock:
+	xfs_iunlock(ip,  XFS_ILOCK_EXCL | XFS_IOLOCK_EXCL);
+	xfs_iunlock(tip, XFS_ILOCK_EXCL | XFS_IOLOCK_EXCL);
+out:
+	kmem_free(tempifp);
 	return error;
+
+out_trans_cancel:
+	xfs_trans_cancel(tp, 0);
+	goto out_unlock;
 }

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
