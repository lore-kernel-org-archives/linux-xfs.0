Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 24 Sep 2008 01:49:28 -0700 (PDT)
Received: from relay.sgi.com (relay1.corp.sgi.com [192.26.58.214])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8O8nPrv010583
	for <xfs@oss.sgi.com>; Wed, 24 Sep 2008 01:49:25 -0700
Subject: TAKE 985583 - move xfs_bmbt_newroot to common code
Message-Id: <20080924085058.C5E0A58C52AE@chook.melbourne.sgi.com>
Date: Wed, 24 Sep 2008 18:50:58 +1000 (EST)
From: lachlan@sgi.com (Lachlan McIlroy)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

move xfs_bmbt_newroot to common code

xfs_bmbt_newroot is a mostly generic implementation of moving from
an inode root to a real block based root.  So move it to xfs_btree.c
where it can use all the nice infrastructure there and make it pointer
size agnostic

The new name for it is xfs_btree_new_iroot, following the old naming
but making it clear we're dealing with the root in inode case here,
and to avoid confusion with xfs_btree_new_root which is used for the
not inode rooted case.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Date:  Wed Sep 24 18:50:17 AEST 2008
Workarea:  redback.melbourne.sgi.com:/home/lachlan/isms/2.6.x-btree
Inspected by:  
dgc
billodo
lachlan
Author:  lachlan

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:32201a
fs/xfs/xfs_bmap_btree.h - 1.87 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_bmap_btree.h.diff?r1=text&tr1=1.87&r2=text&tr2=1.86&f=h
fs/xfs/xfs_bmap_btree.c - 1.190 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_bmap_btree.c.diff?r1=text&tr1=1.190&r2=text&tr2=1.189&f=h
fs/xfs/xfs_btree.c - 1.136 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_btree.c.diff?r1=text&tr1=1.136&r2=text&tr2=1.135&f=h
fs/xfs/xfs_btree.h - 1.89 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_btree.h.diff?r1=text&tr1=1.89&r2=text&tr2=1.88&f=h
fs/xfs/xfs_bmap.c - 1.407 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_bmap.c.diff?r1=text&tr1=1.407&r2=text&tr2=1.406&f=h
	- move xfs_bmbt_newroot to common code
