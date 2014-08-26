Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id F24417F54
	for <xfs@oss.sgi.com>; Mon, 25 Aug 2014 20:21:54 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E0DDC304053
	for <xfs@oss.sgi.com>; Mon, 25 Aug 2014 18:21:54 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	zmHfAPggLaezdGOf for <xfs@oss.sgi.com>;
	Mon, 25 Aug 2014 18:21:52 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1XM5SC-0000KD-75
	for xfs@oss.sgi.com; Tue, 26 Aug 2014 11:21:44 +1000
Received: from dave by disappointment with local (Exim 4.82_1-5b7a7c0-XX)
	(envelope-from <dave@disappointment.disaster>) id 1XM5SC-0002US-6S
	for xfs@oss.sgi.com; Tue, 26 Aug 2014 11:21:44 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 4/4] xfs: reorganise transaction recovery item code
Date: Tue, 26 Aug 2014 11:21:41 +1000
Message-Id: <1409016101-9511-5-git-send-email-david@fromorbit.com>
In-Reply-To: <1409016101-9511-1-git-send-email-david@fromorbit.com>
References: <1409016101-9511-1-git-send-email-david@fromorbit.com>
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

The code for managing transactions anf the items for recovery is
spread across 3 different locations in the file. Move them all
together so that it is easy to read the code without needing to jump
long distances in the file.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_log_recover.c | 358 +++++++++++++++++++++++------------------------
 1 file changed, 179 insertions(+), 179 deletions(-)

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 23895d5..b36d96a 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -1441,160 +1441,6 @@ xlog_clear_stale_blocks(
  ******************************************************************************
  */
 
-STATIC xlog_recover_t *
-xlog_recover_find_tid(
-	struct hlist_head	*head,
-	xlog_tid_t		tid)
-{
-	xlog_recover_t		*trans;
-
-	hlist_for_each_entry(trans, head, r_list) {
-		if (trans->r_log_tid == tid)
-			return trans;
-	}
-	return NULL;
-}
-
-STATIC void
-xlog_recover_new_tid(
-	struct hlist_head	*head,
-	xlog_tid_t		tid,
-	xfs_lsn_t		lsn)
-{
-	xlog_recover_t		*trans;
-
-	trans = kmem_zalloc(sizeof(xlog_recover_t), KM_SLEEP);
-	trans->r_log_tid   = tid;
-	trans->r_lsn	   = lsn;
-	INIT_LIST_HEAD(&trans->r_itemq);
-
-	INIT_HLIST_NODE(&trans->r_list);
-	hlist_add_head(&trans->r_list, head);
-}
-
-STATIC void
-xlog_recover_add_item(
-	struct list_head	*head)
-{
-	xlog_recover_item_t	*item;
-
-	item = kmem_zalloc(sizeof(xlog_recover_item_t), KM_SLEEP);
-	INIT_LIST_HEAD(&item->ri_list);
-	list_add_tail(&item->ri_list, head);
-}
-
-STATIC int
-xlog_recover_add_to_cont_trans(
-	struct xlog		*log,
-	struct xlog_recover	*trans,
-	xfs_caddr_t		dp,
-	int			len)
-{
-	xlog_recover_item_t	*item;
-	xfs_caddr_t		ptr, old_ptr;
-	int			old_len;
-
-	if (list_empty(&trans->r_itemq)) {
-		/* finish copying rest of trans header */
-		xlog_recover_add_item(&trans->r_itemq);
-		ptr = (xfs_caddr_t) &trans->r_theader +
-				sizeof(xfs_trans_header_t) - len;
-		memcpy(ptr, dp, len); /* d, s, l */
-		return 0;
-	}
-	/* take the tail entry */
-	item = list_entry(trans->r_itemq.prev, xlog_recover_item_t, ri_list);
-
-	old_ptr = item->ri_buf[item->ri_cnt-1].i_addr;
-	old_len = item->ri_buf[item->ri_cnt-1].i_len;
-
-	ptr = kmem_realloc(old_ptr, len+old_len, old_len, KM_SLEEP);
-	memcpy(&ptr[old_len], dp, len); /* d, s, l */
-	item->ri_buf[item->ri_cnt-1].i_len += len;
-	item->ri_buf[item->ri_cnt-1].i_addr = ptr;
-	trace_xfs_log_recover_item_add_cont(log, trans, item, 0);
-	return 0;
-}
-
-/*
- * The next region to add is the start of a new region.  It could be
- * a whole region or it could be the first part of a new region.  Because
- * of this, the assumption here is that the type and size fields of all
- * format structures fit into the first 32 bits of the structure.
- *
- * This works because all regions must be 32 bit aligned.  Therefore, we
- * either have both fields or we have neither field.  In the case we have
- * neither field, the data part of the region is zero length.  We only have
- * a log_op_header and can throw away the header since a new one will appear
- * later.  If we have at least 4 bytes, then we can determine how many regions
- * will appear in the current log item.
- */
-STATIC int
-xlog_recover_add_to_trans(
-	struct xlog		*log,
-	struct xlog_recover	*trans,
-	xfs_caddr_t		dp,
-	int			len)
-{
-	xfs_inode_log_format_t	*in_f;			/* any will do */
-	xlog_recover_item_t	*item;
-	xfs_caddr_t		ptr;
-
-	if (!len)
-		return 0;
-	if (list_empty(&trans->r_itemq)) {
-		/* we need to catch log corruptions here */
-		if (*(uint *)dp != XFS_TRANS_HEADER_MAGIC) {
-			xfs_warn(log->l_mp, "%s: bad header magic number",
-				__func__);
-			ASSERT(0);
-			return -EIO;
-		}
-		if (len == sizeof(xfs_trans_header_t))
-			xlog_recover_add_item(&trans->r_itemq);
-		memcpy(&trans->r_theader, dp, len); /* d, s, l */
-		return 0;
-	}
-
-	ptr = kmem_alloc(len, KM_SLEEP);
-	memcpy(ptr, dp, len);
-	in_f = (xfs_inode_log_format_t *)ptr;
-
-	/* take the tail entry */
-	item = list_entry(trans->r_itemq.prev, xlog_recover_item_t, ri_list);
-	if (item->ri_total != 0 &&
-	     item->ri_total == item->ri_cnt) {
-		/* tail item is in use, get a new one */
-		xlog_recover_add_item(&trans->r_itemq);
-		item = list_entry(trans->r_itemq.prev,
-					xlog_recover_item_t, ri_list);
-	}
-
-	if (item->ri_total == 0) {		/* first region to be added */
-		if (in_f->ilf_size == 0 ||
-		    in_f->ilf_size > XLOG_MAX_REGIONS_IN_ITEM) {
-			xfs_warn(log->l_mp,
-		"bad number of regions (%d) in inode log format",
-				  in_f->ilf_size);
-			ASSERT(0);
-			kmem_free(ptr);
-			return -EIO;
-		}
-
-		item->ri_total = in_f->ilf_size;
-		item->ri_buf =
-			kmem_zalloc(item->ri_total * sizeof(xfs_log_iovec_t),
-				    KM_SLEEP);
-	}
-	ASSERT(item->ri_total > item->ri_cnt);
-	/* Description region is ri_buf[0] */
-	item->ri_buf[item->ri_cnt].i_addr = ptr;
-	item->ri_buf[item->ri_cnt].i_len  = len;
-	item->ri_cnt++;
-	trace_xfs_log_recover_item_add(log, trans, item, 0);
-	return 0;
-}
-
 /*
  * Sort the log items in the transaction.
  *
@@ -3250,31 +3096,6 @@ xlog_recover_do_icreate_pass2(
 	return 0;
 }
 
-/*
- * Free up any resources allocated by the transaction
- *
- * Remember that EFIs, EFDs, and IUNLINKs are handled later.
- */
-STATIC void
-xlog_recover_free_trans(
-	struct xlog_recover	*trans)
-{
-	xlog_recover_item_t	*item, *n;
-	int			i;
-
-	list_for_each_entry_safe(item, n, &trans->r_itemq, ri_list) {
-		/* Free the regions in the item. */
-		list_del(&item->ri_list);
-		for (i = 0; i < item->ri_cnt; i++)
-			kmem_free(item->ri_buf[i].i_addr);
-		/* Free the item itself */
-		kmem_free(item->ri_buf);
-		kmem_free(item);
-	}
-	/* Free the transaction recover structure */
-	kmem_free(trans);
-}
-
 STATIC void
 xlog_recover_buffer_ra_pass2(
 	struct xlog                     *log,
@@ -3528,6 +3349,185 @@ out:
 	return error ? error : error2;
 }
 
+
+STATIC xlog_recover_t *
+xlog_recover_find_tid(
+	struct hlist_head	*head,
+	xlog_tid_t		tid)
+{
+	xlog_recover_t		*trans;
+
+	hlist_for_each_entry(trans, head, r_list) {
+		if (trans->r_log_tid == tid)
+			return trans;
+	}
+	return NULL;
+}
+
+STATIC void
+xlog_recover_new_tid(
+	struct hlist_head	*head,
+	xlog_tid_t		tid,
+	xfs_lsn_t		lsn)
+{
+	xlog_recover_t		*trans;
+
+	trans = kmem_zalloc(sizeof(xlog_recover_t), KM_SLEEP);
+	trans->r_log_tid   = tid;
+	trans->r_lsn	   = lsn;
+	INIT_LIST_HEAD(&trans->r_itemq);
+
+	INIT_HLIST_NODE(&trans->r_list);
+	hlist_add_head(&trans->r_list, head);
+}
+
+STATIC void
+xlog_recover_add_item(
+	struct list_head	*head)
+{
+	xlog_recover_item_t	*item;
+
+	item = kmem_zalloc(sizeof(xlog_recover_item_t), KM_SLEEP);
+	INIT_LIST_HEAD(&item->ri_list);
+	list_add_tail(&item->ri_list, head);
+}
+
+STATIC int
+xlog_recover_add_to_cont_trans(
+	struct xlog		*log,
+	struct xlog_recover	*trans,
+	xfs_caddr_t		dp,
+	int			len)
+{
+	xlog_recover_item_t	*item;
+	xfs_caddr_t		ptr, old_ptr;
+	int			old_len;
+
+	if (list_empty(&trans->r_itemq)) {
+		/* finish copying rest of trans header */
+		xlog_recover_add_item(&trans->r_itemq);
+		ptr = (xfs_caddr_t) &trans->r_theader +
+				sizeof(xfs_trans_header_t) - len;
+		memcpy(ptr, dp, len);
+		return 0;
+	}
+	/* take the tail entry */
+	item = list_entry(trans->r_itemq.prev, xlog_recover_item_t, ri_list);
+
+	old_ptr = item->ri_buf[item->ri_cnt-1].i_addr;
+	old_len = item->ri_buf[item->ri_cnt-1].i_len;
+
+	ptr = kmem_realloc(old_ptr, len+old_len, old_len, KM_SLEEP);
+	memcpy(&ptr[old_len], dp, len);
+	item->ri_buf[item->ri_cnt-1].i_len += len;
+	item->ri_buf[item->ri_cnt-1].i_addr = ptr;
+	trace_xfs_log_recover_item_add_cont(log, trans, item, 0);
+	return 0;
+}
+
+/*
+ * The next region to add is the start of a new region.  It could be
+ * a whole region or it could be the first part of a new region.  Because
+ * of this, the assumption here is that the type and size fields of all
+ * format structures fit into the first 32 bits of the structure.
+ *
+ * This works because all regions must be 32 bit aligned.  Therefore, we
+ * either have both fields or we have neither field.  In the case we have
+ * neither field, the data part of the region is zero length.  We only have
+ * a log_op_header and can throw away the header since a new one will appear
+ * later.  If we have at least 4 bytes, then we can determine how many regions
+ * will appear in the current log item.
+ */
+STATIC int
+xlog_recover_add_to_trans(
+	struct xlog		*log,
+	struct xlog_recover	*trans,
+	xfs_caddr_t		dp,
+	int			len)
+{
+	xfs_inode_log_format_t	*in_f;			/* any will do */
+	xlog_recover_item_t	*item;
+	xfs_caddr_t		ptr;
+
+	if (!len)
+		return 0;
+	if (list_empty(&trans->r_itemq)) {
+		/* we need to catch log corruptions here */
+		if (*(uint *)dp != XFS_TRANS_HEADER_MAGIC) {
+			xfs_warn(log->l_mp, "%s: bad header magic number",
+				__func__);
+			ASSERT(0);
+			return -EIO;
+		}
+		if (len == sizeof(xfs_trans_header_t))
+			xlog_recover_add_item(&trans->r_itemq);
+		memcpy(&trans->r_theader, dp, len);
+		return 0;
+	}
+
+	ptr = kmem_alloc(len, KM_SLEEP);
+	memcpy(ptr, dp, len);
+	in_f = (xfs_inode_log_format_t *)ptr;
+
+	/* take the tail entry */
+	item = list_entry(trans->r_itemq.prev, xlog_recover_item_t, ri_list);
+	if (item->ri_total != 0 &&
+	     item->ri_total == item->ri_cnt) {
+		/* tail item is in use, get a new one */
+		xlog_recover_add_item(&trans->r_itemq);
+		item = list_entry(trans->r_itemq.prev,
+					xlog_recover_item_t, ri_list);
+	}
+
+	if (item->ri_total == 0) {		/* first region to be added */
+		if (in_f->ilf_size == 0 ||
+		    in_f->ilf_size > XLOG_MAX_REGIONS_IN_ITEM) {
+			xfs_warn(log->l_mp,
+		"bad number of regions (%d) in inode log format",
+				  in_f->ilf_size);
+			ASSERT(0);
+			kmem_free(ptr);
+			return -EIO;
+		}
+
+		item->ri_total = in_f->ilf_size;
+		item->ri_buf =
+			kmem_zalloc(item->ri_total * sizeof(xfs_log_iovec_t),
+				    KM_SLEEP);
+	}
+	ASSERT(item->ri_total > item->ri_cnt);
+	/* Description region is ri_buf[0] */
+	item->ri_buf[item->ri_cnt].i_addr = ptr;
+	item->ri_buf[item->ri_cnt].i_len  = len;
+	item->ri_cnt++;
+	trace_xfs_log_recover_item_add(log, trans, item, 0);
+	return 0;
+}
+/*
+ * Free up any resources allocated by the transaction
+ *
+ * Remember that EFIs, EFDs, and IUNLINKs are handled later.
+ */
+STATIC void
+xlog_recover_free_trans(
+	struct xlog_recover	*trans)
+{
+	xlog_recover_item_t	*item, *n;
+	int			i;
+
+	list_for_each_entry_safe(item, n, &trans->r_itemq, ri_list) {
+		/* Free the regions in the item. */
+		list_del(&item->ri_list);
+		for (i = 0; i < item->ri_cnt; i++)
+			kmem_free(item->ri_buf[i].i_addr);
+		/* Free the item itself */
+		kmem_free(item->ri_buf);
+		kmem_free(item);
+	}
+	/* Free the transaction recover structure */
+	kmem_free(trans);
+}
+
 STATIC int
 xlog_recovery_process_ophdr(
 	struct xlog		*log,
-- 
2.0.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
