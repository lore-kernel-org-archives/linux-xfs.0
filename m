Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 24 Aug 2007 03:50:42 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l7OAob4p025628
	for <xfs@oss.sgi.com>; Fri, 24 Aug 2007 03:50:38 -0700
Subject: PARTIAL TAKE 969608 - remove vnode operations
Message-Id: <20070824105033.3385458C38F1@chook.melbourne.sgi.com>
Date: Fri, 24 Aug 2007 20:50:32 +1000 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

call common xfs vnode-level helpers directly and remove vnode operations

Signed-off-by: Christoph Hellwig <hch@lst.de>


Date:  Fri Aug 24 20:48:51 AEST 2007
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  hch@lst.de

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:29493a
fs/xfs/xfsidbg.c - 1.324 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfsidbg.c.diff?r1=text&tr1=1.324&r2=text&tr2=1.323&f=h
	- remove vnode operations.

fs/xfs/xfs_vnodeops.c - 1.710 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_vnodeops.c.diff?r1=text&tr1=1.710&r2=text&tr2=1.709&f=h
	- remove vnode operations.

fs/xfs/xfs_vfsops.c - 1.528 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_vfsops.c.diff?r1=text&tr1=1.528&r2=text&tr2=1.527&f=h
	- remove vnode operations.

fs/xfs/xfs_dfrag.c - 1.60 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_dfrag.c.diff?r1=text&tr1=1.60&r2=text&tr2=1.59&f=h
	- remove vnode operations.

fs/xfs/xfs_iget.c - 1.227 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_iget.c.diff?r1=text&tr1=1.227&r2=text&tr2=1.226&f=h
	- remove vnode operations.

fs/xfs/xfs_mount.h - 1.241 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_mount.h.diff?r1=text&tr1=1.241&r2=text&tr2=1.240&f=h
	- remove vnode operations.

fs/xfs/xfs_acl.c - 1.64 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_acl.c.diff?r1=text&tr1=1.64&r2=text&tr2=1.63&f=h
	- remove vnode operations.

fs/xfs/xfs_inode.c - 1.473 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_inode.c.diff?r1=text&tr1=1.473&r2=text&tr2=1.472&f=h
	- remove vnode operations.

fs/xfs/xfs_inode.h - 1.226 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_inode.h.diff?r1=text&tr1=1.226&r2=text&tr2=1.225&f=h
	- remove vnode operations.

fs/xfs/xfs_bmap.c - 1.378 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_bmap.c.diff?r1=text&tr1=1.378&r2=text&tr2=1.377&f=h
	- remove vnode operations.

fs/xfs/xfs_rename.c - 1.74 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_rename.c.diff?r1=text&tr1=1.74&r2=text&tr2=1.73&f=h
	- remove vnode operations.

fs/xfs/xfs_attr.c - 1.145 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_attr.c.diff?r1=text&tr1=1.145&r2=text&tr2=1.144&f=h
	- remove vnode operations.

fs/xfs/Makefile-linux-2.6 - 1.210 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/Makefile-linux-2.6.diff?r1=text&tr1=1.210&r2=text&tr2=1.209&f=h
	- remove vnode operations.

fs/xfs/linux-2.6/xfs_lrw.c - 1.264 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_lrw.c.diff?r1=text&tr1=1.264&r2=text&tr2=1.263&f=h
	- remove vnode operations.

fs/xfs/linux-2.6/xfs_ioctl.c - 1.148 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_ioctl.c.diff?r1=text&tr1=1.148&r2=text&tr2=1.147&f=h
	- remove vnode operations.

fs/xfs/linux-2.6/xfs_vfs.h - 1.72 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_vfs.h.diff?r1=text&tr1=1.72&r2=text&tr2=1.71&f=h
	- remove vnode operations.

fs/xfs/linux-2.6/xfs_vfs.c - 1.75 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_vfs.c.diff?r1=text&tr1=1.75&r2=text&tr2=1.74&f=h
	- remove vnode operations.

fs/xfs/linux-2.6/xfs_file.c - 1.153 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_file.c.diff?r1=text&tr1=1.153&r2=text&tr2=1.152&f=h
	- remove vnode operations.

fs/xfs/linux-2.6/xfs_vnode.c - 1.144 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_vnode.c.diff?r1=text&tr1=1.144&r2=text&tr2=1.143&f=h
	- remove vnode operations.

fs/xfs/linux-2.6/xfs_vnode.h - 1.131 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_vnode.h.diff?r1=text&tr1=1.131&r2=text&tr2=1.130&f=h
	- remove vnode operations.

fs/xfs/linux-2.6/xfs_super.h - 1.70 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_super.h.diff?r1=text&tr1=1.70&r2=text&tr2=1.69&f=h
	- remove vnode operations.

fs/xfs/linux-2.6/xfs_super.c - 1.385 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_super.c.diff?r1=text&tr1=1.385&r2=text&tr2=1.384&f=h
	- remove vnode operations.

fs/xfs/linux-2.6/xfs_iops.c - 1.260 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_iops.c.diff?r1=text&tr1=1.260&r2=text&tr2=1.259&f=h
	- remove vnode operations.

fs/xfs/linux-2.6/xfs_iops.h - 1.32 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_iops.h.diff?r1=text&tr1=1.32&r2=text&tr2=1.31&f=h
	- remove vnode operations.

fs/xfs/linux-2.6/xfs_aops.c - 1.148 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_aops.c.diff?r1=text&tr1=1.148&r2=text&tr2=1.147&f=h
	- remove vnode operations.

fs/xfs/linux-2.6/xfs_ksyms.c - 1.66 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_ksyms.c.diff?r1=text&tr1=1.66&r2=text&tr2=1.65&f=h
	- remove vnode operations.

fs/xfs/linux-2.6/xfs_ioctl32.c - 1.19 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_ioctl32.c.diff?r1=text&tr1=1.19&r2=text&tr2=1.18&f=h
	- remove vnode operations.

fs/xfs/linux-2.6/xfs_export.c - 1.14 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_export.c.diff?r1=text&tr1=1.14&r2=text&tr2=1.13&f=h
	- remove vnode operations.

fs/xfs/dmapi/xfs_dm_fsops.c - 1.8 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/dmapi/xfs_dm_fsops.c.diff?r1=text&tr1=1.8&r2=text&tr2=1.7&f=h
	- remove vnode operations.

fs/xfs/dmapi/xfs_dm_bhv.c - 1.7 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/dmapi/xfs_dm_bhv.c.diff?r1=text&tr1=1.7&r2=text&tr2=1.6&f=h
	- remove vnode operations.

fs/xfs/dmapi/xfs_dm.c - 1.45 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/dmapi/xfs_dm.c.diff?r1=text&tr1=1.45&r2=text&tr2=1.44&f=h
	- remove vnode operations.

fs/xfs/xfs_vnodeops_bhv.c - 1.2 - deleted
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_vnodeops_bhv.c.diff?r1=text&tr1=1.2&r2=text&tr2=1.1&f=h
	- remove vnode operations.
