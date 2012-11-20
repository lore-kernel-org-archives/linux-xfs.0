Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qAKMe9W7218877 for <xfs@oss.sgi.com>; Tue, 20 Nov 2012 16:40:09 -0600
Received: from eagdhcp-232-125.americas.sgi.com
	(eagdhcp-232-125.americas.sgi.com [128.162.232.125])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 582B28F806F
	for <xfs@oss.sgi.com>; Tue, 20 Nov 2012 14:42:17 -0800 (PST)
Received: from eagdhcp-232-125.americas.sgi.com (localhost [127.0.0.1])
	by eagdhcp-232-125.americas.sgi.com (8.14.5/8.14.5) with ESMTP id
	qAKMgEdY009260
	for <xfs@oss.sgi.com>; Tue, 20 Nov 2012 16:42:14 -0600 (CST)
	(envelope-from tinguely@sgi.com)
Message-Id: <20121120224146.479983109@sgi.com>
Date: Tue, 20 Nov 2012 16:41:22 -0600
From: Mark Tinguely <tinguely@sgi.com>
Subject: [PATCH 2/2] xfs: fix the buffer log format for contiguous buffers
References: <20121120224120.224166649@sgi.com>
Content-Disposition: inline; filename=xfs-fix-blf-for-multiple-segment.patch
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

A few buffer log format clean-ups for contiguous buffers.

In xfs_buf_item_format_segment(), when a segment is not dirty in
the transaction, do not increment format vector pointer.

In xfs_buf_item_unlock(), every segment must be empty before
considering the buf item empty.

In xfs_trans_binval(), clear the correct buffer log format structure.

Signed-off-by: Mark Tinguely <tinguely@sgi.com>

---
 fs/xfs/xfs_buf_item.c  |   32 +++++++++++++++++++++++---------
 fs/xfs/xfs_trans_buf.c |    4 ++--
 2 files changed, 25 insertions(+), 11 deletions(-)

Index: b/fs/xfs/xfs_buf_item.c
===================================================================
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -71,7 +71,7 @@ xfs_buf_item_log_debug(
 		chunk_num = byte >> XFS_BLF_SHIFT;
 		word_num = chunk_num >> BIT_TO_WORD_SHIFT;
 		bit_num = chunk_num & (NBWORD - 1);
-		wordp = &(bip->bli_format.blf_data_map[word_num]);
+		wordp = &(bip->bli_formats[0].blf_data_map[word_num]);
 		bit_set = *wordp & (1 << bit_num);
 		ASSERT(bit_set);
 		byte++;
@@ -290,8 +290,6 @@ xfs_buf_item_format_segment(
 	vecp->i_addr = blfp;
 	vecp->i_len = base_size;
 	vecp->i_type = XLOG_REG_TYPE_BFORMAT;
-	vecp++;
-	nvecs = 1;
 
 	if (bip->bli_flags & XFS_BLI_STALE) {
 		/*
@@ -301,7 +299,8 @@ xfs_buf_item_format_segment(
 		 */
 		trace_xfs_buf_item_format_stale(bip);
 		ASSERT(blfp->blf_flags & XFS_BLF_CANCEL);
-		blfp->blf_size = nvecs;
+		vecp++;
+		blfp->blf_size = 1;
 		return vecp;
 	}
 
@@ -309,7 +308,16 @@ xfs_buf_item_format_segment(
 	 * Fill in an iovec for each set of contiguous chunks.
 	 */
 	first_bit = xfs_next_bit(blfp->blf_data_map, blfp->blf_map_size, 0);
-	ASSERT(first_bit != -1);
+	if (first_bit == -1) {
+		/* If the map is not be dirty in the transaction, mark
+		 * the size as zero and do not advance the vector pointer.
+		 */
+		blfp->blf_size = 0;
+		return(vecp);
+	}
+
+	nvecs = 1;
+	vecp++;
 	last_bit = first_bit;
 	nbits = 1;
 	for (;;) {
@@ -371,7 +379,7 @@ xfs_buf_item_format_segment(
 			nbits++;
 		}
 	}
-	bip->bli_format.blf_size = nvecs;
+	blfp->blf_size = nvecs;
 	return vecp;
 }
 
@@ -601,7 +609,7 @@ xfs_buf_item_unlock(
 {
 	struct xfs_buf_log_item	*bip = BUF_ITEM(lip);
 	struct xfs_buf		*bp = bip->bli_buf;
-	int			aborted;
+	int			aborted, empty, i;
 	uint			hold;
 
 	/* Clear the buffer's association with this transaction. */
@@ -644,8 +652,14 @@ xfs_buf_item_unlock(
 	 * If the buf item isn't tracking any data, free it, otherwise drop the
 	 * reference we hold to it.
 	 */
-	if (xfs_bitmap_empty(bip->bli_format.blf_data_map,
-			     bip->bli_format.blf_map_size))
+	empty = 1;
+	for (i = 0; i < bip->bli_format_count; i++)
+		if (!xfs_bitmap_empty(bip->bli_formats[i].blf_data_map,
+			     bip->bli_formats[i].blf_map_size)) {
+			empty = 0;
+			break;
+		}
+	if (empty)
 		xfs_buf_item_relse(bp);
 	else
 		atomic_dec(&bip->bli_refcount);
Index: b/fs/xfs/xfs_trans_buf.c
===================================================================
--- a/fs/xfs/xfs_trans_buf.c
+++ b/fs/xfs/xfs_trans_buf.c
@@ -670,8 +670,8 @@ xfs_trans_binval(
 	bip->bli_flags &= ~(XFS_BLI_INODE_BUF | XFS_BLI_LOGGED | XFS_BLI_DIRTY);
 	bip->bli_format.blf_flags &= ~XFS_BLF_INODE_BUF;
 	bip->bli_format.blf_flags |= XFS_BLF_CANCEL;
-	memset((char *)(bip->bli_format.blf_data_map), 0,
-	      (bip->bli_format.blf_map_size * sizeof(uint)));
+	memset((char *)(bip->bli_formats[0].blf_data_map), 0,
+	      (bip->bli_formats[0].blf_map_size * sizeof(uint)));
 	bip->bli_item.li_desc->lid_flags |= XFS_LID_DIRTY;
 	tp->t_flags |= XFS_TRANS_DIRTY;
 }


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
