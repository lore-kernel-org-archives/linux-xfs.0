Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 24 Sep 2008 00:42:33 -0700 (PDT)
Received: from relay.sgi.com (relay1.corp.sgi.com [192.26.58.214])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8O7gU2o000613
	for <xfs@oss.sgi.com>; Wed, 24 Sep 2008 00:42:30 -0700
Subject: TAKE 985583 - add new btree statistics
Message-Id: <20080924074403.1B50458C52AE@chook.melbourne.sgi.com>
Date: Wed, 24 Sep 2008 17:44:03 +1000 (EST)
From: lachlan@sgi.com (Lachlan McIlroy)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

add new btree statistics

From: Dave Chinner <dgc@sgi.com>

Introduce statistics coverage of all the btrees and cover
all the btree operations, not just some.

Invaluable for determining test code coverage of all the btree
operations....


Signed-off-by: Dave Chinner <dgc@sgi.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>

Date:  Wed Sep 24 17:43:27 AEST 2008
Workarea:  redback.melbourne.sgi.com:/home/lachlan/isms/2.6.x-btree
Inspected by:  
dgc
billodo
lachlan
Author:  lachlan

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:32184a
fs/xfs/xfs_btree.h - 1.76 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_btree.h.diff?r1=text&tr1=1.76&r2=text&tr2=1.75&f=h
fs/xfs/linux-2.6/xfs_stats.c - 1.27 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_stats.c.diff?r1=text&tr1=1.27&r2=text&tr2=1.26&f=h
fs/xfs/linux-2.6/xfs_stats.h - 1.20 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_stats.h.diff?r1=text&tr1=1.20&r2=text&tr2=1.19&f=h
	- add new btree statistics
