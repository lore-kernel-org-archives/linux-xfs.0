Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 24 Sep 2008 02:20:40 -0700 (PDT)
Received: from relay.sgi.com (relay2.corp.sgi.com [192.26.58.22])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8O9Kcpo015234
	for <xfs@oss.sgi.com>; Wed, 24 Sep 2008 02:20:38 -0700
Subject: TAKE 985583 - add keys_inorder and recs_inorder btree methods
Message-Id: <20080924092211.A2A6858C52AE@chook.melbourne.sgi.com>
Date: Wed, 24 Sep 2008 19:22:11 +1000 (EST)
From: lachlan@sgi.com (Lachlan McIlroy)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

add keys_inorder and recs_inorder btree methods

Add methods to check whether two keys/records are in the righ order.  This
replaces the xfs_btree_check_key and xfs_btree_check_rec methods.  For the
callers from xfs_bmap.c just opencode the bmbt-specific asserts.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Date:  Wed Sep 24 19:21:33 AEST 2008
Workarea:  redback.melbourne.sgi.com:/home/lachlan/isms/2.6.x-btree
Inspected by:  
dgc
billodo
lachlan
Author:  lachlan

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:32208a
fs/xfs/xfs_ialloc_btree.c - 1.106 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_ialloc_btree.c.diff?r1=text&tr1=1.106&r2=text&tr2=1.105&f=h
fs/xfs/xfs_bmap_btree.c - 1.195 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_bmap_btree.c.diff?r1=text&tr1=1.195&r2=text&tr2=1.194&f=h
fs/xfs/xfs_btree.c - 1.142 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_btree.c.diff?r1=text&tr1=1.142&r2=text&tr2=1.141&f=h
fs/xfs/xfs_btree.h - 1.95 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_btree.h.diff?r1=text&tr1=1.95&r2=text&tr2=1.94&f=h
fs/xfs/xfs_bmap.c - 1.411 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_bmap.c.diff?r1=text&tr1=1.411&r2=text&tr2=1.410&f=h
fs/xfs/xfs_alloc_btree.c - 1.110 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_alloc_btree.c.diff?r1=text&tr1=1.110&r2=text&tr2=1.109&f=h
	- add keys_inorder and recs_inorder btree methods
