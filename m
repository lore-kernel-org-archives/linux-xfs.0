Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 09 Apr 2008 17:47:14 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m3A0l4TQ030196
	for <xfs@oss.sgi.com>; Wed, 9 Apr 2008 17:47:06 -0700
Subject: PARTIAL TAKE 980084 - Mark xfs_bulkstat_one_dinode() void.
Message-Id: <20080410004742.5B4C858C4C15@chook.melbourne.sgi.com>
Date: Thu, 10 Apr 2008 10:47:42 +1000 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

xfs_bulkstat_one_dinode() never returns an error.

Mark it void.


Date:  Thu Apr 10 10:47:12 AEST 2008
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  xaiki@sgi.com

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:30828a
fs/xfs/xfs_itable.c - 1.163 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_itable.c.diff?r1=text&tr1=1.163&r2=text&tr2=1.162&f=h
	- Make xfs_bulkstat_one_dinode() void.
