Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 04 Sep 2008 20:49:48 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m853nfa4021887
	for <xfs@oss.sgi.com>; Thu, 4 Sep 2008 20:49:43 -0700
Subject: TAKE 983683 - Don't do I/O beyond eof when unreserving space
Message-Id: <20080905035107.D2BBD58C52AB@chook.melbourne.sgi.com>
Date: Fri,  5 Sep 2008 13:51:07 +1000 (EST)
From: lachlan@sgi.com (Lachlan McIlroy)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

Don't do I/O beyond eof when unreserving space

When unreserving space with boundaries that are not block aligned we round
up the start and round down the end boundaries and then use this function,
xfs_zero_remaining_bytes(), to zero the parts of the blocks that got dropped
during the rounding.  The problem is we don't consider if these blocks are
beyond eof.  Worse still is if we encounter delayed allocations beyond eof
we will try to use the magic delayed allocation block number as a real block
number.  If the file size is ever extended to expose these blocks then we'll
go through xfs_zero_eof() to zero them anyway.

Date:  Fri Sep  5 13:50:14 AEST 2008
Workarea:  redback.melbourne.sgi.com:/home/lachlan/isms/2.6.x-xfs
Inspected by:  hch
Author:  lachlan

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:32055a
fs/xfs/xfs_vnodeops.c - 1.774 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_vnodeops.c.diff?r1=text&tr1=1.774&r2=text&tr2=1.773&f=h
	- Don't do I/O beyond eof when unreserving space
