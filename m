Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 20 Apr 2008 21:51:16 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m3L4p2jZ032413
	for <xfs@oss.sgi.com>; Sun, 20 Apr 2008 21:51:07 -0700
Subject: PARTIAL TAKE 976035 - kill xfs_getattr
Message-Id: <20080421045139.F161358C4C15@chook.melbourne.sgi.com>
Date: Mon, 21 Apr 2008 14:51:39 +1000 (EST)
From: lachlan@sgi.com (Lachlan McIlroy)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

kill xfs_getattr

It's currently used by the ACL code to read di_mode/di_uid, but these
are simple 32bit scalar values we can just read directly without
locking.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Date:  Mon Apr 21 14:50:32 AEST 2008
Workarea:  redback.melbourne.sgi.com:/home/lachlan/isms/2.6.x-hch
Inspected by:  hch
Author:  lachlan

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:30897a
fs/xfs/xfs_vnodeops.c - 1.751 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_vnodeops.c.diff?r1=text&tr1=1.751&r2=text&tr2=1.750&f=h
fs/xfs/xfs_acl.c - 1.72 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_acl.c.diff?r1=text&tr1=1.72&r2=text&tr2=1.71&f=h
fs/xfs/xfs_vnodeops.h - 1.13 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_vnodeops.h.diff?r1=text&tr1=1.13&r2=text&tr2=1.12&f=h
	- kill xfs_getattr
