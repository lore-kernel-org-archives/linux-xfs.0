Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qB4N62Ol203888 for <xfs@oss.sgi.com>; Tue, 4 Dec 2012 17:06:02 -0600
Received: from eagdhcp-232-125.americas.sgi.com
	(eagdhcp-232-125.americas.sgi.com [128.162.232.125])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 9EE82AC007
	for <xfs@oss.sgi.com>; Tue,  4 Dec 2012 15:08:22 -0800 (PST)
Received: from eagdhcp-232-125.americas.sgi.com (localhost [127.0.0.1])
	by eagdhcp-232-125.americas.sgi.com (8.14.5/8.14.5) with ESMTP id
	qB4N8Lkw008571
	for <xfs@oss.sgi.com>; Tue, 4 Dec 2012 17:08:21 -0600 (CST)
	(envelope-from tinguely@sgi.com)
Message-Id: <20121204224938.703805260@sgi.com>
Date: Tue, 04 Dec 2012 17:18:03 -0600
From: Mark Tinguely <tinguely@sgi.com>
Subject: [PATCH v3 2/5] xfs: rename bli_format to avoid confusion with
	bli_formats
References: <20121204231801.982422341@sgi.com>
Content-Disposition: inline; filename=v3-2a-rename-bli_format.patch
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

Rename the bli_format structure to __bli_format to avoid
accidently confusing them with the bli_formats pointer.

Signed-off-by: Mark Tinguely <tinguely@sgi.com>
---
 fs/xfs/xfs_buf_item.c  |   22 +++++++++++-----------
 fs/xfs/xfs_buf_item.h  |    2 +-
 fs/xfs/xfs_trans_buf.c |   24 ++++++++++++------------
 3 files changed, 24 insertions(+), 24 deletions(-)

Index: b/fs/xfs/xfs_buf_item.c
===================================================================
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -71,7 +71,7 @@ xfs_buf_item_log_debug(
 		chunk_num = byte >> XFS_BLF_SHIFT;
 		word_num = chunk_num >> BIT_TO_WORD_SHIFT;
 		bit_num = chunk_num & (NBWORD - 1);
-		wordp = &(bip->bli_format.blf_data_map[word_num]);
+		wordp = &(bip->__bli_format.blf_data_map[word_num]);
 		bit_set = *wordp & (1 << bit_num);
 		ASSERT(bit_set);
 		byte++;
@@ -237,7 +237,7 @@ xfs_buf_item_size(
 		 * cancel flag in it.
 		 */
 		trace_xfs_buf_item_size_stale(bip);
-		ASSERT(bip->bli_format.blf_flags & XFS_BLF_CANCEL);
+		ASSERT(bip->__bli_format.blf_flags & XFS_BLF_CANCEL);
 		return bip->bli_format_count;
 	}
 
@@ -278,7 +278,7 @@ xfs_buf_item_format_segment(
 	uint		buffer_offset;
 
 	/* copy the flags across from the base format item */
-	blfp->blf_flags = bip->bli_format.blf_flags;
+	blfp->blf_flags = bip->__bli_format.blf_flags;
 
 	/*
 	 * Base size is the actual size of the ondisk structure - it reflects
@@ -371,7 +371,7 @@ xfs_buf_item_format_segment(
 			nbits++;
 		}
 	}
-	bip->bli_format.blf_size = nvecs;
+	bip->__bli_format.blf_size = nvecs;
 	return vecp;
 }
 
@@ -405,7 +405,7 @@ xfs_buf_item_format(
 	if (bip->bli_flags & XFS_BLI_INODE_BUF) {
 		if (!((bip->bli_flags & XFS_BLI_INODE_ALLOC_BUF) &&
 		      xfs_log_item_in_current_chkpt(lip)))
-			bip->bli_format.blf_flags |= XFS_BLF_INODE_BUF;
+			bip->__bli_format.blf_flags |= XFS_BLF_INODE_BUF;
 		bip->bli_flags &= ~XFS_BLI_INODE_BUF;
 	}
 
@@ -485,7 +485,7 @@ xfs_buf_item_unpin(
 		ASSERT(bip->bli_flags & XFS_BLI_STALE);
 		ASSERT(xfs_buf_islocked(bp));
 		ASSERT(XFS_BUF_ISSTALE(bp));
-		ASSERT(bip->bli_format.blf_flags & XFS_BLF_CANCEL);
+		ASSERT(bip->__bli_format.blf_flags & XFS_BLF_CANCEL);
 
 		trace_xfs_buf_item_unpin_stale(bip);
 
@@ -631,7 +631,7 @@ xfs_buf_item_unlock(
 	 */
 	if (bip->bli_flags & XFS_BLI_STALE) {
 		trace_xfs_buf_item_unlock_stale(bip);
-		ASSERT(bip->bli_format.blf_flags & XFS_BLF_CANCEL);
+		ASSERT(bip->__bli_format.blf_flags & XFS_BLF_CANCEL);
 		if (!aborted) {
 			atomic_dec(&bip->bli_refcount);
 			return;
@@ -644,8 +644,8 @@ xfs_buf_item_unlock(
 	 * If the buf item isn't tracking any data, free it, otherwise drop the
 	 * reference we hold to it.
 	 */
-	if (xfs_bitmap_empty(bip->bli_format.blf_data_map,
-			     bip->bli_format.blf_map_size))
+	if (xfs_bitmap_empty(bip->__bli_format.blf_data_map,
+			     bip->__bli_format.blf_map_size))
 		xfs_buf_item_relse(bp);
 	else
 		atomic_dec(&bip->bli_refcount);
@@ -716,7 +716,7 @@ xfs_buf_item_get_format(
 	bip->bli_format_count = count;
 
 	if (count == 1) {
-		bip->bli_formats = &bip->bli_format;
+		bip->bli_formats = &bip->__bli_format;
 		return 0;
 	}
 
@@ -731,7 +731,7 @@ STATIC void
 xfs_buf_item_free_format(
 	struct xfs_buf_log_item	*bip)
 {
-	if (bip->bli_formats != &bip->bli_format) {
+	if (bip->bli_formats != &bip->__bli_format) {
 		kmem_free(bip->bli_formats);
 		bip->bli_formats = NULL;
 	}
Index: b/fs/xfs/xfs_buf_item.h
===================================================================
--- a/fs/xfs/xfs_buf_item.h
+++ b/fs/xfs/xfs_buf_item.h
@@ -104,7 +104,7 @@ typedef struct xfs_buf_log_item {
 #endif
 	int			bli_format_count;	/* count of headers */
 	struct xfs_buf_log_format *bli_formats;	/* array of in-log header ptrs */
-	struct xfs_buf_log_format bli_format;	/* embedded in-log header */
+	struct xfs_buf_log_format __bli_format;	/* embedded in-log header */
 } xfs_buf_log_item_t;
 
 void	xfs_buf_item_init(struct xfs_buf *, struct xfs_mount *);
Index: b/fs/xfs/xfs_trans_buf.c
===================================================================
--- a/fs/xfs/xfs_trans_buf.c
+++ b/fs/xfs/xfs_trans_buf.c
@@ -93,7 +93,7 @@ _xfs_trans_bjoin(
 	xfs_buf_item_init(bp, tp->t_mountp);
 	bip = bp->b_fspriv;
 	ASSERT(!(bip->bli_flags & XFS_BLI_STALE));
-	ASSERT(!(bip->bli_format.blf_flags & XFS_BLF_CANCEL));
+	ASSERT(!(bip->__bli_format.blf_flags & XFS_BLF_CANCEL));
 	ASSERT(!(bip->bli_flags & XFS_BLI_LOGGED));
 	if (reset_recur)
 		bip->bli_recur = 0;
@@ -432,7 +432,7 @@ xfs_trans_brelse(xfs_trans_t	*tp,
 	bip = bp->b_fspriv;
 	ASSERT(bip->bli_item.li_type == XFS_LI_BUF);
 	ASSERT(!(bip->bli_flags & XFS_BLI_STALE));
-	ASSERT(!(bip->bli_format.blf_flags & XFS_BLF_CANCEL));
+	ASSERT(!(bip->__bli_format.blf_flags & XFS_BLF_CANCEL));
 	ASSERT(atomic_read(&bip->bli_refcount) > 0);
 
 	trace_xfs_trans_brelse(bip);
@@ -519,7 +519,7 @@ xfs_trans_bhold(xfs_trans_t	*tp,
 	ASSERT(bp->b_transp == tp);
 	ASSERT(bip != NULL);
 	ASSERT(!(bip->bli_flags & XFS_BLI_STALE));
-	ASSERT(!(bip->bli_format.blf_flags & XFS_BLF_CANCEL));
+	ASSERT(!(bip->__bli_format.blf_flags & XFS_BLF_CANCEL));
 	ASSERT(atomic_read(&bip->bli_refcount) > 0);
 
 	bip->bli_flags |= XFS_BLI_HOLD;
@@ -539,7 +539,7 @@ xfs_trans_bhold_release(xfs_trans_t	*tp,
 	ASSERT(bp->b_transp == tp);
 	ASSERT(bip != NULL);
 	ASSERT(!(bip->bli_flags & XFS_BLI_STALE));
-	ASSERT(!(bip->bli_format.blf_flags & XFS_BLF_CANCEL));
+	ASSERT(!(bip->__bli_format.blf_flags & XFS_BLF_CANCEL));
 	ASSERT(atomic_read(&bip->bli_refcount) > 0);
 	ASSERT(bip->bli_flags & XFS_BLI_HOLD);
 
@@ -598,7 +598,7 @@ xfs_trans_log_buf(xfs_trans_t	*tp,
 		bip->bli_flags &= ~XFS_BLI_STALE;
 		ASSERT(XFS_BUF_ISSTALE(bp));
 		XFS_BUF_UNSTALE(bp);
-		bip->bli_format.blf_flags &= ~XFS_BLF_CANCEL;
+		bip->__bli_format.blf_flags &= ~XFS_BLF_CANCEL;
 	}
 
 	tp->t_flags |= XFS_TRANS_DIRTY;
@@ -657,8 +657,8 @@ xfs_trans_binval(
 		 */
 		ASSERT(XFS_BUF_ISSTALE(bp));
 		ASSERT(!(bip->bli_flags & (XFS_BLI_LOGGED | XFS_BLI_DIRTY)));
-		ASSERT(!(bip->bli_format.blf_flags & XFS_BLF_INODE_BUF));
-		ASSERT(bip->bli_format.blf_flags & XFS_BLF_CANCEL);
+		ASSERT(!(bip->__bli_format.blf_flags & XFS_BLF_INODE_BUF));
+		ASSERT(bip->__bli_format.blf_flags & XFS_BLF_CANCEL);
 		ASSERT(bip->bli_item.li_desc->lid_flags & XFS_LID_DIRTY);
 		ASSERT(tp->t_flags & XFS_TRANS_DIRTY);
 		return;
@@ -668,10 +668,10 @@ xfs_trans_binval(
 
 	bip->bli_flags |= XFS_BLI_STALE;
 	bip->bli_flags &= ~(XFS_BLI_INODE_BUF | XFS_BLI_LOGGED | XFS_BLI_DIRTY);
-	bip->bli_format.blf_flags &= ~XFS_BLF_INODE_BUF;
-	bip->bli_format.blf_flags |= XFS_BLF_CANCEL;
-	memset((char *)(bip->bli_format.blf_data_map), 0,
-	      (bip->bli_format.blf_map_size * sizeof(uint)));
+	bip->__bli_format.blf_flags &= ~XFS_BLF_INODE_BUF;
+	bip->__bli_format.blf_flags |= XFS_BLF_CANCEL;
+	memset((char *)(bip->__bli_format.blf_data_map), 0,
+	      (bip->__bli_format.blf_map_size * sizeof(uint)));
 	bip->bli_item.li_desc->lid_flags |= XFS_LID_DIRTY;
 	tp->t_flags |= XFS_TRANS_DIRTY;
 }
@@ -775,5 +775,5 @@ xfs_trans_dquot_buf(
 	       type == XFS_BLF_GDQUOT_BUF);
 	ASSERT(atomic_read(&bip->bli_refcount) > 0);
 
-	bip->bli_format.blf_flags |= type;
+	bip->__bli_format.blf_flags |= type;
 }


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
