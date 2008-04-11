Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 11 Apr 2008 02:51:02 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m3B9og5F028128
	for <xfs@oss.sgi.com>; Fri, 11 Apr 2008 02:50:43 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 839F9128F267
	for <xfs@oss.sgi.com>; Fri, 11 Apr 2008 02:51:18 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id J9GaOMP1NJc58elF for <xfs@oss.sgi.com>; Fri, 11 Apr 2008 02:51:18 -0700 (PDT)
Received: from verein.lst.de (localhost [127.0.0.1])
	by verein.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id m3B9DvF3015067
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Fri, 11 Apr 2008 11:13:57 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id m3B9Dvvv015065
	for xfs@oss.sgi.com; Fri, 11 Apr 2008 11:13:57 +0200
Date: Fri, 11 Apr 2008 11:13:57 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] kill di_mode checks after xfs_iget
Message-ID: <20080411091357.GA15008@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Unless XFS_IGET_CREATE is passed xfs_iget will return ENOENT if it
encounters an inode with di_mode == 0.  Remove the duplicated checks
in the callers.

(the log recovery case is not touched for now)


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/dmapi/xfs_dm.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/dmapi/xfs_dm.c	2008-04-10 19:59:00.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/dmapi/xfs_dm.c	2008-04-10 19:59:58.000000000 +0200
@@ -503,10 +503,6 @@ xfs_dm_bulkall_iget_one(
 			 XFS_IGET_BULKSTAT, XFS_ILOCK_SHARED, &ip, bno);
 	if (error)
 		return error;
-	if (ip->i_d.di_mode == 0) {
-		xfs_iput_new(ip, XFS_ILOCK_SHARED);
-		return ENOENT;
-	}
 
 	xfs_ip_to_stat(mp, ino, ip, &xbuf->dx_statinfo);
 	dm_ip_to_handle(ip->i_vnode, &handle);
@@ -766,10 +762,6 @@ xfs_dm_bulkattr_iget_one(
 			 XFS_IGET_BULKSTAT, XFS_ILOCK_SHARED, &ip, bno);
 	if (error)
 		return error;
-	if (ip->i_d.di_mode == 0) {
-		xfs_iput_new(ip, XFS_ILOCK_SHARED);
-		return ENOENT;
-	}
 
 	xfs_ip_to_stat(mp, ino, ip, sbuf);
 	dm_ip_to_handle(ip->i_vnode, &handle);
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ioctl.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_ioctl.c	2008-04-10 20:00:13.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ioctl.c	2008-04-10 20:00:38.000000000 +0200
@@ -238,7 +238,7 @@ xfs_vget_fsop_handlereq(
 		return error;
 	if (ip == NULL)
 		return XFS_ERROR(EIO);
-	if (ip->i_d.di_mode == 0 || ip->i_d.di_gen != igen) {
+	if (ip->i_d.di_gen != igen) {
 		xfs_iput_new(ip, XFS_ILOCK_SHARED);
 		return XFS_ERROR(ENOENT);
 	}
Index: linux-2.6-xfs/fs/xfs/quota/xfs_qm.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/quota/xfs_qm.c	2008-04-10 19:58:50.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/quota/xfs_qm.c	2008-04-10 19:58:54.000000000 +0200
@@ -1737,12 +1737,6 @@ xfs_qm_dqusage_adjust(
 		return error;
 	}
 
-	if (ip->i_d.di_mode == 0) {
-		xfs_iput_new(ip, XFS_ILOCK_EXCL);
-		*res = BULKSTAT_RV_NOTHING;
-		return XFS_ERROR(ENOENT);
-	}
-
 	/*
 	 * Obtain the locked dquots. In case of an error (eg. allocation
 	 * fails for ENOSPC), we return the negative of the error number
Index: linux-2.6-xfs/fs/xfs/quota/xfs_qm_syscalls.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/quota/xfs_qm_syscalls.c	2008-04-10 19:58:28.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/quota/xfs_qm_syscalls.c	2008-04-10 19:58:45.000000000 +0200
@@ -1366,12 +1366,6 @@ xfs_qm_internalqcheck_adjust(
 		return (error);
 	}
 
-	if (ip->i_d.di_mode == 0) {
-		xfs_iput_new(ip, lock_flags);
-		*res = BULKSTAT_RV_NOTHING;
-		return XFS_ERROR(ENOENT);
-	}
-
 	/*
 	 * This inode can have blocks after eof which can get released
 	 * when we send it to inactive. Since we don't check the dquot
Index: linux-2.6-xfs/fs/xfs/xfs_itable.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_itable.c	2008-04-10 20:05:04.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_itable.c	2008-04-10 20:05:18.000000000 +0200
@@ -71,11 +71,6 @@ xfs_bulkstat_one_iget(
 
 	ASSERT(ip != NULL);
 	ASSERT(ip->i_blkno != (xfs_daddr_t)0);
-	if (ip->i_d.di_mode == 0) {
-		*stat = BULKSTAT_RV_NOTHING;
-		error = XFS_ERROR(ENOENT);
-		goto out_iput;
-	}
 
 	vp = XFS_ITOV(ip);
 	dic = &ip->i_d;
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_export.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_export.c	2008-04-10 20:07:06.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_export.c	2008-04-10 20:07:20.000000000 +0200
@@ -133,7 +133,7 @@ xfs_nfs_get_inode(
 	if (!ip)
 		return ERR_PTR(-EIO);
 
-	if (!ip->i_d.di_mode || ip->i_d.di_gen != generation) {
+	if (ip->i_d.di_gen != generation) {
 		xfs_iput_new(ip, XFS_ILOCK_SHARED);
 		return ERR_PTR(-ENOENT);
 	}
