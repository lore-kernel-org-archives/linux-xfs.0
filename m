Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 16 Dec 2007 08:34:01 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id lBGGXli1025633
	for <xfs@oss.sgi.com>; Sun, 16 Dec 2007 08:33:48 -0800
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 16D56116635C
	for <xfs@oss.sgi.com>; Sun, 16 Dec 2007 08:33:56 -0800 (PST)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id G5hPHLoEZL1m4sf1 for <xfs@oss.sgi.com>; Sun, 16 Dec 2007 08:33:56 -0800 (PST)
Received: from verein.lst.de (localhost [127.0.0.1])
	by verein.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id lBGGXnF3002356
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Sun, 16 Dec 2007 17:33:49 +0100
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id lBGGXndK002354
	for xfs@oss.sgi.com; Sun, 16 Dec 2007 17:33:49 +0100
Date: Sun, 16 Dec 2007 17:33:49 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 2/2] keep i_nlink updated and use proper accessors
Message-ID: <20071216163349.GA2107@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

To get the read-only bind mounts in -mm to work correctly with XFS we
need to call the drop_nlink and inc_nlink helpers to monitor the link
count.  Add calls to these to xfs_bumplink and xfs_droplink and stop
copying over di_nlink to i_nlink in xfs_validate_fields and vn_revalidate.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_iops.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_iops.c	2007-09-30 20:09:32.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_iops.c	2007-09-30 20:16:43.000000000 +0200
@@ -184,7 +184,6 @@ xfs_validate_fields(
 	struct xfs_inode	*ip = XFS_I(inode);
 	loff_t size;
 
-	inode->i_nlink = ip->i_d.di_nlink;
 	/* we're under i_sem so i_size can't change under us */
 	size = XFS_ISIZE(ip);
 	if (i_size_read(inode) != size)
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_vnode.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_vnode.c	2007-09-30 20:09:32.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_vnode.c	2007-09-30 20:16:31.000000000 +0200
@@ -117,7 +117,6 @@ vn_revalidate(
 
 	xfs_ilock(ip, XFS_ILOCK_SHARED);
 	inode->i_mode	    = ip->i_d.di_mode;
-	inode->i_nlink	    = ip->i_d.di_nlink;
 	inode->i_uid	    = ip->i_d.di_uid;
 	inode->i_gid	    = ip->i_d.di_gid;
 	inode->i_mtime.tv_sec = ip->i_d.di_mtime.t_sec;
Index: linux-2.6-xfs/fs/xfs/xfs_utils.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_utils.c	2007-09-30 20:09:32.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_utils.c	2007-09-30 20:16:06.000000000 +0200
@@ -302,6 +302,7 @@ xfs_droplink(
 
 	ASSERT (ip->i_d.di_nlink > 0);
 	ip->i_d.di_nlink--;
+	drop_nlink(ip->i_vnode);
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 
 	error = 0;
@@ -365,6 +366,7 @@ xfs_bumplink(
 
 	ASSERT(ip->i_d.di_nlink > 0);
 	ip->i_d.di_nlink++;
+	inc_nlink(ip->i_vnode);
 	if ((ip->i_d.di_version == XFS_DINODE_VERSION_1) &&
 	    (ip->i_d.di_nlink > XFS_MAXLINK_1)) {
 		/*
