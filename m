Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:24720 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750971AbdFBWcA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Jun 2017 18:32:00 -0400
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v52MVxZd002971
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 2 Jun 2017 22:32:00 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id v52MVxKr019620
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 2 Jun 2017 22:31:59 GMT
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id v52MVx8q000910
        for <linux-xfs@vger.kernel.org>; Fri, 2 Jun 2017 22:31:59 GMT
Subject: [PATCH 11/19] xfs: scrub refcount btrees
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 02 Jun 2017 15:31:57 -0700
Message-ID: <149644271754.19430.12333024000511962113.stgit@birch.djwong.org>
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

Plumb in the pieces necessary to check the refcount btree.  If rmap is
available, check the reference count by performing an interval query
against the rmapbt.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/Makefile         |    1 
 fs/xfs/libxfs/xfs_fs.h  |    3 +
 fs/xfs/scrub/common.c   |    5 ++
 fs/xfs/scrub/common.h   |    2 +
 fs/xfs/scrub/refcount.c |   96 +++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_trace.h      |    3 +
 6 files changed, 108 insertions(+), 2 deletions(-)
 create mode 100644 fs/xfs/scrub/refcount.c


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index b0e3013..54afcbd 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -109,6 +109,7 @@ xfs-$(CONFIG_XFS_DEBUG)		+= $(addprefix scrub/, \
 				   btree.o \
 				   common.o \
 				   ialloc.o \
+				   refcount.o \
 				   rmap.o \
 				   )
 
diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index 72b27e6..fe6d5a8 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -502,7 +502,8 @@ struct xfs_scrub_metadata {
 #define XFS_SCRUB_TYPE_INOBT	7	/* inode btree */
 #define XFS_SCRUB_TYPE_FINOBT	8	/* free inode btree */
 #define XFS_SCRUB_TYPE_RMAPBT	9	/* reverse mapping btree */
-#define XFS_SCRUB_TYPE_MAX	9
+#define XFS_SCRUB_TYPE_REFCNTBT	10	/* reference count btree */
+#define XFS_SCRUB_TYPE_MAX	10
 
 #define XFS_SCRUB_FLAG_REPAIR	0x01	/* i: repair this metadata */
 #define XFS_SCRUB_FLAG_CORRUPT	0x02	/* o: needs repair */
diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index db86e8b..031338a 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -699,6 +699,11 @@ static const struct xfs_scrub_meta_fns meta_scrub_fns[] = {
 		.scrub	= xfs_scrub_rmapbt,
 		.has	= xfs_sb_version_hasrmapbt,
 	},
+	{ /* refcountbt */
+		.setup	= xfs_scrub_setup_ag_refcountbt,
+		.scrub	= xfs_scrub_refcountbt,
+		.has	= xfs_sb_version_hasreflink,
+	},
 };
 
 /* Dispatch metadata scrubbing. */
diff --git a/fs/xfs/scrub/common.h b/fs/xfs/scrub/common.h
index ec12d90..12e7e60 100644
--- a/fs/xfs/scrub/common.h
+++ b/fs/xfs/scrub/common.h
@@ -203,6 +203,7 @@ SETUP_FN(xfs_scrub_setup_ag_header);
 SETUP_FN(xfs_scrub_setup_ag_allocbt);
 SETUP_FN(xfs_scrub_setup_ag_iallocbt);
 SETUP_FN(xfs_scrub_setup_ag_rmapbt);
+SETUP_FN(xfs_scrub_setup_ag_refcountbt);
 #undef SETUP_FN
 
 /* Metadata scrubbers */
@@ -217,6 +218,7 @@ SCRUB_FN(xfs_scrub_cntbt);
 SCRUB_FN(xfs_scrub_inobt);
 SCRUB_FN(xfs_scrub_finobt);
 SCRUB_FN(xfs_scrub_rmapbt);
+SCRUB_FN(xfs_scrub_refcountbt);
 #undef SCRUB_FN
 
 #endif	/* __XFS_REPAIR_COMMON_H__ */
diff --git a/fs/xfs/scrub/refcount.c b/fs/xfs/scrub/refcount.c
new file mode 100644
index 0000000..fcc72c5
--- /dev/null
+++ b/fs/xfs/scrub/refcount.c
@@ -0,0 +1,96 @@
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
+ * Set us up to scrub reference count btrees.
+ */
+int
+xfs_scrub_setup_ag_refcountbt(
+	struct xfs_scrub_context	*sc,
+	struct xfs_inode		*ip)
+{
+	return xfs_scrub_setup_ag_btree(sc, ip, false);
+}
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
index b1fb867..effaa47 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -3339,7 +3339,8 @@ DEFINE_GETFSMAP_EVENT(xfs_getfsmap_mapping);
 	{ XFS_SCRUB_TYPE_CNTBT,		"cntbt" }, \
 	{ XFS_SCRUB_TYPE_INOBT,		"inobt" }, \
 	{ XFS_SCRUB_TYPE_FINOBT,	"finobt" }, \
-	{ XFS_SCRUB_TYPE_RMAPBT,	"rmapbt" }
+	{ XFS_SCRUB_TYPE_RMAPBT,	"rmapbt" }, \
+	{ XFS_SCRUB_TYPE_REFCNTBT,	"refcountbt" }
 DECLARE_EVENT_CLASS(xfs_scrub_class,
 	TP_PROTO(struct xfs_inode *ip, struct xfs_scrub_metadata *sm,
 		 int error),

