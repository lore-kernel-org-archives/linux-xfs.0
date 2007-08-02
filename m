Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 02 Aug 2007 00:40:25 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l727eIbm018527
	for <xfs@oss.sgi.com>; Thu, 2 Aug 2007 00:40:20 -0700
Subject: PARTIAL TAKE 968555 - sparse fixes for 2.6.23
Message-Id: <20070802074018.9CF4458F4B6D@chook.melbourne.sgi.com>
Date: Thu,  2 Aug 2007 17:40:18 +1000 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Fix sparse NULL vs 0 warnings

Sparse now warns about comparing pointers to 0, so change all instance
where that happens to NULL instead.


Signed-off-by: Christoph Hellwig <hch@lst.de>


Date:  Thu Aug  2 17:39:43 AEST 2007
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  hch@lst.de

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:29308a
fs/xfs/xfs_log.c - 1.333 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_log.c.diff?r1=text&tr1=1.333&r2=text&tr2=1.332&f=h
	- Fix sparse NULL vs 0 warnings

fs/xfs/xfs_log_recover.c - 1.320 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_log_recover.c.diff?r1=text&tr1=1.320&r2=text&tr2=1.319&f=h
	- Fix sparse NULL vs 0 warnings
