Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 23 Aug 2007 05:44:35 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l7NCiS4p027257
	for <xfs@oss.sgi.com>; Thu, 23 Aug 2007 05:44:32 -0700
Subject: PARTIAL TAKE 968563 - stop using uio in the readlink code
Message-Id: <20070823124424.99C7858C38F1@chook.melbourne.sgi.com>
Date: Thu, 23 Aug 2007 22:44:24 +1000 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

stop using uio in the readlink code

Simplify the readlink code to get rid of the last user of uio.


Signed-off-by: Christoph Hellwig <hch@lst.de>


Date:  Thu Aug 23 22:43:50 AEST 2007
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  hch@lst.de

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:29479a
fs/xfs/xfs_vnodeops.c - 1.707 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_vnodeops.c.diff?r1=text&tr1=1.707&r2=text&tr2=1.706&f=h
	- stop using uio in the readlink code.

fs/xfs/linux-2.6/xfs_ioctl.c - 1.146 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_ioctl.c.diff?r1=text&tr1=1.146&r2=text&tr2=1.145&f=h
	- stop using uio in the readlink code.

fs/xfs/linux-2.6/xfs_vnode.h - 1.130 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_vnode.h.diff?r1=text&tr1=1.130&r2=text&tr2=1.129&f=h
	- stop using uio in the readlink code.

fs/xfs/linux-2.6/xfs_iops.c - 1.259 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_iops.c.diff?r1=text&tr1=1.259&r2=text&tr2=1.258&f=h
	- stop using uio in the readlink code.
