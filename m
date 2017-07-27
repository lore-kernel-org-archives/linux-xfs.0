Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:35945 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751680AbdG0WnV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Jul 2017 18:43:21 -0400
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v6RMhJX9007846
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 27 Jul 2017 22:43:20 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id v6RMhJPb012540
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 27 Jul 2017 22:43:19 GMT
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id v6RMhJwZ022199
        for <linux-xfs@vger.kernel.org>; Thu, 27 Jul 2017 22:43:19 GMT
Subject: [PATCH 16/26] xfs: scrub refcount btrees
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 27 Jul 2017 15:43:18 -0700
Message-ID: <150119539797.15159.9862462798690270623.stgit@magnolia>
In-Reply-To: <150119530010.15159.9900948790538082160.stgit@magnolia>
References: <150119530010.15159.9900948790538082160.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Plumb in the pieces necessary to check the refcount btree.  If rmap is
available, check the reference count by performing an interval query
against the rmapbt.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/Makefile         |    1 
 fs/xfs/libxfs/xfs_fs.h  |    3 +
 fs/xfs/scrub/common.h   |    2 +
 fs/xfs/scrub/refcount.c |   98 +++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/scrub.c    |    5 ++
 fs/xfs/scrub/scrub.h    |    1 
 fs/xfs/scrub/trace.h    |    3 +
 7 files changed, 111 insertions(+), 2 deletions(-)
 create mode 100644 fs/xfs/scrub/refcount.c


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 89585b7..8aa745c 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -149,6 +149,7 @@ xfs-y				+= $(addprefix scrub/, \
 				   btree.o \
 				   common.o \
 				   ialloc.o \
+				   refcount.o \
 				   rmap.o \
 				   scrub.o \
 				   )
diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index 74aa021..450a692 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -493,9 +493,10 @@ struct xfs_scrub_metadata {
 #define XFS_SCRUB_TYPE_INOBT	7	/* inode btree */
 #define XFS_SCRUB_TYPE_FINOBT	8	/* free inode btree */
 #define XFS_SCRUB_TYPE_RMAPBT	9	/* reverse mapping btree */
+#define XFS_SCRUB_TYPE_REFCNTBT	10	/* reference count btree */
 
 /* Number of scrub subcommands. */
-#define XFS_SCRUB_TYPE_NR	10
+#define XFS_SCRUB_TYPE_NR	11
 
 /* i: Repair this metadata. */
 #define XFS_SCRUB_IFLAG_REPAIR		(1 << 0)
diff --git a/fs/xfs/scrub/common.h b/fs/xfs/scrub/common.h
index 9075a5c..e50368d 100644
--- a/fs/xfs/scrub/common.h
+++ b/fs/xfs/scrub/common.h
@@ -100,6 +100,8 @@ int xfs_scrub_setup_ag_iallocbt(struct xfs_scrub_context *sc,
 				struct xfs_inode *ip);
 int xfs_scrub_setup_ag_rmapbt(struct xfs_scrub_context *sc,
 			      struct xfs_inode *ip);
+int xfs_scrub_setup_ag_refcountbt(struct xfs_scrub_context *sc,
+				  struct xfs_inode *ip);
 
 
 void xfs_scrub_ag_free(struct xfs_scrub_context *sc, struct xfs_scrub_ag *sa);
diff --git a/fs/xfs/scrub/refcount.c b/fs/xfs/scrub/refcount.c
new file mode 100644
index 0000000..581e47d
--- /dev/null
+++ b/fs/xfs/scrub/refcount.c
@@ -0,0 +1,98 @@
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
+#include "xfs_sb.h"
+#include "xfs_rmap.h"
+#include "scrub/xfs_scrub.h"
+#include "scrub/scrub.h"
+#include "scrub/common.h"
+#include "scrub/btree.h"
+#include "scrub/trace.h"
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
+	unsigned long long		rec_end;
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
+	xfs_scrub_btree_check_ok(bs->sc, bs->cur, 0,
+			(irec.rc_refcount == 1 && has_cowflag) ||
+			(irec.rc_refcount != 1 && !has_cowflag));
+	irec.rc_startblock &= ~XFS_REFC_COW_START;
+	rec_end = (unsigned long long)irec.rc_startblock + irec.rc_blockcount;
+	xfs_scrub_btree_check_ok(bs->sc, bs->cur, 0,
+			irec.rc_startblock < mp->m_sb.sb_agblocks &&
+			irec.rc_startblock < eoag &&
+			rec_end <= mp->m_sb.sb_agblocks &&
+			rec_end <= eoag &&
+			irec.rc_refcount >= 1);
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
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index dc5ddaf..e5b14d5 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -200,6 +200,11 @@ static const struct xfs_scrub_meta_ops meta_scrub_ops[] = {
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
diff --git a/fs/xfs/scrub/scrub.h b/fs/xfs/scrub/scrub.h
index f602ded..4cc4b84 100644
--- a/fs/xfs/scrub/scrub.h
+++ b/fs/xfs/scrub/scrub.h
@@ -71,5 +71,6 @@ int xfs_scrub_cntbt(struct xfs_scrub_context *sc);
 int xfs_scrub_inobt(struct xfs_scrub_context *sc);
 int xfs_scrub_finobt(struct xfs_scrub_context *sc);
 int xfs_scrub_rmapbt(struct xfs_scrub_context *sc);
+int xfs_scrub_refcountbt(struct xfs_scrub_context *sc);
 
 #endif	/* __XFS_SCRUB_SCRUB_H__ */
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index b04d8af..b5259c9 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -35,7 +35,8 @@
 	{ XFS_SCRUB_TYPE_CNTBT,		"cntbt" } , \
 	{ XFS_SCRUB_TYPE_INOBT,		"inobt" }, \
 	{ XFS_SCRUB_TYPE_FINOBT,	"finobt" }, \
-	{ XFS_SCRUB_TYPE_RMAPBT,	"rmapbt" }
+	{ XFS_SCRUB_TYPE_RMAPBT,	"rmapbt" }, \
+	{ XFS_SCRUB_TYPE_REFCNTBT,	"refcountbt" }
 DECLARE_EVENT_CLASS(xfs_scrub_class,
 	TP_PROTO(struct xfs_inode *ip, struct xfs_scrub_metadata *sm,
 		 int error),

