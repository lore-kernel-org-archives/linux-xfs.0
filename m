Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 27 Jul 2008 19:36:37 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m6S2aX8m014349
	for <xfs@oss.sgi.com>; Sun, 27 Jul 2008 19:36:34 -0700
Subject: TAKE 981498 - remove some easy bhv_vnode_t instances
Message-Id: <20080728023743.4016258C4C3F@chook.melbourne.sgi.com>
Date: Mon, 28 Jul 2008 12:37:43 +1000 (EST)
From: lachlan@sgi.com (Lachlan McIlroy)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

remove some easy bhv_vnode_t instances

In various places we can just move a VFS_I call into the argument list
of called functions/macros instead of having a local bhv_vnode_t.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Date:  Mon Jul 28 12:36:08 AEST 2008
Workarea:  redback.melbourne.sgi.com:/home/lachlan/isms/2.6.x-hch
Inspected by:  
hch
lachlan
Author:  lachlan

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:31776a
fs/xfs/xfs_vnodeops.c - 1.770 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_vnodeops.c.diff?r1=text&tr1=1.770&r2=text&tr2=1.769&f=h
fs/xfs/xfs_itable.c - 1.169 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_itable.c.diff?r1=text&tr1=1.169&r2=text&tr2=1.168&f=h
fs/xfs/xfs_vfsops.c - 1.573 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_vfsops.c.diff?r1=text&tr1=1.573&r2=text&tr2=1.572&f=h
fs/xfs/xfs_dfrag.c - 1.71 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_dfrag.c.diff?r1=text&tr1=1.71&r2=text&tr2=1.70&f=h
fs/xfs/xfs_inode.c - 1.512 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_inode.c.diff?r1=text&tr1=1.512&r2=text&tr2=1.511&f=h
fs/xfs/linux-2.6/xfs_super.c - 1.441 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_super.c.diff?r1=text&tr1=1.441&r2=text&tr2=1.440&f=h
	- remove some easy bhv_vnode_t instances
