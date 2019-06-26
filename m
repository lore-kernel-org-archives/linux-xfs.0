Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:55216 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726703AbfFZCh4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Jun 2019 22:37:56 -0400
Subject: [PATCH 10/10] libxfs: move topology declarations into separate
 header
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 25 Jun 2019 19:37:52 -0700
Message-ID: <156151667233.2286979.9157937825247227178.stgit@magnolia>
In-Reply-To: <156151660523.2286979.13694849827562044045.stgit@magnolia>
References: <156151660523.2286979.13694849827562044045.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@sandeen.net, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

The topology functions live in libfrog now, which means their
declarations don't belong in libxcmd.h.  Create new header file for
them.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 include/libxcmd.h  |   31 -------------------------------
 include/topology.h |   39 +++++++++++++++++++++++++++++++++++++++
 libfrog/topology.c |    1 +
 mkfs/xfs_mkfs.c    |    2 +-
 repair/sb.c        |    1 +
 5 files changed, 42 insertions(+), 32 deletions(-)
 create mode 100644 include/topology.h


diff --git a/include/libxcmd.h b/include/libxcmd.h
index 20e5d834..7b889b0a 100644
--- a/include/libxcmd.h
+++ b/include/libxcmd.h
@@ -10,35 +10,4 @@
 #include "libxfs.h"
 #include <sys/time.h>
 
-/*
- * Device topology information.
- */
-typedef struct fs_topology {
-	int	dsunit;		/* stripe unit - data subvolume */
-	int	dswidth;	/* stripe width - data subvolume */
-	int	rtswidth;	/* stripe width - rt subvolume */
-	int	lsectorsize;	/* logical sector size &*/
-	int	psectorsize;	/* physical sector size */
-} fs_topology_t;
-
-extern void
-get_topology(
-	libxfs_init_t		*xi,
-	struct fs_topology	*ft,
-	int			force_overwrite);
-
-extern void
-calc_default_ag_geometry(
-	int		blocklog,
-	uint64_t	dblocks,
-	int		multidisk,
-	uint64_t	*agsize,
-	uint64_t	*agcount);
-
-extern int
-check_overwrite(
-	const char	*device);
-
-
-
 #endif	/* __LIBXCMD_H__ */
diff --git a/include/topology.h b/include/topology.h
new file mode 100644
index 00000000..61ede23a
--- /dev/null
+++ b/include/topology.h
@@ -0,0 +1,39 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2000-2005 Silicon Graphics, Inc.
+ * All Rights Reserved.
+ */
+
+#ifndef __TOPOLOGY_H__
+#define __TOPOLOGY_H__
+
+/*
+ * Device topology information.
+ */
+typedef struct fs_topology {
+	int	dsunit;		/* stripe unit - data subvolume */
+	int	dswidth;	/* stripe width - data subvolume */
+	int	rtswidth;	/* stripe width - rt subvolume */
+	int	lsectorsize;	/* logical sector size &*/
+	int	psectorsize;	/* physical sector size */
+} fs_topology_t;
+
+extern void
+get_topology(
+	libxfs_init_t		*xi,
+	struct fs_topology	*ft,
+	int			force_overwrite);
+
+extern void
+calc_default_ag_geometry(
+	int		blocklog,
+	uint64_t	dblocks,
+	int		multidisk,
+	uint64_t	*agsize,
+	uint64_t	*agcount);
+
+extern int
+check_overwrite(
+	const char	*device);
+
+#endif	/* __TOPOLOGY_H__ */
diff --git a/libfrog/topology.c b/libfrog/topology.c
index cac164f3..e2f87415 100644
--- a/libfrog/topology.c
+++ b/libfrog/topology.c
@@ -10,6 +10,7 @@
 #  include <blkid/blkid.h>
 #endif /* ENABLE_BLKID */
 #include "xfs_multidisk.h"
+#include "topology.h"
 
 #define TERABYTES(count, blog)	((uint64_t)(count) << (40 - (blog)))
 #define GIGABYTES(count, blog)	((uint64_t)(count) << (30 - (blog)))
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 468b8fde..ade06bf6 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -9,7 +9,7 @@
 #include "xfs_multidisk.h"
 #include "libxcmd.h"
 #include "fsgeom.h"
-
+#include "topology.h"
 
 #define TERABYTES(count, blog)	((uint64_t)(count) << (40 - (blog)))
 #define GIGABYTES(count, blog)	((uint64_t)(count) << (30 - (blog)))
diff --git a/repair/sb.c b/repair/sb.c
index 119bf219..547969f7 100644
--- a/repair/sb.c
+++ b/repair/sb.c
@@ -12,6 +12,7 @@
 #include "protos.h"
 #include "err_protos.h"
 #include "xfs_multidisk.h"
+#include "topology.h"
 
 #define BSIZE	(1024 * 1024)
 
