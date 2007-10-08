Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 07 Oct 2007 23:21:40 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id l986LXPD020972
	for <xfs@oss.sgi.com>; Sun, 7 Oct 2007 23:21:35 -0700
Subject: PARTIAL TAKE 971186 - kill XFS_INOBT_IS_FREE_DISK
Message-Id: <20071008062130.4D01158C38F1@chook.melbourne.sgi.com>
Date: Mon,  8 Oct 2007 16:21:30 +1000 (EST)
From: lachlan@sgi.com (Lachlan McIlroy)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

kill XFS_INOBT_IS_FREE_DISK

This macro is unused an all other acros in this family operate on native
types, so we most likely won't grow a user either.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Date:  Mon Oct  8 16:20:45 AEST 2007
Workarea:  redback.melbourne.sgi.com:/home/lachlan/isms/2.6.x-oss
Inspected by:  Christoph Hellwig <hch@lst.de>
Author:  lachlan

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:29846a
fs/xfs/xfs_ialloc_btree.h - 1.33 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_ialloc_btree.h.diff?r1=text&tr1=1.33&r2=text&tr2=1.32&f=h
	- kill XFS_INOBT_IS_FREE_DISK
