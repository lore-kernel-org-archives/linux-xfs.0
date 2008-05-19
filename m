Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 19 May 2008 00:23:56 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m4J7NnLX002172
	for <xfs@oss.sgi.com>; Mon, 19 May 2008 00:23:51 -0700
Subject: PARTIAL TAKE 981498 - kill xfs_igrow_start and xfs_igrow_finish
Message-Id: <20080519072435.7CFBA58C4C29@chook.melbourne.sgi.com>
Date: Mon, 19 May 2008 17:24:35 +1000 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

kill xfs_igrow_start and xfs_igrow_finish

xfs_igrow_start just expands to xfs_zero_eof with two asserts that are
useless in the context of the only caller and some rather confusing
comments.

xfs_igrow_finish is just a few lines of code decorated again with
useless asserts and confusing comments.

Just kill those two and merge them into xfs_setattr.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Date:  Mon May 19 17:24:15 AEST 2008
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  hch@lst.de

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:31186a
fs/xfs/xfs_vnodeops.c - 1.759 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_vnodeops.c.diff?r1=text&tr1=1.759&r2=text&tr2=1.758&f=h
	- kill xfs_igrow_start and xfs_igrow_finish.

fs/xfs/xfs_inode.c - 1.504 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_inode.c.diff?r1=text&tr1=1.504&r2=text&tr2=1.503&f=h
	- kill xfs_igrow_start and xfs_igrow_finish.

fs/xfs/xfs_inode.h - 1.246 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_inode.h.diff?r1=text&tr1=1.246&r2=text&tr2=1.245&f=h
	- kill xfs_igrow_start and xfs_igrow_finish.

fs/xfs/linux-2.6/xfs_ksyms.c - 1.84 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_ksyms.c.diff?r1=text&tr1=1.84&r2=text&tr2=1.83&f=h
	- kill xfs_igrow_start and xfs_igrow_finish.
