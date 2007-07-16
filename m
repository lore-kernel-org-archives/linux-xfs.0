Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 16 Jul 2007 00:32:34 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l6G7WTbm014234
	for <xfs@oss.sgi.com>; Mon, 16 Jul 2007 00:32:31 -0700
Subject: PARTIAL TAKE 940392 - unwritten extents aren't converted when modified through mmap
Message-Id: <20070716073228.4180958C38F1@chook.melbourne.sgi.com>
Date: Mon, 16 Jul 2007 17:32:28 +1000 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Date:  Mon Jul 16 17:28:48 AEST 2007
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  hch@lst.de

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  2.6.x-xfs-melb:linux:29146a
fs/buffer.c - 1.30 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.6-xfs/fs/buffer.c.diff?r1=text&tr1=1.30&r2=text&tr2=1.29&f=h
	- Implement block_page_mkwrite.
	  Many filesystems need a ->page-mkwrite callout to correctly
	  set up pages that have been written to by mmap. This is especially
	  important when mmap is writing into holes as it allows filesystems
	  to correctly account for and allocate space before the mmap
	  write is allowed to proceed.
	  Protection against truncate races is provided by locking the page
	  and checking to see whether the page mapping is correct and whether
	  it is beyond EOF so we don't end up allowing allocations beyond
	  the current EOF or changing EOF as a result of a mmap write.

include/linux/buffer_head.h - 1.18 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.6-xfs/include/linux/buffer_head.h.diff?r1=text&tr1=1.18&r2=text&tr2=1.17&f=h
	- Implement block_page_mkwrite.
