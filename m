Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 14 Oct 2008 19:09:17 -0700 (PDT)
Received: from relay.sgi.com (relay1.corp.sgi.com [192.26.58.214])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9F29EKA006733
	for <xfs@oss.sgi.com>; Tue, 14 Oct 2008 19:09:14 -0700
Subject: TAKE 988141 - Fix build error - use VFS_I() to access linux inode from xfs inode
Message-Id: <20081015021055.6B76358FA1E9@chook.melbourne.sgi.com>
Date: Wed, 15 Oct 2008 13:10:55 +1100 (EST)
From: lachlan@sgi.com (Lachlan McIlroy)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

Fix build error - use VFS_I() to access linux inode from xfs inode

Date:  Wed Oct 15 13:10:35 EST 2008
Workarea:  redback.melbourne.sgi.com:/home/lachlan/isms/2.6.x-inode
Inspected by:  lachlan
Author:  lachlan

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:32326a
fs/xfs/dmapi/xfs_dm.c - 1.79 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/dmapi/xfs_dm.c.diff?r1=text&tr1=1.79&r2=text&tr2=1.78&f=h
	- Fix build error - use VFS_I() to access linux inode from xfs inode
