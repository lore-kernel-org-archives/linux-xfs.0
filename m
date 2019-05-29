Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:55016 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726535AbfE2W0c (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 May 2019 18:26:32 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4TM4E6A031120
        for <linux-xfs@vger.kernel.org>; Wed, 29 May 2019 22:26:30 GMT
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2spxbqcp43-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 29 May 2019 22:26:30 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4TMPS7E096530
        for <linux-xfs@vger.kernel.org>; Wed, 29 May 2019 22:26:29 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2ss1fnqqpk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 29 May 2019 22:26:29 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x4TMQTG5003333
        for <linux-xfs@vger.kernel.org>; Wed, 29 May 2019 22:26:29 GMT
Subject: [PATCH 02/11] xfs: create simplified inode walk function
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 29 May 2019 15:26:27 -0700
Message-ID: <155916878781.757870.16686660432312494436.stgit@magnolia>
In-Reply-To: <155916877311.757870.11060347556535201032.stgit@magnolia>
References: <155916877311.757870.11060347556535201032.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/Makefile     |    1 
 fs/xfs/xfs_itable.c |    5 -
 fs/xfs/xfs_itable.h |    8 +
 fs/xfs/xfs_iwalk.c  |  402 +++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_iwalk.h  |   18 ++
 fs/xfs/xfs_trace.h  |   40 +++++
 6 files changed, 472 insertions(+), 2 deletions(-)
 create mode 100644 fs/xfs/xfs_iwalk.c
 create mode 100644 fs/xfs/xfs_iwalk.h


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 91831975363b..74d30ef0dbce 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -80,6 +80,7 @@ xfs-y				+= xfs_aops.o \
 				   xfs_iops.o \
 				   xfs_inode.o \
 				   xfs_itable.o \
+				   xfs_iwalk.o \
 				   xfs_message.o \
 				   xfs_mount.o \
 				   xfs_mru_cache.o \
diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
index cff28ee73deb..96590d9f917c 100644
--- a/fs/xfs/xfs_itable.c
+++ b/fs/xfs/xfs_itable.c
@@ -19,6 +19,7 @@
 #include "xfs_trace.h"
 #include "xfs_icache.h"
 #include "xfs_health.h"
+#include "xfs_iwalk.h"
 
 /*
  * Return stat information for one inode.
@@ -161,7 +162,7 @@ xfs_bulkstat_one(
  * Loop over all clusters in a chunk for a given incore inode allocation btree
  * record.  Do a readahead if there are any allocated inodes in that cluster.
  */
-STATIC void
+void
 xfs_bulkstat_ichunk_ra(
 	struct xfs_mount		*mp,
 	xfs_agnumber_t			agno,
@@ -195,7 +196,7 @@ xfs_bulkstat_ichunk_ra(
  * are some left allocated, update the data for the pointed-to record as well as
  * return the count of grabbed inodes.
  */
-STATIC int
+int
 xfs_bulkstat_grab_ichunk(
 	struct xfs_btree_cur		*cur,	/* btree cursor */
 	xfs_agino_t			agino,	/* starting inode of chunk */
diff --git a/fs/xfs/xfs_itable.h b/fs/xfs/xfs_itable.h
index 8a822285b671..369e3f159d4e 100644
--- a/fs/xfs/xfs_itable.h
+++ b/fs/xfs/xfs_itable.h
@@ -84,4 +84,12 @@ xfs_inumbers(
 	void			__user *buffer, /* buffer with inode info */
 	inumbers_fmt_pf		formatter);
 
+/* Temporarily needed while we refactor functions. */
+struct xfs_btree_cur;
+struct xfs_inobt_rec_incore;
+void xfs_bulkstat_ichunk_ra(struct xfs_mount *mp, xfs_agnumber_t agno,
+		struct xfs_inobt_rec_incore *irec);
+int xfs_bulkstat_grab_ichunk(struct xfs_btree_cur *cur, xfs_agino_t agino,
+		int *icount, struct xfs_inobt_rec_incore *irec);
+
 #endif	/* __XFS_ITABLE_H__ */
diff --git a/fs/xfs/xfs_iwalk.c b/fs/xfs/xfs_iwalk.c
new file mode 100644
index 000000000000..0ce3baa159ba
--- /dev/null
+++ b/fs/xfs/xfs_iwalk.c
@@ -0,0 +1,402 @@
+// SPDX-License-Identifier: GPL-2.0+
+/*
+ * Copyright (C) 2019 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <darrick.wong@oracle.com>
+ */
+#include "xfs.h"
+#include "xfs_fs.h"
+#include "xfs_shared.h"
+#include "xfs_format.h"
+#include "xfs_log_format.h"
+#include "xfs_trans_resv.h"
+#include "xfs_mount.h"
+#include "xfs_inode.h"
+#include "xfs_btree.h"
+#include "xfs_ialloc.h"
+#include "xfs_ialloc_btree.h"
+#include "xfs_itable.h"
+#include "xfs_error.h"
+#include "xfs_trace.h"
+#include "xfs_icache.h"
+#include "xfs_health.h"
+#include "xfs_trans.h"
+#include "xfs_iwalk.h"
+
+/*
+ * Walking All the Inodes in the Filesystem
+ * ========================================
+ * Starting at some @startino, call a walk function on every allocated inode in
+ * the system.  The walk function is called with the relevant inode number and
+ * a pointer to caller-provided data.  The walk function can return the usual
+ * negative error code, 0, or XFS_IWALK_ABORT to stop the iteration.  This
+ * return value is returned to the caller.
+ *
+ * Internally, we allow the walk function to do anything, which means that we
+ * cannot maintain the inobt cursor or our lock on the AGI buffer.  We
+ * therefore build up a batch of inobt records in kernel memory and only call
+ * the walk function when our memory buffer is full.
+ */
+
+struct xfs_iwalk_ag {
+	struct xfs_mount		*mp;
+	struct xfs_trans		*tp;
+
+	/* Where do we start the traversal? */
+	xfs_ino_t			startino;
+
+	/* Array of inobt records we cache. */
+	struct xfs_inobt_rec_incore	*recs;
+	unsigned int			sz_recs;
+	unsigned int			nr_recs;
+
+	/* Inode walk function and data pointer. */
+	xfs_iwalk_fn			iwalk_fn;
+	void				*data;
+};
+
+/* Allocate memory for a walk. */
+STATIC int
+xfs_iwalk_allocbuf(
+	struct xfs_iwalk_ag	*iwag)
+{
+	size_t			size;
+
+	ASSERT(iwag->recs == NULL);
+	iwag->nr_recs = 0;
+
+	/* Allocate a prefetch buffer for inobt records. */
+	size = iwag->sz_recs * sizeof(struct xfs_inobt_rec_incore);
+	iwag->recs = kmem_alloc(size, KM_SLEEP);
+	if (iwag->recs == NULL)
+		return -ENOMEM;
+
+	return 0;
+}
+
+/* Free memory we allocated for a walk. */
+STATIC void
+xfs_iwalk_freebuf(
+	struct xfs_iwalk_ag	*iwag)
+{
+	ASSERT(iwag->recs != NULL);
+	kmem_free(iwag->recs);
+}
+
+/* For each inuse inode in each cached inobt record, call our function. */
+STATIC int
+xfs_iwalk_ag_recs(
+	struct xfs_iwalk_ag		*iwag)
+{
+	struct xfs_mount		*mp = iwag->mp;
+	struct xfs_trans		*tp = iwag->tp;
+	struct xfs_inobt_rec_incore	*irec;
+	xfs_ino_t			ino;
+	unsigned int			i, j;
+	xfs_agnumber_t			agno;
+	int				error;
+
+	agno = XFS_INO_TO_AGNO(mp, iwag->startino);
+	for (i = 0, irec = iwag->recs; i < iwag->nr_recs; i++, irec++) {
+		trace_xfs_iwalk_ag_rec(mp, agno, irec->ir_startino,
+				irec->ir_free);
+		for (j = 0; j < XFS_INODES_PER_CHUNK; j++) {
+			/* Skip if this inode is free */
+			if (XFS_INOBT_MASK(j) & irec->ir_free)
+				continue;
+
+			/* Otherwise call our function. */
+			ino = XFS_AGINO_TO_INO(mp, agno, irec->ir_startino + j);
+			error = iwag->iwalk_fn(mp, tp, ino, iwag->data);
+			if (error)
+				return error;
+		}
+	}
+
+	iwag->nr_recs = 0;
+	return 0;
+}
+
+/* Read AGI and create inobt cursor. */
+static inline int
+xfs_iwalk_inobt_cur(
+	struct xfs_mount	*mp,
+	struct xfs_trans	*tp,
+	xfs_agnumber_t		agno,
+	struct xfs_btree_cur	**curpp,
+	struct xfs_buf		**agi_bpp)
+{
+	struct xfs_btree_cur	*cur;
+	int			error;
+
+	ASSERT(*agi_bpp == NULL);
+
+	error = xfs_ialloc_read_agi(mp, tp, agno, agi_bpp);
+	if (error)
+		return error;
+
+	cur = xfs_inobt_init_cursor(mp, tp, *agi_bpp, agno, XFS_BTNUM_INO);
+	if (!cur)
+		return -ENOMEM;
+	*curpp = cur;
+	return 0;
+}
+
+/* Delete cursor and let go of AGI. */
+static inline void
+xfs_iwalk_del_inobt(
+	struct xfs_trans	*tp,
+	struct xfs_btree_cur	**curpp,
+	struct xfs_buf		**agi_bpp,
+	int			error)
+{
+	if (*curpp) {
+		xfs_btree_del_cursor(*curpp, error);
+		*curpp = NULL;
+	}
+	if (*agi_bpp) {
+		xfs_trans_brelse(tp, *agi_bpp);
+		*agi_bpp = NULL;
+	}
+}
+
+/*
+ * Set ourselves up for walking inobt records starting from a given point in
+ * the filesystem.
+ *
+ * If caller passed in a nonzero start inode number, load the record from the
+ * inobt and make the record look like all the inodes before agino are free so
+ * that we skip them, and then move the cursor to the next inobt record.  This
+ * is how we support starting an iwalk in the middle of an inode chunk.
+ *
+ * If the caller passed in a start number of zero, move the cursor to the first
+ * inobt record.
+ *
+ * The caller is responsible for cleaning up the cursor and buffer pointer
+ * regardless of the error status.
+ */
+STATIC int
+xfs_iwalk_ag_start(
+	struct xfs_iwalk_ag	*iwag,
+	xfs_agnumber_t		agno,
+	xfs_agino_t		agino,
+	struct xfs_btree_cur	**curpp,
+	struct xfs_buf		**agi_bpp,
+	int			*has_more)
+{
+	struct xfs_mount	*mp = iwag->mp;
+	struct xfs_trans	*tp = iwag->tp;
+	int			icount;
+	int			error;
+
+	/* Set up a fresh cursor and empty the inobt cache. */
+	iwag->nr_recs = 0;
+	error = xfs_iwalk_inobt_cur(mp, tp, agno, curpp, agi_bpp);
+	if (error)
+		return error;
+
+	/* Starting at the beginning of the AG?  That's easy! */
+	if (agino == 0)
+		return xfs_inobt_lookup(*curpp, 0, XFS_LOOKUP_GE, has_more);
+
+	/*
+	 * Otherwise, we have to grab the inobt record where we left off, stuff
+	 * the record into our cache, and then see if there are more records.
+	 * We require a lookup cache of at least two elements so that we don't
+	 * have to deal with tearing down the cursor to walk the records.
+	 */
+	error = xfs_bulkstat_grab_ichunk(*curpp, agino - 1, &icount,
+			&iwag->recs[iwag->nr_recs]);
+	if (error)
+		return error;
+	if (icount)
+		iwag->nr_recs++;
+
+	ASSERT(iwag->nr_recs < iwag->sz_recs);
+	return xfs_btree_increment(*curpp, 0, has_more);
+}
+
+typedef int (*xfs_iwalk_ag_recs_fn)(struct xfs_iwalk_ag *iwag);
+
+/*
+ * Acknowledge that we added an inobt record to the cache.  Flush the inobt
+ * record cache if the buffer is full, and position the cursor wherever it
+ * needs to be so that we can keep going.
+ */
+STATIC int
+xfs_iwalk_ag_increment(
+	struct xfs_iwalk_ag		*iwag,
+	xfs_iwalk_ag_recs_fn		walk_ag_recs_fn,
+	xfs_agnumber_t			agno,
+	struct xfs_btree_cur		**curpp,
+	struct xfs_buf			**agi_bpp,
+	int				*has_more)
+{
+	struct xfs_mount		*mp = iwag->mp;
+	struct xfs_trans		*tp = iwag->tp;
+	struct xfs_inobt_rec_incore	*irec;
+	xfs_agino_t			restart;
+	int				error;
+
+	iwag->nr_recs++;
+
+	/* If there's space, just increment and look for more records. */
+	if (iwag->nr_recs < iwag->sz_recs)
+		return xfs_btree_increment(*curpp, 0, has_more);
+
+	/*
+	 * Otherwise the record cache is full; delete the cursor and walk the
+	 * records...
+	 */
+	xfs_iwalk_del_inobt(tp, curpp, agi_bpp, 0);
+	irec = &iwag->recs[iwag->nr_recs - 1];
+	restart = irec->ir_startino + XFS_INODES_PER_CHUNK - 1;
+
+	error = walk_ag_recs_fn(iwag);
+	if (error)
+		return error;
+
+	/* ...and recreate cursor where we left off. */
+	error = xfs_iwalk_inobt_cur(mp, tp, agno, curpp, agi_bpp);
+	if (error)
+		return error;
+
+	return xfs_inobt_lookup(*curpp, restart, XFS_LOOKUP_GE, has_more);
+}
+
+/* Walk all inodes in a single AG, from @iwag->startino to the end of the AG. */
+STATIC int
+xfs_iwalk_ag(
+	struct xfs_iwalk_ag		*iwag)
+{
+	struct xfs_mount		*mp = iwag->mp;
+	struct xfs_trans		*tp = iwag->tp;
+	struct xfs_buf			*agi_bp = NULL;
+	struct xfs_btree_cur		*cur = NULL;
+	xfs_agnumber_t			agno;
+	xfs_agino_t			agino;
+	int				has_more;
+	int				error = 0;
+
+	/* Set up our cursor at the right place in the inode btree. */
+	agno = XFS_INO_TO_AGNO(mp, iwag->startino);
+	agino = XFS_INO_TO_AGINO(mp, iwag->startino);
+	error = xfs_iwalk_ag_start(iwag, agno, agino, &cur, &agi_bp, &has_more);
+	if (error)
+		goto out_cur;
+
+	while (has_more) {
+		struct xfs_inobt_rec_incore	*irec;
+
+		/* Fetch the inobt record. */
+		irec = &iwag->recs[iwag->nr_recs];
+		error = xfs_inobt_get_rec(cur, irec, &has_more);
+		if (error)
+			goto out_cur;
+		if (!has_more)
+			break;
+
+		/* No allocated inodes in this chunk; skip it. */
+		if (irec->ir_freecount == irec->ir_count) {
+			error = xfs_btree_increment(cur, 0, &has_more);
+			goto next_loop;
+		}
+
+		/*
+		 * Start readahead for this inode chunk in anticipation of
+		 * walking the inodes.
+		 */
+		xfs_bulkstat_ichunk_ra(mp, agno, irec);
+
+		/*
+		 * Add this inobt record to our cache, flush the cache if
+		 * needed, and move on to the next record.
+		 */
+		error = xfs_iwalk_ag_increment(iwag, xfs_iwalk_ag_recs, agno,
+				&cur, &agi_bp, &has_more);
+next_loop:
+		if (error)
+			goto out_cur;
+		cond_resched();
+	}
+
+	/* Walk any records left behind in the cache. */
+	if (iwag->nr_recs) {
+		xfs_iwalk_del_inobt(tp, &cur, &agi_bp, error);
+		return xfs_iwalk_ag_recs(iwag);
+	}
+
+out_cur:
+	xfs_iwalk_del_inobt(tp, &cur, &agi_bp, error);
+	return error;
+}
+
+/*
+ * Given the number of inodes to prefetch, set the number of inobt records that
+ * we cache in memory, which controls the number of inodes we try to read
+ * ahead.
+ *
+ * If no max prefetch was given, default to one page's worth of inobt records;
+ * this should be plenty of inodes to read ahead.
+ */
+static inline void
+xfs_iwalk_set_prefetch(
+	struct xfs_iwalk_ag	*iwag,
+	unsigned int		max_prefetch)
+{
+	if (max_prefetch)
+		iwag->sz_recs = round_up(max_prefetch, XFS_INODES_PER_CHUNK) /
+					XFS_INODES_PER_CHUNK;
+	else
+		iwag->sz_recs = PAGE_SIZE / sizeof(struct xfs_inobt_rec_incore);
+
+	/*
+	 * Allocate enough space to prefetch at least two records so that we
+	 * can cache both the inobt record where the iwalk started and the next
+	 * record.  This simplifies the AG inode walk loop setup code.
+	 */
+	if (iwag->sz_recs < 2)
+		iwag->sz_recs = 2;
+}
+
+/*
+ * Walk all inodes in the filesystem starting from @startino.  The @iwalk_fn
+ * will be called for each allocated inode, being passed the inode's number and
+ * @data.  @max_prefetch controls how many inobt records' worth of inodes we
+ * try to readahead.
+ */
+int
+xfs_iwalk(
+	struct xfs_mount	*mp,
+	struct xfs_trans	*tp,
+	xfs_ino_t		startino,
+	xfs_iwalk_fn		iwalk_fn,
+	unsigned int		max_prefetch,
+	void			*data)
+{
+	struct xfs_iwalk_ag	iwag = {
+		.mp		= mp,
+		.tp		= tp,
+		.iwalk_fn	= iwalk_fn,
+		.data		= data,
+		.startino	= startino,
+	};
+	xfs_agnumber_t		agno = XFS_INO_TO_AGNO(mp, startino);
+	int			error;
+
+	ASSERT(agno < mp->m_sb.sb_agcount);
+
+	xfs_iwalk_set_prefetch(&iwag, max_prefetch);
+	error = xfs_iwalk_allocbuf(&iwag);
+	if (error)
+		return error;
+
+	for (; agno < mp->m_sb.sb_agcount; agno++) {
+		error = xfs_iwalk_ag(&iwag);
+		if (error)
+			break;
+		iwag.startino = XFS_AGINO_TO_INO(mp, agno + 1, 0);
+	}
+
+	xfs_iwalk_freebuf(&iwag);
+	return error;
+}
diff --git a/fs/xfs/xfs_iwalk.h b/fs/xfs/xfs_iwalk.h
new file mode 100644
index 000000000000..45b1baabcd2d
--- /dev/null
+++ b/fs/xfs/xfs_iwalk.h
@@ -0,0 +1,18 @@
+// SPDX-License-Identifier: GPL-2.0+
+/*
+ * Copyright (C) 2019 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <darrick.wong@oracle.com>
+ */
+#ifndef __XFS_IWALK_H__
+#define __XFS_IWALK_H__
+
+/* Walk all inodes in the filesystem starting from @startino. */
+typedef int (*xfs_iwalk_fn)(struct xfs_mount *mp, struct xfs_trans *tp,
+			    xfs_ino_t ino, void *data);
+/* Return value (for xfs_iwalk_fn) that aborts the walk immediately. */
+#define XFS_IWALK_ABORT	(1)
+
+int xfs_iwalk(struct xfs_mount *mp, struct xfs_trans *tp, xfs_ino_t startino,
+		xfs_iwalk_fn iwalk_fn, unsigned int max_prefetch, void *data);
+
+#endif /* __XFS_IWALK_H__ */
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 2464ea351f83..a2881659f776 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -3516,6 +3516,46 @@ DEFINE_EVENT(xfs_inode_corrupt_class, name,	\
 DEFINE_INODE_CORRUPT_EVENT(xfs_inode_mark_sick);
 DEFINE_INODE_CORRUPT_EVENT(xfs_inode_mark_healthy);
 
+TRACE_EVENT(xfs_iwalk_ag,
+	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno,
+		 xfs_agino_t startino),
+	TP_ARGS(mp, agno, startino),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_agnumber_t, agno)
+		__field(xfs_agino_t, startino)
+	),
+	TP_fast_assign(
+		__entry->dev = mp->m_super->s_dev;
+		__entry->agno = agno;
+		__entry->startino = startino;
+	),
+	TP_printk("dev %d:%d agno %d startino %u",
+		  MAJOR(__entry->dev), MINOR(__entry->dev), __entry->agno,
+		  __entry->startino)
+)
+
+TRACE_EVENT(xfs_iwalk_ag_rec,
+	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno,
+		 xfs_agino_t startino, uint64_t freemask),
+	TP_ARGS(mp, agno, startino, freemask),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_agnumber_t, agno)
+		__field(xfs_agino_t, startino)
+		__field(uint64_t, freemask)
+	),
+	TP_fast_assign(
+		__entry->dev = mp->m_super->s_dev;
+		__entry->agno = agno;
+		__entry->startino = startino;
+		__entry->freemask = freemask;
+	),
+	TP_printk("dev %d:%d agno %d startino %u freemask 0x%llx",
+		  MAJOR(__entry->dev), MINOR(__entry->dev), __entry->agno,
+		  __entry->startino, __entry->freemask)
+)
+
 #endif /* _TRACE_XFS_H */
 
 #undef TRACE_INCLUDE_PATH
