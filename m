Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 30 Mar 2007 00:04:43 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l2U74b6p010395
	for <xfs@oss.sgi.com>; Fri, 30 Mar 2007 00:04:39 -0700
Subject: TAKE 962571 - xfs_dm_sync_by_handle is busted
Message-Id: <20070330064158.7663458FF807@chook.melbourne.sgi.com>
Date: Fri, 30 Mar 2007 16:41:58 +1000 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com, sgi.bugs.xfs@engr.sgi.com

xfs_dm_sync_by_handle does not sync file data.

xfs_dm_sync_by_handle() is supposed to behave like fsync.
When it returns the handle against which it was called is supposed
to be completely on stable storage. xfs_dm_sync_by_handle
syncs the inode but not the data. Make it sync hte data as well.

Date:  Fri Mar 30 16:41:20 AEST 2007
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  vapo

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:28329a
fs/xfs/dmapi/xfs_dm.c - 1.35 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/dmapi/xfs_dm.c.diff?r1=text&tr1=1.35&r2=text&tr2=1.34&f=h
	- sync data as well as the inode in xfs_dm_sync_by_handle().
