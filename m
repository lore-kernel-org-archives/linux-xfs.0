Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o461hn2h064952 for <xfs@oss.sgi.com>; Wed, 5 May 2010 20:43:50 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2EB421B0A122
	for <xfs@oss.sgi.com>; Wed,  5 May 2010 18:45:56 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail17.adl2.internode.on.net
	[150.101.137.102]) by cuda.sgi.com with ESMTP id
	h5nacnRybBUXEhhA for <xfs@oss.sgi.com>;
	Wed, 05 May 2010 18:45:56 -0700 (PDT)
Received: from dastard (unverified [121.44.229.111])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	23089810-1927428
	for <xfs@oss.sgi.com>; Thu, 06 May 2010 11:15:54 +0930 (CST)
Received: from disturbed ([192.168.1.9]) by dastard with esmtp (Exim 4.71)
	(envelope-from <dave@fromorbit.com>) id 1O9q9w-0005DS-Ep
	for xfs@oss.sgi.com; Thu, 06 May 2010 11:45:52 +1000
Received: from dave by disturbed with local (Exim 4.71)
	(envelope-from <dave@disturbed.disaster>) id 1O9q9v-0000cR-G4
	for xfs@oss.sgi.com; Thu, 06 May 2010 11:45:51 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 05/11] xfs: Clean up XFS_BLI_* flag namespace
Date: Thu,  6 May 2010 11:45:45 +1000
Message-Id: <1273110351-2333-6-git-send-email-david@fromorbit.com>
In-Reply-To: <1273110351-2333-1-git-send-email-david@fromorbit.com>
References: <1273110351-2333-1-git-send-email-david@fromorbit.com>
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

Clean up the buffer log format (XFS_BLI_*) flags because they have a
polluted namespace. They XFS_BLI_ prefix is used for both in-memory
and on-disk flag feilds, but have overlapping values for different
flags. Rename the buffer log format flags to use the XFS_BLF_*
prefix to avoid confusing them with the in-memory XFS_BLI_* prefixed
flags.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/linux-2.6/xfs_super.c |    2 +-
 fs/xfs/quota/xfs_dquot.c     |    6 ++--
 fs/xfs/xfs_buf_item.c        |   42 +++++++++++++++++++-------------------
 fs/xfs/xfs_buf_item.h        |   14 ++++++------
 fs/xfs/xfs_log_recover.c     |   46 +++++++++++++++++++++---------------------
 fs/xfs/xfs_log_recover.h     |    2 +-
 fs/xfs/xfs_trans_buf.c       |   28 ++++++++++++------------
 7 files changed, 70 insertions(+), 70 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_super.c b/fs/xfs/linux-2.6/xfs_super.c
index a43d09e..1e88c98 100644
--- a/fs/xfs/linux-2.6/xfs_super.c
+++ b/fs/xfs/linux-2.6/xfs_super.c
@@ -1753,7 +1753,7 @@ xfs_init_zones(void)
 	 * but it is much faster.
 	 */
 	xfs_buf_item_zone = kmem_zone_init((sizeof(xfs_buf_log_item_t) +
-				(((XFS_MAX_BLOCKSIZE / XFS_BLI_CHUNK) /
+				(((XFS_MAX_BLOCKSIZE / XFS_BLF_CHUNK) /
 				  NBWORD) * sizeof(int))), "xfs_buf_item");
 	if (!xfs_buf_item_zone)
 		goto out_destroy_trans_zone;
diff --git a/fs/xfs/quota/xfs_dquot.c b/fs/xfs/quota/xfs_dquot.c
index b89ec5d..585e763 100644
--- a/fs/xfs/quota/xfs_dquot.c
+++ b/fs/xfs/quota/xfs_dquot.c
@@ -344,9 +344,9 @@ xfs_qm_init_dquot_blk(
 	for (i = 0; i < q->qi_dqperchunk; i++, d++, curid++)
 		xfs_qm_dqinit_core(curid, type, d);
 	xfs_trans_dquot_buf(tp, bp,
-			    (type & XFS_DQ_USER ? XFS_BLI_UDQUOT_BUF :
-			    ((type & XFS_DQ_PROJ) ? XFS_BLI_PDQUOT_BUF :
-			     XFS_BLI_GDQUOT_BUF)));
+			    (type & XFS_DQ_USER ? XFS_BLF_UDQUOT_BUF :
+			    ((type & XFS_DQ_PROJ) ? XFS_BLF_PDQUOT_BUF :
+			     XFS_BLF_GDQUOT_BUF)));
 	xfs_trans_log_buf(tp, bp, 0, BBTOB(q->qi_dqchunklen) - 1);
 }
 
diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index 4cd5f61..bcbb661 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -64,7 +64,7 @@ xfs_buf_item_log_debug(
 	nbytes = last - first + 1;
 	bfset(bip->bli_logged, first, nbytes);
 	for (x = 0; x < nbytes; x++) {
-		chunk_num = byte >> XFS_BLI_SHIFT;
+		chunk_num = byte >> XFS_BLF_SHIFT;
 		word_num = chunk_num >> BIT_TO_WORD_SHIFT;
 		bit_num = chunk_num & (NBWORD - 1);
 		wordp = &(bip->bli_format.blf_data_map[word_num]);
@@ -166,7 +166,7 @@ xfs_buf_item_size(
 		 * cancel flag in it.
 		 */
 		trace_xfs_buf_item_size_stale(bip);
-		ASSERT(bip->bli_format.blf_flags & XFS_BLI_CANCEL);
+		ASSERT(bip->bli_format.blf_flags & XFS_BLF_CANCEL);
 		return 1;
 	}
 
@@ -197,9 +197,9 @@ xfs_buf_item_size(
 		} else if (next_bit != last_bit + 1) {
 			last_bit = next_bit;
 			nvecs++;
-		} else if (xfs_buf_offset(bp, next_bit * XFS_BLI_CHUNK) !=
-			   (xfs_buf_offset(bp, last_bit * XFS_BLI_CHUNK) +
-			    XFS_BLI_CHUNK)) {
+		} else if (xfs_buf_offset(bp, next_bit * XFS_BLF_CHUNK) !=
+			   (xfs_buf_offset(bp, last_bit * XFS_BLF_CHUNK) +
+			    XFS_BLF_CHUNK)) {
 			last_bit = next_bit;
 			nvecs++;
 		} else {
@@ -261,7 +261,7 @@ xfs_buf_item_format(
 		 * cancel flag in it.
 		 */
 		trace_xfs_buf_item_format_stale(bip);
-		ASSERT(bip->bli_format.blf_flags & XFS_BLI_CANCEL);
+		ASSERT(bip->bli_format.blf_flags & XFS_BLF_CANCEL);
 		bip->bli_format.blf_size = nvecs;
 		return;
 	}
@@ -294,28 +294,28 @@ xfs_buf_item_format(
 		 * keep counting and scanning.
 		 */
 		if (next_bit == -1) {
-			buffer_offset = first_bit * XFS_BLI_CHUNK;
+			buffer_offset = first_bit * XFS_BLF_CHUNK;
 			vecp->i_addr = xfs_buf_offset(bp, buffer_offset);
-			vecp->i_len = nbits * XFS_BLI_CHUNK;
+			vecp->i_len = nbits * XFS_BLF_CHUNK;
 			vecp->i_type = XLOG_REG_TYPE_BCHUNK;
 			nvecs++;
 			break;
 		} else if (next_bit != last_bit + 1) {
-			buffer_offset = first_bit * XFS_BLI_CHUNK;
+			buffer_offset = first_bit * XFS_BLF_CHUNK;
 			vecp->i_addr = xfs_buf_offset(bp, buffer_offset);
-			vecp->i_len = nbits * XFS_BLI_CHUNK;
+			vecp->i_len = nbits * XFS_BLF_CHUNK;
 			vecp->i_type = XLOG_REG_TYPE_BCHUNK;
 			nvecs++;
 			vecp++;
 			first_bit = next_bit;
 			last_bit = next_bit;
 			nbits = 1;
-		} else if (xfs_buf_offset(bp, next_bit << XFS_BLI_SHIFT) !=
-			   (xfs_buf_offset(bp, last_bit << XFS_BLI_SHIFT) +
-			    XFS_BLI_CHUNK)) {
-			buffer_offset = first_bit * XFS_BLI_CHUNK;
+		} else if (xfs_buf_offset(bp, next_bit << XFS_BLF_SHIFT) !=
+			   (xfs_buf_offset(bp, last_bit << XFS_BLF_SHIFT) +
+			    XFS_BLF_CHUNK)) {
+			buffer_offset = first_bit * XFS_BLF_CHUNK;
 			vecp->i_addr = xfs_buf_offset(bp, buffer_offset);
-			vecp->i_len = nbits * XFS_BLI_CHUNK;
+			vecp->i_len = nbits * XFS_BLF_CHUNK;
 			vecp->i_type = XLOG_REG_TYPE_BCHUNK;
 /* You would think we need to bump the nvecs here too, but we do not
  * this number is used by recovery, and it gets confused by the boundary
@@ -399,7 +399,7 @@ xfs_buf_item_unpin(
 		ASSERT(XFS_BUF_VALUSEMA(bp) <= 0);
 		ASSERT(!(XFS_BUF_ISDELAYWRITE(bp)));
 		ASSERT(XFS_BUF_ISSTALE(bp));
-		ASSERT(bip->bli_format.blf_flags & XFS_BLI_CANCEL);
+		ASSERT(bip->bli_format.blf_flags & XFS_BLF_CANCEL);
 		trace_xfs_buf_item_unpin_stale(bip);
 
 		/*
@@ -550,7 +550,7 @@ xfs_buf_item_unlock(
 	 */
 	if (bip->bli_flags & XFS_BLI_STALE) {
 		trace_xfs_buf_item_unlock_stale(bip);
-		ASSERT(bip->bli_format.blf_flags & XFS_BLI_CANCEL);
+		ASSERT(bip->bli_format.blf_flags & XFS_BLF_CANCEL);
 		if (!aborted) {
 			atomic_dec(&bip->bli_refcount);
 			return;
@@ -707,12 +707,12 @@ xfs_buf_item_init(
 	}
 
 	/*
-	 * chunks is the number of XFS_BLI_CHUNK size pieces
+	 * chunks is the number of XFS_BLF_CHUNK size pieces
 	 * the buffer can be divided into. Make sure not to
 	 * truncate any pieces.  map_size is the size of the
 	 * bitmap needed to describe the chunks of the buffer.
 	 */
-	chunks = (int)((XFS_BUF_COUNT(bp) + (XFS_BLI_CHUNK - 1)) >> XFS_BLI_SHIFT);
+	chunks = (int)((XFS_BUF_COUNT(bp) + (XFS_BLF_CHUNK - 1)) >> XFS_BLF_SHIFT);
 	map_size = (int)((chunks + NBWORD) >> BIT_TO_WORD_SHIFT);
 
 	bip = (xfs_buf_log_item_t*)kmem_zone_zalloc(xfs_buf_item_zone,
@@ -780,8 +780,8 @@ xfs_buf_item_log(
 	/*
 	 * Convert byte offsets to bit numbers.
 	 */
-	first_bit = first >> XFS_BLI_SHIFT;
-	last_bit = last >> XFS_BLI_SHIFT;
+	first_bit = first >> XFS_BLF_SHIFT;
+	last_bit = last >> XFS_BLF_SHIFT;
 
 	/*
 	 * Calculate the total number of bits to be set.
diff --git a/fs/xfs/xfs_buf_item.h b/fs/xfs/xfs_buf_item.h
index df44545..8cbb82b 100644
--- a/fs/xfs/xfs_buf_item.h
+++ b/fs/xfs/xfs_buf_item.h
@@ -41,22 +41,22 @@ typedef struct xfs_buf_log_format {
  * This flag indicates that the buffer contains on disk inodes
  * and requires special recovery handling.
  */
-#define	XFS_BLI_INODE_BUF	0x1
+#define	XFS_BLF_INODE_BUF	0x1
 /*
  * This flag indicates that the buffer should not be replayed
  * during recovery because its blocks are being freed.
  */
-#define	XFS_BLI_CANCEL		0x2
+#define	XFS_BLF_CANCEL		0x2
 /*
  * This flag indicates that the buffer contains on disk
  * user or group dquots and may require special recovery handling.
  */
-#define	XFS_BLI_UDQUOT_BUF	0x4
-#define XFS_BLI_PDQUOT_BUF	0x8
-#define	XFS_BLI_GDQUOT_BUF	0x10
+#define	XFS_BLF_UDQUOT_BUF	0x4
+#define XFS_BLF_PDQUOT_BUF	0x8
+#define	XFS_BLF_GDQUOT_BUF	0x10
 
-#define	XFS_BLI_CHUNK		128
-#define	XFS_BLI_SHIFT		7
+#define	XFS_BLF_CHUNK		128
+#define	XFS_BLF_SHIFT		7
 #define	BIT_TO_WORD_SHIFT	5
 #define	NBWORD			(NBBY * sizeof(unsigned int))
 
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 0de08e3..14a69ae 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -1576,7 +1576,7 @@ xlog_recover_reorder_trans(
 
 		switch (ITEM_TYPE(item)) {
 		case XFS_LI_BUF:
-			if (!(buf_f->blf_flags & XFS_BLI_CANCEL)) {
+			if (!(buf_f->blf_flags & XFS_BLF_CANCEL)) {
 				trace_xfs_log_recover_item_reorder_head(log,
 							trans, item, pass);
 				list_move(&item->ri_list, &trans->r_itemq);
@@ -1638,7 +1638,7 @@ xlog_recover_do_buffer_pass1(
 	/*
 	 * If this isn't a cancel buffer item, then just return.
 	 */
-	if (!(flags & XFS_BLI_CANCEL)) {
+	if (!(flags & XFS_BLF_CANCEL)) {
 		trace_xfs_log_recover_buf_not_cancel(log, buf_f);
 		return;
 	}
@@ -1696,7 +1696,7 @@ xlog_recover_do_buffer_pass1(
  * Check to see whether the buffer being recovered has a corresponding
  * entry in the buffer cancel record table.  If it does then return 1
  * so that it will be cancelled, otherwise return 0.  If the buffer is
- * actually a buffer cancel item (XFS_BLI_CANCEL is set), then decrement
+ * actually a buffer cancel item (XFS_BLF_CANCEL is set), then decrement
  * the refcount on the entry in the table and remove it from the table
  * if this is the last reference.
  *
@@ -1721,7 +1721,7 @@ xlog_check_buffer_cancelled(
 		 * There is nothing in the table built in pass one,
 		 * so this buffer must not be cancelled.
 		 */
-		ASSERT(!(flags & XFS_BLI_CANCEL));
+		ASSERT(!(flags & XFS_BLF_CANCEL));
 		return 0;
 	}
 
@@ -1733,7 +1733,7 @@ xlog_check_buffer_cancelled(
 		 * There is no corresponding entry in the table built
 		 * in pass one, so this buffer has not been cancelled.
 		 */
-		ASSERT(!(flags & XFS_BLI_CANCEL));
+		ASSERT(!(flags & XFS_BLF_CANCEL));
 		return 0;
 	}
 
@@ -1752,7 +1752,7 @@ xlog_check_buffer_cancelled(
 			 * one in the table and remove it if this is the
 			 * last reference.
 			 */
-			if (flags & XFS_BLI_CANCEL) {
+			if (flags & XFS_BLF_CANCEL) {
 				bcp->bc_refcount--;
 				if (bcp->bc_refcount == 0) {
 					if (prevp == NULL) {
@@ -1772,7 +1772,7 @@ xlog_check_buffer_cancelled(
 	 * We didn't find a corresponding entry in the table, so
 	 * return 0 so that the buffer is NOT cancelled.
 	 */
-	ASSERT(!(flags & XFS_BLI_CANCEL));
+	ASSERT(!(flags & XFS_BLF_CANCEL));
 	return 0;
 }
 
@@ -1874,8 +1874,8 @@ xlog_recover_do_inode_buffer(
 			nbits = xfs_contig_bits(data_map, map_size,
 							 bit);
 			ASSERT(nbits > 0);
-			reg_buf_offset = bit << XFS_BLI_SHIFT;
-			reg_buf_bytes = nbits << XFS_BLI_SHIFT;
+			reg_buf_offset = bit << XFS_BLF_SHIFT;
+			reg_buf_bytes = nbits << XFS_BLF_SHIFT;
 			item_index++;
 		}
 
@@ -1889,7 +1889,7 @@ xlog_recover_do_inode_buffer(
 		}
 
 		ASSERT(item->ri_buf[item_index].i_addr != NULL);
-		ASSERT((item->ri_buf[item_index].i_len % XFS_BLI_CHUNK) == 0);
+		ASSERT((item->ri_buf[item_index].i_len % XFS_BLF_CHUNK) == 0);
 		ASSERT((reg_buf_offset + reg_buf_bytes) <= XFS_BUF_COUNT(bp));
 
 		/*
@@ -1955,9 +1955,9 @@ xlog_recover_do_reg_buffer(
 		nbits = xfs_contig_bits(data_map, map_size, bit);
 		ASSERT(nbits > 0);
 		ASSERT(item->ri_buf[i].i_addr != NULL);
-		ASSERT(item->ri_buf[i].i_len % XFS_BLI_CHUNK == 0);
+		ASSERT(item->ri_buf[i].i_len % XFS_BLF_CHUNK == 0);
 		ASSERT(XFS_BUF_COUNT(bp) >=
-		       ((uint)bit << XFS_BLI_SHIFT)+(nbits<<XFS_BLI_SHIFT));
+		       ((uint)bit << XFS_BLF_SHIFT)+(nbits<<XFS_BLF_SHIFT));
 
 		/*
 		 * Do a sanity check if this is a dquot buffer. Just checking
@@ -1966,7 +1966,7 @@ xlog_recover_do_reg_buffer(
 		 */
 		error = 0;
 		if (buf_f->blf_flags &
-		   (XFS_BLI_UDQUOT_BUF|XFS_BLI_PDQUOT_BUF|XFS_BLI_GDQUOT_BUF)) {
+		   (XFS_BLF_UDQUOT_BUF|XFS_BLF_PDQUOT_BUF|XFS_BLF_GDQUOT_BUF)) {
 			if (item->ri_buf[i].i_addr == NULL) {
 				cmn_err(CE_ALERT,
 					"XFS: NULL dquot in %s.", __func__);
@@ -1987,9 +1987,9 @@ xlog_recover_do_reg_buffer(
 		}
 
 		memcpy(xfs_buf_offset(bp,
-			(uint)bit << XFS_BLI_SHIFT),	/* dest */
+			(uint)bit << XFS_BLF_SHIFT),	/* dest */
 			item->ri_buf[i].i_addr,		/* source */
-			nbits<<XFS_BLI_SHIFT);		/* length */
+			nbits<<XFS_BLF_SHIFT);		/* length */
  next:
 		i++;
 		bit += nbits;
@@ -2148,11 +2148,11 @@ xlog_recover_do_dquot_buffer(
 	}
 
 	type = 0;
-	if (buf_f->blf_flags & XFS_BLI_UDQUOT_BUF)
+	if (buf_f->blf_flags & XFS_BLF_UDQUOT_BUF)
 		type |= XFS_DQ_USER;
-	if (buf_f->blf_flags & XFS_BLI_PDQUOT_BUF)
+	if (buf_f->blf_flags & XFS_BLF_PDQUOT_BUF)
 		type |= XFS_DQ_PROJ;
-	if (buf_f->blf_flags & XFS_BLI_GDQUOT_BUF)
+	if (buf_f->blf_flags & XFS_BLF_GDQUOT_BUF)
 		type |= XFS_DQ_GROUP;
 	/*
 	 * This type of quotas was turned off, so ignore this buffer
@@ -2173,7 +2173,7 @@ xlog_recover_do_dquot_buffer(
  * here which overlaps that may be stale.
  *
  * When meta-data buffers are freed at run time we log a buffer item
- * with the XFS_BLI_CANCEL bit set to indicate that previous copies
+ * with the XFS_BLF_CANCEL bit set to indicate that previous copies
  * of the buffer in the log should not be replayed at recovery time.
  * This is so that if the blocks covered by the buffer are reused for
  * file data before we crash we don't end up replaying old, freed
@@ -2207,7 +2207,7 @@ xlog_recover_do_buffer_trans(
 	if (pass == XLOG_RECOVER_PASS1) {
 		/*
 		 * In this pass we're only looking for buf items
-		 * with the XFS_BLI_CANCEL bit set.
+		 * with the XFS_BLF_CANCEL bit set.
 		 */
 		xlog_recover_do_buffer_pass1(log, buf_f);
 		return 0;
@@ -2244,7 +2244,7 @@ xlog_recover_do_buffer_trans(
 
 	mp = log->l_mp;
 	buf_flags = XBF_LOCK;
-	if (!(flags & XFS_BLI_INODE_BUF))
+	if (!(flags & XFS_BLF_INODE_BUF))
 		buf_flags |= XBF_MAPPED;
 
 	bp = xfs_buf_read(mp->m_ddev_targp, blkno, len, buf_flags);
@@ -2257,10 +2257,10 @@ xlog_recover_do_buffer_trans(
 	}
 
 	error = 0;
-	if (flags & XFS_BLI_INODE_BUF) {
+	if (flags & XFS_BLF_INODE_BUF) {
 		error = xlog_recover_do_inode_buffer(mp, item, bp, buf_f);
 	} else if (flags &
-		  (XFS_BLI_UDQUOT_BUF|XFS_BLI_PDQUOT_BUF|XFS_BLI_GDQUOT_BUF)) {
+		  (XFS_BLF_UDQUOT_BUF|XFS_BLF_PDQUOT_BUF|XFS_BLF_GDQUOT_BUF)) {
 		xlog_recover_do_dquot_buffer(mp, log, item, bp, buf_f);
 	} else {
 		xlog_recover_do_reg_buffer(mp, item, bp, buf_f);
diff --git a/fs/xfs/xfs_log_recover.h b/fs/xfs/xfs_log_recover.h
index 75d7492..1c55ccb 100644
--- a/fs/xfs/xfs_log_recover.h
+++ b/fs/xfs/xfs_log_recover.h
@@ -28,7 +28,7 @@
 #define XLOG_RHASH(tid)	\
 	((((__uint32_t)tid)>>XLOG_RHASH_SHIFT) & (XLOG_RHASH_SIZE-1))
 
-#define XLOG_MAX_REGIONS_IN_ITEM   (XFS_MAX_BLOCKSIZE / XFS_BLI_CHUNK / 2 + 1)
+#define XLOG_MAX_REGIONS_IN_ITEM   (XFS_MAX_BLOCKSIZE / XFS_BLF_CHUNK / 2 + 1)
 
 
 /*
diff --git a/fs/xfs/xfs_trans_buf.c b/fs/xfs/xfs_trans_buf.c
index 9cd8090..3390c3e 100644
--- a/fs/xfs/xfs_trans_buf.c
+++ b/fs/xfs/xfs_trans_buf.c
@@ -114,7 +114,7 @@ _xfs_trans_bjoin(
 	xfs_buf_item_init(bp, tp->t_mountp);
 	bip = XFS_BUF_FSPRIVATE(bp, xfs_buf_log_item_t *);
 	ASSERT(!(bip->bli_flags & XFS_BLI_STALE));
-	ASSERT(!(bip->bli_format.blf_flags & XFS_BLI_CANCEL));
+	ASSERT(!(bip->bli_format.blf_flags & XFS_BLF_CANCEL));
 	ASSERT(!(bip->bli_flags & XFS_BLI_LOGGED));
 	if (reset_recur)
 		bip->bli_recur = 0;
@@ -511,7 +511,7 @@ xfs_trans_brelse(xfs_trans_t	*tp,
 	bip = XFS_BUF_FSPRIVATE(bp, xfs_buf_log_item_t *);
 	ASSERT(bip->bli_item.li_type == XFS_LI_BUF);
 	ASSERT(!(bip->bli_flags & XFS_BLI_STALE));
-	ASSERT(!(bip->bli_format.blf_flags & XFS_BLI_CANCEL));
+	ASSERT(!(bip->bli_format.blf_flags & XFS_BLF_CANCEL));
 	ASSERT(atomic_read(&bip->bli_refcount) > 0);
 
 	/*
@@ -619,7 +619,7 @@ xfs_trans_bhold(xfs_trans_t	*tp,
 
 	bip = XFS_BUF_FSPRIVATE(bp, xfs_buf_log_item_t *);
 	ASSERT(!(bip->bli_flags & XFS_BLI_STALE));
-	ASSERT(!(bip->bli_format.blf_flags & XFS_BLI_CANCEL));
+	ASSERT(!(bip->bli_format.blf_flags & XFS_BLF_CANCEL));
 	ASSERT(atomic_read(&bip->bli_refcount) > 0);
 	bip->bli_flags |= XFS_BLI_HOLD;
 	trace_xfs_trans_bhold(bip);
@@ -641,7 +641,7 @@ xfs_trans_bhold_release(xfs_trans_t	*tp,
 
 	bip = XFS_BUF_FSPRIVATE(bp, xfs_buf_log_item_t *);
 	ASSERT(!(bip->bli_flags & XFS_BLI_STALE));
-	ASSERT(!(bip->bli_format.blf_flags & XFS_BLI_CANCEL));
+	ASSERT(!(bip->bli_format.blf_flags & XFS_BLF_CANCEL));
 	ASSERT(atomic_read(&bip->bli_refcount) > 0);
 	ASSERT(bip->bli_flags & XFS_BLI_HOLD);
 	bip->bli_flags &= ~XFS_BLI_HOLD;
@@ -704,7 +704,7 @@ xfs_trans_log_buf(xfs_trans_t	*tp,
 		bip->bli_flags &= ~XFS_BLI_STALE;
 		ASSERT(XFS_BUF_ISSTALE(bp));
 		XFS_BUF_UNSTALE(bp);
-		bip->bli_format.blf_flags &= ~XFS_BLI_CANCEL;
+		bip->bli_format.blf_flags &= ~XFS_BLF_CANCEL;
 	}
 
 	lidp = xfs_trans_find_item(tp, (xfs_log_item_t*)bip);
@@ -762,8 +762,8 @@ xfs_trans_binval(
 		ASSERT(!(XFS_BUF_ISDELAYWRITE(bp)));
 		ASSERT(XFS_BUF_ISSTALE(bp));
 		ASSERT(!(bip->bli_flags & (XFS_BLI_LOGGED | XFS_BLI_DIRTY)));
-		ASSERT(!(bip->bli_format.blf_flags & XFS_BLI_INODE_BUF));
-		ASSERT(bip->bli_format.blf_flags & XFS_BLI_CANCEL);
+		ASSERT(!(bip->bli_format.blf_flags & XFS_BLF_INODE_BUF));
+		ASSERT(bip->bli_format.blf_flags & XFS_BLF_CANCEL);
 		ASSERT(lidp->lid_flags & XFS_LID_DIRTY);
 		ASSERT(tp->t_flags & XFS_TRANS_DIRTY);
 		return;
@@ -774,7 +774,7 @@ xfs_trans_binval(
 	 * in the buf log item.  The STALE flag will be used in
 	 * xfs_buf_item_unpin() to determine if it should clean up
 	 * when the last reference to the buf item is given up.
-	 * We set the XFS_BLI_CANCEL flag in the buf log format structure
+	 * We set the XFS_BLF_CANCEL flag in the buf log format structure
 	 * and log the buf item.  This will be used at recovery time
 	 * to determine that copies of the buffer in the log before
 	 * this should not be replayed.
@@ -793,8 +793,8 @@ xfs_trans_binval(
 	XFS_BUF_STALE(bp);
 	bip->bli_flags |= XFS_BLI_STALE;
 	bip->bli_flags &= ~(XFS_BLI_LOGGED | XFS_BLI_DIRTY);
-	bip->bli_format.blf_flags &= ~XFS_BLI_INODE_BUF;
-	bip->bli_format.blf_flags |= XFS_BLI_CANCEL;
+	bip->bli_format.blf_flags &= ~XFS_BLF_INODE_BUF;
+	bip->bli_format.blf_flags |= XFS_BLF_CANCEL;
 	memset((char *)(bip->bli_format.blf_data_map), 0,
 	      (bip->bli_format.blf_map_size * sizeof(uint)));
 	lidp->lid_flags |= XFS_LID_DIRTY;
@@ -826,7 +826,7 @@ xfs_trans_inode_buf(
 	bip = XFS_BUF_FSPRIVATE(bp, xfs_buf_log_item_t *);
 	ASSERT(atomic_read(&bip->bli_refcount) > 0);
 
-	bip->bli_format.blf_flags |= XFS_BLI_INODE_BUF;
+	bip->bli_format.blf_flags |= XFS_BLF_INODE_BUF;
 }
 
 /*
@@ -908,9 +908,9 @@ xfs_trans_dquot_buf(
 	ASSERT(XFS_BUF_ISBUSY(bp));
 	ASSERT(XFS_BUF_FSPRIVATE2(bp, xfs_trans_t *) == tp);
 	ASSERT(XFS_BUF_FSPRIVATE(bp, void *) != NULL);
-	ASSERT(type == XFS_BLI_UDQUOT_BUF ||
-	       type == XFS_BLI_PDQUOT_BUF ||
-	       type == XFS_BLI_GDQUOT_BUF);
+	ASSERT(type == XFS_BLF_UDQUOT_BUF ||
+	       type == XFS_BLF_PDQUOT_BUF ||
+	       type == XFS_BLF_GDQUOT_BUF);
 
 	bip = XFS_BUF_FSPRIVATE(bp, xfs_buf_log_item_t *);
 	ASSERT(atomic_read(&bip->bli_refcount) > 0);
-- 
1.5.6.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
