Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 17 Jan 2008 21:10:37 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m0I5ASCG024216
	for <xfs@oss.sgi.com>; Thu, 17 Jan 2008 21:10:30 -0800
Subject: TAKE 971186 - [PATCH 2/4] clean up xfs_swapext
Message-Id: <20080118051042.B220A58C4C0F@chook.melbourne.sgi.com>
Date: Fri, 18 Jan 2008 16:10:42 +1100 (EST)
From: lachlan@sgi.com (Lachlan McIlroy)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

[PATCH 2/4] clean up xfs_swapext

 - stop using vnodes
 - use proper multiple label goto unwinding
 - give the struct file * variables saner names


Signed-off-by: Christoph Hellwig <hch@lst.de>

Date:  Fri Jan 18 16:09:59 AEDT 2008
Workarea:  redback.melbourne.sgi.com:/home/lachlan/isms/2.6.x-hch
Inspected by:  Christoph Hellwig <hch@lst.de>
Author:  lachlan

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:30366a
fs/xfs/xfs_dfrag.c - 1.64 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_dfrag.c.diff?r1=text&tr1=1.64&r2=text&tr2=1.63&f=h
	- [PATCH 2/4] clean up xfs_swapext
