Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 22 Sep 2008 20:48:52 -0700 (PDT)
Received: from relay.sgi.com (netops-testserver-3.corp.sgi.com [192.26.57.72])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8N3mjhn002666
	for <xfs@oss.sgi.com>; Mon, 22 Sep 2008 20:48:46 -0700
Subject: TAKE 987159 - Remove xfs_iext_irec_compact_full()
Message-Id: <20080923035018.7D3CF58C52AE@chook.melbourne.sgi.com>
Date: Tue, 23 Sep 2008 13:50:18 +1000 (EST)
From: lachlan@sgi.com (Lachlan McIlroy)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

Remove xfs_iext_irec_compact_full()

Yet another bug was found in xfs_iext_irec_compact_full() and while the
source of the bug was found it wasn't an easy task to track it down because
the conditions are very difficult to reproduce.

A HUGE thank-you goes to Russell Cattelan and Eric Sandeen for their
significant effort in tracking down the source of this corruption.

xfs_iext_irec_compact_full() and xfs_iext_irec_compact_pages() are almost
identical - they both compact indirect extent lists by moving extents from
subsequent buffers into earlier ones.  xfs_iext_irec_compact_pages() only
moves extents if all of the extents in the next buffer will fit into the
empty space in the buffer before it.  xfs_iext_irec_compact_full() will go
a step further and move part of the next buffer if all the extents wont fit.
It will then shift the remaining extents in the next buffer up to the start
of the buffer.  The bug here was that we did not update er_extoff and this
caused extent list corruption.

It does not appear that this extra functionality gains us much.  Calling
xfs_iext_irec_compact_pages() instead will do a good enough job at compacting
the indirect list and will be quicker too.

For the case in xfs_iext_indirect_to_direct() the total number of extents
in the indirect list will fit into one buffer so we will never need the
extra functionality of xfs_iext_irec_compact_full() there.

Also xfs_iext_irec_compact_pages() doesn't need to do a memmove() (the
buffers will never overlap) so we don't want the performance hit that
can incur.

Date:  Tue Sep 23 13:49:26 AEST 2008
Workarea:  redback.melbourne.sgi.com:/home/lachlan/isms/2.6.x-xfs
Inspected by:  sandeen@sandeen.net
Author:  lachlan

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:32166a
fs/xfs/xfs_inode.c - 1.522 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_inode.c.diff?r1=text&tr1=1.522&r2=text&tr2=1.521&f=h
	- Remove xfs_iext_irec_compact_full()
