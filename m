Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 21 Feb 2008 20:43:21 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m1M4h88j012068
	for <xfs@oss.sgi.com>; Thu, 21 Feb 2008 20:43:15 -0800
Subject: TAKE 977547 - Update c/mtime correctly on truncates
Message-Id: <20080222044330.7C98958C4C0F@chook.melbourne.sgi.com>
Date: Fri, 22 Feb 2008 15:43:30 +1100 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Update c/mtime correctly on truncates

XFS changes the c/mtime of an inode when truncating it to the same
size. The c/mtime is only supposed to change if the size is changed.
Not to be confused with ftruncate, where the c/mtime is supposed to
be changed even if the size is not changed.

The Linux VFS encodes this semantic difference in the flags it sends
down to ->setattr, which XFS currently ignores. We need to make XFS
pay attention to the VFS flags and hence Do The Right Thing.



Date:  Fri Feb 22 15:42:58 AEDT 2008
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  hch@infradead.org

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:30536a
fs/xfs/xfs_vnodeops.c - 1.739 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_vnodeops.c.diff?r1=text&tr1=1.739&r2=text&tr2=1.738&f=h
	- Only change the c/mtime on truncate when the file size does
	  not change if asked to by the VFS.
