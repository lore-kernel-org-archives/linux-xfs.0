Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 25 Jul 2008 23:33:09 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6Q6WYUU002428
	for <xfs@oss.sgi.com>; Fri, 25 Jul 2008 23:32:34 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id AF7C6331892
	for <xfs@oss.sgi.com>; Fri, 25 Jul 2008 23:33:45 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id pVNCyVxFA1eFhxuT for <xfs@oss.sgi.com>; Fri, 25 Jul 2008 23:33:45 -0700 (PDT)
Received: from verein.lst.de (localhost [127.0.0.1])
	by verein.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id m6Q6XZNg022925
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Sat, 26 Jul 2008 08:33:35 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id m6Q6XZG9022923
	for xfs@oss.sgi.com; Sat, 26 Jul 2008 08:33:35 +0200
Date: Sat, 26 Jul 2008 08:33:35 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 2/3] optimize xfs_ichgtime
Message-ID: <20080726063335.GB22603@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Port a little optmization from file_update_time to xfs_ichgtime, and
only update the timestamp and mark the inode dirty if the timestamp
actually changes in the timer tick resultion supported by the running
kernel.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_iops.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_iops.c	2008-07-23 23:31:32.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_iops.c	2008-07-23 23:34:20.000000000 +0200
@@ -97,17 +97,23 @@ xfs_ichgtime(
 {
 	struct inode	*inode = VFS_I(ip);
 	timespec_t	tv;
+	int		sync_it = 0;
 
-	nanotime(&tv);
-	if (flags & XFS_ICHGTIME_MOD) {
+	tv = current_fs_time(inode->i_sb);
+
+	if ((flags & XFS_ICHGTIME_MOD) &&
+	    !timespec_equal(&inode->i_mtime, &tv)) {
 		inode->i_mtime = tv;
 		ip->i_d.di_mtime.t_sec = (__int32_t)tv.tv_sec;
 		ip->i_d.di_mtime.t_nsec = (__int32_t)tv.tv_nsec;
+		sync_it = 1;
 	}
-	if (flags & XFS_ICHGTIME_CHG) {
+	if ((flags & XFS_ICHGTIME_CHG) &&
+	    !timespec_equal(&inode->i_ctime, &tv)) {
 		inode->i_ctime = tv;
 		ip->i_d.di_ctime.t_sec = (__int32_t)tv.tv_sec;
 		ip->i_d.di_ctime.t_nsec = (__int32_t)tv.tv_nsec;
+		sync_it = 1;
 	}
 
 	/*
@@ -119,10 +125,12 @@ xfs_ichgtime(
 	 * ensure that the compiler does not reorder the update
 	 * of i_update_core above the timestamp updates above.
 	 */
-	SYNCHRONIZE();
-	ip->i_update_core = 1;
-	if (!(inode->i_state & I_NEW))
-		mark_inode_dirty_sync(inode);
+	if (sync_it) {
+		SYNCHRONIZE();
+		ip->i_update_core = 1;
+		if (!(inode->i_state & I_NEW))
+			mark_inode_dirty_sync(inode);
+	}
 }
 
 /*
