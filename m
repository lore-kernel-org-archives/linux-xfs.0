Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 24 Sep 2008 01:13:45 -0700 (PDT)
Received: from relay.sgi.com (netops-testserver-3.corp.sgi.com [192.26.57.72])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8O8Dc0i005317
	for <xfs@oss.sgi.com>; Wed, 24 Sep 2008 01:13:38 -0700
Subject: TAKE 985583 - implement generic xfs_btree_lookup
Message-Id: <20080924081501.8CBC558C52AE@chook.melbourne.sgi.com>
Date: Wed, 24 Sep 2008 18:15:01 +1000 (EST)
From: lachlan@sgi.com (Lachlan McIlroy)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

implement generic xfs_btree_lookup

From: Dave Chinner <dgc@sgi.com>

[hch: split out from bigger patch and minor adaptions]


Signed-off-by: Christoph Hellwig <hch@lst.de>

Date:  Wed Sep 24 18:14:13 AEST 2008
Workarea:  redback.melbourne.sgi.com:/home/lachlan/isms/2.6.x-btree
Inspected by:  
dgc
billodo
lachlan
Author:  lachlan

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:32192a
fs/xfs/xfs_ialloc.h - 1.49 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_ialloc.h.diff?r1=text&tr1=1.49&r2=text&tr2=1.48&f=h
fs/xfs/xfs_ialloc.c - 1.204 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_ialloc.c.diff?r1=text&tr1=1.204&r2=text&tr2=1.203&f=h
fs/xfs/xfs_ialloc_btree.h - 1.37 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_ialloc_btree.h.diff?r1=text&tr1=1.37&r2=text&tr2=1.36&f=h
fs/xfs/xfs_ialloc_btree.c - 1.95 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_ialloc_btree.c.diff?r1=text&tr1=1.95&r2=text&tr2=1.94&f=h
fs/xfs/xfs_bmap_btree.h - 1.85 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_bmap_btree.h.diff?r1=text&tr1=1.85&r2=text&tr2=1.84&f=h
fs/xfs/xfs_bmap_btree.c - 1.184 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_bmap_btree.c.diff?r1=text&tr1=1.184&r2=text&tr2=1.183&f=h
fs/xfs/xfs_btree.c - 1.129 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_btree.c.diff?r1=text&tr1=1.129&r2=text&tr2=1.128&f=h
fs/xfs/xfs_btree.h - 1.82 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_btree.h.diff?r1=text&tr1=1.82&r2=text&tr2=1.81&f=h
fs/xfs/xfs_alloc.c - 1.198 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_alloc.c.diff?r1=text&tr1=1.198&r2=text&tr2=1.197&f=h
fs/xfs/xfs_bmap.c - 1.405 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_bmap.c.diff?r1=text&tr1=1.405&r2=text&tr2=1.404&f=h
fs/xfs/xfs_alloc_btree.h - 1.34 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_alloc_btree.h.diff?r1=text&tr1=1.34&r2=text&tr2=1.33&f=h
fs/xfs/xfs_alloc_btree.c - 1.99 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_alloc_btree.c.diff?r1=text&tr1=1.99&r2=text&tr2=1.98&f=h
	- implement generic xfs_btree_lookup
