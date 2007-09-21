Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 20 Sep 2007 18:49:25 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l8L1nFgf029707
	for <xfs@oss.sgi.com>; Thu, 20 Sep 2007 18:49:21 -0700
From: donaldd@sgi.com
Subject: PARTIAL TAKE 970382 - untangle spinlock macros
Message-Id: <20070921014913.BAC703079F69@linuxbuild.melbourne.sgi.com>
Date: Fri, 21 Sep 2007 11:49:13 +1000 (EST)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com, sgi.bugs.xfs@engr.sgi.com

Unwrap AIL_LOCK

Un-obfuscate AIL_LOCK, remove AIL_LOCK->mutex_lock->spin_lock
macros, call spin_lock directly, remove extraneous cookie
holdover from old xfs code, and change lock type to spinlock_t.

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>

Date:  Fri Sep 21 11:45:49 AEST 2007
Workarea:  linuxbuild.melbourne.sgi.com:/home/donaldd/isms/2.6.x-xfs
Inspected by:  sandeen@sandeen.net

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:29739a
fs/xfs/xfs_extfree_item.c - 1.68 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_extfree_item.c.diff?r1=text&tr1=1.68&r2=text&tr2=1.67&f=h
fs/xfs/xfs_buf_item.c - 1.164 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_buf_item.c.diff?r1=text&tr1=1.164&r2=text&tr2=1.163&f=h
fs/xfs/xfs_trans_priv.h - 1.29 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_trans_priv.h.diff?r1=text&tr1=1.29&r2=text&tr2=1.28&f=h
fs/xfs/xfs_trans_ail.c - 1.82 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_trans_ail.c.diff?r1=text&tr1=1.82&r2=text&tr2=1.81&f=h
fs/xfs/xfs_inode_item.c - 1.131 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_inode_item.c.diff?r1=text&tr1=1.131&r2=text&tr2=1.130&f=h
fs/xfs/xfs_log_recover.c - 1.325 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_log_recover.c.diff?r1=text&tr1=1.325&r2=text&tr2=1.324&f=h
fs/xfs/xfs_mount.h - 1.252 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_mount.h.diff?r1=text&tr1=1.252&r2=text&tr2=1.251&f=h
fs/xfs/xfs_mount.c - 1.412 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_mount.c.diff?r1=text&tr1=1.412&r2=text&tr2=1.411&f=h
fs/xfs/xfs_inode.c - 1.481 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_inode.c.diff?r1=text&tr1=1.481&r2=text&tr2=1.480&f=h
fs/xfs/xfs_trans.c - 1.184 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_trans.c.diff?r1=text&tr1=1.184&r2=text&tr2=1.183&f=h
fs/xfs/quota/xfs_dquot_item.c - 1.18 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/quota/xfs_dquot_item.c.diff?r1=text&tr1=1.18&r2=text&tr2=1.17&f=h
fs/xfs/quota/xfs_dquot.c - 1.30 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/quota/xfs_dquot.c.diff?r1=text&tr1=1.30&r2=text&tr2=1.29&f=h
