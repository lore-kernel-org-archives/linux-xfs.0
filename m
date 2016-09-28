Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:16426 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756502AbcI1Cxx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Sep 2016 22:53:53 -0400
Subject: [PATCH 03/63] xfs: define tracepoints for refcount btree activities
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 27 Sep 2016 19:53:49 -0700
Message-ID: <147503122918.30303.16146439086000365868.stgit@birch.djwong.org>
In-Reply-To: <147503120985.30303.14151302091684456858.stgit@birch.djwong.org>
References: <147503120985.30303.14151302091684456858.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

Define all the tracepoints we need to inspect the refcount btree
runtime operation.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_trace.h |  302 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 302 insertions(+)


diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index c6b2b1d..ee439e5 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -40,6 +40,16 @@ struct xfs_inode_log_format;
 struct xfs_bmbt_irec;
 struct xfs_btree_cur;
 
+#ifndef XFS_REFCOUNT_IREC_PLACEHOLDER
+#define XFS_REFCOUNT_IREC_PLACEHOLDER
+/* Placeholder definition to avoid breaking bisectability. */
+struct xfs_refcount_irec {
+	xfs_agblock_t	rc_startblock;	/* starting block number */
+	xfs_extlen_t	rc_blockcount;	/* count of free blocks */
+	xfs_nlink_t	rc_refcount;	/* number of inodes linked here */
+};
+#endif
+
 DECLARE_EVENT_CLASS(xfs_attr_list_class,
 	TP_PROTO(struct xfs_attr_list_context *ctx),
 	TP_ARGS(ctx),
@@ -2640,6 +2650,298 @@ DEFINE_AG_RESV_EVENT(xfs_ag_resv_needed);
 DEFINE_AG_ERROR_EVENT(xfs_ag_resv_free_error);
 DEFINE_AG_ERROR_EVENT(xfs_ag_resv_init_error);
 
+/* refcount tracepoint classes */
+
+/* reuse the discard trace class for agbno/aglen-based traces */
+#define DEFINE_AG_EXTENT_EVENT(name) DEFINE_DISCARD_EVENT(name)
+
+/* ag btree lookup tracepoint class */
+#define XFS_AG_BTREE_CMP_FORMAT_STR \
+	{ XFS_LOOKUP_EQ,	"eq" }, \
+	{ XFS_LOOKUP_LE,	"le" }, \
+	{ XFS_LOOKUP_GE,	"ge" }
+DECLARE_EVENT_CLASS(xfs_ag_btree_lookup_class,
+	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno,
+		 xfs_agblock_t agbno, xfs_lookup_t dir),
+	TP_ARGS(mp, agno, agbno, dir),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_agnumber_t, agno)
+		__field(xfs_agblock_t, agbno)
+		__field(xfs_lookup_t, dir)
+	),
+	TP_fast_assign(
+		__entry->dev = mp->m_super->s_dev;
+		__entry->agno = agno;
+		__entry->agbno = agbno;
+		__entry->dir = dir;
+	),
+	TP_printk("dev %d:%d agno %u agbno %u cmp %s(%d)\n",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->agno,
+		  __entry->agbno,
+		  __print_symbolic(__entry->dir, XFS_AG_BTREE_CMP_FORMAT_STR),
+		  __entry->dir)
+)
+
+#define DEFINE_AG_BTREE_LOOKUP_EVENT(name) \
+DEFINE_EVENT(xfs_ag_btree_lookup_class, name, \
+	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno, \
+		 xfs_agblock_t agbno, xfs_lookup_t dir), \
+	TP_ARGS(mp, agno, agbno, dir))
+
+/* single-rcext tracepoint class */
+DECLARE_EVENT_CLASS(xfs_refcount_extent_class,
+	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno,
+		 struct xfs_refcount_irec *irec),
+	TP_ARGS(mp, agno, irec),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_agnumber_t, agno)
+		__field(xfs_agblock_t, startblock)
+		__field(xfs_extlen_t, blockcount)
+		__field(xfs_nlink_t, refcount)
+	),
+	TP_fast_assign(
+		__entry->dev = mp->m_super->s_dev;
+		__entry->agno = agno;
+		__entry->startblock = irec->rc_startblock;
+		__entry->blockcount = irec->rc_blockcount;
+		__entry->refcount = irec->rc_refcount;
+	),
+	TP_printk("dev %d:%d agno %u agbno %u len %u refcount %u\n",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->agno,
+		  __entry->startblock,
+		  __entry->blockcount,
+		  __entry->refcount)
+)
+
+#define DEFINE_REFCOUNT_EXTENT_EVENT(name) \
+DEFINE_EVENT(xfs_refcount_extent_class, name, \
+	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno, \
+		 struct xfs_refcount_irec *irec), \
+	TP_ARGS(mp, agno, irec))
+
+/* single-rcext and an agbno tracepoint class */
+DECLARE_EVENT_CLASS(xfs_refcount_extent_at_class,
+	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno,
+		 struct xfs_refcount_irec *irec, xfs_agblock_t agbno),
+	TP_ARGS(mp, agno, irec, agbno),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_agnumber_t, agno)
+		__field(xfs_agblock_t, startblock)
+		__field(xfs_extlen_t, blockcount)
+		__field(xfs_nlink_t, refcount)
+		__field(xfs_agblock_t, agbno)
+	),
+	TP_fast_assign(
+		__entry->dev = mp->m_super->s_dev;
+		__entry->agno = agno;
+		__entry->startblock = irec->rc_startblock;
+		__entry->blockcount = irec->rc_blockcount;
+		__entry->refcount = irec->rc_refcount;
+		__entry->agbno = agbno;
+	),
+	TP_printk("dev %d:%d agno %u agbno %u len %u refcount %u @ agbno %u\n",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->agno,
+		  __entry->startblock,
+		  __entry->blockcount,
+		  __entry->refcount,
+		  __entry->agbno)
+)
+
+#define DEFINE_REFCOUNT_EXTENT_AT_EVENT(name) \
+DEFINE_EVENT(xfs_refcount_extent_at_class, name, \
+	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno, \
+		 struct xfs_refcount_irec *irec, xfs_agblock_t agbno), \
+	TP_ARGS(mp, agno, irec, agbno))
+
+/* double-rcext tracepoint class */
+DECLARE_EVENT_CLASS(xfs_refcount_double_extent_class,
+	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno,
+		 struct xfs_refcount_irec *i1, struct xfs_refcount_irec *i2),
+	TP_ARGS(mp, agno, i1, i2),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_agnumber_t, agno)
+		__field(xfs_agblock_t, i1_startblock)
+		__field(xfs_extlen_t, i1_blockcount)
+		__field(xfs_nlink_t, i1_refcount)
+		__field(xfs_agblock_t, i2_startblock)
+		__field(xfs_extlen_t, i2_blockcount)
+		__field(xfs_nlink_t, i2_refcount)
+	),
+	TP_fast_assign(
+		__entry->dev = mp->m_super->s_dev;
+		__entry->agno = agno;
+		__entry->i1_startblock = i1->rc_startblock;
+		__entry->i1_blockcount = i1->rc_blockcount;
+		__entry->i1_refcount = i1->rc_refcount;
+		__entry->i2_startblock = i2->rc_startblock;
+		__entry->i2_blockcount = i2->rc_blockcount;
+		__entry->i2_refcount = i2->rc_refcount;
+	),
+	TP_printk("dev %d:%d agno %u agbno %u len %u refcount %u -- "
+		  "agbno %u len %u refcount %u\n",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->agno,
+		  __entry->i1_startblock,
+		  __entry->i1_blockcount,
+		  __entry->i1_refcount,
+		  __entry->i2_startblock,
+		  __entry->i2_blockcount,
+		  __entry->i2_refcount)
+)
+
+#define DEFINE_REFCOUNT_DOUBLE_EXTENT_EVENT(name) \
+DEFINE_EVENT(xfs_refcount_double_extent_class, name, \
+	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno, \
+		 struct xfs_refcount_irec *i1, struct xfs_refcount_irec *i2), \
+	TP_ARGS(mp, agno, i1, i2))
+
+/* double-rcext and an agbno tracepoint class */
+DECLARE_EVENT_CLASS(xfs_refcount_double_extent_at_class,
+	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno,
+		 struct xfs_refcount_irec *i1, struct xfs_refcount_irec *i2,
+		 xfs_agblock_t agbno),
+	TP_ARGS(mp, agno, i1, i2, agbno),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_agnumber_t, agno)
+		__field(xfs_agblock_t, i1_startblock)
+		__field(xfs_extlen_t, i1_blockcount)
+		__field(xfs_nlink_t, i1_refcount)
+		__field(xfs_agblock_t, i2_startblock)
+		__field(xfs_extlen_t, i2_blockcount)
+		__field(xfs_nlink_t, i2_refcount)
+		__field(xfs_agblock_t, agbno)
+	),
+	TP_fast_assign(
+		__entry->dev = mp->m_super->s_dev;
+		__entry->agno = agno;
+		__entry->i1_startblock = i1->rc_startblock;
+		__entry->i1_blockcount = i1->rc_blockcount;
+		__entry->i1_refcount = i1->rc_refcount;
+		__entry->i2_startblock = i2->rc_startblock;
+		__entry->i2_blockcount = i2->rc_blockcount;
+		__entry->i2_refcount = i2->rc_refcount;
+		__entry->agbno = agbno;
+	),
+	TP_printk("dev %d:%d agno %u agbno %u len %u refcount %u -- "
+		  "agbno %u len %u refcount %u @ agbno %u\n",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->agno,
+		  __entry->i1_startblock,
+		  __entry->i1_blockcount,
+		  __entry->i1_refcount,
+		  __entry->i2_startblock,
+		  __entry->i2_blockcount,
+		  __entry->i2_refcount,
+		  __entry->agbno)
+)
+
+#define DEFINE_REFCOUNT_DOUBLE_EXTENT_AT_EVENT(name) \
+DEFINE_EVENT(xfs_refcount_double_extent_at_class, name, \
+	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno, \
+		 struct xfs_refcount_irec *i1, struct xfs_refcount_irec *i2, \
+		 xfs_agblock_t agbno), \
+	TP_ARGS(mp, agno, i1, i2, agbno))
+
+/* triple-rcext tracepoint class */
+DECLARE_EVENT_CLASS(xfs_refcount_triple_extent_class,
+	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno,
+		 struct xfs_refcount_irec *i1, struct xfs_refcount_irec *i2,
+		 struct xfs_refcount_irec *i3),
+	TP_ARGS(mp, agno, i1, i2, i3),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_agnumber_t, agno)
+		__field(xfs_agblock_t, i1_startblock)
+		__field(xfs_extlen_t, i1_blockcount)
+		__field(xfs_nlink_t, i1_refcount)
+		__field(xfs_agblock_t, i2_startblock)
+		__field(xfs_extlen_t, i2_blockcount)
+		__field(xfs_nlink_t, i2_refcount)
+		__field(xfs_agblock_t, i3_startblock)
+		__field(xfs_extlen_t, i3_blockcount)
+		__field(xfs_nlink_t, i3_refcount)
+	),
+	TP_fast_assign(
+		__entry->dev = mp->m_super->s_dev;
+		__entry->agno = agno;
+		__entry->i1_startblock = i1->rc_startblock;
+		__entry->i1_blockcount = i1->rc_blockcount;
+		__entry->i1_refcount = i1->rc_refcount;
+		__entry->i2_startblock = i2->rc_startblock;
+		__entry->i2_blockcount = i2->rc_blockcount;
+		__entry->i2_refcount = i2->rc_refcount;
+		__entry->i3_startblock = i3->rc_startblock;
+		__entry->i3_blockcount = i3->rc_blockcount;
+		__entry->i3_refcount = i3->rc_refcount;
+	),
+	TP_printk("dev %d:%d agno %u agbno %u len %u refcount %u -- "
+		  "agbno %u len %u refcount %u -- "
+		  "agbno %u len %u refcount %u\n",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->agno,
+		  __entry->i1_startblock,
+		  __entry->i1_blockcount,
+		  __entry->i1_refcount,
+		  __entry->i2_startblock,
+		  __entry->i2_blockcount,
+		  __entry->i2_refcount,
+		  __entry->i3_startblock,
+		  __entry->i3_blockcount,
+		  __entry->i3_refcount)
+);
+
+#define DEFINE_REFCOUNT_TRIPLE_EXTENT_EVENT(name) \
+DEFINE_EVENT(xfs_refcount_triple_extent_class, name, \
+	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno, \
+		 struct xfs_refcount_irec *i1, struct xfs_refcount_irec *i2, \
+		 struct xfs_refcount_irec *i3), \
+	TP_ARGS(mp, agno, i1, i2, i3))
+
+/* refcount btree tracepoints */
+DEFINE_BUSY_EVENT(xfs_refcountbt_alloc_block);
+DEFINE_BUSY_EVENT(xfs_refcountbt_free_block);
+DEFINE_AG_BTREE_LOOKUP_EVENT(xfs_refcount_lookup);
+DEFINE_REFCOUNT_EXTENT_EVENT(xfs_refcount_get);
+DEFINE_REFCOUNT_EXTENT_EVENT(xfs_refcount_update);
+DEFINE_REFCOUNT_EXTENT_EVENT(xfs_refcount_insert);
+DEFINE_REFCOUNT_EXTENT_EVENT(xfs_refcount_delete);
+DEFINE_AG_ERROR_EVENT(xfs_refcount_insert_error);
+DEFINE_AG_ERROR_EVENT(xfs_refcount_delete_error);
+DEFINE_AG_ERROR_EVENT(xfs_refcount_update_error);
+
+/* refcount adjustment tracepoints */
+DEFINE_AG_EXTENT_EVENT(xfs_refcount_increase);
+DEFINE_AG_EXTENT_EVENT(xfs_refcount_decrease);
+DEFINE_REFCOUNT_TRIPLE_EXTENT_EVENT(xfs_refcount_merge_center_extents);
+DEFINE_REFCOUNT_EXTENT_EVENT(xfs_refcount_modify_extent);
+DEFINE_REFCOUNT_EXTENT_AT_EVENT(xfs_refcount_split_extent);
+DEFINE_REFCOUNT_DOUBLE_EXTENT_EVENT(xfs_refcount_merge_left_extent);
+DEFINE_REFCOUNT_DOUBLE_EXTENT_EVENT(xfs_refcount_merge_right_extent);
+DEFINE_REFCOUNT_DOUBLE_EXTENT_AT_EVENT(xfs_refcount_find_left_extent);
+DEFINE_REFCOUNT_DOUBLE_EXTENT_AT_EVENT(xfs_refcount_find_right_extent);
+DEFINE_AG_ERROR_EVENT(xfs_refcount_adjust_error);
+DEFINE_AG_ERROR_EVENT(xfs_refcount_merge_center_extents_error);
+DEFINE_AG_ERROR_EVENT(xfs_refcount_modify_extent_error);
+DEFINE_AG_ERROR_EVENT(xfs_refcount_split_extent_error);
+DEFINE_AG_ERROR_EVENT(xfs_refcount_merge_left_extent_error);
+DEFINE_AG_ERROR_EVENT(xfs_refcount_merge_right_extent_error);
+DEFINE_AG_ERROR_EVENT(xfs_refcount_find_left_extent_error);
+DEFINE_AG_ERROR_EVENT(xfs_refcount_find_right_extent_error);
+DEFINE_REFCOUNT_DOUBLE_EXTENT_EVENT(xfs_refcount_rec_order_error);
+
+/* reflink helpers */
+DEFINE_AG_EXTENT_EVENT(xfs_refcount_find_shared);
+DEFINE_AG_EXTENT_EVENT(xfs_refcount_find_shared_result);
+DEFINE_AG_ERROR_EVENT(xfs_refcount_find_shared_error);
+
 #endif /* _TRACE_XFS_H */
 
 #undef TRACE_INCLUDE_PATH

