Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 19 Sep 2007 08:58:31 -0700 (PDT)
Received: from redback.melbourne.sgi.com (redback.melbourne.sgi.com [134.14.55.78])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l8JFwNuw006297
	for <xfs@oss.sgi.com>; Wed, 19 Sep 2007 08:58:25 -0700
Date: Tue, 18 Sep 2007 17:56:52 +1000
From: Lachlan McIlroy <lachlan@redback.melbourne.sgi.com>
Message-Id: <200709180756.l8I7uq6L029870@redback.melbourne.sgi.com>
Subject: TAKE 970662 - simplify validata_fields
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

simplify validata_fields

Stop using xfs_getattr and a onstack bhv_vattr_t just to get three
fields from the underlying inode and opencode copying from the inode
fields instead.


Signed-off-by: Christoph Hellwig <hch@lst.de>


Date:  Tue Sep 18 17:53:18 AEST 2007
Workarea:  redback.melbourne.sgi.com:/home/lachlan/isms/2.6.x-hch
Inspected by:  Christoph Hellwig <hch@lst.de>

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:29711a
fs/xfs/linux-2.6/xfs_iops.c - 1.263 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_iops.c.diff?r1=text&tr1=1.263&r2=text&tr2=1.262&f=h
	- simplify validata_fields
