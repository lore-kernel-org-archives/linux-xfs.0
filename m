Return-Path: <SRS0=0KAm=5A=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78AA4C10F29
	for <linux-xfs@archiver.kernel.org>; Sun, 15 Mar 2020 23:50:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3709B20663
	for <linux-xfs@archiver.kernel.org>; Sun, 15 Mar 2020 23:50:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="eK2gQJLJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729048AbgCOXuw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 15 Mar 2020 19:50:52 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:37548 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729042AbgCOXuw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 15 Mar 2020 19:50:52 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02FNdikH015964;
        Sun, 15 Mar 2020 23:50:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=npcT2/Vomp1pF+DrlTcUQR1+DUwkju0w+jtRC8ugmQc=;
 b=eK2gQJLJQWZJiZw35UCgFakqu41niRjzJIg+qfw3e7CHn4fcMVTusaz7mo0gc5WpDk3i
 9Q5E28G6+3Er+10r328LTqDuuHksiTWJwgIs2JN+/ze7x1nHYrJdFJGSu9aTaInSGf2j
 UOROou1O1rvbyilye4556X2jrrRC/NxWIxDoApFofcT4rGQ8OxbxvS8fzu9nUPWWXhtU
 EFCwnVasg9zsw8r1UWJXMB4bf3/Yuaq7lCnPzc6J+3tWm8L4dKpV7fXSWidklkYW0dhF
 lm7IIh8zEXVx91IBr+SMkGOIgdZRiG8HvIhVuAzbpoVUdS2NUZf3fMsAUcmUo1uehQe7 3g== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2yrppqv52e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 15 Mar 2020 23:50:49 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02FNoXJu042027;
        Sun, 15 Mar 2020 23:50:48 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2ys8rb4h68-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 15 Mar 2020 23:50:48 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 02FNomjY009254;
        Sun, 15 Mar 2020 23:50:48 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 15 Mar 2020 16:50:47 -0700
Subject: [PATCH 1/7] xfs: introduce fake roots for ag-rooted btrees
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, bfoster@redhat.com
Date:   Sun, 15 Mar 2020 16:50:46 -0700
Message-ID: <158431624662.357791.16507650161335055681.stgit@magnolia>
In-Reply-To: <158431623997.357791.9599758740528407024.stgit@magnolia>
References: <158431623997.357791.9599758740528407024.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9561 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 phishscore=0
 malwarescore=0 mlxscore=0 mlxlogscore=999 adultscore=0 suspectscore=3
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2003150129
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9561 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0
 suspectscore=3 lowpriorityscore=0 phishscore=0 adultscore=0 clxscore=1015
 impostorscore=0 priorityscore=1501 spamscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2003150129
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Create an in-core fake root for AG-rooted btree types so that callers
can generate a whole new btree using the upcoming btree bulk load
function without making the new tree accessible from the rest of the
filesystem.  It is up to the individual btree type to provide a function
to create a staged cursor (presumably with the appropriate callouts to
update the fakeroot) and then commit the staged root back into the
filesystem.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/Makefile                   |    1 
 fs/xfs/libxfs/xfs_btree.c         |    3 +
 fs/xfs/libxfs/xfs_btree.h         |   11 ++
 fs/xfs/libxfs/xfs_btree_staging.c |  179 +++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_btree_staging.h |   27 ++++++
 fs/xfs/xfs_trace.c                |    1 
 fs/xfs/xfs_trace.h                |   28 ++++++
 7 files changed, 249 insertions(+), 1 deletion(-)
 create mode 100644 fs/xfs/libxfs/xfs_btree_staging.c
 create mode 100644 fs/xfs/libxfs/xfs_btree_staging.h


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 135f4478aa5a..3b0b21a4dcde 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -41,6 +41,7 @@ xfs-y				+= $(addprefix libxfs/, \
 				   xfs_bmap.o \
 				   xfs_bmap_btree.o \
 				   xfs_btree.o \
+				   xfs_btree_staging.o \
 				   xfs_da_btree.o \
 				   xfs_defer.o \
 				   xfs_dir2.o \
diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index 4ef9f0b42c7f..e81db0f38ba8 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -20,6 +20,7 @@
 #include "xfs_trace.h"
 #include "xfs_alloc.h"
 #include "xfs_log.h"
+#include "xfs_btree_staging.h"
 
 /*
  * Cursor allocation zone.
@@ -382,6 +383,8 @@ xfs_btree_del_cursor(
 	/*
 	 * Free the cursor.
 	 */
+	if (unlikely(cur->bc_flags & XFS_BTREE_STAGING))
+		kmem_free((void *)cur->bc_ops);
 	kmem_cache_free(xfs_btree_cur_zone, cur);
 }
 
diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
index 133b858bf096..d6e201ff4027 100644
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
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
diff --git a/fs/xfs/libxfs/xfs_btree_staging.c b/fs/xfs/libxfs/xfs_btree_staging.c
new file mode 100644
index 000000000000..995a4681e90a
--- /dev/null
+++ b/fs/xfs/libxfs/xfs_btree_staging.c
@@ -0,0 +1,179 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (C) 2020 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <darrick.wong@oracle.com>
+ */
+#include "xfs.h"
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
diff --git a/fs/xfs/libxfs/xfs_btree_staging.h b/fs/xfs/libxfs/xfs_btree_staging.h
new file mode 100644
index 000000000000..5d78e13d2968
--- /dev/null
+++ b/fs/xfs/libxfs/xfs_btree_staging.h
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
diff --git a/fs/xfs/xfs_trace.c b/fs/xfs/xfs_trace.c
index bc85b89f88ca..e9546a6aac10 100644
--- a/fs/xfs/xfs_trace.c
+++ b/fs/xfs/xfs_trace.c
@@ -27,6 +27,7 @@
 #include "xfs_log_recover.h"
 #include "xfs_filestream.h"
 #include "xfs_fsmap.h"
+#include "xfs_btree_staging.h"
 
 /*
  * We include this last to have the helpers above available for the trace
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 059c3098a4a0..d8c229492973 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -3605,6 +3605,34 @@ TRACE_EVENT(xfs_check_new_dalign,
 		  __entry->calc_rootino)
 )
 
+TRACE_EVENT(xfs_btree_commit_afakeroot,
+	TP_PROTO(struct xfs_btree_cur *cur),
+	TP_ARGS(cur),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_btnum_t, btnum)
+		__field(xfs_agnumber_t, agno)
+		__field(xfs_agblock_t, agbno)
+		__field(unsigned int, levels)
+		__field(unsigned int, blocks)
+	),
+	TP_fast_assign(
+		__entry->dev = cur->bc_mp->m_super->s_dev;
+		__entry->btnum = cur->bc_btnum;
+		__entry->agno = cur->bc_ag.agno;
+		__entry->agbno = cur->bc_ag.afake->af_root;
+		__entry->levels = cur->bc_ag.afake->af_levels;
+		__entry->blocks = cur->bc_ag.afake->af_blocks;
+	),
+	TP_printk("dev %d:%d btree %s ag %u levels %u blocks %u root %u",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __print_symbolic(__entry->btnum, XFS_BTNUM_STRINGS),
+		  __entry->agno,
+		  __entry->levels,
+		  __entry->blocks,
+		  __entry->agbno)
+)
+
 #endif /* _TRACE_XFS_H */
 
 #undef TRACE_INCLUDE_PATH

