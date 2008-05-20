Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 19 May 2008 18:26:29 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m4K1QKI1031639
	for <xfs@oss.sgi.com>; Mon, 19 May 2008 18:26:22 -0700
Subject: PARTIAL TAKE 981951 - add xfs_setup_devices helper
Message-Id: <20080520012706.45EEF58C4C29@chook.melbourne.sgi.com>
Date: Tue, 20 May 2008 11:27:06 +1000 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

add xfs_setup_devices helper

Split setting the block and sector size out of xfs_fs_fill_super into a
small helper to make xfs_fs_fill_super more readable.


Signed-off-by: Christoph Hellwig <hch@lst.de>


Date:  Tue May 20 11:26:47 AEST 2008
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  hch@lst.de

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:31194a
fs/xfs/linux-2.6/xfs_super.c - 1.422 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_super.c.diff?r1=text&tr1=1.422&r2=text&tr2=1.421&f=h
	- add xfs_setup_devices helper.
