Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 24 Jul 2008 22:25:11 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m6P5P5mb017439
	for <xfs@oss.sgi.com>; Thu, 24 Jul 2008 22:25:06 -0700
Subject: REOPEN 981498 - Revert remove mounpoint UUID code 
Message-Id: <20080725052614.B173B58C4C3F@chook.melbourne.sgi.com>
Date: Fri, 25 Jul 2008 15:26:14 +1000 (EST)
From: xaiki@sgi.com (Niv Sardi-Altivanik)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

Revert remove mounpoint UUID code

As spotted by dchinner and hch, this touches on-disk format and log format, should be more carefully reviewed.


Date:  Fri Jul 25 15:25:25 AEST 2008
Workarea:  itchy.melbourne.sgi.com:/i386/home/xaiki/Wrk/ptools/xfs-2.6
Inspected by:  hch,xaiki
Undoes mod:  xfs-linux-melb:xfs-kern:31766a

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:31773a
fs/xfs/xfsidbg.c - 1.357 - changed
fs/xfs/xfs_itable.c - 1.168 - changed
fs/xfs/xfs_inode_item.c - 1.138 - changed
fs/xfs/xfs_inode_item.h - 1.52 - changed
fs/xfs/xfs_log_recover.c - 1.346 - changed
fs/xfs/xfs_inode.c - 1.511 - changed
fs/xfs/xfs_inode.h - 1.253 - changed
fs/xfs/xfs_attr_leaf.c - 1.116 - changed
fs/xfs/xfs_bmap.c - 1.400 - changed
fs/xfs/xfs_dinode.h - 1.86 - changed
fs/xfs/dmapi/xfs_dm.c - 1.78 - changed
