Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 19 Jul 2007 21:12:25 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l6K4CLbm027940
	for <xfs@oss.sgi.com>; Thu, 19 Jul 2007 21:12:22 -0700
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTP id 44AEB1801056F
	for <xfs@oss.sgi.com>; Thu, 19 Jul 2007 23:12:24 -0500 (CDT)
Message-ID: <46A03628.1070704@sandeen.net>
Date: Thu, 19 Jul 2007 23:12:24 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH 5/7] - move linux/log2.h header to xfs_linux.h
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-oss <xfs@oss.sgi.com>

Generally we try not to directly include linux header files
in core xfs code; xfs_linux.h is the spot for that.

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>

Index: linux/fs/xfs/linux-2.4/xfs_linux.h
===================================================================
--- linux.orig/fs/xfs/linux-2.4/xfs_linux.h
+++ linux/fs/xfs/linux-2.4/xfs_linux.h
@@ -93,6 +93,7 @@ typedef unsigned int gfp_t;
 #include <linux/init.h>
 #include <linux/list.h>
 #include <linux/proc_fs.h>
+#include <linux/log2.h>
 
 #include <asm/page.h>
 #include <asm/div64.h>
Index: linux/fs/xfs/linux-2.6/xfs_linux.h
===================================================================
--- linux.orig/fs/xfs/linux-2.6/xfs_linux.h
+++ linux/fs/xfs/linux-2.6/xfs_linux.h
@@ -75,6 +75,7 @@
 #include <linux/cpu.h>
 #include <linux/notifier.h>
 #include <linux/delay.h>
+#include <linux/log2.h>
 
 #include <asm/page.h>
 #include <asm/div64.h>
Index: linux/fs/xfs/xfs_inode.c
===================================================================
--- linux.orig/fs/xfs/xfs_inode.c
+++ linux/fs/xfs/xfs_inode.c
@@ -50,8 +50,6 @@
 #include "xfs_acl.h"
 #include "xfs_filestream.h"
 
-#include <linux/log2.h>
-
 kmem_zone_t *xfs_ifork_zone;
 kmem_zone_t *xfs_inode_zone;
 kmem_zone_t *xfs_chashlist_zone;
