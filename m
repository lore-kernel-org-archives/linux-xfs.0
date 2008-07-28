Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 27 Jul 2008 23:25:19 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m6S6PFpR000997
	for <xfs@oss.sgi.com>; Sun, 27 Jul 2008 23:25:16 -0700
Subject: TAKE 981498 - kill bhv_vnode_t
Message-Id: <20080728062625.BB57158C4C3F@chook.melbourne.sgi.com>
Date: Mon, 28 Jul 2008 16:26:25 +1000 (EST)
From: lachlan@sgi.com (Lachlan McIlroy)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

kill bhv_vnode_t

All remaining bhv_vnode_t instance are in code that's more or less Linux
specific.  (Well, for xfs_acl.c that could be argued, but that code is
on the removal list, too).  So just do an s/bhv_vnode_t/struct inode/
over the whole tree.  We can clean up variable naming and some useless
helpers later.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Date:  Mon Jul 28 16:25:27 AEST 2008
Workarea:  redback.melbourne.sgi.com:/home/lachlan/isms/2.6.x-hch
Inspected by:  
hch
lachlan
Author:  lachlan

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:31781a
fs/xfs/xfs_vnodeops.c - 1.771 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_vnodeops.c.diff?r1=text&tr1=1.771&r2=text&tr2=1.770&f=h
fs/xfs/xfs_vfsops.c - 1.574 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_vfsops.c.diff?r1=text&tr1=1.574&r2=text&tr2=1.573&f=h
fs/xfs/xfs_acl.h - 1.39 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_acl.h.diff?r1=text&tr1=1.39&r2=text&tr2=1.38&f=h
fs/xfs/xfs_acl.c - 1.79 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_acl.c.diff?r1=text&tr1=1.79&r2=text&tr2=1.78&f=h
fs/xfs/xfs_inode.c - 1.513 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_inode.c.diff?r1=text&tr1=1.513&r2=text&tr2=1.512&f=h
fs/xfs/xfs_inode.h - 1.254 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_inode.h.diff?r1=text&tr1=1.254&r2=text&tr2=1.253&f=h
fs/xfs/quota/xfs_qm_syscalls.c - 1.46 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/quota/xfs_qm_syscalls.c.diff?r1=text&tr1=1.46&r2=text&tr2=1.45&f=h
fs/xfs/linux-2.6/xfs_vnode.c - 1.161 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_vnode.c.diff?r1=text&tr1=1.161&r2=text&tr2=1.160&f=h
fs/xfs/linux-2.6/xfs_vnode.h - 1.158 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_vnode.h.diff?r1=text&tr1=1.158&r2=text&tr2=1.157&f=h
fs/xfs/linux-2.6/xfs_super.h - 1.80 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_super.h.diff?r1=text&tr1=1.80&r2=text&tr2=1.79&f=h
fs/xfs/linux-2.6/xfs_super.c - 1.442 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_super.c.diff?r1=text&tr1=1.442&r2=text&tr2=1.441&f=h
	- kill bhv_vnode_t
