Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:33644 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751414AbeCOU1J (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Mar 2018 16:27:09 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w2FKFYWd053769
        for <linux-xfs@vger.kernel.org>; Thu, 15 Mar 2018 20:27:09 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by aserp2130.oracle.com with ESMTP id 2gqyq001ht-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 15 Mar 2018 20:27:08 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w2FKR7q0029962
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 15 Mar 2018 20:27:08 GMT
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w2FKR7pU018287
        for <linux-xfs@vger.kernel.org>; Thu, 15 Mar 2018 20:27:07 GMT
Subject: [PATCH 07/20] xfs: create tracepoints for online repair
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 15 Mar 2018 13:27:05 -0700
Message-ID: <152114562551.22742.14664633243118632395.stgit@magnolia>
In-Reply-To: <152114558216.22742.6635423816559130061.stgit@magnolia>
References: <152114558216.22742.6635423816559130061.stgit@magnolia>
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
 fs/xfs/scrub/trace.h |  243 ++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 243 insertions(+)


diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index 5d2b1c2..8238882 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -69,6 +69,8 @@ DEFINE_EVENT(xfs_scrub_class, name, \
 DEFINE_SCRUB_EVENT(xfs_scrub_start);
 DEFINE_SCRUB_EVENT(xfs_scrub_done);
 DEFINE_SCRUB_EVENT(xfs_scrub_deadlock_retry);
+DEFINE_SCRUB_EVENT(xfs_repair_attempt);
+DEFINE_SCRUB_EVENT(xfs_repair_done);
 
 TRACE_EVENT(xfs_scrub_op_error,
 	TP_PROTO(struct xfs_scrub_context *sc, xfs_agnumber_t agno,
@@ -492,6 +494,247 @@ TRACE_EVENT(xfs_scrub_xref_error,
 		  __entry->ret_ip)
 );
 
+/* repair tracepoints */
+#if IS_ENABLED(CONFIG_XFS_ONLINE_REPAIR)
+
+DECLARE_EVENT_CLASS(xfs_repair_extent_class,
+	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno,
+		 xfs_agblock_t agbno, xfs_extlen_t len),
+	TP_ARGS(mp, agno, agbno, len),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_agnumber_t, agno)
+		__field(xfs_agblock_t, agbno)
+		__field(xfs_extlen_t, len)
+	),
+	TP_fast_assign(
+		__entry->dev = mp->m_super->s_dev;
+		__entry->agno = agno;
+		__entry->agbno = agbno;
+		__entry->len = len;
+	),
+	TP_printk("dev %d:%d agno %u agbno %u len %u",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->agno,
+		  __entry->agbno,
+		  __entry->len)
+);
+#define DEFINE_REPAIR_EXTENT_EVENT(name) \
+DEFINE_EVENT(xfs_repair_extent_class, name, \
+	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno, \
+		 xfs_agblock_t agbno, xfs_extlen_t len), \
+	TP_ARGS(mp, agno, agbno, len))
+DEFINE_REPAIR_EXTENT_EVENT(xfs_repair_free_or_unmap_extent);
+DEFINE_REPAIR_EXTENT_EVENT(xfs_repair_collect_btree_extent);
+DEFINE_REPAIR_EXTENT_EVENT(xfs_repair_agfl_insert);
+
+DECLARE_EVENT_CLASS(xfs_repair_rmap_class,
+	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno,
+		 xfs_agblock_t agbno, xfs_extlen_t len,
+		 uint64_t owner, uint64_t offset, unsigned int flags),
+	TP_ARGS(mp, agno, agbno, len, owner, offset, flags),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_agnumber_t, agno)
+		__field(xfs_agblock_t, agbno)
+		__field(xfs_extlen_t, len)
+		__field(uint64_t, owner)
+		__field(uint64_t, offset)
+		__field(unsigned int, flags)
+	),
+	TP_fast_assign(
+		__entry->dev = mp->m_super->s_dev;
+		__entry->agno = agno;
+		__entry->agbno = agbno;
+		__entry->len = len;
+		__entry->owner = owner;
+		__entry->offset = offset;
+		__entry->flags = flags;
+	),
+	TP_printk("dev %d:%d agno %u agbno %u len %u owner %lld offset %llu flags 0x%x",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->agno,
+		  __entry->agbno,
+		  __entry->len,
+		  __entry->owner,
+		  __entry->offset,
+		  __entry->flags)
+);
+#define DEFINE_REPAIR_RMAP_EVENT(name) \
+DEFINE_EVENT(xfs_repair_rmap_class, name, \
+	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno, \
+		 xfs_agblock_t agbno, xfs_extlen_t len, \
+		 uint64_t owner, uint64_t offset, unsigned int flags), \
+	TP_ARGS(mp, agno, agbno, len, owner, offset, flags))
+DEFINE_REPAIR_RMAP_EVENT(xfs_repair_alloc_extent_fn);
+DEFINE_REPAIR_RMAP_EVENT(xfs_repair_ialloc_extent_fn);
+DEFINE_REPAIR_RMAP_EVENT(xfs_repair_rmap_extent_fn);
+DEFINE_REPAIR_RMAP_EVENT(xfs_repair_bmap_extent_fn);
+
+TRACE_EVENT(xfs_repair_refcount_extent_fn,
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
+	TP_printk("dev %d:%d agno %u agbno %u len %u refcount %u",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->agno,
+		  __entry->startblock,
+		  __entry->blockcount,
+		  __entry->refcount)
+)
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
+
+#endif /* IS_ENABLED(CONFIG_XFS_ONLINE_REPAIR) */
+
 #endif /* _TRACE_XFS_SCRUB_TRACE_H */
 
 #undef TRACE_INCLUDE_PATH

