Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 24 Aug 2007 04:33:00 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l7OBWt4p008407
	for <xfs@oss.sgi.com>; Fri, 24 Aug 2007 04:32:57 -0700
Subject: PARTIAL TAKE 969608 - remove dependency of the quota module on behaviors
Message-Id: <20070824113251.E91F058C38F1@chook.melbourne.sgi.com>
Date: Fri, 24 Aug 2007 21:32:51 +1000 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

remove dependency of the quota module on behaviors

Mount options are now parsed by the main XFS module and rejected if quota
support is not available, and there are some new quota operation for the
quotactl syscall and calls to quote in the mount, unmount and sync
callchains.


Signed-off-by: Christoph Hellwig <hch@lst.de>


Date:  Fri Aug 24 21:32:27 AEST 2007
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  hch@lst.de

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:29503a
fs/xfs/xfs_vfsops.c - 1.532 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_vfsops.c.diff?r1=text&tr1=1.532&r2=text&tr2=1.531&f=h
	- remove dependency of the quota module on behaviors

fs/xfs/xfs_mount.h - 1.244 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_mount.h.diff?r1=text&tr1=1.244&r2=text&tr2=1.243&f=h
	- remove dependency of the quota module on behaviors

fs/xfs/xfs_qmops.c - 1.16 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_qmops.c.diff?r1=text&tr1=1.16&r2=text&tr2=1.15&f=h
	- remove dependency of the quota module on behaviors

fs/xfs/xfs_quota.h - 1.49 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_quota.h.diff?r1=text&tr1=1.49&r2=text&tr2=1.48&f=h
	- remove dependency of the quota module on behaviors

fs/xfs/quota/xfs_qm_bhv.c - 1.27 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/quota/xfs_qm_bhv.c.diff?r1=text&tr1=1.27&r2=text&tr2=1.26&f=h
	- remove dependency of the quota module on behaviors

fs/xfs/quota/xfs_qm_syscalls.c - 1.34 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/quota/xfs_qm_syscalls.c.diff?r1=text&tr1=1.34&r2=text&tr2=1.33&f=h
	- remove dependency of the quota module on behaviors

fs/xfs/quota/xfs_qm.h - 1.16 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/quota/xfs_qm.h.diff?r1=text&tr1=1.16&r2=text&tr2=1.15&f=h
	- remove dependency of the quota module on behaviors

fs/xfs/quota/xfs_qm.c - 1.53 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/quota/xfs_qm.c.diff?r1=text&tr1=1.53&r2=text&tr2=1.52&f=h
	- remove dependency of the quota module on behaviors

fs/xfs/linux-2.6/xfs_vfs.h - 1.75 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_vfs.h.diff?r1=text&tr1=1.75&r2=text&tr2=1.74&f=h
	- remove dependency of the quota module on behaviors

fs/xfs/linux-2.6/xfs_vfs.c - 1.79 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_vfs.c.diff?r1=text&tr1=1.79&r2=text&tr2=1.78&f=h
	- remove dependency of the quota module on behaviors

fs/xfs/linux-2.6/xfs_super.h - 1.71 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_super.h.diff?r1=text&tr1=1.71&r2=text&tr2=1.70&f=h
	- remove dependency of the quota module on behaviors

fs/xfs/linux-2.6/xfs_super.c - 1.390 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_super.c.diff?r1=text&tr1=1.390&r2=text&tr2=1.389&f=h
	- remove dependency of the quota module on behaviors

fs/xfs/linux-2.6/xfs_ksyms.c - 1.68 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_ksyms.c.diff?r1=text&tr1=1.68&r2=text&tr2=1.67&f=h
	- remove dependency of the quota module on behaviors
