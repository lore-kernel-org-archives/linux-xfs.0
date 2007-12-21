Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 20 Dec 2007 22:22:19 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id lBL6MC1m010772
	for <xfs@oss.sgi.com>; Thu, 20 Dec 2007 22:22:15 -0800
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E34D34AB255
	for <xfs@oss.sgi.com>; Thu, 20 Dec 2007 22:22:25 -0800 (PST)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id yFQkxshXKRSF8KEV for <xfs@oss.sgi.com>; Thu, 20 Dec 2007 22:22:25 -0800 (PST)
Received: from verein.lst.de (localhost [127.0.0.1])
	by verein.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id lBL6MIF3023416
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Fri, 21 Dec 2007 07:22:19 +0100
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id lBL6MIGH023414
	for xfs@oss.sgi.com; Fri, 21 Dec 2007 07:22:18 +0100
Date: Fri, 21 Dec 2007 07:22:18 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 3/4] stop re-checking permissions in xfs_swapext
Message-ID: <20071221062218.GC23180@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

xfs_swapext should simplify check if we have a writeable file descriptor
instead of re-checking the permissions using xfs_iaccess.   Add an
additional check to refuse O_APPEND file descriptors because swapext is
not an append-only write operation.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/xfs_dfrag.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_dfrag.c	2007-12-19 16:57:18.000000000 +0100
+++ linux-2.6-xfs/fs/xfs/xfs_dfrag.c	2007-12-19 16:57:29.000000000 +0100
@@ -74,12 +74,23 @@ xfs_swapext(
 		goto out_free_sxp;
 	}
 
+	if (!(file->f_mode & FMODE_WRITE) || (file->f_flags & O_APPEND)) {
+		error = XFS_ERROR(EBADF);
+		goto out_put_file;
+	}
+
 	target_file = fget((int)sxp->sx_fdtmp);
 	if (!target_file) {
 		error = XFS_ERROR(EINVAL);
 		goto out_put_file;
 	}
 
+	if (!(target_file->f_mode & FMODE_WRITE) ||
+	    (target_file->f_flags & O_APPEND)) {
+		error = XFS_ERROR(EBADF);
+		goto out_put_target_file;
+	}
+
 	ip = XFS_I(file->f_path.dentry->d_inode);
 	tip = XFS_I(target_file->f_path.dentry->d_inode);
 
@@ -154,15 +165,6 @@ xfs_swap_extents(
 	xfs_lock_inodes(ips, 2, 0, lock_flags);
 	locked = 1;
 
-	/* Check permissions */
-	error = xfs_iaccess(ip, S_IWUSR, NULL);
-	if (error)
-		goto error0;
-
-	error = xfs_iaccess(tip, S_IWUSR, NULL);
-	if (error)
-		goto error0;
-
 	/* Verify that both files have the same format */
 	if ((ip->i_d.di_mode & S_IFMT) != (tip->i_d.di_mode & S_IFMT)) {
 		error = XFS_ERROR(EINVAL);
