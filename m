Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 22 Dec 2006 01:51:46 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id kBM9pWr0005622
	for <xfs@oss.sgi.com>; Fri, 22 Dec 2006 01:51:39 -0800
Subject: TAKE 957195 - system wedged in xfs_write / xfs_buf_lock
Message-Id: <20061123033203.1239A58FF50E@chook.melbourne.sgi.com>
Date: Thu, 23 Nov 2006 14:32:03 +1100 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

Fix a synchronous buftarg flush deadlock when freezing.

At the last stage of a freeze, we flush the buftarg synchronously
over and over again until it succeeds twice without skipping
any buffers.

The delwri list flush skips pinned buffers, but tries to flush
all others. It removes the buffers from the delwri list, then tries
to lock them one at a time as it traverses the list to issue
the I/O. It holds them locked until we issue all of the I/O
and then unlocks them once we've waited for it to complete.

The problem is that during a freeze, the filesystem may
still be doing stuff - like flushing delalloc data buffers -
in the background and hence we can be trying to lock buffers
that were on the delwri list at the same time.  Hence we can
get ABBA deadlocks between threads doing allocation and the
buftarg flush (freeze) thread.

Fix it by skipping locked (and pinned) buffers as we traverse the
delwri buffer list.

Date:  Thu Nov 23 14:30:57 AEDT 2006
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  tes

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:27535a
fs/xfs/linux-2.6/xfs_buf.c - 1.230 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_buf.c.diff?r1=text&tr1=1.230&r2=text&tr2=1.229&f=h
	- Skip locked buffers when flushing the buftarg delwri buffer list
	  to prevent deadlocks with allocation when synchronously flushing
	  the buftarg during a freeze.
