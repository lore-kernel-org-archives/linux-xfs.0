Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 09 Apr 2008 00:30:37 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m397UKLF020658
	for <xfs@oss.sgi.com>; Wed, 9 Apr 2008 00:30:22 -0700
Subject: PARTIAL TAKE 980084 - Catch errors returned from xfs_bmap_last_offset().
Message-Id: <20080409073054.E39AB58C4C0F@chook.melbourne.sgi.com>
Date: Wed,  9 Apr 2008 17:30:54 +1000 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Catch errors returned from xfs_bmap_last_offset().

xfs_bmap_last_offset() can fail and return an error.
xfs_iomap_write_allocate() fails to detect and propagate the error.

Date:  Wed Apr  9 17:30:31 AEST 2008
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  xaiki@sgi.com

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:30802a
fs/xfs/xfs_iomap.c - 1.62 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_iomap.c.diff?r1=text&tr1=1.62&r2=text&tr2=1.61&f=h
	- Catch errors returned from xfs_bmap_last_offset().
