Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o96IeMeE110151 for <xfs@oss.sgi.com>; Wed, 6 Oct 2010 13:40:22 -0500
Received: from canuck.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BFC404EB25C
	for <xfs@oss.sgi.com>; Wed,  6 Oct 2010 11:41:26 -0700 (PDT)
Received: from canuck.infradead.org (canuck.infradead.org [134.117.69.58]) by
	cuda.sgi.com with ESMTP id x6265rabbwHQBcmQ for
	<xfs@oss.sgi.com>; Wed, 06 Oct 2010 11:41:26 -0700 (PDT)
Received: from hch by canuck.infradead.org with local (Exim 4.72 #1 (Red Hat
	Linux)) id 1P3Yve-00019j-A0
	for xfs@oss.sgi.com; Wed, 06 Oct 2010 18:41:26 +0000
Message-Id: <20101006184126.161666009@localhost.localdomain>
Date: Wed, 06 Oct 2010 14:41:15 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 4/7] xfs: remove xfs_version.h
References: <20101006184111.634126439@localhost.localdomain>
Content-Disposition: inline; filename=xfs-kill-version.h
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

It used to have a place when it contained an automatically generated CVS
version, but these days it's entirely superflous.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/linux-2.6/xfs_super.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_super.c	2010-09-29 07:54:47.649262102 +0900
+++ xfs/fs/xfs/linux-2.6/xfs_super.c	2010-09-29 07:55:42.216005782 +0900
@@ -44,7 +44,6 @@
 #include "xfs_buf_item.h"
 #include "xfs_utils.h"
 #include "xfs_vnodeops.h"
-#include "xfs_version.h"
 #include "xfs_log_priv.h"
 #include "xfs_trans_priv.h"
 #include "xfs_filestream.h"
Index: xfs/fs/xfs/linux-2.6/xfs_super.h
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_super.h	2010-09-29 07:55:15.945003267 +0900
+++ xfs/fs/xfs/linux-2.6/xfs_super.h	2010-09-29 07:55:25.893021010 +0900
@@ -62,6 +62,7 @@ extern void xfs_qm_exit(void);
 # define XFS_DBG_STRING		"no debug"
 #endif
 
+#define XFS_VERSION_STRING	"SGI XFS"
 #define XFS_BUILD_OPTIONS	XFS_ACL_STRING \
 				XFS_SECURITY_STRING \
 				XFS_REALTIME_STRING \
Index: xfs/fs/xfs/linux-2.6/xfs_version.h
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_version.h	2010-09-29 07:54:47.640253372 +0900
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
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
