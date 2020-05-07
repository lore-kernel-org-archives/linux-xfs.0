Return-Path: <SRS0=M5eb=6V=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95CF8C38A24
	for <linux-xfs@archiver.kernel.org>; Thu,  7 May 2020 12:20:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 716412083B
	for <linux-xfs@archiver.kernel.org>; Thu,  7 May 2020 12:20:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="roAEtQXJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726743AbgEGMUw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 May 2020 08:20:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725900AbgEGMUv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 May 2020 08:20:51 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5DB1C05BD43
        for <linux-xfs@vger.kernel.org>; Thu,  7 May 2020 05:20:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=33EEYN4Gpgxd1NUQXjXyW6NC33CVc6mSbkRGnxEksJ4=; b=roAEtQXJjPq90A2BBD1RN1/dXU
        Ry1o9BSHBB1N1ZPi0XSQKvaxxG/0mL4IoHwp+DbMuNMB9sEfU50x8vo3hirxqXpiFYx1NU2RQi+rA
        aKxpw2j/ibUalh0owdBmoF+kC4lKuS4/7UKx+3Pzyynx59CANRKdnC+BnvLs81BO8bCjipMF4UR/0
        xlwH7drsRLuQFS0AqUYMRji+RK1pVw6I8m5uHGOEEozCF1504f+HSt39pB92Dllw+OEprtSJEAgsk
        YAZ8G/oebKWY8IOaaS2wawK8IigilfquxmB5r4Sfue8Up/+nYmqhmU1Z6v4Yig7e7eD/iFOHeGsDW
        WCWWwBag==;
Received: from [2001:4bb8:180:9d3f:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jWfWF-0007tD-3s; Thu, 07 May 2020 12:20:51 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     sandeen@sandeen.net
Cc:     linux-xfs@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Brian Foster <bfoster@redhat.com>
Subject: [PATCH 48/58] xfs: introduce fake roots for ag-rooted btrees
Date:   Thu,  7 May 2020 14:18:41 +0200
Message-Id: <20200507121851.304002-49-hch@lst.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200507121851.304002-1-hch@lst.de>
References: <20200507121851.304002-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: "Darrick J. Wong" <darrick.wong@oracle.com>

Source kernel commit: e06536a692e032470130af5b2136b519595809da

Create an in-core fake root for AG-rooted btree types so that callers
can generate a whole new btree using the upcoming btree bulk load
function without making the new tree accessible from the rest of the
filesystem.  It is up to the individual btree type to provide a function
to create a staged cursor (presumably with the appropriate callouts to
update the fakeroot) and then commit the staged root back into the
filesystem.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/xfs_trace.h        |   1 +
 libxfs/Makefile            |   2 +
 libxfs/xfs_btree.c         |   3 +
 libxfs/xfs_btree.h         |  11 ++-
 libxfs/xfs_btree_staging.c | 179 +++++++++++++++++++++++++++++++++++++
 libxfs/xfs_btree_staging.h |  27 ++++++
 6 files changed, 222 insertions(+), 1 deletion(-)
 create mode 100644 libxfs/xfs_btree_staging.c
 create mode 100644 libxfs/xfs_btree_staging.h

diff --git a/include/xfs_trace.h b/include/xfs_trace.h
index 35c92388..bb409444 100644
--- a/include/xfs_trace.h
+++ b/include/xfs_trace.h
@@ -46,6 +46,7 @@
 #define trace_xfs_btree_corrupt(a,b)		((void) 0)
 #define trace_xfs_btree_updkeys(a,b,c)		((void) 0)
 #define trace_xfs_btree_overlapped_query_range(a,b,c)	((void) 0)
+#define trace_xfs_btree_commit_afakeroot(cur)	((void) 0)
 
 #define trace_xfs_free_extent(a,b,c,d,e,f,g)	((void) 0)
 #define trace_xfs_agf(a,b,c,d)			((void) 0)
diff --git a/libxfs/Makefile b/libxfs/Makefile
index 8c19836f..44b23816 100644
--- a/libxfs/Makefile
+++ b/libxfs/Makefile
@@ -29,6 +29,7 @@ HFILES = \
 	xfs_bmap.h \
 	xfs_bmap_btree.h \
 	xfs_btree.h \
+	xfs_btree_staging.h \
 	xfs_attr_remote.h \
 	xfs_cksum.h \
 	xfs_da_btree.h \
@@ -72,6 +73,7 @@ CFILES = cache.c \
 	xfs_bmap.c \
 	xfs_bmap_btree.c \
 	xfs_btree.c \
+	xfs_btree_staging.c \
 	xfs_da_btree.c \
 	xfs_defer.c \
 	xfs_dir2.c \
diff --git a/libxfs/xfs_btree.c b/libxfs/xfs_btree.c
index 6771c981..a2ab7cf3 100644
--- a/libxfs/xfs_btree.c
+++ b/libxfs/xfs_btree.c
@@ -17,6 +17,7 @@
 #include "xfs_errortag.h"
 #include "xfs_trace.h"
 #include "xfs_alloc.h"
+#include "xfs_btree_staging.h"
 
 /*
  * Cursor allocation zone.
@@ -379,6 +380,8 @@ xfs_btree_del_cursor(
 	/*
 	 * Free the cursor.
 	 */
+	if (unlikely(cur->bc_flags & XFS_BTREE_STAGING))
+		kmem_free((void *)cur->bc_ops);
 	kmem_cache_free(xfs_btree_cur_zone, cur);
 }
 
diff --git a/libxfs/xfs_btree.h b/libxfs/xfs_btree.h
index 6faed214..82b906b5 100644
--- a/libxfs/xfs_btree.h
+++ b/libxfs/xfs_btree.h
@@ -179,7 +179,10 @@ union xfs_btree_irec {
 
 /* Per-AG btree information. */
 struct xfs_btree_cur_ag {
-	struct xfs_buf		*agbp;
+	union {
+		struct xfs_buf		*agbp;
+		struct xbtree_afakeroot	*afake;	/* for staging cursor */
+	};
 	xfs_agnumber_t		agno;
 	union {
 		struct {
@@ -238,6 +241,12 @@ typedef struct xfs_btree_cur
 #define XFS_BTREE_LASTREC_UPDATE	(1<<2)	/* track last rec externally */
 #define XFS_BTREE_CRC_BLOCKS		(1<<3)	/* uses extended btree blocks */
 #define XFS_BTREE_OVERLAPPING		(1<<4)	/* overlapping intervals */
+/*
+ * The root of this btree is a fakeroot structure so that we can stage a btree
+ * rebuild without leaving it accessible via primary metadata.  The ops struct
+ * is dynamically allocated and must be freed when the cursor is deleted.
+ */
+#define XFS_BTREE_STAGING		(1<<5)
 
 
 #define	XFS_BTREE_NOERROR	0
diff --git a/libxfs/xfs_btree_staging.c b/libxfs/xfs_btree_staging.c
new file mode 100644
index 00000000..247683c6
--- /dev/null
+++ b/libxfs/xfs_btree_staging.c
@@ -0,0 +1,179 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (C) 2020 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <darrick.wong@oracle.com>
+ */
+#include "libxfs_priv.h"
+#include "xfs_fs.h"
+#include "xfs_shared.h"
+#include "xfs_format.h"
+#include "xfs_log_format.h"
+#include "xfs_trans_resv.h"
+#include "xfs_bit.h"
+#include "xfs_mount.h"
+#include "xfs_inode.h"
+#include "xfs_trans.h"
+#include "xfs_btree.h"
+#include "xfs_trace.h"
+#include "xfs_btree_staging.h"
+
+/*
+ * Staging Cursors and Fake Roots for Btrees
+ * =========================================
+ *
+ * A staging btree cursor is a special type of btree cursor that callers must
+ * use to construct a new btree index using the btree bulk loader code.  The
+ * bulk loading code uses the staging btree cursor to abstract the details of
+ * initializing new btree blocks and filling them with records or key/ptr
+ * pairs.  Regular btree operations (e.g. queries and modifications) are not
+ * supported with staging cursors, and callers must not invoke them.
+ *
+ * Fake root structures contain all the information about a btree that is under
+ * construction by the bulk loading code.  Staging btree cursors point to fake
+ * root structures instead of the usual AG header or inode structure.
+ *
+ * Callers are expected to initialize a fake root structure and pass it into
+ * the _stage_cursor function for a specific btree type.  When bulk loading is
+ * complete, callers should call the _commit_staged_btree function for that
+ * specific btree type to commit the new btree into the filesystem.
+ */
+
+/*
+ * Don't allow staging cursors to be duplicated because they're supposed to be
+ * kept private to a single thread.
+ */
+STATIC struct xfs_btree_cur *
+xfs_btree_fakeroot_dup_cursor(
+	struct xfs_btree_cur	*cur)
+{
+	ASSERT(0);
+	return NULL;
+}
+
+/*
+ * Don't allow block allocation for a staging cursor, because staging cursors
+ * do not support regular btree modifications.
+ *
+ * Bulk loading uses a separate callback to obtain new blocks from a
+ * preallocated list, which prevents ENOSPC failures during loading.
+ */
+STATIC int
+xfs_btree_fakeroot_alloc_block(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_ptr	*start_bno,
+	union xfs_btree_ptr	*new_bno,
+	int			*stat)
+{
+	ASSERT(0);
+	return -EFSCORRUPTED;
+}
+
+/*
+ * Don't allow block freeing for a staging cursor, because staging cursors
+ * do not support regular btree modifications.
+ */
+STATIC int
+xfs_btree_fakeroot_free_block(
+	struct xfs_btree_cur	*cur,
+	struct xfs_buf		*bp)
+{
+	ASSERT(0);
+	return -EFSCORRUPTED;
+}
+
+/* Initialize a pointer to the root block from the fakeroot. */
+STATIC void
+xfs_btree_fakeroot_init_ptr_from_cur(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_ptr	*ptr)
+{
+	struct xbtree_afakeroot	*afake;
+
+	ASSERT(cur->bc_flags & XFS_BTREE_STAGING);
+
+	afake = cur->bc_ag.afake;
+	ptr->s = cpu_to_be32(afake->af_root);
+}
+
+/*
+ * Bulk Loading for AG Btrees
+ * ==========================
+ *
+ * For a btree rooted in an AG header, pass a xbtree_afakeroot structure to the
+ * staging cursor.  Callers should initialize this to zero.
+ *
+ * The _stage_cursor() function for a specific btree type should call
+ * xfs_btree_stage_afakeroot to set up the in-memory cursor as a staging
+ * cursor.  The corresponding _commit_staged_btree() function should log the
+ * new root and call xfs_btree_commit_afakeroot() to transform the staging
+ * cursor into a regular btree cursor.
+ */
+
+/* Update the btree root information for a per-AG fake root. */
+STATIC void
+xfs_btree_afakeroot_set_root(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_ptr	*ptr,
+	int			inc)
+{
+	struct xbtree_afakeroot	*afake = cur->bc_ag.afake;
+
+	ASSERT(cur->bc_flags & XFS_BTREE_STAGING);
+	afake->af_root = be32_to_cpu(ptr->s);
+	afake->af_levels += inc;
+}
+
+/*
+ * Initialize a AG-rooted btree cursor with the given AG btree fake root.
+ * The btree cursor's bc_ops will be overridden as needed to make the staging
+ * functionality work.
+ */
+void
+xfs_btree_stage_afakeroot(
+	struct xfs_btree_cur		*cur,
+	struct xbtree_afakeroot		*afake)
+{
+	struct xfs_btree_ops		*nops;
+
+	ASSERT(!(cur->bc_flags & XFS_BTREE_STAGING));
+	ASSERT(!(cur->bc_flags & XFS_BTREE_ROOT_IN_INODE));
+	ASSERT(cur->bc_tp == NULL);
+
+	nops = kmem_alloc(sizeof(struct xfs_btree_ops), KM_NOFS);
+	memcpy(nops, cur->bc_ops, sizeof(struct xfs_btree_ops));
+	nops->alloc_block = xfs_btree_fakeroot_alloc_block;
+	nops->free_block = xfs_btree_fakeroot_free_block;
+	nops->init_ptr_from_cur = xfs_btree_fakeroot_init_ptr_from_cur;
+	nops->set_root = xfs_btree_afakeroot_set_root;
+	nops->dup_cursor = xfs_btree_fakeroot_dup_cursor;
+
+	cur->bc_ag.afake = afake;
+	cur->bc_nlevels = afake->af_levels;
+	cur->bc_ops = nops;
+	cur->bc_flags |= XFS_BTREE_STAGING;
+}
+
+/*
+ * Transform an AG-rooted staging btree cursor back into a regular cursor by
+ * substituting a real btree root for the fake one and restoring normal btree
+ * cursor ops.  The caller must log the btree root change prior to calling
+ * this.
+ */
+void
+xfs_btree_commit_afakeroot(
+	struct xfs_btree_cur		*cur,
+	struct xfs_trans		*tp,
+	struct xfs_buf			*agbp,
+	const struct xfs_btree_ops	*ops)
+{
+	ASSERT(cur->bc_flags & XFS_BTREE_STAGING);
+	ASSERT(cur->bc_tp == NULL);
+
+	trace_xfs_btree_commit_afakeroot(cur);
+
+	kmem_free((void *)cur->bc_ops);
+	cur->bc_ag.agbp = agbp;
+	cur->bc_ops = ops;
+	cur->bc_flags &= ~XFS_BTREE_STAGING;
+	cur->bc_tp = tp;
+}
diff --git a/libxfs/xfs_btree_staging.h b/libxfs/xfs_btree_staging.h
new file mode 100644
index 00000000..5d78e13d
--- /dev/null
+++ b/libxfs/xfs_btree_staging.h
@@ -0,0 +1,27 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * Copyright (C) 2020 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <darrick.wong@oracle.com>
+ */
+#ifndef __XFS_BTREE_STAGING_H__
+#define __XFS_BTREE_STAGING_H__
+
+/* Fake root for an AG-rooted btree. */
+struct xbtree_afakeroot {
+	/* AG block number of the new btree root. */
+	xfs_agblock_t		af_root;
+
+	/* Height of the new btree. */
+	unsigned int		af_levels;
+
+	/* Number of blocks used by the btree. */
+	unsigned int		af_blocks;
+};
+
+/* Cursor interactions with with fake roots for AG-rooted btrees. */
+void xfs_btree_stage_afakeroot(struct xfs_btree_cur *cur,
+		struct xbtree_afakeroot *afake);
+void xfs_btree_commit_afakeroot(struct xfs_btree_cur *cur, struct xfs_trans *tp,
+		struct xfs_buf *agbp, const struct xfs_btree_ops *ops);
+
+#endif	/* __XFS_BTREE_STAGING_H__ */
-- 
2.26.2

