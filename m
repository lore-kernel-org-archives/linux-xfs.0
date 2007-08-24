Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 24 Aug 2007 04:41:23 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l7OBfF4p009966
	for <xfs@oss.sgi.com>; Fri, 24 Aug 2007 04:41:20 -0700
Subject: PARTIAL TAKE 969608 - decontaminate vfs operations from behavior details
Message-Id: <20070824114111.E303F58C38F1@chook.melbourne.sgi.com>
Date: Fri, 24 Aug 2007 21:41:11 +1000 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

decontaminate vfs operations from behavior details

All vfs ops now take struct xfs_mount pointers and the behaviour
related glue is split out into methods of it's own.


Signed-off-by: Christoph Hellwig <hch@lst.de>


Date:  Fri Aug 24 21:40:43 AEST 2007
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  hch@lst.de

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:29504a
fs/xfs/xfs_vfsops_bhv.c - 1.1 - new
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_vfsops_bhv.c
	- convert vfs ops to take xfs_mount pointers and split out
	  the behaviour related glue.

fs/xfs/xfs_vfsops.h - 1.1 - new
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_vfsops.h
	- convert vfs ops to take xfs_mount pointers and split out
	  the behaviour related glue.

fs/xfs/xfs_rw.c - 1.399 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_rw.c.diff?r1=text&tr1=1.399&r2=text&tr2=1.398&f=h
	- convert vfs ops to take xfs_mount pointers and split out
	  the behaviour related glue.

fs/xfs/xfs_vfsops.c - 1.533 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_vfsops.c.diff?r1=text&tr1=1.533&r2=text&tr2=1.532&f=h
	- convert vfs ops to take xfs_mount pointers and split out
	  the behaviour related glue.

fs/xfs/xfs_mount.h - 1.245 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_mount.h.diff?r1=text&tr1=1.245&r2=text&tr2=1.244&f=h
	- convert vfs ops to take xfs_mount pointers and split out
	  the behaviour related glue.

fs/xfs/Makefile-linux-2.6 - 1.211 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/Makefile-linux-2.6.diff?r1=text&tr1=1.211&r2=text&tr2=1.210&f=h
	- convert vfs ops to take xfs_mount pointers and split out
	  the behaviour related glue.

fs/xfs/linux-2.6/xfs_super.h - 1.72 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_super.h.diff?r1=text&tr1=1.72&r2=text&tr2=1.71&f=h
	- convert vfs ops to take xfs_mount pointers and split out
	  the behaviour related glue.

fs/xfs/linux-2.6/xfs_super.c - 1.391 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_super.c.diff?r1=text&tr1=1.391&r2=text&tr2=1.390&f=h
	- convert vfs ops to take xfs_mount pointers and split out
	  the behaviour related glue.
