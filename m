Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 08 Jul 2007 23:05:43 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l6965ctL030975
	for <xfs@oss.sgi.com>; Sun, 8 Jul 2007 23:05:40 -0700
Subject: TAKE 967354 - new compat ioctl handlers
Message-Id: <20070709060536.EAC6358C38F1@chook.melbourne.sgi.com>
Date: Mon,  9 Jul 2007 16:05:36 +1000 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Fix XFS_IOC_FSBULKSTAT{,_SINGLE} and XFS_IOC_FSINUMBERS in compat mode

* 32bit struct xfs_fsop_bulkreq has different size and layout of
  members, no matter the alignment. Move the code out of the #else
  branch (why was it there in the first place?). Define _32 variants of
  the ioctl constants.
* 32bit struct xfs_bstat is different because of time_t and on
  i386 because of different padding. Make xfs_bulkstat_one() accept a
  custom "output formatter" in the private_data argument which takes care
  of the xfs_bulkstat_one_compat() that takes care of the different
  layout in the compat case.
* i386 struct xfs_inogrp has different padding. Add a similar "output
  formatter" mecanism to xfs_inumbers().

Signed-Off-By: Michal Marek <mmarek@suse.cz>

Date:  Mon Jul  9 16:05:13 AEST 2007
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  mmarek@suse.cz

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:29102a
fs/xfs/xfs_itable.c - 1.152 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_itable.c.diff?r1=text&tr1=1.152&r2=text&tr2=1.151&f=h
	- Fix XFS_IOC_FSBULKSTAT{,_SINGLE} and XFS_IOC_FSINUMBERS in compat mode

fs/xfs/xfs_itable.h - 1.51 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_itable.h.diff?r1=text&tr1=1.51&r2=text&tr2=1.50&f=h
	- Fix XFS_IOC_FSBULKSTAT{,_SINGLE} and XFS_IOC_FSINUMBERS in compat mode

fs/xfs/linux-2.6/xfs_ioctl.c - 1.145 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_ioctl.c.diff?r1=text&tr1=1.145&r2=text&tr2=1.144&f=h
	- Fix XFS_IOC_FSBULKSTAT{,_SINGLE} and XFS_IOC_FSINUMBERS in compat mode

fs/xfs/linux-2.6/xfs_ioctl32.c - 1.18 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_ioctl32.c.diff?r1=text&tr1=1.18&r2=text&tr2=1.17&f=h
	- Fix XFS_IOC_FSBULKSTAT{,_SINGLE} and XFS_IOC_FSINUMBERS in compat mode
