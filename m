Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 14 Feb 2008 23:50:23 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m1F7oDOG019413
	for <xfs@oss.sgi.com>; Thu, 14 Feb 2008 23:50:15 -0800
Subject: PARTIAL TAKE 975671 - Prevent AIL lock contention during transaction completion
Message-Id: <20080215075034.30F6058C4C11@chook.melbourne.sgi.com>
Date: Fri, 15 Feb 2008 18:50:34 +1100 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Prevent AIL lock contention during transaction completion

When hundreds of processors attempt to commit transactions at the
same time, they can contend on the AIL lock when updating the tail
LSN held in the in-core log structure.

At the moment, the tail LSN is only needed when actually writing
out an iclog, so it really does not need to be updated on every
single transaction completion - only those that result in switching
iclogs and flushing them to disk.

The result is that we reduce the number of times we need to grab the
AIL lock and the log grant lock by up to two orders of magnitude
on large processor count machines. The problem has previously been
hidden by AIL lock contention walking the AIL list which was
recently solved and uncovered this issue.

Date:  Fri Feb 15 18:49:54 AEDT 2008
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  tes@sgi.com

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:30504a
fs/xfs/xfs_log.c - 1.347 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_log.c.diff?r1=text&tr1=1.347&r2=text&tr2=1.346&f=h
	- Only update the tail lsn when we need to write it to disk
	  rather than every time we release an iclog to reduce lock
	  contention on the AIL lock.
