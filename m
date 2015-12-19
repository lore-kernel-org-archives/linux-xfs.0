Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 094077FFF
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 03:00:34 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C2291304059
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 01:00:33 -0800 (PST)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id At8UUcbhIeAPvZ4f (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 19 Dec 2015 01:00:30 -0800 (PST)
Subject: [PATCH 37/76] xfs: define tracepoints for refcount btree activities
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sat, 19 Dec 2015 01:00:27 -0800
Message-ID: <20151219090027.12713.53055.stgit@birch.djwong.org>
In-Reply-To: <20151219085622.12713.88678.stgit@birch.djwong.org>
References: <20151219085622.12713.88678.stgit@birch.djwong.org>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: xfs@oss.sgi.com

Define all the tracepoints we need to inspect the refcount btree
runtime operation.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_trace.h |  329 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 329 insertions(+)


diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index bdd6b18..1c91439 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -39,6 +39,16 @@ struct xfs_buf_log_format;
 struct xfs_inode_log_format;
 struct xfs_bmbt_irec;
 
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
@@ -2455,6 +2465,325 @@ DEFINE_DISCARD_EVENT(xfs_discard_toosmall);
 DEFINE_DISCARD_EVENT(xfs_discard_exclude);
 DEFINE_DISCARD_EVENT(xfs_discard_busy);
 
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
+/* simple AG-based error/%ip tracepoint class */
+DECLARE_EVENT_CLASS(xfs_ag_error_class,
+	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno, int error,
+		 unsigned long caller_ip),
+	TP_ARGS(mp, agno, error, caller_ip),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_agnumber_t, agno)
+		__field(int, error)
+		__field(unsigned long, caller_ip)
+	),
+	TP_fast_assign(
+		__entry->dev = mp->m_super->s_dev;
+		__entry->agno = agno;
+		__entry->error = error;
+		__entry->caller_ip = caller_ip;
+	),
+	TP_printk("dev %d:%d agno %u error %d caller %ps",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->agno,
+		  __entry->error,
+		  (char *)__entry->caller_ip)
+);
+
+#define DEFINE_AG_ERROR_EVENT(name) \
+DEFINE_EVENT(xfs_ag_error_class, name, \
+	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno, int error, \
+		 unsigned long caller_ip), \
+	TP_ARGS(mp, agno, error, caller_ip))
+
+/* refcount btree tracepoints */
+DEFINE_AG_BTREE_LOOKUP_EVENT(xfs_refcountbt_lookup);
+DEFINE_REFCOUNT_EXTENT_EVENT(xfs_refcountbt_get);
+DEFINE_REFCOUNT_EXTENT_EVENT(xfs_refcountbt_update);
+DEFINE_REFCOUNT_EXTENT_EVENT(xfs_refcountbt_insert);
+DEFINE_REFCOUNT_EXTENT_EVENT(xfs_refcountbt_delete);
+
+/* refcount adjustment tracepoints */
+DEFINE_AG_EXTENT_EVENT(xfs_refcount_increase);
+DEFINE_AG_EXTENT_EVENT(xfs_refcount_decrease);
+DEFINE_REFCOUNT_TRIPLE_EXTENT_EVENT(xfs_refcount_merge_center_extents);
+DEFINE_REFCOUNT_EXTENT_EVENT(xfs_refcount_modify_extent);
+DEFINE_REFCOUNT_EXTENT_AT_EVENT(xfs_refcount_split_left_extent);
+DEFINE_REFCOUNT_EXTENT_AT_EVENT(xfs_refcount_split_right_extent);
+DEFINE_REFCOUNT_DOUBLE_EXTENT_EVENT(xfs_refcount_merge_left_extent);
+DEFINE_REFCOUNT_DOUBLE_EXTENT_EVENT(xfs_refcount_merge_right_extent);
+DEFINE_REFCOUNT_DOUBLE_EXTENT_AT_EVENT(xfs_refcount_find_left_extent);
+DEFINE_REFCOUNT_DOUBLE_EXTENT_AT_EVENT(xfs_refcount_find_right_extent);
+DEFINE_AG_ERROR_EVENT(xfs_refcount_adjust_error);
+DEFINE_AG_ERROR_EVENT(xfs_refcount_merge_center_extents_error);
+DEFINE_AG_ERROR_EVENT(xfs_refcount_modify_extent_error);
+DEFINE_AG_ERROR_EVENT(xfs_refcount_split_left_extent_error);
+DEFINE_AG_ERROR_EVENT(xfs_refcount_split_right_extent_error);
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

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
