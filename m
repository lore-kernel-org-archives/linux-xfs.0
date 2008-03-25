Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 24 Mar 2008 23:45:05 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m2P6isZQ009840
	for <xfs@oss.sgi.com>; Mon, 24 Mar 2008 23:44:56 -0700
Subject: PARTIAL TAKE 976035 - cleanup root inode handling in xfs_fs_fill_super
Message-Id: <20080325064522.9A7BD58C4C0F@chook.melbourne.sgi.com>
Date: Tue, 25 Mar 2008 17:45:22 +1100 (EST)
From: lachlan@sgi.com (Lachlan McIlroy)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

cleanup root inode handling in xfs_fs_fill_super

 - rename rootvp to root for clarify
 - remove useless vn_to_inode call
 - check is_bad_inode before calling d_alloc_root
 - use iput instead of VN_RELE in the error case


Signed-off-by: Christoph Hellwig <hch@lst.de>

Date:  Tue Mar 25 17:44:23 AEDT 2008
Workarea:  redback.melbourne.sgi.com:/home/lachlan/isms/2.6.x-hch
Inspected by:  hch
Author:  lachlan

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:30708a
fs/xfs/linux-2.6/xfs_super.c - 1.411 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_super.c.diff?r1=text&tr1=1.411&r2=text&tr2=1.410&f=h
	- cleanup root inode handling in xfs_fs_fill_super
