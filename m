Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 01 Nov 2007 19:43:24 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id lA22hFsG019415
	for <xfs@oss.sgi.com>; Thu, 1 Nov 2007 19:43:19 -0700
Subject: TAKE 972756 - Implement fallocate.
Message-Id: <20071102024314.9BF3458C38F7@chook.melbourne.sgi.com>
Date: Fri,  2 Nov 2007 13:43:14 +1100 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Implement fallocate.

Implement the new generic callout for file preallocation.
Atomically change the file size if requested.


Date:  Fri Nov  2 13:42:52 AEDT 2007
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  hch@infradead.org

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:30009a
fs/xfs/linux-2.6/xfs_iops.c - 1.268 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_iops.c.diff?r1=text&tr1=1.268&r2=text&tr2=1.267&f=h
	- implement ->fallocate()
