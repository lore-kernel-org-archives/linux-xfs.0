Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 18 Jul 2007 01:20:14 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l6I8K8bm016112
	for <xfs@oss.sgi.com>; Wed, 18 Jul 2007 01:20:10 -0700
Subject: TAKE 966308 - null files fix deficient when growing a file via ftruncate
Message-Id: <20070718082005.A5CC858C52B5@chook.melbourne.sgi.com>
Date: Wed, 18 Jul 2007 18:20:05 +1000 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Fix inode size update before data write in xfs_setattr

When changing the file size by a truncate() call, we log
the change in the inode size. However, we do not flush any outstanding
data that might not have been written to disk, thereby violating the
data/inode size update order. This can leave files full of NULLs
on crash.

Hence if we are truncating the file, flush any unwritten data that
may lie between the curret on disk inode size and the new inode size
that is being logged to ensure that ordering is preserved.


Date:  Wed Jul 18 18:19:31 AEST 2007
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  hch@lst.de

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:29174a
fs/xfs/xfs_vnodeops.c - 1.704 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_vnodeops.c.diff?r1=text&tr1=1.704&r2=text&tr2=1.703&f=h
	- Flush unwritten data between the current on disk inode size
	  and the new inode size logged by xfs_setattr during a truncate
	  operation to ensure the data is on disk before the inode size
	  update.
