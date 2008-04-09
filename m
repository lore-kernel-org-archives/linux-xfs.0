Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 09 Apr 2008 00:15:53 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m397Fe47011936
	for <xfs@oss.sgi.com>; Wed, 9 Apr 2008 00:15:42 -0700
Subject: PARTIAL TAKE 980084 - Clean up xfs_alloc_search_busy() return values.
Message-Id: <20080409071613.1AFB858C4C0F@chook.melbourne.sgi.com>
Date: Wed,  9 Apr 2008 17:16:13 +1000 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Clean up xfs_alloc_search_busy() return values.

xfs_alloc_search_busy() returns an index into the busy
array if the extent was found in the array. This is never checked,
and the xfs_alloc_search_busy() does a log force to prevent
reuse of the extent before the free transaction hits the disk.
Hence the return value is useless. Declare the function void
and remove the slot number from the tracing as well.


Date:  Wed Apr  9 17:15:51 AEST 2008
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  xaiki@sgi.com

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:30796a
fs/xfs/xfs_alloc.c - 1.191 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_alloc.c.diff?r1=text&tr1=1.191&r2=text&tr2=1.190&f=h
	- Clean up xfs_alloc_search_busy() return values.
