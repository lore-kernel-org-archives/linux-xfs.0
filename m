Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 08 Apr 2008 23:59:10 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m396wx6d005086
	for <xfs@oss.sgi.com>; Tue, 8 Apr 2008 23:59:01 -0700
Subject: PARTIAL TAKE 980084 - Catch errors when turning off quotas.
Message-Id: <20080409065933.6189A58C4C0F@chook.melbourne.sgi.com>
Date: Wed,  9 Apr 2008 16:59:33 +1000 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Catch errors when turning off quotas.

When turning off quota, we need to write various transactions
to the log to ensure that they are cleanly removed in the case
of a crash. We need to check that the transactions hit the disk
correctly. If we fail to write the final quota off transaction,
we are corrupt in memory and so the only option is to shut the
filesystem down at this point.


Date:  Wed Apr  9 16:59:11 AEST 2008
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  xaiki@sgi.com

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:30790a
fs/xfs/quota/xfs_qm_syscalls.c - 1.39 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/quota/xfs_qm_syscalls.c.diff?r1=text&tr1=1.39&r2=text&tr2=1.38&f=h
	- Catch errors when turning off quotas.
