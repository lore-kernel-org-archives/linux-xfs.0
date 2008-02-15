Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 14 Feb 2008 22:53:19 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m1F6rBGk006737
	for <xfs@oss.sgi.com>; Thu, 14 Feb 2008 22:53:14 -0800
Subject: PARTIAL TAKE 970925 - Factor xfs_itobp() and xfs_inotobp()
Message-Id: <20080215065330.60A3058C4C11@chook.melbourne.sgi.com>
Date: Fri, 15 Feb 2008 17:53:30 +1100 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Factor xfs_itobp() and xfs_inotobp().

The only difference between the functions is one passes an
inode for the lookup, the other passes an inode number.
However, they don't do the same validity checking or set
all the same state on the buffer that is returned yet
they should.

Factor the functions into a common implementation.


Date:  Fri Feb 15 17:53:02 AEDT 2008
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  lachlan@sgi.com

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:30500a
fs/xfs/xfs_inode.c - 1.491 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_inode.c.diff?r1=text&tr1=1.491&r2=text&tr2=1.490&f=h
	- Factor xfs_itobp() and xfs_inotobp() to use a common
	  implementation.
