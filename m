Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 19 May 2008 17:43:24 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m4K0hIF6027704
	for <xfs@oss.sgi.com>; Mon, 19 May 2008 17:43:20 -0700
Subject: PARTIAL TAKE 981951 - merge xfs_unmount into xfs_fs_put_super / xfs_fs_fill_super
Message-Id: <20080520004401.35C0958C4C29@chook.melbourne.sgi.com>
Date: Tue, 20 May 2008 10:44:01 +1000 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

merge xfs_unmount into xfs_fs_put_super / xfs_fs_fill_super

xfs_unmount is small and already pretty Linux specific, so merge it into
the callers.  The real unmount path is simplified a little by doing a
WARN_ON on the xfs_unmount_flush retval directly instead of propagating
the error back to the caller, and the mout failure case in simplified
significantly by removing the forced shutdown case and all the dmapi
events that shouldn't be sent because the dmapi mount event hasn't been
sent by that time either.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Date:  Tue May 20 10:43:13 AEST 2008
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  hch@lst.de

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:31188a
fs/xfs/xfs_vfsops.c - 1.566 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_vfsops.c.diff?r1=text&tr1=1.566&r2=text&tr2=1.565&f=h
	- merge xfs_unmount into xfs_fs_put_super / xfs_fs_fill_super

fs/xfs/linux-2.6/xfs_super.c - 1.419 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_super.c.diff?r1=text&tr1=1.419&r2=text&tr2=1.418&f=h
	- merge xfs_unmount into xfs_fs_put_super / xfs_fs_fill_super

fs/xfs/xfs_vfsops.h - 1.10 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_vfsops.h.diff?r1=text&tr1=1.10&r2=text&tr2=1.9&f=h
	- merge xfs_unmount into xfs_fs_put_super / xfs_fs_fill_super
