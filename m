Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:19255 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757714AbcLCBhj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Dec 2016 20:37:39 -0500
Subject: [PATCH 16/55] xfs: add scrub tracepoints
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 02 Dec 2016 17:36:55 -0800
Message-ID: <148072901576.12995.2754148857945557965.stgit@birch.djwong.org>
In-Reply-To: <148072891404.12995.15510849192837089093.stgit@birch.djwong.org>
References: <148072891404.12995.15510849192837089093.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_types.h |    5 +
 fs/xfs/xfs_trace.h        |  372 +++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 377 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_types.h b/fs/xfs/libxfs/xfs_types.h
index 717909f..04145e5 100644
--- a/fs/xfs/libxfs/xfs_types.h
+++ b/fs/xfs/libxfs/xfs_types.h
@@ -94,6 +94,11 @@ typedef __int64_t	xfs_sfiloff_t;	/* signed block number in a file */
 #define	XFS_ATTR_FORK	1
 #define	XFS_COW_FORK	2
 
+#define XFS_FORK_DESC \
+	{ XFS_DATA_FORK,	"data" }, \
+	{ XFS_ATTR_FORK,	"attr" }, \
+	{ XFS_COW_FORK,		"CoW" }
+
 /*
  * Min numbers of data/attr fork btree root pointers.
  */
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 71778d0..ddbba0f 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -3460,6 +3460,378 @@ DEFINE_GETFSMAP_EVENT(xfs_getfsmap_low_key);
 DEFINE_GETFSMAP_EVENT(xfs_getfsmap_high_key);
 DEFINE_GETFSMAP_EVENT(xfs_getfsmap_mapping);
 
+/* scrub */
+#define XFS_SCRUB_TYPE_DESC \
+	{ 0, NULL }
+DECLARE_EVENT_CLASS(xfs_scrub_class,
+	TP_PROTO(struct xfs_inode *ip, int type, xfs_agnumber_t agno,
+		 xfs_ino_t inum, unsigned int gen, unsigned int flags,
+		 int error),
+	TP_ARGS(ip, type, agno, inum, gen, flags, error),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_ino_t, ino)
+		__field(int, type)
+		__field(xfs_agnumber_t, agno)
+		__field(xfs_ino_t, inum)
+		__field(unsigned int, gen)
+		__field(unsigned int, flags)
+		__field(int, error)
+	),
+	TP_fast_assign(
+		__entry->dev = ip->i_mount->m_super->s_dev;
+		__entry->ino = ip->i_ino;
+		__entry->type = type;
+		__entry->agno = agno;
+		__entry->inum = inum;
+		__entry->gen = gen;
+		__entry->flags = flags;
+		__entry->error = error;
+	),
+	TP_printk("dev %d:%d ino %llu type %s agno %u inum %llu gen %u flags 0x%x error %d\n",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->ino,
+		  __print_symbolic(__entry->type, XFS_SCRUB_TYPE_DESC),
+		  __entry->agno,
+		  __entry->inum,
+		  __entry->gen,
+		  __entry->flags,
+		  __entry->error)
+)
+#define DEFINE_SCRUB_EVENT(name) \
+DEFINE_EVENT(xfs_scrub_class, name, \
+	TP_PROTO(struct xfs_inode *ip, int type, xfs_agnumber_t agno, \
+		 xfs_ino_t inum, unsigned int gen, unsigned int flags, \
+		 int error), \
+	TP_ARGS(ip, type, agno, inum, gen, flags, error))
+
+DECLARE_EVENT_CLASS(xfs_scrub_sbtree_class,
+	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno, xfs_agblock_t bno,
+		 xfs_btnum_t btnum, int level, int nlevels, int ptr),
+	TP_ARGS(mp, agno, bno, btnum, level, nlevels, ptr),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_btnum_t, btnum)
+		__field(xfs_agnumber_t, agno)
+		__field(xfs_agblock_t, bno)
+		__field(int, level)
+		__field(int, nlevels)
+		__field(int, ptr)
+	),
+	TP_fast_assign(
+		__entry->dev = mp->m_super->s_dev;
+		__entry->agno = agno;
+		__entry->btnum = btnum;
+		__entry->bno = bno;
+		__entry->level = level;
+		__entry->nlevels = nlevels;
+		__entry->ptr = ptr;
+	),
+	TP_printk("dev %d:%d agno %u agbno %u btnum %d level %d nlevels %d ptr %d\n",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->agno,
+		  __entry->bno,
+		  __entry->btnum,
+		  __entry->level,
+		  __entry->nlevels,
+		  __entry->ptr)
+)
+#define DEFINE_SCRUB_SBTREE_EVENT(name) \
+DEFINE_EVENT(xfs_scrub_sbtree_class, name, \
+	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno, xfs_agblock_t bno, \
+		 xfs_btnum_t btnum, int level, int nlevels, int ptr), \
+	TP_ARGS(mp, agno, bno, btnum, level, nlevels, ptr))
+
+DEFINE_SCRUB_EVENT(xfs_scrub);
+DEFINE_SCRUB_EVENT(xfs_scrub_done);
+DEFINE_SCRUB_SBTREE_EVENT(xfs_scrub_btree_rec);
+DEFINE_SCRUB_SBTREE_EVENT(xfs_scrub_btree_key);
+
+TRACE_EVENT(xfs_scrub_op_error,
+	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno, xfs_agblock_t bno,
+		 const char *type, int error, const char *func,
+		 int line),
+	TP_ARGS(mp, agno, bno, type, error, func, line),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_agnumber_t, agno)
+		__field(xfs_agblock_t, bno)
+		__string(type, type)
+		__field(int, error)
+		__string(func, func)
+		__field(int, line)
+	),
+	TP_fast_assign(
+		__entry->dev = mp->m_super->s_dev;
+		__entry->agno = agno;
+		__entry->bno = bno;
+		__assign_str(type, type);
+		__entry->error = error;
+		__assign_str(func, func);
+		__entry->line = line;
+	),
+	TP_printk("dev %d:%d agno %u agbno %u type '%s' error %d fn %s:%d\n",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->agno,
+		  __entry->bno,
+		  __get_str(type),
+		  __entry->error,
+		  __get_str(func),
+		  __entry->line)
+);
+
+TRACE_EVENT(xfs_scrub_file_op_error,
+	TP_PROTO(struct xfs_inode *ip, int whichfork, xfs_fileoff_t offset,
+		 const char *type, int error, const char *func,
+		 int line),
+	TP_ARGS(ip, whichfork, offset, type, error, func, line),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_ino_t, ino)
+		__field(int, whichfork)
+		__field(xfs_fileoff_t, offset)
+		__string(type, type)
+		__field(int, error)
+		__string(func, func)
+		__field(int, line)
+	),
+	TP_fast_assign(
+		__entry->dev = ip->i_mount->m_super->s_dev;
+		__entry->ino = ip->i_ino;
+		__entry->whichfork = whichfork;
+		__entry->offset = offset;
+		__assign_str(type, type);
+		__entry->error = error;
+		__assign_str(func, func);
+		__entry->line = line;
+	),
+	TP_printk("dev %d:%d ino %llu %s offset %llu type '%s' error %d fn %s:%d\n",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->ino,
+		  __print_symbolic(__entry->whichfork, XFS_FORK_DESC),
+		  __entry->offset,
+		  __get_str(type),
+		  __entry->error,
+		  __get_str(func),
+		  __entry->line)
+);
+
+DECLARE_EVENT_CLASS(xfs_scrub_block_error_class,
+	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno, xfs_agblock_t bno,
+		 const char *type, const char *check, const char *func,
+		 int line),
+	TP_ARGS(mp, agno, bno, type, check, func, line),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_agnumber_t, agno)
+		__field(xfs_agblock_t, bno)
+		__string(type, type)
+		__string(check, check)
+		__string(func, func)
+		__field(int, line)
+	),
+	TP_fast_assign(
+		__entry->dev = mp->m_super->s_dev;
+		__entry->agno = agno;
+		__entry->bno = bno;
+		__assign_str(type, type);
+		__assign_str(check, check);
+		__assign_str(func, func);
+		__entry->line = line;
+	),
+	TP_printk("dev %d:%d agno %u agbno %u type '%s' check '%s' fn %s:%d\n",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->agno,
+		  __entry->bno,
+		  __get_str(type),
+		  __get_str(check),
+		  __get_str(func),
+		  __entry->line)
+)
+
+#define DEFINE_SCRUB_BLOCK_ERROR_EVENT(name) \
+DEFINE_EVENT(xfs_scrub_block_error_class, name, \
+	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno, xfs_agblock_t bno, \
+		 const char *type, const char *check, const char *func, \
+		 int line), \
+	TP_ARGS(mp, agno, bno, type, check, func, line))
+
+DEFINE_SCRUB_BLOCK_ERROR_EVENT(xfs_scrub_block_error);
+DEFINE_SCRUB_BLOCK_ERROR_EVENT(xfs_scrub_block_preen);
+
+DECLARE_EVENT_CLASS(xfs_scrub_ino_error_class,
+	TP_PROTO(struct xfs_mount *mp, xfs_ino_t ino, xfs_agnumber_t agno, xfs_agblock_t bno,
+		 const char *type, const char *check, const char *func,
+		 int line),
+	TP_ARGS(mp, ino, agno, bno, type, check, func, line),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_ino_t, ino)
+		__field(xfs_agnumber_t, agno)
+		__field(xfs_agblock_t, bno)
+		__string(type, type)
+		__string(check, check)
+		__string(func, func)
+		__field(int, line)
+	),
+	TP_fast_assign(
+		__entry->dev = mp->m_super->s_dev;
+		__entry->ino = ino;
+		__entry->agno = agno;
+		__entry->bno = bno;
+		__assign_str(type, type);
+		__assign_str(check, check);
+		__assign_str(func, func);
+		__entry->line = line;
+	),
+	TP_printk("dev %d:%d ino %llu agno %u agbno %u type '%s' check '%s' fn %s:%d\n",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->ino,
+		  __entry->agno,
+		  __entry->bno,
+		  __get_str(type),
+		  __get_str(check),
+		  __get_str(func),
+		  __entry->line)
+)
+
+#define DEFINE_SCRUB_INO_ERROR_EVENT(name) \
+DEFINE_EVENT(xfs_scrub_ino_error_class, name, \
+	TP_PROTO(struct xfs_mount *mp, xfs_ino_t ino, xfs_agnumber_t agno, xfs_agblock_t bno, \
+		 const char *type, const char *check, const char *func, \
+		 int line), \
+	TP_ARGS(mp, ino, agno, bno, type, check, func, line))
+
+DEFINE_SCRUB_INO_ERROR_EVENT(xfs_scrub_ino_error);
+DEFINE_SCRUB_INO_ERROR_EVENT(xfs_scrub_ino_preen);
+
+TRACE_EVENT(xfs_scrub_data_error,
+	TP_PROTO(struct xfs_inode *ip, int whichfork, xfs_fileoff_t offset,
+		 const char *type, const char *check, const char *func,
+		 int line),
+	TP_ARGS(ip, whichfork, offset, type, check, func, line),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_ino_t, ino)
+		__field(int, whichfork)
+		__field(xfs_fileoff_t, offset)
+		__string(type, type)
+		__string(check, check)
+		__string(func, func)
+		__field(int, line)
+	),
+	TP_fast_assign(
+		__entry->dev = ip->i_mount->m_super->s_dev;
+		__entry->ino = ip->i_ino;
+		__entry->whichfork = whichfork;
+		__entry->offset = offset;
+		__assign_str(type, type);
+		__assign_str(check, check);
+		__assign_str(func, func);
+		__entry->line = line;
+	),
+	TP_printk("dev %d:%d ino %llu %s fork offset %llu type '%s' check '%s' fn %s:%d\n",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->ino,
+		  __print_symbolic(__entry->whichfork, XFS_FORK_DESC),
+		  __entry->offset,
+		  __get_str(type),
+		  __get_str(check),
+		  __get_str(func),
+		  __entry->line)
+);
+
+TRACE_EVENT(xfs_scrub_xref_error,
+	TP_PROTO(struct xfs_mount *mp, const char *type, int error,
+		 const char *func, int line),
+	TP_ARGS(mp, type, error, func, line),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__string(type, type)
+		__field(int, error)
+		__string(func, func)
+		__field(int, line)
+	),
+	TP_fast_assign(
+		__entry->dev = mp->m_super->s_dev;
+		__assign_str(type, type);
+		__entry->error = error;
+		__assign_str(func, func);
+		__entry->line = line;
+	),
+	TP_printk("dev %d:%d btree %s xref error %d fn %s:%d\n",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __get_str(type),
+		  __entry->error,
+		  __get_str(func),
+		  __entry->line)
+);
+
+TRACE_EVENT(xfs_scrub_btree_error,
+	TP_PROTO(struct xfs_mount *mp, const char *bt_type, const char *bt_ptr,
+		 xfs_agnumber_t agno, xfs_agblock_t bno, const char *check,
+		 const char *func, int line),
+	TP_ARGS(mp, bt_type, bt_ptr, agno, bno, check, func, line),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__string(bt_type, bt_type)
+		__string(bt_ptr, bt_ptr)
+		__field(xfs_agnumber_t, agno)
+		__field(xfs_agblock_t, bno)
+		__string(check, check)
+		__string(func, func)
+		__field(int, line)
+	),
+	TP_fast_assign(
+		__entry->dev = mp->m_super->s_dev;
+		__assign_str(bt_type, bt_type);
+		__assign_str(bt_ptr, bt_ptr);
+		__entry->agno = agno;
+		__entry->bno = bno;
+		__assign_str(check, check);
+		__assign_str(func, func);
+		__entry->line = line;
+	),
+	TP_printk("dev %d:%d %s %s agno %u agbno %u check '%s' fn %s:%d\n",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __get_str(bt_type),
+		  __get_str(bt_ptr),
+		  __entry->agno,
+		  __entry->bno,
+		  __get_str(check),
+		  __get_str(func),
+		  __entry->line)
+);
+
+DECLARE_EVENT_CLASS(xfs_scrub_ag_lock_class,
+	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t max_ag,
+		 xfs_agnumber_t agno),
+	TP_ARGS(mp, max_ag, agno),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_agnumber_t, max_ag)
+		__field(xfs_agnumber_t, agno)
+	),
+	TP_fast_assign(
+		__entry->dev = mp->m_super->s_dev;
+		__entry->max_ag = max_ag;
+		__entry->agno = agno;
+	),
+	TP_printk("dev %d:%d max_ag %u agno %u\n",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->max_ag,
+		  __entry->agno)
+)
+#define DEFINE_SCRUB_AG_LOCK_EVENT(name) \
+DEFINE_EVENT(xfs_scrub_ag_lock_class, name, \
+	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t max_ag, \
+		 xfs_agnumber_t agno), \
+	TP_ARGS(mp, max_ag, agno))
+
+DEFINE_SCRUB_AG_LOCK_EVENT(xfs_scrub_ag_can_lock);
+DEFINE_SCRUB_AG_LOCK_EVENT(xfs_scrub_ag_may_deadlock);
+DEFINE_SCRUB_AG_LOCK_EVENT(xfs_scrub_ag_lock_all);
+
 #endif /* _TRACE_XFS_H */
 
 #undef TRACE_INCLUDE_PATH

