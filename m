Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 24 Sep 2008 00:56:57 -0700 (PDT)
Received: from relay.sgi.com (relay2.corp.sgi.com [192.26.58.22])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8O7ut9Y003160
	for <xfs@oss.sgi.com>; Wed, 24 Sep 2008 00:56:55 -0700
Subject: TAKE 985583 - add helpers for addressing entities inside a btree block
Message-Id: <20080924075828.0B52E58C52AE@chook.melbourne.sgi.com>
Date: Wed, 24 Sep 2008 17:58:28 +1000 (EST)
From: lachlan@sgi.com (Lachlan McIlroy)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

add helpers for addressing entities inside a btree block

Add new helpers in xfs_btree.c to find the record, key and block pointer
entries inside a btree block.  To implement this genericly the ->get_maxrecs
methods and two new xfs_btree_ops entries for the key and record sizes are
used.  Also add a big comment describing how the addressing inside a btree
block works.

Note that these helpers are unused until users are introduced in the next
patches and this patch will thus cause some harmless compiler warnings.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Date:  Wed Sep 24 17:57:38 AEST 2008
Workarea:  redback.melbourne.sgi.com:/home/lachlan/isms/2.6.x-btree
Inspected by:  
dgc
billodo
lachlan
Author:  lachlan

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:32189a
fs/xfs/xfs_ialloc_btree.c - 1.92 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_ialloc_btree.c.diff?r1=text&tr1=1.92&r2=text&tr2=1.91&f=h
fs/xfs/xfs_bmap_btree.c - 1.181 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_bmap_btree.c.diff?r1=text&tr1=1.181&r2=text&tr2=1.180&f=h
fs/xfs/xfs_btree.c - 1.126 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_btree.c.diff?r1=text&tr1=1.126&r2=text&tr2=1.125&f=h
fs/xfs/xfs_btree.h - 1.79 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_btree.h.diff?r1=text&tr1=1.79&r2=text&tr2=1.78&f=h
fs/xfs/xfs_alloc_btree.c - 1.96 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_alloc_btree.c.diff?r1=text&tr1=1.96&r2=text&tr2=1.95&f=h
	- add helpers for addressing entities inside a btree block
