Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 24 Sep 2008 01:04:15 -0700 (PDT)
Received: from relay.sgi.com (relay2.corp.sgi.com [192.26.58.22])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8O84B92004294
	for <xfs@oss.sgi.com>; Wed, 24 Sep 2008 01:04:11 -0700
Subject: TAKE 985583 - implement generic xfs_btree_decrement
Message-Id: <20080924080544.6A50058C52AE@chook.melbourne.sgi.com>
Date: Wed, 24 Sep 2008 18:05:44 +1000 (EST)
From: lachlan@sgi.com (Lachlan McIlroy)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

implement generic xfs_btree_decrement

From: Dave Chinner <dgc@sgi.com>

[hch: split out from bigger patch and minor adaptions]

Signed-off-by: Christoph Hellwig <hch@lst.de>

Date:  Wed Sep 24 18:05:04 AEST 2008
Workarea:  redback.melbourne.sgi.com:/home/lachlan/isms/2.6.x-btree
Inspected by:  
dgc
billodo
lachlan
Author:  lachlan

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:32191a
fs/xfs/xfs_ialloc.c - 1.203 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_ialloc.c.diff?r1=text&tr1=1.203&r2=text&tr2=1.202&f=h
fs/xfs/xfs_ialloc_btree.h - 1.36 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_ialloc_btree.h.diff?r1=text&tr1=1.36&r2=text&tr2=1.35&f=h
fs/xfs/xfs_ialloc_btree.c - 1.94 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_ialloc_btree.c.diff?r1=text&tr1=1.94&r2=text&tr2=1.93&f=h
fs/xfs/xfs_bmap_btree.h - 1.84 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_bmap_btree.h.diff?r1=text&tr1=1.84&r2=text&tr2=1.83&f=h
fs/xfs/xfs_bmap_btree.c - 1.183 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_bmap_btree.c.diff?r1=text&tr1=1.183&r2=text&tr2=1.182&f=h
fs/xfs/xfs_btree.c - 1.128 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_btree.c.diff?r1=text&tr1=1.128&r2=text&tr2=1.127&f=h
fs/xfs/xfs_btree.h - 1.81 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_btree.h.diff?r1=text&tr1=1.81&r2=text&tr2=1.80&f=h
fs/xfs/xfs_alloc.c - 1.197 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_alloc.c.diff?r1=text&tr1=1.197&r2=text&tr2=1.196&f=h
fs/xfs/xfs_bmap.c - 1.404 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_bmap.c.diff?r1=text&tr1=1.404&r2=text&tr2=1.403&f=h
fs/xfs/xfs_alloc_btree.h - 1.33 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_alloc_btree.h.diff?r1=text&tr1=1.33&r2=text&tr2=1.32&f=h
fs/xfs/xfs_alloc_btree.c - 1.98 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_alloc_btree.c.diff?r1=text&tr1=1.98&r2=text&tr2=1.97&f=h
	- implement generic xfs_btree_decrement
