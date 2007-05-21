Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 21 May 2007 16:39:16 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l4LNd5fB014946
	for <xfs@oss.sgi.com>; Mon, 21 May 2007 16:39:07 -0700
Subject: PARTIAL TAKE 964983 - vmalloc leak on mount/unmount
Message-Id: <20070521233902.4571058CA531@chook.melbourne.sgi.com>
Date: Tue, 22 May 2007 09:39:02 +1000 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com, sgi.bugs.xfs@engr.sgi.com

Fix vmalloc leak on mount/unmount.

When setting the length of the iclogbuf to write out we should just
be changing the desired byte count rather completely reassociating
the buffer memory with the buffer. Reassociating the buffer memory
changes the apparent length of the buffer and hence when we free the
buffer, we don't free all the vmap()d space we originally allocated.

Date:  Tue May 22 09:38:29 AEST 2007
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  hch@lst.de

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:28640a
fs/xfs/xfs_log.c - 1.331 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_log.c.diff?r1=text&tr1=1.331&r2=text&tr2=1.330&f=h
	- Set the iclogbuf I/O size correctly rather than reassociating the
	  memory which can lead to vmalloc leaks.
