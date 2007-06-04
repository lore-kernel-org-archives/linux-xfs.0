Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 03 Jun 2007 23:15:28 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l546FLWt025769
	for <xfs@oss.sgi.com>; Sun, 3 Jun 2007 23:15:23 -0700
Subject: TAKE 965631 - xfs_bmapi() fails to update previous extent pointer
Message-Id: <20070604061517.AF6EF58C38C1@chook.melbourne.sgi.com>
Date: Mon,  4 Jun 2007 16:15:17 +1000 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com, sgi.bugs.xfs@engr.sgi.com

xfs_bmapi fails to update the previous extent pointer

When processing multiple extent maps, xfs_bmapi needs to keep
track of the extent behind the one it is currently working on
to be able to trim extent ranges correctly. Failing to update
the previous pointer can result in corrupted extent lists
in memory and this will result in panics or assert failures.

Update the previous pointer correctly when we move to the
next extent to process.

Date:  Mon Jun  4 16:14:47 AEST 2007
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  vapo@sgi.com

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:28773a
fs/xfs/xfs_bmap.c - 1.368 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_bmap.c.diff?r1=text&tr1=1.368&r2=text&tr2=1.367&f=h
	- Update the previous extent pointer correctly in xfs_bmapi.
