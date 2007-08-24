Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 24 Aug 2007 04:24:35 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l7OBOU4p006525
	for <xfs@oss.sgi.com>; Fri, 24 Aug 2007 04:24:31 -0700
Subject: PARTIAL TAKE 969608 - move freeing the mount structure from xfs_mount_free into the callers
Message-Id: <20070824112426.3861058C38F1@chook.melbourne.sgi.com>
Date: Fri, 24 Aug 2007 21:24:26 +1000 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

move freeing the mount structure from xfs_mount_free into the callers

In the next patch we need to look at the mount structure until just before
it's freed, so we need to be able to free it as the very last thing in
xfs_unmount.


Signed-off-by: Christoph Hellwig <hch@lst.de>


Date:  Fri Aug 24 21:24:02 AEST 2007
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  hch@lst.de

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:29501a
fs/xfs/xfs_vfsops.c - 1.530 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_vfsops.c.diff?r1=text&tr1=1.530&r2=text&tr2=1.529&f=h
	- call xfs_mount_free into the callers so that we can stack extra
	  cleanup functions prior to freeing the structure.

fs/xfs/xfs_mount.c - 1.404 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_mount.c.diff?r1=text&tr1=1.404&r2=text&tr2=1.403&f=h
	- call xfs_mount_free into the callers so that we can stack extra
	  cleanup functions prior to freeing the structure.

fs/xfs/linux-2.6/xfs_vfs.c - 1.77 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_vfs.c.diff?r1=text&tr1=1.77&r2=text&tr2=1.76&f=h
	- call xfs_mount_free into the callers so that we can stack extra
	  cleanup functions prior to freeing the structure.
