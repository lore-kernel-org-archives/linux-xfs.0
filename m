Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 20 Sep 2007 19:00:19 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l8L20Agf032713
	for <xfs@oss.sgi.com>; Thu, 20 Sep 2007 19:00:14 -0700
From: donaldd@sgi.com
Subject: PARTIAL TAKE 970382 - untangle spinlock macros 
Message-Id: <20070921020008.78CF53079F83@linuxbuild.melbourne.sgi.com>
Date: Fri, 21 Sep 2007 12:00:08 +1000 (EST)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com, sgi.bugs.xfs@engr.sgi.com

Unwrap GRANT_LOCK.

Un-obfuscate GRANT_LOCK, remove GRANT_LOCK->mutex_lock->spin_lock
macros, call spin_lock directly, remove extraneous cookie
holdover from old xfs code, and change lock type to spinlock_t.

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>

Date:  Fri Sep 21 11:59:22 AEST 2007
Workarea:  linuxbuild.melbourne.sgi.com:/home/donaldd/isms/2.6.x-xfs
Inspected by:  sandeen@sandeen.net

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:29741a
fs/xfs/xfs_log.c - 1.338 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_log.c.diff?r1=text&tr1=1.338&r2=text&tr2=1.337&f=h
	- Unwrap GRANT_LOCK.

fs/xfs/xfs_log_priv.h - 1.122 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_log_priv.h.diff?r1=text&tr1=1.122&r2=text&tr2=1.121&f=h
	- Unwrap GRANT_LOCK.

fs/xfs/xfs_vnodeops.c - 1.722 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_vnodeops.c.diff?r1=text&tr1=1.722&r2=text&tr2=1.721&f=h
	- Unwrap GRANT_LOCK.
