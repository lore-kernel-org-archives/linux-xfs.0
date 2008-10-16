Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 15 Oct 2008 21:38:37 -0700 (PDT)
Received: from relay.sgi.com (relay2.corp.sgi.com [192.26.58.22])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9G4cW2c013156
	for <xfs@oss.sgi.com>; Wed, 15 Oct 2008 21:38:34 -0700
Subject: TAKE 988143 - Add ail pointer into log items
Message-Id: <20081016044013.DD50958FA22B@chook.melbourne.sgi.com>
Date: Thu, 16 Oct 2008 15:40:13 +1100 (EST)
From: lachlan@sgi.com (Lachlan McIlroy)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

Add ail pointer into log items

Add an xfs_ail pointer to log items so that the log items can
reference the AIL directly during callbacks without needed a
struct xfs_mount.

Signed-off-by: Dave Chinner <david@fromorbit.com>

Date:  Thu Oct 16 15:39:48 EST 2008
Workarea:  redback.melbourne.sgi.com:/home/lachlan/isms/2.6.x-ail
Inspected by:  hch
Author:  lachlan

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:32352a
fs/xfs/xfs_extfree_item.c - 1.71 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_extfree_item.c.diff?r1=text&tr1=1.71&r2=text&tr2=1.70&f=h
fs/xfs/xfs_buf_item.c - 1.171 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_buf_item.c.diff?r1=text&tr1=1.171&r2=text&tr2=1.170&f=h
fs/xfs/xfs_inode_item.c - 1.141 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_inode_item.c.diff?r1=text&tr1=1.141&r2=text&tr2=1.140&f=h
fs/xfs/xfs_trans_item.c - 1.49 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_trans_item.c.diff?r1=text&tr1=1.49&r2=text&tr2=1.48&f=h
fs/xfs/xfs_trans.c - 1.190 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_trans.c.diff?r1=text&tr1=1.190&r2=text&tr2=1.189&f=h
fs/xfs/xfs_trans.h - 1.154 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_trans.h.diff?r1=text&tr1=1.154&r2=text&tr2=1.153&f=h
	- Add ail pointer into log items
