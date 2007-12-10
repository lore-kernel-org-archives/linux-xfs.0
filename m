Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 10 Dec 2007 13:55:19 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id lBALsjUa013424
	for <xfs@oss.sgi.com>; Mon, 10 Dec 2007 13:54:57 -0800
Subject: TAKE 964002 - Don't wait for pending I/Os when purging blocks beyond eof.
Message-Id: <20071210055955.0F96358C4C34@chook.melbourne.sgi.com>
Date: Mon, 10 Dec 2007 16:59:55 +1100 (EST)
From: lachlan@sgi.com (Lachlan McIlroy)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

Don't wait for pending I/Os when purging blocks beyond eof.

On last close of a file we purge blocks beyond eof.  The same
code is used when we truncate the file size down.  In this case
we need to wait for any pending I/Os for dirty pages beyond the
new eof.  For the last close case we are not changing the file
size and therefore do not need to wait for any I/Os to complete.
This fixes a performance bottleneck where writes into the page
cache and cache flushes can become mutually exclusive.

Date:  Mon Dec 10 16:59:09 AEDT 2007
Workarea:  redback.melbourne.sgi.com:/home/lachlan/isms/2.6.x-vniowait
Inspected by:  pleckie
Author:  lachlan

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:30220a
fs/xfs/xfs_inode.c - 1.489 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_inode.c.diff?r1=text&tr1=1.489&r2=text&tr2=1.488&f=h
	- Don't wait for pending I/Os when purging blocks beyond eof.
