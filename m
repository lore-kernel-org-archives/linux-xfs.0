Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 01 Oct 2007 20:10:25 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id l923AETH031126
	for <xfs@oss.sgi.com>; Mon, 1 Oct 2007 20:10:18 -0700
Subject: PARTIAL TAKE 971186 - cleanup vnode useage in xfs_ioctl.c
Message-Id: <20071002031009.5372F58C38F1@chook.melbourne.sgi.com>
Date: Tue,  2 Oct 2007 13:10:09 +1000 (EST)
From: lachlan@sgi.com (Lachlan McIlroy)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

cleanup vnode useage in xfs_ioctl.c

xfs_ioctl.c passes around vnode pointers quite a lot, but all places
already have the Linux inode which is identical to the vnode these
days.  Clean the code up to always use the Linux inode.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Date:  Sun Sep 30 23:26:24 PDT 2007
Workarea:  redback.melbourne.sgi.com:/home/lachlan/isms/2.6.x-log
Inspected by:  Christoph Hellwig <hch@lst.de>
Author:  lachlan.longdrop.melbourne.sgi.com

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:29807a
fs/xfs/linux-2.6/xfs_ioctl.c - 1.156 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_ioctl.c.diff?r1=text&tr1=1.156&r2=text&tr2=1.155&f=h
	- cleanup vnode useage in xfs_ioctl.c
