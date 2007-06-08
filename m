Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 08 Jun 2007 02:39:31 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l589dPWt030741
	for <xfs@oss.sgi.com>; Fri, 8 Jun 2007 02:39:26 -0700
Subject: TAKE 964464 - remount r/o path has same flush problems as freeze path
Message-Id: <20070608093920.CA13C58C38C1@chook.melbourne.sgi.com>
Date: Fri,  8 Jun 2007 19:39:20 +1000 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Fix remount,readonly path to flush everything correctly.

The remount readonly path can fail to writeback properly because we
still have active transactions after calling xfs_quiesce_fs().
Further investigation shows that this path is broken in the same
ways that the xfs freeze path was broken so fix it the same
way.

Date:  Fri Jun  8 19:38:52 AEST 2007
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  hch@infradead.org

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:28869a
fs/xfs/xfs_vfsops.c - 1.521 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_vfsops.c.diff?r1=text&tr1=1.521&r2=text&tr2=1.520&f=h
	- Modify remount,ro path to use data and inode quiesce
	  code. Factor common inode quiesce code.

fs/xfs/linux-2.6/xfs_vfs.h - 1.71 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_vfs.h.diff?r1=text&tr1=1.71&r2=text&tr2=1.70&f=h
	- Define data and inode quiesce flush flags and document
	  what they do.

fs/xfs/linux-2.6/xfs_super.c - 1.383 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_super.c.diff?r1=text&tr1=1.383&r2=text&tr2=1.382&f=h
	- Clean up data quiesce flags.
