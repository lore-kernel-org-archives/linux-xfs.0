Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 01 Aug 2008 14:17:05 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m71LH2bR002221
	for <xfs@oss.sgi.com>; Fri, 1 Aug 2008 14:17:03 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BEC82EEDE55
	for <xfs@oss.sgi.com>; Fri,  1 Aug 2008 14:18:14 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id NDHJcMaEBADVbetj for <xfs@oss.sgi.com>; Fri, 01 Aug 2008 14:18:14 -0700 (PDT)
Date: Fri, 1 Aug 2008 23:18:06 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 2/3] optimize xfs_ichgtime
Message-ID: <20080801211806.GA6529@lst.de>
References: <20080726063335.GB22603@lst.de> <20080726091230.GS5947@disturbed>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080726091230.GS5947@disturbed>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

On Sat, Jul 26, 2008 at 07:12:30PM +1000, Dave Chinner wrote:
> On Sat, Jul 26, 2008 at 08:33:35AM +0200, Christoph Hellwig wrote:
> > Port a little optmization from file_update_time to xfs_ichgtime, and
> > only update the timestamp and mark the inode dirty if the timestamp
> > actually changes in the timer tick resultion supported by the running
> > kernel.
> 
> Looks ok.

Updated version that removes the I_NEW check (I could do this in patch
1, but doing it here causes less churn)


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_iops.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_iops.c	2008-07-26 11:14:45.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_iops.c	2008-07-26 11:15:54.000000000 +0200
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
@@ -119,10 +125,11 @@ xfs_ichgtime(
 	 * ensure that the compiler does not reorder the update
 	 * of i_update_core above the timestamp updates above.
 	 */
-	SYNCHRONIZE();
-	ip->i_update_core = 1;
-	if (!(inode->i_state & I_NEW))
+	if (sync_it) {
+		SYNCHRONIZE();
+		ip->i_update_core = 1;
 		mark_inode_dirty_sync(inode);
+	}
 }
 
 /*
