Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 24 Sep 2008 00:27:56 -0700 (PDT)
Received: from relay.sgi.com (relay1.corp.sgi.com [192.26.58.214])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8O7Rohf030656
	for <xfs@oss.sgi.com>; Wed, 24 Sep 2008 00:27:50 -0700
Subject: TAKE 985583 - make btree root in inode support generic
Message-Id: <20080924072923.DEEC858C52AE@chook.melbourne.sgi.com>
Date: Wed, 24 Sep 2008 17:29:23 +1000 (EST)
From: lachlan@sgi.com (Lachlan McIlroy)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

make btree root in inode support generic

The bmap btree is rooted in the inode and not in a disk block.  Make the
support for this feature more generic by adding a btree flag to for this
feature instead of relying on the XFS_BTNUM_BMAP btnum check.

Also clean up xfs_btree_get_block where this new flag is used.

Based upon a patch from Dave Chinner.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Date:  Wed Sep 24 17:28:45 AEST 2008
Workarea:  redback.melbourne.sgi.com:/home/lachlan/isms/2.6.x-btree
Inspected by:  
dgc
billodo
lachlan
Author:  lachlan

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:32180a
fs/xfs/xfs_bmap_btree.c - 1.176 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_bmap_btree.c.diff?r1=text&tr1=1.176&r2=text&tr2=1.175&f=h
fs/xfs/xfs_btree.c - 1.121 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_btree.c.diff?r1=text&tr1=1.121&r2=text&tr2=1.120&f=h
fs/xfs/xfs_btree.h - 1.72 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_btree.h.diff?r1=text&tr1=1.72&r2=text&tr2=1.71&f=h
	- make btree root in inode support generic
