Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:41905 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933269AbdHYWRm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 25 Aug 2017 18:17:42 -0400
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v7PMHeR1013463
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 25 Aug 2017 22:17:41 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id v7PMHeL8003076
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 25 Aug 2017 22:17:40 GMT
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id v7PMHe1X023713
        for <linux-xfs@vger.kernel.org>; Fri, 25 Aug 2017 22:17:40 GMT
Subject: [PATCH 07/19] xfs: create tracepoints for online repair
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 25 Aug 2017 15:17:37 -0700
Message-ID: <150369945760.9957.14285425672997392968.stgit@magnolia>
In-Reply-To: <150369940879.9957.6303798184036268321.stgit@magnolia>
References: <150369940879.9957.6303798184036268321.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

These tracepoints will be used to debug the online repair routines.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/scrub/trace.h |  166 ++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 166 insertions(+)


diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index 6769e02..f389501 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -68,6 +68,8 @@ DEFINE_EVENT(xfs_scrub_class, name, \
 DEFINE_SCRUB_EVENT(xfs_scrub_start);
 DEFINE_SCRUB_EVENT(xfs_scrub_done);
 DEFINE_SCRUB_EVENT(xfs_scrub_deadlock_retry);
+DEFINE_SCRUB_EVENT(xfs_repair_attempt);
+DEFINE_SCRUB_EVENT(xfs_repair_done);
 
 TRACE_EVENT(xfs_scrub_op_error,
 	TP_PROTO(struct xfs_scrub_context *sc, xfs_agnumber_t agno,
@@ -489,6 +491,170 @@ TRACE_EVENT(xfs_scrub_xref_error,
 		  __entry->ret_ip)
 );
 
+/* repair tracepoints */
+
+/* XXX sort out this mess (and the two others below) later */
+
+#define trace_xfs_repair_free_or_unmap_extent(...)
+#define trace_xfs_repair_collect_btree_extent(...)
+#if 0
+DEFINE_BUSY_EVENT(xfs_repair_free_or_unmap_extent);
+DEFINE_BUSY_EVENT(xfs_repair_collect_btree_extent);
+#endif
+
+TRACE_EVENT(xfs_repair_init_btblock,
+	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno, xfs_agblock_t agbno,
+		 xfs_btnum_t btnum),
+	TP_ARGS(mp, agno, agbno, btnum),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_agnumber_t, agno)
+		__field(xfs_agblock_t, agbno)
+		__field(uint32_t, btnum)
+	),
+	TP_fast_assign(
+		__entry->dev = mp->m_super->s_dev;
+		__entry->agno = agno;
+		__entry->agbno = agbno;
+		__entry->btnum = btnum;
+	),
+	TP_printk("dev %d:%d agno %u agbno %u btnum %d",
+		  MAJOR(__entry->dev), MINOR(__entry->dev), __entry->agno,
+		  __entry->agbno, __entry->btnum)
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
+#define trace_xfs_repair_agfl_insert(...)
+#define trace_xfs_repair_alloc_extent_fn(...)
+#define trace_xfs_repair_ialloc_extent_fn(...)
+#if 0
+DEFINE_BUSY_EVENT(xfs_repair_agfl_insert);
+DEFINE_RMAPBT_EVENT(xfs_repair_alloc_extent_fn);
+DEFINE_RMAPBT_EVENT(xfs_repair_ialloc_extent_fn);
+#endif
+
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
+#define trace_xfs_repair_rmap_extent_fn(...)
+#define trace_xfs_repair_refcount_extent_fn(...)
+#define trace_xfs_repair_bmap_extent_fn(...)
+#if 0
+DEFINE_RMAPBT_EVENT(xfs_repair_rmap_extent_fn);
+DEFINE_REFCOUNT_EXTENT_EVENT(xfs_repair_refcount_extent_fn);
+DEFINE_RMAPBT_EVENT(xfs_repair_bmap_extent_fn);
+#endif
+
 #endif /* _TRACE_XFS_SCRUB_TRACE_H */
 
 #undef TRACE_INCLUDE_PATH

