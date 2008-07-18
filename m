Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 17 Jul 2008 23:23:56 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m6I6NG4q008572
	for <xfs@oss.sgi.com>; Thu, 17 Jul 2008 23:23:19 -0700
Subject: TAKE 984564 - split out xfs value-add from xfs_setattr
Message-Id: <20080718062419.B444058C4C3F@chook.melbourne.sgi.com>
Date: Fri, 18 Jul 2008 16:24:19 +1000 (EST)
From: tes@sgi.com (Tim Shimmin)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com, sgi.bugs.xfs@engr.sgi.com

xfs_setattr currently doesn't just handle the attributes set through
->setattr but also addition XFS-specific attributes: project id, inode
flags and extent size hint.  Having these in a single function makes it
more complicated and forces to have us a bhv_vattr intermediate
structure eating up stackspace.

This patch adds a new xfs_ioctl_setattr helper for the XFS ioctls that
set these attributes and remove the code to set them through
xfs_setattr.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Date:  Fri Jul 18 16:22:14 AEST 2008
Workarea:  chook.melbourne.sgi.com:/build/tes/2.6.x-xfs-quilt
Inspected by:  hch@lst.de

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb

Modid:  xfs-linux-melb:xfs-kern:31677a
fs/xfs/xfs_vnodeops.c - 1.763 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_vnodeops.c.diff?r1=text&tr1=1.763&r2=text&tr2=1.762&f=h
fs/xfs/linux-2.6/xfs_ioctl.c - 1.168 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_ioctl.c.diff?r1=text&tr1=1.168&r2=text&tr2=1.167&f=h
fs/xfs/linux-2.6/xfs_vnode.h - 1.151 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_vnode.h.diff?r1=text&tr1=1.151&r2=text&tr2=1.150&f=h
