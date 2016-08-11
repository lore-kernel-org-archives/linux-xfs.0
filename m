Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 8F8BF7CB0
	for <xfs@oss.sgi.com>; Thu, 11 Aug 2016 12:11:14 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 5BB66304043
	for <xfs@oss.sgi.com>; Thu, 11 Aug 2016 10:11:11 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id xIBTboTwWsXtQbNE (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 11 Aug 2016 10:11:10 -0700 (PDT)
Received: from int-mx14.intmail.prod.int.phx2.redhat.com
	(int-mx14.intmail.prod.int.phx2.redhat.com [10.5.11.27])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.redhat.com (Postfix) with ESMTPS id C5AE346211
	for <xfs@oss.sgi.com>; Thu, 11 Aug 2016 17:11:09 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-69.bos.redhat.com [10.18.41.69])
	by int-mx14.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id u7BHB92X005923
	for <xfs@oss.sgi.com>; Thu, 11 Aug 2016 13:11:09 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 5/5] xfs: log recovery tracepoints to track current lsn and
	buffer submission
Date: Thu, 11 Aug 2016 13:11:07 -0400
Message-Id: <1470935467-52772-6-git-send-email-bfoster@redhat.com>
In-Reply-To: <1470935467-52772-1-git-send-email-bfoster@redhat.com>
References: <1470935467-52772-1-git-send-email-bfoster@redhat.com>
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

Log recovery has particular rules around buffer submission along with
tricky corner cases where independent transactions can share an LSN. As
such, it can be difficult to follow when/why buffers are submitted
during recovery.

Add a couple tracepoints to post the current LSN of a record when a new
record is being processed and when a buffer is being skipped due to LSN
ordering. Also, update the recover item class to include the LSN of the
current transaction for the item being processed.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_log_recover.c |  2 ++
 fs/xfs/xfs_trace.h       | 31 +++++++++++++++++++++++++++++--
 2 files changed, 31 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 0c0b743..ad63ec0 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2801,6 +2801,7 @@ xlog_recover_buffer_pass2(
 	 */
 	lsn = xlog_recover_get_buf_lsn(mp, bp);
 	if (lsn && lsn != -1 && XFS_LSN_CMP(lsn, current_lsn) >= 0) {
+		trace_xfs_log_recover_buf_skip(log, buf_f);
 		xlog_recover_validate_buf_type(mp, bp, buf_f, NULLCOMMITLSN);
 		goto out_release;
 	}
@@ -4316,6 +4317,7 @@ xlog_recover_process_data(
 	if (xlog_header_check_recover(log->l_mp, rhead))
 		return -EIO;
 
+	trace_xfs_log_recover_record(log, rhead, pass);
 	while ((dp < end) && num_logops) {
 
 		ohead = (struct xlog_op_header *)dp;
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 551b7e2..d5a8abd 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -1985,6 +1985,29 @@ DEFINE_EVENT(xfs_swap_extent_class, name, \
 DEFINE_SWAPEXT_EVENT(xfs_swap_extent_before);
 DEFINE_SWAPEXT_EVENT(xfs_swap_extent_after);
 
+TRACE_EVENT(xfs_log_recover_record,
+	TP_PROTO(struct xlog *log, struct xlog_rec_header *rhead, int pass),
+	TP_ARGS(log, rhead, pass),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_lsn_t, lsn)
+		__field(int, len)
+		__field(int, num_logops)
+		__field(int, pass)
+	),
+	TP_fast_assign(
+		__entry->dev = log->l_mp->m_super->s_dev;
+		__entry->lsn = be64_to_cpu(rhead->h_lsn);
+		__entry->len = be32_to_cpu(rhead->h_len);
+		__entry->num_logops = be32_to_cpu(rhead->h_num_logops);
+		__entry->pass = pass;
+	),
+	TP_printk("dev %d:%d lsn 0x%llx len 0x%x num_logops 0x%x pass %d",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->lsn, __entry->len, __entry->num_logops,
+		   __entry->pass)
+)
+
 DECLARE_EVENT_CLASS(xfs_log_recover_item_class,
 	TP_PROTO(struct xlog *log, struct xlog_recover *trans,
 		struct xlog_recover_item *item, int pass),
@@ -1993,6 +2016,7 @@ DECLARE_EVENT_CLASS(xfs_log_recover_item_class,
 		__field(dev_t, dev)
 		__field(unsigned long, item)
 		__field(xlog_tid_t, tid)
+		__field(xfs_lsn_t, lsn)
 		__field(int, type)
 		__field(int, pass)
 		__field(int, count)
@@ -2002,15 +2026,17 @@ DECLARE_EVENT_CLASS(xfs_log_recover_item_class,
 		__entry->dev = log->l_mp->m_super->s_dev;
 		__entry->item = (unsigned long)item;
 		__entry->tid = trans->r_log_tid;
+		__entry->lsn = trans->r_lsn;
 		__entry->type = ITEM_TYPE(item);
 		__entry->pass = pass;
 		__entry->count = item->ri_cnt;
 		__entry->total = item->ri_total;
 	),
-	TP_printk("dev %d:%d trans 0x%x, pass %d, item 0x%p, item type %s "
-		  "item region count/total %d/%d",
+	TP_printk("dev %d:%d tid 0x%x lsn 0x%llx, pass %d, item 0x%p, "
+		  "item type %s item region count/total %d/%d",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->tid,
+		  __entry->lsn,
 		  __entry->pass,
 		  (void *)__entry->item,
 		  __print_symbolic(__entry->type, XFS_LI_TYPE_DESC),
@@ -2069,6 +2095,7 @@ DEFINE_LOG_RECOVER_BUF_ITEM(xfs_log_recover_buf_cancel);
 DEFINE_LOG_RECOVER_BUF_ITEM(xfs_log_recover_buf_cancel_add);
 DEFINE_LOG_RECOVER_BUF_ITEM(xfs_log_recover_buf_cancel_ref_inc);
 DEFINE_LOG_RECOVER_BUF_ITEM(xfs_log_recover_buf_recover);
+DEFINE_LOG_RECOVER_BUF_ITEM(xfs_log_recover_buf_skip);
 DEFINE_LOG_RECOVER_BUF_ITEM(xfs_log_recover_buf_inode_buf);
 DEFINE_LOG_RECOVER_BUF_ITEM(xfs_log_recover_buf_reg_buf);
 DEFINE_LOG_RECOVER_BUF_ITEM(xfs_log_recover_buf_dquot_buf);
-- 
2.5.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
