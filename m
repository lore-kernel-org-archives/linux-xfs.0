Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 14 May 2008 20:59:00 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m4F3wb1r007946
	for <xfs@oss.sgi.com>; Wed, 14 May 2008 20:58:41 -0700
Subject: TAKE 981809 - kill attr_capable checks
Message-Id: <20080515035919.4966658C4C29@chook.melbourne.sgi.com>
Date: Thu, 15 May 2008 13:59:19 +1000 (EST)
From: tes@sgi.com (Tim Shimmin)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com, sgi.bugs.xfs@engr.sgi.com

Kill attr_capable checks as already done in xattr_permission.

No need for addition permission checks in the xattr handler,
fs/xattr.c:xattr_permission() already does them, and in fact slightly
more strict then what was in the attr_capable handlers.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Date:  Thu May 15 13:58:26 AEST 2008
Workarea:  chook.melbourne.sgi.com:/build/tes/2.6.x-xfs-quilt
Inspected by:  hch@lst.de

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:31164a
fs/xfs/xfs_attr.c - 1.149 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_attr.c.diff?r1=text&tr1=1.149&r2=text&tr2=1.148&f=h
	- Kill attr_capable checks as already done in xattr_permission.

fs/xfs/xfs_attr.h - 1.40 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_attr.h.diff?r1=text&tr1=1.40&r2=text&tr2=1.39&f=h
	- Kill attr_capable checks as already done in xattr_permission.

fs/xfs/linux-2.6/xfs_iops.c - 1.285 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_iops.c.diff?r1=text&tr1=1.285&r2=text&tr2=1.284&f=h
	- Kill attr_capable checks as already done in xattr_permission.
