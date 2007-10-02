Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 01 Oct 2007 22:27:43 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id l925RYkh025863
	for <xfs@oss.sgi.com>; Mon, 1 Oct 2007 22:27:37 -0700
Subject: TAKE 970980 - simplify xfs_vn_getattr
Message-Id: <20071002052729.E0DD358C38F1@chook.melbourne.sgi.com>
Date: Tue,  2 Oct 2007 15:27:29 +1000 (EST)
From: lachlan@sgi.com (Lachlan McIlroy)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

simplify xfs_vn_getattr

Just fill in struct kstat directly from the xfs_inode instead of doing
a detour through a bhv_vattr_t and xfs_getattr.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Date:  Tue Sep 25 14:51:00 AEST 2007
Workarea:  redback.melbourne.sgi.com:/home/lachlan/isms/2.6.x-hch
Inspected by:  Christoph Hellwig <hch@lst.de>
Author:  lachlan

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:29770a
fs/xfs/linux-2.6/xfs_iops.c - 1.265 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_iops.c.diff?r1=text&tr1=1.265&r2=text&tr2=1.264&f=h
	- simplify xfs_vn_getattr
