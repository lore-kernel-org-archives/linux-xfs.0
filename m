Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 09 Jan 2007 21:44:23 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l0A5iFqw006143
	for <xfs@oss.sgi.com>; Tue, 9 Jan 2007 21:44:16 -0800
Subject: TAKE 956323 - File system block reservation mechanism is broken
Message-Id: <20070110054314.A64F058CF82A@chook.melbourne.sgi.com>
Date: Wed, 10 Jan 2007 16:43:14 +1100 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com, sgi.bugs.xfs@engr.sgi.com
Cc: sdoyon@max-t.com

Fix block reservation mechanism.

The block reservation mechanism has been broken since the per-cpu
superblock counters were introduced. Make the block reservation code
work with the per-cpu counters by syncing the counters, snapshotting
the amount of available space and then doing a modifcation of the
counter state according to the result. Continue in a loop until we
either have no space available or we reserve some space.


Date:  Wed Jan 10 16:42:29 AEDT 2007
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  hch@infradead.org

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:27895a
fs/xfs/xfs_vfsops.c - 1.513 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_vfsops.c.diff?r1=text&tr1=1.513&r2=text&tr2=1.512&f=h
	- Use the flags superblock counter sync function variant.

fs/xfs/xfs_mount.h - 1.232 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_mount.h.diff?r1=text&tr1=1.232&r2=text&tr2=1.231&f=h
	- Change the per-cpu counter sync interface to export a flags variant
	  rather than specific, similar functions.

fs/xfs/xfs_mount.c - 1.391 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_mount.c.diff?r1=text&tr1=1.391&r2=text&tr2=1.390&f=h
	- Change the per-cpu counter sync interface to export a flags variant
	  rather than specific, similar functions.

fs/xfs/xfs_fsops.c - 1.120 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_fsops.c.diff?r1=text&tr1=1.120&r2=text&tr2=1.119&f=h
	- Fix the block reservation mechanism to work with per-cpu superblock
	  counters.
