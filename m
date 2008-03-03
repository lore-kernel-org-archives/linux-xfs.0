Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 02 Mar 2008 20:16:12 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m234FjJP003479
	for <xfs@oss.sgi.com>; Sun, 2 Mar 2008 20:15:50 -0800
Subject: PARTIAL TAKE 977823 - fix inode leak in xfs_iget_core()
Message-Id: <20080303041610.80A3D58C4C0F@chook.melbourne.sgi.com>
Date: Mon,  3 Mar 2008 15:16:10 +1100 (EST)
From: lachlan@sgi.com (Lachlan McIlroy)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

fix inode leak in xfs_iget_core()

If the radix_tree_preload() fails, we need to destroy the
inode we just read in before trying again. This could leak
xfs_vnode structures when there is memory pressure. Noticed
by Christoph Hellwig.

Signed-off-by: Dave Chinner <dgc@sgi.com>

Date:  Mon Mar  3 15:15:23 AEDT 2008
Workarea:  redback.melbourne.sgi.com:/home/lachlan/isms/2.6.x-xfs
Inspected by:  hch
Author:  lachlan

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:30606a
fs/xfs/xfs_iget.c - 1.240 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_iget.c.diff?r1=text&tr1=1.240&r2=text&tr2=1.239&f=h
	- fix inode leak in xfs_iget_core()
