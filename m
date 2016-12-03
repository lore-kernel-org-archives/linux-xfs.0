Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:19477 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756546AbcLCBhp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Dec 2016 20:37:45 -0500
Subject: [PATCH 22/55] xfs: support scrubbing free space btrees
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 02 Dec 2016 17:37:40 -0800
Message-ID: <148072906012.12995.13754614468306815684.stgit@birch.djwong.org>
In-Reply-To: <148072891404.12995.15510849192837089093.stgit@birch.djwong.org>
References: <148072891404.12995.15510849192837089093.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

Check the extent records free space btrees to ensure that the values
look sane.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/Makefile                 |    1 
 fs/xfs/libxfs/xfs_alloc_btree.c |    6 ---
 fs/xfs/libxfs/xfs_fs.h          |    4 +-
 fs/xfs/repair/alloc.c           |   93 +++++++++++++++++++++++++++++++++++++++
 fs/xfs/repair/common.c          |    2 +
 fs/xfs/repair/common.h          |    2 +
 fs/xfs/xfs_trace.h              |    4 +-
 7 files changed, 104 insertions(+), 8 deletions(-)
 create mode 100644 fs/xfs/repair/alloc.c


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index c22b3c0..a4246f1 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -104,6 +104,7 @@ xfs-y				+= xfs_aops.o \
 # online scrub/repair
 xfs-$(CONFIG_XFS_ONLINE_REPAIR)	+= $(addprefix repair/, \
 				   agheader.o \
+				   alloc.o \
 				   btree.o \
 				   common.o \
 				   )
diff --git a/fs/xfs/libxfs/xfs_alloc_btree.c b/fs/xfs/libxfs/xfs_alloc_btree.c
index 3dad54e..927f444 100644
--- a/fs/xfs/libxfs/xfs_alloc_btree.c
+++ b/fs/xfs/libxfs/xfs_alloc_btree.c
@@ -386,7 +386,6 @@ const struct xfs_buf_ops xfs_allocbt_buf_ops = {
 };
 
 
-#if defined(DEBUG) || defined(XFS_WARN)
 STATIC int
 xfs_bnobt_keys_inorder(
 	struct xfs_btree_cur	*cur,
@@ -433,7 +432,6 @@ xfs_cntbt_recs_inorder(
 		 be32_to_cpu(r1->alloc.ar_startblock) <
 		 be32_to_cpu(r2->alloc.ar_startblock));
 }
-#endif /* DEBUG */
 
 static const struct xfs_btree_ops xfs_bnobt_ops = {
 	.rec_len		= sizeof(xfs_alloc_rec_t),
@@ -453,10 +451,8 @@ static const struct xfs_btree_ops xfs_bnobt_ops = {
 	.key_diff		= xfs_bnobt_key_diff,
 	.buf_ops		= &xfs_allocbt_buf_ops,
 	.diff_two_keys		= xfs_bnobt_diff_two_keys,
-#if defined(DEBUG) || defined(XFS_WARN)
 	.keys_inorder		= xfs_bnobt_keys_inorder,
 	.recs_inorder		= xfs_bnobt_recs_inorder,
-#endif
 };
 
 static const struct xfs_btree_ops xfs_cntbt_ops = {
@@ -476,10 +472,8 @@ static const struct xfs_btree_ops xfs_cntbt_ops = {
 	.key_diff		= xfs_cntbt_key_diff,
 	.buf_ops		= &xfs_allocbt_buf_ops,
 	.diff_two_keys		= xfs_cntbt_diff_two_keys,
-#if defined(DEBUG) || defined(XFS_WARN)
 	.keys_inorder		= xfs_cntbt_keys_inorder,
 	.recs_inorder		= xfs_cntbt_recs_inorder,
-#endif
 };
 
 /*
diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index d93787b..d640464 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -579,7 +579,9 @@ struct xfs_scrub_metadata {
 #define XFS_SCRUB_TYPE_AGF	2	/* AG free header */
 #define XFS_SCRUB_TYPE_AGFL	3	/* AG free list */
 #define XFS_SCRUB_TYPE_AGI	4	/* AG inode header */
-#define XFS_SCRUB_TYPE_MAX	4
+#define XFS_SCRUB_TYPE_BNOBT	5	/* freesp by block btree */
+#define XFS_SCRUB_TYPE_CNTBT	6	/* freesp by length btree */
+#define XFS_SCRUB_TYPE_MAX	6
 
 #define XFS_SCRUB_FLAG_REPAIR	0x1	/* i: repair this metadata */
 #define XFS_SCRUB_FLAG_CORRUPT	0x2	/* o: needs repair */
diff --git a/fs/xfs/repair/alloc.c b/fs/xfs/repair/alloc.c
new file mode 100644
index 0000000..9f9f4db9c
--- /dev/null
+++ b/fs/xfs/repair/alloc.c
@@ -0,0 +1,93 @@
+/*
+ * Copyright (C) 2016-2017 Oracle.  All Rights Reserved.
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
+#include "repair/common.h"
+#include "repair/btree.h"
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
diff --git a/fs/xfs/repair/common.c b/fs/xfs/repair/common.c
index 72b56e7..81a60a5 100644
--- a/fs/xfs/repair/common.c
+++ b/fs/xfs/repair/common.c
@@ -701,6 +701,8 @@ static const struct xfs_scrub_meta_fns meta_scrub_fns[] = {
 	{xfs_scrub_setup_ag, xfs_scrub_agf, NULL, NULL},
 	{xfs_scrub_setup_ag, xfs_scrub_agfl, NULL, NULL},
 	{xfs_scrub_setup_ag, xfs_scrub_agi, NULL, NULL},
+	{xfs_scrub_setup_ag_header, xfs_scrub_bnobt, NULL, NULL},
+	{xfs_scrub_setup_ag_header, xfs_scrub_cntbt, NULL, NULL},
 };
 
 /* Dispatch metadata scrubbing. */
diff --git a/fs/xfs/repair/common.h b/fs/xfs/repair/common.h
index ef94e5f..e2f5bf6 100644
--- a/fs/xfs/repair/common.h
+++ b/fs/xfs/repair/common.h
@@ -198,5 +198,7 @@ int xfs_scrub_superblock(struct xfs_scrub_context *sc);
 int xfs_scrub_agf(struct xfs_scrub_context *sc);
 int xfs_scrub_agfl(struct xfs_scrub_context *sc);
 int xfs_scrub_agi(struct xfs_scrub_context *sc);
+int xfs_scrub_bnobt(struct xfs_scrub_context *sc);
+int xfs_scrub_cntbt(struct xfs_scrub_context *sc);
 
 #endif	/* __XFS_REPAIR_COMMON_H__ */
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 41d8d1e..d17cee5 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -3466,7 +3466,9 @@ DEFINE_GETFSMAP_EVENT(xfs_getfsmap_mapping);
 	{ XFS_SCRUB_TYPE_SB,		"superblock" }, \
 	{ XFS_SCRUB_TYPE_AGF,		"AGF" }, \
 	{ XFS_SCRUB_TYPE_AGFL,		"AGFL" }, \
-	{ XFS_SCRUB_TYPE_AGI,		"AGI" }
+	{ XFS_SCRUB_TYPE_AGI,		"AGI" }, \
+	{ XFS_SCRUB_TYPE_BNOBT,		"bnobt" }, \
+	{ XFS_SCRUB_TYPE_CNTBT,		"cntbt" }
 DECLARE_EVENT_CLASS(xfs_scrub_class,
 	TP_PROTO(struct xfs_inode *ip, int type, xfs_agnumber_t agno,
 		 xfs_ino_t inum, unsigned int gen, unsigned int flags,

