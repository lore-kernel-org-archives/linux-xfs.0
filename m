Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 08 Apr 2008 20:47:36 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m393lLOj006986
	for <xfs@oss.sgi.com>; Tue, 8 Apr 2008 20:47:23 -0700
Subject: PARTIAL TAKE 978729 - Per iclog callback chain lock
Message-Id: <20080409034752.05BAC58C4C0F@chook.melbourne.sgi.com>
Date: Wed,  9 Apr 2008 13:47:51 +1000 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Per iclog callback chain lock

Rather than use the icloglock for protecting the iclog completion
callback chain, use a new per-iclog lock so that walking the
callback chain doesn't require holding a global lock.

This reduces contention on the icloglock during transaction commit
and log I/O completion by reducing the number of times we need to
hold the global icloglock during these operations.


Date:  Wed Apr  9 13:47:24 AEST 2008
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  lachlan@sgi.com,hch@infradead.org

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:30770a
fs/xfs/xfs_log.c - 1.350 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_log.c.diff?r1=text&tr1=1.350&r2=text&tr2=1.349&f=h
	- Use a per-iclog callback chain log to reduce contention on the
	  icloglock.

fs/xfs/xfs_log_priv.h - 1.128 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_log_priv.h.diff?r1=text&tr1=1.128&r2=text&tr2=1.127&f=h
	- Use a per-iclog callback chain log to reduce contention on the
	  icloglock.
