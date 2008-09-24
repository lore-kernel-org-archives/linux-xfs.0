Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 24 Sep 2008 01:19:15 -0700 (PDT)
Received: from relay.sgi.com (relay1.corp.sgi.com [192.26.58.214])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8O8JCi8006425
	for <xfs@oss.sgi.com>; Wed, 24 Sep 2008 01:19:12 -0700
Subject: TAKE 985583 - implement generic xfs_btree_updkey
Message-Id: <20080924082042.8659858C52AE@chook.melbourne.sgi.com>
Date: Wed, 24 Sep 2008 18:20:42 +1000 (EST)
From: lachlan@sgi.com (Lachlan McIlroy)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

implement generic xfs_btree_updkey

From: Dave Chinner <dgc@sgi.com>

Note that there are many > 80 char lines introduced due to the
xfs_btree_key casts.  But the places where this happens is throw-away
code once the whole btree code gets merged into a common implementation.

The same is true for the temporary xfs_alloc_log_keys define to the new
name.  All old users will be gone after a few patches.


[hch: split out from bigger patch and minor adaptions]

Signed-off-by: Christoph Hellwig <hch@lst.de>

Date:  Wed Sep 24 18:20:00 AEST 2008
Workarea:  redback.melbourne.sgi.com:/home/lachlan/isms/2.6.x-btree
Inspected by:  
dgc
billodo
lachlan
Author:  lachlan

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:32193a
fs/xfs/xfs_ialloc_btree.c - 1.96 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_ialloc_btree.c.diff?r1=text&tr1=1.96&r2=text&tr2=1.95&f=h
fs/xfs/xfs_bmap_btree.c - 1.185 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_bmap_btree.c.diff?r1=text&tr1=1.185&r2=text&tr2=1.184&f=h
fs/xfs/xfs_btree.c - 1.130 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_btree.c.diff?r1=text&tr1=1.130&r2=text&tr2=1.129&f=h
fs/xfs/xfs_btree.h - 1.83 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_btree.h.diff?r1=text&tr1=1.83&r2=text&tr2=1.82&f=h
fs/xfs/xfs_alloc_btree.c - 1.100 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_alloc_btree.c.diff?r1=text&tr1=1.100&r2=text&tr2=1.99&f=h
	- implement generic xfs_btree_updkey
