Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 20 Apr 2008 21:58:10 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m3L4vnou000643
	for <xfs@oss.sgi.com>; Sun, 20 Apr 2008 21:57:52 -0700
Subject: PARTIAL TAKE 976035 - kill di_mode checks after xfs_iget
Message-Id: <20080421045823.9E26558C4C15@chook.melbourne.sgi.com>
Date: Mon, 21 Apr 2008 14:58:23 +1000 (EST)
From: lachlan@sgi.com (Lachlan McIlroy)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

kill di_mode checks after xfs_iget

Unless XFS_IGET_CREATE is passed xfs_iget will return ENOENT if it
encounters an inode with di_mode == 0.  Remove the duplicated checks
in the callers.

(the log recovery case is not touched for now)


Signed-off-by: Christoph Hellwig <hch@lst.de>

Date:  Mon Apr 21 14:57:50 AEST 2008
Workarea:  redback.melbourne.sgi.com:/home/lachlan/isms/2.6.x-hch
Inspected by:  hch
Author:  lachlan

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:30898a
fs/xfs/xfs_itable.c - 1.164 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_itable.c.diff?r1=text&tr1=1.164&r2=text&tr2=1.163&f=h
fs/xfs/quota/xfs_qm_syscalls.c - 1.42 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/quota/xfs_qm_syscalls.c.diff?r1=text&tr1=1.42&r2=text&tr2=1.41&f=h
fs/xfs/quota/xfs_qm.c - 1.67 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/quota/xfs_qm.c.diff?r1=text&tr1=1.67&r2=text&tr2=1.66&f=h
fs/xfs/linux-2.6/xfs_ioctl.c - 1.164 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_ioctl.c.diff?r1=text&tr1=1.164&r2=text&tr2=1.163&f=h
fs/xfs/linux-2.6/xfs_export.c - 1.23 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_export.c.diff?r1=text&tr1=1.23&r2=text&tr2=1.22&f=h
fs/xfs/dmapi/xfs_dm.c - 1.69 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/dmapi/xfs_dm.c.diff?r1=text&tr1=1.69&r2=text&tr2=1.68&f=h
	- kill di_mode checks after xfs_iget
