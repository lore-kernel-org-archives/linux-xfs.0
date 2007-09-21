Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 20 Sep 2007 21:32:56 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l8L4Wngf027211
	for <xfs@oss.sgi.com>; Thu, 20 Sep 2007 21:32:51 -0700
From: donaldd@sgi.com
Subject: PARTIAL TAKE 970382 - untangle spinlock macros
Message-Id: <20070921043247.E7948307A008@linuxbuild.melbourne.sgi.com>
Date: Fri, 21 Sep 2007 14:32:47 +1000 (EST)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com, sgi.bugs.xfs@engr.sgi.com

Unwrap xfs_dabuf_global_lock

Un-obfuscate dabuf_global_lock, remove mutex_lock->spin_lock
macros, call spin_lock directly, remove extraneous cookie
holdover from old xfs code, and change lock type to spinlock_t.

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>

Date:  Fri Sep 21 14:32:21 AEST 2007
Workarea:  linuxbuild.melbourne.sgi.com:/home/donaldd/isms/2.6.x-xfs
Inspected by:  sandeen@sandeen.net

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:29744a
fs/xfs/xfs_da_btree.c - 1.176 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_da_btree.c.diff?r1=text&tr1=1.176&r2=text&tr2=1.175&f=h
	- Unwrap xfs_dabuf_global_lock

fs/xfs/xfs_vfsops.c - 1.541 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_vfsops.c.diff?r1=text&tr1=1.541&r2=text&tr2=1.540&f=h
	- Unwrap xfs_dabuf_global_lock
