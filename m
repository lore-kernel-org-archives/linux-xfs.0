Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 24 Aug 2007 03:44:11 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l7OAi54p024080
	for <xfs@oss.sgi.com>; Fri, 24 Aug 2007 03:44:07 -0700
Subject: PARTIAL TAKE 969608 - decontaminate vnode operations from behavior details
Message-Id: <20070824104400.2BBFA58C38F1@chook.melbourne.sgi.com>
Date: Fri, 24 Aug 2007 20:44:00 +1000 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

decontaminate vnode operations from behavior details

All vnode ops now take struct xfs_inode pointers and the behaviour
related glue is split out into methods of it's own.  This required
fixing xfs_create/mkdir/symlink to not mess with the inode pointer
but rather use a separate boolean for error handling.  Thanks to
Dave Chinner for that fix.


Signed-off-by: Christoph Hellwig <hch@lst.de>


Date:  Fri Aug 24 20:43:23 AEST 2007
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  hch@lst.de

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:29492a
fs/xfs/xfs_vnodeops_bhv.c - 1.1 - new
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_vnodeops_bhv.c
	- convert vnode ops to take xfs_inode pointers and separate out
	  behaviour related glue.

fs/xfs/xfs_vnodeops.h - 1.1 - new
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_vnodeops.h
	- convert vnode ops to take xfs_inode pointers and separate out
	  behaviour related glue.

fs/xfs/xfs_rw.h - 1.84 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_rw.h.diff?r1=text&tr1=1.84&r2=text&tr2=1.83&f=h
	- convert vnode ops to take xfs_inode pointers and separate out
	  behaviour related glue.

fs/xfs/xfs_vnodeops.c - 1.709 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_vnodeops.c.diff?r1=text&tr1=1.709&r2=text&tr2=1.708&f=h
	- convert vnode ops to take xfs_inode pointers and separate out
	  behaviour related glue.

fs/xfs/xfs_utils.c - 1.75 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_utils.c.diff?r1=text&tr1=1.75&r2=text&tr2=1.74&f=h
	- convert vnode ops to take xfs_inode pointers and separate out
	  behaviour related glue.

fs/xfs/xfs_utils.h - 1.36 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_utils.h.diff?r1=text&tr1=1.36&r2=text&tr2=1.35&f=h
	- convert vnode ops to take xfs_inode pointers and separate out
	  behaviour related glue.

fs/xfs/xfs_bmap.h - 1.101 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_bmap.h.diff?r1=text&tr1=1.101&r2=text&tr2=1.100&f=h
	- convert vnode ops to take xfs_inode pointers and separate out
	  behaviour related glue.

fs/xfs/xfs_bmap.c - 1.377 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_bmap.c.diff?r1=text&tr1=1.377&r2=text&tr2=1.376&f=h
	- convert vnode ops to take xfs_inode pointers and separate out
	  behaviour related glue.

fs/xfs/xfs_rename.c - 1.73 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_rename.c.diff?r1=text&tr1=1.73&r2=text&tr2=1.72&f=h
	- convert vnode ops to take xfs_inode pointers and separate out
	  behaviour related glue.

fs/xfs/xfs_attr.c - 1.144 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_attr.c.diff?r1=text&tr1=1.144&r2=text&tr2=1.143&f=h
	- convert vnode ops to take xfs_inode pointers and separate out
	  behaviour related glue.

fs/xfs/xfs_attr.h - 1.37 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_attr.h.diff?r1=text&tr1=1.37&r2=text&tr2=1.36&f=h
	- convert vnode ops to take xfs_inode pointers and separate out
	  behaviour related glue.

fs/xfs/xfs_dir2.h - 1.21 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_dir2.h.diff?r1=text&tr1=1.21&r2=text&tr2=1.20&f=h
	- convert vnode ops to take xfs_inode pointers and separate out
	  behaviour related glue.

fs/xfs/xfs_dir2.c - 1.58 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_dir2.c.diff?r1=text&tr1=1.58&r2=text&tr2=1.57&f=h
	- convert vnode ops to take xfs_inode pointers and separate out
	  behaviour related glue.

fs/xfs/Makefile-linux-2.6 - 1.209 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/Makefile-linux-2.6.diff?r1=text&tr1=1.209&r2=text&tr2=1.208&f=h
	- convert vnode ops to take xfs_inode pointers and separate out
	  behaviour related glue.

fs/xfs/linux-2.6/xfs_lrw.h - 1.57 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_lrw.h.diff?r1=text&tr1=1.57&r2=text&tr2=1.56&f=h
	- convert vnode ops to take xfs_inode pointers and separate out
	  behaviour related glue.

fs/xfs/linux-2.6/xfs_lrw.c - 1.263 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_lrw.c.diff?r1=text&tr1=1.263&r2=text&tr2=1.262&f=h
	- convert vnode ops to take xfs_inode pointers and separate out
	  behaviour related glue.

fs/xfs/linux-2.6/xfs_ioctl.c - 1.147 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_ioctl.c.diff?r1=text&tr1=1.147&r2=text&tr2=1.146&f=h
	- convert vnode ops to take xfs_inode pointers and separate out
	  behaviour related glue.

fs/xfs/linux-2.6/xfs_fs_subr.c - 1.51 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_fs_subr.c.diff?r1=text&tr1=1.51&r2=text&tr2=1.50&f=h
	- convert vnode ops to take xfs_inode pointers and separate out
	  behaviour related glue.

fs/xfs/linux-2.6/xfs_fs_subr.h - 1.15 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_fs_subr.h.diff?r1=text&tr1=1.15&r2=text&tr2=1.14&f=h
	- convert vnode ops to take xfs_inode pointers and separate out
	  behaviour related glue.

fs/xfs/linux-2.6/xfs_iops.h - 1.31 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_iops.h.diff?r1=text&tr1=1.31&r2=text&tr2=1.30&f=h
	- convert vnode ops to take xfs_inode pointers and separate out
	  behaviour related glue.

fs/xfs/linux-2.6/xfs_ksyms.c - 1.65 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_ksyms.c.diff?r1=text&tr1=1.65&r2=text&tr2=1.64&f=h
	- convert vnode ops to take xfs_inode pointers and separate out
	  behaviour related glue.

fs/xfs/dmapi/xfs_dm.c - 1.44 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/dmapi/xfs_dm.c.diff?r1=text&tr1=1.44&r2=text&tr2=1.43&f=h
	- convert vnode ops to take xfs_inode pointers and separate out
	  behaviour related glue.
