Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 29 Jul 2008 00:08:39 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m6T78V0m024262
	for <xfs@oss.sgi.com>; Tue, 29 Jul 2008 00:08:32 -0700
Subject: PARTIAL TAKE 981498 - Use the same btree_cur union member for alloc and inobt trees.
Message-Id: <20080729070941.CE3C558C4C3F@chook.melbourne.sgi.com>
Date: Tue, 29 Jul 2008 17:09:41 +1000 (EST)
From: tes@sgi.com (Tim Shimmin)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com, sgi.bugs.xfs@engr.sgi.com

Use the same btree_cur union member for alloc and inobt trees.

The alloc and inobt btree use the same agbp/agno pair in the btree_cur
union.  Make them use the same bc_private.a union member so that code
for these two short form btree implementations can be shared.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Date:  Tue Jul 29 17:07:56 AEST 2008
Workarea:  chook.melbourne.sgi.com:/build/tes/2.6.x-xfs-quilt
Inspected by:  tes@sgi.com,david@fromorbit.com

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:31788a
fs/xfs/xfsidbg.c - 1.358 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfsidbg.c.diff?r1=text&tr1=1.358&r2=text&tr2=1.357&f=h
	- use the same btree_cur union member for alloc and inobt trees

fs/xfs/xfs_ialloc_btree.c - 1.87 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_ialloc_btree.c.diff?r1=text&tr1=1.87&r2=text&tr2=1.86&f=h
	- use the same btree_cur union member for alloc and inobt trees

fs/xfs/xfs_btree.c - 1.118 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_btree.c.diff?r1=text&tr1=1.118&r2=text&tr2=1.117&f=h
	- use the same btree_cur union member for alloc and inobt trees

fs/xfs/xfs_btree.h - 1.68 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_btree.h.diff?r1=text&tr1=1.68&r2=text&tr2=1.67&f=h
	- use the same btree_cur union member for alloc and inobt trees
