Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 26 May 2008 21:37:35 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m4R4bTT9032169
	for <xfs@oss.sgi.com>; Mon, 26 May 2008 21:37:31 -0700
Subject: TAKE 982343 - make xfs use generic set/get/remove xattr routines
Message-Id: <20080527043816.4ADD558C4C3F@chook.melbourne.sgi.com>
Date: Tue, 27 May 2008 14:38:16 +1000 (EST)
From: tes@sgi.com (Tim Shimmin)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

Use the generic xattr methods.

Use the generic set, get and removexattr methods and supply the s_xattr
array with fine-grained handlers.  All XFS/Linux highlevel attr handling is
rewritten from scratch and placed into fs/xfs/linux-2.6/xfs_xattr.c so
that it's separated from the generic low-level code.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Date:  Tue May 27 14:37:16 AEST 2008
Workarea:  chook.melbourne.sgi.com:/build/tes/2.6.x-xfs-quilt
Inspected by:  hch@lst.de

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:31234a
fs/xfs/linux-2.6/xfs_xattr.c - 1.1 - new
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_xattr.c
	- Use generic set/get/remove xattr methods.

fs/xfs/Makefile - 1.61 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/Makefile.diff?r1=text&tr1=1.61&r2=text&tr2=1.60&f=h
	- Use generic set/get/remove xattr methods.

fs/xfs/xfs_attr.c - 1.152 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_attr.c.diff?r1=text&tr1=1.152&r2=text&tr2=1.151&f=h
	- Use generic set/get/remove xattr methods.

fs/xfs/xfs_attr.h - 1.41 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_attr.h.diff?r1=text&tr1=1.41&r2=text&tr2=1.40&f=h
	- Use generic set/get/remove xattr methods.

fs/xfs/linux-2.6/xfs_super.h - 1.79 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_super.h.diff?r1=text&tr1=1.79&r2=text&tr2=1.78&f=h
	- Use generic set/get/remove xattr methods.

fs/xfs/linux-2.6/xfs_super.c - 1.430 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_super.c.diff?r1=text&tr1=1.430&r2=text&tr2=1.429&f=h
	- Use generic set/get/remove xattr methods.

fs/xfs/linux-2.6/xfs_iops.c - 1.288 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_iops.c.diff?r1=text&tr1=1.288&r2=text&tr2=1.287&f=h
	- Use generic set/get/remove xattr methods.

fs/xfs/linux-2.6/xfs_iops.h - 1.34 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_iops.h.diff?r1=text&tr1=1.34&r2=text&tr2=1.33&f=h
	- Use generic set/get/remove xattr methods.
