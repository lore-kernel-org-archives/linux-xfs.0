Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 22 Sep 2008 01:10:31 -0700 (PDT)
Received: from relay.sgi.com (relay2.corp.sgi.com [192.26.58.22])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8M8AExK003536
	for <xfs@oss.sgi.com>; Mon, 22 Sep 2008 01:10:14 -0700
Subject: TAKE 987246 - Unlock inode before calling xfs_idestroy()
Message-Id: <20080922081140.3862858C52AE@chook.melbourne.sgi.com>
Date: Mon, 22 Sep 2008 18:11:40 +1000 (EST)
From: lachlan@sgi.com (Lachlan McIlroy)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

Unlock inode before calling xfs_idestroy()

Lock debugging reported the ilock was being destroyed without being
unlocked.  We don't need to lock the inode until we are going to
insert it into the radix tree.

Date:  Mon Sep 22 18:10:49 AEST 2008
Workarea:  redback.melbourne.sgi.com:/home/lachlan/isms/2.6.x-tot
Inspected by:  hch
Author:  lachlan

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:32159a
fs/xfs/xfs_iget.c - 1.246 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_iget.c.diff?r1=text&tr1=1.246&r2=text&tr2=1.245&f=h
	- Unlock inode before calling xfs_idestroy()
