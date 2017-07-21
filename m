Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:49522 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750743AbdGUEjD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Jul 2017 00:39:03 -0400
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v6L4d23r029893
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 21 Jul 2017 04:39:02 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id v6L4d2iB027307
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 21 Jul 2017 04:39:02 GMT
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id v6L4d2UY008511
        for <linux-xfs@vger.kernel.org>; Fri, 21 Jul 2017 04:39:02 GMT
Subject: [PATCH 05/22] xfs: scrub in-memory metadata buffers
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 20 Jul 2017 21:39:00 -0700
Message-ID: <150061194082.14732.17289613506653968866.stgit@magnolia>
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

Call the verifier function for all in-memory metadata buffers, looking
for memory corruption either due to bad memory or coding bugs.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/Makefile         |    1 
 fs/xfs/libxfs/xfs_fs.h  |    3 +
 fs/xfs/scrub/common.c   |    4 +
 fs/xfs/scrub/common.h   |    2 +
 fs/xfs/scrub/metabufs.c |  177 +++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_trace.h      |    3 +
 6 files changed, 188 insertions(+), 2 deletions(-)
 create mode 100644 fs/xfs/scrub/metabufs.c


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 4e04da9..67cf4ac 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -142,5 +142,6 @@ ifeq ($(CONFIG_XFS_ONLINE_SCRUB),y)
 xfs-y				+= $(addprefix scrub/, \
 				   btree.o \
 				   common.o \
+				   metabufs.o \
 				   )
 endif
diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index aeccc99..9fb3c65 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -482,7 +482,8 @@ struct xfs_scrub_metadata {
  * Metadata types and flags for scrub operation.
  */
 #define XFS_SCRUB_TYPE_TEST	0	/* dummy to test ioctl */
-#define XFS_SCRUB_TYPE_MAX	0
+#define XFS_SCRUB_TYPE_METABUFS	1	/* in-core metadata buffers */
+#define XFS_SCRUB_TYPE_MAX	1
 
 /* i: repair this metadata */
 #define XFS_SCRUB_FLAG_REPAIR		(1 << 0)
diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index 331aa14..e06131f 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -610,6 +610,10 @@ static const struct xfs_scrub_meta_fns meta_scrub_fns[] = {
 		.setup	= xfs_scrub_setup_fs,
 		.scrub	= xfs_scrub_dummy,
 	},
+	{ /* in-memory metadata buffers */
+		.setup	= xfs_scrub_setup_metabufs,
+		.scrub	= xfs_scrub_metabufs,
+	},
 };
 
 /* Dispatch metadata scrubbing. */
diff --git a/fs/xfs/scrub/common.h b/fs/xfs/scrub/common.h
index 15baccb..5f0818c 100644
--- a/fs/xfs/scrub/common.h
+++ b/fs/xfs/scrub/common.h
@@ -198,12 +198,14 @@ int xfs_scrub_ag_btcur_init(struct xfs_scrub_context *sc,
 
 #define SETUP_FN(name) int name(struct xfs_scrub_context *sc, struct xfs_inode *ip)
 SETUP_FN(xfs_scrub_setup_fs);
+SETUP_FN(xfs_scrub_setup_metabufs);
 #undef SETUP_FN
 
 /* Metadata scrubbers */
 
 #define SCRUB_FN(name) int name(struct xfs_scrub_context *sc)
 SCRUB_FN(xfs_scrub_dummy);
+SCRUB_FN(xfs_scrub_metabufs);
 #undef SCRUB_FN
 
 #endif	/* __XFS_REPAIR_COMMON_H__ */
diff --git a/fs/xfs/scrub/metabufs.c b/fs/xfs/scrub/metabufs.c
new file mode 100644
index 0000000..63faaa6
--- /dev/null
+++ b/fs/xfs/scrub/metabufs.c
@@ -0,0 +1,177 @@
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
+#include "scrub/common.h"
+
+/* We only iterate buffers one by one, so we don't need any setup. */
+int
+xfs_scrub_setup_metabufs(
+	struct xfs_scrub_context	*sc,
+	struct xfs_inode		*ip)
+{
+	return 0;
+}
+
+#define XFS_SCRUB_METABUFS_TOO_MANY_RETRIES	10
+struct xfs_scrub_metabufs_info {
+	struct xfs_scrub_context	*sc;
+	unsigned int			retries;
+};
+
+/* In-memory buffer corruption. */
+
+#define XFS_SCRUB_BUF_OP_ERROR_GOTO(label) \
+	XFS_SCRUB_OP_ERROR_GOTO(smi->sc, \
+			xfs_daddr_to_agno(smi->sc->mp, bp->b_bn), \
+			xfs_daddr_to_agbno(smi->sc->mp, bp->b_bn), "buf", \
+			&error, label)
+STATIC int
+xfs_scrub_metabufs_scrub_buf(
+	struct xfs_scrub_metabufs_info	*smi,
+	struct xfs_buf			*bp)
+{
+	int				olderror;
+	int				error = 0;
+
+	/*
+	 * We hold the rcu lock during the rhashtable walk, so we can't risk
+	 * having the log forced due to a stale buffer by xfs_buf_lock.
+	 */
+	if (bp->b_flags & XBF_STALE)
+		return 0;
+
+	atomic_inc(&bp->b_hold);
+	if (!xfs_buf_trylock(bp)) {
+		if (smi->retries > XFS_SCRUB_METABUFS_TOO_MANY_RETRIES) {
+			/* We've retried too many times, do what we can. */
+			XFS_SCRUB_INCOMPLETE(smi->sc, "metabufs", true);
+			error = 0;
+		} else {
+			/* Restart the metabuf scrub from the start. */
+			smi->retries++;
+			error = -EAGAIN;
+		}
+		goto out_dec;
+	}
+
+	/* Skip this buffer if it's stale, unread, or has no verifiers. */
+	if ((bp->b_flags & XBF_STALE) ||
+	    !(bp->b_flags & XBF_DONE) ||
+	    !bp->b_ops)
+		goto out_unlock;
+
+	/*
+	 * Run the verifiers to see if the in-memory buffer is bitrotting or
+	 * otherwise corrupt.  If the buffer doesn't have a log item then
+	 * it's clean, so call the read verifier.  However, if the buffer
+	 * has a log item, it is probably dirty.  Checksums will be written
+	 * when the buffer is about to go out to disk, so call the write
+	 * verifier to check the structure.
+	 */
+	olderror = bp->b_error;
+	if (bp->b_fspriv)
+		bp->b_ops->verify_write(bp);
+	else
+		bp->b_ops->verify_read(bp);
+	error = bp->b_error;
+	bp->b_error = olderror;
+
+	/* Mark any corruption errors we might find. */
+	XFS_SCRUB_BUF_OP_ERROR_GOTO(out_unlock);
+
+out_unlock:
+	xfs_buf_unlock(bp);
+out_dec:
+	atomic_dec(&bp->b_hold);
+	return error;
+}
+#undef XFS_SCRUB_BUF_OP_ERROR_GOTO
+
+/* Walk the buffer rhashtable and dispatch buffer checking. */
+STATIC int
+xfs_scrub_metabufs_walk_rhash(
+	struct xfs_scrub_metabufs_info	*smi,
+	struct rhashtable_iter		*iter)
+{
+	struct xfs_buf			*bp;
+	int				error = 0;
+
+	do {
+		if (xfs_scrub_should_terminate(&error))
+			break;
+
+		bp = rhashtable_walk_next(iter);
+		if (IS_ERR(bp))
+			return PTR_ERR(bp);
+		else if (bp == NULL)
+			return 0;
+
+		error = xfs_scrub_metabufs_scrub_buf(smi, bp);
+	} while (error != 0);
+
+	return error;
+}
+
+/* Try to walk the buffers in this AG in order to scrub them. */
+int
+xfs_scrub_metabufs(
+	struct xfs_scrub_context	*sc)
+{
+	struct xfs_scrub_metabufs_info	smi;
+	struct rhashtable_iter		iter;
+	struct xfs_perag		*pag;
+	int				error;
+
+	smi.sc = sc;
+	smi.retries = 0;
+	pag = xfs_perag_get(sc->mp, sc->sm->sm_agno);
+	rhashtable_walk_enter(&pag->pag_buf_hash, &iter);
+
+	while (1) {
+		if (xfs_scrub_should_terminate(&error))
+			break;
+
+		error = rhashtable_walk_start(&iter);
+		if (!error) {
+			error = xfs_scrub_metabufs_walk_rhash(&smi, &iter);
+			rhashtable_walk_stop(&iter);
+		}
+
+		if (error != -EAGAIN)
+			break;
+		cond_resched();
+	}
+
+	rhashtable_walk_exit(&iter);
+	xfs_perag_put(pag);
+	return error;
+}
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index d4de29b..036e65c 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -3312,7 +3312,8 @@ DEFINE_GETFSMAP_EVENT(xfs_getfsmap_mapping);
 
 /* scrub */
 #define XFS_SCRUB_TYPE_DESC \
-	{ XFS_SCRUB_TYPE_TEST,		"dummy" }
+	{ XFS_SCRUB_TYPE_TEST,		"dummy" }, \
+	{ XFS_SCRUB_TYPE_METABUFS,	"metabufs" }
 DECLARE_EVENT_CLASS(xfs_scrub_class,
 	TP_PROTO(struct xfs_inode *ip, struct xfs_scrub_metadata *sm,
 		 int error),

