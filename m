Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 14 Jul 2007 09:10:08 -0700 (PDT)
Received: from mail.lst.de (verein.lst.de [213.95.11.210])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l6EGA3bm018428
	for <xfs@oss.sgi.com>; Sat, 14 Jul 2007 09:10:05 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by mail.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id l6EGA4NK008740
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Sat, 14 Jul 2007 18:10:04 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id l6EGA4Xx008737
	for xfs@oss.sgi.com; Sat, 14 Jul 2007 18:10:04 +0200
Date: Sat, 14 Jul 2007 18:10:04 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] fix dmapi warning in 32bit builds
Message-ID: <20070714161003.GF7768@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

dm_size_t is 64bit even in 32bit builds so we need to use max_t when
when comparing to PAGE_CACHE_SIZE.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/dmapi/xfs_dm.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/dmapi/xfs_dm.c	2007-07-14 16:10:40.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/dmapi/xfs_dm.c	2007-07-14 16:11:34.000000000 +0200
@@ -2636,7 +2636,7 @@ xfs_dm_probe_hole(
 	if (align == 0)
 		align = 1;
 	align <<= mp->m_sb.sb_blocklog;
-	align = MAX(align, PAGE_CACHE_SIZE);
+	align = max_t(dm_size_t, align, PAGE_CACHE_SIZE);
 
 	error = xfs_dm_round_hole(off, len, align, realsize, &roff, &rlen);
 	if (error)
@@ -2699,7 +2699,7 @@ xfs_dm_punch_hole(
 		align = 1;
 
 	align <<= mp->m_sb.sb_blocklog;
-	align = MAX(align, PAGE_CACHE_SIZE);
+	align = max_t(dm_size_t, align, PAGE_CACHE_SIZE);
 
 	if ((off + len) > realsize) {
 		xfs_iunlock(ip, XFS_IOLOCK_EXCL);
