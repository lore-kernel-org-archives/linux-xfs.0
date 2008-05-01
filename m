Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 01 May 2008 15:01:21 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m41M0NFt001250
	for <xfs@oss.sgi.com>; Thu, 1 May 2008 15:00:29 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1E3911176E1
	for <xfs@oss.sgi.com>; Thu,  1 May 2008 15:01:07 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id A0F6EhAbzgY42E3j for <xfs@oss.sgi.com>; Thu, 01 May 2008 15:01:07 -0700 (PDT)
Received: from verein.lst.de (localhost [127.0.0.1])
	by verein.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id m41M10F3002379
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Fri, 2 May 2008 00:01:00 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id m41M1069002377
	for xfs@oss.sgi.com; Fri, 2 May 2008 00:01:00 +0200
Date: Fri, 2 May 2008 00:01:00 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 3/10] don't call xfs_freesb from xfs_mountfs failure case
Message-ID: <20080501220100.GC2315@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Freeing of the superblock is already handled in the caller, and that
is more symmetric with the mount path, too.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/xfs_mount.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_mount.c	2008-05-01 21:20:47.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_mount.c	2008-05-01 21:21:04.000000000 +0200
@@ -1272,7 +1272,6 @@ xfs_mountfs(
  error1:
 	if (uuid_mounted)
 		uuid_table_remove(&mp->m_sb.sb_uuid);
-	xfs_freesb(mp);
 	return error;
 }
 
