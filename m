Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 19 Aug 2008 23:07:19 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m7K67D3w022660
	for <xfs@oss.sgi.com>; Tue, 19 Aug 2008 23:07:14 -0700
Subject: PARTIAL TAKE 983683 - Prevent direct I/O from mapping extents beyond eof
Message-Id: <20080820060831.B658D58C52A8@chook.melbourne.sgi.com>
Date: Wed, 20 Aug 2008 16:08:31 +1000 (EST)
From: lachlan@sgi.com (Lachlan McIlroy)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

Prevent direct I/O from mapping extents beyond eof

With the help from some tracing I found that we try to map extents beyond
eof when doing a direct I/O read.  It appears that the way to inform the
generic direct I/O path (ie do_direct_IO()) that we have breached eof is
to return an unmapped buffer from xfs_get_blocks_direct().  This will cause
do_direct_IO() to jump to the hole handling code where is will check for
eof and then abort.

This problem was found because a direct I/O read was trying to map beyond
eof and was encountering delayed allocations.  The delayed allocations beyond
eof are speculative allocations and they didn't get converted when the direct
I/O flushed the file because there was only enough space in the current AG
to convert and write out the dirty pages within eof.  Note that
xfs_iomap_write_allocate() wont necessarily convert all the delayed allocation
passed to it - it will return after allocating the first extent - so if the
delayed allocation extends beyond eof then it will stay that way.

Date:  Wed Aug 20 16:07:36 AEST 2008
Workarea:  redback.melbourne.sgi.com:/home/lachlan/isms/2.6.x-xfs
Inspected by:  hch
Author:  lachlan

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:31929a
fs/xfs/linux-2.6/xfs_aops.c - 1.164 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_aops.c.diff?r1=text&tr1=1.164&r2=text&tr2=1.163&f=h
	- Prevent direct I/O from mapping extents beyond eof
