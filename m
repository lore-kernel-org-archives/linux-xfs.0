Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 17 Jan 2008 21:18:06 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m0I5HrZL025425
	for <xfs@oss.sgi.com>; Thu, 17 Jan 2008 21:17:58 -0800
Subject: TAKE 971186 - [PATCH 4/4] use generic_permission
Message-Id: <20080118051807.CBC3258C4C0F@chook.melbourne.sgi.com>
Date: Fri, 18 Jan 2008 16:18:07 +1100 (EST)
From: lachlan@sgi.com (Lachlan McIlroy)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

[PATCH 4/4] use generic_permission

Now that all direct caller of xfs_iaccess are gone we can kill
xfs_iaccess and xfs_access and just use generic_permission with a
check_acl callback.  This is required for the per-mount read-only
patchset in -mm to work properly with XFS.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Date:  Fri Jan 18 16:15:08 AEDT 2008
Workarea:  redback.melbourne.sgi.com:/home/lachlan/isms/2.6.x-hch
Inspected by:  Christoph Hellwig <hch@lst.de>
Author:  lachlan

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:30370a
fs/xfs/xfs_vnodeops.c - 1.729 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_vnodeops.c.diff?r1=text&tr1=1.729&r2=text&tr2=1.728&f=h
fs/xfs/xfs_acl.h - 1.37 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_acl.h.diff?r1=text&tr1=1.37&r2=text&tr2=1.36&f=h
fs/xfs/xfs_acl.c - 1.68 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_acl.c.diff?r1=text&tr1=1.68&r2=text&tr2=1.67&f=h
fs/xfs/xfs_inode.c - 1.490 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_inode.c.diff?r1=text&tr1=1.490&r2=text&tr2=1.489&f=h
fs/xfs/xfs_inode.h - 1.240 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_inode.h.diff?r1=text&tr1=1.240&r2=text&tr2=1.239&f=h
fs/xfs/linux-2.6/xfs_iops.c - 1.273 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_iops.c.diff?r1=text&tr1=1.273&r2=text&tr2=1.272&f=h
fs/xfs/linux-2.6/xfs_ksyms.c - 1.77 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_ksyms.c.diff?r1=text&tr1=1.77&r2=text&tr2=1.76&f=h
fs/xfs/xfs_vnodeops.h - 1.6 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_vnodeops.h.diff?r1=text&tr1=1.6&r2=text&tr2=1.5&f=h
	- use generic_permission
