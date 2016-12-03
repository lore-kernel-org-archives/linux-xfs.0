Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1050.oracle.com ([156.151.31.82]:32161 "EHLO
        userp1050.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758631AbcLCBjd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Dec 2016 20:39:33 -0500
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81])
        by userp1050.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id uB31dGJY009281
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 3 Dec 2016 01:39:16 GMT
Subject: [PATCH 25/55] xfs: support scrubbing refcount btree
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 02 Dec 2016 17:37:59 -0800
Message-ID: <148072907892.12995.16510284382517212253.stgit@birch.djwong.org>
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

Plumb in the pieces necessary to check the refcount btree.  If rmap is
available, check the reference count by performing an interval query
against the rmapbt.

v2: Handle the case where the rmap records are not all at least the
length of the refcount extent.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/Makefile                    |    1 
 fs/xfs/libxfs/xfs_fs.h             |    3 +
 fs/xfs/libxfs/xfs_refcount_btree.c |    4 --
 fs/xfs/repair/common.c             |    1 
 fs/xfs/repair/common.h             |    1 
 fs/xfs/repair/refcount.c           |   85 ++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_trace.h                 |    3 +
 7 files changed, 92 insertions(+), 6 deletions(-)
 create mode 100644 fs/xfs/repair/refcount.c


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index ca367e0..e81212a 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -108,6 +108,7 @@ xfs-$(CONFIG_XFS_ONLINE_REPAIR)	+= $(addprefix repair/, \
 				   btree.o \
 				   common.o \
 				   ialloc.o \
+				   refcount.o \
 				   rmap.o \
 				   )
 
diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index a5e0d51..559ee76 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -584,7 +584,8 @@ struct xfs_scrub_metadata {
 #define XFS_SCRUB_TYPE_INOBT	7	/* inode btree */
 #define XFS_SCRUB_TYPE_FINOBT	8	/* free inode btree */
 #define XFS_SCRUB_TYPE_RMAPBT	9	/* reverse mapping btree */
-#define XFS_SCRUB_TYPE_MAX	9
+#define XFS_SCRUB_TYPE_REFCNTBT	10	/* reference count btree */
+#define XFS_SCRUB_TYPE_MAX	10
 
 #define XFS_SCRUB_FLAG_REPAIR	0x1	/* i: repair this metadata */
 #define XFS_SCRUB_FLAG_CORRUPT	0x2	/* o: needs repair */
diff --git a/fs/xfs/libxfs/xfs_refcount_btree.c b/fs/xfs/libxfs/xfs_refcount_btree.c
index 453bb27..2b1ea4c 100644
--- a/fs/xfs/libxfs/xfs_refcount_btree.c
+++ b/fs/xfs/libxfs/xfs_refcount_btree.c
@@ -285,7 +285,6 @@ const struct xfs_buf_ops xfs_refcountbt_buf_ops = {
 	.verify_write		= xfs_refcountbt_write_verify,
 };
 
-#if defined(DEBUG) || defined(XFS_WARN)
 STATIC int
 xfs_refcountbt_keys_inorder(
 	struct xfs_btree_cur	*cur,
@@ -306,7 +305,6 @@ xfs_refcountbt_recs_inorder(
 		be32_to_cpu(r1->refc.rc_blockcount) <=
 		be32_to_cpu(r2->refc.rc_startblock);
 }
-#endif
 
 static const struct xfs_btree_ops xfs_refcountbt_ops = {
 	.rec_len		= sizeof(struct xfs_refcount_rec),
@@ -325,10 +323,8 @@ static const struct xfs_btree_ops xfs_refcountbt_ops = {
 	.key_diff		= xfs_refcountbt_key_diff,
 	.buf_ops		= &xfs_refcountbt_buf_ops,
 	.diff_two_keys		= xfs_refcountbt_diff_two_keys,
-#if defined(DEBUG) || defined(XFS_WARN)
 	.keys_inorder		= xfs_refcountbt_keys_inorder,
 	.recs_inorder		= xfs_refcountbt_recs_inorder,
-#endif
 };
 
 /*
diff --git a/fs/xfs/repair/common.c b/fs/xfs/repair/common.c
index c017c3f..a1bdf62 100644
--- a/fs/xfs/repair/common.c
+++ b/fs/xfs/repair/common.c
@@ -706,6 +706,7 @@ static const struct xfs_scrub_meta_fns meta_scrub_fns[] = {
 	{xfs_scrub_setup_ag_header, xfs_scrub_inobt, NULL, NULL},
 	{xfs_scrub_setup_ag_header, xfs_scrub_finobt, NULL, xfs_sb_version_hasfinobt},
 	{xfs_scrub_setup_ag_header, xfs_scrub_rmapbt, NULL, xfs_sb_version_hasrmapbt},
+	{xfs_scrub_setup_ag_header, xfs_scrub_refcountbt, NULL, xfs_sb_version_hasreflink},
 };
 
 /* Dispatch metadata scrubbing. */
diff --git a/fs/xfs/repair/common.h b/fs/xfs/repair/common.h
index 412feef..3c24b58 100644
--- a/fs/xfs/repair/common.h
+++ b/fs/xfs/repair/common.h
@@ -203,5 +203,6 @@ int xfs_scrub_cntbt(struct xfs_scrub_context *sc);
 int xfs_scrub_inobt(struct xfs_scrub_context *sc);
 int xfs_scrub_finobt(struct xfs_scrub_context *sc);
 int xfs_scrub_rmapbt(struct xfs_scrub_context *sc);
+int xfs_scrub_refcountbt(struct xfs_scrub_context *sc);
 
 #endif	/* __XFS_REPAIR_COMMON_H__ */
diff --git a/fs/xfs/repair/refcount.c b/fs/xfs/repair/refcount.c
new file mode 100644
index 0000000..740888b
--- /dev/null
+++ b/fs/xfs/repair/refcount.c
@@ -0,0 +1,85 @@
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
+/* Reference count btree scrubber. */
+
+/* Scrub a refcountbt record. */
+STATIC int
+xfs_scrub_refcountbt_helper(
+	struct xfs_scrub_btree		*bs,
+	union xfs_btree_rec		*rec)
+{
+	struct xfs_mount		*mp = bs->cur->bc_mp;
+	struct xfs_agf			*agf;
+	struct xfs_refcount_irec	irec;
+	xfs_agblock_t			eoag;
+	bool				has_cowflag;
+	int				error = 0;
+
+	irec.rc_startblock = be32_to_cpu(rec->refc.rc_startblock);
+	irec.rc_blockcount = be32_to_cpu(rec->refc.rc_blockcount);
+	irec.rc_refcount = be32_to_cpu(rec->refc.rc_refcount);
+	agf = XFS_BUF_TO_AGF(bs->sc->sa.agf_bp);
+	eoag = be32_to_cpu(agf->agf_length);
+
+	has_cowflag = !!(irec.rc_startblock & XFS_REFC_COW_START);
+	XFS_SCRUB_BTREC_CHECK(bs, (irec.rc_refcount == 1 && has_cowflag) ||
+				  (irec.rc_refcount != 1 && !has_cowflag));
+	irec.rc_startblock &= ~XFS_REFC_COW_START;
+	XFS_SCRUB_BTREC_CHECK(bs, irec.rc_startblock < mp->m_sb.sb_agblocks);
+	XFS_SCRUB_BTREC_CHECK(bs, irec.rc_startblock < eoag);
+	XFS_SCRUB_BTREC_CHECK(bs, irec.rc_startblock < irec.rc_startblock +
+			irec.rc_blockcount);
+	XFS_SCRUB_BTREC_CHECK(bs, (unsigned long long)irec.rc_startblock +
+			irec.rc_blockcount <= mp->m_sb.sb_agblocks);
+	XFS_SCRUB_BTREC_CHECK(bs, (unsigned long long)irec.rc_startblock +
+			irec.rc_blockcount <= eoag);
+	XFS_SCRUB_BTREC_CHECK(bs, irec.rc_refcount >= 1);
+
+	return error;
+}
+
+/* Scrub the refcount btree for some AG. */
+int
+xfs_scrub_refcountbt(
+	struct xfs_scrub_context	*sc)
+{
+	struct xfs_owner_info		oinfo;
+
+	xfs_rmap_ag_owner(&oinfo, XFS_RMAP_OWN_REFC);
+	return xfs_scrub_btree(sc, sc->sa.refc_cur, xfs_scrub_refcountbt_helper,
+			&oinfo, NULL);
+}
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 94cde25..4e27db0 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -3471,7 +3471,8 @@ DEFINE_GETFSMAP_EVENT(xfs_getfsmap_mapping);
 	{ XFS_SCRUB_TYPE_CNTBT,		"cntbt" }, \
 	{ XFS_SCRUB_TYPE_INOBT,		"inobt" }, \
 	{ XFS_SCRUB_TYPE_FINOBT,	"finobt" }, \
-	{ XFS_SCRUB_TYPE_RMAPBT,	"rmapbt" }
+	{ XFS_SCRUB_TYPE_RMAPBT,	"rmapbt" }, \
+	{ XFS_SCRUB_TYPE_REFCNTBT,	"refcountbt" }
 DECLARE_EVENT_CLASS(xfs_scrub_class,
 	TP_PROTO(struct xfs_inode *ip, int type, xfs_agnumber_t agno,
 		 xfs_ino_t inum, unsigned int gen, unsigned int flags,

