Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 21 Feb 2008 21:10:03 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m1M59tgs014837
	for <xfs@oss.sgi.com>; Thu, 21 Feb 2008 21:09:59 -0800
Subject: PARTIAL TAKE 977546 - Use atomic counters for ktrace buffer indexes
Message-Id: <20080222051015.857B158C4C0F@chook.melbourne.sgi.com>
Date: Fri, 22 Feb 2008 16:10:15 +1100 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Use atomic counters for ktrace buffer indexes

ktrace_enter() is consuming vast amounts of CPU time
due to the use of a single global lock for protecting
buffer index increments. Change it to use per-buffer
atomic counters - this reduces ktrace_enter() overhead
during a trace intensive test on a 4p machine from 58%
of all CPU time to 12% and halves test runtime.

Date:  Fri Feb 22 16:09:47 AEDT 2008
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  lachlan@sgi.com,hch@infradead.org

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:30537a
fs/xfs/support/ktrace.c - 1.29 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/support/ktrace.c.diff?r1=text&tr1=1.29&r2=text&tr2=1.28&f=h
	- Use per-ktrace buffer atomic index counters and remove
	  the global ktrace index lock that is causing performance
	  problems on ktrace kernels.

fs/xfs/support/ktrace.h - 1.16 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/support/ktrace.h.diff?r1=text&tr1=1.16&r2=text&tr2=1.15&f=h
	- Use per-ktrace buffer atomic index counters and remove
	  the global ktrace index lock that is causing performance
	  problems on ktrace kernels.
