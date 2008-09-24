Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 24 Sep 2008 00:54:11 -0700 (PDT)
Received: from relay.sgi.com (relay1.corp.sgi.com [192.26.58.214])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8O7s8qg002648
	for <xfs@oss.sgi.com>; Wed, 24 Sep 2008 00:54:08 -0700
Subject: TAKE 985583 - add get_maxrecs btree operation
Message-Id: <20080924075541.5DF8258C52AE@chook.melbourne.sgi.com>
Date: Wed, 24 Sep 2008 17:55:41 +1000 (EST)
From: lachlan@sgi.com (Lachlan McIlroy)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

add get_maxrecs btree operation

Factor xfs_btree_maxrecs into a per-btree operation.

The get_maxrecs method is based on a patch from Dave Chinner.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Date:  Wed Sep 24 17:54:59 AEST 2008
Workarea:  redback.melbourne.sgi.com:/home/lachlan/isms/2.6.x-btree
Inspected by:  
dgc
billodo
lachlan
Author:  lachlan

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:32188a
fs/xfs/xfs_ialloc_btree.c - 1.91 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_ialloc_btree.c.diff?r1=text&tr1=1.91&r2=text&tr2=1.90&f=h
fs/xfs/xfs_bmap_btree.c - 1.180 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_bmap_btree.c.diff?r1=text&tr1=1.180&r2=text&tr2=1.179&f=h
fs/xfs/xfs_btree.c - 1.125 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_btree.c.diff?r1=text&tr1=1.125&r2=text&tr2=1.124&f=h
fs/xfs/xfs_btree.h - 1.78 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_btree.h.diff?r1=text&tr1=1.78&r2=text&tr2=1.77&f=h
fs/xfs/xfs_alloc_btree.c - 1.95 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_alloc_btree.c.diff?r1=text&tr1=1.95&r2=text&tr2=1.94&f=h
	- add get_maxrecs btree operation
