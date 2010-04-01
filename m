Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o31CdtII120115 for <xfs@oss.sgi.com>; Thu, 1 Apr 2010 07:39:55 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EC54E1DCA1F6
	for <xfs@oss.sgi.com>; Thu,  1 Apr 2010 05:41:39 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail18.adl2.internode.on.net
	[150.101.137.103]) by cuda.sgi.com with ESMTP id
	31hywTMaOARXmd2z for <xfs@oss.sgi.com>;
	Thu, 01 Apr 2010 05:41:39 -0700 (PDT)
Received: from dastard (unverified [121.44.229.111])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	19158694-1927428
	for <xfs@oss.sgi.com>; Thu, 01 Apr 2010 23:11:38 +1030 (CDT)
Received: from disturbed ([192.168.1.9]) by dastard with esmtp (Exim 4.71)
	(envelope-from <dave@fromorbit.com>) id 1NxJiK-0002Hi-Lg
	for xfs@oss.sgi.com; Thu, 01 Apr 2010 23:41:36 +1100
Received: from dave by disturbed with local (Exim 4.71)
	(envelope-from <dave@disturbed.disaster>) id 1NxJiK-0001ne-Bu
	for xfs@oss.sgi.com; Thu, 01 Apr 2010 23:41:36 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 4/8] xfs: add log item recovery tracing
Date: Thu,  1 Apr 2010 23:41:27 +1100
Message-Id: <1270125691-29266-5-git-send-email-david@fromorbit.com>
In-Reply-To: <1270125691-29266-1-git-send-email-david@fromorbit.com>
References: <1270125691-29266-1-git-send-email-david@fromorbit.com>
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

From: Dave Chinner <dchinner@redhat.com>

Currently there is no tracing in log recovery, so it is difficult to
determine what is going on when something goes wrong.

Add tracing for log item recovery to provide visibility into the log
recovery process. The tracing added shows regions being extracted
from the log transactions and added to the transaction hash forming
recovery items, followed by the reordering, cancelling and finally
recovery of the items.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/linux-2.6/xfs_trace.c |    3 +
 fs/xfs/linux-2.6/xfs_trace.h |  147 ++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_buf_item.h        |    2 +-
 fs/xfs/xfs_log_recover.c     |   44 ++++++++++--
 4 files changed, 187 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_trace.c b/fs/xfs/linux-2.6/xfs_trace.c
index 5a10760..2a46058 100644
--- a/fs/xfs/linux-2.6/xfs_trace.c
+++ b/fs/xfs/linux-2.6/xfs_trace.c
@@ -50,6 +50,9 @@
 #include "xfs_aops.h"
 #include "quota/xfs_dquot_item.h"
 #include "quota/xfs_dquot.h"
+#include "xfs_log_recover.h"
+#include "xfs_buf_item.h"
+#include "xfs_inode_item.h"
 
 /*
  * We include this last to have the helpers above available for the trace
diff --git a/fs/xfs/linux-2.6/xfs_trace.h b/fs/xfs/linux-2.6/xfs_trace.h
index 6537185..cde032b 100644
--- a/fs/xfs/linux-2.6/xfs_trace.h
+++ b/fs/xfs/linux-2.6/xfs_trace.h
@@ -32,6 +32,10 @@ struct xfs_da_node_entry;
 struct xfs_dquot;
 struct xlog_ticket;
 struct log;
+struct xlog_recover;
+struct xlog_recover_item;
+struct xfs_buf_log_format;
+struct xfs_inode_log_format;
 
 DECLARE_EVENT_CLASS(xfs_attr_list_class,
 	TP_PROTO(struct xfs_attr_list_context *ctx),
@@ -1502,6 +1506,149 @@ DEFINE_EVENT(xfs_swap_extent_class, name, \
 DEFINE_SWAPEXT_EVENT(xfs_swap_extent_before);
 DEFINE_SWAPEXT_EVENT(xfs_swap_extent_after);
 
+#define XFS_LOG_ITEM_TYPE \
+	{ 0x1236,	"XFS_LI_EFI" }, \
+	{ 0x1237,	"XFS_LI_EFD" }, \
+	{ 0x1238,	"XFS_LI_IUNLINK" }, \
+	{ 0x123b,	"XFS_LI_INODE" }, \
+	{ 0x123c,	"XFS_LI_BUF" }, \
+	{ 0x123d,	"XFS_LI_DQUOT" }, \
+	{ 0x123e,	"XFS_LI_QUOTAOFF" }
+
+DECLARE_EVENT_CLASS(xfs_log_recover_item_class,
+	TP_PROTO(struct log *log, struct xlog_recover *trans,
+		struct xlog_recover_item *item, int pass),
+	TP_ARGS(log, trans, item, pass),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(unsigned long, item)
+		__field(xlog_tid_t, tid)
+		__field(int, type)
+		__field(int, pass)
+		__field(int, count)
+		__field(int, total)
+	),
+	TP_fast_assign(
+		__entry->dev = log->l_mp->m_super->s_dev;
+		__entry->item = (unsigned long)item;
+		__entry->tid = trans->r_log_tid;
+		__entry->type = ITEM_TYPE(item);
+		__entry->pass = pass;
+		__entry->count = item->ri_cnt;
+		__entry->total = item->ri_total;
+	),
+	TP_printk("dev %d:%d trans 0x%x, pass %d, item 0x%p, item type %s "
+		  "item region count/total %d/%d",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->tid,
+		  __entry->pass,
+		  (void *)__entry->item,
+		  __print_symbolic(__entry->type, XFS_LOG_ITEM_TYPE),
+		  __entry->count,
+		  __entry->total)
+)
+
+#define DEFINE_LOG_RECOVER_ITEM(name) \
+DEFINE_EVENT(xfs_log_recover_item_class, name, \
+	TP_PROTO(struct log *log, struct xlog_recover *trans, \
+		struct xlog_recover_item *item, int pass), \
+	TP_ARGS(log, trans, item, pass))
+
+DEFINE_LOG_RECOVER_ITEM(xfs_log_recover_item_add);
+DEFINE_LOG_RECOVER_ITEM(xfs_log_recover_item_add_cont);
+DEFINE_LOG_RECOVER_ITEM(xfs_log_recover_item_reorder_head);
+DEFINE_LOG_RECOVER_ITEM(xfs_log_recover_item_reorder_tail);
+DEFINE_LOG_RECOVER_ITEM(xfs_log_recover_item_recover);
+
+DECLARE_EVENT_CLASS(xfs_log_recover_buf_item_class,
+	TP_PROTO(struct log *log, struct xfs_buf_log_format *buf_f),
+	TP_ARGS(log, buf_f),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(__int64_t, blkno)
+		__field(unsigned short, len)
+		__field(unsigned short, flags)
+		__field(unsigned short, size)
+		__field(unsigned int, map_size)
+	),
+	TP_fast_assign(
+		__entry->dev = log->l_mp->m_super->s_dev;
+		__entry->blkno = buf_f->blf_blkno;
+		__entry->len = buf_f->blf_len;
+		__entry->flags = buf_f->blf_flags;
+		__entry->size = buf_f->blf_size;
+		__entry->map_size = buf_f->blf_map_size;
+	),
+	TP_printk("dev %d:%d blkno 0x%llx, len %u, flags 0x%x, size %d, "
+			"map_size %d",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->blkno,
+		  __entry->len,
+		  __entry->flags,
+		  __entry->size,
+		  __entry->map_size)
+)
+
+#define DEFINE_LOG_RECOVER_BUF_ITEM(name) \
+DEFINE_EVENT(xfs_log_recover_buf_item_class, name, \
+	TP_PROTO(struct log *log, struct xfs_buf_log_format *buf_f), \
+	TP_ARGS(log, buf_f))
+
+DEFINE_LOG_RECOVER_BUF_ITEM(xfs_log_recover_buf_not_cancel);
+DEFINE_LOG_RECOVER_BUF_ITEM(xfs_log_recover_buf_cancel);
+DEFINE_LOG_RECOVER_BUF_ITEM(xfs_log_recover_buf_cancel_add);
+DEFINE_LOG_RECOVER_BUF_ITEM(xfs_log_recover_buf_cancel_ref_inc);
+DEFINE_LOG_RECOVER_BUF_ITEM(xfs_log_recover_buf_recover);
+DEFINE_LOG_RECOVER_BUF_ITEM(xfs_log_recover_buf_inode_buf);
+DEFINE_LOG_RECOVER_BUF_ITEM(xfs_log_recover_buf_reg_buf);
+DEFINE_LOG_RECOVER_BUF_ITEM(xfs_log_recover_buf_dquot_buf);
+
+DECLARE_EVENT_CLASS(xfs_log_recover_ino_item_class,
+	TP_PROTO(struct log *log, struct xfs_inode_log_format *in_f),
+	TP_ARGS(log, in_f),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_ino_t, ino)
+		__field(unsigned short, size)
+		__field(int, fields)
+		__field(unsigned short, asize)
+		__field(unsigned short, dsize)
+		__field(__int64_t, blkno)
+		__field(int, len)
+		__field(int, boffset)
+	),
+	TP_fast_assign(
+		__entry->dev = log->l_mp->m_super->s_dev;
+		__entry->ino = in_f->ilf_ino;
+		__entry->size = in_f->ilf_size;
+		__entry->fields = in_f->ilf_fields;
+		__entry->asize = in_f->ilf_asize;
+		__entry->dsize = in_f->ilf_dsize;
+		__entry->blkno = in_f->ilf_blkno;
+		__entry->len = in_f->ilf_len;
+		__entry->boffset = in_f->ilf_boffset;
+	),
+	TP_printk("dev %d:%d ino 0x%llx, size %u, fields 0x%x, asize %d, "
+			"dsize %d, blkno 0x%llx, len %d, boffset %d",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->ino,
+		  __entry->size,
+		  __entry->fields,
+		  __entry->asize,
+		  __entry->dsize,
+		  __entry->blkno,
+		  __entry->len,
+		  __entry->boffset)
+)
+#define DEFINE_LOG_RECOVER_INO_ITEM(name) \
+DEFINE_EVENT(xfs_log_recover_ino_item_class, name, \
+	TP_PROTO(struct log *log, struct xfs_inode_log_format *in_f), \
+	TP_ARGS(log, in_f))
+
+DEFINE_LOG_RECOVER_INO_ITEM(xfs_log_recover_inode_recover);
+DEFINE_LOG_RECOVER_INO_ITEM(xfs_log_recover_inode_cancel);
+DEFINE_LOG_RECOVER_INO_ITEM(xfs_log_recover_inode_skip);
+
 #endif /* _TRACE_XFS_H */
 
 #undef TRACE_INCLUDE_PATH
diff --git a/fs/xfs/xfs_buf_item.h b/fs/xfs/xfs_buf_item.h
index 217f34a..df44545 100644
--- a/fs/xfs/xfs_buf_item.h
+++ b/fs/xfs/xfs_buf_item.h
@@ -26,7 +26,7 @@ extern kmem_zone_t	*xfs_buf_item_zone;
  * have been logged.
  * For 6.2 and beyond, this is XFS_LI_BUF.  We use this to log everything.
  */
-typedef struct xfs_buf_log_format_t {
+typedef struct xfs_buf_log_format {
 	unsigned short	blf_type;	/* buf log item type indicator */
 	unsigned short	blf_size;	/* size of this item */
 	ushort		blf_flags;	/* misc state */
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 22e6efd..f21eb8a 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -1408,6 +1408,7 @@ xlog_recover_add_item(
 
 STATIC int
 xlog_recover_add_to_cont_trans(
+	struct log		*log,
 	xlog_recover_t		*trans,
 	xfs_caddr_t		dp,
 	int			len)
@@ -1434,6 +1435,7 @@ xlog_recover_add_to_cont_trans(
 	memcpy(&ptr[old_len], dp, len); /* d, s, l */
 	item->ri_buf[item->ri_cnt-1].i_len += len;
 	item->ri_buf[item->ri_cnt-1].i_addr = ptr;
+	trace_xfs_log_recover_item_add_cont(log, trans, item, 0);
 	return 0;
 }
 
@@ -1452,6 +1454,7 @@ xlog_recover_add_to_cont_trans(
  */
 STATIC int
 xlog_recover_add_to_trans(
+	struct log		*log,
 	xlog_recover_t		*trans,
 	xfs_caddr_t		dp,
 	int			len)
@@ -1510,6 +1513,7 @@ xlog_recover_add_to_trans(
 	item->ri_buf[item->ri_cnt].i_addr = ptr;
 	item->ri_buf[item->ri_cnt].i_len  = len;
 	item->ri_cnt++;
+	trace_xfs_log_recover_item_add(log, trans, item, 0);
 	return 0;
 }
 
@@ -1521,7 +1525,9 @@ xlog_recover_add_to_trans(
  */
 STATIC int
 xlog_recover_reorder_trans(
-	xlog_recover_t		*trans)
+	struct log		*log,
+	xlog_recover_t		*trans,
+	int			pass)
 {
 	xlog_recover_item_t	*item, *n;
 	LIST_HEAD(sort_list);
@@ -1535,6 +1541,8 @@ xlog_recover_reorder_trans(
 		switch (ITEM_TYPE(item)) {
 		case XFS_LI_BUF:
 			if (!(buf_f->blf_flags & XFS_BLI_CANCEL)) {
+				trace_xfs_log_recover_item_reorder_head(log,
+							trans, item, pass);
 				list_move(&item->ri_list, &trans->r_itemq);
 				break;
 			}
@@ -1543,6 +1551,8 @@ xlog_recover_reorder_trans(
 		case XFS_LI_QUOTAOFF:
 		case XFS_LI_EFD:
 		case XFS_LI_EFI:
+			trace_xfs_log_recover_item_reorder_tail(log,
+							trans, item, pass);
 			list_move_tail(&item->ri_list, &trans->r_itemq);
 			break;
 		default:
@@ -1592,8 +1602,10 @@ xlog_recover_do_buffer_pass1(
 	/*
 	 * If this isn't a cancel buffer item, then just return.
 	 */
-	if (!(flags & XFS_BLI_CANCEL))
+	if (!(flags & XFS_BLI_CANCEL)) {
+		trace_xfs_log_recover_buf_not_cancel(log, buf_f);
 		return;
+	}
 
 	/*
 	 * Insert an xfs_buf_cancel record into the hash table of
@@ -1627,6 +1639,7 @@ xlog_recover_do_buffer_pass1(
 	while (nextp != NULL) {
 		if (nextp->bc_blkno == blkno && nextp->bc_len == len) {
 			nextp->bc_refcount++;
+			trace_xfs_log_recover_buf_cancel_ref_inc(log, buf_f);
 			return;
 		}
 		prevp = nextp;
@@ -1640,6 +1653,7 @@ xlog_recover_do_buffer_pass1(
 	bcp->bc_refcount = 1;
 	bcp->bc_next = NULL;
 	prevp->bc_next = bcp;
+	trace_xfs_log_recover_buf_cancel_add(log, buf_f);
 }
 
 /*
@@ -1779,6 +1793,8 @@ xlog_recover_do_inode_buffer(
 	unsigned int		*data_map = NULL;
 	unsigned int		map_size = 0;
 
+	trace_xfs_log_recover_buf_inode_buf(mp->m_log, buf_f);
+
 	switch (buf_f->blf_type) {
 	case XFS_LI_BUF:
 		data_map = buf_f->blf_data_map;
@@ -1874,6 +1890,7 @@ xlog_recover_do_inode_buffer(
 /*ARGSUSED*/
 STATIC void
 xlog_recover_do_reg_buffer(
+	struct xfs_mount	*mp,
 	xlog_recover_item_t	*item,
 	xfs_buf_t		*bp,
 	xfs_buf_log_format_t	*buf_f)
@@ -1885,6 +1902,8 @@ xlog_recover_do_reg_buffer(
 	unsigned int		map_size = 0;
 	int                     error;
 
+	trace_xfs_log_recover_buf_reg_buf(mp->m_log, buf_f);
+
 	switch (buf_f->blf_type) {
 	case XFS_LI_BUF:
 		data_map = buf_f->blf_data_map;
@@ -2083,6 +2102,8 @@ xlog_recover_do_dquot_buffer(
 {
 	uint			type;
 
+	trace_xfs_log_recover_buf_dquot_buf(log, buf_f);
+
 	/*
 	 * Filesystems are required to send in quota flags at mount time.
 	 */
@@ -2103,7 +2124,7 @@ xlog_recover_do_dquot_buffer(
 	if (log->l_quotaoffs_flag & type)
 		return;
 
-	xlog_recover_do_reg_buffer(item, bp, buf_f);
+	xlog_recover_do_reg_buffer(mp, item, bp, buf_f);
 }
 
 /*
@@ -2164,9 +2185,11 @@ xlog_recover_do_buffer_trans(
 		 */
 		cancel = xlog_recover_do_buffer_pass2(log, buf_f);
 		if (cancel) {
+			trace_xfs_log_recover_buf_cancel(log, buf_f);
 			return 0;
 		}
 	}
+	trace_xfs_log_recover_buf_recover(log, buf_f);
 	switch (buf_f->blf_type) {
 	case XFS_LI_BUF:
 		blkno = buf_f->blf_blkno;
@@ -2204,7 +2227,7 @@ xlog_recover_do_buffer_trans(
 		  (XFS_BLI_UDQUOT_BUF|XFS_BLI_PDQUOT_BUF|XFS_BLI_GDQUOT_BUF)) {
 		xlog_recover_do_dquot_buffer(mp, log, item, bp, buf_f);
 	} else {
-		xlog_recover_do_reg_buffer(item, bp, buf_f);
+		xlog_recover_do_reg_buffer(mp, item, bp, buf_f);
 	}
 	if (error)
 		return XFS_ERROR(error);
@@ -2284,8 +2307,10 @@ xlog_recover_do_inode_trans(
 	if (xlog_check_buffer_cancelled(log, in_f->ilf_blkno,
 					in_f->ilf_len, 0)) {
 		error = 0;
+		trace_xfs_log_recover_inode_cancel(log, in_f);
 		goto error;
 	}
+	trace_xfs_log_recover_inode_recover(log, in_f);
 
 	bp = xfs_buf_read(mp->m_ddev_targp, in_f->ilf_blkno, in_f->ilf_len,
 			  XBF_LOCK);
@@ -2337,6 +2362,7 @@ xlog_recover_do_inode_trans(
 			/* do nothing */
 		} else {
 			xfs_buf_relse(bp);
+			trace_xfs_log_recover_inode_skip(log, in_f);
 			error = 0;
 			goto error;
 		}
@@ -2758,11 +2784,12 @@ xlog_recover_do_trans(
 	int			error = 0;
 	xlog_recover_item_t	*item;
 
-	error = xlog_recover_reorder_trans(trans);
+	error = xlog_recover_reorder_trans(log, trans, pass);
 	if (error)
 		return error;
 
 	list_for_each_entry(item, &trans->r_itemq, ri_list) {
+		trace_xfs_log_recover_item_recover(log, trans, item, pass);
 		switch (ITEM_TYPE(item)) {
 		case XFS_LI_BUF:
 			error = xlog_recover_do_buffer_trans(log, item, pass);
@@ -2919,8 +2946,9 @@ xlog_recover_process_data(
 				error = xlog_recover_unmount_trans(trans);
 				break;
 			case XLOG_WAS_CONT_TRANS:
-				error = xlog_recover_add_to_cont_trans(trans,
-						dp, be32_to_cpu(ohead->oh_len));
+				error = xlog_recover_add_to_cont_trans(log,
+						trans, dp,
+						be32_to_cpu(ohead->oh_len));
 				break;
 			case XLOG_START_TRANS:
 				xlog_warn(
@@ -2930,7 +2958,7 @@ xlog_recover_process_data(
 				break;
 			case 0:
 			case XLOG_CONTINUE_TRANS:
-				error = xlog_recover_add_to_trans(trans,
+				error = xlog_recover_add_to_trans(log, trans,
 						dp, be32_to_cpu(ohead->oh_len));
 				break;
 			default:
-- 
1.6.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
