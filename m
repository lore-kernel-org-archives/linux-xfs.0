Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 08 Apr 2008 21:03:11 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m3942lHP010170
	for <xfs@oss.sgi.com>; Tue, 8 Apr 2008 21:02:49 -0700
Subject: TAKE 979661 - Fix lock inversion in forced shutdown.
Message-Id: <20080409040321.64CDF58C4C0F@chook.melbourne.sgi.com>
Date: Wed,  9 Apr 2008 14:03:21 +1000 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Fix lock inversion in forced shutdown.

Recent changes to xlog_state_release_iclog() placed the grant_lock
inside the icloglock. forced unmount of the log does this the opposite
way around, but does not depend on the order for correct working.
Fix the inversion by changing the order locks are gained in
xfs_log_force_umount().


Date:  Wed Apr  9 14:02:59 AEST 2008
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  hch@infradead.org

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:30773a
fs/xfs/xfs_log.c - 1.353 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_log.c.diff?r1=text&tr1=1.353&r2=text&tr2=1.352&f=h
	- Fix lock inversion in forced shutdown.
