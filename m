Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 18 Sep 2008 00:35:02 -0700 (PDT)
Received: from relay.sgi.com (relay1.corp.sgi.com [192.26.58.214])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8I7Yu2Z024535
	for <xfs@oss.sgi.com>; Thu, 18 Sep 2008 00:34:58 -0700
Subject: TAKE 987086 - Fix use-after-free with log and quotas
Message-Id: <20080918073621.39D9758C52AE@chook.melbourne.sgi.com>
Date: Thu, 18 Sep 2008 17:36:21 +1000 (EST)
From: lachlan@sgi.com (Lachlan McIlroy)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

Fix use-after-free with log and quotas

Destroying the quota stuff on unmount can access the log - ie XFS_QM_DONE()
ends up in xfs_dqunlock() which calls xfs_trans_unlocked_item() and then
xfs_log_move_tail().  By this time the log has already been destroyed.
Just move the cleanup of the quota code earlier in xfs_unmountfs() before
the call to xfs_log_unmount().  Moving XFS_QM_DONE() up near
XFS_QM_DQPURGEALL() seems like a good spot. 

Date:  Thu Sep 18 17:35:23 AEST 2008
Workarea:  redback.melbourne.sgi.com:/home/lachlan/isms/2.6.x-tot
Inspected by:  
hch
lachlan
pleckie
Author:  lachlan

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:32148a
fs/xfs/xfs_mount.c - 1.446 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_mount.c.diff?r1=text&tr1=1.446&r2=text&tr2=1.445&f=h
	- Fix use-after-free with log and quotas
