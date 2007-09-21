Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 20 Sep 2007 21:45:45 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l8L4jagf029481
	for <xfs@oss.sgi.com>; Thu, 20 Sep 2007 21:45:40 -0700
From: donaldd@sgi.com
Subject: PARTIAL TAKE 970382 - untangle spinlock macros
Message-Id: <20070921044534.DA755307A01A@linuxbuild.melbourne.sgi.com>
Date: Fri, 21 Sep 2007 14:45:34 +1000 (EST)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com, sgi.bugs.xfs@engr.sgi.com

Unwrap XFS_SB_LOCK.

Un-obfuscate XFS_SB_LOCK, remove XFS_SB_LOCK->mutex_lock->spin_lock
macros, call spin_lock directly, remove extraneous cookie
holdover from old xfs code, and change lock type to spinlock_t.

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>


Date:  Fri Sep 21 14:44:47 AEST 2007
Workarea:  linuxbuild.melbourne.sgi.com:/home/donaldd/isms/2.6.x-xfs
Inspected by:  sandeen@sandeen.net

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:29746a
fs/xfs/xfs_vfsops.c - 1.542 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_vfsops.c.diff?r1=text&tr1=1.542&r2=text&tr2=1.541&f=h
	- Unwrap XFS_SB_LOCK

fs/xfs/xfs_mount.h - 1.253 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_mount.h.diff?r1=text&tr1=1.253&r2=text&tr2=1.252&f=h
	- Unwrap XFS_SB_LOCK

fs/xfs/xfs_mount.c - 1.413 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_mount.c.diff?r1=text&tr1=1.413&r2=text&tr2=1.412&f=h
	- Unwrap XFS_SB_LOCK

fs/xfs/xfs_qmops.c - 1.18 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_qmops.c.diff?r1=text&tr1=1.18&r2=text&tr2=1.17&f=h
	- Unwrap XFS_SB_LOCK

fs/xfs/xfs_attr_leaf.c - 1.108 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_attr_leaf.c.diff?r1=text&tr1=1.108&r2=text&tr2=1.107&f=h
	- Unwrap XFS_SB_LOCK

fs/xfs/xfs_utils.c - 1.78 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_utils.c.diff?r1=text&tr1=1.78&r2=text&tr2=1.77&f=h
	- Unwrap XFS_SB_LOCK

fs/xfs/xfs_fsops.c - 1.131 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_fsops.c.diff?r1=text&tr1=1.131&r2=text&tr2=1.130&f=h
	- Unwrap XFS_SB_LOCK

fs/xfs/xfs_bmap.c - 1.379 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_bmap.c.diff?r1=text&tr1=1.379&r2=text&tr2=1.378&f=h
	- Unwrap XFS_SB_LOCK

fs/xfs/quota/xfs_qm_syscalls.c - 1.36 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/quota/xfs_qm_syscalls.c.diff?r1=text&tr1=1.36&r2=text&tr2=1.35&f=h
	- Unwrap XFS_SB_LOCK

fs/xfs/quota/xfs_qm.c - 1.56 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/quota/xfs_qm.c.diff?r1=text&tr1=1.56&r2=text&tr2=1.55&f=h
	- Unwrap XFS_SB_LOCK
