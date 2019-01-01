Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:42862 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728225AbfAACTQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 31 Dec 2018 21:19:16 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id x012Ehmt019070
        for <linux-xfs@vger.kernel.org>; Tue, 1 Jan 2019 02:19:14 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp2130.oracle.com with ESMTP id 2pp0btp78y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 01 Jan 2019 02:19:14 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x012J8Hs024017
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 1 Jan 2019 02:19:09 GMT
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x012J8II026833
        for <linux-xfs@vger.kernel.org>; Tue, 1 Jan 2019 02:19:08 GMT
Subject: [PATCH 01/22] xfs: hoist extent size helpers to libxfs
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 31 Dec 2018 18:19:07 -0800
Message-ID: <154630914753.18437.17751711685826124435.stgit@magnolia>
In-Reply-To: <154630914104.18437.15354380637179830566.stgit@magnolia>
References: <154630914104.18437.15354380637179830566.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Create a new xfs_inode_utils.c file in libxfs and hoist the extent size
helper functions to libxfs, since they pertain directly to inode
functionality.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/Makefile                |    1 +
 fs/xfs/libxfs/xfs_bmap.c       |    2 +-
 fs/xfs/libxfs/xfs_inode_util.c |   52 ++++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_inode_util.h |   12 +++++++++
 fs/xfs/xfs_inode.c             |   37 ----------------------------
 fs/xfs/xfs_inode.h             |    4 +--
 6 files changed, 67 insertions(+), 41 deletions(-)
 create mode 100644 fs/xfs/libxfs/xfs_inode_util.c
 create mode 100644 fs/xfs/libxfs/xfs_inode_util.h


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index fd658fce9a63..ab373aeb0c37 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -48,6 +48,7 @@ xfs-y				+= $(addprefix libxfs/, \
 				   xfs_iext_tree.o \
 				   xfs_inode_fork.o \
 				   xfs_inode_buf.o \
+				   xfs_inode_util.o \
 				   xfs_log_rlimit.o \
 				   xfs_ag_resv.o \
 				   xfs_rmap.o \
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 6471fdd843a1..e151685b57d3 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -39,7 +39,7 @@
 #include "xfs_ag_resv.h"
 #include "xfs_refcount.h"
 #include "xfs_icache.h"
-
+#include "xfs_inode_util.h"
 
 kmem_zone_t		*xfs_bmap_free_item_zone;
 
diff --git a/fs/xfs/libxfs/xfs_inode_util.c b/fs/xfs/libxfs/xfs_inode_util.c
new file mode 100644
index 000000000000..f9fc2e60c91c
--- /dev/null
+++ b/fs/xfs/libxfs/xfs_inode_util.c
@@ -0,0 +1,52 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2000-2006 Silicon Graphics, Inc.
+ * All Rights Reserved.
+ */
+#include "xfs.h"
+#include "xfs_fs.h"
+#include "xfs_shared.h"
+#include "xfs_format.h"
+#include "xfs_log_format.h"
+#include "xfs_trans_resv.h"
+#include "xfs_sb.h"
+#include "xfs_mount.h"
+#include "xfs_inode.h"
+#include "xfs_inode_util.h"
+
+/*
+ * helper function to extract extent size hint from inode
+ */
+xfs_extlen_t
+xfs_get_extsz_hint(
+	struct xfs_inode	*ip)
+{
+	if ((ip->i_d.di_flags & XFS_DIFLAG_EXTSIZE) && ip->i_d.di_extsize)
+		return ip->i_d.di_extsize;
+	if (XFS_IS_REALTIME_INODE(ip))
+		return ip->i_mount->m_sb.sb_rextsize;
+	return 0;
+}
+
+/*
+ * Helper function to extract CoW extent size hint from inode.
+ * Between the extent size hint and the CoW extent size hint, we
+ * return the greater of the two.  If the value is zero (automatic),
+ * use the default size.
+ */
+xfs_extlen_t
+xfs_get_cowextsz_hint(
+	struct xfs_inode	*ip)
+{
+	xfs_extlen_t		a, b;
+
+	a = 0;
+	if (ip->i_d.di_flags2 & XFS_DIFLAG2_COWEXTSIZE)
+		a = ip->i_d.di_cowextsize;
+	b = xfs_get_extsz_hint(ip);
+
+	a = max(a, b);
+	if (a == 0)
+		return XFS_DEFAULT_COWEXTSZ_HINT;
+	return a;
+}
diff --git a/fs/xfs/libxfs/xfs_inode_util.h b/fs/xfs/libxfs/xfs_inode_util.h
new file mode 100644
index 000000000000..98bae709dee8
--- /dev/null
+++ b/fs/xfs/libxfs/xfs_inode_util.h
@@ -0,0 +1,12 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2000-2003,2005 Silicon Graphics, Inc.
+ * All Rights Reserved.
+ */
+#ifndef	__XFS_INODE_UTIL_H__
+#define	__XFS_INODE_UTIL_H__
+
+xfs_extlen_t	xfs_get_extsz_hint(struct xfs_inode *ip);
+xfs_extlen_t	xfs_get_cowextsz_hint(struct xfs_inode *ip);
+
+#endif /* __XFS_INODE_UTIL_H__ */
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 2c7f8aeffa92..9774f1ecdd35 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -50,43 +50,6 @@ STATIC int xfs_iflush_int(struct xfs_inode *, struct xfs_buf *);
 STATIC int xfs_iunlink(struct xfs_trans *, struct xfs_inode *);
 STATIC int xfs_iunlink_remove(struct xfs_trans *, struct xfs_inode *);
 
-/*
- * helper function to extract extent size hint from inode
- */
-xfs_extlen_t
-xfs_get_extsz_hint(
-	struct xfs_inode	*ip)
-{
-	if ((ip->i_d.di_flags & XFS_DIFLAG_EXTSIZE) && ip->i_d.di_extsize)
-		return ip->i_d.di_extsize;
-	if (XFS_IS_REALTIME_INODE(ip))
-		return ip->i_mount->m_sb.sb_rextsize;
-	return 0;
-}
-
-/*
- * Helper function to extract CoW extent size hint from inode.
- * Between the extent size hint and the CoW extent size hint, we
- * return the greater of the two.  If the value is zero (automatic),
- * use the default size.
- */
-xfs_extlen_t
-xfs_get_cowextsz_hint(
-	struct xfs_inode	*ip)
-{
-	xfs_extlen_t		a, b;
-
-	a = 0;
-	if (ip->i_d.di_flags2 & XFS_DIFLAG2_COWEXTSIZE)
-		a = ip->i_d.di_cowextsize;
-	b = xfs_get_extsz_hint(ip);
-
-	a = max(a, b);
-	if (a == 0)
-		return XFS_DEFAULT_COWEXTSZ_HINT;
-	return a;
-}
-
 /*
  * These two are wrapper routines around the xfs_ilock() routine used to
  * centralize some grungy code.  They are used in places that wish to lock the
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index e95e30a94243..29aedfdf3d05 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -8,6 +8,7 @@
 
 #include "xfs_inode_buf.h"
 #include "xfs_inode_fork.h"
+#include "xfs_inode_util.h"
 
 /*
  * Kernel only inode definitions
@@ -446,9 +447,6 @@ int		xfs_iflush(struct xfs_inode *, struct xfs_buf **);
 void		xfs_lock_two_inodes(struct xfs_inode *ip0, uint ip0_mode,
 				struct xfs_inode *ip1, uint ip1_mode);
 
-xfs_extlen_t	xfs_get_extsz_hint(struct xfs_inode *ip);
-xfs_extlen_t	xfs_get_cowextsz_hint(struct xfs_inode *ip);
-
 int		xfs_dir_ialloc(struct xfs_trans **, struct xfs_inode *, umode_t,
 			       xfs_nlink_t, dev_t, prid_t,
 			       struct xfs_inode **);
