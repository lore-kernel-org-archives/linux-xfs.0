Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o5L8XR9a113440 for <xfs@oss.sgi.com>; Mon, 21 Jun 2010 03:33:28 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DEE46267830
	for <xfs@oss.sgi.com>; Mon, 21 Jun 2010 01:36:07 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id dvQy7KrjjRNjUHBN for
	<xfs@oss.sgi.com>; Mon, 21 Jun 2010 01:36:07 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.72 #1 (Red Hat
	Linux)) id 1OQcUB-0007al-JB
	for xfs@oss.sgi.com; Mon, 21 Jun 2010 08:36:07 +0000
Message-Id: <20100621083607.476361881@bombadil.infradead.org>
Date: Mon, 21 Jun 2010 04:35:50 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 07/12] xfs: remove explicit xfs_sync_data/xfs_sync_attr calls
	on umount
References: <20100621083543.125860679@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-remove-sync-on-umount
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

On the final put of a superblock the VFS already calls sync_filesystem
for us to write out all data and wait for it.  No need to start another
asynchronous writenack inside ->put_super.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/linux-2.6/xfs_super.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_super.c	2010-06-19 11:54:54.072006021 +0200
+++ xfs/fs/xfs/linux-2.6/xfs_super.c	2010-06-19 12:26:48.388003856 +0200
@@ -1160,18 +1160,6 @@ xfs_fs_put_super(
 
 	xfs_syncd_stop(mp);
 
-	if (!(sb->s_flags & MS_RDONLY)) {
-		/*
-		 * XXX(hch): this should be SYNC_WAIT.
-		 *
-		 * Or more likely not needed at all because the VFS is already
-		 * calling ->sync_fs after shutting down all filestem
-		 * operations and just before calling ->put_super.
-		 */
-		xfs_sync_data(mp, 0);
-		xfs_sync_attr(mp, 0);
-	}
-
 	/*
 	 * Blow away any referenced inode in the filestreams cache.
 	 * This can and will cause log traffic as inodes go inactive
Index: xfs/fs/xfs/linux-2.6/xfs_sync.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_sync.c	2010-06-19 10:41:57.626004207 +0200
+++ xfs/fs/xfs/linux-2.6/xfs_sync.c	2010-06-19 12:26:48.389003298 +0200
@@ -274,7 +274,7 @@ xfs_sync_inode_attr(
 /*
  * Write out pagecache data for the whole filesystem.
  */
-int
+STATIC int
 xfs_sync_data(
 	struct xfs_mount	*mp,
 	int			flags)
@@ -295,7 +295,7 @@ xfs_sync_data(
 /*
  * Write out inode metadata (attributes) for the whole filesystem.
  */
-int
+STATIC int
 xfs_sync_attr(
 	struct xfs_mount	*mp,
 	int			flags)
Index: xfs/fs/xfs/linux-2.6/xfs_sync.h
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_sync.h	2010-06-19 10:41:57.647253683 +0200
+++ xfs/fs/xfs/linux-2.6/xfs_sync.h	2010-06-19 12:26:48.391003717 +0200
@@ -35,9 +35,6 @@ typedef struct xfs_sync_work {
 int xfs_syncd_init(struct xfs_mount *mp);
 void xfs_syncd_stop(struct xfs_mount *mp);
 
-int xfs_sync_attr(struct xfs_mount *mp, int flags);
-int xfs_sync_data(struct xfs_mount *mp, int flags);
-
 int xfs_quiesce_data(struct xfs_mount *mp);
 void xfs_quiesce_attr(struct xfs_mount *mp);
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
