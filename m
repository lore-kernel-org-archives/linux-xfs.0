Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 08 Apr 2008 20:58:40 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m393wLrQ009059
	for <xfs@oss.sgi.com>; Tue, 8 Apr 2008 20:58:24 -0700
Subject: PARTIAL TAKE 978729 - Reorganise xlog_t for better cacheline isolation of contention
Message-Id: <20080409035855.C6B3F58C4C0F@chook.melbourne.sgi.com>
Date: Wed,  9 Apr 2008 13:58:55 +1000 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Reorganise xlog_t for better cacheline isolation of contention

To reduce contention on the log in large CPU count, separate
out different parts of the xlog_t structure onto different cachelines.
Move each lock onto a different cacheline along with all the members
that are accessed/modified while that lock is held.

Also, move the debugging code into debug code.


Date:  Wed Apr  9 13:58:11 AEST 2008
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  lachlan@sgi.com

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:30772a
fs/xfs/xfs_log.c - 1.352 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_log.c.diff?r1=text&tr1=1.352&r2=text&tr2=1.351&f=h
	- Isolate some debugging to the debug build.

fs/xfs/xfs_log_priv.h - 1.130 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_log_priv.h.diff?r1=text&tr1=1.130&r2=text&tr2=1.129&f=h
	- Reorganise xlog_t for better cacheline isolation of contention
