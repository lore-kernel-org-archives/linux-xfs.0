Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7N52lJ2134666 for <xfs@oss.sgi.com>; Thu, 23 Aug 2012 00:02:47 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	s49JNUFwdmN1EoWm for <xfs@oss.sgi.com>;
	Wed, 22 Aug 2012 22:03:32 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1T4PZq-0003F5-7B
	for xfs@oss.sgi.com; Thu, 23 Aug 2012 15:03:30 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1T4PZl-0003cj-38
	for xfs@oss.sgi.com; Thu, 23 Aug 2012 15:03:25 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 019/102] xfs: add AIL pushing tracepoints
Date: Thu, 23 Aug 2012 15:01:37 +1000
Message-Id: <1345698180-13612-20-git-send-email-david@fromorbit.com>
In-Reply-To: <1345698180-13612-1-git-send-email-david@fromorbit.com>
References: <1345698180-13612-1-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

From: Christoph Hellwig <hch@infradead.org>

Upstream commit: 9e4c109ac822395e0aae650e4e3c9e4903f6602f

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Alex Elder <aelder@sgi.com>
---
 fs/xfs/linux-2.6/xfs_trace.h |   37 +++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_trans_ail.c       |    8 ++++++++
 2 files changed, 45 insertions(+)

diff --git a/fs/xfs/linux-2.6/xfs_trace.h b/fs/xfs/linux-2.6/xfs_trace.h
index fae13a0..b5f892a 100644
--- a/fs/xfs/linux-2.6/xfs_trace.h
+++ b/fs/xfs/linux-2.6/xfs_trace.h
@@ -30,6 +30,7 @@ struct xfs_buf_log_item;
 struct xfs_da_args;
 struct xfs_da_node_entry;
 struct xfs_dquot;
+struct xfs_log_item;
 struct xlog_ticket;
 struct log;
 struct xlog_recover;
@@ -854,6 +855,42 @@ DEFINE_LOGGRANT_EVENT(xfs_log_ungrant_enter);
 DEFINE_LOGGRANT_EVENT(xfs_log_ungrant_exit);
 DEFINE_LOGGRANT_EVENT(xfs_log_ungrant_sub);
 
+DECLARE_EVENT_CLASS(xfs_log_item_class,
+	TP_PROTO(struct xfs_log_item *lip),
+	TP_ARGS(lip),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(void *, lip)
+		__field(uint, type)
+		__field(uint, flags)
+		__field(xfs_lsn_t, lsn)
+	),
+	TP_fast_assign(
+		__entry->dev = lip->li_mountp->m_super->s_dev;
+		__entry->lip = lip;
+		__entry->type = lip->li_type;
+		__entry->flags = lip->li_flags;
+		__entry->lsn = lip->li_lsn;
+	),
+	TP_printk("dev %d:%d lip 0x%p lsn %d/%d type %s flags %s",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->lip,
+		  CYCLE_LSN(__entry->lsn), BLOCK_LSN(__entry->lsn),
+		  __print_symbolic(__entry->type, XFS_LI_TYPE_DESC),
+		  __print_flags(__entry->flags, "|", XFS_LI_FLAGS))
+)
+
+#define DEFINE_LOG_ITEM_EVENT(name) \
+DEFINE_EVENT(xfs_log_item_class, name, \
+	TP_PROTO(struct xfs_log_item *lip), \
+	TP_ARGS(lip))
+DEFINE_LOG_ITEM_EVENT(xfs_ail_push);
+DEFINE_LOG_ITEM_EVENT(xfs_ail_pushbuf);
+DEFINE_LOG_ITEM_EVENT(xfs_ail_pushbuf_pinned);
+DEFINE_LOG_ITEM_EVENT(xfs_ail_pinned);
+DEFINE_LOG_ITEM_EVENT(xfs_ail_locked);
+
+
 DECLARE_EVENT_CLASS(xfs_file_class,
 	TP_PROTO(struct xfs_inode *ip, size_t count, loff_t offset, int flags),
 	TP_ARGS(ip, count, offset, flags),
diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
index 3949a5e..409ac37 100644
--- a/fs/xfs/xfs_trans_ail.c
+++ b/fs/xfs/xfs_trans_ail.c
@@ -26,6 +26,7 @@
 #include "xfs_ag.h"
 #include "xfs_mount.h"
 #include "xfs_trans_priv.h"
+#include "xfs_trace.h"
 #include "xfs_error.h"
 
 #ifdef DEBUG
@@ -476,14 +477,18 @@ xfsaild_push(
 		switch (lock_result) {
 		case XFS_ITEM_SUCCESS:
 			XFS_STATS_INC(xs_push_ail_success);
+			trace_xfs_ail_push(lip);
+
 			IOP_PUSH(lip);
 			ailp->xa_last_pushed_lsn = lsn;
 			break;
 
 		case XFS_ITEM_PUSHBUF:
 			XFS_STATS_INC(xs_push_ail_pushbuf);
+			trace_xfs_ail_pushbuf(lip);
 
 			if (!IOP_PUSHBUF(lip)) {
+				trace_xfs_ail_pushbuf_pinned(lip);
 				stuck++;
 				ailp->xa_log_flush++;
 			} else {
@@ -494,12 +499,15 @@ xfsaild_push(
 
 		case XFS_ITEM_PINNED:
 			XFS_STATS_INC(xs_push_ail_pinned);
+			trace_xfs_ail_pinned(lip);
+
 			stuck++;
 			ailp->xa_log_flush++;
 			break;
 
 		case XFS_ITEM_LOCKED:
 			XFS_STATS_INC(xs_push_ail_locked);
+			trace_xfs_ail_locked(lip);
 			stuck++;
 			break;
 
-- 
1.7.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
