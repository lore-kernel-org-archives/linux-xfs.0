Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 26 Jul 2008 02:44:35 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6Q9iXGR023331
	for <xfs@oss.sgi.com>; Sat, 26 Jul 2008 02:44:33 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B5D74EA54F7
	for <xfs@oss.sgi.com>; Sat, 26 Jul 2008 02:45:43 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id CAOVdvo1I8uOKN2X for <xfs@oss.sgi.com>; Sat, 26 Jul 2008 02:45:43 -0700 (PDT)
Received: from verein.lst.de (localhost [127.0.0.1])
	by verein.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id m6Q9jXNg031326
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Sat, 26 Jul 2008 11:45:33 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id m6Q9jXUd031324
	for xfs@oss.sgi.com; Sat, 26 Jul 2008 11:45:33 +0200
Date: Sat, 26 Jul 2008 11:45:33 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] stop using igrab in xfs_vn_link
Message-ID: <20080726094533.GA31253@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

->link is guranteed to get an already reference inode passed so we
can do a simple increment of i_count instead of using igrab and thus
avoid banging on the global inode_lock.  This is what most filesystems
already do.

Also move the increment after the call to xfs_link to simplify error
handling.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_iops.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_iops.c	2008-07-25 06:48:34.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_iops.c	2008-07-25 06:49:30.000000000 +0200
@@ -359,20 +359,17 @@ xfs_vn_link(
 	struct inode	*dir,
 	struct dentry	*dentry)
 {
-	struct inode	*inode;	/* inode of guy being linked to */
+	struct inode	*inode = old_dentry->d_inode;
 	struct xfs_name	name;
 	int		error;
 
-	inode = old_dentry->d_inode;
 	xfs_dentry_to_name(&name, dentry);
 
-	igrab(inode);
 	error = xfs_link(XFS_I(dir), XFS_I(inode), &name);
-	if (unlikely(error)) {
-		iput(inode);
+	if (unlikely(error))
 		return -error;
-	}
 
+	atomic_inc(&inode->i_count);
 	d_instantiate(dentry, inode);
 	return 0;
 }
