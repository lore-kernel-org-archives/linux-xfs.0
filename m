Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 15 Oct 2008 21:36:06 -0700 (PDT)
Received: from relay.sgi.com (relay2.corp.sgi.com [192.26.58.22])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9G4a33u012487
	for <xfs@oss.sgi.com>; Wed, 15 Oct 2008 21:36:03 -0700
Subject: TAKE 988143 - Move the AIL lock into the struct xfs_ail
Message-Id: <20081016043744.9737258FA22B@chook.melbourne.sgi.com>
Date: Thu, 16 Oct 2008 15:37:44 +1100 (EST)
From: lachlan@sgi.com (Lachlan McIlroy)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

Move the AIL lock into the struct xfs_ail

Bring the ail lock inside the struct xfs_ail. This means
the AIL can be entirely manipulated via the struct xfs_ail rather
than needing both the struct xfs_mount and the struct xfs_ail.

Signed-off-by: Dave Chinner <david@fromorbit.com>

Date:  Thu Oct 16 15:37:23 EST 2008
Workarea:  redback.melbourne.sgi.com:/home/lachlan/isms/2.6.x-ail
Inspected by:  hch
Author:  lachlan

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:32350a
fs/xfs/xfs_log.c - 1.371 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_log.c.diff?r1=text&tr1=1.371&r2=text&tr2=1.370&f=h
fs/xfs/xfs_extfree_item.c - 1.70 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_extfree_item.c.diff?r1=text&tr1=1.70&r2=text&tr2=1.69&f=h
fs/xfs/xfs_buf_item.c - 1.170 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_buf_item.c.diff?r1=text&tr1=1.170&r2=text&tr2=1.169&f=h
fs/xfs/xfs_trans_priv.h - 1.35 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_trans_priv.h.diff?r1=text&tr1=1.35&r2=text&tr2=1.34&f=h
fs/xfs/xfs_trans_ail.c - 1.91 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_trans_ail.c.diff?r1=text&tr1=1.91&r2=text&tr2=1.90&f=h
fs/xfs/xfs_inode_item.c - 1.140 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_inode_item.c.diff?r1=text&tr1=1.140&r2=text&tr2=1.139&f=h
fs/xfs/xfs_log_recover.c - 1.352 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_log_recover.c.diff?r1=text&tr1=1.352&r2=text&tr2=1.351&f=h
fs/xfs/xfs_mount.h - 1.283 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_mount.h.diff?r1=text&tr1=1.283&r2=text&tr2=1.282&f=h
fs/xfs/xfs_inode.c - 1.533 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_inode.c.diff?r1=text&tr1=1.533&r2=text&tr2=1.532&f=h
fs/xfs/xfs_trans.c - 1.189 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_trans.c.diff?r1=text&tr1=1.189&r2=text&tr2=1.188&f=h
fs/xfs/quota/xfs_dquot_item.c - 1.26 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/quota/xfs_dquot_item.c.diff?r1=text&tr1=1.26&r2=text&tr2=1.25&f=h
fs/xfs/quota/xfs_dquot.c - 1.42 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/quota/xfs_dquot.c.diff?r1=text&tr1=1.42&r2=text&tr2=1.41&f=h
	- Move the AIL lock into the struct xfs_ail
