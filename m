Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 21 May 2007 16:32:44 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l4LNWYfB013251
	for <xfs@oss.sgi.com>; Mon, 21 May 2007 16:32:36 -0700
Subject: PARTIAL TAKE 964983 - vmalloc leak on mount/unmount
Message-Id: <20070521233229.B2A2758CA531@chook.melbourne.sgi.com>
Date: Tue, 22 May 2007 09:32:29 +1000 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com, sgi.bugs.xfs@engr.sgi.com

Fix double free in xfs_buf_get_noaddr error handling path

Signed-off-by: Christoph Hellwig <hch@lst.de>

Date:  Tue May 22 09:31:46 AEST 2007
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  hch@lst.de

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:28639a
fs/xfs/linux-2.6/xfs_buf.c - 1.238 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_buf.c.diff?r1=text&tr1=1.238&r2=text&tr2=1.237&f=h
	- Fix double free in xfs_buf_get_noaddr error handling path.
