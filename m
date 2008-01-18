Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 17 Jan 2008 21:07:56 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m0I57lpZ023744
	for <xfs@oss.sgi.com>; Thu, 17 Jan 2008 21:07:51 -0800
Subject: TAKE 971186 - [PATCH 1/4] remove permission check from xfs_change_file_space
Message-Id: <20080118050800.CB1B458C4C0F@chook.melbourne.sgi.com>
Date: Fri, 18 Jan 2008 16:08:00 +1100 (EST)
From: lachlan@sgi.com (Lachlan McIlroy)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

[PATCH 1/4] remove permission check from xfs_change_file_space

Both callers of xfs_change_file_space alreaedy do the
file->f_mode & FMODE_WRITE check to ensure we have a file descriptor
that has been opened for write mode, so there is no need to re-check
that with xfs_iaccess.  Especially as the later might wrongly deny it
for corner cases like file descriptor passing through unix domain
sockets.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Date:  Fri Jan 18 16:07:07 AEDT 2008
Workarea:  redback.melbourne.sgi.com:/home/lachlan/isms/2.6.x-hch
Inspected by:  Christoph Hellwig <hch@lst.de>
Author:  lachlan

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:30365a
fs/xfs/xfs_vnodeops.c - 1.728 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_vnodeops.c.diff?r1=text&tr1=1.728&r2=text&tr2=1.727&f=h
	- remove permission check from xfs_change_file_space
