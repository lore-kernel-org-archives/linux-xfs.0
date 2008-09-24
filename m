Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 24 Sep 2008 02:09:39 -0700 (PDT)
Received: from relay.sgi.com (relay2.corp.sgi.com [192.26.58.22])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8O99aKn013049
	for <xfs@oss.sgi.com>; Wed, 24 Sep 2008 02:09:36 -0700
Subject: TAKE 985583 - move xfs_bmbt_killroot to common code
Message-Id: <20080924091102.BE4E558C52AE@chook.melbourne.sgi.com>
Date: Wed, 24 Sep 2008 19:11:02 +1000 (EST)
From: lachlan@sgi.com (Lachlan McIlroy)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

move xfs_bmbt_killroot to common code

xfs_bmbt_killroot is a mostly generic implementation of moving from
a real block based root to an inode based root.  So move it to xfs_btree.c
where it can use all the nice infrastructure there and make it pointer
size agnostic

The new name for it is xfs_btree_kill_iroot, following the old naming
but making it clear we're dealing with the root in inode case here,
and to avoid confusion with xfs_btree_new_root which is used for the
not inode rooted case.  I've also added a comment describing what it does
and why it's named the way it is.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Date:  Wed Sep 24 19:10:22 AEST 2008
Workarea:  redback.melbourne.sgi.com:/home/lachlan/isms/2.6.x-btree
Inspected by:  
dgc
billodo
lachlan
Author:  lachlan

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:32203a
fs/xfs/xfs_ialloc_btree.c - 1.103 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_ialloc_btree.c.diff?r1=text&tr1=1.103&r2=text&tr2=1.102&f=h
fs/xfs/xfs_bmap_btree.c - 1.192 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_bmap_btree.c.diff?r1=text&tr1=1.192&r2=text&tr2=1.191&f=h
fs/xfs/xfs_btree.c - 1.138 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_btree.c.diff?r1=text&tr1=1.138&r2=text&tr2=1.137&f=h
fs/xfs/xfs_btree.h - 1.91 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_btree.h.diff?r1=text&tr1=1.91&r2=text&tr2=1.90&f=h
fs/xfs/xfs_alloc_btree.c - 1.107 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_alloc_btree.c.diff?r1=text&tr1=1.107&r2=text&tr2=1.106&f=h
	- move xfs_bmbt_killroot to common code
