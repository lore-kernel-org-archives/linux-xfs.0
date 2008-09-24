Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 24 Sep 2008 01:51:42 -0700 (PDT)
Received: from relay.sgi.com (netops-testserver-3.corp.sgi.com [192.26.57.72])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8O8pdfU011053
	for <xfs@oss.sgi.com>; Wed, 24 Sep 2008 01:51:39 -0700
Subject: TAKE 985583 - implement generic xfs_btree_insert/insrec
Message-Id: <20080924085312.6EE1758C52AE@chook.melbourne.sgi.com>
Date: Wed, 24 Sep 2008 18:53:12 +1000 (EST)
From: lachlan@sgi.com (Lachlan McIlroy)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

implement generic xfs_btree_insert/insrec

Make the btree insert code generic.  Based on a patch from David Chinner
with lots of changes to follow the original btree implementations more
closely.  While this loses some of the generic helper routines for
inserting/moving/removing records it also solves some of the one off
bugs in the original code and makes it easier to verify.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Date:  Wed Sep 24 18:52:22 AEST 2008
Workarea:  redback.melbourne.sgi.com:/home/lachlan/isms/2.6.x-btree
Inspected by:  
dgc
billodo
lachlan
Author:  lachlan

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:32202a
fs/xfs/xfs_ialloc.c - 1.206 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_ialloc.c.diff?r1=text&tr1=1.206&r2=text&tr2=1.205&f=h
fs/xfs/xfs_ialloc_btree.h - 1.39 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_ialloc_btree.h.diff?r1=text&tr1=1.39&r2=text&tr2=1.38&f=h
fs/xfs/xfs_ialloc_btree.c - 1.102 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_ialloc_btree.c.diff?r1=text&tr1=1.102&r2=text&tr2=1.101&f=h
fs/xfs/xfs_bmap_btree.h - 1.88 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_bmap_btree.h.diff?r1=text&tr1=1.88&r2=text&tr2=1.87&f=h
fs/xfs/xfs_bmap_btree.c - 1.191 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_bmap_btree.c.diff?r1=text&tr1=1.191&r2=text&tr2=1.190&f=h
fs/xfs/xfs_btree.c - 1.137 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_btree.c.diff?r1=text&tr1=1.137&r2=text&tr2=1.136&f=h
fs/xfs/xfs_btree.h - 1.90 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_btree.h.diff?r1=text&tr1=1.90&r2=text&tr2=1.89&f=h
fs/xfs/xfs_alloc.c - 1.200 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_alloc.c.diff?r1=text&tr1=1.200&r2=text&tr2=1.199&f=h
fs/xfs/xfs_bmap.c - 1.408 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_bmap.c.diff?r1=text&tr1=1.408&r2=text&tr2=1.407&f=h
fs/xfs/xfs_alloc_btree.h - 1.36 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_alloc_btree.h.diff?r1=text&tr1=1.36&r2=text&tr2=1.35&f=h
fs/xfs/xfs_alloc_btree.c - 1.106 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_alloc_btree.c.diff?r1=text&tr1=1.106&r2=text&tr2=1.105&f=h
	- implement generic xfs_btree_insert/insrec
