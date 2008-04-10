Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 09 Apr 2008 22:13:06 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m3A5CtaC004309
	for <xfs@oss.sgi.com>; Wed, 9 Apr 2008 22:12:58 -0700
Subject: TAKE 980145 - Remove periodic logging of in-core superblock counters.
Message-Id: <20080410051330.01A5C58C4C15@chook.melbourne.sgi.com>
Date: Thu, 10 Apr 2008 15:13:29 +1000 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Remove periodic logging of in-core superblock counters.

xfssyncd triggers the logging of superblock counters every
30s if the filesystem is made with lazy-count=1. This will
prevent disks from idling and spinning down as there will
be a log write every 30s. With the way counter recovery
works for lazy-count=1, this code is unnecessary and provides
no real benefit, so just remove it.

Date:  Thu Apr 10 15:13:10 AEST 2008
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  bnaujok@sgi.com

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:30840a
fs/xfs/xfs_vfsops.c - 1.561 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_vfsops.c.diff?r1=text&tr1=1.561&r2=text&tr2=1.560&f=h
	- Remove periodic logging of in-core superblock counters.

fs/xfs/linux-2.6/xfs_vfs.h - 1.81 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_vfs.h.diff?r1=text&tr1=1.81&r2=text&tr2=1.80&f=h
	- Remove periodic logging of in-core superblock counters.

fs/xfs/linux-2.6/xfs_super.c - 1.413 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_super.c.diff?r1=text&tr1=1.413&r2=text&tr2=1.412&f=h
	- Remove periodic logging of in-core superblock counters.
