Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 09 Sep 2007 23:26:50 -0700 (PDT)
Received: from redback.melbourne.sgi.com (redback.melbourne.sgi.com [134.14.55.78])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l8A6Qf4p007077
	for <xfs@oss.sgi.com>; Sun, 9 Sep 2007 23:26:45 -0700
Date: Mon, 10 Sep 2007 15:52:30 +1000
From: Lachlan McIlroy <lachlan@redback.melbourne.sgi.com>
Message-Id: <200709100552.l8A5qUQu014115@redback.melbourne.sgi.com>
Subject: TAKE 970242 - remove dead SYNC_BDFLUSH case in xfs_sync_inodes
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-dev@sgi.com, xfs@oss.sgi.com

remove dead SYNC_BDFLUSH case in xfs_sync_inodes

A large part of xfs_sync_inodes is conditional on the SYNC_BDFLUSH which
is never passed to it.  This patch removes it and adds an assert that
triggers in case some new code tries to pass SYNC_BDFLUSH to it.


Date:  Mon Sep 10 15:49:14 AEST 2007
Workarea:  redback.melbourne.sgi.com:/home/lachlan/isms/2.6.x-fixes
Inspected by:  Christoph Hellwig <hch@lst.de>

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:29630a
fs/xfs/xfs_vfsops.c - 1.537 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_vfsops.c.diff?r1=text&tr1=1.537&r2=text&tr2=1.536&f=h
	- remove dead SYNC_BDFLUSH case in xfs_sync_inodes
