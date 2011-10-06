Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p96IZqxR195427 for <xfs@oss.sgi.com>; Thu, 6 Oct 2011 13:35:52 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 44DAD1C6D13D
	for <xfs@oss.sgi.com>; Thu,  6 Oct 2011 11:35:50 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	KFZPMHBFVUoQDrNb for <xfs@oss.sgi.com>;
	Thu, 06 Oct 2011 11:35:50 -0700 (PDT)
Message-Id: <20111006183549.961878101@bombadil.infradead.org>
Date: Thu, 06 Oct 2011 14:33:01 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 4/4] xfs: add AIL pushing tracepoints
References: <20111006183257.036884724@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-ail-tracing
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
Cc: Stefan Priebe <s.priebe@profihost.ag>

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/xfs_trace.h
===================================================================
--- xfs.orig/fs/xfs/xfs_trace.h	2011-10-06 14:10:53.710918092 -0400
+++ xfs/fs/xfs/xfs_trace.h	2011-10-06 14:26:25.274918999 -0400
@@ -30,6 +30,7 @@ struct xfs_buf_log_item;
 struct xfs_da_args;
 struct xfs_da_node_entry;
 struct xfs_dquot;
+struct xfs_log_item;
 struct xlog_ticket;
 struct log;
 struct xlog_recover;
@@ -853,6 +854,42 @@ DEFINE_LOGGRANT_EVENT(xfs_log_ungrant_en
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
Index: xfs/fs/xfs/xfs_trans_ail.c
===================================================================
--- xfs.orig/fs/xfs/xfs_trans_ail.c	2011-10-06 14:22:18.955418059 -0400
+++ xfs/fs/xfs/xfs_trans_ail.c	2011-10-06 14:26:25.274918999 -0400
@@ -26,6 +26,7 @@
 #include "xfs_ag.h"
 #include "xfs_mount.h"
 #include "xfs_trans_priv.h"
+#include "xfs_trace.h"
 #include "xfs_error.h"
 
 #ifdef DEBUG
@@ -425,14 +426,18 @@ xfsaild_push(
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
@@ -443,12 +448,16 @@ xfsaild_push(
 
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
+
 			stuck++;
 			break;
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
