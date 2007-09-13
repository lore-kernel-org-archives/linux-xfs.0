Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 12 Sep 2007 20:27:36 -0700 (PDT)
Received: from redback.melbourne.sgi.com (redback.melbourne.sgi.com [134.14.55.78])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l8D3RS4p020270
	for <xfs@oss.sgi.com>; Wed, 12 Sep 2007 20:27:30 -0700
Date: Thu, 13 Sep 2007 13:30:16 +1000
From: Lachlan McIlroy <lachlan@redback.melbourne.sgi.com>
Message-Id: <200709130330.l8D3UGu9004196@redback.melbourne.sgi.com>
Subject: TAKE 968767 - Ensure file size updates have been completed before writing inode to disk.
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

Ensure file size updates have been completed before writing inode to disk.



Date:  Thu Sep 13 13:27:00 AEST 2007
Workarea:  redback.melbourne.sgi.com:/home/lachlan/isms/2.6.x-xfs
Inspected by:  dgc

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:29675a
fs/xfs/xfs_vnodeops.c - 1.720 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_vnodeops.c.diff?r1=text&tr1=1.720&r2=text&tr2=1.719&f=h
	- Ensure file size updates have been completed before writing inode to disk.

fs/xfs/linux-2.6/xfs_super.c - 1.398 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_super.c.diff?r1=text&tr1=1.398&r2=text&tr2=1.397&f=h
	- Ensure file size updates have been completed before writing inode to disk.

fs/xfs/linux-2.6/xfs_aops.c - 1.153 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_aops.c.diff?r1=text&tr1=1.153&r2=text&tr2=1.152&f=h
	- Ensure file size updates have been completed before writing inode to disk.
