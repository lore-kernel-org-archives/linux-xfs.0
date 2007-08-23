Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 23 Aug 2007 12:39:22 -0700 (PDT)
Received: from mail.lst.de (verein.lst.de [213.95.11.210])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l7NJdG4p004121
	for <xfs@oss.sgi.com>; Thu, 23 Aug 2007 12:39:18 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by mail.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id l7NJdFA5008646
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Thu, 23 Aug 2007 21:39:15 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id l7NJdFaH008641
	for xfs@oss.sgi.com; Thu, 23 Aug 2007 21:39:15 +0200
Date: Thu, 23 Aug 2007 21:39:15 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 9/17] move freeing the mount structure from xfs_mount_free into the callers
Message-ID: <20070823193915.GJ8050@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

In the next patch we need to look at the mount structure until just before
it's freed, so we need to be able to free it as the very last thing in
xfs_unmount.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/xfs_mount.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_mount.c	2007-08-13 18:07:48.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_mount.c	2007-08-13 18:07:51.000000000 +0200
@@ -194,7 +194,6 @@ xfs_mount_free(
 	}
 
 	xfs_icsb_destroy_counters(mp);
-	kmem_free(mp, sizeof(xfs_mount_t));
 }
 
 /*
Index: linux-2.6-xfs/fs/xfs/xfs_vfsops.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_vfsops.c	2007-08-13 18:07:48.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_vfsops.c	2007-08-13 18:07:51.000000000 +0200
@@ -639,6 +639,7 @@ out:
 		 * and free the super block buffer & mount structures.
 		 */
 		xfs_unmountfs(mp, credp);
+		kmem_free(mp, sizeof(xfs_mount_t));
 	}
 
 	return XFS_ERROR(error);
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_vfs.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_vfs.c	2007-08-13 18:07:48.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_vfs.c	2007-08-13 18:07:51.000000000 +0200
@@ -411,6 +411,7 @@ bhv_remove_all_vfsops(
 	mp = XFS_VFSTOM(vfsp);
 	VFS_REMOVEBHV(vfsp, &mp->m_bhv);
 	xfs_mount_free(mp, 0);
+	kmem_free(mp, sizeof(xfs_mount_t));
 }
 
 void
