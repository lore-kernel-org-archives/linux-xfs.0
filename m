Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:25672 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751640AbdIUASJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 20 Sep 2017 20:18:09 -0400
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v8L0I9ta005203
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 21 Sep 2017 00:18:09 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id v8L0I9oH014411
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 21 Sep 2017 00:18:09 GMT
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id v8L0I8KM000889
        for <linux-xfs@vger.kernel.org>; Thu, 21 Sep 2017 00:18:09 GMT
Subject: [PATCH 05/27] xfs: test the scrub ioctl
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 20 Sep 2017 17:18:08 -0700
Message-ID: <150595308840.18473.7997837811162843403.stgit@magnolia>
In-Reply-To: <150595305131.18473.16572195821331601191.stgit@magnolia>
References: <150595305131.18473.16572195821331601191.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Create a test scrubber with id 0.  This will be used by xfs_scrub to
probe the kernel's abilities to scrub (and repair) the metadata.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/Makefile        |    1 +
 fs/xfs/libxfs/xfs_fs.h |    3 ++
 fs/xfs/scrub/common.c  |   60 ++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/common.h  |   44 +++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/scrub.c   |   33 ++++++++++++++++++++++++++
 fs/xfs/scrub/scrub.h   |    1 +
 fs/xfs/scrub/trace.c   |    1 +
 7 files changed, 142 insertions(+), 1 deletion(-)
 create mode 100644 fs/xfs/scrub/common.c
 create mode 100644 fs/xfs/scrub/common.h


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index f4312bc..ca14595 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -146,6 +146,7 @@ ifeq ($(CONFIG_XFS_ONLINE_SCRUB),y)
 
 xfs-y				+= $(addprefix scrub/, \
 				   trace.o \
+				   common.o \
 				   scrub.o \
 				   )
 endif
diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index a4b4c8c..5105bad 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -483,9 +483,10 @@ struct xfs_scrub_metadata {
  */
 
 /* Scrub subcommands. */
+#define XFS_SCRUB_TYPE_TEST	0	/* presence test ioctl */
 
 /* Number of scrub subcommands. */
-#define XFS_SCRUB_TYPE_NR	0
+#define XFS_SCRUB_TYPE_NR	1
 
 /* i: Repair this metadata. */
 #define XFS_SCRUB_IFLAG_REPAIR		(1 << 0)
diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
new file mode 100644
index 0000000..13ccb36
--- /dev/null
+++ b/fs/xfs/scrub/common.c
@@ -0,0 +1,60 @@
+/*
+ * Copyright (C) 2017 Oracle.  All Rights Reserved.
+ *
+ * Author: Darrick J. Wong <darrick.wong@oracle.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301, USA.
+ */
+#include "xfs.h"
+#include "xfs_fs.h"
+#include "xfs_shared.h"
+#include "xfs_format.h"
+#include "xfs_trans_resv.h"
+#include "xfs_mount.h"
+#include "xfs_defer.h"
+#include "xfs_btree.h"
+#include "xfs_bit.h"
+#include "xfs_log_format.h"
+#include "xfs_trans.h"
+#include "xfs_sb.h"
+#include "xfs_inode.h"
+#include "xfs_alloc.h"
+#include "xfs_alloc_btree.h"
+#include "xfs_bmap.h"
+#include "xfs_bmap_btree.h"
+#include "xfs_ialloc.h"
+#include "xfs_ialloc_btree.h"
+#include "xfs_refcount.h"
+#include "xfs_refcount_btree.h"
+#include "xfs_rmap.h"
+#include "xfs_rmap_btree.h"
+#include "scrub/xfs_scrub.h"
+#include "scrub/scrub.h"
+#include "scrub/common.h"
+#include "scrub/trace.h"
+
+/* Common code for the metadata scrubbers. */
+
+/* Per-scrubber setup functions */
+
+/* Set us up with a transaction and an empty context. */
+int
+xfs_scrub_setup_fs(
+	struct xfs_scrub_context	*sc,
+	struct xfs_inode		*ip)
+{
+	return xfs_scrub_trans_alloc(sc->sm, sc->mp,
+			&M_RES(sc->mp)->tr_itruncate, 0, 0, 0, &sc->tp);
+}
diff --git a/fs/xfs/scrub/common.h b/fs/xfs/scrub/common.h
new file mode 100644
index 0000000..b97df8c
--- /dev/null
+++ b/fs/xfs/scrub/common.h
@@ -0,0 +1,44 @@
+/*
+ * Copyright (C) 2017 Oracle.  All Rights Reserved.
+ *
+ * Author: Darrick J. Wong <darrick.wong@oracle.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301, USA.
+ */
+#ifndef __XFS_SCRUB_COMMON_H__
+#define __XFS_SCRUB_COMMON_H__
+
+/*
+ * Grab a transaction.  If we're going to repair something, we need to
+ * ensure there's enough reservation to make all the changes.  If not,
+ * we can use an empty transaction.
+ */
+static inline int
+xfs_scrub_trans_alloc(
+	struct xfs_scrub_metadata	*sm,
+	struct xfs_mount		*mp,
+	struct xfs_trans_res		*resp,
+	uint				blocks,
+	uint				rtextents,
+	uint				flags,
+	struct xfs_trans		**tpp)
+{
+	return xfs_trans_alloc_empty(mp, tpp);
+}
+
+/* Setup functions */
+int xfs_scrub_setup_fs(struct xfs_scrub_context *sc, struct xfs_inode *ip);
+
+#endif	/* __XFS_SCRUB_COMMON_H__ */
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index 7cf518e..7936a23 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -42,6 +42,7 @@
 #include "xfs_rmap_btree.h"
 #include "scrub/xfs_scrub.h"
 #include "scrub/scrub.h"
+#include "scrub/common.h"
 #include "scrub/trace.h"
 
 /*
@@ -108,6 +109,34 @@
  * will be set.
  */
 
+/*
+ * Test scrubber -- userspace uses this to probe if we're willing to
+ * scrub or repair a given mountpoint.
+ */
+int
+xfs_scrub_tester(
+	struct xfs_scrub_context	*sc)
+{
+	if (sc->sm->sm_ino || sc->sm->sm_agno)
+		return -EINVAL;
+	if (sc->sm->sm_gen & XFS_SCRUB_OFLAG_CORRUPT)
+		sc->sm->sm_flags |= XFS_SCRUB_OFLAG_CORRUPT;
+	if (sc->sm->sm_gen & XFS_SCRUB_OFLAG_PREEN)
+		sc->sm->sm_flags |= XFS_SCRUB_OFLAG_PREEN;
+	if (sc->sm->sm_gen & XFS_SCRUB_OFLAG_XFAIL)
+		sc->sm->sm_flags |= XFS_SCRUB_OFLAG_XFAIL;
+	if (sc->sm->sm_gen & XFS_SCRUB_OFLAG_XCORRUPT)
+		sc->sm->sm_flags |= XFS_SCRUB_OFLAG_XCORRUPT;
+	if (sc->sm->sm_gen & XFS_SCRUB_OFLAG_INCOMPLETE)
+		sc->sm->sm_flags |= XFS_SCRUB_OFLAG_INCOMPLETE;
+	if (sc->sm->sm_gen & XFS_SCRUB_OFLAG_WARNING)
+		sc->sm->sm_flags |= XFS_SCRUB_OFLAG_WARNING;
+	if (sc->sm->sm_gen & ~XFS_SCRUB_FLAGS_OUT)
+		return -ENOENT;
+
+	return 0;
+}
+
 /* Scrub setup and teardown */
 
 /* Free all the resources and finish the transactions. */
@@ -126,6 +155,10 @@ xfs_scrub_teardown(
 /* Scrubbing dispatch. */
 
 static const struct xfs_scrub_meta_ops meta_scrub_ops[] = {
+	{ /* ioctl presence test */
+		.setup	= xfs_scrub_setup_fs,
+		.scrub	= xfs_scrub_tester,
+	},
 };
 
 /* Dispatch metadata scrubbing. */
diff --git a/fs/xfs/scrub/scrub.h b/fs/xfs/scrub/scrub.h
index b271b2a..2528039 100644
--- a/fs/xfs/scrub/scrub.h
+++ b/fs/xfs/scrub/scrub.h
@@ -40,5 +40,6 @@ struct xfs_scrub_context {
 };
 
 /* Metadata scrubbers */
+int xfs_scrub_tester(struct xfs_scrub_context *sc);
 
 #endif	/* __XFS_SCRUB_SCRUB_H__ */
diff --git a/fs/xfs/scrub/trace.c b/fs/xfs/scrub/trace.c
index c59fd41..88b5ccb 100644
--- a/fs/xfs/scrub/trace.c
+++ b/fs/xfs/scrub/trace.c
@@ -32,6 +32,7 @@
 #include "xfs_trans.h"
 #include "scrub/xfs_scrub.h"
 #include "scrub/scrub.h"
+#include "scrub/common.h"
 
 /*
  * We include this last to have the helpers above available for the trace

