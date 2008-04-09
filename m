Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 09 Apr 2008 00:20:48 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m397Kc6W017684
	for <xfs@oss.sgi.com>; Wed, 9 Apr 2008 00:20:40 -0700
Subject: PARTIAL TAKE 980084 - xfs_bmap_adjacent() never returns an error.
Message-Id: <20080409072112.CC41258C4C0F@chook.melbourne.sgi.com>
Date: Wed,  9 Apr 2008 17:21:12 +1000 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

xfs_bmap_adjacent() never returns an error.

Mark it void.

Date:  Wed Apr  9 17:20:56 AEST 2008
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  xaiki@sgi.com

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:30798a
fs/xfs/xfs_bmap.c - 1.389 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_bmap.c.diff?r1=text&tr1=1.389&r2=text&tr2=1.388&f=h
	- Make xfs_bmap_adjacent() void.
