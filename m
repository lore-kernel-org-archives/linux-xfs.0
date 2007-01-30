Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 29 Jan 2007 16:59:41 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l0U0xWqw009195
	for <xfs@oss.sgi.com>; Mon, 29 Jan 2007 16:59:34 -0800
Subject: PARTIAL TAKE 960328 - Garbage found in a preallocated file on XFS
Message-Id: <20070130005829.9645D58FF492@chook.melbourne.sgi.com>
Date: Tue, 30 Jan 2007 11:58:29 +1100 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com, sgi.bugs.xfs@engr.sgi.com

Fix sub-block zeroing for buffered writes into unwritten extents.

When writing less than a filesystem block of data into an unwritten
extent via buffered I/O, __xfs_get_blocks fails to set the buffer
new flag. As a result, the generic code will not zero either edge
of the block resulting in garbage being written to disk either side
of the real data. Set the buffer new state on bufferd writes to
unwritten extents to ensure that zeroing occurs.

Date:  Tue Jan 30 11:57:42 AEDT 2007
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  lachlan

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:28000a
fs/xfs/linux-2.6/xfs_aops.c - 1.140 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_aops.c.diff?r1=text&tr1=1.140&r2=text&tr2=1.139&f=h
	- Set the buffer_new state when writing into unwritten extents so that
	  sub-block zeroing will occur for buffered writes if necessary.
