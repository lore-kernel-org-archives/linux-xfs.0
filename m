Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:59396 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751765AbeCZX5B (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Mar 2018 19:57:01 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w2QNpjtD005251
        for <linux-xfs@vger.kernel.org>; Mon, 26 Mar 2018 23:57:01 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp2120.oracle.com with ESMTP id 2gyawe80ap-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 26 Mar 2018 23:57:01 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w2QNv0Hi002143
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 26 Mar 2018 23:57:00 GMT
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w2QNv0Dp020790
        for <linux-xfs@vger.kernel.org>; Mon, 26 Mar 2018 23:57:00 GMT
Subject: [PATCH 10/20] xfs: repair superblocks
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 26 Mar 2018 16:56:59 -0700
Message-ID: <152210861897.13184.13041891489003984365.stgit@magnolia>
In-Reply-To: <152210855435.13184.6475770131389744177.stgit@magnolia>
References: <152210855435.13184.6475770131389744177.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

If one of the backup superblocks is found to differ seriously from
superblock 0, write out a fresh copy from the in-core sb.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/Makefile                |    1 +
 fs/xfs/scrub/agheader_repair.c |   77 ++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/repair.h          |    2 +
 fs/xfs/scrub/scrub.c           |    1 +
 4 files changed, 81 insertions(+)
 create mode 100644 fs/xfs/scrub/agheader_repair.c


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 9175d51..cf64415 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -173,6 +173,7 @@ xfs-$(CONFIG_XFS_QUOTA)		+= scrub/quota.o
 # online repair
 ifeq ($(CONFIG_XFS_ONLINE_REPAIR),y)
 xfs-y				+= $(addprefix scrub/, \
+				   agheader_repair.o \
 				   repair.o \
 				   )
 endif
diff --git a/fs/xfs/scrub/agheader_repair.c b/fs/xfs/scrub/agheader_repair.c
new file mode 100644
index 0000000..068a738
--- /dev/null
+++ b/fs/xfs/scrub/agheader_repair.c
@@ -0,0 +1,77 @@
+/*
+ * Copyright (C) 2018 Oracle.  All Rights Reserved.
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
+#include "xfs_ialloc.h"
+#include "xfs_rmap.h"
+#include "scrub/xfs_scrub.h"
+#include "scrub/scrub.h"
+#include "scrub/common.h"
+#include "scrub/trace.h"
+
+/* Superblock */
+
+/* Repair the superblock. */
+int
+xfs_repair_superblock(
+	struct xfs_scrub_context	*sc,
+	uint32_t			scrub_oflags)
+{
+	struct xfs_mount		*mp = sc->mp;
+	struct xfs_buf			*bp;
+	struct xfs_dsb			*sbp;
+	xfs_agnumber_t			agno;
+	int				error;
+
+	/* Don't try to repair AG 0's sb; let xfs_repair deal with it. */
+	agno = sc->sm->sm_agno;
+	if (agno == 0)
+		return -EOPNOTSUPP;
+
+	error = xfs_trans_read_buf(mp, sc->tp, mp->m_ddev_targp,
+		  XFS_AG_DADDR(mp, agno, XFS_SB_BLOCK(mp)),
+		  XFS_FSS_TO_BB(mp, 1), 0, &bp, NULL);
+	if (error)
+		return error;
+	bp->b_ops = &xfs_sb_buf_ops;
+
+	/* Copy AG 0's superblock to this one. */
+	sbp = XFS_BUF_TO_SBP(bp);
+	memset(sbp, 0, mp->m_sb.sb_sectsize);
+	xfs_sb_to_disk(sbp, &mp->m_sb);
+	sbp->sb_bad_features2 = sbp->sb_features2;
+
+	/* Write this to disk. */
+	xfs_trans_buf_set_type(sc->tp, bp, XFS_BLFT_SB_BUF);
+	xfs_trans_log_buf(sc->tp, bp, 0, mp->m_sb.sb_sectsize - 1);
+	return error;
+}
diff --git a/fs/xfs/scrub/repair.h b/fs/xfs/scrub/repair.h
index 6a9f9f9..09e8dd7 100644
--- a/fs/xfs/scrub/repair.h
+++ b/fs/xfs/scrub/repair.h
@@ -118,6 +118,7 @@ xfs_extlen_t xfs_repair_calc_ag_resblks(struct xfs_scrub_context *sc);
 int xfs_repair_setup_btree_extent_collection(struct xfs_scrub_context *sc);
 
 /* Metadata repairers */
+int xfs_repair_superblock(struct xfs_scrub_context *sc, uint32_t scrub_oflags);
 
 #else
 
@@ -140,6 +141,7 @@ xfs_repair_calc_ag_resblks(
 # define xfs_repair_probe		(NULL)
 # define xfs_repair_unfixed(sm)		(false)
 # define xfs_repair_reset_counters	xfs_repair_fail
+# define xfs_repair_superblock		(NULL)
 
 #endif /* IS_ENABLED(CONFIG_XFS_ONLINE_REPAIR) */
 
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index 5e22de5..837961e 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -214,6 +214,7 @@ static const struct xfs_scrub_meta_ops meta_scrub_ops[] = {
 		.type	= ST_PERAG,
 		.setup	= xfs_scrub_setup_fs,
 		.scrub	= xfs_scrub_superblock,
+		.repair	= xfs_repair_superblock,
 	},
 	[XFS_SCRUB_TYPE_AGF] = {	/* agf */
 		.type	= ST_PERAG,

