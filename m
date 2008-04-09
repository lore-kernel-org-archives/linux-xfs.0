Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 08 Apr 2008 23:43:08 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m396guhd000879
	for <xfs@oss.sgi.com>; Tue, 8 Apr 2008 23:42:59 -0700
Subject: PARTIAL TAKE 980084 - Report errors from xfs_reserve_blocks().
Message-Id: <20080409064328.20C5358C4C0F@chook.melbourne.sgi.com>
Date: Wed,  9 Apr 2008 16:43:28 +1000 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Report errors from xfs_reserve_blocks().

xfs_reserve_blocks() can fail in interesting ways. In neither
case is it a fatal error, but the result can lead to sub-optimal
behaviour. Warn to the syslog if the call fails but otherwise
continue.

Date:  Wed Apr  9 16:43:02 AEST 2008
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  xaiki@sgi.com

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:30784a
fs/xfs/xfs_mount.c - 1.424 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_mount.c.diff?r1=text&tr1=1.424&r2=text&tr2=1.423&f=h
	- Report errors from xfs_reserve_blocks().
