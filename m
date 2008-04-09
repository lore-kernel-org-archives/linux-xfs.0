Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 08 Apr 2008 23:39:09 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m396cuIJ032379
	for <xfs@oss.sgi.com>; Tue, 8 Apr 2008 23:38:59 -0700
Subject: PARTIAL TAKE 980084 - xfs_icsb_counter_disabled() never returns an error
Message-Id: <20080409063926.6361B58C4C0F@chook.melbourne.sgi.com>
Date: Wed,  9 Apr 2008 16:39:26 +1000 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

xfs_icsb_counter_disabled() never returns an error.

Mark it void.


Date:  Wed Apr  9 16:38:42 AEST 2008
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  xaiki@sgi.com

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:30782a
fs/xfs/xfs_mount.c - 1.423 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_mount.c.diff?r1=text&tr1=1.423&r2=text&tr2=1.422&f=h
	- make xfs_icsb_counter_disabled() void.
