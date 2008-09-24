Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 24 Sep 2008 00:08:18 -0700 (PDT)
Received: from relay.sgi.com (relay1.corp.sgi.com [192.26.58.214])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8O78ENr023318
	for <xfs@oss.sgi.com>; Wed, 24 Sep 2008 00:08:14 -0700
Subject: PARTIAL TAKE 985583 - kill struct xfs_btree_hdr
Message-Id: <20080924070944.3000958C52AE@chook.melbourne.sgi.com>
Date: Wed, 24 Sep 2008 17:09:44 +1000 (EST)
From: lachlan@sgi.com (Lachlan McIlroy)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

kill struct xfs_btree_hdr

This type is only embedded in struct xfs_btree_block and never used
directly.  By moving the fields directly into struct xfs_btree_block
a lot of the macros for struct xfs_btree_sblock and struct xfs_btree_lblock
can be used for struct xfs_btree_block too now which helps greatly
with some of the migrations during implementing the generic btree code.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Date:  Wed Sep 24 17:08:26 AEST 2008
Workarea:  redback.melbourne.sgi.com:/home/lachlan/isms/2.6.x-btree
Inspected by:  
dgc
billodo
lachlan
Author:  lachlan

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:32174a
fs/xfs/xfs_btree.c - 1.119 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_btree.c.diff?r1=text&tr1=1.119&r2=text&tr2=1.118&f=h
fs/xfs/xfs_btree.h - 1.69 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_btree.h.diff?r1=text&tr1=1.69&r2=text&tr2=1.68&f=h
	- kill struct xfs_btree_hdr
