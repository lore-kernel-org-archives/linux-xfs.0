Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 05 Dec 2007 22:00:51 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id lB660TnY019466
	for <xfs@oss.sgi.com>; Wed, 5 Dec 2007 22:00:45 -0800
Subject: TAKE 974225 - Fix xfs_ichgtime()s broken usage of I_SYNC
Message-Id: <20071206060035.428E258FA249@chook.melbourne.sgi.com>
Date: Thu,  6 Dec 2007 17:00:35 +1100 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Fix xfs_ichgtime()s broken usage of I_SYNC

The recent I_LOCK->I_SYNC changes mistakenly changed xfs_ichgtime to
look at I_SYNC instead of I_LOCK. This was incorrect and prevents newly
created inodes from moving to the dirty list. Change this to the correct
check which is for I_NEW, not I_LOCK or I_SYNC so that behaviour is
correct.


Date:  Thu Dec  6 16:59:52 AEDT 2007
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  lachlan@sgi.com

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:30204a
fs/xfs/linux-2.6/xfs_iops.c - 1.271 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_iops.c.diff?r1=text&tr1=1.271&r2=text&tr2=1.270&f=h
	- Use I_NEW in xfs_ichgtime instead of I_SYNC so that new inodes are
	  moved to the dirty list correctly.
