Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 24 Jul 2008 19:43:13 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m6P2hAf8031106
	for <xfs@oss.sgi.com>; Thu, 24 Jul 2008 19:43:11 -0700
Subject: TAKE 981498 - implement IHOLD/IRELE directly
Message-Id: <20080725024420.1B62A58C4C3F@chook.melbourne.sgi.com>
Date: Fri, 25 Jul 2008 12:44:19 +1000 (EST)
From: lachlan@sgi.com (Lachlan McIlroy)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

implement IHOLD/IRELE directly

Now that all direct calls to VN_HOLD/VN_RELE are gone we can implement
IHOLD/IRELE directly.

For the IHOLD case also replace igrab with a direct increment of i_count
because we are guaranteed to already have a live and referenced inode
by the VFS.  Also remove the vn_hold statistic because it's been rather
meaningless for some time with most references done by other callers.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Date:  Fri Jul 25 12:43:32 AEST 2008
Workarea:  redback.melbourne.sgi.com:/home/lachlan/isms/2.6.x-hch
Inspected by:  
hch
lachlan
Author:  lachlan

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:31764a
fs/xfs/xfs_utils.h - 1.44 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_utils.h.diff?r1=text&tr1=1.44&r2=text&tr2=1.43&f=h
fs/xfs/linux-2.6/xfs_vnode.c - 1.160 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_vnode.c.diff?r1=text&tr1=1.160&r2=text&tr2=1.159&f=h
fs/xfs/linux-2.6/xfs_vnode.h - 1.157 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_vnode.h.diff?r1=text&tr1=1.157&r2=text&tr2=1.156&f=h
fs/xfs/linux-2.6/xfs_ksyms.c - 1.87 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_ksyms.c.diff?r1=text&tr1=1.87&r2=text&tr2=1.86&f=h
	- implement IHOLD/IRELE directly
