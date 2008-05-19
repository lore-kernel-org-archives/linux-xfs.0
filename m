Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 19 May 2008 00:16:26 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m4J7GLFl029174
	for <xfs@oss.sgi.com>; Mon, 19 May 2008 00:16:23 -0700
Subject: PARTIAL TAKE 981498 - kill xfs_uuid_unmount
Message-Id: <20080519071706.CE7DE58C4C29@chook.melbourne.sgi.com>
Date: Mon, 19 May 2008 17:17:06 +1000 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

kill xfs_uuid_unmount

Quite useless wrapper that doesn't help making the code more readable.


Signed-off-by: Christoph Hellwig <hch@lst.de>


Date:  Mon May 19 17:16:42 AEST 2008
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  hch@lst.de

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:31184a
fs/xfs/xfs_mount.c - 1.433 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_mount.c.diff?r1=text&tr1=1.433&r2=text&tr2=1.432&f=h
	- kill xfs_uuid_unmount wrapper.
