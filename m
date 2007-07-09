Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 08 Jul 2007 23:01:20 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l6961CtL029631
	for <xfs@oss.sgi.com>; Sun, 8 Jul 2007 23:01:16 -0700
Subject: PARTIAL TAKE 967354 - new compat ioctl handlers
Message-Id: <20070709060110.1938C58C38F1@chook.melbourne.sgi.com>
Date: Mon,  9 Jul 2007 16:01:10 +1000 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Compat ioctl handler for handle operations

32bit struct xfs_fsop_handlereq has different size and offsets (due to
pointers). TODO: case XFS_IOC_{FSSETDM,ATTRLIST,ATTRMULTI}_BY_HANDLE
still not handled.

Signed-Off-By: Michal Marek <mmarek@suse.cz>

Date:  Mon Jul  9 16:00:29 AEST 2007
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  mmarek@suse.cz

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:29101a
fs/xfs/linux-2.6/xfs_ioctl32.c - 1.17 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_ioctl32.c.diff?r1=text&tr1=1.17&r2=text&tr2=1.16&f=h
	- Compat ioctl handlers for several by-handle ioctls.
