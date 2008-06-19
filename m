Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 18 Jun 2008 21:38:13 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m5J4c8pY004344
	for <xfs@oss.sgi.com>; Wed, 18 Jun 2008 21:38:10 -0700
Subject: TAKE 983337 - fix extent corruption in xfs_iext_irec_compact_full()
Message-Id: <20080619043903.A166B58C4C3F@chook.melbourne.sgi.com>
Date: Thu, 19 Jun 2008 14:39:03 +1000 (EST)
From: lachlan@sgi.com (Lachlan McIlroy)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

fix extent corruption in xfs_iext_irec_compact_full()

This function is used to compact the indirect extent list by moving
extents from one page to the previous to fill them up.  After we
move some extents to an earlier page we need to shuffle the remaining
extents to the start of the page.  The actual bug here is the second
argument to memmove() needs to index past the extents, that were copied
to the previous page, and move the remaining extents.  For pages that
are already full (ie ext_avail == 0) the compaction code has no net
effect so don't do it.


Date:  Thu Jun 19 14:38:15 AEST 2008
Workarea:  redback.melbourne.sgi.com:/home/lachlan/isms/2.6.x-agno2
Inspected by:  hch
Author:  lachlan

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:31332a
fs/xfs/xfs_inode.c - 1.506 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_inode.c.diff?r1=text&tr1=1.506&r2=text&tr2=1.505&f=h
	- fix extent corruption in xfs_iext_irec_compact_full()
