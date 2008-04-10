Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 10 Apr 2008 11:44:39 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m3AIhKw8003653
	for <xfs@oss.sgi.com>; Thu, 10 Apr 2008 11:43:23 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B04A799FFA3
	for <xfs@oss.sgi.com>; Thu, 10 Apr 2008 11:43:56 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id BBLjskEKgwhn2qkb for <xfs@oss.sgi.com>; Thu, 10 Apr 2008 11:43:56 -0700 (PDT)
Received: from verein.lst.de (localhost [127.0.0.1])
	by verein.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id m3AIhnF3006898
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Thu, 10 Apr 2008 20:43:49 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id m3AIhnLR006896
	for xfs@oss.sgi.com; Thu, 10 Apr 2008 20:43:49 +0200
Date: Thu, 10 Apr 2008 20:43:49 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 1/2] simplify xfs_lookup
Message-ID: <20080410184349.GA6771@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Opencode xfs-kill-xfs_dir_lookup_int here, which gets rid of a lock
roundtrip, and lots of stack space.  Also kill the di_mode == 0 check
that has been done in xfs_iget for a few years now.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/xfs_vnodeops.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_vnodeops.c	2008-04-09 20:02:27.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_vnodeops.c	2008-04-09 20:03:42.000000000 +0200
@@ -1767,8 +1767,7 @@ xfs_lookup(
 	struct xfs_name		*name,
 	xfs_inode_t		**ipp)
 {
-	xfs_inode_t		*ip;
-	xfs_ino_t		e_inum;
+	xfs_ino_t		inum;
 	int			error;
 	uint			lock_mode;
 
@@ -1778,12 +1777,21 @@ xfs_lookup(
 		return XFS_ERROR(EIO);
 
 	lock_mode = xfs_ilock_map_shared(dp);
-	error = xfs_dir_lookup_int(dp, lock_mode, name, &e_inum, &ip);
-	if (!error) {
-		*ipp = ip;
-		xfs_itrace_ref(ip);
-	}
+	error = xfs_dir_lookup(NULL, dp, name, &inum);
 	xfs_iunlock_map_shared(dp, lock_mode);
+
+	if (error)
+		goto out;
+
+	error = xfs_iget(dp->i_mount, NULL, inum, 0, 0, ipp, 0);
+	if (error)
+		goto out;
+
+	xfs_itrace_ref(*ipp);
+	return 0;
+
+ out:
+	*ipp = NULL;
 	return error;
 }
 
