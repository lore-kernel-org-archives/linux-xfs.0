Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 16 Jan 2007 04:29:25 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l0GCTHqw002343
	for <xfs@oss.sgi.com>; Tue, 16 Jan 2007 04:29:19 -0800
Subject: TAKE 956323 - File system block reservation mechanism is broken
Message-Id: <20070116120407.59C3A58F92CD@chook.melbourne.sgi.com>
Date: Tue, 16 Jan 2007 23:04:07 +1100 (EST)
From: chatz@sgi.com (David Chatterton)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Fix block reservation changes for non-SMP systems.

Signed-off-by: Kevin Jamieson <kjamieson@bycast.com>


Date:  Tue Jan 16 23:03:21 AEDT 2007
Workarea:  chook.melbourne.sgi.com:/build/chatz/isms/xfs-linux
Inspected by:  kjamieson,dgc

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-kern/xfs-linux-melb


Modid:  xfs-linux-melb:xfs-kern:27940a
xfs_mount.h - 1.233 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_mount.h.diff?r1=text&tr1=1.233&r2=text&tr2=1.232&f=h
	- No-op xfs_icsb_sync_counters_flags on non-SMP builds.
