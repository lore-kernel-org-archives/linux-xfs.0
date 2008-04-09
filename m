Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 08 Apr 2008 23:56:25 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m396uDgd004483
	for <xfs@oss.sgi.com>; Tue, 8 Apr 2008 23:56:16 -0700
Subject: PARTIAL TAKE 980084 - Catch errors resetting quota flags.
Message-Id: <20080409065648.5E86158C4C0F@chook.melbourne.sgi.com>
Date: Wed,  9 Apr 2008 16:56:48 +1000 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Catch errors resetting quota flags.

Warn to the syslog if we fail to reset the quota flags
in the superblock when a quota check fails.


Date:  Wed Apr  9 16:56:29 AEST 2008
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  xaiki@sgi.com

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:30789a
fs/xfs/quota/xfs_qm.c - 1.65 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/quota/xfs_qm.c.diff?r1=text&tr1=1.65&r2=text&tr2=1.64&f=h
	- Catch errors resetting quota flags.
