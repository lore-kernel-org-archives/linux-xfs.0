Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 17 Jul 2008 23:36:41 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m6I6aUGW010223
	for <xfs@oss.sgi.com>; Thu, 17 Jul 2008 23:36:32 -0700
Subject: TAKE 984566 - kill vn_revalidate - set inode fields in setattr explicitly
Message-Id: <20080718063734.7AC6458C4C3F@chook.melbourne.sgi.com>
Date: Fri, 18 Jul 2008 16:37:34 +1000 (EST)
From: tes@sgi.com (Tim Shimmin)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com, sgi.bugs.xfs@engr.sgi.com

Remove vn_revalidate calls in xfs.

These days most of the attributes in struct inode are properly kept in
sync by XFS.  This patch removes the need for vn_revalidate completely
by:
 - keeping inode.i_flags uptodate after any flags are updated in
   xfs_ioctl_setattr
 - keeping i_mode, i_uid and i_gid uptodate in xfs_setattr

Signed-off-by: Christoph Hellwig <hch@lst.de>

Date:  Fri Jul 18 16:36:39 AEST 2008
Workarea:  chook.melbourne.sgi.com:/build/tes/2.6.x-xfs-quilt
Inspected by:  hch@lst.de

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:31679a
fs/xfs/xfs_vnodeops.c - 1.765 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_vnodeops.c.diff?r1=text&tr1=1.765&r2=text&tr2=1.764&f=h
	- remove vn_revalidate calls in xfs.

fs/xfs/linux-2.6/xfs_ioctl.c - 1.170 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_ioctl.c.diff?r1=text&tr1=1.170&r2=text&tr2=1.169&f=h
	- remove vn_revalidate calls in xfs.

fs/xfs/linux-2.6/xfs_vnode.c - 1.157 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_vnode.c.diff?r1=text&tr1=1.157&r2=text&tr2=1.156&f=h
	- remove vn_revalidate calls in xfs.

fs/xfs/linux-2.6/xfs_vnode.h - 1.153 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_vnode.h.diff?r1=text&tr1=1.153&r2=text&tr2=1.152&f=h
	- remove vn_revalidate calls in xfs.

fs/xfs/linux-2.6/xfs_iops.c - 1.293 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_iops.c.diff?r1=text&tr1=1.293&r2=text&tr2=1.292&f=h
	- remove vn_revalidate calls in xfs.

fs/xfs/linux-2.6/xfs_ksyms.c - 1.86 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_ksyms.c.diff?r1=text&tr1=1.86&r2=text&tr2=1.85&f=h
	- remove vn_revalidate calls in xfs.

fs/xfs/dmapi/xfs_dm.c - 1.75 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/dmapi/xfs_dm.c.diff?r1=text&tr1=1.75&r2=text&tr2=1.74&f=h
	- remove vn_revalidate calls in xfs.

fs/xfs/linux-2.6/xfs_xattr.c - 1.3 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_xattr.c.diff?r1=text&tr1=1.3&r2=text&tr2=1.2&f=h
	- remove vn_revalidate calls in xfs.
