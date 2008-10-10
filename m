Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 09 Oct 2008 22:07:26 -0700 (PDT)
Received: from relay.sgi.com (relay1.corp.sgi.com [192.26.58.214])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9A57NHR001505
	for <xfs@oss.sgi.com>; Thu, 9 Oct 2008 22:07:25 -0700
Subject: PATIAL TAKE 988147 - cleanup btree record / key / ptr addressing macros
Message-Id: <20081010050903.354B01F08E9@chapter11.melbourne.sgi.com>
Date: Fri, 10 Oct 2008 16:09:03 +1100 (EST)
From: donaldd@sgi.com (Donald Douwsma)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com, sgi.bugs.xfs@engr.sgi.com

cleanup btree record / key / ptr addressing macros.

Replace the generic record / key / ptr addressing macros that use cpp token
pasting with simpler macros that do the job for just one given btree type.
The new macros lose the cur argument and thus can be used outside the core
btree code, but also gain an xfs_mount * argument to allow for checking the
CRC flag in the near future.  Note that many of these macros aren't actually
used in the kernel code, but only in userspace (mostly in xfs_repair).


Signed-off-by: Christoph Hellwig <hch@lst.de>


Date:  Fri Oct 10 16:08:19 EST 2008
Workarea:  chapter11.melbourne.sgi.com:/scratch/donaldd/isms/2.6.x-xfs
Inspected by:  hch,dchinner

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:32295a
fs/xfs/xfs_ialloc_btree.h - 1.43 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_ialloc_btree.h.diff?r1=text&tr1=1.43&r2=text&tr2=1.42&f=h
	- cleanup btree record / key / ptr addressing macros.

fs/xfs/xfs_bmap_btree.h - 1.93 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_bmap_btree.h.diff?r1=text&tr1=1.93&r2=text&tr2=1.92&f=h
	- cleanup btree record / key / ptr addressing macros.

fs/xfs/xfs_bmap_btree.c - 1.197 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_bmap_btree.c.diff?r1=text&tr1=1.197&r2=text&tr2=1.196&f=h
	- cleanup btree record / key / ptr addressing macros.

fs/xfs/xfs_btree.h - 1.99 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_btree.h.diff?r1=text&tr1=1.99&r2=text&tr2=1.98&f=h
	- cleanup btree record / key / ptr addressing macros.

fs/xfs/xfs_inode.c - 1.528 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_inode.c.diff?r1=text&tr1=1.528&r2=text&tr2=1.527&f=h
	- cleanup btree record / key / ptr addressing macros.

fs/xfs/xfs_fsops.c - 1.137 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_fsops.c.diff?r1=text&tr1=1.137&r2=text&tr2=1.136&f=h
	- cleanup btree record / key / ptr addressing macros.

fs/xfs/xfs_bmap.c - 1.413 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_bmap.c.diff?r1=text&tr1=1.413&r2=text&tr2=1.412&f=h
	- cleanup btree record / key / ptr addressing macros.

fs/xfs/xfs_alloc_btree.h - 1.40 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_alloc_btree.h.diff?r1=text&tr1=1.40&r2=text&tr2=1.39&f=h
	- cleanup btree record / key / ptr addressing macros.

fs/xfs/xfs_alloc_btree.c - 1.112 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_alloc_btree.c.diff?r1=text&tr1=1.112&r2=text&tr2=1.111&f=h
	- cleanup btree record / key / ptr addressing macros.
