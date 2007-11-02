Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 01 Nov 2007 19:35:54 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id lA22Zmhd018421
	for <xfs@oss.sgi.com>; Thu, 1 Nov 2007 19:35:50 -0700
Subject: TAKE 972753 - Fix inode allocation latency
Message-Id: <20071102023547.E27C658C38F7@chook.melbourne.sgi.com>
Date: Fri,  2 Nov 2007 13:35:47 +1100 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Fix inode allocation latency

The log force added in xfs_iget_core() has been a performance
issue since it was introduced for tight loops that allocate
then unlink a single file. under heavy writeback, this can
introduce unnecessary latency due tothe log I/o getting
stuck behind bulk data writes.

Fix this latency problem by avoinding the need for the log
force by moving the place we mark linux inode dirty to the
transaction commit rather than on transaction completion.

This also closes a potential hole in the sync code where a
linux inode is not dirty between the time it is modified and
the time the log buffer has been written to disk.

Date:  Fri Nov  2 13:35:27 AEDT 2007
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  hch@infradead.org

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:30007a
fs/xfs/xfs_inode_item.c - 1.132 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_inode_item.c.diff?r1=text&tr1=1.132&r2=text&tr2=1.131&f=h
	- Remove the need to mark the linux inode dirty in xfs_iunpin by marking
	  it dirty during transaction commit.

fs/xfs/xfs_iget.c - 1.237 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_iget.c.diff?r1=text&tr1=1.237&r2=text&tr2=1.236&f=h
	- Remove the need to force the log on pinned inode reuse by making sure
	  we never need to touch the linux inode during transaction completion.

fs/xfs/xfs_inode.c - 1.485 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_inode.c.diff?r1=text&tr1=1.485&r2=text&tr2=1.484&f=h
	- Remove the need to mark the linux inode dirty in xfs_iunpin by marking
	  it dirty during transaction commit.

fs/xfs/xfs_inode.h - 1.237 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_inode.h.diff?r1=text&tr1=1.237&r2=text&tr2=1.236&f=h
	- Remove the need to mark the linux inode dirty in xfs_iunpin by marking
	  it dirty during transaction commit.

fs/xfs/linux-2.6/xfs_iops.c - 1.267 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_iops.c.diff?r1=text&tr1=1.267&r2=text&tr2=1.266&f=h
	- Remove the need to mark the linux inode dirty in xfs_iunpin by marking
	  it dirty during transaction commit.
