Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:28147 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752807AbdJLBm4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 11 Oct 2017 21:42:56 -0400
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v9C1gtn0000446
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 12 Oct 2017 01:42:55 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id v9C1gt4I007393
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 12 Oct 2017 01:42:55 GMT
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id v9C1gt8g029114
        for <linux-xfs@vger.kernel.org>; Thu, 12 Oct 2017 01:42:55 GMT
Subject: [PATCH 20/30] xfs: scrub refcount btrees
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 11 Oct 2017 18:42:53 -0700
Message-ID: <150777257372.1724.10044986248908141456.stgit@magnolia>
In-Reply-To: <150777244315.1724.6916081372861799350.stgit@magnolia>
References: <150777244315.1724.6916081372861799350.stgit@magnolia>
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
 fs/xfs/scrub/common.h   |    2 +
 fs/xfs/scrub/refcount.c |   99 +++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/scrub.c    |    5 ++
 fs/xfs/scrub/scrub.h    |    1 
 6 files changed, 110 insertions(+), 1 deletion(-)
 create mode 100644 fs/xfs/scrub/refcount.c


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 5a64f8d..a7c5752 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -151,6 +151,7 @@ xfs-y				+= $(addprefix scrub/, \
 				   btree.o \
 				   common.o \
 				   ialloc.o \
+				   refcount.o \
 				   rmap.o \
 				   scrub.o \
 				   )
diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index fb1d997..b3f992c 100644
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
index 7922775..610e956 100644
--- a/fs/xfs/scrub/common.h
+++ b/fs/xfs/scrub/common.h
@@ -85,6 +85,8 @@ int xfs_scrub_setup_ag_iallocbt(struct xfs_scrub_context *sc,
 				struct xfs_inode *ip);
 int xfs_scrub_setup_ag_rmapbt(struct xfs_scrub_context *sc,
 			      struct xfs_inode *ip);
+int xfs_scrub_setup_ag_refcountbt(struct xfs_scrub_context *sc,
+				  struct xfs_inode *ip);
 
 
 void xfs_scrub_ag_free(struct xfs_scrub_context *sc, struct xfs_scrub_ag *sa);
diff --git a/fs/xfs/scrub/refcount.c b/fs/xfs/scrub/refcount.c
new file mode 100644
index 0000000..2aab775
--- /dev/null
+++ b/fs/xfs/scrub/refcount.c
@@ -0,0 +1,99 @@
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
+#include "xfs_alloc.h"
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
+	xfs_agnumber_t			agno = bs->cur->bc_private.a.agno;
+	xfs_agblock_t			bno;
+	xfs_extlen_t			len;
+	xfs_nlink_t			refcount;
+	bool				has_cowflag;
+	int				error = 0;
+
+	bno = be32_to_cpu(rec->refc.rc_startblock);
+	len = be32_to_cpu(rec->refc.rc_blockcount);
+	refcount = be32_to_cpu(rec->refc.rc_refcount);
+
+	/* Only CoW records can have refcount == 1. */
+	has_cowflag = (bno & XFS_REFC_COW_START);
+	if ((refcount == 1 && !has_cowflag) || (refcount != 1 && has_cowflag))
+		xfs_scrub_btree_set_corrupt(bs->sc, bs->cur, 0);
+
+	/* Check the extent. */
+	bno &= ~XFS_REFC_COW_START;
+	if (bno + len <= bno ||
+	    !xfs_verify_agbno_ptr(mp, agno, bno) ||
+	    !xfs_verify_agbno_ptr(mp, agno, bno + len - 1))
+		xfs_scrub_btree_set_corrupt(bs->sc, bs->cur, 0);
+
+	if (refcount == 0)
+		xfs_scrub_btree_set_corrupt(bs->sc, bs->cur, 0);
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
index 9239cb3..10c9078 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -186,6 +186,11 @@ static const struct xfs_scrub_meta_ops meta_scrub_ops[] = {
 		.scrub	= xfs_scrub_rmapbt,
 		.has	= xfs_sb_version_hasrmapbt,
 	},
+	{ /* refcountbt */
+		.setup	= xfs_scrub_setup_ag_refcountbt,
+		.scrub	= xfs_scrub_refcountbt,
+		.has	= xfs_sb_version_hasreflink,
+	},
 };
 
 /* This isn't a stable feature, warn once per day. */
diff --git a/fs/xfs/scrub/scrub.h b/fs/xfs/scrub/scrub.h
index 0d1e78b..1c80bf5 100644
--- a/fs/xfs/scrub/scrub.h
+++ b/fs/xfs/scrub/scrub.h
@@ -76,5 +76,6 @@ int xfs_scrub_cntbt(struct xfs_scrub_context *sc);
 int xfs_scrub_inobt(struct xfs_scrub_context *sc);
 int xfs_scrub_finobt(struct xfs_scrub_context *sc);
 int xfs_scrub_rmapbt(struct xfs_scrub_context *sc);
+int xfs_scrub_refcountbt(struct xfs_scrub_context *sc);
 
 #endif	/* __XFS_SCRUB_SCRUB_H__ */

