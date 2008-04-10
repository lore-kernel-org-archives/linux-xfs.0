Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 09 Apr 2008 18:11:10 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m3A1AkEm001551
	for <xfs@oss.sgi.com>; Wed, 9 Apr 2008 18:10:52 -0700
Subject: PARTIAL TAKE 980084 - Sanitise xfs_log_force error checking.
Message-Id: <20080410005942.C707C58C4C15@chook.melbourne.sgi.com>
Date: Thu, 10 Apr 2008 10:59:42 +1000 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Sanitise xfs_log_force error checking.

xfs_log_force() is declared to return an error, but we almost never
check it. We don't need to check it in most cases; if there's a log
I/O error then we'll be shutting down the filesystem anyway and that
means we'll catch the error somewhere else.

However, on certain calls we should be returning an error - sync
transactions, fsync, sync writes, etc. so this isn't a pure black
and white distinction. Hence make xfs_log_force() a void function
that issues a warning to the syslog on error, and call
_xfs_log_force() in all the places where we actually care about the
error status returned.

Date:  Thu Apr 10 10:59:08 AEST 2008
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  xaiki@sgi.com

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:30832a
fs/xfs/xfs_log.h - 1.81 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_log.h.diff?r1=text&tr1=1.81&r2=text&tr2=1.80&f=h
	- Sanitise xfs_log_force error checking.

fs/xfs/xfs_log.c - 1.355 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_log.c.diff?r1=text&tr1=1.355&r2=text&tr2=1.354&f=h
	- Sanitise xfs_log_force error checking.

fs/xfs/xfs_rw.c - 1.400 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_rw.c.diff?r1=text&tr1=1.400&r2=text&tr2=1.399&f=h
	- Sanitise xfs_log_force error checking.

fs/xfs/linux-2.6/xfs_ksyms.c - 1.82 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_ksyms.c.diff?r1=text&tr1=1.82&r2=text&tr2=1.81&f=h
	- Sanitise xfs_log_force error checking.
