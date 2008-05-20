Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 19 May 2008 18:51:19 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m4K1pBA6002890
	for <xfs@oss.sgi.com>; Mon, 19 May 2008 18:51:16 -0700
Subject: TAKE 981951 - add missing call to xfs_filestream_unmount on xfs_mountfs failure
Message-Id: <20080520015156.E79B258C4C29@chook.melbourne.sgi.com>
Date: Tue, 20 May 2008 11:51:56 +1000 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

add missing call to xfs_filestream_unmount on xfs_mountfs failure

Signed-off-by: Christoph Hellwig <hch@lst.de>


Date:  Tue May 20 11:51:38 AEST 2008
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  hch@lst.de

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:31199a
fs/xfs/linux-2.6/xfs_super.c - 1.427 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_super.c.diff?r1=text&tr1=1.427&r2=text&tr2=1.426&f=h
	- add missing call to xfs_filestream_unmount on xfs_mountfs failure.
