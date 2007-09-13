Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 12 Sep 2007 20:35:33 -0700 (PDT)
Received: from redback.melbourne.sgi.com (redback.melbourne.sgi.com [134.14.55.78])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l8D3ZP4p021475
	for <xfs@oss.sgi.com>; Wed, 12 Sep 2007 20:35:29 -0700
Date: Thu, 13 Sep 2007 13:38:16 +1000
From: Lachlan McIlroy <lachlan@redback.melbourne.sgi.com>
Message-Id: <200709130338.l8D3cGMi006214@redback.melbourne.sgi.com>
Subject: TAKE 969656 - Avoid replaying inode buffer initialisation log items if on-disk version is newer.
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

Avoid replaying inode buffer initialisation log items if on-disk version is newer.


Date:  Thu Sep 13 13:34:58 AEST 2007
Workarea:  redback.melbourne.sgi.com:/home/lachlan/isms/2.6.x-xfs
Inspected by:  dgc

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:29676a
fs/xfs/xfs_buf_item.h - 1.45 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_buf_item.h.diff?r1=text&tr1=1.45&r2=text&tr2=1.44&f=h
	- Avoid replaying inode buffer initialisation log items if on-disk version is newer.

fs/xfs/xfs_log_recover.c - 1.323 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_log_recover.c.diff?r1=text&tr1=1.323&r2=text&tr2=1.322&f=h
	- Avoid replaying inode buffer initialisation log items if on-disk version is newer.

fs/xfs/xfs_trans_buf.c - 1.127 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_trans_buf.c.diff?r1=text&tr1=1.127&r2=text&tr2=1.126&f=h
	- Avoid replaying inode buffer initialisation log items if on-disk version is newer.
