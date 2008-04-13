Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 13 Apr 2008 01:21:38 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m3D8LHtX013354
	for <xfs@oss.sgi.com>; Sun, 13 Apr 2008 01:21:19 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DAD1812961A6
	for <xfs@oss.sgi.com>; Sun, 13 Apr 2008 01:21:55 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id DzXyrgi0usAIrygS for <xfs@oss.sgi.com>; Sun, 13 Apr 2008 01:21:55 -0700 (PDT)
Received: from verein.lst.de (localhost [127.0.0.1])
	by verein.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id m3D8LnF3018053
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Sun, 13 Apr 2008 10:21:49 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id m3D8LnAq018051
	for xfs@oss.sgi.com; Sun, 13 Apr 2008 10:21:49 +0200
Date: Sun, 13 Apr 2008 10:21:49 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] xfs_rename: pass resblks to xfs_dir_removename
Message-ID: <20080413082149.GA17993@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Symilar to rmdir and remove - avoids a potential transaction reservation
overrun.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/xfs_vnodeops.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_vnodeops.c	2008-04-11 12:22:37.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_vnodeops.c	2008-04-11 12:23:08.000000000 +0200
@@ -2359,7 +2359,7 @@ xfs_remove(
 	 */
 	XFS_BMAP_INIT(&free_list, &first_block);
 	error = xfs_dir_removename(tp, dp, name, ip->i_ino,
-					&first_block, &free_list, 0);
+					&first_block, &free_list, resblks);
 	if (error) {
 		ASSERT(error != ENOENT);
 		REMOVE_DEBUG_TRACE(__LINE__);
