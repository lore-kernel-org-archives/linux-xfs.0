Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 09 Apr 2008 00:01:11 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m3970l0G007804
	for <xfs@oss.sgi.com>; Wed, 9 Apr 2008 00:00:52 -0700
Subject: PARTIAL TAKE 980084 - Propagate quota file truncation errors.
Message-Id: <20080409070121.D983158C4C0F@chook.melbourne.sgi.com>
Date: Wed,  9 Apr 2008 17:01:21 +1000 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Propagate quota file truncation errors.

Truncating the quota files can silently fail. Ensure that
truncation errors are propagated to the callers.


Date:  Wed Apr  9 17:01:01 AEST 2008
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  xaiki@sgi.com

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:30791a
fs/xfs/quota/xfs_qm_syscalls.c - 1.40 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/quota/xfs_qm_syscalls.c.diff?r1=text&tr1=1.40&r2=text&tr2=1.39&f=h
	- Propagate quota file truncation errors.
