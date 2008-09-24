Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 24 Sep 2008 02:22:39 -0700 (PDT)
Received: from relay.sgi.com (netops-testserver-3.corp.sgi.com [192.26.57.72])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8O9MaSp015626
	for <xfs@oss.sgi.com>; Wed, 24 Sep 2008 02:22:36 -0700
Subject: TAKE 985583 - mark various functions in xfs_btree.c static
Message-Id: <20080924092409.77C6058C52AE@chook.melbourne.sgi.com>
Date: Wed, 24 Sep 2008 19:24:09 +1000 (EST)
From: lachlan@sgi.com (Lachlan McIlroy)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

mark various functions in xfs_btree.c static

Lots of functionality in xfs_btree.c isn't needed by callers outside of
this file anymore, so mark these functions static.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Date:  Wed Sep 24 19:23:23 AEST 2008
Workarea:  redback.melbourne.sgi.com:/home/lachlan/isms/2.6.x-btree
Inspected by:  
dgc
billodo
lachlan
Author:  lachlan

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:32209a
fs/xfs/xfs_btree.c - 1.143 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_btree.c.diff?r1=text&tr1=1.143&r2=text&tr2=1.142&f=h
fs/xfs/xfs_btree.h - 1.96 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_btree.h.diff?r1=text&tr1=1.96&r2=text&tr2=1.95&f=h
	- mark various functions in xfs_btree.c static
