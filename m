Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 10 Sep 2007 21:33:04 -0700 (PDT)
Received: from redback.melbourne.sgi.com (redback.melbourne.sgi.com [134.14.55.78])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l8B4Wu4p015119
	for <xfs@oss.sgi.com>; Mon, 10 Sep 2007 21:32:58 -0700
Date: Tue, 11 Sep 2007 14:35:38 +1000
From: Lachlan McIlroy <lachlan@redback.melbourne.sgi.com>
Message-Id: <200709110435.l8B4Zcv2012121@redback.melbourne.sgi.com>
Subject: TAKE 970334 - ensure file size is logged on synchronous writes
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

ensure file size is logged on synchronous writes

Synchronous writes currently log inode changes before syncing
pages to disk.  Since the file size is updated on I/O completion
we wont be writing out the updated file size and if we crash the
file will have the wrong size.  This change moves the logging
after the syncing of the pages to ensure we log the correct file
size.


Date:  Tue Sep 11 14:31:23 AEST 2007
Workarea:  redback.melbourne.sgi.com:/home/lachlan/isms/2.6.x-xfs
Inspected by:  Christoph Hellwig <hch@infradead.org>

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:29649a
fs/xfs/linux-2.6/xfs_lrw.c - 1.267 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_lrw.c.diff?r1=text&tr1=1.267&r2=text&tr2=1.266&f=h
	- ensure file size is logged on synchronous writes
