Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:58510 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753031AbeDRCmz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Apr 2018 22:42:55 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w3I2gEPf010694
        for <linux-xfs@vger.kernel.org>; Wed, 18 Apr 2018 02:42:55 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp2130.oracle.com with ESMTP id 2hdrxnrjuv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 18 Apr 2018 02:42:55 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w3I2gsAa019666
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 18 Apr 2018 02:42:54 GMT
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w3I2gssb026366
        for <linux-xfs@vger.kernel.org>; Wed, 18 Apr 2018 02:42:54 GMT
Subject: [PATCH 10/24] xfs: repair superblocks
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 17 Apr 2018 19:42:53 -0700
Message-ID: <152401937340.12079.2024604205549567150.stgit@magnolia>
In-Reply-To: <152401930978.12079.2000682561964128780.stgit@magnolia>
References: <152401930978.12079.2000682561964128780.stgit@magnolia>
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
 fs/xfs/scrub/agheader_repair.c |   76 ++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/repair.h          |    2 +
 fs/xfs/scrub/scrub.c           |    2 +
 4 files changed, 80 insertions(+), 1 deletion(-)
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
index 0000000..959b8c6
--- /dev/null
+++ b/fs/xfs/scrub/agheader_repair.c
@@ -0,0 +1,76 @@
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
+	struct xfs_scrub_context	*sc)
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
+	bp = xfs_buf_get_uncached(mp->m_ddev_targp, XFS_FSS_TO_BB(mp, 1), 0);
+	if (!bp)
+		return -ENOMEM;
+
+	xfs_buf_zero(bp, 0, BBTOB(bp->b_length));
+	bp->b_bn = XFS_AG_DADDR(mp, agno, XFS_SB_BLOCK(mp));
+	bp->b_maps[0].bm_bn = XFS_AG_DADDR(mp, agno, XFS_SB_BLOCK(mp));
+	bp->b_ops = &xfs_sb_buf_ops;
+
+	/* Copy AG 0's superblock to this one. */
+	sbp = XFS_BUF_TO_SBP(bp);
+	xfs_sb_to_disk(sbp, &mp->m_sb);
+
+	/* Write this to disk. */
+	error = xfs_bwrite(bp);
+	xfs_buf_relse(bp);
+	return error;
+}
diff --git a/fs/xfs/scrub/repair.h b/fs/xfs/scrub/repair.h
index 0cb91dc..0090087 100644
--- a/fs/xfs/scrub/repair.h
+++ b/fs/xfs/scrub/repair.h
@@ -103,6 +103,7 @@ int xfs_repair_ino_dqattach(struct xfs_scrub_context *sc);
 /* Metadata repairers */
 
 int xfs_repair_probe(struct xfs_scrub_context *sc);
+int xfs_repair_superblock(struct xfs_scrub_context *sc);
 
 #else
 
@@ -131,6 +132,7 @@ static inline int xfs_repair_reset_counters(struct xfs_mount *mp)
 }
 
 #define xfs_repair_probe		xfs_repair_notsupported
+#define xfs_repair_superblock		xfs_repair_notsupported
 
 #endif /* CONFIG_XFS_ONLINE_REPAIR */
 
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index 9cdc3f0..d7bcf31 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -218,7 +218,7 @@ static const struct xfs_scrub_meta_ops meta_scrub_ops[] = {
 		.type	= ST_PERAG,
 		.setup	= xfs_scrub_setup_fs,
 		.scrub	= xfs_scrub_superblock,
-		.repair	= xfs_repair_notsupported,
+		.repair	= xfs_repair_superblock,
 	},
 	[XFS_SCRUB_TYPE_AGF] = {	/* agf */
 		.type	= ST_PERAG,

