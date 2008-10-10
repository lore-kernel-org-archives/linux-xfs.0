Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 09 Oct 2008 21:03:44 -0700 (PDT)
Received: from relay.sgi.com (relay2.corp.sgi.com [192.26.58.22])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9A43fC1027848
	for <xfs@oss.sgi.com>; Thu, 9 Oct 2008 21:03:41 -0700
Subject: TAKE 988139 - Remove xfs_iflush_all and clean up xfs_finish_reclaim_all()
Message-Id: <20081010040514.9A1AA58C52B5@chook.melbourne.sgi.com>
Date: Fri, 10 Oct 2008 15:05:14 +1100 (EST)
From: lachlan@sgi.com (Lachlan McIlroy)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

Remove xfs_iflush_all and clean up xfs_finish_reclaim_all()

xfs_iflush_all() walks the m_inodes list to find inodes that
need reclaiming. We already have such a list - the m_del_inodes
list. Replace xfs_iflush_all() with a call to xfs_finish_reclaim_all()
and clean up xfs_finish_reclaim_all() to handle the different flush
modes now needed.

Originally based on a patch from Christoph Hellwig.

Version 3
o rediff against new linux-2.6/xfs_sync.c code

Version 2
o revert xfs_syncsub() inode reclaim behaviour back to original
  code
o xfs_quiesce_fs() should use XFS_IFLUSH_DELWRI_ELSE_ASYNC, not
  XFS_IFLUSH_ASYNC, to prevent change of behaviour.

Signed-off-by: Dave Chinner <david@fromorbit.com>

Date:  Fri Oct 10 15:04:08 EST 2008
Workarea:  redback.melbourne.sgi.com:/home/lachlan/isms/2.6.x-radix
Inspected by:  hch
Author:  lachlan

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:32284a
fs/xfs/xfs_vnodeops.c - 1.776 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_vnodeops.c.diff?r1=text&tr1=1.776&r2=text&tr2=1.775&f=h
fs/xfs/xfs_vfsops.c - 1.576 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_vfsops.c.diff?r1=text&tr1=1.576&r2=text&tr2=1.575&f=h
fs/xfs/xfs_mount.c - 1.447 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_mount.c.diff?r1=text&tr1=1.447&r2=text&tr2=1.446&f=h
fs/xfs/xfs_inode.c - 1.526 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_inode.c.diff?r1=text&tr1=1.526&r2=text&tr2=1.525&f=h
fs/xfs/xfs_inode.h - 1.260 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_inode.h.diff?r1=text&tr1=1.260&r2=text&tr2=1.259&f=h
fs/xfs/linux-2.6/xfs_sync.c - 1.3 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_sync.c.diff?r1=text&tr1=1.3&r2=text&tr2=1.2&f=h
	- Remove xfs_iflush_all and clean up xfs_finish_reclaim_all()
