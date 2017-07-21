Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:35071 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750743AbdGUEjd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Jul 2017 00:39:33 -0400
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v6L4dWe8009627
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 21 Jul 2017 04:39:32 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id v6L4dVap031529
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 21 Jul 2017 04:39:32 GMT
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0121.oracle.com (8.13.8/8.13.8) with ESMTP id v6L4dTvk006481
        for <linux-xfs@vger.kernel.org>; Fri, 21 Jul 2017 04:39:31 GMT
Subject: [PATCH 09/22] xfs: scrub free space btrees
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 20 Jul 2017 21:39:26 -0700
Message-ID: <150061196598.14732.397774100309714676.stgit@magnolia>
In-Reply-To: <150061190859.14732.17040548800470377701.stgit@magnolia>
References: <150061190859.14732.17040548800470377701.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Check the extent records free space btrees to ensure that the values
look sane.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/Makefile        |    1 
 fs/xfs/libxfs/xfs_fs.h |    4 +-
 fs/xfs/scrub/alloc.c   |  105 ++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/common.c  |   24 +++++++++++
 fs/xfs/scrub/common.h  |    6 +++
 fs/xfs/xfs_trace.h     |    4 +-
 6 files changed, 142 insertions(+), 2 deletions(-)
 create mode 100644 fs/xfs/scrub/alloc.c


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 1b9bd1a..ce492ee 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -141,6 +141,7 @@ xfs-$(CONFIG_EXPORTFS_BLOCK_OPS)	+= xfs_pnfs.o
 ifeq ($(CONFIG_XFS_ONLINE_SCRUB),y)
 xfs-y				+= $(addprefix scrub/, \
 				   agheader.o \
+				   alloc.o \
 				   btree.o \
 				   common.o \
 				   metabufs.o \
diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index 208cc48..bb36acf 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -487,7 +487,9 @@ struct xfs_scrub_metadata {
 #define XFS_SCRUB_TYPE_AGF	3	/* AG free header */
 #define XFS_SCRUB_TYPE_AGFL	4	/* AG free list */
 #define XFS_SCRUB_TYPE_AGI	5	/* AG inode header */
-#define XFS_SCRUB_TYPE_MAX	5
+#define XFS_SCRUB_TYPE_BNOBT	6	/* freesp by block btree */
+#define XFS_SCRUB_TYPE_CNTBT	7	/* freesp by length btree */
+#define XFS_SCRUB_TYPE_MAX	7
 
 /* i: repair this metadata */
 #define XFS_SCRUB_FLAG_REPAIR		(1 << 0)
diff --git a/fs/xfs/scrub/alloc.c b/fs/xfs/scrub/alloc.c
new file mode 100644
index 0000000..1709ab2
--- /dev/null
+++ b/fs/xfs/scrub/alloc.c
@@ -0,0 +1,105 @@
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
+#include "xfs_trace.h"
+#include "xfs_sb.h"
+#include "xfs_rmap.h"
+#include "scrub/common.h"
+#include "scrub/btree.h"
+
+/*
+ * Set us up to scrub free space btrees.
+ * Push everything out of the log so that the busy extent list is empty.
+ */
+int
+xfs_scrub_setup_ag_allocbt(
+	struct xfs_scrub_context	*sc,
+	struct xfs_inode		*ip)
+{
+	return xfs_scrub_setup_ag_btree(sc, ip, sc->try_harder);
+}
+
+/* Free space btree scrubber. */
+
+/* Scrub a bnobt/cntbt record. */
+STATIC int
+xfs_scrub_allocbt_helper(
+	struct xfs_scrub_btree		*bs,
+	union xfs_btree_rec		*rec)
+{
+	struct xfs_mount		*mp = bs->cur->bc_mp;
+	struct xfs_agf			*agf;
+	xfs_agblock_t			bno;
+	xfs_extlen_t			len;
+	int				error = 0;
+
+	bno = be32_to_cpu(rec->alloc.ar_startblock);
+	len = be32_to_cpu(rec->alloc.ar_blockcount);
+	agf = XFS_BUF_TO_AGF(bs->sc->sa.agf_bp);
+
+	XFS_SCRUB_BTREC_CHECK(bs, bno < mp->m_sb.sb_agblocks);
+	XFS_SCRUB_BTREC_CHECK(bs, bno < be32_to_cpu(agf->agf_length));
+	XFS_SCRUB_BTREC_CHECK(bs, bno < bno + len);
+	XFS_SCRUB_BTREC_CHECK(bs, (unsigned long long)bno + len <=
+			mp->m_sb.sb_agblocks);
+	XFS_SCRUB_BTREC_CHECK(bs, (unsigned long long)bno + len <=
+			be32_to_cpu(agf->agf_length));
+
+	return error;
+}
+
+/* Scrub the freespace btrees for some AG. */
+STATIC int
+xfs_scrub_allocbt(
+	struct xfs_scrub_context	*sc,
+	xfs_btnum_t			which)
+{
+	struct xfs_owner_info		oinfo;
+	struct xfs_btree_cur		*cur;
+
+	xfs_rmap_ag_owner(&oinfo, XFS_RMAP_OWN_AG);
+	cur = which == XFS_BTNUM_BNO ? sc->sa.bno_cur : sc->sa.cnt_cur;
+	return xfs_scrub_btree(sc, cur, xfs_scrub_allocbt_helper,
+			&oinfo, NULL);
+}
+
+int
+xfs_scrub_bnobt(
+	struct xfs_scrub_context	*sc)
+{
+	return xfs_scrub_allocbt(sc, XFS_BTNUM_BNO);
+}
+
+int
+xfs_scrub_cntbt(
+	struct xfs_scrub_context	*sc)
+{
+	return xfs_scrub_allocbt(sc, XFS_BTNUM_CNT);
+}
diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index 994c6c8..86161b5 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -556,6 +556,22 @@ xfs_scrub_dummy(
 	return 0;
 }
 
+/* Set us up with AG headers and btree cursors. */
+int
+xfs_scrub_setup_ag_btree(
+	struct xfs_scrub_context	*sc,
+	struct xfs_inode		*ip,
+	bool				force_log)
+{
+	int				error;
+
+	error = xfs_scrub_setup_ag_header(sc, ip);
+	if (error)
+		return error;
+
+	return xfs_scrub_ag_init(sc, sc->sm->sm_agno, &sc->sa);
+}
+
 /* Per-scrubber setup functions */
 
 /* Set us up with a transaction and an empty context. */
@@ -692,6 +708,14 @@ static const struct xfs_scrub_meta_fns meta_scrub_fns[] = {
 		.setup	= xfs_scrub_setup_ag_header,
 		.scrub	= xfs_scrub_agi,
 	},
+	{ /* bnobt */
+		.setup	= xfs_scrub_setup_ag_allocbt,
+		.scrub	= xfs_scrub_bnobt,
+	},
+	{ /* cntbt */
+		.setup	= xfs_scrub_setup_ag_allocbt,
+		.scrub	= xfs_scrub_cntbt,
+	},
 };
 
 /* Dispatch metadata scrubbing. */
diff --git a/fs/xfs/scrub/common.h b/fs/xfs/scrub/common.h
index 952151a..f14abfb 100644
--- a/fs/xfs/scrub/common.h
+++ b/fs/xfs/scrub/common.h
@@ -202,10 +202,14 @@ int xfs_scrub_walk_agfl(struct xfs_scrub_context *sc,
 
 /* Setup functions */
 
+int xfs_scrub_setup_ag_btree(struct xfs_scrub_context *sc,
+			     struct xfs_inode *ip, bool force_log);
+
 #define SETUP_FN(name) int name(struct xfs_scrub_context *sc, struct xfs_inode *ip)
 SETUP_FN(xfs_scrub_setup_fs);
 SETUP_FN(xfs_scrub_setup_metabufs);
 SETUP_FN(xfs_scrub_setup_ag_header);
+SETUP_FN(xfs_scrub_setup_ag_allocbt);
 #undef SETUP_FN
 
 /* Metadata scrubbers */
@@ -217,6 +221,8 @@ SCRUB_FN(xfs_scrub_superblock);
 SCRUB_FN(xfs_scrub_agf);
 SCRUB_FN(xfs_scrub_agfl);
 SCRUB_FN(xfs_scrub_agi);
+SCRUB_FN(xfs_scrub_bnobt);
+SCRUB_FN(xfs_scrub_cntbt);
 #undef SCRUB_FN
 
 #endif	/* __XFS_REPAIR_COMMON_H__ */
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 24efbff..4a9a645 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -3317,7 +3317,9 @@ DEFINE_GETFSMAP_EVENT(xfs_getfsmap_mapping);
 	{ XFS_SCRUB_TYPE_SB,		"superblock" }, \
 	{ XFS_SCRUB_TYPE_AGF,		"AGF" }, \
 	{ XFS_SCRUB_TYPE_AGFL,		"AGFL" }, \
-	{ XFS_SCRUB_TYPE_AGI,		"AGI" }
+	{ XFS_SCRUB_TYPE_AGI,		"AGI" }, \
+	{ XFS_SCRUB_TYPE_BNOBT,		"bnobt" }, \
+	{ XFS_SCRUB_TYPE_CNTBT,		"cntbt" }
 DECLARE_EVENT_CLASS(xfs_scrub_class,
 	TP_PROTO(struct xfs_inode *ip, struct xfs_scrub_metadata *sm,
 		 int error),

