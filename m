Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:57474 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727472AbfFMSD0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 13 Jun 2019 14:03:26 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 10/20] xfs: remove the xfs_log_item_t typedef
Date: Thu, 13 Jun 2019 20:02:50 +0200
Message-Id: <20190613180300.30447-11-hch@lst.de>
In-Reply-To: <20190613180300.30447-1-hch@lst.de>
References: <20190613180300.30447-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Brian Foster <bfoster@redhat.com>

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_buf_item.c     |  6 +++---
 fs/xfs/xfs_buf_item.h     |  6 +++---
 fs/xfs/xfs_dquot_item.h   |  4 ++--
 fs/xfs/xfs_extfree_item.h |  4 ++--
 fs/xfs/xfs_inode.c        | 12 +++++------
 fs/xfs/xfs_inode_item.h   |  2 +-
 fs/xfs/xfs_log_recover.c  |  2 +-
 fs/xfs/xfs_trans.h        | 16 +++++++-------
 fs/xfs/xfs_trans_ail.c    | 44 +++++++++++++++++++--------------------
 9 files changed, 48 insertions(+), 48 deletions(-)

diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index dc98d669884e..ddeabb7ff18a 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -981,9 +981,9 @@ xfs_buf_item_relse(
  */
 void
 xfs_buf_attach_iodone(
-	xfs_buf_t	*bp,
-	void		(*cb)(xfs_buf_t *, xfs_log_item_t *),
-	xfs_log_item_t	*lip)
+	struct xfs_buf		*bp,
+	void			(*cb)(struct xfs_buf *, struct xfs_log_item *),
+	struct xfs_log_item	*lip)
 {
 	ASSERT(xfs_buf_islocked(bp));
 
diff --git a/fs/xfs/xfs_buf_item.h b/fs/xfs/xfs_buf_item.h
index 90f65f891fab..4a054b11011a 100644
--- a/fs/xfs/xfs_buf_item.h
+++ b/fs/xfs/xfs_buf_item.h
@@ -39,7 +39,7 @@ struct xfs_buf_log_item;
  * locked, and which 128 byte chunks of the buffer are dirty.
  */
 struct xfs_buf_log_item {
-	xfs_log_item_t		bli_item;	/* common item structure */
+	struct xfs_log_item	bli_item;	/* common item structure */
 	struct xfs_buf		*bli_buf;	/* real buffer pointer */
 	unsigned int		bli_flags;	/* misc flags */
 	unsigned int		bli_recur;	/* lock recursion count */
@@ -55,8 +55,8 @@ bool	xfs_buf_item_put(struct xfs_buf_log_item *);
 void	xfs_buf_item_log(struct xfs_buf_log_item *, uint, uint);
 bool	xfs_buf_item_dirty_format(struct xfs_buf_log_item *);
 void	xfs_buf_attach_iodone(struct xfs_buf *,
-			      void(*)(struct xfs_buf *, xfs_log_item_t *),
-			      xfs_log_item_t *);
+			      void(*)(struct xfs_buf *, struct xfs_log_item *),
+			      struct xfs_log_item *);
 void	xfs_buf_iodone_callbacks(struct xfs_buf *);
 void	xfs_buf_iodone(struct xfs_buf *, struct xfs_log_item *);
 bool	xfs_buf_resubmit_failed_buffers(struct xfs_buf *,
diff --git a/fs/xfs/xfs_dquot_item.h b/fs/xfs/xfs_dquot_item.h
index db9df710a308..1aed34ccdabc 100644
--- a/fs/xfs/xfs_dquot_item.h
+++ b/fs/xfs/xfs_dquot_item.h
@@ -12,13 +12,13 @@ struct xfs_mount;
 struct xfs_qoff_logitem;
 
 typedef struct xfs_dq_logitem {
-	xfs_log_item_t		 qli_item;	   /* common portion */
+	struct xfs_log_item	 qli_item;	   /* common portion */
 	struct xfs_dquot	*qli_dquot;	   /* dquot ptr */
 	xfs_lsn_t		 qli_flush_lsn;	   /* lsn at last flush */
 } xfs_dq_logitem_t;
 
 typedef struct xfs_qoff_logitem {
-	xfs_log_item_t		 qql_item;	/* common portion */
+	struct xfs_log_item	 qql_item;	/* common portion */
 	struct xfs_qoff_logitem *qql_start_lip; /* qoff-start logitem, if any */
 	unsigned int		qql_flags;
 } xfs_qoff_logitem_t;
diff --git a/fs/xfs/xfs_extfree_item.h b/fs/xfs/xfs_extfree_item.h
index 2a6a895ca73e..b0dc4ebe8892 100644
--- a/fs/xfs/xfs_extfree_item.h
+++ b/fs/xfs/xfs_extfree_item.h
@@ -51,7 +51,7 @@ struct kmem_zone;
  * AIL, so at this point both the EFI and EFD are freed.
  */
 typedef struct xfs_efi_log_item {
-	xfs_log_item_t		efi_item;
+	struct xfs_log_item	efi_item;
 	atomic_t		efi_refcount;
 	atomic_t		efi_next_extent;
 	unsigned long		efi_flags;	/* misc flags */
@@ -64,7 +64,7 @@ typedef struct xfs_efi_log_item {
  * have been freed.
  */
 typedef struct xfs_efd_log_item {
-	xfs_log_item_t		efd_item;
+	struct xfs_log_item	efd_item;
 	xfs_efi_log_item_t	*efd_efip;
 	uint			efd_next_extent;
 	xfs_efd_log_format_t	efd_format;
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 419eae485ff3..6076bae6eb21 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -441,12 +441,12 @@ xfs_lock_inumorder(int lock_mode, int subclass)
  */
 static void
 xfs_lock_inodes(
-	xfs_inode_t	**ips,
-	int		inodes,
-	uint		lock_mode)
+	struct xfs_inode	**ips,
+	int			inodes,
+	uint			lock_mode)
 {
-	int		attempts = 0, i, j, try_lock;
-	xfs_log_item_t	*lp;
+	int			attempts = 0, i, j, try_lock;
+	struct xfs_log_item	*lp;
 
 	/*
 	 * Currently supports between 2 and 5 inodes with exclusive locking.  We
@@ -551,7 +551,7 @@ xfs_lock_two_inodes(
 	struct xfs_inode	*temp;
 	uint			mode_temp;
 	int			attempts = 0;
-	xfs_log_item_t		*lp;
+	struct xfs_log_item	*lp;
 
 	ASSERT(hweight32(ip0_mode) == 1);
 	ASSERT(hweight32(ip1_mode) == 1);
diff --git a/fs/xfs/xfs_inode_item.h b/fs/xfs/xfs_inode_item.h
index 27081eba220c..07a60e74c39c 100644
--- a/fs/xfs/xfs_inode_item.h
+++ b/fs/xfs/xfs_inode_item.h
@@ -14,7 +14,7 @@ struct xfs_inode;
 struct xfs_mount;
 
 typedef struct xfs_inode_log_item {
-	xfs_log_item_t		ili_item;	   /* common portion */
+	struct xfs_log_item	ili_item;	   /* common portion */
 	struct xfs_inode	*ili_inode;	   /* inode ptr */
 	xfs_lsn_t		ili_flush_lsn;	   /* lsn at last flush */
 	xfs_lsn_t		ili_last_lsn;	   /* lsn at last transaction */
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index b03921b0548a..8e385ee5a142 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -3385,7 +3385,7 @@ xlog_recover_efd_pass2(
 {
 	xfs_efd_log_format_t	*efd_formatp;
 	xfs_efi_log_item_t	*efip = NULL;
-	xfs_log_item_t		*lip;
+	struct xfs_log_item	*lip;
 	uint64_t		efi_id;
 	struct xfs_ail_cursor	cur;
 	struct xfs_ail		*ailp = log->l_ailp;
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index 1eeaefd3c65d..f75042bdd2ea 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -27,7 +27,7 @@ struct xfs_cud_log_item;
 struct xfs_bui_log_item;
 struct xfs_bud_log_item;
 
-typedef struct xfs_log_item {
+struct xfs_log_item {
 	struct list_head		li_ail;		/* AIL pointers */
 	struct list_head		li_trans;	/* transaction list */
 	xfs_lsn_t			li_lsn;		/* last on-disk lsn */
@@ -48,7 +48,7 @@ typedef struct xfs_log_item {
 	struct xfs_log_vec		*li_lv;		/* active log vector */
 	struct xfs_log_vec		*li_lv_shadow;	/* standby vector */
 	xfs_lsn_t			li_seq;		/* CIL commit seq */
-} xfs_log_item_t;
+};
 
 /*
  * li_flags use the (set/test/clear)_bit atomic interfaces because updates can
@@ -68,15 +68,15 @@ typedef struct xfs_log_item {
 
 struct xfs_item_ops {
 	unsigned flags;
-	void (*iop_size)(xfs_log_item_t *, int *, int *);
-	void (*iop_format)(xfs_log_item_t *, struct xfs_log_vec *);
-	void (*iop_pin)(xfs_log_item_t *);
-	void (*iop_unpin)(xfs_log_item_t *, int remove);
+	void (*iop_size)(struct xfs_log_item *, int *, int *);
+	void (*iop_format)(struct xfs_log_item *, struct xfs_log_vec *);
+	void (*iop_pin)(struct xfs_log_item *);
+	void (*iop_unpin)(struct xfs_log_item *, int remove);
 	uint (*iop_push)(struct xfs_log_item *, struct list_head *);
 	void (*iop_committing)(struct xfs_log_item *, xfs_lsn_t commit_lsn);
 	void (*iop_release)(struct xfs_log_item *);
-	xfs_lsn_t (*iop_committed)(xfs_log_item_t *, xfs_lsn_t);
-	void (*iop_error)(xfs_log_item_t *, xfs_buf_t *);
+	xfs_lsn_t (*iop_committed)(struct xfs_log_item *, xfs_lsn_t);
+	void (*iop_error)(struct xfs_log_item *, xfs_buf_t *);
 };
 
 /*
diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
index a3ea5d25b0f9..19f800b9e592 100644
--- a/fs/xfs/xfs_trans_ail.c
+++ b/fs/xfs/xfs_trans_ail.c
@@ -74,29 +74,29 @@ xfs_ail_check(
  * Return a pointer to the last item in the AIL.  If the AIL is empty, then
  * return NULL.
  */
-static xfs_log_item_t *
+static struct xfs_log_item *
 xfs_ail_max(
 	struct xfs_ail  *ailp)
 {
 	if (list_empty(&ailp->ail_head))
 		return NULL;
 
-	return list_entry(ailp->ail_head.prev, xfs_log_item_t, li_ail);
+	return list_entry(ailp->ail_head.prev, struct xfs_log_item, li_ail);
 }
 
 /*
  * Return a pointer to the item which follows the given item in the AIL.  If
  * the given item is the last item in the list, then return NULL.
  */
-static xfs_log_item_t *
+static struct xfs_log_item *
 xfs_ail_next(
-	struct xfs_ail  *ailp,
-	xfs_log_item_t  *lip)
+	struct xfs_ail		*ailp,
+	struct xfs_log_item	*lip)
 {
 	if (lip->li_ail.next == &ailp->ail_head)
 		return NULL;
 
-	return list_first_entry(&lip->li_ail, xfs_log_item_t, li_ail);
+	return list_first_entry(&lip->li_ail, struct xfs_log_item, li_ail);
 }
 
 /*
@@ -109,10 +109,10 @@ xfs_ail_next(
  */
 xfs_lsn_t
 xfs_ail_min_lsn(
-	struct xfs_ail	*ailp)
+	struct xfs_ail		*ailp)
 {
-	xfs_lsn_t	lsn = 0;
-	xfs_log_item_t	*lip;
+	xfs_lsn_t		lsn = 0;
+	struct xfs_log_item	*lip;
 
 	spin_lock(&ailp->ail_lock);
 	lip = xfs_ail_min(ailp);
@@ -128,10 +128,10 @@ xfs_ail_min_lsn(
  */
 static xfs_lsn_t
 xfs_ail_max_lsn(
-	struct xfs_ail  *ailp)
+	struct xfs_ail		*ailp)
 {
-	xfs_lsn_t       lsn = 0;
-	xfs_log_item_t  *lip;
+	xfs_lsn_t       	lsn = 0;
+	struct xfs_log_item	*lip;
 
 	spin_lock(&ailp->ail_lock);
 	lip = xfs_ail_max(ailp);
@@ -216,13 +216,13 @@ xfs_trans_ail_cursor_clear(
  * ascending traversal.  Pass a @lsn of zero to initialise the cursor to the
  * first item in the AIL. Returns NULL if the list is empty.
  */
-xfs_log_item_t *
+struct xfs_log_item *
 xfs_trans_ail_cursor_first(
 	struct xfs_ail		*ailp,
 	struct xfs_ail_cursor	*cur,
 	xfs_lsn_t		lsn)
 {
-	xfs_log_item_t		*lip;
+	struct xfs_log_item	*lip;
 
 	xfs_trans_ail_cursor_init(ailp, cur);
 
@@ -248,7 +248,7 @@ __xfs_trans_ail_cursor_last(
 	struct xfs_ail		*ailp,
 	xfs_lsn_t		lsn)
 {
-	xfs_log_item_t		*lip;
+	struct xfs_log_item	*lip;
 
 	list_for_each_entry_reverse(lip, &ailp->ail_head, li_ail) {
 		if (XFS_LSN_CMP(lip->li_lsn, lsn) <= 0)
@@ -327,8 +327,8 @@ xfs_ail_splice(
  */
 static void
 xfs_ail_delete(
-	struct xfs_ail  *ailp,
-	xfs_log_item_t  *lip)
+	struct xfs_ail		*ailp,
+	struct xfs_log_item	*lip)
 {
 	xfs_ail_check(ailp, lip);
 	list_del(&lip->li_ail);
@@ -364,7 +364,7 @@ xfsaild_push(
 {
 	xfs_mount_t		*mp = ailp->ail_mount;
 	struct xfs_ail_cursor	cur;
-	xfs_log_item_t		*lip;
+	struct xfs_log_item	*lip;
 	xfs_lsn_t		lsn;
 	xfs_lsn_t		target;
 	long			tout;
@@ -619,10 +619,10 @@ xfsaild(
  */
 void
 xfs_ail_push(
-	struct xfs_ail	*ailp,
-	xfs_lsn_t	threshold_lsn)
+	struct xfs_ail		*ailp,
+	xfs_lsn_t		threshold_lsn)
 {
-	xfs_log_item_t	*lip;
+	struct xfs_log_item	*lip;
 
 	lip = xfs_ail_min(ailp);
 	if (!lip || XFS_FORCED_SHUTDOWN(ailp->ail_mount) ||
@@ -707,7 +707,7 @@ xfs_trans_ail_update_bulk(
 	int			nr_items,
 	xfs_lsn_t		lsn) __releases(ailp->ail_lock)
 {
-	xfs_log_item_t		*mlip;
+	struct xfs_log_item	*mlip;
 	int			mlip_changed = 0;
 	int			i;
 	LIST_HEAD(tmp);
-- 
2.20.1
