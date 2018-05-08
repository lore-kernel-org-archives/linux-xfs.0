Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:52295 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754222AbeEHDmM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 May 2018 23:42:12 -0400
Received: from discord.disaster.area ([192.168.1.111])
        by dastard with esmtp (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1fFtVt-0002Kh-1k
        for linux-xfs@vger.kernel.org; Tue, 08 May 2018 13:42:05 +1000
Received: from dave by discord.disaster.area with local (Exim 4.91)
        (envelope-from <david@fromorbit.com>)
        id 1fFtVt-0002hn-0s
        for linux-xfs@vger.kernel.org; Tue, 08 May 2018 13:42:05 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 3/9] xfs: adder caller IP to xfs_defer* tracepoints
Date: Tue,  8 May 2018 13:41:56 +1000
Message-Id: <20180508034202.10136-4-david@fromorbit.com>
In-Reply-To: <20180508034202.10136-1-david@fromorbit.com>
References: <20180508034202.10136-1-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

So it's clear in the trace where they are being called from.

Signed-Off-By: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_defer.c | 12 ++++++------
 fs/xfs/xfs_trace.h        | 17 +++++++++++------
 2 files changed, 17 insertions(+), 12 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
index 087fea02c389..51821af5d653 100644
--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -220,7 +220,7 @@ xfs_defer_trans_abort(
 {
 	struct xfs_defer_pending	*dfp;
 
-	trace_xfs_defer_trans_abort(tp->t_mountp, dop);
+	trace_xfs_defer_trans_abort(tp->t_mountp, dop, _RET_IP_);
 
 	/* Abort intent items that don't have a done item. */
 	list_for_each_entry(dfp, &dop->dop_pending, dfp_list) {
@@ -253,7 +253,7 @@ xfs_defer_trans_roll(
 	for (i = 0; i < XFS_DEFER_OPS_NR_BUFS && dop->dop_bufs[i]; i++)
 		xfs_trans_dirty_buf(*tp, dop->dop_bufs[i]);
 
-	trace_xfs_defer_trans_roll((*tp)->t_mountp, dop);
+	trace_xfs_defer_trans_roll((*tp)->t_mountp, dop, _RET_IP_);
 
 	/* Roll the transaction. */
 	error = xfs_trans_roll(tp);
@@ -355,7 +355,7 @@ xfs_defer_finish(
 
 	ASSERT((*tp)->t_flags & XFS_TRANS_PERM_LOG_RES);
 
-	trace_xfs_defer_finish((*tp)->t_mountp, dop);
+	trace_xfs_defer_finish((*tp)->t_mountp, dop, _RET_IP_);
 
 	/* Until we run out of pending work to finish... */
 	while (xfs_defer_has_unfinished_work(dop)) {
@@ -431,7 +431,7 @@ xfs_defer_finish(
 	if (error)
 		trace_xfs_defer_finish_error((*tp)->t_mountp, dop, error);
 	else
-		trace_xfs_defer_finish_done((*tp)->t_mountp, dop);
+		trace_xfs_defer_finish_done((*tp)->t_mountp, dop, _RET_IP_);
 	return error;
 }
 
@@ -447,7 +447,7 @@ xfs_defer_cancel(
 	struct list_head		*pwi;
 	struct list_head		*n;
 
-	trace_xfs_defer_cancel(NULL, dop);
+	trace_xfs_defer_cancel(NULL, dop, _RET_IP_);
 
 	/*
 	 * Free the pending items.  Caller should already have arranged
@@ -532,5 +532,5 @@ xfs_defer_init(
 	*fbp = NULLFSBLOCK;
 	INIT_LIST_HEAD(&dop->dop_intake);
 	INIT_LIST_HEAD(&dop->dop_pending);
-	trace_xfs_defer_init(NULL, dop);
+	trace_xfs_defer_init(NULL, dop, _RET_IP_);
 }
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 8136f2280173..947ab6e32c18 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -2243,30 +2243,35 @@ struct xfs_defer_pending;
 struct xfs_defer_ops;
 
 DECLARE_EVENT_CLASS(xfs_defer_class,
-	TP_PROTO(struct xfs_mount *mp, struct xfs_defer_ops *dop),
-	TP_ARGS(mp, dop),
+	TP_PROTO(struct xfs_mount *mp, struct xfs_defer_ops *dop,
+		 unsigned long caller_ip),
+	TP_ARGS(mp, dop, caller_ip),
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
 		__field(void *, dop)
 		__field(char, committed)
 		__field(char, low)
+		__field(unsigned long, caller_ip)
 	),
 	TP_fast_assign(
 		__entry->dev = mp ? mp->m_super->s_dev : 0;
 		__entry->dop = dop;
 		__entry->committed = dop->dop_committed;
 		__entry->low = dop->dop_low;
+		__entry->caller_ip = caller_ip;
 	),
-	TP_printk("dev %d:%d ops %p committed %d low %d",
+	TP_printk("dev %d:%d ops %p committed %d low %d, caller %pS",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->dop,
 		  __entry->committed,
-		  __entry->low)
+		  __entry->low,
+		  (char *)__entry->caller_ip)
 )
 #define DEFINE_DEFER_EVENT(name) \
 DEFINE_EVENT(xfs_defer_class, name, \
-	TP_PROTO(struct xfs_mount *mp, struct xfs_defer_ops *dop), \
-	TP_ARGS(mp, dop))
+	TP_PROTO(struct xfs_mount *mp, struct xfs_defer_ops *dop, \
+		 unsigned long caller_ip), \
+	TP_ARGS(mp, dop, caller_ip))
 
 DECLARE_EVENT_CLASS(xfs_defer_error_class,
 	TP_PROTO(struct xfs_mount *mp, struct xfs_defer_ops *dop, int error),
-- 
2.17.0

