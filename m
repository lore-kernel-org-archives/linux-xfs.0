Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 21 Apr 2008 01:07:28 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m3L874b0021965
	for <xfs@oss.sgi.com>; Mon, 21 Apr 2008 01:07:08 -0700
Subject: PARTIAL TAKE 976035 - kill usesless IHOLD calls in xfs_remove and xfs_rmdir
Message-Id: <20080421080741.EBE7758C4C15@chook.melbourne.sgi.com>
Date: Mon, 21 Apr 2008 18:07:41 +1000 (EST)
From: lachlan@sgi.com (Lachlan McIlroy)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

kill usesless IHOLD calls in xfs_remove and xfs_rmdir

The VFS always has an inode reference when we call these functions.  So
we only need to grab a signle reference to each inode that's joined to
a transaction - all the other bumping and dropping is as useless as the
comments describing the IRIX semantics.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Date:  Mon Apr 21 18:07:13 AEST 2008
Workarea:  redback.melbourne.sgi.com:/home/lachlan/isms/2.6.x-hch
Inspected by:  hch
Author:  lachlan

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:30912a
fs/xfs/xfs_vnodeops.c - 1.757 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_vnodeops.c.diff?r1=text&tr1=1.757&r2=text&tr2=1.756&f=h
	- kill usesless IHOLD calls in xfs_remove and xfs_rmdir
