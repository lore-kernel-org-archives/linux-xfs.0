Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 05 Aug 2008 22:37:01 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m765aubW011896
	for <xfs@oss.sgi.com>; Tue, 5 Aug 2008 22:36:57 -0700
Subject: TAKE 981498 - refactor xfs_mount_free
Message-Id: <20080806053808.6790658C52A4@chook.melbourne.sgi.com>
Date: Wed,  6 Aug 2008 15:38:08 +1000 (EST)
From: lachlan@sgi.com (Lachlan McIlroy)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

refactor xfs_mount_free

xfs_mount_free mostly frees the perag data, which is something that
is duplicated in the mount error path.

Move the XFS_QM_DONE call to the caller and remove the useless
mutex_destroy/spinlock_destroy calls so that we can re-use it for
the mount error path.  Also rename it to xfs_free_perag to reflect what
it does.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Date:  Wed Aug  6 15:37:28 AEST 2008
Workarea:  redback.melbourne.sgi.com:/home/lachlan/isms/2.6.x-mm
Inspected by:  
hch
lachlan
Author:  lachlan

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:31836a
fs/xfs/xfs_mount.c - 1.444 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_mount.c.diff?r1=text&tr1=1.444&r2=text&tr2=1.443&f=h
	- refactor xfs_mount_free
