Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 22 Jul 2008 23:35:15 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m6N6Z812029900
	for <xfs@oss.sgi.com>; Tue, 22 Jul 2008 23:35:10 -0700
Subject: TAKE 981498 -  XFS: Avoid directly referencing the VFS inode V2
Message-Id: <20080723063612.8939B58C4C3F@chook.melbourne.sgi.com>
Date: Wed, 23 Jul 2008 16:36:12 +1000 (EST)
From: xaiki@sgi.com (Niv Sardi-Altivanik)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

In several places we directly convert from the XFS inode
to the linux (VFS) inode by a simple deference of ip->i_vnode.
We should not do this - a helper function should be used to
extract the VFS inode from the XFS inode.

Introduce the function VFS_I() to extract the VFS inode
from the XFS inode. The name was chosen to match XFS_I() which
is used to extract the XFS inode from the VFS inode.

Version 2:
o don't use vn_to_inode() and inode_to_vn() functions as they
  are not needed

Signed-off-by: Dave Chinner <david@fromorbit.com>


Date:  Wed Jul 23 16:32:07 AEST 2008
Workarea:  itchy.melbourne.sgi.com:/i386/home/xaiki/Wrk/ptools/xfs-2.6
Inspected by:  dchinner,hch,xaiki

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:31720a
fs/xfs/xfs_iget.c - 1.242 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_iget.c.diff?r1=text&tr1=1.242&r2=text&tr2=1.241&f=h
fs/xfs/xfs_inode.h - 1.247 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_inode.h.diff?r1=text&tr1=1.247&r2=text&tr2=1.246&f=h
fs/xfs/xfs_utils.c - 1.85 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_utils.c.diff?r1=text&tr1=1.85&r2=text&tr2=1.84&f=h
fs/xfs/linux-2.6/xfs_lrw.c - 1.281 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_lrw.c.diff?r1=text&tr1=1.281&r2=text&tr2=1.280&f=h
fs/xfs/linux-2.6/xfs_fs_subr.c - 1.54 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_fs_subr.c.diff?r1=text&tr1=1.54&r2=text&tr2=1.53&f=h
fs/xfs/linux-2.6/xfs_super.c - 1.436 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_super.c.diff?r1=text&tr1=1.436&r2=text&tr2=1.435&f=h
fs/xfs/linux-2.6/xfs_iops.c - 1.294 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_iops.c.diff?r1=text&tr1=1.294&r2=text&tr2=1.293&f=h
fs/xfs/linux-2.6/xfs_iops.h - 1.35 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_iops.h.diff?r1=text&tr1=1.35&r2=text&tr2=1.34&f=h
fs/xfs/linux-2.6/xfs_export.c - 1.25 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_export.c.diff?r1=text&tr1=1.25&r2=text&tr2=1.24&f=h
