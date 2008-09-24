Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 24 Sep 2008 00:33:29 -0700 (PDT)
Received: from relay.sgi.com (relay1.corp.sgi.com [192.26.58.214])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8O7XPVe031594
	for <xfs@oss.sgi.com>; Wed, 24 Sep 2008 00:33:25 -0700
Subject: TAKE 985583 - add a long pointers flag to xfs_btree_cur
Message-Id: <20080924073458.9A07658C52AE@chook.melbourne.sgi.com>
Date: Wed, 24 Sep 2008 17:34:58 +1000 (EST)
From: lachlan@sgi.com (Lachlan McIlroy)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

add a long pointers flag to xfs_btree_cur

Add a flag to the xfs btree cursor when using long (64bit) block pointers
instead of checking btnum == XFS_BTNUM_BMAP.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Date:  Wed Sep 24 17:34:19 AEST 2008
Workarea:  redback.melbourne.sgi.com:/home/lachlan/isms/2.6.x-btree
Inspected by:  
dgc
billodo
lachlan
Author:  lachlan

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:32181a
fs/xfs/xfs_bmap_btree.c - 1.177 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_bmap_btree.c.diff?r1=text&tr1=1.177&r2=text&tr2=1.176&f=h
fs/xfs/xfs_btree.c - 1.122 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_btree.c.diff?r1=text&tr1=1.122&r2=text&tr2=1.121&f=h
fs/xfs/xfs_btree.h - 1.73 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_btree.h.diff?r1=text&tr1=1.73&r2=text&tr2=1.72&f=h
	- add a long pointers flag to xfs_btree_cur
