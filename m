Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 18 Jun 2008 00:54:58 -0700 (PDT)
Received: from molten.melbourne.sgi.com (molten.melbourne.sgi.com [134.14.54.33])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5I7srtV024714
	for <xfs@oss.sgi.com>; Wed, 18 Jun 2008 00:54:54 -0700
Subject: PARTIAL TAKE 956281 - fix XFSQA 145 / test_hole
Message-Id: <20080618075828.540975359B@molten.melbourne.sgi.com>
Date: Wed, 18 Jun 2008 17:58:28 +1000 (EST)
From: donaldd@molten.melbourne.sgi.com (Donald Douwsma)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.melbourne.sgi.com, xfs@oss.sgi.com

fix XFSQA 145 / test_hole

There are two errors I see all the time in 145:

 - dm_probe_hole returns EINVAL for offsets close to the file size
 - dm_probe_hole wants EAGAIN for a probe at offset 1, length 0


The first error is a consequence of how the hole puching / probing
works.  It always rounds the requested offset up to the next block
size and then checks if that rounded offset still fits into the file
size.  Just do the same rounding in the testcase to make sure we don't
probe invalid offsets.

The second error is very odd to me, as we never return AGAIN in the
whole dm_probe_hole path.  I've just commented it out.

I've also re-enabled the E2BIG to past-EOF test that was uncommented
before because it works perfectly fine now.


Signed-off-by: Christoph Hellwig <hch@lst.de>


Date:  Wed Jun 18 17:54:10 AEST 2008
Workarea:  molten.melbourne.sgi.com:/home/donaldd/isms/xfs-cmds
Inspected by:  hch

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-cmds/master-melb


Modid:  master-melb:xfs-cmds:31330a
xfstests/dmapi/src/suite2/src/test_hole.c - 1.9 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfstests/dmapi/src/suite2/src/test_hole.c.diff?r1=text&tr1=1.9&r2=text&tr2=1.8&f=h
xfstests/145.out - 1.2 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfstests/145.out.diff?r1=text&tr1=1.2&r2=text&tr2=1.1&f=h
	- fix XFSQA 145 / test_hole
