Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 29 Jul 2008 00:02:30 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m6T72IGF023500
	for <xfs@oss.sgi.com>; Tue, 29 Jul 2008 00:02:19 -0700
Subject: PARTIAL TAKE 981498 - small cleanups in xfs_btree.c
Message-Id: <20080729070327.729BD58C4C3F@chook.melbourne.sgi.com>
Date: Tue, 29 Jul 2008 17:03:27 +1000 (EST)
From: tes@sgi.com (Tim Shimmin)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

small cleanups in xfs_btree.c

Remove unneeded xfs_btree_get_block forward declaration.
Move xfs_btree_firstrec next to xfs_btree_lastrec.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Date:  Tue Jul 29 17:02:19 AEST 2008
Workarea:  chook.melbourne.sgi.com:/build/tes/2.6.x-xfs-quilt
Inspected by:  tes@sgi.com,david@fromorbit.com

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:31787a
fs/xfs/xfs_btree.c - 1.117 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_btree.c.diff?r1=text&tr1=1.117&r2=text&tr2=1.116&f=h
	- - remove unneeded xfs_btree_get_block forward declaration
	  - move xfs_btree_firstrec next to xfs_btree_lastrec
