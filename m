Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 21 Feb 2008 20:15:12 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m1M4F3m2004231
	for <xfs@oss.sgi.com>; Thu, 21 Feb 2008 20:15:07 -0800
Subject: TAKE 977545 - xfsaild causing too many wakeups
Message-Id: <20080222041525.37EA858C4C0F@chook.melbourne.sgi.com>
Date: Fri, 22 Feb 2008 15:15:25 +1100 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

xfsaild causing too many wakeups

Idle state is not being detected properly by the xfsaild push code.
The current idle state is detected by an empty list which may never
happen with mostly idle filesystem or one using lazy superblock
counters. A single dirty item in the list that exists beyond the
push target can result repeated looping attempting to push
up to the target because it fails to check if the push target
has been acheived or not.

Fix by considering a dirty list with everything past the target
as an idle state and set the timeout appropriately.


Date:  Fri Feb 22 15:15:03 AEDT 2008
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  hch@infradead.org

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:30532a
fs/xfs/xfs_trans_ail.c - 1.85 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_trans_ail.c.diff?r1=text&tr1=1.85&r2=text&tr2=1.84&f=h
	- Move the aild to idle state if we have pushed past the target
	  we have been given.
