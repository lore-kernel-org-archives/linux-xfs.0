Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 25 Sep 2008 21:40:59 -0700 (PDT)
Received: from relay.sgi.com (relay2.corp.sgi.com [192.26.58.22])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8Q4etoU011453
	for <xfs@oss.sgi.com>; Thu, 25 Sep 2008 21:40:55 -0700
Subject: TAKE 981668 - Wait for all I/O on truncate to zero file size
Message-Id: <20080926044226.3D4DD58C52AE@chook.melbourne.sgi.com>
Date: Fri, 26 Sep 2008 14:42:26 +1000 (EST)
From: lachlan@sgi.com (Lachlan McIlroy)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

Wait for all I/O on truncate to zero file size

It's possible to have outstanding xfs_ioend_t's queued when the file
size is zero.  This can happen in the direct I/O path when a direct
I/O write fails due to ENOSPC.  In this case the xfs_ioend_t will still
be queued (ie xfs_end_io_direct() does not know that the I/O failed so
can't force the xfs_ioend_t to be flushed synchronously).

When we truncate a file on unlink we don't know to wait for these
xfs_ioend_ts and we can have a use-after-free situation if the inode
is reclaimed before the xfs_ioend_t is finally processed.

As was suggested by Dave Chinner lets wait for all I/Os to complete
when truncating the file size to zero.

Date:  Fri Sep 26 14:41:42 AEST 2008
Workarea:  redback.melbourne.sgi.com:/home/lachlan/isms/2.6.x-tot
Inspected by:  hch
Author:  lachlan

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:32216a
fs/xfs/xfs_inode.c - 1.524 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_inode.c.diff?r1=text&tr1=1.524&r2=text&tr2=1.523&f=h
	- Wait for all I/O on truncate to zero file size
