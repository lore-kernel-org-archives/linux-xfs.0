Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 09 Apr 2008 00:10:11 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m3979tAb010199
	for <xfs@oss.sgi.com>; Wed, 9 Apr 2008 00:09:57 -0700
Subject: PARTIAL TAKE 980084 - Propagate xfs_trans_reserve() errors
Message-Id: <20080409071030.4BBFE58C4C0F@chook.melbourne.sgi.com>
Date: Wed,  9 Apr 2008 17:10:30 +1000 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Propagate xfs_trans_reserve() errors.

xfs_trans_reserve() reports errors that should not be ignored.
For example, a shutdown filesystem will report errors through
xfs_trans_reserve() to prevent further changes from being attempted
on a damaged filesystem. Catch and propagate all error conditions
from xfs_trans_reserve().

Date:  Wed Apr  9 17:10:06 AEST 2008
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  xaiki@sgi.com

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:30794a
fs/xfs/xfs_log_recover.c - 1.338 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_log_recover.c.diff?r1=text&tr1=1.338&r2=text&tr2=1.337&f=h
	- Catch xfs_trans_reserve() errors.
