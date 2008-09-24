Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 24 Sep 2008 02:14:13 -0700 (PDT)
Received: from relay.sgi.com (relay2.corp.sgi.com [192.26.58.22])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8O9E3ld014066
	for <xfs@oss.sgi.com>; Wed, 24 Sep 2008 02:14:03 -0700
Subject: TAKE 985583 - implement generic xfs_btree_get_rec
Message-Id: <20080924091536.0883458C52AE@chook.melbourne.sgi.com>
Date: Wed, 24 Sep 2008 19:15:36 +1000 (EST)
From: lachlan@sgi.com (Lachlan McIlroy)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

implement generic xfs_btree_get_rec

Not really much reason to make it generic given that it's so small,
but this is the last non-method in xfs_alloc_btree.c and xfs_ialloc_btree.c,
so it makes the whole btree implementation more structured.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Date:  Wed Sep 24 19:14:55 AEST 2008
Workarea:  redback.melbourne.sgi.com:/home/lachlan/isms/2.6.x-btree
Inspected by:  
dgc
billodo
lachlan
Author:  lachlan

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:32206a
fs/xfs/xfs_ialloc.h - 1.50 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_ialloc.h.diff?r1=text&tr1=1.50&r2=text&tr2=1.49&f=h
fs/xfs/xfs_ialloc.c - 1.208 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_ialloc.c.diff?r1=text&tr1=1.208&r2=text&tr2=1.207&f=h
fs/xfs/xfs_ialloc_btree.h - 1.41 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_ialloc_btree.h.diff?r1=text&tr1=1.41&r2=text&tr2=1.40&f=h
fs/xfs/xfs_ialloc_btree.c - 1.105 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_ialloc_btree.c.diff?r1=text&tr1=1.105&r2=text&tr2=1.104&f=h
fs/xfs/xfs_btree.c - 1.140 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_btree.c.diff?r1=text&tr1=1.140&r2=text&tr2=1.139&f=h
fs/xfs/xfs_btree.h - 1.93 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_btree.h.diff?r1=text&tr1=1.93&r2=text&tr2=1.92&f=h
fs/xfs/xfs_alloc.c - 1.202 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_alloc.c.diff?r1=text&tr1=1.202&r2=text&tr2=1.201&f=h
fs/xfs/xfs_alloc_btree.h - 1.38 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_alloc_btree.h.diff?r1=text&tr1=1.38&r2=text&tr2=1.37&f=h
fs/xfs/xfs_alloc_btree.c - 1.109 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_alloc_btree.c.diff?r1=text&tr1=1.109&r2=text&tr2=1.108&f=h
	- implement generic xfs_btree_get_rec
