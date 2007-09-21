Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 20 Sep 2007 21:53:46 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l8L4rbgf031277
	for <xfs@oss.sgi.com>; Thu, 20 Sep 2007 21:53:39 -0700
From: donaldd@sgi.com
Subject: PARTIAL TAKE 970382 - untangle spinlock macros
Message-Id: <20070921045335.2824C307A044@linuxbuild.melbourne.sgi.com>
Date: Fri, 21 Sep 2007 14:53:35 +1000 (EST)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com, sgi.bugs.xfs@engr.sgi.com

Cleanup lock goop.

Switch last couple lock_t's to spinlock_t's.
Remove now-unused spinlock-related macros & types.

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>


Date:  Fri Sep 21 14:53:11 AEST 2007
Workarea:  linuxbuild.melbourne.sgi.com:/home/donaldd/isms/2.6.x-xfs
Inspected by:  sandeen@sandeen.net

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:29748a
fs/xfs/xfs_mount.h - 1.254 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_mount.h.diff?r1=text&tr1=1.254&r2=text&tr2=1.253&f=h
	- Cleanup lock goop

fs/xfs/xfs_inode.h - 1.234 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_inode.h.diff?r1=text&tr1=1.234&r2=text&tr2=1.233&f=h
	- Cleanup lock goop

fs/xfs/linux-2.6/spin.h - 1.21 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/spin.h.diff?r1=text&tr1=1.21&r2=text&tr2=1.20&f=h
	- Cleanup lock goop
