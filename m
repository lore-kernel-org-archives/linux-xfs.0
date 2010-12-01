Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oB1M5SwK236339 for <xfs@oss.sgi.com>; Wed, 1 Dec 2010 16:05:30 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E14C91609CBA
	for <xfs@oss.sgi.com>; Wed,  1 Dec 2010 14:07:11 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id HARdAZMiDfS4nfQr for
	<xfs@oss.sgi.com>; Wed, 01 Dec 2010 14:07:11 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.72 #1 (Red Hat
	Linux)) id 1PNupS-0007nF-9h
	for xfs@oss.sgi.com; Wed, 01 Dec 2010 22:07:10 +0000
Message-Id: <20101201220710.254521341@bombadil.infradead.org>
Date: Wed, 01 Dec 2010 17:06:22 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 2/4] xfs: use struct list_head for the buf cancel table
References: <20101201220620.340188389@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-buf-cancel-list_head
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

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/xfs_buf_item.h
===================================================================
--- xfs.orig/fs/xfs/xfs_buf_item.h	2010-11-29 16:33:20.473005032 +0100
+++ xfs/fs/xfs/xfs_buf_item.h	2010-11-29 17:26:52.384003914 +0100
@@ -105,17 +105,6 @@ typedef struct xfs_buf_log_item {
 	xfs_buf_log_format_t	bli_format;	/* in-log header */
 } xfs_buf_log_item_t;
 
-/*
- * This structure is used during recovery to record the buf log
- * items which have been canceled and should not be replayed.
- */
-typedef struct xfs_buf_cancel {
-	xfs_daddr_t		bc_blkno;
-	uint			bc_len;
-	int			bc_refcount;
-	struct xfs_buf_cancel	*bc_next;
-} xfs_buf_cancel_t;
-
 void	xfs_buf_item_init(struct xfs_buf *, struct xfs_mount *);
 void	xfs_buf_item_relse(struct xfs_buf *);
 void	xfs_buf_item_log(xfs_buf_log_item_t *, uint, uint);
Index: xfs/fs/xfs/xfs_log_priv.h
===================================================================
--- xfs.orig/fs/xfs/xfs_log_priv.h	2010-11-29 16:33:20.486010899 +0100
+++ xfs/fs/xfs/xfs_log_priv.h	2010-11-29 17:26:52.385003145 +0100
@@ -21,7 +21,6 @@
 struct xfs_buf;
 struct log;
 struct xlog_ticket;
-struct xfs_buf_cancel;
 struct xfs_mount;
 
 /*
@@ -491,7 +490,7 @@ typedef struct log {
 	struct xfs_buftarg	*l_targ;        /* buftarg of log */
 	uint			l_flags;
 	uint			l_quotaoffs_flag; /* XFS_DQ_*, for QUOTAOFFs */
-	struct xfs_buf_cancel	**l_buf_cancel_table;
+	struct list_head	*l_buf_cancel_table;
 	int			l_iclog_hsize;  /* size of iclog header */
 	int			l_iclog_heads;  /* # of iclog header sectors */
 	uint			l_sectBBsize;   /* sector size in BBs (2^n) */
@@ -534,6 +533,9 @@ typedef struct log {
 
 } xlog_t;
 
+#define XLOG_BUF_CANCEL_BUCKET(log, blkno) \
+	((log)->l_buf_cancel_table + ((__uint64_t)blkno % XLOG_BC_TABLE_SIZE))
+
 #define XLOG_FORCED_SHUTDOWN(log)	((log)->l_flags & XLOG_IO_ERROR)
 
 /* common routines */
Index: xfs/fs/xfs/xfs_log_recover.c
===================================================================
--- xfs.orig/fs/xfs/xfs_log_recover.c	2010-11-29 16:33:20.495004054 +0100
+++ xfs/fs/xfs/xfs_log_recover.c	2010-11-29 17:31:12.135004894 +0100
@@ -53,6 +53,17 @@ STATIC void	xlog_recover_check_summary(x
 #endif
 
 /*
+ * This structure is used during recovery to record the buf log items which
+ * have been canceled and should not be replayed.
+ */
+struct xfs_buf_cancel {
+	xfs_daddr_t		bc_blkno;
+	uint			bc_len;
+	int			bc_refcount;
+	struct list_head	bc_list;
+};
+
+/*
  * Sector aligned buffer routines for buffer create/read/write/access
  */
 
@@ -1607,15 +1618,11 @@ xlog_recover_reorder_trans(
  */
 STATIC void
 xlog_recover_do_buffer_pass1(
-	xlog_t			*log,
+	struct log		*log,
 	xfs_buf_log_format_t	*buf_f)
 {
-	xfs_buf_cancel_t	*bcp;
-	xfs_buf_cancel_t	*nextp;
-	xfs_buf_cancel_t	*prevp;
-	xfs_buf_cancel_t	**bucket;
-	xfs_daddr_t		blkno = buf_f->blf_blkno;
-	uint			len = buf_f->blf_len;
+	struct list_head	*bucket;
+	struct xfs_buf_cancel	*bcp;
 
 	/*
 	 * If this isn't a cancel buffer item, then just return.
@@ -1626,51 +1633,25 @@ xlog_recover_do_buffer_pass1(
 	}
 
 	/*
-	 * Insert an xfs_buf_cancel record into the hash table of
-	 * them.  If there is already an identical record, bump
-	 * its reference count.
-	 */
-	bucket = &log->l_buf_cancel_table[(__uint64_t)blkno %
-					  XLOG_BC_TABLE_SIZE];
-	/*
-	 * If the hash bucket is empty then just insert a new record into
-	 * the bucket.
-	 */
-	if (*bucket == NULL) {
-		bcp = (xfs_buf_cancel_t *)kmem_alloc(sizeof(xfs_buf_cancel_t),
-						     KM_SLEEP);
-		bcp->bc_blkno = blkno;
-		bcp->bc_len = len;
-		bcp->bc_refcount = 1;
-		bcp->bc_next = NULL;
-		*bucket = bcp;
-		return;
-	}
-
-	/*
-	 * The hash bucket is not empty, so search for duplicates of our
-	 * record.  If we find one them just bump its refcount.  If not
-	 * then add us at the end of the list.
-	 */
-	prevp = NULL;
-	nextp = *bucket;
-	while (nextp != NULL) {
-		if (nextp->bc_blkno == blkno && nextp->bc_len == len) {
-			nextp->bc_refcount++;
+	 * Insert an xfs_buf_cancel record into the hash table of them.
+	 * If there is already an identical record, bump its reference count.
+	 */
+	bucket = XLOG_BUF_CANCEL_BUCKET(log, buf_f->blf_blkno);
+	list_for_each_entry(bcp, bucket, bc_list) {
+		if (bcp->bc_blkno == buf_f->blf_blkno &&
+		    bcp->bc_len == buf_f->blf_len) {
+			bcp->bc_refcount++;
 			trace_xfs_log_recover_buf_cancel_ref_inc(log, buf_f);
 			return;
 		}
-		prevp = nextp;
-		nextp = nextp->bc_next;
 	}
-	ASSERT(prevp != NULL);
-	bcp = (xfs_buf_cancel_t *)kmem_alloc(sizeof(xfs_buf_cancel_t),
-					     KM_SLEEP);
-	bcp->bc_blkno = blkno;
-	bcp->bc_len = len;
+
+	bcp = kmem_alloc(sizeof(struct xfs_buf_cancel), KM_SLEEP);
+	bcp->bc_blkno = buf_f->blf_blkno;
+	bcp->bc_len = buf_f->blf_len;
 	bcp->bc_refcount = 1;
-	bcp->bc_next = NULL;
-	prevp->bc_next = bcp;
+	list_add_tail(&bcp->bc_list, bucket);
+
 	trace_xfs_log_recover_buf_cancel_add(log, buf_f);
 }
 
@@ -1689,14 +1670,13 @@ xlog_recover_do_buffer_pass1(
  */
 STATIC int
 xlog_check_buffer_cancelled(
-	xlog_t			*log,
+	struct log		*log,
 	xfs_daddr_t		blkno,
 	uint			len,
 	ushort			flags)
 {
-	xfs_buf_cancel_t	*bcp;
-	xfs_buf_cancel_t	*prevp;
-	xfs_buf_cancel_t	**bucket;
+	struct list_head	*bucket;
+	struct xfs_buf_cancel	*bcp;
 
 	if (log->l_buf_cancel_table == NULL) {
 		/*
@@ -1707,55 +1687,36 @@ xlog_check_buffer_cancelled(
 		return 0;
 	}
 
-	bucket = &log->l_buf_cancel_table[(__uint64_t)blkno %
-					  XLOG_BC_TABLE_SIZE];
-	bcp = *bucket;
-	if (bcp == NULL) {
-		/*
-		 * There is no corresponding entry in the table built
-		 * in pass one, so this buffer has not been cancelled.
-		 */
-		ASSERT(!(flags & XFS_BLF_CANCEL));
-		return 0;
-	}
-
 	/*
-	 * Search for an entry in the buffer cancel table that
-	 * matches our buffer.
+	 * Search for an entry in the  cancel table that matches our buffer.
 	 */
-	prevp = NULL;
-	while (bcp != NULL) {
-		if (bcp->bc_blkno == blkno && bcp->bc_len == len) {
-			/*
-			 * We've go a match, so return 1 so that the
-			 * recovery of this buffer is cancelled.
-			 * If this buffer is actually a buffer cancel
-			 * log item, then decrement the refcount on the
-			 * one in the table and remove it if this is the
-			 * last reference.
-			 */
-			if (flags & XFS_BLF_CANCEL) {
-				bcp->bc_refcount--;
-				if (bcp->bc_refcount == 0) {
-					if (prevp == NULL) {
-						*bucket = bcp->bc_next;
-					} else {
-						prevp->bc_next = bcp->bc_next;
-					}
-					kmem_free(bcp);
-				}
-			}
-			return 1;
-		}
-		prevp = bcp;
-		bcp = bcp->bc_next;
+	bucket = XLOG_BUF_CANCEL_BUCKET(log, blkno);
+	list_for_each_entry(bcp, bucket, bc_list) {
+		if (bcp->bc_blkno == blkno && bcp->bc_len == len)
+			goto found;
 	}
+
 	/*
-	 * We didn't find a corresponding entry in the table, so
-	 * return 0 so that the buffer is NOT cancelled.
+	 * We didn't find a corresponding entry in the table, so return 0 so
+	 * that the buffer is NOT cancelled.
 	 */
 	ASSERT(!(flags & XFS_BLF_CANCEL));
 	return 0;
+
+found:
+	/*
+	 * We've go a match, so return 1 so that the recovery of this buffer
+	 * is cancelled.  If this buffer is actually a buffer cancel log
+	 * item, then decrement the refcount on the one in the table and
+	 * remove it if this is the last reference.
+	 */
+	if (flags & XFS_BLF_CANCEL) {
+		if (--bcp->bc_refcount == 0) {
+			list_del(&bcp->bc_list);
+			kmem_free(bcp);
+		}
+	}
+	return 1;
 }
 
 /*
@@ -3649,7 +3610,7 @@ xlog_do_log_recovery(
 	xfs_daddr_t	head_blk,
 	xfs_daddr_t	tail_blk)
 {
-	int		error;
+	int		error, i;
 
 	ASSERT(head_blk != tail_blk);
 
@@ -3657,10 +3618,12 @@ xlog_do_log_recovery(
 	 * First do a pass to find all of the cancelled buf log items.
 	 * Store them in the buf_cancel_table for use in the second pass.
 	 */
-	log->l_buf_cancel_table =
-		(xfs_buf_cancel_t **)kmem_zalloc(XLOG_BC_TABLE_SIZE *
-						 sizeof(xfs_buf_cancel_t*),
+	log->l_buf_cancel_table = kmem_zalloc(XLOG_BC_TABLE_SIZE *
+						 sizeof(struct list_head),
 						 KM_SLEEP);
+	for (i = 0; i < XLOG_BC_TABLE_SIZE; i++)
+		INIT_LIST_HEAD(&log->l_buf_cancel_table[i]);
+
 	error = xlog_do_recovery_pass(log, head_blk, tail_blk,
 				      XLOG_RECOVER_PASS1);
 	if (error != 0) {
@@ -3679,7 +3642,7 @@ xlog_do_log_recovery(
 		int	i;
 
 		for (i = 0; i < XLOG_BC_TABLE_SIZE; i++)
-			ASSERT(log->l_buf_cancel_table[i] == NULL);
+			ASSERT(list_empty(&log->l_buf_cancel_table[i]));
 	}
 #endif	/* DEBUG */
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
