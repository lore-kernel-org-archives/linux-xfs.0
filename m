Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 24 Sep 2008 01:46:20 -0700 (PDT)
Received: from relay.sgi.com (relay1.corp.sgi.com [192.26.58.214])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8O8kIk7010046
	for <xfs@oss.sgi.com>; Wed, 24 Sep 2008 01:46:18 -0700
Subject: TAKE 985583 - implement semi-generic xfs_btree_new_root
Message-Id: <20080924084751.8887058C52AE@chook.melbourne.sgi.com>
Date: Wed, 24 Sep 2008 18:47:51 +1000 (EST)
From: lachlan@sgi.com (Lachlan McIlroy)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

implement semi-generic xfs_btree_new_root

From: Dave Chinner <dgc@sgi.com>

Add a xfs_btree_new_root helper for the alloc and ialloc btrees.  The bmap
btree needs it's own version and is not converted.

[hch: split out from bigger patch and minor adaptions]


Signed-off-by: Christoph Hellwig <hch@lst.de>

Date:  Wed Sep 24 18:47:15 AEST 2008
Workarea:  redback.melbourne.sgi.com:/home/lachlan/isms/2.6.x-btree
Inspected by:  
dgc
billodo
lachlan
Author:  lachlan

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:32200a
fs/xfs/xfs_ialloc_btree.c - 1.101 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_ialloc_btree.c.diff?r1=text&tr1=1.101&r2=text&tr2=1.100&f=h
fs/xfs/xfs_btree.c - 1.135 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_btree.c.diff?r1=text&tr1=1.135&r2=text&tr2=1.134&f=h
fs/xfs/xfs_btree.h - 1.88 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_btree.h.diff?r1=text&tr1=1.88&r2=text&tr2=1.87&f=h
fs/xfs/xfs_alloc_btree.c - 1.105 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_alloc_btree.c.diff?r1=text&tr1=1.105&r2=text&tr2=1.104&f=h
	- implement semi-generic xfs_btree_new_root
