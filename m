Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 23 Oct 2008 00:06:02 -0700 (PDT)
Received: from relay.sgi.com (relay1.corp.sgi.com [192.26.58.214])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9N75ovZ014711
	for <xfs@oss.sgi.com>; Thu, 23 Oct 2008 00:05:50 -0700
Subject: TAKE 987246 - 
Message-Id: <20081023070728.9927358AE1E5@chook.melbourne.sgi.com>
Date: Thu, 23 Oct 2008 18:07:28 +1100 (EST)
From: lachlan@sgi.com (Lachlan McIlroy)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

free partially initialized inodes using destroy_inode

To make sure we free the security data inodes need to be freed using
the proper VFS helper (which we also need to export for this). We mark
these inodes bad so we can skip the flush path for them.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Date:  Thu Oct 23 17:55:04 EST 2008
Workarea:  redback.melbourne.sgi.com:/home/lachlan/isms/2.6.x-hch
Inspected by:  david@fromorbit.com
Author:  lachlan

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:32398a
fs/xfs/xfs_iget.c - 1.255 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_iget.c.diff?r1=text&tr1=1.255&r2=text&tr2=1.254&f=h
fs/xfs/xfs_inode.c - 1.536 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_inode.c.diff?r1=text&tr1=1.536&r2=text&tr2=1.535&f=h
fs/xfs/xfs_inode.h - 1.267 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_inode.h.diff?r1=text&tr1=1.267&r2=text&tr2=1.266&f=h
	- free partially initialized inodes using destroy_inode
