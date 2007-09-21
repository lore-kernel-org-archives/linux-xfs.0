Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 20 Sep 2007 19:27:19 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l8L2RAgf004992
	for <xfs@oss.sgi.com>; Thu, 20 Sep 2007 19:27:14 -0700
From: donaldd@sgi.com
Subject: PARTIAL TAKE 970382 - untangle spinlock macros
Message-Id: <20070921022707.EB225305C989@linuxbuild.melbourne.sgi.com>
Date: Fri, 21 Sep 2007 12:27:07 +1000 (EST)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com, sgi.bugs.xfs@engr.sgi.com

Unwrap XFS_DQ_PINUNLOCK.

Un-obfuscate DQ_PINLOCK, remove DQ_PINLOCK->mutex_lock->spin_lock
macros, call spin_lock directly, remove extraneous cookie
holdover from old xfs code, and change lock type to spinlock_t.

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>

Date:  Fri Sep 21 12:26:20 AEST 2007
Workarea:  linuxbuild.melbourne.sgi.com:/home/donaldd/isms/2.6.x-xfs
Inspected by:  sandeen@sandeen.net

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:29742a
fs/xfs/quota/xfs_dquot_item.c - 1.19 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/quota/xfs_dquot_item.c.diff?r1=text&tr1=1.19&r2=text&tr2=1.18&f=h
	- Unwrap XFS_DQ_PINUNLOCK

fs/xfs/quota/xfs_dquot.h - 1.11 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/quota/xfs_dquot.h.diff?r1=text&tr1=1.11&r2=text&tr2=1.10&f=h
	- Unwrap XFS_DQ_PINUNLOCK

fs/xfs/quota/xfs_qm.h - 1.17 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/quota/xfs_qm.h.diff?r1=text&tr1=1.17&r2=text&tr2=1.16&f=h
	- Unwrap XFS_DQ_PINUNLOCK
