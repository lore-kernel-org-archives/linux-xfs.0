Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 24 Aug 2007 04:28:50 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l7OBSj4p007483
	for <xfs@oss.sgi.com>; Fri, 24 Aug 2007 04:28:47 -0700
Subject: PARTIAL TAKE 969608 - remove dependency of the dmapi module on behaviors
Message-Id: <20070824112841.6E0F058C38F1@chook.melbourne.sgi.com>
Date: Fri, 24 Aug 2007 21:28:41 +1000 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

remove dependency of the dmapi module on behaviors

Mount options are now parsed by the main XFS module and rejected if dmapi
support is not available, and there is a new dm operation to send the
mount event.


Signed-off-by: Christoph Hellwig <hch@lst.de>


Date:  Fri Aug 24 21:28:04 AEST 2007
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  hch@lst.de

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:29502a
fs/xfs/xfs_dmapi.h - 1.61 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_dmapi.h.diff?r1=text&tr1=1.61&r2=text&tr2=1.60&f=h
	- remove dependency of the dmapi module on behaviors

fs/xfs/xfs_vfsops.c - 1.531 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_vfsops.c.diff?r1=text&tr1=1.531&r2=text&tr2=1.530&f=h
	- remove dependency of the dmapi module on behaviors

fs/xfs/xfs_mount.h - 1.243 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_mount.h.diff?r1=text&tr1=1.243&r2=text&tr2=1.242&f=h
	- remove dependency of the dmapi module on behaviors

fs/xfs/xfs_dmops.c - 1.13 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_dmops.c.diff?r1=text&tr1=1.13&r2=text&tr2=1.12&f=h
	- remove dependency of the dmapi module on behaviors

fs/xfs/linux-2.6/xfs_vfs.h - 1.74 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_vfs.h.diff?r1=text&tr1=1.74&r2=text&tr2=1.73&f=h
	- remove dependency of the dmapi module on behaviors

fs/xfs/linux-2.6/xfs_vfs.c - 1.78 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_vfs.c.diff?r1=text&tr1=1.78&r2=text&tr2=1.77&f=h
	- remove dependency of the dmapi module on behaviors

fs/xfs/linux-2.6/xfs_ksyms.c - 1.67 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_ksyms.c.diff?r1=text&tr1=1.67&r2=text&tr2=1.66&f=h
	- remove dependency of the dmapi module on behaviors

fs/xfs/dmapi/Makefile-linux-2.6 - 1.6 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/dmapi/Makefile-linux-2.6.diff?r1=text&tr1=1.6&r2=text&tr2=1.5&f=h
	- remove dependency of the dmapi module on behaviors

fs/xfs/dmapi/xfs_dm_fsops.c - 1.10 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/dmapi/xfs_dm_fsops.c.diff?r1=text&tr1=1.10&r2=text&tr2=1.9&f=h
	- remove dependency of the dmapi module on behaviors

fs/xfs/dmapi/xfs_dm_bhv.c - 1.9 - deleted
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/dmapi/xfs_dm_bhv.c.diff?r1=text&tr1=1.9&r2=text&tr2=1.8&f=h
	- remove dependency of the dmapi module on behaviors

fs/xfs/dmapi/xfs_dm.h - 1.2 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/dmapi/xfs_dm.h.diff?r1=text&tr1=1.2&r2=text&tr2=1.1&f=h
	- remove dependency of the dmapi module on behaviors

fs/xfs/dmapi/xfs_dm.c - 1.49 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/dmapi/xfs_dm.c.diff?r1=text&tr1=1.49&r2=text&tr2=1.48&f=h
	- remove dependency of the dmapi module on behaviors
