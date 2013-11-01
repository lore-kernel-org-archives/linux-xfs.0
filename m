Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B0C197F55
	for <xfs@oss.sgi.com>; Thu, 31 Oct 2013 23:27:42 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 54BB08F8065
	for <xfs@oss.sgi.com>; Thu, 31 Oct 2013 21:27:39 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	sJ228EPWcnzUUw3l for <xfs@oss.sgi.com>;
	Thu, 31 Oct 2013 21:27:38 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1Vc6KR-0008Gr-4P
	for xfs@oss.sgi.com; Fri, 01 Nov 2013 15:27:23 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1Vc6KR-0005lZ-3F
	for xfs@oss.sgi.com; Fri, 01 Nov 2013 15:27:23 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 3/5] xfs: trace AIL manipulations
Date: Fri,  1 Nov 2013 15:27:18 +1100
Message-Id: <1383280040-21979-4-git-send-email-david@fromorbit.com>
In-Reply-To: <1383280040-21979-1-git-send-email-david@fromorbit.com>
References: <1383280040-21979-1-git-send-email-david@fromorbit.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

I debugging a log tail issue on a RHEL6 kernel, I added these trace
points to trace log items being added, moved and removed in the AIL
and how that affected the log tail LSN that was written to the log.
They were very helpful in that they immediately identified the cause
of the problem being seen. Hence I'd like to always have them
available for use.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_log.c       |  1 +
 fs/xfs/xfs_trace.h     | 59 +++++++++++++++++++++++++++++++++++++++++++++++++-
 fs/xfs/xfs_trans_ail.c |  3 +++
 3 files changed, 62 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 49dd41e..8497a00 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1076,6 +1076,7 @@ xlog_assign_tail_lsn_locked(
 		tail_lsn = lip->li_lsn;
 	else
 		tail_lsn = atomic64_read(&log->l_last_sync_lsn);
+	trace_xfs_log_assign_tail_lsn(log, tail_lsn);
 	atomic64_set(&log->l_tail_lsn, tail_lsn);
 	return tail_lsn;
 }
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 47910e6..f195476 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -31,8 +31,8 @@ struct xfs_da_args;
 struct xfs_da_node_entry;
 struct xfs_dquot;
 struct xfs_log_item;
-struct xlog_ticket;
 struct xlog;
+struct xlog_ticket;
 struct xlog_recover;
 struct xlog_recover_item;
 struct xfs_buf_log_format;
@@ -938,6 +938,63 @@ DEFINE_LOG_ITEM_EVENT(xfs_ail_pinned);
 DEFINE_LOG_ITEM_EVENT(xfs_ail_locked);
 DEFINE_LOG_ITEM_EVENT(xfs_ail_flushing);
 
+DECLARE_EVENT_CLASS(xfs_ail_class,
+	TP_PROTO(struct xfs_log_item *lip, xfs_lsn_t old_lsn, xfs_lsn_t new_lsn),
+	TP_ARGS(lip, old_lsn, new_lsn),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(void *, lip)
+		__field(uint, type)
+		__field(uint, flags)
+		__field(xfs_lsn_t, old_lsn)
+		__field(xfs_lsn_t, new_lsn)
+	),
+	TP_fast_assign(
+		__entry->dev = lip->li_mountp->m_super->s_dev;
+		__entry->lip = lip;
+		__entry->type = lip->li_type;
+		__entry->flags = lip->li_flags;
+		__entry->old_lsn = old_lsn;
+		__entry->new_lsn = new_lsn;
+	),
+	TP_printk("dev %d:%d lip 0x%p old lsn %d/%d new lsn %d/%d type %s flags %s",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->lip,
+		  CYCLE_LSN(__entry->old_lsn), BLOCK_LSN(__entry->old_lsn),
+		  CYCLE_LSN(__entry->new_lsn), BLOCK_LSN(__entry->new_lsn),
+		  __print_symbolic(__entry->type, XFS_LI_TYPE_DESC),
+		  __print_flags(__entry->flags, "|", XFS_LI_FLAGS))
+)
+
+#define DEFINE_AIL_EVENT(name) \
+DEFINE_EVENT(xfs_ail_class, name, \
+	TP_PROTO(struct xfs_log_item *lip, xfs_lsn_t old_lsn, xfs_lsn_t new_lsn), \
+	TP_ARGS(lip, old_lsn, new_lsn))
+DEFINE_AIL_EVENT(xfs_ail_insert);
+DEFINE_AIL_EVENT(xfs_ail_move);
+DEFINE_AIL_EVENT(xfs_ail_delete);
+
+TRACE_EVENT(xfs_log_assign_tail_lsn,
+	TP_PROTO(struct xlog *log, xfs_lsn_t new_lsn),
+	TP_ARGS(log, new_lsn),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_lsn_t, new_lsn)
+		__field(xfs_lsn_t, old_lsn)
+		__field(xfs_lsn_t, last_sync_lsn)
+	),
+	TP_fast_assign(
+		__entry->dev = log->l_mp->m_super->s_dev;
+		__entry->new_lsn = new_lsn;
+		__entry->old_lsn = atomic64_read(&log->l_tail_lsn);
+		__entry->last_sync_lsn = atomic64_read(&log->l_last_sync_lsn);
+	),
+	TP_printk("dev %d:%d new tail lsn %d/%d, old lsn %d/%d, last sync %d/%d",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  CYCLE_LSN(__entry->new_lsn), BLOCK_LSN(__entry->new_lsn),
+		  CYCLE_LSN(__entry->old_lsn), BLOCK_LSN(__entry->old_lsn),
+		  CYCLE_LSN(__entry->last_sync_lsn), BLOCK_LSN(__entry->last_sync_lsn))
+)
 
 DECLARE_EVENT_CLASS(xfs_file_class,
 	TP_PROTO(struct xfs_inode *ip, size_t count, loff_t offset, int flags),
diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
index 4b47cfe..a728735 100644
--- a/fs/xfs/xfs_trans_ail.c
+++ b/fs/xfs/xfs_trans_ail.c
@@ -659,11 +659,13 @@ xfs_trans_ail_update_bulk(
 			if (XFS_LSN_CMP(lsn, lip->li_lsn) <= 0)
 				continue;
 
+			trace_xfs_ail_move(lip, lip->li_lsn, lsn);
 			xfs_ail_delete(ailp, lip);
 			if (mlip == lip)
 				mlip_changed = 1;
 		} else {
 			lip->li_flags |= XFS_LI_IN_AIL;
+			trace_xfs_ail_insert(lip, 0, lsn);
 		}
 		lip->li_lsn = lsn;
 		list_add(&lip->li_ail, &tmp);
@@ -732,6 +734,7 @@ xfs_trans_ail_delete_bulk(
 			return;
 		}
 
+		trace_xfs_ail_delete(lip, mlip->li_lsn, lip->li_lsn);
 		xfs_ail_delete(ailp, lip);
 		lip->li_flags &= ~XFS_LI_IN_AIL;
 		lip->li_lsn = 0;
-- 
1.8.4.rc3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
