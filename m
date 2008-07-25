Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 24 Jul 2008 22:17:58 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m6P5HrmS016394
	for <xfs@oss.sgi.com>; Thu, 24 Jul 2008 22:17:54 -0700
Subject: TAKE 981498 - kill xfs_lock_dir_and_entry
Message-Id: <20080725051859.C7093359F6F9@linuxbuild.melbourne.sgi.com>
Date: Fri, 25 Jul 2008 15:18:59 +1000 (EST)
From: donaldd@sgi.com (Donald Douwsma)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com, sgi.bugs.xfs@engr.sgi.com

kill xfs_lock_dir_and_entry

When multiple inodes are locked in XFS it happens in order of the inode
number, with the everything but the first inode trylocked if any of
the previous inodes is in the AIL.

Except for the sorting of the inodes this logic is implemented in
xfs_lock_inodes, but also partially duplicated in xfs_lock_dir_and_entry
in a particularly stupid way adds a lock roundtrip if the inode ordering
is not optimal.

This patch adds a new helper xfs_lock_two_inodes that takes two inodes
and locks them in the most optimal way according to the above locking
protocol and uses it for all places that want to lock two inodes.

The only caller of xfs_lock_inodes is xfs_rename which might lock up to
four inodes.


Signed-off-by: Christoph Hellwig <hch@lst.de>


Date:  Fri Jul 25 15:14:03 AEST 2008
Workarea:  linuxbuild.melbourne.sgi.com:/home/donaldd/isms/2.6.x-xfs
Inspected by:  hch

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:31772a
fs/xfs/xfs_vnodeops.c - 1.769 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_vnodeops.c.diff?r1=text&tr1=1.769&r2=text&tr2=1.768&f=h
	- kill xfs_lock_dir_and_entry

fs/xfs/xfs_dfrag.c - 1.70 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_dfrag.c.diff?r1=text&tr1=1.70&r2=text&tr2=1.69&f=h
	- kill xfs_lock_dir_and_entry

fs/xfs/xfs_inode.h - 1.252 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_inode.h.diff?r1=text&tr1=1.252&r2=text&tr2=1.251&f=h
	- kill xfs_lock_dir_and_entry
