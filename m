Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 22 Oct 2008 23:05:45 -0700 (PDT)
Received: from relay.sgi.com (netops-testserver-3.corp.sgi.com [192.26.57.72])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9N65cxN007495
	for <xfs@oss.sgi.com>; Wed, 22 Oct 2008 23:05:38 -0700
Subject: TAKE 987246 - fs/xfs/linux-2.6/xfs_sync.c
Message-Id: <20081023060716.5F5931EDDEF@chapter11.melbourne.sgi.com>
Date: Thu, 23 Oct 2008 17:07:16 +1100 (EST)
From: pleckie@sgi.com (Peter Leckie)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com, sgi.bugs.xfs@engr.sgi.com

avoid all reclaimable inodes in xfs_sync_inodes_ag

If we are syncing data in xfs_sync_inodes_ag(), the VFS
inode must still be referencable as the dirty data state
is carried on the VFS inode. hence if we can't get a
reference via igrab(), the inode must be in reclaim which
implies that it has no dirty data attached.

Leave such inodes to the reclaim code to flush the dirty
inode state to disk and so avoid attempting to access the
VFS inode when it may not exist in xfs_sync_inodes_ag().

Version 4:
o don't reference liinux inode untiil after igrab() succeeds

Version 3:
o converted unlock/rele to an xfs_iput() call.

Version 2:
o change igrab logic to be more linear
o remove initial reclaimable inode check now that we are using
  igrab() failure to find reclaimable inodes
o assert that igrab failure occurs only on reclaimable inodes
o clean up inode locking - only grab the iolock if we are doing
  a SYNC_DELWRI call and we have a dirty inode.


Date:  Thu Oct 23 17:06:31 EST 2008
Workarea:  chapter11.melbourne.sgi.com:/scratch/pleckie/2.6.x-xfs
Inspected by:  pleckie,david@fromorbit.com,hch@infradead.org

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:32391a
fs/xfs/linux-2.6/xfs_sync.c - 1.24 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_sync.c.diff?r1=text&tr1=1.24&r2=text&tr2=1.23&f=h
	- avoid all reclaimable inodes in xfs_sync_inodes_ag
