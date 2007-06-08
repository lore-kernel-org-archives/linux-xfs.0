Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 08 Jun 2007 01:35:38 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l588ZXWt018792
	for <xfs@oss.sgi.com>; Fri, 8 Jun 2007 01:35:35 -0700
Subject: TAKE 964538 - tail-pushing deadlock when flushing inodes on unmount
Message-Id: <20070608083528.D7EC658C38F2@chook.melbourne.sgi.com>
Date: Fri,  8 Jun 2007 18:35:28 +1000 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Prevent deadlock when flushing inodes on unmount

When we are unmounting the filesystem, we flush all the inodes to
disk. Unfortunately, if we have an inode cluster that has just been
freed and marked stale sitting in an incore log buffer (i.e. hasn't
been flushed to disk), it will be holding all the flush locks on the
inodes in that cluster.

xfs_iflush_all() which is called during unmount walks all the inodes
trying to reclaim them, and it doing so calls xfs_finish_reclaim() on
each inode. If the inode is dirty, if grabs the flush lock and flushes
it. Unfortunately, find dirty inodes that already have their flush lock
held and so we sleep.

At this point in the unmount process, we are running single-threaded.
There is nothing more that can push on the log to force the transaction
holding the inode flush locks to disk and hence we deadlock.

The fix is to issue a log force before flushing the inodes on
unmount so that all the flush locks will be released before we start
flushing the inodes.

Date:  Fri Jun  8 18:34:39 AEST 2007
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  tes@sgi.com

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:28862a
fs/xfs/xfs_mount.c - 1.396 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_mount.c.diff?r1=text&tr1=1.396&r2=text&tr2=1.395&f=h
	- Force the log before we flush all the inodes on unmount to prevent
	  a deadlock if any inode flush locks are held by transactions that
	  are not yet on disk.
