Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 10 Apr 2008 11:48:41 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m3AImXOV004379
	for <xfs@oss.sgi.com>; Thu, 10 Apr 2008 11:48:35 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9645F77847A
	for <xfs@oss.sgi.com>; Thu, 10 Apr 2008 11:49:10 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id RSALObmAuYrK1AHl for <xfs@oss.sgi.com>; Thu, 10 Apr 2008 11:49:10 -0700 (PDT)
Received: from verein.lst.de (localhost [127.0.0.1])
	by verein.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id m3AIn4F3007208
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Thu, 10 Apr 2008 20:49:04 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id m3AIn4rr007206
	for xfs@oss.sgi.com; Thu, 10 Apr 2008 20:49:04 +0200
Date: Thu, 10 Apr 2008 20:49:04 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 2/2] kill usesless IHOLD calls in xfs_remove and xfs_rmdir
Message-ID: <20080410184904.GD6771@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

The VFS always has an inode reference when we call these functions.  So
we only need to grab a signle reference to each inode that's joined to
a transaction - all the other bumping and dropping is as useless as the
comments describing the IRIX semantics.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/xfs_vnodeops.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_vnodeops.c	2008-04-10 11:24:07.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_vnodeops.c	2008-04-10 11:24:46.000000000 +0200
@@ -2306,20 +2306,6 @@ xfs_remove(
 			return error;
 	}
 
-	/*
-	 * We need to get a reference to ip before we get our log
-	 * reservation. The reason for this is that we cannot call
-	 * xfs_iget for an inode for which we do not have a reference
-	 * once we've acquired a log reservation. This is because the
-	 * inode we are trying to get might be in xfs_inactive going
-	 * for a log reservation. Since we'll have to wait for the
-	 * inactive code to complete before returning from xfs_iget,
-	 * we need to make sure that we don't have log space reserved
-	 * when we call xfs_iget.  Instead we get an unlocked reference
-	 * to the inode before getting our log reservation.
-	 */
-	IHOLD(ip);
-
 	xfs_itrace_entry(ip);
 	xfs_itrace_ref(ip);
 
@@ -2328,7 +2314,6 @@ xfs_remove(
 		error = XFS_QM_DQATTACH(mp, ip, 0);
 	if (error) {
 		REMOVE_DEBUG_TRACE(__LINE__);
-		IRELE(ip);
 		goto std_return;
 	}
 
@@ -2355,7 +2340,6 @@ xfs_remove(
 		ASSERT(error != ENOSPC);
 		REMOVE_DEBUG_TRACE(__LINE__);
 		xfs_trans_cancel(tp, 0);
-		IRELE(ip);
 		return error;
 	}
 
@@ -2363,7 +2347,6 @@ xfs_remove(
 	if (error) {
 		REMOVE_DEBUG_TRACE(__LINE__);
 		xfs_trans_cancel(tp, cancel_flags);
-		IRELE(ip);
 		goto std_return;
 	}
 
@@ -2371,6 +2354,7 @@ xfs_remove(
 	 * At this point, we've gotten both the directory and the entry
 	 * inodes locked.
 	 */
+	IHOLD(ip);
 	xfs_trans_ijoin(tp, dp, XFS_ILOCK_EXCL);
 
 	IHOLD(dp);
@@ -2404,12 +2388,6 @@ xfs_remove(
 	link_zero = (ip)->i_d.di_nlink==0;
 
 	/*
-	 * Take an extra ref on the inode so that it doesn't
-	 * go to xfs_inactive() from within the commit.
-	 */
-	IHOLD(ip);
-
-	/*
 	 * If this is a synchronous mount, make sure that the
 	 * remove transaction goes to disk before returning to
 	 * the user.
@@ -2425,10 +2403,8 @@ xfs_remove(
 	}
 
 	error = xfs_trans_commit(tp, XFS_TRANS_RELEASE_LOG_RES);
-	if (error) {
-		IRELE(ip);
+	if (error)
 		goto std_return;
-	}
 
 	/*
 	 * If we are using filestreams, kill the stream association.
@@ -2440,7 +2416,6 @@ xfs_remove(
 		xfs_filestream_deassociate(ip);
 
 	xfs_itrace_exit(ip);
-	IRELE(ip);
 
 /*	Fall through to std_return with error = 0 */
  std_return:
@@ -2469,8 +2444,6 @@ xfs_remove(
 	cancel_flags |= XFS_TRANS_ABORT;
 	xfs_trans_cancel(tp, cancel_flags);
 
-	IRELE(ip);
-
 	goto std_return;
 }
 
@@ -2842,7 +2815,6 @@ xfs_rmdir(
 	struct xfs_name		*name,
 	xfs_inode_t		*cdp)
 {
-	bhv_vnode_t		*dir_vp = XFS_ITOV(dp);
 	xfs_mount_t		*mp = dp->i_mount;
 	xfs_trans_t             *tp;
 	int                     error;
@@ -2868,27 +2840,12 @@ xfs_rmdir(
 	}
 
 	/*
-	 * We need to get a reference to cdp before we get our log
-	 * reservation.  The reason for this is that we cannot call
-	 * xfs_iget for an inode for which we do not have a reference
-	 * once we've acquired a log reservation.  This is because the
-	 * inode we are trying to get might be in xfs_inactive going
-	 * for a log reservation.  Since we'll have to wait for the
-	 * inactive code to complete before returning from xfs_iget,
-	 * we need to make sure that we don't have log space reserved
-	 * when we call xfs_iget.  Instead we get an unlocked reference
-	 * to the inode before getting our log reservation.
-	 */
-	IHOLD(cdp);
-
-	/*
 	 * Get the dquots for the inodes.
 	 */
 	error = XFS_QM_DQATTACH(mp, dp, 0);
 	if (!error)
 		error = XFS_QM_DQATTACH(mp, cdp, 0);
 	if (error) {
-		IRELE(cdp);
 		REMOVE_DEBUG_TRACE(__LINE__);
 		goto std_return;
 	}
@@ -2915,7 +2872,6 @@ xfs_rmdir(
 	if (error) {
 		ASSERT(error != ENOSPC);
 		cancel_flags = 0;
-		IRELE(cdp);
 		goto error_return;
 	}
 	XFS_BMAP_INIT(&free_list, &first_block);
@@ -2929,14 +2885,13 @@ xfs_rmdir(
 	error = xfs_lock_dir_and_entry(dp, cdp);
 	if (error) {
 		xfs_trans_cancel(tp, cancel_flags);
-		IRELE(cdp);
 		goto std_return;
 	}
 
+	IHOLD(dp);
 	xfs_trans_ijoin(tp, dp, XFS_ILOCK_EXCL);
-	VN_HOLD(dir_vp);
 
-	xfs_itrace_ref(cdp);
+	IHOLD(cdp);
 	xfs_trans_ijoin(tp, cdp, XFS_ILOCK_EXCL);
 
 	ASSERT(cdp->i_d.di_nlink >= 2);
@@ -2990,12 +2945,6 @@ xfs_rmdir(
 	last_cdp_link = (cdp)->i_d.di_nlink==0;
 
 	/*
-	 * Take an extra ref on the child vnode so that it
-	 * does not go to xfs_inactive() from within the commit.
-	 */
-	IHOLD(cdp);
-
-	/*
 	 * If this is a synchronous mount, make sure that the
 	 * rmdir transaction goes to disk before returning to
 	 * the user.
@@ -3009,19 +2958,15 @@ xfs_rmdir(
 		xfs_bmap_cancel(&free_list);
 		xfs_trans_cancel(tp, (XFS_TRANS_RELEASE_LOG_RES |
 				 XFS_TRANS_ABORT));
-		IRELE(cdp);
 		goto std_return;
 	}
 
 	error = xfs_trans_commit(tp, XFS_TRANS_RELEASE_LOG_RES);
 	if (error) {
-		IRELE(cdp);
 		goto std_return;
 	}
 
 
-	IRELE(cdp);
-
 	/* Fall through to std_return with error = 0 or the errno
 	 * from xfs_trans_commit. */
  std_return:
