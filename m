Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 09 Oct 2007 18:24:29 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id l9A1OJ8q014082
	for <xfs@oss.sgi.com>; Tue, 9 Oct 2007 18:24:21 -0700
Subject: TAKE 971670 - Ensure sync flushes all dirty data to disk
Message-Id: <20071010012416.524D258C38F1@chook.melbourne.sgi.com>
Date: Wed, 10 Oct 2007 11:24:16 +1000 (EST)
From: lachlan@sgi.com (Lachlan McIlroy)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

avoid race in sync_inodes() that can fail to write out all dirty data

In xfs_fs_sync_super() treat a sync the same as a filesystem freeze.
This is needed to force the log to disk for inodes which are not marked
dirty in the Linux inode (the inodes are marked dirty on completion of
the log I/O) and so sync_inodes() will not flush them.

In xfs_fs_write_inode() a synchronous flush will not get an EAGAIN
from xfs_inode_flush() and if an asynchronous flush returns EAGAIN
we should pass it on to the caller.  If we get an error while flushing
the inode then re-dirty it so we can try again later.

Date:  Wed Oct 10 11:22:49 AEST 2007
Workarea:  redback.melbourne.sgi.com:/home/lachlan/isms/2.6.x-preempt
Inspected by:  dgc
Author:  lachlan

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:29860a
fs/xfs/linux-2.6/xfs_super.c - 1.401 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_super.c.diff?r1=text&tr1=1.401&r2=text&tr2=1.400&f=h
	- avoid race in sync_inodes() that can fail to write out all dirty data
