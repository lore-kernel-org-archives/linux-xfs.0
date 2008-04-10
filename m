Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 10 Apr 2008 11:48:35 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m3AImRX1004350
	for <xfs@oss.sgi.com>; Thu, 10 Apr 2008 11:48:27 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D0668778478
	for <xfs@oss.sgi.com>; Thu, 10 Apr 2008 11:49:04 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id 9gxA00ypJCtFvvxw for <xfs@oss.sgi.com>; Thu, 10 Apr 2008 11:49:04 -0700 (PDT)
Received: from verein.lst.de (localhost [127.0.0.1])
	by verein.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id m3AImwF3007182
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Thu, 10 Apr 2008 20:48:58 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id m3AImwTN007180
	for xfs@oss.sgi.com; Thu, 10 Apr 2008 20:48:58 +0200
Date: Thu, 10 Apr 2008 20:48:58 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 1/2] kill parent == child checks in xfs_remove and xfs_rmdir
Message-ID: <20080410184858.GC6771@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

VFS guaranteed these can't happen.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/xfs_vnodeops.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_vnodeops.c	2008-03-21 17:15:21.000000000 +0100
+++ linux-2.6-xfs/fs/xfs/xfs_vnodeops.c	2008-03-21 17:16:34.000000000 +0100
@@ -2312,7 +2312,7 @@ xfs_remove(
 	xfs_itrace_ref(ip);
 
 	error = XFS_QM_DQATTACH(mp, dp, 0);
-	if (!error && dp != ip)
+	if (!error)
 		error = XFS_QM_DQATTACH(mp, ip, 0);
 	if (error) {
 		REMOVE_DEBUG_TRACE(__LINE__);
@@ -2360,15 +2360,9 @@ xfs_remove(
 	 * inodes locked.
 	 */
 	xfs_trans_ijoin(tp, dp, XFS_ILOCK_EXCL);
-	if (dp != ip) {
-		/*
-		 * Increment vnode ref count only in this case since
-		 * there's an extra vnode reference in the case where
-		 * dp == ip.
-		 */
-		IHOLD(dp);
-		xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
-	}
+
+	IHOLD(dp);
+	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
 
 	/*
 	 * Entry must exist since we did a lookup in xfs_lock_dir_and_entry.
@@ -2887,7 +2881,7 @@ xfs_rmdir(
 	 * Get the dquots for the inodes.
 	 */
 	error = XFS_QM_DQATTACH(mp, dp, 0);
-	if (!error && dp != cdp)
+	if (!error)
 		error = XFS_QM_DQATTACH(mp, cdp, 0);
 	if (error) {
 		IRELE(cdp);
@@ -2936,14 +2930,7 @@ xfs_rmdir(
 	}
 
 	xfs_trans_ijoin(tp, dp, XFS_ILOCK_EXCL);
-	if (dp != cdp) {
-		/*
-		 * Only increment the parent directory vnode count if
-		 * we didn't bump it in looking up cdp.  The only time
-		 * we don't bump it is when we're looking up ".".
-		 */
-		VN_HOLD(dir_vp);
-	}
+	VN_HOLD(dir_vp);
 
 	xfs_itrace_ref(cdp);
 	xfs_trans_ijoin(tp, cdp, XFS_ILOCK_EXCL);
