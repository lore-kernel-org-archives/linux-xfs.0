Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 01 Feb 2007 21:24:21 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l125OCqw006015
	for <xfs@oss.sgi.com>; Thu, 1 Feb 2007 21:24:14 -0800
Subject: PARTIAL TAKE 959267 - bad clientid during log replay of snapshot image
Message-Id: <20070202052311.4DD7758FF653@chook.melbourne.sgi.com>
Date: Fri,  2 Feb 2007 16:23:11 +1100 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com, sgi.bugs.xfs@engr.sgi.com

Ensure a frozen filesystem has a clean log before writing the dummy record.

The current Linux XFS freeze code is a mess. We flush the metadata
buffers out while we are still allowing new transactions to start
and then fail to flush the dirty buffers back out before writing
the unmount and dummy records to the log.

This leads to problems when the frozen filesystem is used for
snapshots - we do log recovery on a readonly image and often
it appears that the log image in the snapshot is not correct.
Hence we end up with hangs, oops and mount failures when trying
to mount a snapshot image that has been created when the filesystem
has not been correctly frozen.

To fix this, we need to move th metadata flush to after we wait for all
current transactions to complete in teh second stage of the freeze.
This means that when we write the final log records, the log should
be clean and recovery should never occur on a snapshot image created
from a frozen filesystem.

Date:  Fri Feb  2 16:22:20 AEDT 2007
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  donaldd

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:28010a
fs/xfs/xfs_vfsops.c - 1.514 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_vfsops.c.diff?r1=text&tr1=1.514&r2=text&tr2=1.513&f=h
	- Push xfs_quiesce_fs() down into xfs_freeze() so it occurs
	  after we've blocked new transactions and waited for all the
	  currently running transactions to complete. hence we should
	  have a clean log before we write the unmount and dummy records
	  into the log.

fs/xfs/linux-2.6/xfs_vfs.h - 1.68 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_vfs.h.diff?r1=text&tr1=1.68&r2=text&tr2=1.67&f=h
	- Add definition of SYNC_DIO_WAIT for telling the sync code
	  to wait for direct I/O to complete.

fs/xfs/linux-2.6/xfs_super.c - 1.376 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_super.c.diff?r1=text&tr1=1.376&r2=text&tr2=1.375&f=h
	- After the writes are frozen, simply flush out the data and wait for
	  all data I/O (including direct I/O) to complete. Don't bother
	  flushing the metadata out - we still have active transactions
	  at this point.
