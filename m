Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 05 Feb 2008 15:41:54 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m15NflvM001610
	for <xfs@oss.sgi.com>; Tue, 5 Feb 2008 15:41:49 -0800
Subject: TAKE 976923 - Fix oops in xfs_file_readdir()
Message-Id: <20080205234205.1B5C558C4C11@chook.melbourne.sgi.com>
Date: Wed,  6 Feb 2008 10:42:05 +1100 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Fix oops in xfs_file_readdir()

When xfs_file_readdir() exactly fills a buffer, it can move it's index past
the end of the buffer and dereference it even though the result of the
dereference is never used. On some platforms this causes an oops.


Date:  Wed Feb  6 10:41:34 AEDT 2008
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  lachlan@sgi.com

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:30458a
fs/xfs/linux-2.6/xfs_file.c - 1.163 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_file.c.diff?r1=text&tr1=1.163&r2=text&tr2=1.162&f=h
	- Only update the current offset in xfs_file_readdir() when it is safe to do so.
