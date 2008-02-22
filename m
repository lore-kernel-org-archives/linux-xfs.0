Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 21 Feb 2008 18:09:36 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m1M29SXu020757
	for <xfs@oss.sgi.com>; Thu, 21 Feb 2008 18:09:30 -0800
Subject: PARTIAL TAKE 976035 - vnode cleanup in xfs_fs_subr.c
Message-Id: <20080222020949.C725B58C4C0F@chook.melbourne.sgi.com>
Date: Fri, 22 Feb 2008 13:09:49 +1100 (EST)
From: lachlan@sgi.com (Lachlan McIlroy)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

vnode cleanup in xfs_fs_subr.c

Cleanup the unneeded intermediate vnode step in the flushing helpers
and go directly from the xfs_inode to the struct address_space.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Date:  Fri Feb 22 13:09:19 AEDT 2008
Workarea:  redback.melbourne.sgi.com:/home/lachlan/isms/2.6.x-hch
Inspected by:  lachlan
Author:  lachlan

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:30530a
fs/xfs/linux-2.6/xfs_fs_subr.c - 1.53 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_fs_subr.c.diff?r1=text&tr1=1.53&r2=text&tr2=1.52&f=h
	- vnode cleanup in xfs_fs_subr.c
