Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 20 Jan 2008 23:18:18 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m0L7IAbT028066
	for <xfs@oss.sgi.com>; Sun, 20 Jan 2008 23:18:14 -0800
Subject: PARTIAL TAKE 971186 - kill xfs_root
Message-Id: <20080121071824.E026C58C4C10@chook.melbourne.sgi.com>
Date: Mon, 21 Jan 2008 18:18:24 +1100 (EST)
From: lachlan@sgi.com (Lachlan McIlroy)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

kill xfs_root

The only caller (xfs_fs_fill_super) can simplify call igrab on the
root inode.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Date:  Mon Jan 21 18:17:52 AEDT 2008
Workarea:  redback.melbourne.sgi.com:/home/lachlan/isms/2.6.x-hch
Inspected by:  Christoph Hellwig <hch@lst.de>
Author:  lachlan

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:30393a
fs/xfs/xfs_vfsops.c - 1.550 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_vfsops.c.diff?r1=text&tr1=1.550&r2=text&tr2=1.549&f=h
fs/xfs/linux-2.6/xfs_super.c - 1.407 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_super.c.diff?r1=text&tr1=1.407&r2=text&tr2=1.406&f=h
fs/xfs/linux-2.6/xfs_ksyms.c - 1.78 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_ksyms.c.diff?r1=text&tr1=1.78&r2=text&tr2=1.77&f=h
fs/xfs/xfs_vfsops.h - 1.8 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_vfsops.h.diff?r1=text&tr1=1.8&r2=text&tr2=1.7&f=h
	- kill xfs_root
