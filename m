Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n4QK0Aqr158291 for <xfs@oss.sgi.com>; Tue, 26 May 2009 15:00:10 -0500
Received: from mx2.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 921F91A1F90F
	for <xfs@oss.sgi.com>; Tue, 26 May 2009 13:00:22 -0700 (PDT)
Received: from mx2.redhat.com (mx2.redhat.com [66.187.237.31]) by cuda.sgi.com
	with ESMTP id orMPQribCikoy2AR for <xfs@oss.sgi.com>;
	Tue, 26 May 2009 13:00:22 -0700 (PDT)
Message-ID: <4A1C4A44.1030309@sandeen.net>
Date: Tue, 26 May 2009 15:00:04 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH V2] drop xfs_version.h
References: <4A1C449E.7070004@sandeen.net>
	<20090526195140.GA4368@infradead.org>
In-Reply-To: <20090526195140.GA4368@infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs mailing list <xfs@oss.sgi.com>

xfs_version.h is about 30 lines for the benefit of 
one single define, which seems a bit silly.

Just drop the file and hardcode "SGI XFS" the 2 
places it's used.

v2: merge together 2 now-shorter lines.

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---

 fs/xfs/linux-2.6/xfs_version.h         |   29 -----------------
 linux-2.6/fs/xfs/linux-2.6/xfs_super.c |    6 +---
 2 files changed, 2 insertions(+), 33 deletions(-)

Index: linux-2.6/fs/xfs/linux-2.6/xfs_super.c
===================================================================
--- linux-2.6.orig/fs/xfs/linux-2.6/xfs_super.c
+++ linux-2.6/fs/xfs/linux-2.6/xfs_super.c
@@ -48,7 +48,6 @@
 #include "xfs_buf_item.h"
 #include "xfs_utils.h"
 #include "xfs_vnodeops.h"
-#include "xfs_version.h"
 #include "xfs_log_priv.h"
 #include "xfs_trans_priv.h"
 #include "xfs_filestream.h"
@@ -1788,8 +1787,7 @@ init_xfs_fs(void)
 {
 	int			error;
 
-	printk(KERN_INFO XFS_VERSION_STRING " with "
-			 XFS_BUILD_OPTIONS " enabled\n");
+	printk(KERN_INFO "SGI XFS with " XFS_BUILD_OPTIONS " enabled\n");
 
 	ktrace_init(64);
 	xfs_ioend_init();
@@ -1867,5 +1865,5 @@ module_init(init_xfs_fs);
 module_exit(exit_xfs_fs);
 
 MODULE_AUTHOR("Silicon Graphics, Inc.");
-MODULE_DESCRIPTION(XFS_VERSION_STRING " with " XFS_BUILD_OPTIONS " enabled");
+MODULE_DESCRIPTION("SGI XFS with " XFS_BUILD_OPTIONS " enabled");
 MODULE_LICENSE("GPL");
Index: linux-2.6/fs/xfs/linux-2.6/xfs_version.h
===================================================================
--- linux-2.6.orig/fs/xfs/linux-2.6/xfs_version.h
+++ /dev/null
@@ -1,29 +0,0 @@
-/*
- * Copyright (c) 2001-2002,2005 Silicon Graphics, Inc.
- * All Rights Reserved.
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it would be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write the Free Software Foundation,
- * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
- */
-#ifndef __XFS_VERSION_H__
-#define __XFS_VERSION_H__
-
-/*
- * Dummy file that can contain a timestamp to put into the
- * XFS init string, to help users keep track of what they're
- * running
- */
-
-#define XFS_VERSION_STRING "SGI XFS"
-
-#endif /* __XFS_VERSION_H__ */

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
