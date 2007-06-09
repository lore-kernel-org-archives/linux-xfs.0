Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 09 Jun 2007 03:26:43 -0700 (PDT)
Received: from mail.lst.de (verein.lst.de [213.95.11.210])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l59AQbWt029229
	for <xfs@oss.sgi.com>; Sat, 9 Jun 2007 03:26:39 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by mail.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id l59AQbo6023340
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Sat, 9 Jun 2007 12:26:37 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id l59AQboW023338
	for xfs@oss.sgi.com; Sat, 9 Jun 2007 12:26:37 +0200
Date: Sat, 9 Jun 2007 12:26:37 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] fix 32bit build
Message-ID: <20070609102637.GA23294@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/xfs_mount.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_mount.c	2007-06-09 11:20:51.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_mount.c	2007-06-09 11:21:43.000000000 +0200
@@ -1154,7 +1154,9 @@ xfs_mountfs(
 	 * This may drive us straight to ENOSPC on mount, but that implies
 	 * we were already there on the last unmount.
 	 */
-	resblks = min_t(__uint64_t, mp->m_sb.sb_dblocks / 20, 1024);
+	resblks = mp->m_sb.sb_dblocks;
+	do_div(resblks, 20);
+	resblks = min_t(__uint64_t, resblks, 1024);
 	xfs_reserve_blocks(mp, &resblks, NULL);
 
 	return 0;
