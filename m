Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 10 May 2007 22:03:50 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l4B53ifB014004
	for <xfs@oss.sgi.com>; Thu, 10 May 2007 22:03:46 -0700
Subject: TAKE 963674 - Don't hold ilock when calling vn_iowait.
Message-Id: <20070511050340.A25B858CA530@chook.melbourne.sgi.com>
Date: Fri, 11 May 2007 15:03:40 +1000 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com, sgi.bugs.xfs@engr.sgi.com

Sleeping with the ilock waiting for I/O completion is Bad.

Recent fixes to the filesystem freezing code introduced a vn_iowait
call in the middle of the sync code. Unfortunately, at the point
where this call was added we are holding the ilock. The ilock is
needed by I/O completion for unwritten extent conversion and now
updating the file size. Hence I/o cannot complete if we hol dthe
ilock while waiting for I/O completion.

Fix up the bug and clean the code up around it.

Date:  Fri May 11 15:02:29 AEST 2007
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  hch@infradead.org,tes

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:28566a
fs/xfs/xfs_vfsops.c - 1.519 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_vfsops.c.diff?r1=text&tr1=1.519&r2=text&tr2=1.518&f=h
	- Drop the ilock before calling vn_iowait() when doing a SYNC_IOWAIT
	  sync operation. Make the code easier to understand as well.
