Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 24 Sep 2008 02:11:58 -0700 (PDT)
Received: from relay.sgi.com (relay1.corp.sgi.com [192.26.58.214])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8O9BtZi013481
	for <xfs@oss.sgi.com>; Wed, 24 Sep 2008 02:11:56 -0700
Subject: TAKE 985583 - implement generic xfs_btree_delete/delrec
Message-Id: <20080924091322.AE60658C52AE@chook.melbourne.sgi.com>
Date: Wed, 24 Sep 2008 19:13:22 +1000 (EST)
From: lachlan@sgi.com (Lachlan McIlroy)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

implement generic xfs_btree_delete/delrec

Make the btree delete code generic.  Based on a patch from David Chinner
with lots of changes to follow the original btree implementations more
closely.  While this loses some of the generic helper routines for
inserting/moving/removing records it also solves some of the one off
bugs in the original code and makes it easier to verify.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Date:  Wed Sep 24 19:12:37 AEST 2008
Workarea:  redback.melbourne.sgi.com:/home/lachlan/isms/2.6.x-btree
Inspected by:  
dgc
billodo
lachlan
Author:  lachlan

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:32205a
fs/xfs/xfs_ialloc.c - 1.207 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_ialloc.c.diff?r1=text&tr1=1.207&r2=text&tr2=1.206&f=h
fs/xfs/xfs_ialloc_btree.h - 1.40 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_ialloc_btree.h.diff?r1=text&tr1=1.40&r2=text&tr2=1.39&f=h
fs/xfs/xfs_ialloc_btree.c - 1.104 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_ialloc_btree.c.diff?r1=text&tr1=1.104&r2=text&tr2=1.103&f=h
fs/xfs/xfs_bmap_btree.h - 1.89 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_bmap_btree.h.diff?r1=text&tr1=1.89&r2=text&tr2=1.88&f=h
fs/xfs/xfs_bmap_btree.c - 1.193 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_bmap_btree.c.diff?r1=text&tr1=1.193&r2=text&tr2=1.192&f=h
fs/xfs/xfs_btree.c - 1.139 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_btree.c.diff?r1=text&tr1=1.139&r2=text&tr2=1.138&f=h
fs/xfs/xfs_btree.h - 1.92 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_btree.h.diff?r1=text&tr1=1.92&r2=text&tr2=1.91&f=h
fs/xfs/xfs_alloc.c - 1.201 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_alloc.c.diff?r1=text&tr1=1.201&r2=text&tr2=1.200&f=h
fs/xfs/xfs_bmap.c - 1.409 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_bmap.c.diff?r1=text&tr1=1.409&r2=text&tr2=1.408&f=h
fs/xfs/xfs_alloc_btree.h - 1.37 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_alloc_btree.h.diff?r1=text&tr1=1.37&r2=text&tr2=1.36&f=h
fs/xfs/xfs_alloc_btree.c - 1.108 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_alloc_btree.c.diff?r1=text&tr1=1.108&r2=text&tr2=1.107&f=h
	- implement generic xfs_btree_delete/delrec
