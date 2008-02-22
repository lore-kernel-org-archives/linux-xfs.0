Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 21 Feb 2008 18:07:23 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m1M27FOa020361
	for <xfs@oss.sgi.com>; Thu, 21 Feb 2008 18:07:17 -0800
Subject: PARTIAL TAKE 976035 - cleanup xfs_vn_mknod
Message-Id: <20080222020734.B91C958C4C0F@chook.melbourne.sgi.com>
Date: Fri, 22 Feb 2008 13:07:34 +1100 (EST)
From: lachlan@sgi.com (Lachlan McIlroy)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

cleanup xfs_vn_mknod

 - use proper goto based unwinding instead of the current mess of
   multiple conditionals
 - rename ip to inode because that's the normal convention for Linux
   inodes while ip is the convention for xfs_inodes
 - remove unlikely checks for the default_acl - branches marked unlikely
   might lead to extreme branch bredictor slowdons if taken and for some
   workloads a default acl is quite common
 - properly indent the switch statements
 - remove xfs_has_fs_struct as nfsd has a fs_struct in any semi-recent
   kernel


Signed-off-by: Christoph Hellwig <hch@lst.de>

Date:  Fri Feb 22 13:06:33 AEDT 2008
Workarea:  redback.melbourne.sgi.com:/home/lachlan/isms/2.6.x-hch
Inspected by:  lachlan
Author:  lachlan

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:30529a
fs/xfs/linux-2.6/xfs_iops.c - 1.276 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_iops.c.diff?r1=text&tr1=1.276&r2=text&tr2=1.275&f=h
	- cleanup xfs_vn_mknod
