Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 21 Dec 2006 15:32:25 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id kBLNWIqw025994
	for <xfs@oss.sgi.com>; Thu, 21 Dec 2006 15:32:20 -0800
Subject: TAKE 959388 - use-after-free of inode log item when shutting down a filesystem
Message-Id: <20061221233123.E16F658CA546@chook.melbourne.sgi.com>
Date: Fri, 22 Dec 2006 10:31:23 +1100 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com, sgi.bugs.xfs@engr.sgi.com

Fix inode log item use-after-free on forced shutdown


Date:  Fri Dec 22 10:30:43 AEDT 2006
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  lachlan

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:27805a
fs/xfs/xfs_inode.c - 1.457 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_inode.c.diff?r1=text&tr1=1.457&r2=text&tr2=1.456&f=h
	- Remove the inode log item from the AIL list before freeing it
	  on shutdown to prevent it from being used after it has been freed.
