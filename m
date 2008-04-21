Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 20 Apr 2008 22:21:30 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m3L5LJ6l003080
	for <xfs@oss.sgi.com>; Sun, 20 Apr 2008 22:21:21 -0700
Subject: PARTIAL TAKE 976035 - remove manual lookup from xfs_rename and simplify locking
Message-Id: <20080421052156.DC68E58C4C15@chook.melbourne.sgi.com>
Date: Mon, 21 Apr 2008 15:21:56 +1000 (EST)
From: lachlan@sgi.com (Lachlan McIlroy)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

remove manual lookup from xfs_rename and simplify locking

->rename already gets the target inode passed if it exits.  Pass it down
to xfs_rename so that we can avoid looking it up again.  Also simplify
locking as the first lock section in xfs_rename can go away now:  the
isdir is an invariant over the lifetime of the inode, and new_parent and
the nlink check are namespace topology protected by i_mutex in the VFS.
The projid check needs to move into the second lock section anyway to
not be racy.

Also kill the now unused xfs_dir_lookup_int and remove the now-unused
first_locked argumet to xfs_lock_inodes.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Date:  Mon Apr 21 15:21:27 AEST 2008
Workarea:  redback.melbourne.sgi.com:/home/lachlan/isms/2.6.x-hch
Inspected by:  hch
Author:  lachlan

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:30903a
fs/xfs/xfs_vnodeops.c - 1.755 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_vnodeops.c.diff?r1=text&tr1=1.755&r2=text&tr2=1.754&f=h
fs/xfs/xfs_dfrag.c - 1.66 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_dfrag.c.diff?r1=text&tr1=1.66&r2=text&tr2=1.65&f=h
fs/xfs/xfs_inode.h - 1.245 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_inode.h.diff?r1=text&tr1=1.245&r2=text&tr2=1.244&f=h
fs/xfs/xfs_utils.c - 1.84 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_utils.c.diff?r1=text&tr1=1.84&r2=text&tr2=1.83&f=h
fs/xfs/xfs_utils.h - 1.42 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_utils.h.diff?r1=text&tr1=1.42&r2=text&tr2=1.41&f=h
fs/xfs/xfs_rename.c - 1.83 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_rename.c.diff?r1=text&tr1=1.83&r2=text&tr2=1.82&f=h
fs/xfs/linux-2.6/xfs_iops.c - 1.284 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_iops.c.diff?r1=text&tr1=1.284&r2=text&tr2=1.283&f=h
fs/xfs/xfs_vnodeops.h - 1.14 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_vnodeops.h.diff?r1=text&tr1=1.14&r2=text&tr2=1.13&f=h
	- remove manual lookup from xfs_rename and simplify locking
