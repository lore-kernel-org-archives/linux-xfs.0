Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1050.oracle.com ([141.146.126.70]:21493 "EHLO
        aserp1050.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758911AbcLCBjd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Dec 2016 20:39:33 -0500
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69])
        by aserp1050.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id uB31dG3E000434
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 3 Dec 2016 01:39:16 GMT
Subject: [PATCH 24/55] xfs: support scrubbing rmap btree
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 02 Dec 2016 17:37:52 -0800
Message-ID: <148072907268.12995.6163861609108435433.stgit@birch.djwong.org>
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

Check the reverse mapping records to make sure that the contents
make sense.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/Makefile                |    1 
 fs/xfs/libxfs/xfs_fs.h         |    3 +
 fs/xfs/libxfs/xfs_rmap.c       |    3 +
 fs/xfs/libxfs/xfs_rmap.h       |    3 +
 fs/xfs/libxfs/xfs_rmap_btree.c |    4 -
 fs/xfs/repair/common.c         |    1 
 fs/xfs/repair/common.h         |    1 
 fs/xfs/repair/rmap.c           |  116 ++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_trace.h             |    3 +
 9 files changed, 128 insertions(+), 7 deletions(-)
 create mode 100644 fs/xfs/repair/rmap.c


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index c434fd8..ca367e0 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -108,6 +108,7 @@ xfs-$(CONFIG_XFS_ONLINE_REPAIR)	+= $(addprefix repair/, \
 				   btree.o \
 				   common.o \
 				   ialloc.o \
+				   rmap.o \
 				   )
 
 # low-level transaction/log code
diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index 00be3ca..a5e0d51 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -583,7 +583,8 @@ struct xfs_scrub_metadata {
 #define XFS_SCRUB_TYPE_CNTBT	6	/* freesp by length btree */
 #define XFS_SCRUB_TYPE_INOBT	7	/* inode btree */
 #define XFS_SCRUB_TYPE_FINOBT	8	/* free inode btree */
-#define XFS_SCRUB_TYPE_MAX	8
+#define XFS_SCRUB_TYPE_RMAPBT	9	/* reverse mapping btree */
+#define XFS_SCRUB_TYPE_MAX	9
 
 #define XFS_SCRUB_FLAG_REPAIR	0x1	/* i: repair this metadata */
 #define XFS_SCRUB_FLAG_CORRUPT	0x2	/* o: needs repair */
diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
index 3840556..c7d5102 100644
--- a/fs/xfs/libxfs/xfs_rmap.c
+++ b/fs/xfs/libxfs/xfs_rmap.c
@@ -179,7 +179,8 @@ xfs_rmap_delete(
 	return error;
 }
 
-static int
+/* Convert an internal btree record to an rmap record. */
+int
 xfs_rmap_btrec_to_irec(
 	union xfs_btree_rec	*rec,
 	struct xfs_rmap_irec	*irec)
diff --git a/fs/xfs/libxfs/xfs_rmap.h b/fs/xfs/libxfs/xfs_rmap.h
index faf2c1a..3fa4559 100644
--- a/fs/xfs/libxfs/xfs_rmap.h
+++ b/fs/xfs/libxfs/xfs_rmap.h
@@ -214,5 +214,8 @@ int xfs_rmap_find_left_neighbor(struct xfs_btree_cur *cur, xfs_agblock_t bno,
 int xfs_rmap_lookup_le_range(struct xfs_btree_cur *cur, xfs_agblock_t bno,
 		uint64_t owner, uint64_t offset, unsigned int flags,
 		struct xfs_rmap_irec *irec, int	*stat);
+union xfs_btree_rec;
+int xfs_rmap_btrec_to_irec(union xfs_btree_rec *rec,
+		struct xfs_rmap_irec *irec);
 
 #endif	/* __XFS_RMAP_H__ */
diff --git a/fs/xfs/libxfs/xfs_rmap_btree.c b/fs/xfs/libxfs/xfs_rmap_btree.c
index 83e672f..045f075 100644
--- a/fs/xfs/libxfs/xfs_rmap_btree.c
+++ b/fs/xfs/libxfs/xfs_rmap_btree.c
@@ -377,7 +377,6 @@ const struct xfs_buf_ops xfs_rmapbt_buf_ops = {
 	.verify_write		= xfs_rmapbt_write_verify,
 };
 
-#if defined(DEBUG) || defined(XFS_WARN)
 STATIC int
 xfs_rmapbt_keys_inorder(
 	struct xfs_btree_cur	*cur,
@@ -437,7 +436,6 @@ xfs_rmapbt_recs_inorder(
 		return 1;
 	return 0;
 }
-#endif	/* DEBUG */
 
 static const struct xfs_btree_ops xfs_rmapbt_ops = {
 	.rec_len		= sizeof(struct xfs_rmap_rec),
@@ -456,10 +454,8 @@ static const struct xfs_btree_ops xfs_rmapbt_ops = {
 	.key_diff		= xfs_rmapbt_key_diff,
 	.buf_ops		= &xfs_rmapbt_buf_ops,
 	.diff_two_keys		= xfs_rmapbt_diff_two_keys,
-#if defined(DEBUG) || defined(XFS_WARN)
 	.keys_inorder		= xfs_rmapbt_keys_inorder,
 	.recs_inorder		= xfs_rmapbt_recs_inorder,
-#endif
 };
 
 /*
diff --git a/fs/xfs/repair/common.c b/fs/xfs/repair/common.c
index 30ed13f..c017c3f 100644
--- a/fs/xfs/repair/common.c
+++ b/fs/xfs/repair/common.c
@@ -705,6 +705,7 @@ static const struct xfs_scrub_meta_fns meta_scrub_fns[] = {
 	{xfs_scrub_setup_ag_header, xfs_scrub_cntbt, NULL, NULL},
 	{xfs_scrub_setup_ag_header, xfs_scrub_inobt, NULL, NULL},
 	{xfs_scrub_setup_ag_header, xfs_scrub_finobt, NULL, xfs_sb_version_hasfinobt},
+	{xfs_scrub_setup_ag_header, xfs_scrub_rmapbt, NULL, xfs_sb_version_hasrmapbt},
 };
 
 /* Dispatch metadata scrubbing. */
diff --git a/fs/xfs/repair/common.h b/fs/xfs/repair/common.h
index 7b71cb3..412feef 100644
--- a/fs/xfs/repair/common.h
+++ b/fs/xfs/repair/common.h
@@ -202,5 +202,6 @@ int xfs_scrub_bnobt(struct xfs_scrub_context *sc);
 int xfs_scrub_cntbt(struct xfs_scrub_context *sc);
 int xfs_scrub_inobt(struct xfs_scrub_context *sc);
 int xfs_scrub_finobt(struct xfs_scrub_context *sc);
+int xfs_scrub_rmapbt(struct xfs_scrub_context *sc);
 
 #endif	/* __XFS_REPAIR_COMMON_H__ */
diff --git a/fs/xfs/repair/rmap.c b/fs/xfs/repair/rmap.c
new file mode 100644
index 0000000..d84bef1
--- /dev/null
+++ b/fs/xfs/repair/rmap.c
@@ -0,0 +1,116 @@
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
+/* Reverse-mapping scrubber. */
+
+/* Scrub an rmapbt record. */
+STATIC int
+xfs_scrub_rmapbt_helper(
+	struct xfs_scrub_btree		*bs,
+	union xfs_btree_rec		*rec)
+{
+	struct xfs_mount		*mp = bs->cur->bc_mp;
+	struct xfs_agf			*agf;
+	struct xfs_rmap_irec		irec;
+	xfs_agblock_t			eoag;
+	bool				non_inode;
+	bool				is_unwritten;
+	bool				is_bmbt;
+	bool				is_attr;
+	int				error;
+
+	error = xfs_rmap_btrec_to_irec(rec, &irec);
+	XFS_SCRUB_BTREC_OP_ERROR_GOTO(bs, &error, out);
+
+	/* Check extent. */
+	agf = XFS_BUF_TO_AGF(bs->sc->sa.agf_bp);
+	eoag = be32_to_cpu(agf->agf_length);
+	XFS_SCRUB_BTREC_CHECK(bs, irec.rm_startblock < mp->m_sb.sb_agblocks);
+	XFS_SCRUB_BTREC_CHECK(bs, irec.rm_startblock < eoag);
+	XFS_SCRUB_BTREC_CHECK(bs, irec.rm_startblock < irec.rm_startblock +
+			irec.rm_blockcount);
+	XFS_SCRUB_BTREC_CHECK(bs, irec.rm_startblock + irec.rm_blockcount <=
+			mp->m_sb.sb_agblocks);
+	XFS_SCRUB_BTREC_CHECK(bs, irec.rm_startblock + irec.rm_blockcount <=
+			eoag);
+
+	/* Check flags. */
+	non_inode = XFS_RMAP_NON_INODE_OWNER(irec.rm_owner);
+	is_bmbt = irec.rm_flags & XFS_RMAP_BMBT_BLOCK;
+	is_attr = irec.rm_flags & XFS_RMAP_ATTR_FORK;
+	is_unwritten = irec.rm_flags & XFS_RMAP_UNWRITTEN;
+
+	XFS_SCRUB_BTREC_CHECK(bs, !is_bmbt || irec.rm_offset == 0);
+	XFS_SCRUB_BTREC_CHECK(bs, !non_inode || irec.rm_offset == 0);
+	XFS_SCRUB_BTREC_CHECK(bs, !is_unwritten || !(is_bmbt || non_inode ||
+			is_attr));
+	XFS_SCRUB_BTREC_CHECK(bs, !non_inode || !(is_bmbt || is_unwritten ||
+			is_attr));
+
+	/* Owner inode within an AG? */
+	XFS_SCRUB_BTREC_CHECK(bs, non_inode ||
+			(XFS_INO_TO_AGNO(mp, irec.rm_owner) <
+							mp->m_sb.sb_agcount &&
+			 XFS_AGINO_TO_AGBNO(mp,
+				XFS_INO_TO_AGINO(mp, irec.rm_owner)) <
+							mp->m_sb.sb_agblocks));
+	/* Owner inode within the FS? */
+	XFS_SCRUB_BTREC_CHECK(bs, non_inode ||
+			XFS_AGB_TO_DADDR(mp,
+				XFS_INO_TO_AGNO(mp, irec.rm_owner),
+				XFS_AGINO_TO_AGBNO(mp,
+					XFS_INO_TO_AGINO(mp, irec.rm_owner))) <
+			XFS_FSB_TO_BB(mp, mp->m_sb.sb_dblocks));
+
+	/* Non-inode owner within the magic values? */
+	XFS_SCRUB_BTREC_CHECK(bs, !non_inode ||
+			(irec.rm_owner > XFS_RMAP_OWN_MIN &&
+			 irec.rm_owner <= XFS_RMAP_OWN_FS));
+out:
+	return error;
+}
+
+/* Scrub the rmap btree for some AG. */
+int
+xfs_scrub_rmapbt(
+	struct xfs_scrub_context	*sc)
+{
+	struct xfs_owner_info		oinfo;
+
+	xfs_rmap_ag_owner(&oinfo, XFS_RMAP_OWN_AG);
+	return xfs_scrub_btree(sc, sc->sa.rmap_cur, xfs_scrub_rmapbt_helper,
+			&oinfo, NULL);
+}
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index a00c6c5..94cde25 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -3470,7 +3470,8 @@ DEFINE_GETFSMAP_EVENT(xfs_getfsmap_mapping);
 	{ XFS_SCRUB_TYPE_BNOBT,		"bnobt" }, \
 	{ XFS_SCRUB_TYPE_CNTBT,		"cntbt" }, \
 	{ XFS_SCRUB_TYPE_INOBT,		"inobt" }, \
-	{ XFS_SCRUB_TYPE_FINOBT,	"finobt" }
+	{ XFS_SCRUB_TYPE_FINOBT,	"finobt" }, \
+	{ XFS_SCRUB_TYPE_RMAPBT,	"rmapbt" }
 DECLARE_EVENT_CLASS(xfs_scrub_class,
 	TP_PROTO(struct xfs_inode *ip, int type, xfs_agnumber_t agno,
 		 xfs_ino_t inum, unsigned int gen, unsigned int flags,

