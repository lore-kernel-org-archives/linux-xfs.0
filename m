Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 10 May 2007 20:39:18 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l4B3dDfB032370
	for <xfs@oss.sgi.com>; Thu, 10 May 2007 20:39:15 -0700
Subject: TAKE 964546 - Only use refcounted pages for I/O
Message-Id: <20070511033907.423A158CA530@chook.melbourne.sgi.com>
Date: Fri, 11 May 2007 13:39:06 +1000 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com, sgi.bugs.xfs@engr.sgi.com

Only use refcounted pages for I/O

Many block drivers (aoe, iscsi) really want refcountable pages in
bios, which is what almost everyone send down.  XFS unfortunately
has a few places where it sends down buffers that may come from
kmalloc, which breaks them.

Fix the places that use kmalloc()d buffers.

Signed-Off-By: Christoph Hellwig <hch@infradead.org>

Date:  Fri May 11 13:37:22 AEST 2007
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  dgc,tes

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:28562a
fs/xfs/xfs_log.c - 1.328 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_log.c.diff?r1=text&tr1=1.328&r2=text&tr2=1.327&f=h
	- Convert log buffers to use xfs_buf_get_noaddr rather
	  than using kmem_alloc()d buffers.

fs/xfs/linux-2.6/xfs_buf.h - 1.120 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_buf.h.diff?r1=text&tr1=1.120&r2=text&tr2=1.119&f=h
	- Use alloc_page() rather than kmem_alloc() for buffers that do not
	  use page cache backed pages.

fs/xfs/linux-2.6/xfs_buf.c - 1.236 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_buf.c.diff?r1=text&tr1=1.236&r2=text&tr2=1.235&f=h
	- Use alloc_page() rather than kmem_alloc() for buffers that do not
	  use page cache backed pages.
