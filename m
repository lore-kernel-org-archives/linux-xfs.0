Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 24 Aug 2007 04:55:26 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l7OBtJ4p012391
	for <xfs@oss.sgi.com>; Fri, 24 Aug 2007 04:55:22 -0700
Subject: PARTIAL TAKE 969608 - call common xfs vfs-level helpers directly and remove vfs operations
Message-Id: <20070824115514.1B53C58C38F1@chook.melbourne.sgi.com>
Date: Fri, 24 Aug 2007 21:55:13 +1000 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

call common xfs vfs-level helpers directly and remove vfs operations

Also remove the now dead behavior code.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Date:  Fri Aug 24 21:54:45 AEST 2007
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  hch@lst.de

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:29505a
fs/xfs/xfsidbg.c - 1.329 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfsidbg.c.diff?r1=text&tr1=1.329&r2=text&tr2=1.328&f=h
	- remove vfs operations.

fs/xfs/xfs_vfsops.c - 1.534 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_vfsops.c.diff?r1=text&tr1=1.534&r2=text&tr2=1.533&f=h
	- remove vfs operations.

fs/xfs/xfs_iget.c - 1.231 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_iget.c.diff?r1=text&tr1=1.231&r2=text&tr2=1.230&f=h
	- remove vfs operations.

fs/xfs/xfs_mount.h - 1.246 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_mount.h.diff?r1=text&tr1=1.246&r2=text&tr2=1.245&f=h
	- remove vfs operations.

fs/xfs/xfs_mount.c - 1.405 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_mount.c.diff?r1=text&tr1=1.405&r2=text&tr2=1.404&f=h
	- remove vfs operations.

fs/xfs/xfs_inode.c - 1.477 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_inode.c.diff?r1=text&tr1=1.477&r2=text&tr2=1.476&f=h
	- remove vfs operations.

fs/xfs/Makefile-linux-2.6 - 1.212 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/Makefile-linux-2.6.diff?r1=text&tr1=1.212&r2=text&tr2=1.211&f=h
	- remove vfs operations.

fs/xfs/xfs_behavior.c - 1.27 - deleted
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_behavior.c.diff?r1=text&tr1=1.27&r2=text&tr2=1.26&f=h
	- remove the now dead behaviour code.

fs/xfs/xfs_behavior.h - 1.24 - deleted
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_behavior.h.diff?r1=text&tr1=1.24&r2=text&tr2=1.23&f=h
	- remove the now dead behaviour code.

fs/xfs/linux-2.6/xfs_lrw.h - 1.59 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_lrw.h.diff?r1=text&tr1=1.59&r2=text&tr2=1.58&f=h
	- remove vfs operations.

fs/xfs/linux-2.6/xfs_vfs.h - 1.76 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_vfs.h.diff?r1=text&tr1=1.76&r2=text&tr2=1.75&f=h
	- remove vfs operations.

fs/xfs/linux-2.6/xfs_vfs.c - 1.80 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_vfs.c.diff?r1=text&tr1=1.80&r2=text&tr2=1.79&f=h
	- remove vfs operations.

fs/xfs/linux-2.6/xfs_linux.h - 1.157 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_linux.h.diff?r1=text&tr1=1.157&r2=text&tr2=1.156&f=h
	- remove vfs operations.

fs/xfs/linux-2.6/xfs_vnode.c - 1.150 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_vnode.c.diff?r1=text&tr1=1.150&r2=text&tr2=1.149&f=h
	- remove vfs operations.

fs/xfs/linux-2.6/xfs_super.h - 1.73 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_super.h.diff?r1=text&tr1=1.73&r2=text&tr2=1.72&f=h
	- remove vfs operations.

fs/xfs/linux-2.6/xfs_super.c - 1.392 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_super.c.diff?r1=text&tr1=1.392&r2=text&tr2=1.391&f=h
	- remove vfs operations.

fs/xfs/linux-2.6/xfs_ksyms.c - 1.69 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_ksyms.c.diff?r1=text&tr1=1.69&r2=text&tr2=1.68&f=h
	- remove vfs operations.

fs/xfs/linux-2.6/xfs_export.c - 1.15 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_export.c.diff?r1=text&tr1=1.15&r2=text&tr2=1.14&f=h
	- remove vfs operations.

fs/xfs/dmapi/xfs_dm_fsops.c - 1.11 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/dmapi/xfs_dm_fsops.c.diff?r1=text&tr1=1.11&r2=text&tr2=1.10&f=h
	- remove vfs operations.

fs/xfs/xfs_vfsops_bhv.c - 1.2 - deleted
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_vfsops_bhv.c.diff?r1=text&tr1=1.2&r2=text&tr2=1.1&f=h
	- remove vfs operations.

fs/xfs/xfs_vfsops.h - 1.2 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_vfsops.h.diff?r1=text&tr1=1.2&r2=text&tr2=1.1&f=h
	- remove vfs operations.
