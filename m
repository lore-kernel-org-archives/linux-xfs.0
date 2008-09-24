Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 24 Sep 2008 00:37:26 -0700 (PDT)
Received: from relay.sgi.com (relay2.corp.sgi.com [192.26.58.22])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8O7bMRK032151
	for <xfs@oss.sgi.com>; Wed, 24 Sep 2008 00:37:23 -0700
Subject: TAKE 985583 - refactor xfs_btree_readahead
Message-Id: <20080924073852.C485058C52AE@chook.melbourne.sgi.com>
Date: Wed, 24 Sep 2008 17:38:52 +1000 (EST)
From: lachlan@sgi.com (Lachlan McIlroy)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

refactor xfs_btree_readahead

From: Dave Chinner <dgc@sgi.com>

Refactor xfs_btree_readahead to make it more readable:

 (a) remove the inline xfs_btree_readahead wrapper and move all checks out
     of line into the main routine.
 (b) factor out helpers for short/long form btrees
 (c) move check for root in inodes from the callers into xfs_btree_readahead


[hch: split out from a big patch and minor cleanups]


Signed-off-by: Christoph Hellwig <hch@lst.de>

Date:  Wed Sep 24 17:38:14 AEST 2008
Workarea:  redback.melbourne.sgi.com:/home/lachlan/isms/2.6.x-btree
Inspected by:  
dgc
billodo
lachlan
Author:  lachlan

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:32182a
fs/xfs/xfs_bmap_btree.c - 1.178 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_bmap_btree.c.diff?r1=text&tr1=1.178&r2=text&tr2=1.177&f=h
fs/xfs/xfs_btree.c - 1.123 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_btree.c.diff?r1=text&tr1=1.123&r2=text&tr2=1.122&f=h
fs/xfs/xfs_btree.h - 1.74 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_btree.h.diff?r1=text&tr1=1.74&r2=text&tr2=1.73&f=h
	- refactor xfs_btree_readahead
