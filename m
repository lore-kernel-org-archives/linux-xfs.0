Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 19 Jun 2007 22:49:07 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l5K5n1do003256
	for <xfs@oss.sgi.com>; Tue, 19 Jun 2007 22:49:04 -0700
Subject: TAKE 966562 - XFS should not be looking at filp reference counts
Message-Id: <20070620054858.99AD658C38F1@chook.melbourne.sgi.com>
Date: Wed, 20 Jun 2007 15:48:58 +1000 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

XFS should not be looking at filp reference counts

A check for file_count is always a bad idea.  Linux has the ->release
method to deal with cleanups on last close and ->flush is only for the
very rare case where we want to perform an operation on every drop of
a reference to a file struct.

This patch gets rid of vop_close and surrounding code in favour of
simply doing the page flushing from ->release.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Date:  Wed Jun 20 15:48:18 AEST 2007
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  hch@lst.de

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:28952a
fs/xfs/xfs_vnodeops.c - 1.700 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_vnodeops.c.diff?r1=text&tr1=1.700&r2=text&tr2=1.699&f=h
	- Move the functionality in xfs_close to xfs_release and
	  remove xfs_close.

fs/xfs/linux-2.6/xfs_file.c - 1.149 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_file.c.diff?r1=text&tr1=1.149&r2=text&tr2=1.148&f=h
	- Kill xfs_file_flush as xfs_file_release provides us with
	  the required last-close callout.

fs/xfs/linux-2.6/xfs_vnode.h - 1.128 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_vnode.h.diff?r1=text&tr1=1.128&r2=text&tr2=1.127&f=h
	- Remove the last close vop call as it is no longer needed.
