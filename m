Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 24 Sep 2008 01:01:42 -0700 (PDT)
Received: from relay.sgi.com (relay2.corp.sgi.com [192.26.58.22])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8O81dcP003902
	for <xfs@oss.sgi.com>; Wed, 24 Sep 2008 01:01:39 -0700
Subject: TAKE 985583 - implement generic xfs_btree_increment
Message-Id: <20080924080306.41F3358C52AE@chook.melbourne.sgi.com>
Date: Wed, 24 Sep 2008 18:03:06 +1000 (EST)
From: lachlan@sgi.com (Lachlan McIlroy)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

implement generic xfs_btree_increment

From: Dave Chinner <dgc@sgi.com>

Because this is the first major generic btree routine this patch
includes some infrastrucure, first a few routines to deal with
a btree block that can be either in short or long form, second
xfs_btree_read_buf_block, which is the new central routine to read
a btree block given a cursor, and third the new xfs_btree_ptr_addr
routine to calculate the address for a given btree pointer record.

[hch: split out from bigger patch and minor adaptions]

Signed-off-by: Christoph Hellwig <hch@lst.de>

Date:  Wed Sep 24 18:02:24 AEST 2008
Workarea:  redback.melbourne.sgi.com:/home/lachlan/isms/2.6.x-btree
Inspected by:  
dgc
billodo
lachlan
Author:  lachlan

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:32190a
fs/xfs/xfs_ialloc.c - 1.202 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_ialloc.c.diff?r1=text&tr1=1.202&r2=text&tr2=1.201&f=h
fs/xfs/xfs_itable.c - 1.172 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_itable.c.diff?r1=text&tr1=1.172&r2=text&tr2=1.171&f=h
fs/xfs/xfs_ialloc_btree.h - 1.35 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_ialloc_btree.h.diff?r1=text&tr1=1.35&r2=text&tr2=1.34&f=h
fs/xfs/xfs_ialloc_btree.c - 1.93 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_ialloc_btree.c.diff?r1=text&tr1=1.93&r2=text&tr2=1.92&f=h
fs/xfs/xfs_bmap_btree.h - 1.83 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_bmap_btree.h.diff?r1=text&tr1=1.83&r2=text&tr2=1.82&f=h
fs/xfs/xfs_bmap_btree.c - 1.182 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_bmap_btree.c.diff?r1=text&tr1=1.182&r2=text&tr2=1.181&f=h
fs/xfs/xfs_btree.c - 1.127 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_btree.c.diff?r1=text&tr1=1.127&r2=text&tr2=1.126&f=h
fs/xfs/xfs_btree.h - 1.80 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_btree.h.diff?r1=text&tr1=1.80&r2=text&tr2=1.79&f=h
fs/xfs/xfs_alloc.c - 1.196 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_alloc.c.diff?r1=text&tr1=1.196&r2=text&tr2=1.195&f=h
fs/xfs/xfs_bmap.c - 1.403 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_bmap.c.diff?r1=text&tr1=1.403&r2=text&tr2=1.402&f=h
fs/xfs/xfs_alloc_btree.h - 1.32 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_alloc_btree.h.diff?r1=text&tr1=1.32&r2=text&tr2=1.31&f=h
fs/xfs/xfs_alloc_btree.c - 1.97 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_alloc_btree.c.diff?r1=text&tr1=1.97&r2=text&tr2=1.96&f=h
	- implement generic xfs_btree_increment
