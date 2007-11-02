Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 01 Nov 2007 18:57:04 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id lA21uuWM012579
	for <xfs@oss.sgi.com>; Thu, 1 Nov 2007 18:56:59 -0700
Subject: TAKE 972757 - Fix transaction overrun during writeback.
Message-Id: <20071102015656.B31AC58C38F7@chook.melbourne.sgi.com>
Date: Fri,  2 Nov 2007 12:56:56 +1100 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Fix transaction overrun during writeback.

Prevent transaction overrun in xfs_iomap_write_allocate() if we
race with a truncate that overlaps the delalloc range we were
planning to allocate.

If we race, we may allocate into a hole and that requires block
allocation. At this point in time we don't have a reservation for
block allocation (apart from metadata blocks) and so allocating
into a hole rather than a delalloc region results in overflowing
the transaction block reservation.

Fix it by only allowing a single extent to be allocated at a
time.


Date:  Fri Nov  2 12:56:36 AEDT 2007
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  lachlan@sgi.com

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:30005a
fs/xfs/xfs_iomap.c - 1.60 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_iomap.c.diff?r1=text&tr1=1.60&r2=text&tr2=1.59&f=h
	- Only allow xfs_iomap_write_allocate to allocate a single extent at a
	  time to prevent races with truncate from causing unreserved allocation
	  and hence transaction overruns.
