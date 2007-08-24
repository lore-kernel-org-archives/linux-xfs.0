Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 24 Aug 2007 04:20:24 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l7OBIZ4p001316
	for <xfs@oss.sgi.com>; Fri, 24 Aug 2007 04:20:21 -0700
Subject: PARTIAL TAKE 969608 - kill struct bhv_vnode
Message-Id: <20070824111831.0ABD458C38F1@chook.melbourne.sgi.com>
Date: Fri, 24 Aug 2007 21:18:30 +1000 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

kill struct bhv_vnode

Now that struct bhv_vnode is empty we can just kill it.  Retain bhv_vnode_t
as a typedef for struct inode for the time beeing until all the fallout is
cleaned up.


Signed-off-by: Christoph Hellwig <hch@lst.de>


Date:  Fri Aug 24 21:18:05 AEST 2007
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  hch@lst.de

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:29500a
fs/xfs/xfs_mount.h - 1.242 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_mount.h.diff?r1=text&tr1=1.242&r2=text&tr2=1.241&f=h
	- struct bhv_vnode is empty so just retain it as a typedef to a
	  struct inode to minimise cosmetic change.

fs/xfs/xfs_acl.h - 1.35 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_acl.h.diff?r1=text&tr1=1.35&r2=text&tr2=1.34&f=h
	- struct bhv_vnode is empty so just retain it as a typedef to a
	  struct inode to minimise cosmetic change.

fs/xfs/xfs_acl.c - 1.66 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_acl.c.diff?r1=text&tr1=1.66&r2=text&tr2=1.65&f=h
	- struct bhv_vnode is empty so just retain it as a typedef to a
	  struct inode to minimise cosmetic change.

fs/xfs/xfs_inode.h - 1.231 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_inode.h.diff?r1=text&tr1=1.231&r2=text&tr2=1.230&f=h
	- struct bhv_vnode is empty so just retain it as a typedef to a
	  struct inode to minimise cosmetic change.

fs/xfs/xfs_attr.h - 1.38 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_attr.h.diff?r1=text&tr1=1.38&r2=text&tr2=1.37&f=h
	- struct bhv_vnode is empty so just retain it as a typedef to a
	  struct inode to minimise cosmetic change.

fs/xfs/quota/xfs_qm_bhv.c - 1.26 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/quota/xfs_qm_bhv.c.diff?r1=text&tr1=1.26&r2=text&tr2=1.25&f=h
	- struct bhv_vnode is empty so just retain it as a typedef to a
	  struct inode to minimise cosmetic change.

fs/xfs/linux-2.6/xfs_lrw.h - 1.58 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_lrw.h.diff?r1=text&tr1=1.58&r2=text&tr2=1.57&f=h
	- struct bhv_vnode is empty so just retain it as a typedef to a
	  struct inode to minimise cosmetic change.

fs/xfs/linux-2.6/xfs_vfs.h - 1.73 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_vfs.h.diff?r1=text&tr1=1.73&r2=text&tr2=1.72&f=h
	- struct bhv_vnode is empty so just retain it as a typedef to a
	  struct inode to minimise cosmetic change.

fs/xfs/linux-2.6/xfs_vfs.c - 1.76 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_vfs.c.diff?r1=text&tr1=1.76&r2=text&tr2=1.75&f=h
	- struct bhv_vnode is empty so just retain it as a typedef to a
	  struct inode to minimise cosmetic change.

fs/xfs/linux-2.6/xfs_vnode.h - 1.137 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_vnode.h.diff?r1=text&tr1=1.137&r2=text&tr2=1.136&f=h
	- struct bhv_vnode is empty so just retain it as a typedef to a
	  struct inode to minimise cosmetic change.

fs/xfs/linux-2.6/xfs_super.c - 1.389 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_super.c.diff?r1=text&tr1=1.389&r2=text&tr2=1.388&f=h
	- struct bhv_vnode is empty so just retain it as a typedef to a
	  struct inode to minimise cosmetic change.

fs/xfs/linux-2.6/xfs_iops.c - 1.262 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_iops.c.diff?r1=text&tr1=1.262&r2=text&tr2=1.261&f=h
	- struct bhv_vnode is empty so just retain it as a typedef to a
	  struct inode to minimise cosmetic change.

fs/xfs/dmapi/xfs_dm_bhv.c - 1.8 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/dmapi/xfs_dm_bhv.c.diff?r1=text&tr1=1.8&r2=text&tr2=1.7&f=h
	- struct bhv_vnode is empty so just retain it as a typedef to a
	  struct inode to minimise cosmetic change.

fs/xfs/dmapi/xfs_dm.c - 1.48 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/dmapi/xfs_dm.c.diff?r1=text&tr1=1.48&r2=text&tr2=1.47&f=h
	- struct bhv_vnode is empty so just retain it as a typedef to a
	  struct inode to minimise cosmetic change.
