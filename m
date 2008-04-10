Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 09 Apr 2008 18:11:00 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m3A1AkEk001551
	for <xfs@oss.sgi.com>; Wed, 9 Apr 2008 18:10:49 -0700
Subject: TAKE 980084 - Catch log unmount failures.
Message-Id: <20080410010144.94DA258C4C15@chook.melbourne.sgi.com>
Date: Thu, 10 Apr 2008 11:01:44 +1000 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Catch log unmount failures.

Unmounting the log can fail. unlikely, but it can. Catch all
the error conditions an make sure it's propagated upwards.

Date:  Thu Apr 10 11:01:28 AEST 2008
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  xaiki@sgi.com

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:30833a
fs/xfs/xfs_log.c - 1.356 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_log.c.diff?r1=text&tr1=1.356&r2=text&tr2=1.355&f=h
	- Catch log unmount failures.
