Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 25 Sep 2007 12:45:33 -0700 (PDT)
Received: from mail.lst.de (verein.lst.de [213.95.11.210])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l8PJjQQ3008683
	for <xfs@oss.sgi.com>; Tue, 25 Sep 2007 12:45:30 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by mail.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id l8PJjSA5001857
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Tue, 25 Sep 2007 21:45:28 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id l8PJjSnA001855
	for xfs@oss.sgi.com; Tue, 25 Sep 2007 21:45:28 +0200
Date: Tue, 25 Sep 2007 21:45:28 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 1/2] kill xfs_freeze
Message-ID: <20070925194528.GA1818@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

No need to have a wrapper just two call two more functions.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_super.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_super.c	2007-09-23 13:54:35.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_super.c	2007-09-23 13:56:12.000000000 +0200
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
--- linux-2.6-xfs.orig/fs/xfs/xfs_vfsops.c	2007-09-23 13:54:35.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_vfsops.c	2007-09-23 13:56:12.000000000 +0200
@@ -692,7 +692,7 @@ xfs_quiesce_fs(
  * care of the metadata. New transactions are already blocked, so we need to
  * wait for any remaining transactions to drain out before proceding.
  */
-STATIC void
+void
 xfs_attr_quiesce(
 	xfs_mount_t	*mp)
 {
Index: linux-2.6-xfs/fs/xfs/xfs_vfsops.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_vfsops.h	2007-09-23 13:56:16.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_vfsops.h	2007-09-23 13:56:34.000000000 +0200
@@ -21,8 +21,8 @@ int xfs_vget(struct xfs_mount *mp, bhv_v
 int xfs_parseargs(struct xfs_mount *mp, char *options,
 		struct xfs_mount_args *args, int update);
 int xfs_showargs(struct xfs_mount *mp, struct seq_file *m);
-void xfs_freeze(struct xfs_mount *mp);
 void xfs_do_force_shutdown(struct xfs_mount *mp, int flags, char *fname,
 		int lnnum);
+void xfs_attr_quiesce(struct xfs_mount *mp);
 
 #endif /* _XFS_VFSOPS_H */
