Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 02 Aug 2007 04:31:13 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l72BV6bm005809
	for <xfs@oss.sgi.com>; Thu, 2 Aug 2007 04:31:08 -0700
Subject: PARTIAL TAKE 968563 - clean up xfs_bmbt_set_all/xfs_bmbt_disk_set_all
Message-Id: <20070802111851.9603458F4B6D@chook.melbourne.sgi.com>
Date: Thu,  2 Aug 2007 21:18:51 +1000 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

clean up xfs_bmbt_set_all/xfs_bmbt_disk_set_all

xfs_bmbt_set_all/xfs_bmbt_disk_set_all are identical to
xfs_bmbt_set_allf/xfs_bmbt_disk_set_allf except that the former take
a xfs_bmbt_irec_t and the latter take the individual extent fields
as scalar values.

This patch reimplements xfs_bmbt_set_all/xfs_bmbt_disk_set_all as
trivial wrappers around xfs_bmbt_set_allf/xfs_bmbt_disk_set_allf and
cleans up the variable naming in xfs_bmbt_set_allf/xfs_bmbt_disk_set_allf
to have some meaning instead of one char variable names.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Date:  Thu Aug  2 21:18:19 AEST 2007
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  hch@lst.de

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:29319a
fs/xfs/xfs_bmap_btree.c - 1.164 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_bmap_btree.c.diff?r1=text&tr1=1.164&r2=text&tr2=1.163&f=h
	- Reimplement xfs_bmbt_set_all/xfs_bmbt_disk_set_all as trivial
	  wrappers around xfs_bmbt_set_allf/xfs_bmbt_disk_set_allf and
	  clean up variable naming.
