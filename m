Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:42378 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751357AbeBWCNA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Feb 2018 21:13:00 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w1N2CEbc026593
        for <linux-xfs@vger.kernel.org>; Fri, 23 Feb 2018 02:12:59 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp2130.oracle.com with ESMTP id 2ga9xbr09m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 23 Feb 2018 02:12:59 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w1N22wVG020123
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Fri, 23 Feb 2018 02:02:58 GMT
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w1N22wne016552
        for <linux-xfs@vger.kernel.org>; Fri, 23 Feb 2018 02:02:58 GMT
Subject: [PATCH 10/20] xfs: repair superblocks
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 22 Feb 2018 18:02:57 -0800
Message-ID: <151935137700.22097.766009918576691404.stgit@magnolia>
In-Reply-To: <151935130484.22097.9694510081310029779.stgit@magnolia>
References: <151935130484.22097.9694510081310029779.stgit@magnolia>
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
index b4686ac..6dea0ce 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -174,6 +174,7 @@ xfs-$(CONFIG_XFS_QUOTA)		+= scrub/quota.o
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
index 8cb233e..ef9cf9c 100644
--- a/fs/xfs/scrub/repair.h
+++ b/fs/xfs/scrub/repair.h
@@ -110,6 +110,7 @@ xfs_extlen_t xfs_repair_calc_ag_resblks(struct xfs_scrub_context *sc);
 int xfs_repair_setup_btree_extent_collection(struct xfs_scrub_context *sc);
 
 /* Metadata repairers */
+int xfs_repair_superblock(struct xfs_scrub_context *sc, uint32_t scrub_oflags);
 
 #else
 
@@ -131,6 +132,7 @@ xfs_repair_calc_ag_resblks(
 # define xfs_repair_should_fix(sm)	(false)
 # define xfs_repair_probe		(NULL)
 # define xfs_repair_reset_counters	xfs_repair_fail
+# define xfs_repair_superblock		(NULL)
 
 #endif /* IS_ENABLED(CONFIG_XFS_ONLINE_REPAIR) */
 
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index ad1eb55..739b62d 100644
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

