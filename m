Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 02 Aug 2007 04:54:14 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l72Bs7bm014544
	for <xfs@oss.sgi.com>; Thu, 2 Aug 2007 04:54:10 -0700
Subject: PARTIAL TAKE 968563 - clean up xfs_start_flags
Message-Id: <20070802115353.D5C9258F4B6D@chook.melbourne.sgi.com>
Date: Thu,  2 Aug 2007 21:53:53 +1000 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

clean up xfs_start_flags

xfs_start_flags can make use of is_power_of_2 to
tidy up the test a little bit.

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>

Date:  Thu Aug  2 21:53:18 AEST 2007
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  sandeen@sandeen.net

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:29327a
fs/xfs/xfs_log_priv.h - 1.119 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_log_priv.h.diff?r1=text&tr1=1.119&r2=text&tr2=1.118&f=h
	- use of is_power_of_2 rather than explicitly testing all the
	  possible power of 2 log buffer sizes.

fs/xfs/xfs_vfsops.c - 1.523 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_vfsops.c.diff?r1=text&tr1=1.523&r2=text&tr2=1.522&f=h
	- use of is_power_of_2 rather than explicitly testing all the
	  possible power of 2 log buffer sizes.
