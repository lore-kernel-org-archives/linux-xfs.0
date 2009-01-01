Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n01Mewdh031892 for <xfs@oss.sgi.com>; Thu, 1 Jan 2009 16:40:58 -0600
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E1BFB58670
	for <xfs@oss.sgi.com>; Thu,  1 Jan 2009 14:40:56 -0800 (PST)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id 0cvBYdAFE0zBvxin for
	<xfs@oss.sgi.com>; Thu, 01 Jan 2009 14:40:56 -0800 (PST)
Message-Id: <20090101224056.845580476@sandeen.net>
References: <20090101224009.616367334@sandeen.net>
Date: Thu, 01 Jan 2009 16:40:10 -0600
From: Eric Sandeen <sandeen@sandeen.net>
Subject: [patch 1/4] Remove several unused typedefs.
Content-Disposition: inline; filename=unused_typedefs
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---

Index: xfs/fs/xfs/linux-2.6/xfs_aops.h
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_aops.h
+++ xfs/fs/xfs/linux-2.6/xfs_aops.h
@@ -21,8 +21,6 @@
 extern struct workqueue_struct *xfsdatad_workqueue;
 extern mempool_t *xfs_ioend_pool;
 
-typedef void (*xfs_ioend_func_t)(void *);
-
 /*
  * xfs_ioend struct manages large extent writes for XFS.
  * It can manage several multi-page bio's at once.
Index: xfs/fs/xfs/xfs_acl.h
===================================================================
--- xfs.orig/fs/xfs/xfs_acl.h
+++ xfs/fs/xfs/xfs_acl.h
@@ -22,7 +22,6 @@
  * Access Control Lists
  */
 typedef __uint16_t	xfs_acl_perm_t;
-typedef __int32_t	xfs_acl_type_t;
 typedef __int32_t	xfs_acl_tag_t;
 typedef __int32_t	xfs_acl_id_t;
 
Index: xfs/fs/xfs/xfs_types.h
===================================================================
--- xfs.orig/fs/xfs/xfs_types.h
+++ xfs/fs/xfs/xfs_types.h
@@ -111,8 +111,6 @@ typedef __uint64_t	xfs_fileoff_t;	/* blo
 typedef __int64_t	xfs_sfiloff_t;	/* signed block number in a file */
 typedef __uint64_t	xfs_filblks_t;	/* number of blocks in a file */
 
-typedef __uint8_t	xfs_arch_t;	/* architecture of an xfs fs */
-
 /*
  * Null values for the types.
  */

-- 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
