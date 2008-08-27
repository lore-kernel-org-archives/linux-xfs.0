Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 26 Aug 2008 22:56:45 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m7R5ueWY022276
	for <xfs@oss.sgi.com>; Tue, 26 Aug 2008 22:56:41 -0700
Subject: TAKE 986143 - Fix barrier status change detection.
Message-Id: <20080827055801.1ECB158C52A8@chook.melbourne.sgi.com>
Date: Wed, 27 Aug 2008 15:58:01 +1000 (EST)
From: pleckie@sgi.com (Peter Leckie)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com, sgi.bugs.xfs@engr.sgi.com

Fix barrier status change detection.

The current code in xlog_iodone() uses the wrong macro
to check if the barrier has been cleared due to an EOPNOTSUPP
error form the lower layer.

Signed-off-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Nathaniel W. Turner <nate@houseofnate.net>


Date:  Wed Aug 27 15:56:11 AEST 2008
Workarea:  chook.melbourne.sgi.com:/build/pleckie/2.6.x-xfs
Inspected by:  pleckie,david@fromorbit.com

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:31984a
fs/xfs/xfs_log.c - 1.367 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_log.c.diff?r1=text&tr1=1.367&r2=text&tr2=1.366&f=h
	- Fix barrier status change detection.
