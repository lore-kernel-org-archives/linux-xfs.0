Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50878 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755360AbeASOJF (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 19 Jan 2018 09:09:05 -0500
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id CF6E2272A5
        for <linux-xfs@vger.kernel.org>; Fri, 19 Jan 2018 14:09:05 +0000 (UTC)
Received: from odin.usersys.redhat.com (unknown [10.40.205.133])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 226355D6B7
        for <linux-xfs@vger.kernel.org>; Fri, 19 Jan 2018 14:09:04 +0000 (UTC)
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: [PATCH 3/4] Split buffer's b_fspriv field
Date: Fri, 19 Jan 2018 15:08:46 +0100
Message-Id: <20180119140847.22934-4-cmaiolino@redhat.com>
In-Reply-To: <20180119140847.22934-1-cmaiolino@redhat.com>
References: <20180119140847.22934-1-cmaiolino@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

By splitting the b_fspriv field into two different fields (b_log_item
and b_li_list). It's possible to get rid of an old ABI workaround, by
using the new b_log_item field to store xfs_buf_log_item separated from
the log items attached to the buffer, which will be linked in the new
b_li_list field.

This way, there is no more need to reorder the log items list to place
the buf_log_item at the beginning of the list, simplifying a bit the
logic to handle buffer IO.

This also opens the possibility to change buffer's log items list into a
proper list_head.

b_log_item field is still defined as a void *, because it is still used
by the log buffers to store xlog_in_core structures, and there is no
need to add an extra field on xfs_buf just for xlog_in_core.

Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 fs/xfs/libxfs/xfs_alloc.c          |  4 +-
 fs/xfs/libxfs/xfs_attr_leaf.c      |  2 +-
 fs/xfs/libxfs/xfs_btree.c          |  4 +-
 fs/xfs/libxfs/xfs_da_btree.c       |  2 +-
 fs/xfs/libxfs/xfs_dir2_block.c     |  2 +-
 fs/xfs/libxfs/xfs_dir2_data.c      |  2 +-
 fs/xfs/libxfs/xfs_dir2_leaf.c      |  2 +-
 fs/xfs/libxfs/xfs_dir2_node.c      |  2 +-
 fs/xfs/libxfs/xfs_ialloc.c         |  2 +-
 fs/xfs/libxfs/xfs_sb.c             |  2 +-
 fs/xfs/libxfs/xfs_symlink_remote.c |  2 +-
 fs/xfs/xfs_buf.h                   |  3 +-
 fs/xfs/xfs_buf_item.c              | 88 +++++++++++++++++++++++---------------
 fs/xfs/xfs_inode.c                 |  4 +-
 fs/xfs/xfs_inode_item.c            |  4 +-
 fs/xfs/xfs_log.c                   |  8 ++--
 fs/xfs/xfs_log_recover.c           |  6 +--
 fs/xfs/xfs_trans_buf.c             | 48 ++++++++++-----------
 18 files changed, 104 insertions(+), 83 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index b41999fcbbe0..17dd7ff7a8f3 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -591,7 +591,7 @@ xfs_agfl_write_verify(
 	struct xfs_buf	*bp)
 {
 	struct xfs_mount	*mp = bp->b_target->bt_mount;
-	struct xfs_buf_log_item	*bip = bp->b_fspriv;
+	struct xfs_buf_log_item	*bip = bp->b_log_item;
 	xfs_failaddr_t		fa;
 
 	/* no verification of non-crc AGFLs */
@@ -2488,7 +2488,7 @@ xfs_agf_write_verify(
 	struct xfs_buf		*bp)
 {
 	struct xfs_mount	*mp = bp->b_target->bt_mount;
-	struct xfs_buf_log_item	*bip = bp->b_fspriv;
+	struct xfs_buf_log_item	*bip = bp->b_log_item;
 	xfs_failaddr_t		fa;
 
 	fa = xfs_agf_verify(bp);
diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index 6fddce7bbd54..516ed1bec27c 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -293,7 +293,7 @@ xfs_attr3_leaf_write_verify(
 	struct xfs_buf	*bp)
 {
 	struct xfs_mount	*mp = bp->b_target->bt_mount;
-	struct xfs_buf_log_item	*bip = bp->b_fspriv;
+	struct xfs_buf_log_item	*bip = bp->b_log_item;
 	struct xfs_attr3_leaf_hdr *hdr3 = bp->b_addr;
 	xfs_failaddr_t		fa;
 
diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index cc501b7d1fc5..f3c647b2b341 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -273,7 +273,7 @@ xfs_btree_lblock_calc_crc(
 	struct xfs_buf		*bp)
 {
 	struct xfs_btree_block	*block = XFS_BUF_TO_BLOCK(bp);
-	struct xfs_buf_log_item	*bip = bp->b_fspriv;
+	struct xfs_buf_log_item	*bip = bp->b_log_item;
 
 	if (!xfs_sb_version_hascrc(&bp->b_target->bt_mount->m_sb))
 		return;
@@ -311,7 +311,7 @@ xfs_btree_sblock_calc_crc(
 	struct xfs_buf		*bp)
 {
 	struct xfs_btree_block	*block = XFS_BUF_TO_BLOCK(bp);
-	struct xfs_buf_log_item	*bip = bp->b_fspriv;
+	struct xfs_buf_log_item	*bip = bp->b_log_item;
 
 	if (!xfs_sb_version_hascrc(&bp->b_target->bt_mount->m_sb))
 		return;
diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
index cf07585b9d83..ea187b4a7991 100644
--- a/fs/xfs/libxfs/xfs_da_btree.c
+++ b/fs/xfs/libxfs/xfs_da_btree.c
@@ -182,7 +182,7 @@ xfs_da3_node_write_verify(
 	struct xfs_buf	*bp)
 {
 	struct xfs_mount	*mp = bp->b_target->bt_mount;
-	struct xfs_buf_log_item	*bip = bp->b_fspriv;
+	struct xfs_buf_log_item	*bip = bp->b_log_item;
 	struct xfs_da3_node_hdr *hdr3 = bp->b_addr;
 	xfs_failaddr_t		fa;
 
diff --git a/fs/xfs/libxfs/xfs_dir2_block.c b/fs/xfs/libxfs/xfs_dir2_block.c
index fe951fa1a583..2da86a394bcf 100644
--- a/fs/xfs/libxfs/xfs_dir2_block.c
+++ b/fs/xfs/libxfs/xfs_dir2_block.c
@@ -103,7 +103,7 @@ xfs_dir3_block_write_verify(
 	struct xfs_buf	*bp)
 {
 	struct xfs_mount	*mp = bp->b_target->bt_mount;
-	struct xfs_buf_log_item	*bip = bp->b_fspriv;
+	struct xfs_buf_log_item	*bip = bp->b_log_item;
 	struct xfs_dir3_blk_hdr	*hdr3 = bp->b_addr;
 	xfs_failaddr_t		fa;
 
diff --git a/fs/xfs/libxfs/xfs_dir2_data.c b/fs/xfs/libxfs/xfs_dir2_data.c
index 32378122cd1f..3ddce2f9b4dc 100644
--- a/fs/xfs/libxfs/xfs_dir2_data.c
+++ b/fs/xfs/libxfs/xfs_dir2_data.c
@@ -311,7 +311,7 @@ xfs_dir3_data_write_verify(
 	struct xfs_buf	*bp)
 {
 	struct xfs_mount	*mp = bp->b_target->bt_mount;
-	struct xfs_buf_log_item	*bip = bp->b_fspriv;
+	struct xfs_buf_log_item	*bip = bp->b_log_item;
 	struct xfs_dir3_blk_hdr	*hdr3 = bp->b_addr;
 	xfs_failaddr_t		fa;
 
diff --git a/fs/xfs/libxfs/xfs_dir2_leaf.c b/fs/xfs/libxfs/xfs_dir2_leaf.c
index a7ad649398c7..d7e630f41f9c 100644
--- a/fs/xfs/libxfs/xfs_dir2_leaf.c
+++ b/fs/xfs/libxfs/xfs_dir2_leaf.c
@@ -208,7 +208,7 @@ __write_verify(
 	uint16_t	magic)
 {
 	struct xfs_mount	*mp = bp->b_target->bt_mount;
-	struct xfs_buf_log_item	*bip = bp->b_fspriv;
+	struct xfs_buf_log_item	*bip = bp->b_log_item;
 	struct xfs_dir3_leaf_hdr *hdr3 = bp->b_addr;
 	xfs_failaddr_t		fa;
 
diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
index 915c4fe5e4c3..e3056c1538e4 100644
--- a/fs/xfs/libxfs/xfs_dir2_node.c
+++ b/fs/xfs/libxfs/xfs_dir2_node.c
@@ -141,7 +141,7 @@ xfs_dir3_free_write_verify(
 	struct xfs_buf	*bp)
 {
 	struct xfs_mount	*mp = bp->b_target->bt_mount;
-	struct xfs_buf_log_item	*bip = bp->b_fspriv;
+	struct xfs_buf_log_item	*bip = bp->b_log_item;
 	struct xfs_dir3_blk_hdr	*hdr3 = bp->b_addr;
 	xfs_failaddr_t		fa;
 
diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index 1580912fe5a2..ecd8f6cb16df 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -2558,7 +2558,7 @@ xfs_agi_write_verify(
 	struct xfs_buf		*bp)
 {
 	struct xfs_mount	*mp = bp->b_target->bt_mount;
-	struct xfs_buf_log_item	*bip = bp->b_fspriv;
+	struct xfs_buf_log_item	*bip = bp->b_log_item;
 	xfs_failaddr_t		fa;
 
 	fa = xfs_agi_verify(bp);
diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index 35b005d66977..d327a188d1e6 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -674,7 +674,7 @@ xfs_sb_write_verify(
 	struct xfs_buf		*bp)
 {
 	struct xfs_mount	*mp = bp->b_target->bt_mount;
-	struct xfs_buf_log_item	*bip = bp->b_fspriv;
+	struct xfs_buf_log_item	*bip = bp->b_log_item;
 	int			error;
 
 	error = xfs_sb_verify(bp, false);
diff --git a/fs/xfs/libxfs/xfs_symlink_remote.c b/fs/xfs/libxfs/xfs_symlink_remote.c
index 091e3cf0868f..5ef5f354587e 100644
--- a/fs/xfs/libxfs/xfs_symlink_remote.c
+++ b/fs/xfs/libxfs/xfs_symlink_remote.c
@@ -149,7 +149,7 @@ xfs_symlink_write_verify(
 	struct xfs_buf	*bp)
 {
 	struct xfs_mount *mp = bp->b_target->bt_mount;
-	struct xfs_buf_log_item	*bip = bp->b_fspriv;
+	struct xfs_buf_log_item	*bip = bp->b_log_item;
 	xfs_failaddr_t		fa;
 
 	/* no verification of non-crc buffers */
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index 90f09e89cda2..21a20d91e9e9 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -176,7 +176,8 @@ struct xfs_buf {
 	struct workqueue_struct	*b_ioend_wq;	/* I/O completion wq */
 	xfs_buf_iodone_t	b_iodone;	/* I/O completion function */
 	struct completion	b_iowait;	/* queue for I/O waiters */
-	void			*b_fspriv;
+	void			*b_log_item;
+	struct xfs_log_item	*b_li_list;
 	struct xfs_trans	*b_transp;
 	struct page		**b_pages;	/* array of page pointers */
 	struct page		*b_page_array[XB_PAGES]; /* inline pages */
diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index 977a2ccc32f3..cbb88a671b3a 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -411,7 +411,7 @@ xfs_buf_item_unpin(
 	int			stale = bip->bli_flags & XFS_BLI_STALE;
 	int			freed;
 
-	ASSERT(bp->b_fspriv == bip);
+	ASSERT(bp->b_log_item == bip);
 	ASSERT(atomic_read(&bip->bli_refcount) > 0);
 
 	trace_xfs_buf_item_unpin(bip);
@@ -456,13 +456,14 @@ xfs_buf_item_unpin(
 		 */
 		if (bip->bli_flags & XFS_BLI_STALE_INODE) {
 			xfs_buf_do_callbacks(bp);
-			bp->b_fspriv = NULL;
+			bp->b_log_item = NULL;
+			bp->b_li_list = NULL;
 			bp->b_iodone = NULL;
 		} else {
 			spin_lock(&ailp->xa_lock);
 			xfs_trans_ail_delete(ailp, lip, SHUTDOWN_LOG_IO_ERROR);
 			xfs_buf_item_relse(bp);
-			ASSERT(bp->b_fspriv == NULL);
+			ASSERT(bp->b_log_item == NULL);
 		}
 		xfs_buf_relse(bp);
 	} else if (freed && remove) {
@@ -722,18 +723,15 @@ xfs_buf_item_free_format(
 
 /*
  * Allocate a new buf log item to go with the given buffer.
- * Set the buffer's b_fsprivate field to point to the new
- * buf log item.  If there are other item's attached to the
- * buffer (see xfs_buf_attach_iodone() below), then put the
- * buf log item at the front.
+ * Set the buffer's b_log_item field to point to the new
+ * buf log item.
  */
 int
 xfs_buf_item_init(
 	struct xfs_buf	*bp,
 	struct xfs_mount *mp)
 {
-	struct xfs_log_item	*lip = bp->b_fspriv;
-	struct xfs_buf_log_item	*bip;
+	struct xfs_buf_log_item	*bip = bp->b_log_item;
 	int			chunks;
 	int			map_size;
 	int			error;
@@ -741,13 +739,14 @@ xfs_buf_item_init(
 
 	/*
 	 * Check to see if there is already a buf log item for
-	 * this buffer.  If there is, it is guaranteed to be
-	 * the first.  If we do already have one, there is
+	 * this buffer. If we do already have one, there is
 	 * nothing to do here so return.
 	 */
 	ASSERT(bp->b_target->bt_mount == mp);
-	if (lip != NULL && lip->li_type == XFS_LI_BUF)
+	if (bip != NULL) {
+		ASSERT(bip->bli_item.li_type == XFS_LI_BUF);
 		return 0;
+	}
 
 	bip = kmem_zone_zalloc(xfs_buf_item_zone, KM_SLEEP);
 	xfs_log_item_init(mp, &bip->bli_item, XFS_LI_BUF, &xfs_buf_item_ops);
@@ -781,13 +780,7 @@ xfs_buf_item_init(
 		bip->bli_formats[i].blf_map_size = map_size;
 	}
 
-	/*
-	 * Put the buf item into the list of items attached to the
-	 * buffer at the front.
-	 */
-	if (bp->b_fspriv)
-		bip->bli_item.li_bio_list = bp->b_fspriv;
-	bp->b_fspriv = bip;
+	bp->b_log_item = bip;
 	xfs_buf_hold(bp);
 	return 0;
 }
@@ -961,13 +954,14 @@ void
 xfs_buf_item_relse(
 	struct xfs_buf		*bp)
 {
-	struct xfs_buf_log_item	*bip = bp->b_fspriv;
+	struct xfs_buf_log_item	*bip = bp->b_log_item;
+	struct xfs_log_item	*lip = bp->b_li_list;
 
 	trace_xfs_buf_item_relse(bp, _RET_IP_);
 	ASSERT(!(bip->bli_item.li_flags & XFS_LI_IN_AIL));
 
-	bp->b_fspriv = bip->bli_item.li_bio_list;
-	if (bp->b_fspriv == NULL)
+	bp->b_log_item = NULL;
+	if (lip == NULL)
 		bp->b_iodone = NULL;
 
 	xfs_buf_rele(bp);
@@ -980,9 +974,7 @@ xfs_buf_item_relse(
  * to be called when the buffer's I/O completes.  If it is not set
  * already, set the buffer's b_iodone() routine to be
  * xfs_buf_iodone_callbacks() and link the log item into the list of
- * items rooted at b_fsprivate.  Items are always added as the second
- * entry in the list if there is a first, because the buf item code
- * assumes that the buf log item is first.
+ * items rooted at b_li_list.
  */
 void
 xfs_buf_attach_iodone(
@@ -995,12 +987,12 @@ xfs_buf_attach_iodone(
 	ASSERT(xfs_buf_islocked(bp));
 
 	lip->li_cb = cb;
-	head_lip = bp->b_fspriv;
+	head_lip = bp->b_li_list;
 	if (head_lip) {
 		lip->li_bio_list = head_lip->li_bio_list;
 		head_lip->li_bio_list = lip;
 	} else {
-		bp->b_fspriv = lip;
+		bp->b_li_list = lip;
 	}
 
 	ASSERT(bp->b_iodone == NULL ||
@@ -1024,10 +1016,17 @@ STATIC void
 xfs_buf_do_callbacks(
 	struct xfs_buf		*bp)
 {
+	struct xfs_buf_log_item *blip = bp->b_log_item;
 	struct xfs_log_item	*lip;
 
-	while ((lip = bp->b_fspriv) != NULL) {
-		bp->b_fspriv = lip->li_bio_list;
+	/* If there is a buf_log_item attached, run its callback */
+	if (blip) {
+		lip = &blip->bli_item;
+		lip->li_cb(bp, lip);
+	}
+
+	while ((lip = bp->b_li_list) != NULL) {
+		bp->b_li_list = lip->li_bio_list;
 		ASSERT(lip->li_cb != NULL);
 		/*
 		 * Clear the next pointer so we don't have any
@@ -1052,9 +1051,19 @@ STATIC void
 xfs_buf_do_callbacks_fail(
 	struct xfs_buf		*bp)
 {
+	struct xfs_log_item	*lip = bp->b_li_list;
 	struct xfs_log_item	*next;
-	struct xfs_log_item	*lip = bp->b_fspriv;
-	struct xfs_ail		*ailp = lip->li_ailp;
+	struct xfs_ail		*ailp;
+
+	/*
+	 * Buffer log item errors are handled directly by xfs_buf_item_push()
+	 * and xfs_buf_iodone_callback_error, and they have no IO error
+	 * callbacks. Check only for items in b_li_list.
+	 */
+	if (lip == NULL)
+		return;
+	else
+		ailp = lip->li_ailp;
 
 	spin_lock(&ailp->xa_lock);
 	for (; lip; lip = next) {
@@ -1069,12 +1078,22 @@ static bool
 xfs_buf_iodone_callback_error(
 	struct xfs_buf		*bp)
 {
-	struct xfs_log_item	*lip = bp->b_fspriv;
-	struct xfs_mount	*mp = lip->li_mountp;
+	struct xfs_buf_log_item	*bip = bp->b_log_item;
+	struct xfs_log_item	*lip = bp->b_li_list;
+	struct xfs_mount	*mp;
 	static ulong		lasttime;
 	static xfs_buftarg_t	*lasttarg;
 	struct xfs_error_cfg	*cfg;
 
+	/*
+	 * The failed buffer might not have a buf_log_item attached or the
+	 * log_item list might be empty. Get the mp from the available xfs_log_item
+	 */
+	if (bip == NULL)
+		mp = lip->li_mountp;
+	else
+		mp = bip->bli_item.li_mountp;
+
 	/*
 	 * If we've already decided to shutdown the filesystem because of
 	 * I/O errors, there's no point in giving this a retry.
@@ -1183,7 +1202,8 @@ xfs_buf_iodone_callbacks(
 	bp->b_first_retry_time = 0;
 
 	xfs_buf_do_callbacks(bp);
-	bp->b_fspriv = NULL;
+	bp->b_log_item = NULL;
+	bp->b_li_list = NULL;
 	bp->b_iodone = NULL;
 	xfs_buf_ioend(bp);
 }
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 54277beb2a3d..0a4c2e48402f 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2272,7 +2272,7 @@ xfs_ifree_cluster(
 		 * stale first, we will not attempt to lock them in the loop
 		 * below as the XFS_ISTALE flag will be set.
 		 */
-		lip = bp->b_fspriv;
+		lip = bp->b_li_list;
 		while (lip) {
 			if (lip->li_type == XFS_LI_INODE) {
 				iip = (xfs_inode_log_item_t *)lip;
@@ -3649,7 +3649,7 @@ xfs_iflush_int(
 	/* generate the checksum. */
 	xfs_dinode_calc_crc(mp, dip);
 
-	ASSERT(bp->b_fspriv != NULL);
+	ASSERT(bp->b_li_list != NULL);
 	ASSERT(bp->b_iodone != NULL);
 	return 0;
 
diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index 6ee5c3bf19ad..993736032b4b 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -722,7 +722,7 @@ xfs_iflush_done(
 	 * Scan the buffer IO completions for other inodes being completed and
 	 * attach them to the current inode log item.
 	 */
-	blip = bp->b_fspriv;
+	blip = bp->b_li_list;
 	prev = NULL;
 	while (blip != NULL) {
 		if (blip->li_cb != xfs_iflush_done) {
@@ -734,7 +734,7 @@ xfs_iflush_done(
 		/* remove from list */
 		next = blip->li_bio_list;
 		if (!prev) {
-			bp->b_fspriv = next;
+			bp->b_li_list = next;
 		} else {
 			prev->li_bio_list = next;
 		}
diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 3df424328ae3..861c84e1f674 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1243,7 +1243,7 @@ static void
 xlog_iodone(
 	struct xfs_buf		*bp)
 {
-	struct xlog_in_core	*iclog = bp->b_fspriv;
+	struct xlog_in_core	*iclog = bp->b_log_item;
 	struct xlog		*l = iclog->ic_log;
 	int			aborted = 0;
 
@@ -1774,7 +1774,7 @@ STATIC int
 xlog_bdstrat(
 	struct xfs_buf		*bp)
 {
-	struct xlog_in_core	*iclog = bp->b_fspriv;
+	struct xlog_in_core	*iclog = bp->b_log_item;
 
 	xfs_buf_lock(bp);
 	if (iclog->ic_state & XLOG_STATE_IOERROR) {
@@ -1920,7 +1920,7 @@ xlog_sync(
 	}
 
 	bp->b_io_length = BTOBB(count);
-	bp->b_fspriv = iclog;
+	bp->b_log_item = iclog;
 	bp->b_flags &= ~XBF_FLUSH;
 	bp->b_flags |= (XBF_ASYNC | XBF_SYNCIO | XBF_WRITE | XBF_FUA);
 
@@ -1959,7 +1959,7 @@ xlog_sync(
 		XFS_BUF_SET_ADDR(bp, 0);	     /* logical 0 */
 		xfs_buf_associate_memory(bp,
 				(char *)&iclog->ic_header + count, split);
-		bp->b_fspriv = iclog;
+		bp->b_log_item = iclog;
 		bp->b_flags &= ~XBF_FLUSH;
 		bp->b_flags |= (XBF_ASYNC | XBF_SYNCIO | XBF_WRITE | XBF_FUA);
 
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 14bf1bdcd3bc..846c3b152e41 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -400,9 +400,9 @@ xlog_recover_iodone(
 	 * On v5 supers, a bli could be attached to update the metadata LSN.
 	 * Clean it up.
 	 */
-	if (bp->b_fspriv)
+	if (bp->b_log_item)
 		xfs_buf_item_relse(bp);
-	ASSERT(bp->b_fspriv == NULL);
+	ASSERT(bp->b_log_item == NULL);
 
 	bp->b_iodone = NULL;
 	xfs_buf_ioend(bp);
@@ -2630,7 +2630,7 @@ xlog_recover_validate_buf_type(
 		ASSERT(!bp->b_iodone || bp->b_iodone == xlog_recover_iodone);
 		bp->b_iodone = xlog_recover_iodone;
 		xfs_buf_item_init(bp, mp);
-		bip = bp->b_fspriv;
+		bip = bp->b_log_item;
 		bip->bli_item.li_lsn = current_lsn;
 	}
 }
diff --git a/fs/xfs/xfs_trans_buf.c b/fs/xfs/xfs_trans_buf.c
index 5359c4bd95e8..ffe344b6e5d2 100644
--- a/fs/xfs/xfs_trans_buf.c
+++ b/fs/xfs/xfs_trans_buf.c
@@ -82,12 +82,12 @@ _xfs_trans_bjoin(
 	ASSERT(bp->b_transp == NULL);
 
 	/*
-	 * The xfs_buf_log_item pointer is stored in b_fsprivate.  If
+	 * The xfs_buf_log_item pointer is stored in b_log_item.  If
 	 * it doesn't have one yet, then allocate one and initialize it.
 	 * The checks to see if one is there are in xfs_buf_item_init().
 	 */
 	xfs_buf_item_init(bp, tp->t_mountp);
-	bip = bp->b_fspriv;
+	bip = bp->b_log_item;
 	ASSERT(!(bip->bli_flags & XFS_BLI_STALE));
 	ASSERT(!(bip->__bli_format.blf_flags & XFS_BLF_CANCEL));
 	ASSERT(!(bip->bli_flags & XFS_BLI_LOGGED));
@@ -118,7 +118,7 @@ xfs_trans_bjoin(
 	struct xfs_buf		*bp)
 {
 	_xfs_trans_bjoin(tp, bp, 0);
-	trace_xfs_trans_bjoin(bp->b_fspriv);
+	trace_xfs_trans_bjoin(bp->b_log_item);
 }
 
 /*
@@ -159,7 +159,7 @@ xfs_trans_get_buf_map(
 		}
 
 		ASSERT(bp->b_transp == tp);
-		bip = bp->b_fspriv;
+		bip = bp->b_log_item;
 		ASSERT(bip != NULL);
 		ASSERT(atomic_read(&bip->bli_refcount) > 0);
 		bip->bli_recur++;
@@ -175,7 +175,7 @@ xfs_trans_get_buf_map(
 	ASSERT(!bp->b_error);
 
 	_xfs_trans_bjoin(tp, bp, 1);
-	trace_xfs_trans_get_buf(bp->b_fspriv);
+	trace_xfs_trans_get_buf(bp->b_log_item);
 	return bp;
 }
 
@@ -211,7 +211,7 @@ xfs_trans_getsb(
 	 */
 	bp = mp->m_sb_bp;
 	if (bp->b_transp == tp) {
-		bip = bp->b_fspriv;
+		bip = bp->b_log_item;
 		ASSERT(bip != NULL);
 		ASSERT(atomic_read(&bip->bli_refcount) > 0);
 		bip->bli_recur++;
@@ -224,7 +224,7 @@ xfs_trans_getsb(
 		return NULL;
 
 	_xfs_trans_bjoin(tp, bp, 1);
-	trace_xfs_trans_getsb(bp->b_fspriv);
+	trace_xfs_trans_getsb(bp->b_log_item);
 	return bp;
 }
 
@@ -267,7 +267,7 @@ xfs_trans_read_buf_map(
 	if (bp) {
 		ASSERT(xfs_buf_islocked(bp));
 		ASSERT(bp->b_transp == tp);
-		ASSERT(bp->b_fspriv != NULL);
+		ASSERT(bp->b_log_item != NULL);
 		ASSERT(!bp->b_error);
 		ASSERT(bp->b_flags & XBF_DONE);
 
@@ -280,7 +280,7 @@ xfs_trans_read_buf_map(
 			return -EIO;
 		}
 
-		bip = bp->b_fspriv;
+		bip = bp->b_log_item;
 		bip->bli_recur++;
 
 		ASSERT(atomic_read(&bip->bli_refcount) > 0);
@@ -330,7 +330,7 @@ xfs_trans_read_buf_map(
 
 	if (tp) {
 		_xfs_trans_bjoin(tp, bp, 1);
-		trace_xfs_trans_read_buf(bp->b_fspriv);
+		trace_xfs_trans_read_buf(bp->b_log_item);
 	}
 	*bpp = bp;
 	return 0;
@@ -370,7 +370,7 @@ xfs_trans_brelse(
 	}
 
 	ASSERT(bp->b_transp == tp);
-	bip = bp->b_fspriv;
+	bip = bp->b_log_item;
 	ASSERT(bip->bli_item.li_type == XFS_LI_BUF);
 	ASSERT(!(bip->bli_flags & XFS_BLI_STALE));
 	ASSERT(!(bip->__bli_format.blf_flags & XFS_BLF_CANCEL));
@@ -462,7 +462,7 @@ xfs_trans_bhold(
 	xfs_trans_t		*tp,
 	struct xfs_buf		*bp)
 {
-	struct xfs_buf_log_item	*bip = bp->b_fspriv;
+	struct xfs_buf_log_item	*bip = bp->b_log_item;
 
 	ASSERT(bp->b_transp == tp);
 	ASSERT(bip != NULL);
@@ -483,7 +483,7 @@ xfs_trans_bhold_release(
 	xfs_trans_t		*tp,
 	struct xfs_buf		*bp)
 {
-	struct xfs_buf_log_item	*bip = bp->b_fspriv;
+	struct xfs_buf_log_item	*bip = bp->b_log_item;
 
 	ASSERT(bp->b_transp == tp);
 	ASSERT(bip != NULL);
@@ -504,7 +504,7 @@ xfs_trans_dirty_buf(
 	struct xfs_trans	*tp,
 	struct xfs_buf		*bp)
 {
-	struct xfs_buf_log_item	*bip = bp->b_fspriv;
+	struct xfs_buf_log_item	*bip = bp->b_log_item;
 
 	ASSERT(bp->b_transp == tp);
 	ASSERT(bip != NULL);
@@ -561,7 +561,7 @@ xfs_trans_log_buf(
 	uint			first,
 	uint			last)
 {
-	struct xfs_buf_log_item	*bip = bp->b_fspriv;
+	struct xfs_buf_log_item	*bip = bp->b_log_item;
 
 	ASSERT(first <= last && last < BBTOB(bp->b_length));
 	ASSERT(!(bip->bli_flags & XFS_BLI_ORDERED));
@@ -607,7 +607,7 @@ xfs_trans_binval(
 	xfs_trans_t		*tp,
 	struct xfs_buf		*bp)
 {
-	struct xfs_buf_log_item	*bip = bp->b_fspriv;
+	struct xfs_buf_log_item	*bip = bp->b_log_item;
 	int			i;
 
 	ASSERT(bp->b_transp == tp);
@@ -662,7 +662,7 @@ xfs_trans_inode_buf(
 	xfs_trans_t		*tp,
 	struct xfs_buf		*bp)
 {
-	struct xfs_buf_log_item	*bip = bp->b_fspriv;
+	struct xfs_buf_log_item	*bip = bp->b_log_item;
 
 	ASSERT(bp->b_transp == tp);
 	ASSERT(bip != NULL);
@@ -686,7 +686,7 @@ xfs_trans_stale_inode_buf(
 	xfs_trans_t		*tp,
 	struct xfs_buf		*bp)
 {
-	struct xfs_buf_log_item	*bip = bp->b_fspriv;
+	struct xfs_buf_log_item	*bip = bp->b_log_item;
 
 	ASSERT(bp->b_transp == tp);
 	ASSERT(bip != NULL);
@@ -711,7 +711,7 @@ xfs_trans_inode_alloc_buf(
 	xfs_trans_t		*tp,
 	struct xfs_buf		*bp)
 {
-	struct xfs_buf_log_item	*bip = bp->b_fspriv;
+	struct xfs_buf_log_item	*bip = bp->b_log_item;
 
 	ASSERT(bp->b_transp == tp);
 	ASSERT(bip != NULL);
@@ -733,7 +733,7 @@ xfs_trans_ordered_buf(
 	struct xfs_trans	*tp,
 	struct xfs_buf		*bp)
 {
-	struct xfs_buf_log_item	*bip = bp->b_fspriv;
+	struct xfs_buf_log_item	*bip = bp->b_log_item;
 
 	ASSERT(bp->b_transp == tp);
 	ASSERT(bip != NULL);
@@ -763,7 +763,7 @@ xfs_trans_buf_set_type(
 	struct xfs_buf		*bp,
 	enum xfs_blft		type)
 {
-	struct xfs_buf_log_item	*bip = bp->b_fspriv;
+	struct xfs_buf_log_item	*bip = bp->b_log_item;
 
 	if (!tp)
 		return;
@@ -780,8 +780,8 @@ xfs_trans_buf_copy_type(
 	struct xfs_buf		*dst_bp,
 	struct xfs_buf		*src_bp)
 {
-	struct xfs_buf_log_item	*sbip = src_bp->b_fspriv;
-	struct xfs_buf_log_item	*dbip = dst_bp->b_fspriv;
+	struct xfs_buf_log_item	*sbip = src_bp->b_log_item;
+	struct xfs_buf_log_item	*dbip = dst_bp->b_log_item;
 	enum xfs_blft		type;
 
 	type = xfs_blft_from_flags(&sbip->__bli_format);
@@ -805,7 +805,7 @@ xfs_trans_dquot_buf(
 	struct xfs_buf		*bp,
 	uint			type)
 {
-	struct xfs_buf_log_item	*bip = bp->b_fspriv;
+	struct xfs_buf_log_item	*bip = bp->b_log_item;
 
 	ASSERT(type == XFS_BLF_UDQUOT_BUF ||
 	       type == XFS_BLF_PDQUOT_BUF ||
-- 
2.14.3

