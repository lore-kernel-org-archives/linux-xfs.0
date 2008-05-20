Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 19 May 2008 18:44:15 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m4K1i83A001184
	for <xfs@oss.sgi.com>; Mon, 19 May 2008 18:44:09 -0700
Subject: PARTIAL TAKE 981951 - kill xfs_mount_init
Message-Id: <20080520014452.EF4A758C4C29@chook.melbourne.sgi.com>
Date: Tue, 20 May 2008 11:44:52 +1000 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

kill xfs_mount_init

xfs_mount_init is inlined into xfs_fs_fill_super and allocation switched
to kzalloc.  Plug a leak of the mount structure for most early mount
failures.  Move xfs_icsb_init_counters to as late as possible in the
mount path and make sure to undo it so that no stale hotplug cpu
notifiers are left around on mount failures.


Signed-off-by: Christoph Hellwig <hch@lst.de>


Date:  Tue May 20 11:44:36 AEST 2008
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  hch@lst.de

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:31196a
fs/xfs/xfs_mount.h - 1.268 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_mount.h.diff?r1=text&tr1=1.268&r2=text&tr2=1.267&f=h
	- kill xfs_mount_init.

fs/xfs/xfs_mount.c - 1.436 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_mount.c.diff?r1=text&tr1=1.436&r2=text&tr2=1.435&f=h
	- kill xfs_mount_init.

fs/xfs/linux-2.6/xfs_super.c - 1.424 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_super.c.diff?r1=text&tr1=1.424&r2=text&tr2=1.423&f=h
	- kill xfs_mount_init.

fs/xfs/linux-2.6/xfs_ksyms.c - 1.85 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_ksyms.c.diff?r1=text&tr1=1.85&r2=text&tr2=1.84&f=h
	- kill xfs_mount_init.
