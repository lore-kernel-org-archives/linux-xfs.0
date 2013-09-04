Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 987A029DFC
	for <xfs@oss.sgi.com>; Wed,  4 Sep 2013 17:21:33 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 88C2D8F8033
	for <xfs@oss.sgi.com>; Wed,  4 Sep 2013 15:21:33 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	zkta0HAuSJt0AnIL for <xfs@oss.sgi.com>;
	Wed, 04 Sep 2013 15:21:32 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1VHLDA-0007dz-6E
	for xfs@oss.sgi.com; Thu, 05 Sep 2013 08:06:04 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1VHLDA-0003tw-5b
	for xfs@oss.sgi.com; Thu, 05 Sep 2013 08:06:04 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 35/55] xfs: move swap extent code to xfs_extent_ops
Date: Thu,  5 Sep 2013 08:05:39 +1000
Message-Id: <1378332359-14737-36-git-send-email-david@fromorbit.com>
In-Reply-To: <1378332359-14737-1-git-send-email-david@fromorbit.com>
References: <1378332359-14737-1-git-send-email-david@fromorbit.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

Swapping extents is clearly an extent operaiton, and it is not
shared with userspace. Move the code to xfs_extent_ops.[ch], and
the userspace ioctl structure definition to xfs_fs.h where most of
the other ioctl structure definitions are. The means xfs_dfrag.h is
no longer needed in userspace.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fsr/xfs_fsr.c       |  1 -
 include/Makefile    |  3 +--
 include/xfs_dfrag.h | 53 -----------------------------------------------------
 include/xfs_fs.h    | 15 +++++++++++++++
 4 files changed, 16 insertions(+), 56 deletions(-)
 delete mode 100644 include/xfs_dfrag.h

diff --git a/fsr/xfs_fsr.c b/fsr/xfs_fsr.c
index 7e518c1..7596834 100644
--- a/fsr/xfs_fsr.c
+++ b/fsr/xfs_fsr.c
@@ -20,7 +20,6 @@
 #include <xfs/xfs.h>
 #include <xfs/xfs_types.h>
 #include <xfs/jdm.h>
-#include <xfs/xfs_dfrag.h>
 #include <xfs/xfs_bmap_btree.h>
 #include <xfs/xfs_dinode.h>
 #include <xfs/xfs_attr_sf.h>
diff --git a/include/Makefile b/include/Makefile
index 45b8533..628a087 100644
--- a/include/Makefile
+++ b/include/Makefile
@@ -40,8 +40,7 @@ QAHFILES = libxfs.h libxlog.h \
 	xfs_sb.h \
 	xfs_trace.h \
 	xfs_trans_resv.h \
-	xfs_trans_space.h \
-	xfs_dfrag.h
+	xfs_trans_space.h
 
 HFILES = handle.h jdm.h xqm.h xfs.h xfs_fs.h xfs_types.h
 HFILES += $(PKG_PLATFORM).h
diff --git a/include/xfs_dfrag.h b/include/xfs_dfrag.h
deleted file mode 100644
index 20bdd93..0000000
--- a/include/xfs_dfrag.h
+++ /dev/null
@@ -1,53 +0,0 @@
-/*
- * Copyright (c) 2000,2005 Silicon Graphics, Inc.
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
-#ifndef __XFS_DFRAG_H__
-#define	__XFS_DFRAG_H__
-
-/*
- * Structure passed to xfs_swapext
- */
-
-typedef struct xfs_swapext
-{
-	__int64_t	sx_version;	/* version */
-	__int64_t	sx_fdtarget;	/* fd of target file */
-	__int64_t	sx_fdtmp;	/* fd of tmp file */
-	xfs_off_t	sx_offset;	/* offset into file */
-	xfs_off_t	sx_length;	/* leng from offset */
-	char		sx_pad[16];	/* pad space, unused */
-	xfs_bstat_t	sx_stat;	/* stat of target b4 copy */
-} xfs_swapext_t;
-
-/*
- * Version flag
- */
-#define XFS_SX_VERSION		0
-
-#ifdef __KERNEL__
-/*
- * Prototypes for visible xfs_dfrag.c routines.
- */
-
-/*
- * Syscall interface for xfs_swapext
- */
-int	xfs_swapext(struct xfs_swapext *sx);
-
-#endif	/* __KERNEL__ */
-
-#endif	/* __XFS_DFRAG_H__ */
diff --git a/include/xfs_fs.h b/include/xfs_fs.h
index 68c2e18..74b24b2 100644
--- a/include/xfs_fs.h
+++ b/include/xfs_fs.h
@@ -461,6 +461,21 @@ typedef struct xfs_handle {
 				 + (handle).ha_fid.fid_len)
 
 /*
+ * Structure passed to XFS_IOC_SWAPEXT
+ */
+typedef struct xfs_swapext
+{
+	__int64_t	sx_version;	/* version */
+#define XFS_SX_VERSION		0
+	__int64_t	sx_fdtarget;	/* fd of target file */
+	__int64_t	sx_fdtmp;	/* fd of tmp file */
+	xfs_off_t	sx_offset;	/* offset into file */
+	xfs_off_t	sx_length;	/* leng from offset */
+	char		sx_pad[16];	/* pad space, unused */
+	xfs_bstat_t	sx_stat;	/* stat of target b4 copy */
+} xfs_swapext_t;
+
+/*
  * Flags for going down operation
  */
 #define XFS_FSOP_GOING_FLAGS_DEFAULT		0x0	/* going down */
-- 
1.8.3.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
