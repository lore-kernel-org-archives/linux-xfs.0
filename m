Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 27 Apr 2008 23:33:54 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m3S6XYbX010149
	for <xfs@oss.sgi.com>; Sun, 27 Apr 2008 23:33:36 -0700
Subject: TAKE 980888 - Fix check for block zero access in xfs_write_iomap_allocate
Message-Id: <20080428063413.5BEDD58C4C15@chook.melbourne.sgi.com>
Date: Mon, 28 Apr 2008 16:34:13 +1000 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Fix check for block zero access in xfs_write_iomap_allocate()

The check for block zero access should be done on non-realtime
inodes. Fix the logic error in xfs_write_iomap_allocate(), and
simplify the logic on all checks for block zero access in
xfs_iomap.c

Date:  Mon Apr 28 16:33:53 AEST 2008
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  lachlan@sgi.com

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:30998a
fs/xfs/xfs_iomap.c - 1.64 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_iomap.c.diff?r1=text&tr1=1.64&r2=text&tr2=1.63&f=h
	- Fix check for block zero access in xfs_write_iomap_allocate().
