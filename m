Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 19 Aug 2008 20:23:02 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m7K3MrH8010143
	for <xfs@oss.sgi.com>; Tue, 19 Aug 2008 20:22:56 -0700
Subject: TAKE 981498 - Make use of the init-once slab optimisation.
Message-Id: <20080820032411.8AA8958C52A8@chook.melbourne.sgi.com>
Date: Wed, 20 Aug 2008 13:24:11 +1000 (EST)
From: lachlan@sgi.com (Lachlan McIlroy)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

Make use of the init-once slab optimisation.

To avoid having to initialise some fields of the XFS inode
on every allocation, we can use the slab init-once feature
to initialise them. All we have to guarantee is that when
we free the inode, all it's entries are in the initial state.
Add asserts where possible to ensure debug kernels check this
initial state before freeing and after allocation.

Signed-off-by: Dave Chinner <david@fromorbit.com>

Date:  Wed Aug 20 13:23:19 AEST 2008
Workarea:  redback.melbourne.sgi.com:/home/lachlan/isms/2.6.x-inode
Inspected by:  
lachlan
david@fromorbit.com
hch@infradead.org
Author:  lachlan

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:31925a
fs/xfs/xfs_itable.c - 1.170 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_itable.c.diff?r1=text&tr1=1.170&r2=text&tr2=1.169&f=h
fs/xfs/xfs_iget.c - 1.245 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_iget.c.diff?r1=text&tr1=1.245&r2=text&tr2=1.244&f=h
fs/xfs/xfs_inode.c - 1.519 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_inode.c.diff?r1=text&tr1=1.519&r2=text&tr2=1.518&f=h
fs/xfs/xfs_inode.h - 1.257 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_inode.h.diff?r1=text&tr1=1.257&r2=text&tr2=1.256&f=h
fs/xfs/linux-2.6/xfs_super.c - 1.448 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_super.c.diff?r1=text&tr1=1.448&r2=text&tr2=1.447&f=h
	- Make use of the init-once slab optimisation.
