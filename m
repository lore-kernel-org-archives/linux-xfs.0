Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:41845 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751337AbdJCUmH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 Oct 2017 16:42:07 -0400
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v93Kg7S6002754
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 3 Oct 2017 20:42:07 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id v93Kg6s4001385
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 3 Oct 2017 20:42:06 GMT
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id v93Kg65J004299
        for <linux-xfs@vger.kernel.org>; Tue, 3 Oct 2017 20:42:06 GMT
Subject: [PATCH 12/25] xfs: scrub free space btrees
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 03 Oct 2017 13:42:05 -0700
Message-ID: <150706332522.19351.3718364611675005450.stgit@magnolia>
In-Reply-To: <150706324963.19351.17715069858921948692.stgit@magnolia>
References: <150706324963.19351.17715069858921948692.stgit@magnolia>
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
 fs/xfs/scrub/alloc.c   |  108 ++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/common.c  |   16 +++++++
 fs/xfs/scrub/common.h  |    6 +++
 fs/xfs/scrub/scrub.c   |    8 ++++
 fs/xfs/scrub/scrub.h   |    2 +
 7 files changed, 144 insertions(+), 1 deletion(-)
 create mode 100644 fs/xfs/scrub/alloc.c


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index e92d04d..84ac733 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -147,6 +147,7 @@ ifeq ($(CONFIG_XFS_ONLINE_SCRUB),y)
 xfs-y				+= $(addprefix scrub/, \
 				   trace.o \
 				   agheader.o \
+				   alloc.o \
 				   btree.o \
 				   common.o \
 				   scrub.o \
diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index 1e326dd..1e23d13 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -488,9 +488,11 @@ struct xfs_scrub_metadata {
 #define XFS_SCRUB_TYPE_AGF	2	/* AG free header */
 #define XFS_SCRUB_TYPE_AGFL	3	/* AG free list */
 #define XFS_SCRUB_TYPE_AGI	4	/* AG inode header */
+#define XFS_SCRUB_TYPE_BNOBT	5	/* freesp by block btree */
+#define XFS_SCRUB_TYPE_CNTBT	6	/* freesp by length btree */
 
 /* Number of scrub subcommands. */
-#define XFS_SCRUB_TYPE_NR	5
+#define XFS_SCRUB_TYPE_NR	7
 
 /* i: Repair this metadata. */
 #define XFS_SCRUB_IFLAG_REPAIR		(1 << 0)
diff --git a/fs/xfs/scrub/alloc.c b/fs/xfs/scrub/alloc.c
new file mode 100644
index 0000000..c1e97cd
--- /dev/null
+++ b/fs/xfs/scrub/alloc.c
@@ -0,0 +1,108 @@
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
+	unsigned long long		rec_end;
+	xfs_agblock_t			bno;
+	xfs_extlen_t			len;
+	int				error = 0;
+
+	bno = be32_to_cpu(rec->alloc.ar_startblock);
+	len = be32_to_cpu(rec->alloc.ar_blockcount);
+	agf = XFS_BUF_TO_AGF(bs->sc->sa.agf_bp);
+	rec_end = (unsigned long long)bno + len;
+
+	if (bno >= mp->m_sb.sb_agblocks ||
+	    bno >= be32_to_cpu(agf->agf_length) ||
+	    len == 0 ||
+	    rec_end > mp->m_sb.sb_agblocks ||
+	    rec_end > be32_to_cpu(agf->agf_length))
+		xfs_scrub_btree_set_corrupt(bs->sc, bs->cur, 0);
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
index 4f42401..4f8d103 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -543,3 +543,19 @@ xfs_scrub_setup_fs(
 {
 	return xfs_scrub_trans_alloc(sc->sm, sc->mp, &sc->tp);
 }
+
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
diff --git a/fs/xfs/scrub/common.h b/fs/xfs/scrub/common.h
index 4d8bb72..9a37e05 100644
--- a/fs/xfs/scrub/common.h
+++ b/fs/xfs/scrub/common.h
@@ -78,6 +78,9 @@ void xfs_scrub_set_incomplete(struct xfs_scrub_context *sc);
 int xfs_scrub_setup_fs(struct xfs_scrub_context *sc, struct xfs_inode *ip);
 int xfs_scrub_setup_ag_header(struct xfs_scrub_context *sc,
 			      struct xfs_inode *ip);
+int xfs_scrub_setup_ag_allocbt(struct xfs_scrub_context *sc,
+			       struct xfs_inode *ip);
+
 
 void xfs_scrub_ag_free(struct xfs_scrub_context *sc, struct xfs_scrub_ag *sa);
 int xfs_scrub_ag_init(struct xfs_scrub_context *sc, xfs_agnumber_t agno,
@@ -95,4 +98,7 @@ int xfs_scrub_walk_agfl(struct xfs_scrub_context *sc,
 				  void *),
 			void *priv);
 
+int xfs_scrub_setup_ag_btree(struct xfs_scrub_context *sc,
+			     struct xfs_inode *ip, bool force_log);
+
 #endif	/* __XFS_SCRUB_COMMON_H__ */
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index a62f53b..f543ce9 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -169,6 +169,14 @@ static const struct xfs_scrub_meta_ops meta_scrub_ops[] = {
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
 
 /* This isn't a stable feature, warn once per day. */
diff --git a/fs/xfs/scrub/scrub.h b/fs/xfs/scrub/scrub.h
index 09952c2..a4af99c 100644
--- a/fs/xfs/scrub/scrub.h
+++ b/fs/xfs/scrub/scrub.h
@@ -71,5 +71,7 @@ int xfs_scrub_superblock(struct xfs_scrub_context *sc);
 int xfs_scrub_agf(struct xfs_scrub_context *sc);
 int xfs_scrub_agfl(struct xfs_scrub_context *sc);
 int xfs_scrub_agi(struct xfs_scrub_context *sc);
+int xfs_scrub_bnobt(struct xfs_scrub_context *sc);
+int xfs_scrub_cntbt(struct xfs_scrub_context *sc);
 
 #endif	/* __XFS_SCRUB_SCRUB_H__ */

