Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:41358 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751291AbdJCUlM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 Oct 2017 16:41:12 -0400
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v93KfAH6001707
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 3 Oct 2017 20:41:11 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id v93Kf9ct000501
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 3 Oct 2017 20:41:10 GMT
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id v93Kf94J001103
        for <linux-xfs@vger.kernel.org>; Tue, 3 Oct 2017 20:41:09 GMT
Subject: [PATCH 03/25] xfs: probe the scrub ioctl
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 03 Oct 2017 13:41:08 -0700
Message-ID: <150706326848.19351.10670988265979551239.stgit@magnolia>
In-Reply-To: <150706324963.19351.17715069858921948692.stgit@magnolia>
References: <150706324963.19351.17715069858921948692.stgit@magnolia>
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
 fs/xfs/scrub/scrub.c   |   24 ++++++++++++++++++++
 fs/xfs/scrub/scrub.h   |    1 +
 fs/xfs/scrub/trace.c   |    1 +
 7 files changed, 127 insertions(+), 1 deletion(-)
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
index 1f0ab15..d51354d 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -42,6 +42,7 @@
 #include "xfs_rmap_btree.h"
 #include "scrub/xfs_scrub.h"
 #include "scrub/scrub.h"
+#include "scrub/common.h"
 #include "scrub/trace.h"
 
 /*
@@ -108,6 +109,25 @@
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
+	if (sc->sm->sm_gen & ~XFS_SCRUB_FLAGS_OUT)
+		return -ENOENT;
+
+	/* Echo parameters back to userspace to prove that we exist. */
+	sc->sm->sm_flags |= (sc->sm->sm_gen & XFS_SCRUB_FLAGS_OUT);
+
+	return 0;
+}
+
 /* Scrub setup and teardown */
 
 /* Free all the resources and finish the transactions. */
@@ -126,6 +146,10 @@ xfs_scrub_teardown(
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

