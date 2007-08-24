Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 24 Aug 2007 05:14:01 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l7OCDt4p016875
	for <xfs@oss.sgi.com>; Fri, 24 Aug 2007 05:13:57 -0700
Subject: PARTIAL TAKE 969608 - move syncing related members from struct bhv_vfs to struct xfs_mount
Message-Id: <20070824121350.6E88A58C38F1@chook.melbourne.sgi.com>
Date: Fri, 24 Aug 2007 22:13:50 +1000 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

move syncing related members from struct bhv_vfs to struct xfs_mount

Signed-off-by: Christoph Hellwig <hch@lst.de>


Date:  Fri Aug 24 22:13:23 AEST 2007
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  hch@lst.de

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:29508a
fs/xfs/xfs_mount.h - 1.248 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_mount.h.diff?r1=text&tr1=1.248&r2=text&tr2=1.247&f=h
	- move sync-related members of bhv_vfs to xfs_mount.

fs/xfs/linux-2.6/xfs_vfs.h - 1.79 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_vfs.h.diff?r1=text&tr1=1.79&r2=text&tr2=1.78&f=h
	- move sync-related members of bhv_vfs to xfs_mount.

fs/xfs/linux-2.6/xfs_vfs.c - 1.82 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_vfs.c.diff?r1=text&tr1=1.82&r2=text&tr2=1.81&f=h
	- move sync-related members of bhv_vfs to xfs_mount.

fs/xfs/linux-2.6/xfs_super.c - 1.394 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_super.c.diff?r1=text&tr1=1.394&r2=text&tr2=1.393&f=h
	- move sync-related members of bhv_vfs to xfs_mount.
