Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 26 Jul 2008 02:57:26 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6Q9vOpH025021
	for <xfs@oss.sgi.com>; Sat, 26 Jul 2008 02:57:24 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D1DD9E9D818
	for <xfs@oss.sgi.com>; Sat, 26 Jul 2008 02:58:34 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id uYTWc4FiiXtsP2MV for <xfs@oss.sgi.com>; Sat, 26 Jul 2008 02:58:34 -0700 (PDT)
Received: from verein.lst.de (localhost [127.0.0.1])
	by verein.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id m6Q9wONg031975
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Sat, 26 Jul 2008 11:58:24 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id m6Q9wOrb031973
	for xfs@oss.sgi.com; Sat, 26 Jul 2008 11:58:24 +0200
Date: Sat, 26 Jul 2008 11:58:24 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 6/6] use KM_MAYFAIL in xfs_mountfs
Message-ID: <20080726095824.GE31858@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Use KM_MAYFAIL for the m_perag allocation, we can deal with the error
easily and blocking forever during mount is not a good idea either.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/xfs_mount.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_mount.c	2008-07-24 23:02:26.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_mount.c	2008-07-24 23:04:15.000000000 +0200
@@ -1052,8 +1052,10 @@ xfs_mountfs(
 	 * Allocate and initialize the per-ag data.
 	 */
 	init_rwsem(&mp->m_peraglock);
-	mp->m_perag =
-		kmem_zalloc(sbp->sb_agcount * sizeof(xfs_perag_t), KM_SLEEP);
+	mp->m_perag = kmem_zalloc(sbp->sb_agcount * sizeof(xfs_perag_t),
+				  KM_MAYFAIL);
+	if (!mp->m_perag)
+		goto error1;
 
 	mp->m_maxagi = xfs_initialize_perag(mp, sbp->sb_agcount);
 
