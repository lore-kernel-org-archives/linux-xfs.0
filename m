Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 07 Feb 2008 22:42:54 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m186ghiH007821
	for <xfs@oss.sgi.com>; Thu, 7 Feb 2008 22:42:48 -0800
Subject: TAKE 909874 - make inode reclaim synchronise with xfs_iflush_done()
Message-Id: <20080208064300.5F7C358C4C11@chook.melbourne.sgi.com>
Date: Fri,  8 Feb 2008 17:43:00 +1100 (EST)
From: lachlan@sgi.com (Lachlan McIlroy)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

make inode reclaim synchronise with xfs_iflush_done()

On a forced shutdown, xfs_finish_reclaim() will skip flushing the inode.
If the inode flush lock is not already held and there is an outstanding
xfs_iflush_done() then we might free the inode prematurely.  By acquiring
and releasing the flush lock we will synchronise with xfs_iflush_done().


Date:  Fri Feb  8 17:40:49 AEDT 2008
Workarea:  redback.melbourne.sgi.com:/home/lachlan/isms/2.6.x-free
Inspected by:  dgc
Author:  lachlan

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:30468a
fs/xfs/xfs_vnodeops.c - 1.731 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_vnodeops.c.diff?r1=text&tr1=1.731&r2=text&tr2=1.730&f=h
	- make inode reclaim synchronise with xfs_iflush_done()
