Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60200 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755398AbeASOJG (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 19 Jan 2018 09:09:06 -0500
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id BDDA3780E9
        for <linux-xfs@vger.kernel.org>; Fri, 19 Jan 2018 14:09:06 +0000 (UTC)
Received: from odin.usersys.redhat.com (unknown [10.40.205.133])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 26D6A62463
        for <linux-xfs@vger.kernel.org>; Fri, 19 Jan 2018 14:09:05 +0000 (UTC)
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: [PATCH 4/4] Use list_head infra-structure for buffer's log items list
Date: Fri, 19 Jan 2018 15:08:47 +0100
Message-Id: <20180119140847.22934-5-cmaiolino@redhat.com>
In-Reply-To: <20180119140847.22934-1-cmaiolino@redhat.com>
References: <20180119140847.22934-1-cmaiolino@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Now that buffer's b_fspriv has been split, just replace the current
singly linked list of xfs_log_items, by the list_head infrastructure.

Also, remove the xfs_log_item argument from xfs_buf_resubmit_failed_buffers(),
there is no need for this argument, once the log items can be walked
through the list_head in the buffer.

Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 fs/xfs/xfs_buf.c        |  1 +
 fs/xfs/xfs_buf.h        |  2 +-
 fs/xfs/xfs_buf_item.c   | 60 +++++++++++++++++++++----------------------------
 fs/xfs/xfs_buf_item.h   |  1 -
 fs/xfs/xfs_dquot_item.c |  2 +-
 fs/xfs/xfs_inode.c      |  8 +++----
 fs/xfs/xfs_inode_item.c | 41 ++++++++++-----------------------
 fs/xfs/xfs_log.c        |  1 +
 fs/xfs/xfs_trans.h      |  2 +-
 9 files changed, 46 insertions(+), 72 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 07dccb05e782..47e530662db9 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -236,6 +236,7 @@ _xfs_buf_alloc(
 	init_completion(&bp->b_iowait);
 	INIT_LIST_HEAD(&bp->b_lru);
 	INIT_LIST_HEAD(&bp->b_list);
+	INIT_LIST_HEAD(&bp->b_li_list);
 	sema_init(&bp->b_sema, 0); /* held, no waiters */
 	spin_lock_init(&bp->b_lock);
 	XB_SET_OWNER(bp);
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index 21a20d91e9e9..503221f778d3 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -177,7 +177,7 @@ struct xfs_buf {
 	xfs_buf_iodone_t	b_iodone;	/* I/O completion function */
 	struct completion	b_iowait;	/* queue for I/O waiters */
 	void			*b_log_item;
-	struct xfs_log_item	*b_li_list;
+	struct list_head	b_li_list;	/* Log items list head */
 	struct xfs_trans	*b_transp;
 	struct page		**b_pages;	/* array of page pointers */
 	struct page		*b_page_array[XB_PAGES]; /* inline pages */
diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index cbb88a671b3a..33f878b51925 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -457,7 +457,7 @@ xfs_buf_item_unpin(
 		if (bip->bli_flags & XFS_BLI_STALE_INODE) {
 			xfs_buf_do_callbacks(bp);
 			bp->b_log_item = NULL;
-			bp->b_li_list = NULL;
+			list_del_init(&bp->b_li_list);
 			bp->b_iodone = NULL;
 		} else {
 			spin_lock(&ailp->xa_lock);
@@ -955,13 +955,12 @@ xfs_buf_item_relse(
 	struct xfs_buf		*bp)
 {
 	struct xfs_buf_log_item	*bip = bp->b_log_item;
-	struct xfs_log_item	*lip = bp->b_li_list;
 
 	trace_xfs_buf_item_relse(bp, _RET_IP_);
 	ASSERT(!(bip->bli_item.li_flags & XFS_LI_IN_AIL));
 
 	bp->b_log_item = NULL;
-	if (lip == NULL)
+	if (list_empty(&bp->b_li_list))
 		bp->b_iodone = NULL;
 
 	xfs_buf_rele(bp);
@@ -982,18 +981,10 @@ xfs_buf_attach_iodone(
 	void		(*cb)(struct xfs_buf *, xfs_log_item_t *),
 	xfs_log_item_t	*lip)
 {
-	xfs_log_item_t	*head_lip;
-
 	ASSERT(xfs_buf_islocked(bp));
 
 	lip->li_cb = cb;
-	head_lip = bp->b_li_list;
-	if (head_lip) {
-		lip->li_bio_list = head_lip->li_bio_list;
-		head_lip->li_bio_list = lip;
-	} else {
-		bp->b_li_list = lip;
-	}
+	list_add_tail(&lip->li_bio_list, &bp->b_li_list);
 
 	ASSERT(bp->b_iodone == NULL ||
 	       bp->b_iodone == xfs_buf_iodone_callbacks);
@@ -1003,12 +994,12 @@ xfs_buf_attach_iodone(
 /*
  * We can have many callbacks on a buffer. Running the callbacks individually
  * can cause a lot of contention on the AIL lock, so we allow for a single
- * callback to be able to scan the remaining lip->li_bio_list for other items
+ * callback to be able to scan the remaining items in bp->b_li_list for other items
  * of the same type and callback to be processed in the first call.
  *
  * As a result, the loop walking the callback list below will also modify the
  * list. it removes the first item from the list and then runs the callback.
- * The loop then restarts from the new head of the list. This allows the
+ * The loop then restarts from the new first item int the list. This allows the
  * callback to scan and modify the list attached to the buffer and we don't
  * have to care about maintaining a next item pointer.
  */
@@ -1025,17 +1016,19 @@ xfs_buf_do_callbacks(
 		lip->li_cb(bp, lip);
 	}
 
-	while ((lip = bp->b_li_list) != NULL) {
-		bp->b_li_list = lip->li_bio_list;
-		ASSERT(lip->li_cb != NULL);
+	while(!list_empty(&bp->b_li_list))
+	{
+		lip = list_first_entry(&bp->b_li_list, struct xfs_log_item,
+				       li_bio_list);
+
 		/*
-		 * Clear the next pointer so we don't have any
+		 * Remove the item from the list, so we don't have any
 		 * confusion if the item is added to another buf.
 		 * Don't touch the log item after calling its
 		 * callback, because it could have freed itself.
 		 */
-		lip->li_bio_list = NULL;
-		lip->li_cb(bp, lip);
+		list_del_init(&lip->li_bio_list);
+		lip->li_cb(bp,lip);
 	}
 }
 
@@ -1051,8 +1044,7 @@ STATIC void
 xfs_buf_do_callbacks_fail(
 	struct xfs_buf		*bp)
 {
-	struct xfs_log_item	*lip = bp->b_li_list;
-	struct xfs_log_item	*next;
+	struct xfs_log_item	*lip;
 	struct xfs_ail		*ailp;
 
 	/*
@@ -1060,14 +1052,16 @@ xfs_buf_do_callbacks_fail(
 	 * and xfs_buf_iodone_callback_error, and they have no IO error
 	 * callbacks. Check only for items in b_li_list.
 	 */
-	if (lip == NULL)
+	if (list_empty(&bp->b_li_list)) {
 		return;
-	else
+	} else {
+		lip = list_first_entry(&bp->b_li_list, struct xfs_log_item,
+				       li_bio_list);
 		ailp = lip->li_ailp;
+	}
 
 	spin_lock(&ailp->xa_lock);
-	for (; lip; lip = next) {
-		next = lip->li_bio_list;
+	list_for_each_entry(lip, &bp->b_li_list, li_bio_list) {
 		if (lip->li_ops->iop_error)
 			lip->li_ops->iop_error(lip, bp);
 	}
@@ -1079,7 +1073,7 @@ xfs_buf_iodone_callback_error(
 	struct xfs_buf		*bp)
 {
 	struct xfs_buf_log_item	*bip = bp->b_log_item;
-	struct xfs_log_item	*lip = bp->b_li_list;
+	struct xfs_log_item	*lip;
 	struct xfs_mount	*mp;
 	static ulong		lasttime;
 	static xfs_buftarg_t	*lasttarg;
@@ -1089,7 +1083,8 @@ xfs_buf_iodone_callback_error(
 	 * The failed buffer might not have a buf_log_item attached or the
 	 * log_item list might be empty. Get the mp from the available xfs_log_item
 	 */
-	if (bip == NULL)
+	if ((lip = list_first_entry_or_null(&bp->b_li_list, struct xfs_log_item,
+					   li_bio_list)))
 		mp = lip->li_mountp;
 	else
 		mp = bip->bli_item.li_mountp;
@@ -1203,7 +1198,7 @@ xfs_buf_iodone_callbacks(
 
 	xfs_buf_do_callbacks(bp);
 	bp->b_log_item = NULL;
-	bp->b_li_list = NULL;
+	list_del_init(&bp->b_li_list);
 	bp->b_iodone = NULL;
 	xfs_buf_ioend(bp);
 }
@@ -1248,10 +1243,9 @@ xfs_buf_iodone(
 bool
 xfs_buf_resubmit_failed_buffers(
 	struct xfs_buf		*bp,
-	struct xfs_log_item	*lip,
 	struct list_head	*buffer_list)
 {
-	struct xfs_log_item	*next;
+	struct xfs_log_item	*lip;
 
 	/*
 	 * Clear XFS_LI_FAILED flag from all items before resubmit
@@ -1259,10 +1253,8 @@ xfs_buf_resubmit_failed_buffers(
 	 * XFS_LI_FAILED set/clear is protected by xa_lock, caller  this
 	 * function already have it acquired
 	 */
-	for (; lip; lip = next) {
-		next = lip->li_bio_list;
+	list_for_each_entry(lip, &bp->b_li_list, li_bio_list)
 		xfs_clear_li_failed(lip);
-	}
 
 	/* Add this buffer back to the delayed write list */
 	return xfs_buf_delwri_queue(bp, buffer_list);
diff --git a/fs/xfs/xfs_buf_item.h b/fs/xfs/xfs_buf_item.h
index 0febfbbf6ba9..643f53dcfe51 100644
--- a/fs/xfs/xfs_buf_item.h
+++ b/fs/xfs/xfs_buf_item.h
@@ -71,7 +71,6 @@ void	xfs_buf_attach_iodone(struct xfs_buf *,
 void	xfs_buf_iodone_callbacks(struct xfs_buf *);
 void	xfs_buf_iodone(struct xfs_buf *, struct xfs_log_item *);
 bool	xfs_buf_resubmit_failed_buffers(struct xfs_buf *,
-					struct xfs_log_item *,
 					struct list_head *);
 
 extern kmem_zone_t	*xfs_buf_item_zone;
diff --git a/fs/xfs/xfs_dquot_item.c b/fs/xfs/xfs_dquot_item.c
index 664dea105e76..4a4539a4fad5 100644
--- a/fs/xfs/xfs_dquot_item.c
+++ b/fs/xfs/xfs_dquot_item.c
@@ -179,7 +179,7 @@ xfs_qm_dquot_logitem_push(
 		if (!xfs_buf_trylock(bp))
 			return XFS_ITEM_LOCKED;
 
-		if (!xfs_buf_resubmit_failed_buffers(bp, lip, buffer_list))
+		if (!xfs_buf_resubmit_failed_buffers(bp, buffer_list))
 			rval = XFS_ITEM_FLUSHING;
 
 		xfs_buf_unlock(bp);
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 0a4c2e48402f..8e26d3121be6 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2214,7 +2214,7 @@ xfs_ifree_cluster(
 	struct xfs_buf		*bp;
 	xfs_inode_t		*ip;
 	xfs_inode_log_item_t	*iip;
-	xfs_log_item_t		*lip;
+	struct xfs_log_item	*lip;
 	struct xfs_perag	*pag;
 	xfs_ino_t		inum;
 
@@ -2272,8 +2272,7 @@ xfs_ifree_cluster(
 		 * stale first, we will not attempt to lock them in the loop
 		 * below as the XFS_ISTALE flag will be set.
 		 */
-		lip = bp->b_li_list;
-		while (lip) {
+		list_for_each_entry(lip, &bp->b_li_list, li_bio_list) {
 			if (lip->li_type == XFS_LI_INODE) {
 				iip = (xfs_inode_log_item_t *)lip;
 				ASSERT(iip->ili_logged == 1);
@@ -2283,7 +2282,6 @@ xfs_ifree_cluster(
 							&iip->ili_item.li_lsn);
 				xfs_iflags_set(iip->ili_inode, XFS_ISTALE);
 			}
-			lip = lip->li_bio_list;
 		}
 
 
@@ -3649,7 +3647,7 @@ xfs_iflush_int(
 	/* generate the checksum. */
 	xfs_dinode_calc_crc(mp, dip);
 
-	ASSERT(bp->b_li_list != NULL);
+	ASSERT(!list_empty(&bp->b_li_list));
 	ASSERT(bp->b_iodone != NULL);
 	return 0;
 
diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index 993736032b4b..ddfc2c80af5e 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -521,7 +521,7 @@ xfs_inode_item_push(
 		if (!xfs_buf_trylock(bp))
 			return XFS_ITEM_LOCKED;
 
-		if (!xfs_buf_resubmit_failed_buffers(bp, lip, buffer_list))
+		if (!xfs_buf_resubmit_failed_buffers(bp, buffer_list))
 			rval = XFS_ITEM_FLUSHING;
 
 		xfs_buf_unlock(bp);
@@ -712,37 +712,23 @@ xfs_iflush_done(
 	struct xfs_log_item	*lip)
 {
 	struct xfs_inode_log_item *iip;
-	struct xfs_log_item	*blip;
-	struct xfs_log_item	*next;
-	struct xfs_log_item	*prev;
+	struct xfs_log_item	*blip, *n;
 	struct xfs_ail		*ailp = lip->li_ailp;
 	int			need_ail = 0;
+	LIST_HEAD(tmp);
 
 	/*
 	 * Scan the buffer IO completions for other inodes being completed and
 	 * attach them to the current inode log item.
 	 */
-	blip = bp->b_li_list;
-	prev = NULL;
-	while (blip != NULL) {
-		if (blip->li_cb != xfs_iflush_done) {
-			prev = blip;
-			blip = blip->li_bio_list;
-			continue;
-		}
 
-		/* remove from list */
-		next = blip->li_bio_list;
-		if (!prev) {
-			bp->b_li_list = next;
-		} else {
-			prev->li_bio_list = next;
-		}
+	list_add_tail(&lip->li_bio_list, &tmp);
 
-		/* add to current list */
-		blip->li_bio_list = lip->li_bio_list;
-		lip->li_bio_list = blip;
+	list_for_each_entry_safe(blip, n, &bp->b_li_list, li_bio_list) {
+		if (lip->li_cb != xfs_iflush_done)
+			continue;
 
+		list_move_tail(&blip->li_bio_list, &tmp);
 		/*
 		 * while we have the item, do the unlocked check for needing
 		 * the AIL lock.
@@ -751,8 +737,6 @@ xfs_iflush_done(
 		if ((iip->ili_logged && blip->li_lsn == iip->ili_flush_lsn) ||
 		    (blip->li_flags & XFS_LI_FAILED))
 			need_ail++;
-
-		blip = next;
 	}
 
 	/* make sure we capture the state of the initial inode. */
@@ -775,7 +759,7 @@ xfs_iflush_done(
 
 		/* this is an opencoded batch version of xfs_trans_ail_delete */
 		spin_lock(&ailp->xa_lock);
-		for (blip = lip; blip; blip = blip->li_bio_list) {
+		list_for_each_entry(blip, &tmp, li_bio_list) {
 			if (INODE_ITEM(blip)->ili_logged &&
 			    blip->li_lsn == INODE_ITEM(blip)->ili_flush_lsn)
 				mlip_changed |= xfs_ail_delete_one(ailp, blip);
@@ -801,15 +785,14 @@ xfs_iflush_done(
 	 * ili_last_fields bits now that we know that the data corresponding to
 	 * them is safely on disk.
 	 */
-	for (blip = lip; blip; blip = next) {
-		next = blip->li_bio_list;
-		blip->li_bio_list = NULL;
-
+	list_for_each_entry_safe(blip, n, &tmp, li_bio_list) {
+		list_del_init(&blip->li_bio_list);
 		iip = INODE_ITEM(blip);
 		iip->ili_logged = 0;
 		iip->ili_last_fields = 0;
 		xfs_ifunlock(iip->ili_inode);
 	}
+	list_del(&tmp);
 }
 
 /*
diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 861c84e1f674..1b5082aeb538 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1047,6 +1047,7 @@ xfs_log_item_init(
 
 	INIT_LIST_HEAD(&item->li_ail);
 	INIT_LIST_HEAD(&item->li_cil);
+	INIT_LIST_HEAD(&item->li_bio_list);
 }
 
 /*
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index 571fe499a48f..950cb9b4e36e 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -50,7 +50,7 @@ typedef struct xfs_log_item {
 	uint				li_type;	/* item type */
 	uint				li_flags;	/* misc flags */
 	struct xfs_buf			*li_buf;	/* real buffer pointer */
-	struct xfs_log_item		*li_bio_list;	/* buffer item list */
+	struct list_head		li_bio_list;	/* buffer item list */
 	void				(*li_cb)(struct xfs_buf *,
 						 struct xfs_log_item *);
 							/* buffer item iodone */
-- 
2.14.3

