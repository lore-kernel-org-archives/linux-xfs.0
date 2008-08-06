Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 05 Aug 2008 21:55:57 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m764th2a024217
	for <xfs@oss.sgi.com>; Tue, 5 Aug 2008 21:55:45 -0700
Subject: TAKE 981498 - stop using file_update_time
Message-Id: <20080806045655.3489958C52A4@chook.melbourne.sgi.com>
Date: Wed,  6 Aug 2008 14:56:55 +1000 (EST)
From: lachlan@sgi.com (Lachlan McIlroy)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

stop using file_update_time

xfs_ichtime updates the xfs_inode and Linux inode timestamps just fine,
no need to call file_update_time and then copy the values over to the
XFS inode.  The only additional thing in file_update_time are checks
not applicable to the write path.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Date:  Wed Aug  6 14:56:16 AEST 2008
Workarea:  redback.melbourne.sgi.com:/home/lachlan/isms/2.6.x-mm
Inspected by:  
hch
lachlan
david@fromorbit.com
Author:  lachlan

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:31829a
fs/xfs/linux-2.6/xfs_lrw.c - 1.282 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_lrw.c.diff?r1=text&tr1=1.282&r2=text&tr2=1.281&f=h
fs/xfs/linux-2.6/xfs_iops.c - 1.299 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_iops.c.diff?r1=text&tr1=1.299&r2=text&tr2=1.298&f=h
fs/xfs/linux-2.6/xfs_iops.h - 1.37 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_iops.h.diff?r1=text&tr1=1.37&r2=text&tr2=1.36&f=h
fs/xfs/linux-2.6/xfs_ksyms.c - 1.89 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_ksyms.c.diff?r1=text&tr1=1.89&r2=text&tr2=1.88&f=h
	- stop using file_update_time
