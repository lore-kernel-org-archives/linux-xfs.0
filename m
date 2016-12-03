Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:20152 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932509AbcLCBjw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Dec 2016 20:39:52 -0500
Subject: [PATCH 41/55] xfs: create tracepoints for online repair
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 02 Dec 2016 17:39:47 -0800
Message-ID: <148072918786.12995.14733871998979028054.stgit@birch.djwong.org>
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

These tracepoints will be used to debug the online repair routines.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_trace.h |  147 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 147 insertions(+)


diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 5a9ac01..7c48c1c 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -3851,6 +3851,153 @@ DEFINE_SCRUB_AG_LOCK_EVENT(xfs_scrub_ag_can_lock);
 DEFINE_SCRUB_AG_LOCK_EVENT(xfs_scrub_ag_may_deadlock);
 DEFINE_SCRUB_AG_LOCK_EVENT(xfs_scrub_ag_lock_all);
 
+/* repair tracepoints */
+DEFINE_SCRUB_EVENT(xfs_repair_attempt);
+DEFINE_SCRUB_EVENT(xfs_repair_done);
+DEFINE_BUSY_EVENT(xfs_repair_free_or_unmap_extent);
+DEFINE_BUSY_EVENT(xfs_repair_collect_btree_extent);
+TRACE_EVENT(xfs_repair_init_btblock,
+	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno, xfs_agblock_t agbno,
+		 uint32_t magic),
+	TP_ARGS(mp, agno, agbno, magic),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_agnumber_t, agno)
+		__field(xfs_agblock_t, agbno)
+		__field(uint32_t, magic)
+	),
+	TP_fast_assign(
+		__entry->dev = mp->m_super->s_dev;
+		__entry->agno = agno;
+		__entry->agbno = agbno;
+		__entry->magic = magic;
+	),
+	TP_printk("dev %d:%d agno %u agbno %u magic 0x%x",
+		  MAJOR(__entry->dev), MINOR(__entry->dev), __entry->agno,
+		  __entry->agbno, __entry->magic)
+)
+TRACE_EVENT(xfs_repair_find_ag_btree_roots_helper,
+	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno, xfs_agblock_t agbno,
+		 uint32_t magic, uint16_t level),
+	TP_ARGS(mp, agno, agbno, magic, level),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_agnumber_t, agno)
+		__field(xfs_agblock_t, agbno)
+		__field(uint32_t, magic)
+		__field(uint16_t, level)
+	),
+	TP_fast_assign(
+		__entry->dev = mp->m_super->s_dev;
+		__entry->agno = agno;
+		__entry->agbno = agbno;
+		__entry->magic = magic;
+		__entry->level = level;
+	),
+	TP_printk("dev %d:%d agno %u agbno %u magic 0x%x level %u",
+		  MAJOR(__entry->dev), MINOR(__entry->dev), __entry->agno,
+		  __entry->agbno, __entry->magic, __entry->level)
+)
+TRACE_EVENT(xfs_repair_calc_ag_resblks,
+	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno,
+		 xfs_agino_t icount, xfs_agblock_t aglen, xfs_agblock_t freelen,
+		 xfs_agblock_t usedlen),
+	TP_ARGS(mp, agno, icount, aglen, freelen, usedlen),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_agnumber_t, agno)
+		__field(xfs_agino_t, icount)
+		__field(xfs_agblock_t, aglen)
+		__field(xfs_agblock_t, freelen)
+		__field(xfs_agblock_t, usedlen)
+	),
+	TP_fast_assign(
+		__entry->dev = mp->m_super->s_dev;
+		__entry->agno = agno;
+		__entry->icount = icount;
+		__entry->aglen = aglen;
+		__entry->freelen = freelen;
+		__entry->usedlen = usedlen;
+	),
+	TP_printk("dev %d:%d agno %d icount %u aglen %u freelen %u usedlen %u",
+		  MAJOR(__entry->dev), MINOR(__entry->dev), __entry->agno,
+		  __entry->icount, __entry->aglen, __entry->freelen,
+		  __entry->usedlen)
+)
+TRACE_EVENT(xfs_repair_calc_ag_resblks_btsize,
+	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno,
+		 xfs_agblock_t bnobt_sz, xfs_agblock_t inobt_sz,
+		 xfs_agblock_t rmapbt_sz, xfs_agblock_t refcbt_sz),
+	TP_ARGS(mp, agno, bnobt_sz, inobt_sz, rmapbt_sz, refcbt_sz),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_agnumber_t, agno)
+		__field(xfs_agblock_t, bnobt_sz)
+		__field(xfs_agblock_t, inobt_sz)
+		__field(xfs_agblock_t, rmapbt_sz)
+		__field(xfs_agblock_t, refcbt_sz)
+	),
+	TP_fast_assign(
+		__entry->dev = mp->m_super->s_dev;
+		__entry->agno = agno;
+		__entry->bnobt_sz = bnobt_sz;
+		__entry->inobt_sz = inobt_sz;
+		__entry->rmapbt_sz = rmapbt_sz;
+		__entry->refcbt_sz = refcbt_sz;
+	),
+	TP_printk("dev %d:%d agno %d bno %u ino %u rmap %u refcount %u",
+		  MAJOR(__entry->dev), MINOR(__entry->dev), __entry->agno,
+		  __entry->bnobt_sz, __entry->inobt_sz, __entry->rmapbt_sz,
+		  __entry->refcbt_sz)
+)
+TRACE_EVENT(xfs_repair_reset_counters,
+	TP_PROTO(struct xfs_mount *mp),
+	TP_ARGS(mp),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+	),
+	TP_fast_assign(
+		__entry->dev = mp->m_super->s_dev;
+	),
+	TP_printk("dev %d:%d",
+		  MAJOR(__entry->dev), MINOR(__entry->dev))
+)
+
+DEFINE_BUSY_EVENT(xfs_repair_agfl_insert);
+DEFINE_RMAPBT_EVENT(xfs_repair_alloc_extent_fn);
+DEFINE_RMAPBT_EVENT(xfs_repair_ialloc_extent_fn);
+TRACE_EVENT(xfs_repair_ialloc_insert,
+	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno,
+		 xfs_agino_t startino, uint16_t holemask, uint8_t count,
+		 uint8_t freecount, uint64_t freemask),
+	TP_ARGS(mp, agno, startino, holemask, count, freecount, freemask),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_agnumber_t, agno)
+		__field(xfs_agino_t, startino)
+		__field(uint16_t, holemask)
+		__field(uint8_t, count)
+		__field(uint8_t, freecount)
+		__field(uint64_t, freemask)
+	),
+	TP_fast_assign(
+		__entry->dev = mp->m_super->s_dev;
+		__entry->agno = agno;
+		__entry->startino = startino;
+		__entry->holemask = holemask;
+		__entry->count = count;
+		__entry->freecount = freecount;
+		__entry->freemask = freemask;
+	),
+	TP_printk("dev %d:%d agno %d startino %u holemask 0x%x count %u freecount %u freemask 0x%llx",
+		  MAJOR(__entry->dev), MINOR(__entry->dev), __entry->agno,
+		  __entry->startino, __entry->holemask, __entry->count,
+		  __entry->freecount, __entry->freemask)
+)
+DEFINE_RMAPBT_EVENT(xfs_repair_rmap_extent_fn);
+DEFINE_REFCOUNT_EXTENT_EVENT(xfs_repair_refcount_extent_fn);
+DEFINE_RMAPBT_EVENT(xfs_repair_bmap_extent_fn);
+
 #endif /* _TRACE_XFS_H */
 
 #undef TRACE_INCLUDE_PATH

