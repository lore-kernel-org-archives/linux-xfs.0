Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 20 Apr 2008 21:45:33 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m3L4j9bL031967
	for <xfs@oss.sgi.com>; Sun, 20 Apr 2008 21:45:11 -0700
Subject: PARTIAL TAKE 976035 - Remove VN_IS* macros and related cruft.
Message-Id: <20080421044545.912E658C4C15@chook.melbourne.sgi.com>
Date: Mon, 21 Apr 2008 14:45:45 +1000 (EST)
From: lachlan@sgi.com (Lachlan McIlroy)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

Remove VN_IS* macros and related cruft.

We can just check i_mode / di_mode directly.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Date:  Mon Apr 21 14:44:57 AEST 2008
Workarea:  redback.melbourne.sgi.com:/home/lachlan/isms/2.6.x-hch
Inspected by:  hch
Author:  lachlan

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:30896a
fs/xfs/xfs_vnodeops.c - 1.750 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_vnodeops.c.diff?r1=text&tr1=1.750&r2=text&tr2=1.749&f=h
fs/xfs/xfs_acl.c - 1.71 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_acl.c.diff?r1=text&tr1=1.71&r2=text&tr2=1.70&f=h
fs/xfs/linux-2.6/xfs_vnode.h - 1.149 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_vnode.h.diff?r1=text&tr1=1.149&r2=text&tr2=1.148&f=h
	- Remove VN_IS* macros and related cruft.
