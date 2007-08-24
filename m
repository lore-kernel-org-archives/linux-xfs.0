Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 24 Aug 2007 04:01:47 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l7OB1f4p028227
	for <xfs@oss.sgi.com>; Fri, 24 Aug 2007 04:01:44 -0700
Subject: PARTIAL TAKE 969608 - Create xfs_iflags_test_and_clear helper function
Message-Id: <20070824110137.1F4E858C38F1@chook.melbourne.sgi.com>
Date: Fri, 24 Aug 2007 21:01:37 +1000 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Create xfs_iflags_test_and_clear helper function

Signed-off-by: Christoph Hellwig <hch@lst.de>


Date:  Fri Aug 24 21:01:07 AEST 2007
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  hch@lst.de

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:29496a
fs/xfs/xfs_vnodeops.c - 1.713 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_vnodeops.c.diff?r1=text&tr1=1.713&r2=text&tr2=1.712&f=h
	- use a xfs_iflags_test_and_clear helper instead of open coding.

fs/xfs/xfs_inode.h - 1.228 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_inode.h.diff?r1=text&tr1=1.228&r2=text&tr2=1.227&f=h
	- use a xfs_iflags_test_and_clear helper instead of open coding.
