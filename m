Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 22 Jul 2008 23:56:22 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m6N6uHnF031266
	for <xfs@oss.sgi.com>; Tue, 22 Jul 2008 23:56:19 -0700
Subject: TAKE 981498 - XFS: Avoid directly referencing the VFS inode V2 
Message-Id: <20080723065721.1408058C4C3F@chook.melbourne.sgi.com>
Date: Wed, 23 Jul 2008 16:57:20 +1000 (EST)
From: xaiki@sgi.com (Niv Sardi-Altivanik)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

Avoid directly referencing the VFS inode V2

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


Date:  Wed Jul 23 16:56:24 AEST 2008
Workarea:  itchy.melbourne.sgi.com:/i386/home/xaiki/Wrk/ptools/xfs-2.6
Inspected by:  dgc,hch,xaiki

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:31722a
fs/xfs/xfsidbg.c - 1.354 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfsidbg.c.diff?r1=text&tr1=1.354&r2=text&tr2=1.353&f=h
fs/xfs/xfs_vnodeops.c - 1.766 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_vnodeops.c.diff?r1=text&tr1=1.766&r2=text&tr2=1.765&f=h
fs/xfs/xfs_vfsops.c - 1.571 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_vfsops.c.diff?r1=text&tr1=1.571&r2=text&tr2=1.570&f=h
fs/xfs/xfs_inode.c - 1.507 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_inode.c.diff?r1=text&tr1=1.507&r2=text&tr2=1.506&f=h
fs/xfs/xfs_inode.h - 1.248 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_inode.h.diff?r1=text&tr1=1.248&r2=text&tr2=1.247&f=h
fs/xfs/quota/xfs_qm_syscalls.c - 1.45 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/quota/xfs_qm_syscalls.c.diff?r1=text&tr1=1.45&r2=text&tr2=1.44&f=h
fs/xfs/linux-2.6/xfs_vnode.c - 1.158 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_vnode.c.diff?r1=text&tr1=1.158&r2=text&tr2=1.157&f=h
