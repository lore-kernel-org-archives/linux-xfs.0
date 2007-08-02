Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 02 Aug 2007 03:59:05 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l72Awwbm021634
	for <xfs@oss.sgi.com>; Thu, 2 Aug 2007 03:59:00 -0700
Subject: PARTIAL TAKE 968563 - fix dmapi warning in 32bit builds
Message-Id: <20070802105858.C6AC858F4B6D@chook.melbourne.sgi.com>
Date: Thu,  2 Aug 2007 20:58:58 +1000 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

fix dmapi warning in 32bit builds

dm_size_t is 64bit even in 32bit builds so we need to use max_t when
when comparing to PAGE_CACHE_SIZE.


Signed-off-by: Christoph Hellwig <hch@lst.de>


Date:  Thu Aug  2 20:58:31 AEST 2007
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  hch@lst.de

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:29314a
fs/xfs/dmapi/xfs_dm.c - 1.40 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/dmapi/xfs_dm.c.diff?r1=text&tr1=1.40&r2=text&tr2=1.39&f=h
	- fix 32bit build warning in xfs_dm_probe_hole.
