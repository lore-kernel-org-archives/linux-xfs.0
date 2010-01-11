Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0BBrOwl138174 for <xfs@oss.sgi.com>; Mon, 11 Jan 2010 05:53:25 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8F6001357F87
	for <xfs@oss.sgi.com>; Mon, 11 Jan 2010 03:54:18 -0800 (PST)
Received: from mail.internode.on.net (bld-mail12.adl6.internode.on.net
	[150.101.137.97]) by cuda.sgi.com with ESMTP id
	Jka2aAaFFhrBjOzn for <xfs@oss.sgi.com>;
	Mon, 11 Jan 2010 03:54:18 -0800 (PST)
Received: from discord (unverified [121.44.168.156])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	11397741-1927428
	for <xfs@oss.sgi.com>; Mon, 11 Jan 2010 22:24:17 +1030 (CDT)
Received: from [192.168.1.6] (helo=disturbed) by discord with esmtp (Exim 4.69)
	(envelope-from <dave@fromorbit.com>) id 1NUIqd-0003fl-CV
	for xfs@oss.sgi.com; Mon, 11 Jan 2010 22:54:15 +1100
Received: from dave by disturbed with local (Exim 4.71)
	(envelope-from <dave@disturbed.disaster>) id 1NUImb-0006qV-5C
	for xfs@oss.sgi.com; Mon, 11 Jan 2010 22:50:05 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 1/3] XFS: Use list_heads for log recovery item lists
Date: Mon, 11 Jan 2010 22:49:57 +1100
Message-Id: <1263210599-25067-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1263210599-25067-1-git-send-email-david@fromorbit.com>
References: <1263210599-25067-1-git-send-email-david@fromorbit.com>
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

Remove the roll-your-own linked list operations.

Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/xfs_log_recover.c |  205 ++++++++++++++++------------------------------
 fs/xfs/xfs_log_recover.h |   23 +++---
 2 files changed, 81 insertions(+), 147 deletions(-)

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 69ac2e5..cd55e1c 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -50,8 +50,6 @@
 
 STATIC int	xlog_find_zeroed(xlog_t *, xfs_daddr_t *);
 STATIC int	xlog_clear_stale_blocks(xlog_t *, xfs_lsn_t);
-STATIC void	xlog_recover_insert_item_backq(xlog_recover_item_t **q,
-					       xlog_recover_item_t *item);
 #if defined(DEBUG)
 STATIC void	xlog_recover_check_summary(xlog_t *);
 #else
@@ -1367,36 +1365,45 @@ xlog_clear_stale_blocks(
 
 STATIC xlog_recover_t *
 xlog_recover_find_tid(
-	xlog_recover_t		*q,
+	struct hlist_head	*head,
 	xlog_tid_t		tid)
 {
-	xlog_recover_t		*p = q;
+	xlog_recover_t		*trans;
+	struct hlist_node	*n;
 
-	while (p != NULL) {
-		if (p->r_log_tid == tid)
-		    break;
-		p = p->r_next;
+	hlist_for_each_entry(trans, n, head, r_list) {
+		if (trans->r_log_tid == tid)
+			return trans;
 	}
-	return p;
+	return NULL;
 }
 
 STATIC void
-xlog_recover_put_hashq(
-	xlog_recover_t		**q,
-	xlog_recover_t		*trans)
+xlog_recover_new_tid(
+	struct hlist_head	*head,
+	xlog_tid_t		tid,
+	xfs_lsn_t		lsn)
 {
-	trans->r_next = *q;
-	*q = trans;
+	xlog_recover_t		*trans;
+
+	trans = kmem_zalloc(sizeof(xlog_recover_t), KM_SLEEP);
+	trans->r_log_tid   = tid;
+	trans->r_lsn	   = lsn;
+	INIT_LIST_HEAD(&trans->r_itemq);
+
+	INIT_HLIST_NODE(&trans->r_list);
+	hlist_add_head(&trans->r_list, head);
 }
 
 STATIC void
 xlog_recover_add_item(
-	xlog_recover_item_t	**itemq)
+	struct list_head	*head)
 {
 	xlog_recover_item_t	*item;
 
 	item = kmem_zalloc(sizeof(xlog_recover_item_t), KM_SLEEP);
-	xlog_recover_insert_item_backq(itemq, item);
+	INIT_LIST_HEAD(&item->ri_list);
+	list_add_tail(&item->ri_list, head);
 }
 
 STATIC int
@@ -1409,8 +1416,7 @@ xlog_recover_add_to_cont_trans(
 	xfs_caddr_t		ptr, old_ptr;
 	int			old_len;
 
-	item = trans->r_itemq;
-	if (item == NULL) {
+	if (list_empty(&trans->r_itemq)) {
 		/* finish copying rest of trans header */
 		xlog_recover_add_item(&trans->r_itemq);
 		ptr = (xfs_caddr_t) &trans->r_theader +
@@ -1418,7 +1424,8 @@ xlog_recover_add_to_cont_trans(
 		memcpy(ptr, dp, len); /* d, s, l */
 		return 0;
 	}
-	item = item->ri_prev;
+	/* take the tail entry */
+	item = list_entry(trans->r_itemq.prev, xlog_recover_item_t, ri_list);
 
 	old_ptr = item->ri_buf[item->ri_cnt-1].i_addr;
 	old_len = item->ri_buf[item->ri_cnt-1].i_len;
@@ -1455,8 +1462,7 @@ xlog_recover_add_to_trans(
 
 	if (!len)
 		return 0;
-	item = trans->r_itemq;
-	if (item == NULL) {
+	if (list_empty(&trans->r_itemq)) {
 		/* we need to catch log corruptions here */
 		if (*(uint *)dp != XFS_TRANS_HEADER_MAGIC) {
 			xlog_warn("XFS: xlog_recover_add_to_trans: "
@@ -1474,12 +1480,15 @@ xlog_recover_add_to_trans(
 	memcpy(ptr, dp, len);
 	in_f = (xfs_inode_log_format_t *)ptr;
 
-	if (item->ri_prev->ri_total != 0 &&
-	     item->ri_prev->ri_total == item->ri_prev->ri_cnt) {
+	/* take the tail entry */
+	item = list_entry(trans->r_itemq.prev, xlog_recover_item_t, ri_list);
+	if (item->ri_total != 0 &&
+	     item->ri_total == item->ri_cnt) {
+		/* tail item is in use, get a new one */
 		xlog_recover_add_item(&trans->r_itemq);
+		item = list_entry(trans->r_itemq.prev,
+					xlog_recover_item_t, ri_list);
 	}
-	item = trans->r_itemq;
-	item = item->ri_prev;
 
 	if (item->ri_total == 0) {		/* first region to be added */
 		if (in_f->ilf_size == 0 ||
@@ -1504,96 +1513,29 @@ xlog_recover_add_to_trans(
 	return 0;
 }
 
-STATIC void
-xlog_recover_new_tid(
-	xlog_recover_t		**q,
-	xlog_tid_t		tid,
-	xfs_lsn_t		lsn)
-{
-	xlog_recover_t		*trans;
-
-	trans = kmem_zalloc(sizeof(xlog_recover_t), KM_SLEEP);
-	trans->r_log_tid   = tid;
-	trans->r_lsn	   = lsn;
-	xlog_recover_put_hashq(q, trans);
-}
-
-STATIC int
-xlog_recover_unlink_tid(
-	xlog_recover_t		**q,
-	xlog_recover_t		*trans)
-{
-	xlog_recover_t		*tp;
-	int			found = 0;
-
-	ASSERT(trans != NULL);
-	if (trans == *q) {
-		*q = (*q)->r_next;
-	} else {
-		tp = *q;
-		while (tp) {
-			if (tp->r_next == trans) {
-				found = 1;
-				break;
-			}
-			tp = tp->r_next;
-		}
-		if (!found) {
-			xlog_warn(
-			     "XFS: xlog_recover_unlink_tid: trans not found");
-			ASSERT(0);
-			return XFS_ERROR(EIO);
-		}
-		tp->r_next = tp->r_next->r_next;
-	}
-	return 0;
-}
-
-STATIC void
-xlog_recover_insert_item_backq(
-	xlog_recover_item_t	**q,
-	xlog_recover_item_t	*item)
-{
-	if (*q == NULL) {
-		item->ri_prev = item->ri_next = item;
-		*q = item;
-	} else {
-		item->ri_next		= *q;
-		item->ri_prev		= (*q)->ri_prev;
-		(*q)->ri_prev		= item;
-		item->ri_prev->ri_next	= item;
-	}
-}
-
-STATIC void
-xlog_recover_insert_item_frontq(
-	xlog_recover_item_t	**q,
-	xlog_recover_item_t	*item)
-{
-	xlog_recover_insert_item_backq(q, item);
-	*q = item;
-}
-
+/*
+ * Sort the log items in the transaction. Cancelled buffers need
+ * to be put first so they are processed before any items that might
+ * modify the buffers. If they are cancelled, then the modifications
+ * don't need to be replayed.
+ */
 STATIC int
 xlog_recover_reorder_trans(
 	xlog_recover_t		*trans)
 {
-	xlog_recover_item_t	*first_item, *itemq, *itemq_next;
-	xfs_buf_log_format_t	*buf_f;
-	ushort			flags = 0;
+	xlog_recover_item_t	*item, *n;
+	LIST_HEAD(sort_list);
+
+	list_splice_init(&trans->r_itemq, &sort_list);
+	list_for_each_entry_safe(item, n, &sort_list, ri_list) {
+		xfs_buf_log_format_t	*buf_f;
 
-	first_item = itemq = trans->r_itemq;
-	trans->r_itemq = NULL;
-	do {
-		itemq_next = itemq->ri_next;
-		buf_f = (xfs_buf_log_format_t *)itemq->ri_buf[0].i_addr;
+		buf_f = (xfs_buf_log_format_t *)item->ri_buf[0].i_addr;
 
-		switch (ITEM_TYPE(itemq)) {
+		switch (ITEM_TYPE(item)) {
 		case XFS_LI_BUF:
-			flags = buf_f->blf_flags;
-			if (!(flags & XFS_BLI_CANCEL)) {
-				xlog_recover_insert_item_frontq(&trans->r_itemq,
-								itemq);
+			if (!(buf_f->blf_flags & XFS_BLI_CANCEL)) {
+				list_move(&item->ri_list, &trans->r_itemq);
 				break;
 			}
 		case XFS_LI_INODE:
@@ -1601,7 +1543,7 @@ xlog_recover_reorder_trans(
 		case XFS_LI_QUOTAOFF:
 		case XFS_LI_EFD:
 		case XFS_LI_EFI:
-			xlog_recover_insert_item_backq(&trans->r_itemq, itemq);
+			list_move_tail(&item->ri_list, &trans->r_itemq);
 			break;
 		default:
 			xlog_warn(
@@ -1609,8 +1551,8 @@ xlog_recover_reorder_trans(
 			ASSERT(0);
 			return XFS_ERROR(EIO);
 		}
-		itemq = itemq_next;
-	} while (first_item != itemq);
+	}
+	ASSERT(list_empty(&sort_list));
 	return 0;
 }
 
@@ -2814,14 +2756,13 @@ xlog_recover_do_trans(
 	int			pass)
 {
 	int			error = 0;
-	xlog_recover_item_t	*item, *first_item;
+	xlog_recover_item_t	*item;
 
 	error = xlog_recover_reorder_trans(trans);
 	if (error)
 		return error;
 
-	first_item = item = trans->r_itemq;
-	do {
+	list_for_each_entry(item, &trans->r_itemq, ri_list) {
 		switch (ITEM_TYPE(item)) {
 		case XFS_LI_BUF:
 			error = xlog_recover_do_buffer_trans(log, item, pass);
@@ -2854,8 +2795,7 @@ xlog_recover_do_trans(
 
 		if (error)
 			return error;
-		item = item->ri_next;
-	} while (first_item != item);
+	}
 
 	return 0;
 }
@@ -2869,21 +2809,18 @@ STATIC void
 xlog_recover_free_trans(
 	xlog_recover_t		*trans)
 {
-	xlog_recover_item_t	*first_item, *item, *free_item;
+	xlog_recover_item_t	*item, *n;
 	int			i;
 
-	item = first_item = trans->r_itemq;
-	do {
-		free_item = item;
-		item = item->ri_next;
-		 /* Free the regions in the item. */
-		for (i = 0; i < free_item->ri_cnt; i++) {
-			kmem_free(free_item->ri_buf[i].i_addr);
-		}
+	list_for_each_entry_safe(item, n, &trans->r_itemq, ri_list) {
+		/* Free the regions in the item. */
+		list_del(&item->ri_list);
+		for (i = 0; i < item->ri_cnt; i++)
+			kmem_free(item->ri_buf[i].i_addr);
 		/* Free the item itself */
-		kmem_free(free_item->ri_buf);
-		kmem_free(free_item);
-	} while (first_item != item);
+		kmem_free(item->ri_buf);
+		kmem_free(item);
+	}
 	/* Free the transaction recover structure */
 	kmem_free(trans);
 }
@@ -2891,14 +2828,12 @@ xlog_recover_free_trans(
 STATIC int
 xlog_recover_commit_trans(
 	xlog_t			*log,
-	xlog_recover_t		**q,
 	xlog_recover_t		*trans,
 	int			pass)
 {
 	int			error;
 
-	if ((error = xlog_recover_unlink_tid(q, trans)))
-		return error;
+	hlist_del(&trans->r_list);
 	if ((error = xlog_recover_do_trans(log, trans, pass)))
 		return error;
 	xlog_recover_free_trans(trans);			/* no error */
@@ -2926,7 +2861,7 @@ xlog_recover_unmount_trans(
 STATIC int
 xlog_recover_process_data(
 	xlog_t			*log,
-	xlog_recover_t		*rhash[],
+	struct hlist_head	rhash[],
 	xlog_rec_header_t	*rhead,
 	xfs_caddr_t		dp,
 	int			pass)
@@ -2960,7 +2895,7 @@ xlog_recover_process_data(
 		}
 		tid = be32_to_cpu(ohead->oh_tid);
 		hash = XLOG_RHASH(tid);
-		trans = xlog_recover_find_tid(rhash[hash], tid);
+		trans = xlog_recover_find_tid(&rhash[hash], tid);
 		if (trans == NULL) {		   /* not found; add new tid */
 			if (ohead->oh_flags & XLOG_START_TRANS)
 				xlog_recover_new_tid(&rhash[hash], tid,
@@ -2978,7 +2913,7 @@ xlog_recover_process_data(
 			switch (flags) {
 			case XLOG_COMMIT_TRANS:
 				error = xlog_recover_commit_trans(log,
-						&rhash[hash], trans, pass);
+								trans, pass);
 				break;
 			case XLOG_UNMOUNT_TRANS:
 				error = xlog_recover_unmount_trans(trans);
@@ -3517,7 +3452,7 @@ xlog_do_recovery_pass(
 	int			error = 0, h_size;
 	int			bblks, split_bblks;
 	int			hblks, split_hblks, wrapped_hblks;
-	xlog_recover_t		*rhash[XLOG_RHASH_SIZE];
+	struct hlist_head	rhash[XLOG_RHASH_SIZE];
 
 	ASSERT(head_blk != tail_blk);
 
diff --git a/fs/xfs/xfs_log_recover.h b/fs/xfs/xfs_log_recover.h
index b225455..75d7492 100644
--- a/fs/xfs/xfs_log_recover.h
+++ b/fs/xfs/xfs_log_recover.h
@@ -35,22 +35,21 @@
  * item headers are in ri_buf[0].  Additional buffers follow.
  */
 typedef struct xlog_recover_item {
-	struct xlog_recover_item *ri_next;
-	struct xlog_recover_item *ri_prev;
-	int			 ri_type;
-	int			 ri_cnt;	/* count of regions found */
-	int			 ri_total;	/* total regions */
-	xfs_log_iovec_t		 *ri_buf;	/* ptr to regions buffer */
+	struct list_head	ri_list;
+	int			ri_type;
+	int			ri_cnt;	/* count of regions found */
+	int			ri_total;	/* total regions */
+	xfs_log_iovec_t		*ri_buf;	/* ptr to regions buffer */
 } xlog_recover_item_t;
 
 struct xlog_tid;
 typedef struct xlog_recover {
-	struct xlog_recover *r_next;
-	xlog_tid_t	    r_log_tid;		/* log's transaction id */
-	xfs_trans_header_t  r_theader;		/* trans header for partial */
-	int		    r_state;		/* not needed */
-	xfs_lsn_t	    r_lsn;		/* xact lsn */
-	xlog_recover_item_t *r_itemq;		/* q for items */
+	struct hlist_node	r_list;
+	xlog_tid_t		r_log_tid;	/* log's transaction id */
+	xfs_trans_header_t	r_theader;	/* trans header for partial */
+	int			r_state;	/* not needed */
+	xfs_lsn_t		r_lsn;		/* xact lsn */
+	struct list_head	r_itemq;	/* q for items */
 } xlog_recover_t;
 
 #define ITEM_TYPE(i)	(*(ushort *)(i)->ri_buf[0].i_addr)
-- 
1.6.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
