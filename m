Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 24 Jul 2008 19:15:44 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m6P2FfYJ028039
	for <xfs@oss.sgi.com>; Thu, 24 Jul 2008 19:15:41 -0700
Subject: TAKE 981498 - kill vn_to_inode
Message-Id: <20080725021650.73E2758C4C3F@chook.melbourne.sgi.com>
Date: Fri, 25 Jul 2008 12:16:50 +1000 (EST)
From: lachlan@sgi.com (Lachlan McIlroy)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

kill vn_to_inode

bhv_vnode_t is just a typedef for struct inode, so there's no need for
a helper to convert between the two.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Date:  Fri Jul 25 12:16:06 AEST 2008
Workarea:  redback.melbourne.sgi.com:/home/lachlan/isms/2.6.x-hch
Inspected by:  
hch
lachlan
Author:  lachlan

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:31761a
fs/xfs/xfs_vnodeops.c - 1.768 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_vnodeops.c.diff?r1=text&tr1=1.768&r2=text&tr2=1.767&f=h
fs/xfs/linux-2.6/xfs_linux.h - 1.169 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_linux.h.diff?r1=text&tr1=1.169&r2=text&tr2=1.168&f=h
fs/xfs/linux-2.6/xfs_vnode.c - 1.159 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_vnode.c.diff?r1=text&tr1=1.159&r2=text&tr2=1.158&f=h
fs/xfs/linux-2.6/xfs_vnode.h - 1.156 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_vnode.h.diff?r1=text&tr1=1.156&r2=text&tr2=1.155&f=h
fs/xfs/linux-2.6/xfs_super.c - 1.440 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_super.c.diff?r1=text&tr1=1.440&r2=text&tr2=1.439&f=h
	- kill vn_to_inode
