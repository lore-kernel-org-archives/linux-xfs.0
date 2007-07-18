Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 17 Jul 2007 20:06:41 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l6I36Ubm001162
	for <xfs@oss.sgi.com>; Tue, 17 Jul 2007 20:06:32 -0700
Subject: TAKE 967788 - Allow punching holes to free space when at ENOSPC
Message-Id: <20070718030628.8872358C52B5@chook.melbourne.sgi.com>
Date: Wed, 18 Jul 2007 13:06:28 +1000 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Allow punching holes to free space when at ENOSPC

Make the free file space transaction able to dip into the
reserved blocks to ensure that we can successfully free blocks
when the filesystem is at ENOSPC.


Date:  Wed Jul 18 13:05:37 AEST 2007
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  vapo@sgi.com

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:29167a
fs/xfs/xfs_vnodeops.c - 1.703 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_vnodeops.c.diff?r1=text&tr1=1.703&r2=text&tr2=1.702&f=h
	- Add XFS_TRANS_RESERVED flag to the xfs_free_file_space
	  transaction reservation.
