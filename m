Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:35533 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751696AbdG0WmH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Jul 2017 18:42:07 -0400
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v6RMg65w006883
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 27 Jul 2017 22:42:06 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id v6RMg6Dc009096
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 27 Jul 2017 22:42:06 GMT
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id v6RMg6b2017349
        for <linux-xfs@vger.kernel.org>; Thu, 27 Jul 2017 22:42:06 GMT
Subject: [PATCH 04/26] xfs: test the scrub ioctl
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 27 Jul 2017 15:42:04 -0700
Message-ID: <150119532479.15159.4358234606027022216.stgit@magnolia>
In-Reply-To: <150119530010.15159.9900948790538082160.stgit@magnolia>
References: <150119530010.15159.9900948790538082160.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

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
 fs/xfs/scrub/trace.h   |    3 ++
 8 files changed, 144 insertions(+), 2 deletions(-)
 create mode 100644 fs/xfs/scrub/common.c
 create mode 100644 fs/xfs/scrub/common.h


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 94fd2d1..bce3a94 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -144,6 +144,7 @@ ifeq ($(CONFIG_XFS_ONLINE_SCRUB),y)
 
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
index e629177..db159b8 100644
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
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index 7dc75a3..78c30bb 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -25,7 +25,8 @@
 
 #include <linux/tracepoint.h>
 
-#define XFS_SCRUB_TYPE_DESC {}
+#define XFS_SCRUB_TYPE_DESC \
+	{ XFS_SCRUB_TYPE_TEST,		"test" }
 DECLARE_EVENT_CLASS(xfs_scrub_class,
 	TP_PROTO(struct xfs_inode *ip, struct xfs_scrub_metadata *sm,
 		 int error),

