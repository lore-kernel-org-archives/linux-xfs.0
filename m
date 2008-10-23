Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 22 Oct 2008 23:50:14 -0700 (PDT)
Received: from relay.sgi.com (netops-testserver-3.corp.sgi.com [192.26.57.72])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9N6o7kX010985
	for <xfs@oss.sgi.com>; Wed, 22 Oct 2008 23:50:07 -0700
Subject: TAKE 987246 - stop using xfs_itobp in xfs_bulkstat
Message-Id: <20081023065149.B56AE58AE1E5@chook.melbourne.sgi.com>
Date: Thu, 23 Oct 2008 17:51:49 +1100 (EST)
From: lachlan@sgi.com (Lachlan McIlroy)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

stop using xfs_itobp in xfs_bulkstat

xfs_bulkstat only wants the dinode, offset and buffer from a given
inode number.  Instead of using xfs_itobp on a fake inode which is
complicated and currently leads to leaks of the security data just use
xfs_inotobp which is designed to do exactly the kind of lookup
xfs_bulkstat wants.  The only thing that's missing in xfs_inotobp is
a flags paramter that let's us pass down XFS_IMAP_BULKSTAT, but that can
easily added.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Date:  Thu Oct 23 17:51:16 EST 2008
Workarea:  redback.melbourne.sgi.com:/home/lachlan/isms/2.6.x-hch
Inspected by:  david@fromorbit.com
Author:  lachlan

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:32397a
fs/xfs/xfs_itable.c - 1.173 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_itable.c.diff?r1=text&tr1=1.173&r2=text&tr2=1.172&f=h
fs/xfs/xfs_inode.c - 1.535 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_inode.c.diff?r1=text&tr1=1.535&r2=text&tr2=1.534&f=h
fs/xfs/xfs_inode.h - 1.266 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_inode.h.diff?r1=text&tr1=1.266&r2=text&tr2=1.265&f=h
	- stop using xfs_itobp in xfs_bulkstat
