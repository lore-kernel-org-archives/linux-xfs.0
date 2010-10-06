Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o96IeM9C110154 for <xfs@oss.sgi.com>; Wed, 6 Oct 2010 13:40:23 -0500
Received: from canuck.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D93131C01E4E
	for <xfs@oss.sgi.com>; Wed,  6 Oct 2010 11:41:26 -0700 (PDT)
Received: from canuck.infradead.org (canuck.infradead.org [134.117.69.58]) by
	cuda.sgi.com with ESMTP id QFhlxeh9KtN4uHG8 for
	<xfs@oss.sgi.com>; Wed, 06 Oct 2010 11:41:26 -0700 (PDT)
Received: from hch by canuck.infradead.org with local (Exim 4.72 #1 (Red Hat
	Linux)) id 1P3Yve-0001AF-IQ
	for xfs@oss.sgi.com; Wed, 06 Oct 2010 18:41:26 +0000
Message-Id: <20101006184126.419695420@localhost.localdomain>
Date: Wed, 06 Oct 2010 14:41:16 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 5/7] xfs: remove xfs_globals.h
References: <20101006184111.634126439@localhost.localdomain>
Content-Disposition: inline; filename=xfs-kill-globals.h
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

This header only provides one extern that isn't actually declared anywhere,
and shadowed by a macro.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/linux-2.6/xfs_globals.h
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_globals.h	2010-09-29 07:57:15.590003897 +0900
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,23 +0,0 @@
-/*
- * Copyright (c) 2000-2003,2005 Silicon Graphics, Inc.
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
-#ifndef __XFS_GLOBALS_H__
-#define __XFS_GLOBALS_H__
-
-extern uint64_t	xfs_panic_mask;		/* set to cause more panics */
-
-#endif	/* __XFS_GLOBALS_H__ */
Index: xfs/fs/xfs/linux-2.6/xfs_linux.h
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_linux.h	2010-09-29 07:57:06.876003478 +0900
+++ xfs/fs/xfs/linux-2.6/xfs_linux.h	2010-09-29 07:57:10.675215517 +0900
@@ -86,7 +86,6 @@
 #include <xfs_iops.h>
 #include <xfs_aops.h>
 #include <xfs_super.h>
-#include <xfs_globals.h>
 #include <xfs_buf.h>
 
 /*

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
