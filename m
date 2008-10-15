Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 14 Oct 2008 19:06:24 -0700 (PDT)
Received: from relay.sgi.com (relay1.corp.sgi.com [192.26.58.214])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9F26MOY006218
	for <xfs@oss.sgi.com>; Tue, 14 Oct 2008 19:06:22 -0700
Subject: TAKE 988141 - Fix build warning - xfs_fs_alloc_inode() needs a return statement
Message-Id: <20081015020757.443A558FA1E9@chook.melbourne.sgi.com>
Date: Wed, 15 Oct 2008 13:07:57 +1100 (EST)
From: lachlan@sgi.com (Lachlan McIlroy)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

Fix build warning - xfs_fs_alloc_inode() needs a return statement

Date:  Wed Oct 15 13:07:36 EST 2008
Workarea:  redback.melbourne.sgi.com:/home/lachlan/isms/2.6.x-inode
Inspected by:  lachlan
Author:  lachlan

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:32325a
fs/xfs/linux-2.6/xfs_super.c - 1.460 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_super.c.diff?r1=text&tr1=1.460&r2=text&tr2=1.459&f=h
	- Fix build warning - xfs_fs_alloc_inode() needs a return statement
