Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 7B7517F7E
	for <xfs@oss.sgi.com>; Fri,  7 Aug 2015 16:15:36 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 2394FAC007
	for <xfs@oss.sgi.com>; Fri,  7 Aug 2015 14:15:32 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id dAXJCgyHkOSK99t3 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 07 Aug 2015 14:15:32 -0700 (PDT)
Received: from int-mx14.intmail.prod.int.phx2.redhat.com
	(int-mx14.intmail.prod.int.phx2.redhat.com [10.5.11.27])
	by mx1.redhat.com (Postfix) with ESMTPS id ED7E335BA49
	for <xfs@oss.sgi.com>; Fri,  7 Aug 2015 21:15:31 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-76.bos.redhat.com [10.18.41.76])
	by int-mx14.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id t77LFVTg023169
	for <xfs@oss.sgi.com>; Fri, 7 Aug 2015 17:15:31 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v2 07/12] xfs: icreate log item recovery and cancellation
	tracepoints
Date: Fri,  7 Aug 2015 17:15:23 -0400
Message-Id: <1438982128-38618-8-git-send-email-bfoster@redhat.com>
In-Reply-To: <1438982128-38618-1-git-send-email-bfoster@redhat.com>
References: <1438982128-38618-1-git-send-email-bfoster@redhat.com>
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

Various log items have recovery tracepoints to identify whether a
particular log item is recovered or cancelled. Add the equivalent
tracepoints for the icreate transaction.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_log_recover.c |  5 ++++-
 fs/xfs/xfs_trace.h       | 34 ++++++++++++++++++++++++++++++++++
 2 files changed, 38 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index c1c4de2..2ff62d3 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -3105,9 +3105,12 @@ xlog_recover_do_icreate_pass2(
 	 * done easily.
 	 */
 	if (xlog_check_buffer_cancelled(log,
-			XFS_AGB_TO_DADDR(mp, agno, agbno), length, 0))
+			XFS_AGB_TO_DADDR(mp, agno, agbno), length, 0)) {
+		trace_xfs_log_recover_icreate_cancel(log, icl);
 		return 0;
+	}
 
+	trace_xfs_log_recover_icreate_recover(log, icl);
 	xfs_ialloc_inode_init(mp, NULL, buffer_list, count, agno, agbno, length,
 			      be32_to_cpu(icl->icl_gen));
 	return 0;
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 8d916d3..9aeeb21 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -2089,6 +2089,40 @@ DEFINE_LOG_RECOVER_INO_ITEM(xfs_log_recover_inode_recover);
 DEFINE_LOG_RECOVER_INO_ITEM(xfs_log_recover_inode_cancel);
 DEFINE_LOG_RECOVER_INO_ITEM(xfs_log_recover_inode_skip);
 
+DECLARE_EVENT_CLASS(xfs_log_recover_icreate_item_class,
+	TP_PROTO(struct xlog *log, struct xfs_icreate_log *in_f),
+	TP_ARGS(log, in_f),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_agnumber_t, agno)
+		__field(xfs_agblock_t, agbno)
+		__field(unsigned int, count)
+		__field(unsigned int, isize)
+		__field(xfs_agblock_t, length)
+		__field(unsigned int, gen)
+	),
+	TP_fast_assign(
+		__entry->dev = log->l_mp->m_super->s_dev;
+		__entry->agno = be32_to_cpu(in_f->icl_ag);
+		__entry->agbno = be32_to_cpu(in_f->icl_agbno);
+		__entry->count = be32_to_cpu(in_f->icl_count);
+		__entry->isize = be32_to_cpu(in_f->icl_isize);
+		__entry->length = be32_to_cpu(in_f->icl_length);
+		__entry->gen = be32_to_cpu(in_f->icl_gen);
+	),
+	TP_printk("dev %d:%d agno %u agbno %u count %u isize %u length %u "
+		  "gen %u", MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->agno, __entry->agbno, __entry->count, __entry->isize,
+		  __entry->length, __entry->gen)
+)
+#define DEFINE_LOG_RECOVER_ICREATE_ITEM(name) \
+DEFINE_EVENT(xfs_log_recover_icreate_item_class, name, \
+	TP_PROTO(struct xlog *log, struct xfs_icreate_log *in_f), \
+	TP_ARGS(log, in_f))
+
+DEFINE_LOG_RECOVER_ICREATE_ITEM(xfs_log_recover_icreate_cancel);
+DEFINE_LOG_RECOVER_ICREATE_ITEM(xfs_log_recover_icreate_recover);
+
 DECLARE_EVENT_CLASS(xfs_discard_class,
 	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno,
 		 xfs_agblock_t agbno, xfs_extlen_t len),
-- 
2.1.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
