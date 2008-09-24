Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 24 Sep 2008 01:27:06 -0700 (PDT)
Received: from relay.sgi.com (relay1.corp.sgi.com [192.26.58.214])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8O8R3eZ007397
	for <xfs@oss.sgi.com>; Wed, 24 Sep 2008 01:27:03 -0700
Subject: TAKE 985583 - implement generic xfs_btree_rshift
Message-Id: <20080924082836.9D19858C52AE@chook.melbourne.sgi.com>
Date: Wed, 24 Sep 2008 18:28:36 +1000 (EST)
From: lachlan@sgi.com (Lachlan McIlroy)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

implement generic xfs_btree_rshift

Make the btree right shift code generic.  Based on a patch from David Chinner
with lots of changes to follow the original btree implementations more
closely.  While this loses some of the generic helper routines for
inserting/moving/removing records it also solves some of the one off
bugs in the original code and makes it easier to verify.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Date:  Wed Sep 24 18:27:55 AEST 2008
Workarea:  redback.melbourne.sgi.com:/home/lachlan/isms/2.6.x-btree
Inspected by:  
dgc
billodo
lachlan
Author:  lachlan

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:32196a
fs/xfs/xfs_ialloc_btree.c - 1.98 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_ialloc_btree.c.diff?r1=text&tr1=1.98&r2=text&tr2=1.97&f=h
fs/xfs/xfs_bmap_btree.c - 1.187 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_bmap_btree.c.diff?r1=text&tr1=1.187&r2=text&tr2=1.186&f=h
fs/xfs/xfs_btree.c - 1.132 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_btree.c.diff?r1=text&tr1=1.132&r2=text&tr2=1.131&f=h
fs/xfs/xfs_btree.h - 1.85 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_btree.h.diff?r1=text&tr1=1.85&r2=text&tr2=1.84&f=h
fs/xfs/xfs_alloc_btree.c - 1.102 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_alloc_btree.c.diff?r1=text&tr1=1.102&r2=text&tr2=1.101&f=h
	- implement generic xfs_btree_rshift
