Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:27857 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753051AbdJLBlk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 11 Oct 2017 21:41:40 -0400
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v9C1fdmt032105
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 12 Oct 2017 01:41:39 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id v9C1fdKC005203
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 12 Oct 2017 01:41:39 GMT
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id v9C1fd7d020076
        for <linux-xfs@vger.kernel.org>; Thu, 12 Oct 2017 01:41:39 GMT
Subject: [PATCH 08/30] xfs: probe the scrub ioctl
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 11 Oct 2017 18:41:37 -0700
Message-ID: <150777249786.1724.13451740442676439052.stgit@magnolia>
In-Reply-To: <150777244315.1724.6916081372861799350.stgit@magnolia>
References: <150777244315.1724.6916081372861799350.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Create a probe scrubber with id 0.  This will be used by xfs_scrub to
probe the kernel's abilities to scrub (and repair) the metadata.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/Makefile        |    1 +
 fs/xfs/libxfs/xfs_fs.h |    3 ++
 fs/xfs/scrub/common.c  |   59 ++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/common.h  |   39 ++++++++++++++++++++++++++++++++
 fs/xfs/scrub/scrub.c   |   19 +++++++++++++++
 fs/xfs/scrub/scrub.h   |    1 +
 fs/xfs/scrub/trace.c   |    1 +
 7 files changed, 122 insertions(+), 1 deletion(-)
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
index 3b4a36e..765f91e 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -483,9 +483,10 @@ struct xfs_scrub_metadata {
  */
 
 /* Scrub subcommands. */
+#define XFS_SCRUB_TYPE_PROBE	0	/* presence test ioctl */
 
 /* Number of scrub subcommands. */
-#define XFS_SCRUB_TYPE_NR	0
+#define XFS_SCRUB_TYPE_NR	1
 
 /* i: Repair this metadata. */
 #define XFS_SCRUB_IFLAG_REPAIR		(1 << 0)
diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
new file mode 100644
index 0000000..d2c8f94
--- /dev/null
+++ b/fs/xfs/scrub/common.c
@@ -0,0 +1,59 @@
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
+	return xfs_scrub_trans_alloc(sc->sm, sc->mp, &sc->tp);
+}
diff --git a/fs/xfs/scrub/common.h b/fs/xfs/scrub/common.h
new file mode 100644
index 0000000..f3d5865
--- /dev/null
+++ b/fs/xfs/scrub/common.h
@@ -0,0 +1,39 @@
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
+ * Grab an empty transaction so that we can re-grab locked buffers if
+ * one of our btrees turns out to be cyclic.
+ */
+static inline int
+xfs_scrub_trans_alloc(
+	struct xfs_scrub_metadata	*sm,
+	struct xfs_mount		*mp,
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
index 75c318b..92eac98 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -42,6 +42,7 @@
 #include "xfs_rmap_btree.h"
 #include "scrub/xfs_scrub.h"
 #include "scrub/scrub.h"
+#include "scrub/common.h"
 #include "scrub/trace.h"
 
 /*
@@ -108,6 +109,20 @@
  * will be set.
  */
 
+/*
+ * Scrub probe -- userspace uses this to probe if we're willing to
+ * scrub or repair a given mountpoint.
+ */
+int
+xfs_scrub_probe(
+	struct xfs_scrub_context	*sc)
+{
+	if (sc->sm->sm_ino || sc->sm->sm_agno)
+		return -EINVAL;
+
+	return 0;
+}
+
 /* Scrub setup and teardown */
 
 /* Free all the resources and finish the transactions. */
@@ -126,6 +141,10 @@ xfs_scrub_teardown(
 /* Scrubbing dispatch. */
 
 static const struct xfs_scrub_meta_ops meta_scrub_ops[] = {
+	{ /* ioctl presence test */
+		.setup	= xfs_scrub_setup_fs,
+		.scrub	= xfs_scrub_probe,
+	},
 };
 
 /* This isn't a stable feature, warn once per day. */
diff --git a/fs/xfs/scrub/scrub.h b/fs/xfs/scrub/scrub.h
index ef7b50e..b7b9422 100644
--- a/fs/xfs/scrub/scrub.h
+++ b/fs/xfs/scrub/scrub.h
@@ -45,5 +45,6 @@ struct xfs_scrub_context {
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

