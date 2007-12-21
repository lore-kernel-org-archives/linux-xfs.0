Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 20 Dec 2007 22:22:02 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id lBL6Lv2h010721
	for <xfs@oss.sgi.com>; Thu, 20 Dec 2007 22:21:58 -0800
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 20E00B91473
	for <xfs@oss.sgi.com>; Thu, 20 Dec 2007 22:22:08 -0800 (PST)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id PJ5N4d0wgGQMn9Ze for <xfs@oss.sgi.com>; Thu, 20 Dec 2007 22:22:08 -0800 (PST)
Received: from verein.lst.de (localhost [127.0.0.1])
	by verein.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id lBL6M2F3023387
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Fri, 21 Dec 2007 07:22:02 +0100
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id lBL6M2fB023385
	for xfs@oss.sgi.com; Fri, 21 Dec 2007 07:22:02 +0100
Date: Fri, 21 Dec 2007 07:22:02 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 1/4] remove permission check from xfs_change_file_space
Message-ID: <20071221062202.GA23180@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Both callers of xfs_change_file_space alreaedy do the
file->f_mode & FMODE_WRITE check to ensure we have a file descriptor
that has been opened for write mode, so there is no need to re-check
that with xfs_iaccess.  Especially as the later might wrongly deny it
for corner cases like file descriptor passing through unix domain
sockets.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/xfs_vnodeops.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_vnodeops.c	2007-12-19 16:07:57.000000000 +0100
+++ linux-2.6-xfs/fs/xfs/xfs_vnodeops.c	2007-12-19 16:08:19.000000000 +0100
@@ -4311,21 +4311,9 @@ xfs_change_file_space(
 
 	xfs_itrace_entry(ip);
 
-	/*
-	 * must be a regular file and have write permission
-	 */
 	if (!S_ISREG(ip->i_d.di_mode))
 		return XFS_ERROR(EINVAL);
 
-	xfs_ilock(ip, XFS_ILOCK_SHARED);
-
-	if ((error = xfs_iaccess(ip, S_IWUSR, credp))) {
-		xfs_iunlock(ip, XFS_ILOCK_SHARED);
-		return error;
-	}
-
-	xfs_iunlock(ip, XFS_ILOCK_SHARED);
-
 	switch (bf->l_whence) {
 	case 0: /*SEEK_SET*/
 		break;
