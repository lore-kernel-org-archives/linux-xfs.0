Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 13 Apr 2008 01:25:59 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m3D8Pp4c013919
	for <xfs@oss.sgi.com>; Sun, 13 Apr 2008 01:25:51 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C23834E26B
	for <xfs@oss.sgi.com>; Sun, 13 Apr 2008 01:26:21 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id Vd0FZyJXnKVpTAOP for <xfs@oss.sgi.com>; Sun, 13 Apr 2008 01:26:21 -0700 (PDT)
Received: from verein.lst.de (localhost [127.0.0.1])
	by verein.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id m3D8QEF3018210
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Sun, 13 Apr 2008 10:26:14 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id m3D8QE38018208
	for xfs@oss.sgi.com; Sun, 13 Apr 2008 10:26:14 +0200
Date: Sun, 13 Apr 2008 10:26:14 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: kill usesless IHOLD calls in xfs_rename
Message-ID: <20080413082614.GB17993@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Similar to to the previous patch for remove and rmdir only grab
a reference to inodes when we join them to transaction to balance the
decrement on transaction completion.  Everything else it taken care of
by the VFS.

Note that the old case had leaks of inode count when src == target or
src or target == one of the parent inodes, but these cases are
fortunately already rejected by the VFS.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/xfs_rename.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_rename.c	2008-04-11 09:06:51.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_rename.c	2008-04-13 09:25:27.000000000 +0200
@@ -137,9 +137,7 @@ xfs_rename(
 	int		cancel_flags;
 	int		committed;
 	xfs_inode_t	*inodes[4];
-	int		target_ip_dropped = 0;	/* dropped target_ip link? */
 	int		spaceres;
-	int		target_link_zero = 0;
 	int		num_inodes;
 
 	xfs_itrace_entry(src_dp);
@@ -174,10 +172,6 @@ xfs_rename(
 	xfs_sort_for_rename(src_dp, target_dp, src_ip, target_ip,
 				inodes, &num_inodes);
 
-	IHOLD(src_ip);
-	if (target_ip)
-		IHOLD(target_ip);
-
 	XFS_BMAP_INIT(&free_list, &first_block);
 	tp = xfs_trans_alloc(mp, XFS_TRANS_RENAME);
 	cancel_flags = XFS_TRANS_RELEASE_LOG_RES;
@@ -191,7 +185,7 @@ xfs_rename(
 	}
 	if (error) {
 		xfs_trans_cancel(tp, 0);
-		goto rele_return;
+		goto std_return;
 	}
 
 	/*
@@ -199,7 +193,7 @@ xfs_rename(
 	 */
 	if ((error = XFS_QM_DQVOPRENAME(mp, inodes))) {
 		xfs_trans_cancel(tp, cancel_flags);
-		goto rele_return;
+		goto std_return;
 	}
 
 	/*
@@ -220,7 +214,7 @@ xfs_rename(
 		error = XFS_ERROR(EXDEV);
 		xfs_rename_unlock4(inodes, XFS_ILOCK_SHARED);
 		xfs_trans_cancel(tp, cancel_flags);
-		goto rele_return;
+		goto std_return;
 	}
 
 	/*
@@ -233,17 +227,17 @@ xfs_rename(
 	 */
 	IHOLD(src_dp);
 	xfs_trans_ijoin(tp, src_dp, XFS_ILOCK_EXCL);
+
 	if (new_parent) {
 		IHOLD(target_dp);
 		xfs_trans_ijoin(tp, target_dp, XFS_ILOCK_EXCL);
 	}
-	if ((src_ip != src_dp) && (src_ip != target_dp)) {
-		xfs_trans_ijoin(tp, src_ip, XFS_ILOCK_EXCL);
-	}
-	if ((target_ip != NULL) &&
-	    (target_ip != src_ip) &&
-	    (target_ip != src_dp) &&
-	    (target_ip != target_dp)) {
+
+	IHOLD(src_ip);
+	xfs_trans_ijoin(tp, src_ip, XFS_ILOCK_EXCL);
+
+	if (target_ip) {
+		IHOLD(target_ip);
 		xfs_trans_ijoin(tp, target_ip, XFS_ILOCK_EXCL);
 	}
 
@@ -317,7 +311,6 @@ xfs_rename(
 		error = xfs_droplink(tp, target_ip);
 		if (error)
 			goto abort_return;
-		target_ip_dropped = 1;
 
 		if (src_is_directory) {
 			/*
@@ -327,10 +320,6 @@ xfs_rename(
 			if (error)
 				goto abort_return;
 		}
-
-		/* Do this test while we still hold the locks */
-		target_link_zero = (target_ip)->i_d.di_nlink==0;
-
 	} /* target_ip != NULL */
 
 	/*
@@ -397,15 +386,6 @@ xfs_rename(
 	}
 
 	/*
-	 * If there was a target inode, take an extra reference on
-	 * it here so that it doesn't go to xfs_inactive() from
-	 * within the commit.
-	 */
-	if (target_ip != NULL) {
-		IHOLD(target_ip);
-	}
-
-	/*
 	 * If this is a synchronous mount, make sure that the
 	 * rename transaction goes to disk before returning to
 	 * the user.
@@ -414,30 +394,11 @@ xfs_rename(
 		xfs_trans_set_sync(tp);
 	}
 
-	/*
-	 * Take refs. for vop_link_removed calls below.  No need to worry
-	 * about directory refs. because the caller holds them.
-	 *
-	 * Do holds before the xfs_bmap_finish since it might rele them down
-	 * to zero.
-	 */
-
-	if (target_ip_dropped)
-		IHOLD(target_ip);
-	IHOLD(src_ip);
-
 	error = xfs_bmap_finish(&tp, &free_list, &committed);
 	if (error) {
 		xfs_bmap_cancel(&free_list);
 		xfs_trans_cancel(tp, (XFS_TRANS_RELEASE_LOG_RES |
 				 XFS_TRANS_ABORT));
-		if (target_ip != NULL) {
-			IRELE(target_ip);
-		}
-		if (target_ip_dropped) {
-			IRELE(target_ip);
-		}
-		IRELE(src_ip);
 		goto std_return;
 	}
 
@@ -446,15 +407,6 @@ xfs_rename(
 	 * the vnode references.
 	 */
 	error = xfs_trans_commit(tp, XFS_TRANS_RELEASE_LOG_RES);
-	if (target_ip != NULL)
-		IRELE(target_ip);
-	/*
-	 * Let interposed file systems know about removed links.
-	 */
-	if (target_ip_dropped)
-		IRELE(target_ip);
-
-	IRELE(src_ip);
 
 	/* Fall through to std_return with error = 0 or errno from
 	 * xfs_trans_commit	 */
@@ -476,11 +428,4 @@ std_return:
 	xfs_bmap_cancel(&free_list);
 	xfs_trans_cancel(tp, cancel_flags);
 	goto std_return;
-
- rele_return:
-	IRELE(src_ip);
-	if (target_ip != NULL) {
-		IRELE(target_ip);
-	}
-	goto std_return;
 }
