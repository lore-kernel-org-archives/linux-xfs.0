Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 22 Dec 2006 01:51:43 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id kBM9pWqw005622
	for <xfs@oss.sgi.com>; Fri, 22 Dec 2006 01:51:35 -0800
Subject: PARTIAL TAKE 958376 - xfs warnings about potential use of uninitialized variables 
Message-Id: <20061120231336.6420758FF4ED@chook.melbourne.sgi.com>
Date: Tue, 21 Nov 2006 10:13:36 +1100 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

Stale the correct inode when freeing clusters.

Date:  Tue Nov 21 10:11:46 AEDT 2006
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  tes

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:27503a
fs/xfs/xfs_inode.c - 1.455 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_inode.c.diff?r1=text&tr1=1.455&r2=text&tr2=1.454&f=h
	- Fix xfs_ifree_cluster to stale the correct inode when
	  walking the log items attached to the cluster buffer.
