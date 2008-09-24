Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 24 Sep 2008 00:17:18 -0700 (PDT)
Received: from relay.sgi.com (netops-testserver-3.corp.sgi.com [192.26.57.72])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8O7HGac024468
	for <xfs@oss.sgi.com>; Wed, 24 Sep 2008 00:17:16 -0700
Subject: TAKE 985583 - split up xfs_btree_init_cursor
Message-Id: <20080924071843.6504958C52AE@chook.melbourne.sgi.com>
Date: Wed, 24 Sep 2008 17:18:43 +1000 (EST)
From: lachlan@sgi.com (Lachlan McIlroy)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

split up xfs_btree_init_cursor

xfs_btree_init_cursor contains close to little shared code for the different
btrees and will get even more non-common code in the future.  Split it up
into one routine per btree type.

Because xfs_btree_dup_cursor needs to call the init routine for a generic
btree cursor add a new btree operation vector that contains a dup_cursor
method that initializes a new cursor based on an existing one.

The btree operations vector is based on an idea and code from Dave Chinner
and will grow more entries later during this series.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Date:  Wed Sep 24 17:14:52 AEST 2008
Workarea:  redback.melbourne.sgi.com:/home/lachlan/isms/2.6.x-btree
Inspected by:  
dgc
billodo
lachlan
Author:  lachlan

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:32176a
fs/xfs/xfs_ialloc.c - 1.201 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_ialloc.c.diff?r1=text&tr1=1.201&r2=text&tr2=1.200&f=h
fs/xfs/xfs_itable.c - 1.171 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_itable.c.diff?r1=text&tr1=1.171&r2=text&tr2=1.170&f=h
fs/xfs/xfs_ialloc_btree.h - 1.34 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_ialloc_btree.h.diff?r1=text&tr1=1.34&r2=text&tr2=1.33&f=h
fs/xfs/xfs_ialloc_btree.c - 1.89 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_ialloc_btree.c.diff?r1=text&tr1=1.89&r2=text&tr2=1.88&f=h
fs/xfs/xfs_bmap_btree.h - 1.81 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_bmap_btree.h.diff?r1=text&tr1=1.81&r2=text&tr2=1.80&f=h
fs/xfs/xfs_bmap_btree.c - 1.175 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_bmap_btree.c.diff?r1=text&tr1=1.175&r2=text&tr2=1.174&f=h
fs/xfs/xfs_btree.c - 1.120 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_btree.c.diff?r1=text&tr1=1.120&r2=text&tr2=1.119&f=h
fs/xfs/xfs_btree.h - 1.70 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_btree.h.diff?r1=text&tr1=1.70&r2=text&tr2=1.69&f=h
fs/xfs/xfs_alloc.c - 1.195 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_alloc.c.diff?r1=text&tr1=1.195&r2=text&tr2=1.194&f=h
fs/xfs/xfs_bmap.c - 1.402 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_bmap.c.diff?r1=text&tr1=1.402&r2=text&tr2=1.401&f=h
fs/xfs/xfs_alloc_btree.h - 1.31 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_alloc_btree.h.diff?r1=text&tr1=1.31&r2=text&tr2=1.30&f=h
fs/xfs/xfs_alloc_btree.c - 1.93 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_alloc_btree.c.diff?r1=text&tr1=1.93&r2=text&tr2=1.92&f=h
	- split up xfs_btree_init_cursor
