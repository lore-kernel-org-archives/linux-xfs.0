Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 24 Jul 2008 19:11:50 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m6P2BkFe027293
	for <xfs@oss.sgi.com>; Thu, 24 Jul 2008 19:11:47 -0700
Subject: TAKE 981498 - Remove vn_from_inode()
Message-Id: <20080725021255.20EEE58C4C3F@chook.melbourne.sgi.com>
Date: Fri, 25 Jul 2008 12:12:55 +1000 (EST)
From: lachlan@sgi.com (Lachlan McIlroy)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

Remove vn_from_inode()

bhv_vnode_t is just a typedef for struct inode, so there's no need for
a helper to convert between the two.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Date:  Fri Jul 25 12:11:50 AEST 2008
Workarea:  redback.melbourne.sgi.com:/home/lachlan/isms/2.6.x-hch
Inspected by:  
hch
lachlan
Author:  lachlan

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:31760a
fs/xfs/linux-2.6/xfs_vnode.h - 1.155 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_vnode.h.diff?r1=text&tr1=1.155&r2=text&tr2=1.154&f=h
fs/xfs/linux-2.6/xfs_super.c - 1.439 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_super.c.diff?r1=text&tr1=1.439&r2=text&tr2=1.438&f=h
	- Remove vn_from_inode()
