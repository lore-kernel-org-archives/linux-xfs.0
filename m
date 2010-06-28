Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o5SM1kNb044141 for <xfs@oss.sgi.com>; Mon, 28 Jun 2010 17:01:47 -0500
From: Alex Elder <aelder@sgi.com>
Message-Id: <201006282204.o5SM4W1o018105@stout.americas.sgi.com>
Date: Mon, 28 Jun 2010 17:04:32 -0500
Subject: [PATCH 01/15] xfs: kill off "xfs_dmapi_priv.h"
MIME-Version: 1.0
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
To: xfs@oss.sgi.com

The file "fs/xfs/linux-2.6/xfs_dmapi_priv.h" only two definitions,
and those are used only once each in non-DMAPI XFS code.  Get rid of
those definitions--as well as the file--and use their expansions
in the place they're used instead.

Signed-off-by: Alex Elder <aelder@sgi.com>

---
 fs/xfs/linux-2.6/xfs_dmapi_priv.h |   28 ----------------------------
 fs/xfs/linux-2.6/xfs_file.c       |    6 ++++--
 fs/xfs/xfs_dmapi.h                |    7 +------
 fs/xfs/xfs_vnodeops.c             |    6 ++++--
 4 files changed, 9 insertions(+), 38 deletions(-)

Index: b/fs/xfs/linux-2.6/xfs_dmapi_priv.h
===================================================================
--- a/fs/xfs/linux-2.6/xfs_dmapi_priv.h
+++ /dev/null
@@ -1,28 +0,0 @@
-/*
- * Copyright (c) 2000-2006 Silicon Graphics, Inc.
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
-#ifndef __XFS_DMAPI_PRIV_H__
-#define __XFS_DMAPI_PRIV_H__
-
-/*
- *	Based on IO_ISDIRECT, decide which i_ flag is set.
- */
-#define DM_SEM_FLAG_RD(ioflags) (((ioflags) & IO_ISDIRECT) ? \
-			      DM_FLAGS_IMUX : 0)
-#define DM_SEM_FLAG_WR	(DM_FLAGS_IALLOCSEM_WR | DM_FLAGS_IMUX)
-
-#endif /*__XFS_DMAPI_PRIV_H__*/
Index: b/fs/xfs/linux-2.6/xfs_file.c
===================================================================
--- a/fs/xfs/linux-2.6/xfs_file.c
+++ b/fs/xfs/linux-2.6/xfs_file.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2000-2005 Silicon Graphics, Inc.
+ * Copyright (c) 2000-2005, SGI
  * All Rights Reserved.
  *
  * This program is free software; you can redistribute it and/or
@@ -276,9 +276,11 @@ xfs_file_aio_read(
 	xfs_ilock(ip, XFS_IOLOCK_SHARED);
 
 	if (DM_EVENT_ENABLED(ip, DM_EVENT_READ) && !(ioflags & IO_INVIS)) {
-		int dmflags = FILP_DELAY_FLAG(file) | DM_SEM_FLAG_RD(ioflags);
 		int iolock = XFS_IOLOCK_SHARED;
+		int dmflags = FILP_DELAY_FLAG(file);
 
+		if (ioflags & IO_ISDIRECT)
+		    	dmflags |= DM_FLAGS_IMUX;
 		ret = -XFS_SEND_DATA(mp, DM_EVENT_READ, ip, iocb->ki_pos, size,
 					dmflags, &iolock);
 		if (ret) {
Index: b/fs/xfs/xfs_dmapi.h
===================================================================
--- a/fs/xfs/xfs_dmapi.h
+++ b/fs/xfs/xfs_dmapi.h
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2000-2005 Silicon Graphics, Inc.
+ * Copyright (c) 2000-2005, 2010 SGI
  * All Rights Reserved.
  *
  * This program is free software; you can redistribute it and/or
@@ -154,11 +154,6 @@ typedef enum {
 #define DM_FLAGS_IALLOCSEM_WR	0x020	/* thread holds i_alloc_sem wr */
 
 /*
- *	Pull in platform specific event flags defines
- */
-#include "xfs_dmapi_priv.h"
-
-/*
  *	Macros to turn caller specified delay/block flags into
  *	dm_send_xxxx_event flag DM_FLAGS_NDELAY.
  */
Index: b/fs/xfs/xfs_vnodeops.c
===================================================================
--- a/fs/xfs/xfs_vnodeops.c
+++ b/fs/xfs/xfs_vnodeops.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2000-2006 Silicon Graphics, Inc.
+ * Copyright (c) 2000-2006, 2010 SGI
  * All Rights Reserved.
  *
  * This program is free software; you can redistribute it and/or
@@ -145,7 +145,9 @@ xfs_setattr(
 	} else {
 		if (DM_EVENT_ENABLED(ip, DM_EVENT_TRUNCATE) &&
 		    !(flags & XFS_ATTR_DMI)) {
-			int dmflags = AT_DELAY_FLAG(flags) | DM_SEM_FLAG_WR;
+			int dmflags = AT_DELAY_FLAG(flags);
+
+			dmflags |= DM_FLAGS_IALLOCSEM_WR|DM_FLAGS_IMUX;
 			code = XFS_SEND_DATA(mp, DM_EVENT_TRUNCATE, ip,
 				iattr->ia_size, 0, dmflags, NULL);
 			if (code) {

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
