Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 27 Oct 2008 06:33:49 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9RDXcvs020695
	for <xfs@oss.sgi.com>; Mon, 27 Oct 2008 06:33:38 -0700
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E91A2ADEB97
	for <xfs@oss.sgi.com>; Mon, 27 Oct 2008 06:33:37 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34]) by cuda.sgi.com with ESMTP id 0Zi4yhRIjEV3nIN7 for <xfs@oss.sgi.com>; Mon, 27 Oct 2008 06:33:37 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.68 #1 (Red Hat Linux))
	id 1KuSDx-00086a-9f
	for xfs@oss.sgi.com; Mon, 27 Oct 2008 13:33:37 +0000
Date: Mon, 27 Oct 2008 09:33:37 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 3/3] remove xfs_vfsops.h
Message-ID: <20081027133337.GD31125@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="xfs-kill-xfs_vfsops.h"
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

The only think left is xfs_do_force_shutdown which already has a defintion
in xfs_mount.h, too.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/dmapi/xfs_dm.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/dmapi/xfs_dm.c	2008-10-15 18:21:53.000000000 -0400
+++ linux-2.6-xfs/fs/xfs/dmapi/xfs_dm.c	2008-10-15 18:22:07.000000000 -0400
@@ -45,7 +45,6 @@
 #include "xfs_attr.h"
 #include "xfs_attr_leaf.h"
 #include "xfs_inode_item.h"
-#include "xfs_vfsops.h"
 #include "xfs_vnodeops.h"
 #include <dmapi.h>
 #include <dmapi_kern.h>
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_export.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_export.c	2008-10-15 18:21:53.000000000 -0400
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_export.c	2008-10-15 18:21:59.000000000 -0400
@@ -29,7 +29,6 @@
 #include "xfs_vnodeops.h"
 #include "xfs_bmap_btree.h"
 #include "xfs_inode.h"
-#include "xfs_vfsops.h"
 
 /*
  * Note that we only accept fileids which are long enough rather than allow
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ksyms.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_ksyms.c	2008-10-15 18:21:53.000000000 -0400
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ksyms.c	2008-10-15 18:22:03.000000000 -0400
@@ -64,7 +64,6 @@
 #include "xfs_iomap.h"
 #include "xfs_filestream.h"
 #include "xfs_vnodeops.h"
-#include "xfs_vfsops.h"
 #include "support/ktrace.h"
 
 
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_super.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_super.c	2008-10-15 18:21:53.000000000 -0400
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_super.c	2008-10-15 18:22:01.000000000 -0400
@@ -48,7 +48,6 @@
 #include "xfs_buf_item.h"
 #include "xfs_utils.h"
 #include "xfs_vnodeops.h"
-#include "xfs_vfsops.h"
 #include "xfs_version.h"
 #include "xfs_log_priv.h"
 #include "xfs_trans_priv.h"
Index: linux-2.6-xfs/fs/xfs/xfs_vfsops.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_vfsops.c	2008-10-15 18:21:53.000000000 -0400
+++ linux-2.6-xfs/fs/xfs/xfs_vfsops.c	2008-10-15 18:22:05.000000000 -0400
@@ -53,7 +53,6 @@
 #include "xfs_filestream.h"
 #include "xfs_fsops.h"
 #include "xfs_vnodeops.h"
-#include "xfs_vfsops.h"
 #include "xfs_utils.h"
 #include "xfs_sync.h"
 
Index: linux-2.6-xfs/fs/xfs/xfs_vfsops.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_vfsops.h	2008-10-15 18:21:09.000000000 -0400
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,14 +0,0 @@
-#ifndef _XFS_VFSOPS_H
-#define _XFS_VFSOPS_H 1
-
-struct cred;
-struct xfs_fid;
-struct inode;
-struct kstatfs;
-struct xfs_mount;
-struct xfs_mount_args;
-
-void xfs_do_force_shutdown(struct xfs_mount *mp, int flags, char *fname,
-		int lnnum);
-
-#endif /* _XFS_VFSOPS_H */

-- 
