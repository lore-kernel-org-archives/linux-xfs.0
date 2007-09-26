Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 26 Sep 2007 01:24:00 -0700 (PDT)
Received: from mail.lst.de (verein.lst.de [213.95.11.210])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id l8Q8NsKd030954
	for <xfs@oss.sgi.com>; Wed, 26 Sep 2007 01:23:56 -0700
Date: Wed, 26 Sep 2007 10:23:52 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 1/2] kill xfs_freeze
Message-ID: <20070926082351.GA32719@lst.de>
References: <20070925194528.GA1818@lst.de> <46F9A38E.6000200@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46F9A38E.6000200@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Donald Douwsma <donaldd@sgi.com>
Cc: Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

> This has removed all use of xfs_freeze, but I cant see a diff
> hunk that removes the xfs_freeze implementation from xfs_vfsops.c

Looks like that hunk got lost in a merge.  Here's an updated version
of the patch that actually removes xfs_freeze:


Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_super.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_super.c	2007-09-25 15:04:01.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_super.c	2007-09-26 10:13:54.000000000 +0200
@@ -41,6 +41,7 @@
 #include "xfs_rtalloc.h"
 #include "xfs_error.h"
 #include "xfs_itable.h"
+#include "xfs_fsops.h"
 #include "xfs_rw.h"
 #include "xfs_acl.h"
 #include "xfs_attr.h"
@@ -684,11 +685,19 @@ xfs_fs_remount(
 	return -error;
 }
 
+/*
+ * Second stage of a freeze. The data is already frozen so we only
+ * need to take care of themetadata. Once that's done write a dummy
+ * record to dirty the log in case of a crash while frozen.
+ */
 STATIC void
 xfs_fs_lockfs(
 	struct super_block	*sb)
 {
-	xfs_freeze(XFS_M(sb));
+	struct xfs_mount	*mp = XFS_M(sb);
+
+	xfs_attr_quiesce(mp);
+	xfs_fs_log_dummy(mp);
 }
 
 STATIC int
Index: linux-2.6-xfs/fs/xfs/xfs_vfsops.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_vfsops.c	2007-09-25 15:04:01.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_vfsops.c	2007-09-26 10:14:07.000000000 +0200
@@ -692,7 +692,7 @@ xfs_quiesce_fs(
  * care of the metadata. New transactions are already blocked, so we need to
  * wait for any remaining transactions to drain out before proceding.
  */
-STATIC void
+void
 xfs_attr_quiesce(
 	xfs_mount_t	*mp)
 {
@@ -1955,16 +1955,3 @@ xfs_showargs(
 		seq_puts(m, "," MNTOPT_DMAPI);
 	return 0;
 }
-
-/*
- * Second stage of a freeze. The data is already frozen so we only
- * need to take care of themetadata. Once that's done write a dummy
- * record to dirty the log in case of a crash while frozen.
- */
-void
-xfs_freeze(
-	xfs_mount_t	*mp)
-{
-	xfs_attr_quiesce(mp);
-	xfs_fs_log_dummy(mp);
-}
Index: linux-2.6-xfs/fs/xfs/xfs_vfsops.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_vfsops.h	2007-09-25 15:04:01.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_vfsops.h	2007-09-26 10:13:54.000000000 +0200
@@ -21,8 +21,8 @@ int xfs_vget(struct xfs_mount *mp, bhv_v
 int xfs_parseargs(struct xfs_mount *mp, char *options,
 		struct xfs_mount_args *args, int update);
 int xfs_showargs(struct xfs_mount *mp, struct seq_file *m);
-void xfs_freeze(struct xfs_mount *mp);
 void xfs_do_force_shutdown(struct xfs_mount *mp, int flags, char *fname,
 		int lnnum);
+void xfs_attr_quiesce(struct xfs_mount *mp);
 
 #endif /* _XFS_VFSOPS_H */
