Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:47280 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750971AbdFBWbl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Jun 2017 18:31:41 -0400
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v52MVeEK027702
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 2 Jun 2017 22:31:40 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id v52MVeLh013409
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 2 Jun 2017 22:31:40 GMT
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id v52MVdn2019918
        for <linux-xfs@vger.kernel.org>; Fri, 2 Jun 2017 22:31:40 GMT
Subject: [PATCH 08/19] xfs: scrub free space btrees
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 02 Jun 2017 15:31:37 -0700
Message-ID: <149644269701.19430.5903185421462394518.stgit@birch.djwong.org>
In-Reply-To: <149644264601.19430.6064928774771048026.stgit@birch.djwong.org>
References: <149644264601.19430.6064928774771048026.stgit@birch.djwong.org>
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
index 4ddebb5..8f8dca5 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -105,6 +105,7 @@ xfs-y				+= xfs_aops.o \
 # online scrub/repair
 xfs-$(CONFIG_XFS_DEBUG)		+= $(addprefix scrub/, \
 				   agheader.o \
+				   alloc.o \
 				   btree.o \
 				   common.o \
 				   )
diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index f509dcbf..21bc4ff 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -497,7 +497,9 @@ struct xfs_scrub_metadata {
 #define XFS_SCRUB_TYPE_AGF	2	/* AG free header */
 #define XFS_SCRUB_TYPE_AGFL	3	/* AG free list */
 #define XFS_SCRUB_TYPE_AGI	4	/* AG inode header */
-#define XFS_SCRUB_TYPE_MAX	4
+#define XFS_SCRUB_TYPE_BNOBT	5	/* freesp by block btree */
+#define XFS_SCRUB_TYPE_CNTBT	6	/* freesp by length btree */
+#define XFS_SCRUB_TYPE_MAX	6
 
 #define XFS_SCRUB_FLAG_REPAIR	0x01	/* i: repair this metadata */
 #define XFS_SCRUB_FLAG_CORRUPT	0x02	/* o: needs repair */
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
index e47d795..2203574 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -529,6 +529,22 @@ xfs_scrub_dummy(
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
@@ -661,6 +677,14 @@ static const struct xfs_scrub_meta_fns meta_scrub_fns[] = {
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
index 4decfef..508c986 100644
--- a/fs/xfs/scrub/common.h
+++ b/fs/xfs/scrub/common.h
@@ -194,9 +194,13 @@ int xfs_scrub_walk_agfl(struct xfs_scrub_context *sc,
 
 /* Setup functions */
 
+int xfs_scrub_setup_ag_btree(struct xfs_scrub_context *sc,
+			     struct xfs_inode *ip, bool force_log);
+
 #define SETUP_FN(name) int name(struct xfs_scrub_context *sc, struct xfs_inode *ip)
 SETUP_FN(xfs_scrub_setup_fs);
 SETUP_FN(xfs_scrub_setup_ag_header);
+SETUP_FN(xfs_scrub_setup_ag_allocbt);
 #undef SETUP_FN
 
 /* Metadata scrubbers */
@@ -206,6 +210,8 @@ SCRUB_FN(xfs_scrub_superblock);
 SCRUB_FN(xfs_scrub_agf);
 SCRUB_FN(xfs_scrub_agfl);
 SCRUB_FN(xfs_scrub_agi);
+SCRUB_FN(xfs_scrub_bnobt);
+SCRUB_FN(xfs_scrub_cntbt);
 #undef SCRUB_FN
 
 #endif	/* __XFS_REPAIR_COMMON_H__ */
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 23e0d56..d277093 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -3334,7 +3334,9 @@ DEFINE_GETFSMAP_EVENT(xfs_getfsmap_mapping);
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

