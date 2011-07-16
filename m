Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6GDNGMc258189 for <xfs@oss.sgi.com>; Sat, 16 Jul 2011 08:23:16 -0500
Received: from e36.co.us.ibm.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1557417DA389
	for <xfs@oss.sgi.com>; Sat, 16 Jul 2011 06:23:15 -0700 (PDT)
Received: from e36.co.us.ibm.com (e36.co.us.ibm.com [32.97.110.154]) by
	cuda.sgi.com with ESMTP id Fq7iVcVl9xRfzDWq for
	<xfs@oss.sgi.com>; Sat, 16 Jul 2011 06:23:15 -0700 (PDT)
Received: from d03relay01.boulder.ibm.com (d03relay01.boulder.ibm.com
	[9.17.195.226])
	by e36.co.us.ibm.com (8.14.4/8.13.1) with ESMTP id p6G1Fced024551
	for <xfs@oss.sgi.com>; Fri, 15 Jul 2011 19:15:38 -0600
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d03relay01.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	p6G1Lmd7203774 for <xfs@oss.sgi.com>; Fri, 15 Jul 2011 19:21:48 -0600
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP
	id p6FJLlOH032339
	for <xfs@oss.sgi.com>; Fri, 15 Jul 2011 13:21:47 -0600
From: Chandra Seetharaman <sekharan@us.ibm.com>
Date: Fri, 15 Jul 2011 18:21:47 -0700
Message-Id: <20110716012147.6629.12496.sendpatchset@chandra-lucid.beaverton.ibm.com>
In-Reply-To: <20110716012105.6629.24407.sendpatchset@chandra-lucid.beaverton.ibm.com>
References: <20110716012105.6629.24407.sendpatchset@chandra-lucid.beaverton.ibm.com>
Subject: [PATCH 07/12] xfs: Remove the macro XFS_BUF_PTR
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
Cc: Chandra Seetharaman <sekharan@us.ibm.com>

Remove the definition and usages of the macro XFS_BUF_PTR.

Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
---
 fs/xfs/linux-2.6/xfs_buf.c |    2 +-
 fs/xfs/linux-2.6/xfs_buf.h |    1 -
 fs/xfs/quota/xfs_dquot.c   |    6 +++---
 fs/xfs/quota/xfs_qm.c      |    2 +-
 fs/xfs/xfs_ag.h            |    6 +++---
 fs/xfs/xfs_bmap.c          |    3 +--
 fs/xfs/xfs_btree.h         |    2 +-
 fs/xfs/xfs_buf_item.c      |    6 +++---
 fs/xfs/xfs_da_btree.c      |    8 ++++----
 fs/xfs/xfs_dinode.h        |    2 +-
 fs/xfs/xfs_log.c           |    2 +-
 fs/xfs/xfs_log_recover.c   |   10 +++++-----
 fs/xfs/xfs_rtalloc.c       |   30 +++++++++++++++---------------
 fs/xfs/xfs_rtalloc.h       |    2 +-
 fs/xfs/xfs_sb.h            |    2 +-
 fs/xfs/xfs_vnodeops.c      |    6 +++---
 16 files changed, 44 insertions(+), 46 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_buf.c b/fs/xfs/linux-2.6/xfs_buf.c
index c881c2e..b3265dd 100644
--- a/fs/xfs/linux-2.6/xfs_buf.c
+++ b/fs/xfs/linux-2.6/xfs_buf.c
@@ -1337,7 +1337,7 @@ xfs_buf_offset(
 	struct page		*page;
 
 	if (bp->b_flags & XBF_MAPPED)
-		return XFS_BUF_PTR(bp) + offset;
+		return bp->b_addr + offset;
 
 	offset += bp->b_offset;
 	page = bp->b_pages[offset >> PAGE_SHIFT];
diff --git a/fs/xfs/linux-2.6/xfs_buf.h b/fs/xfs/linux-2.6/xfs_buf.h
index e256289..e426219 100644
--- a/fs/xfs/linux-2.6/xfs_buf.h
+++ b/fs/xfs/linux-2.6/xfs_buf.h
@@ -275,7 +275,6 @@ void xfs_buf_stale(struct xfs_buf *bp);
 #define XFS_BUF_FSPRIVATE2(bp, type)		((type)(bp)->b_fspriv2)
 #define XFS_BUF_SET_FSPRIVATE2(bp, val)		((bp)->b_fspriv2 = (void*)(val))
 
-#define XFS_BUF_PTR(bp)			(xfs_caddr_t)((bp)->b_addr)
 #define XFS_BUF_SET_PTR(bp, val, cnt)	xfs_buf_associate_memory(bp, val, cnt)
 #define XFS_BUF_ADDR(bp)		((bp)->b_bn)
 #define XFS_BUF_SET_ADDR(bp, bno)	((bp)->b_bn = (xfs_daddr_t)(bno))
diff --git a/fs/xfs/quota/xfs_dquot.c b/fs/xfs/quota/xfs_dquot.c
index fa3c150..7a3beba 100644
--- a/fs/xfs/quota/xfs_dquot.c
+++ b/fs/xfs/quota/xfs_dquot.c
@@ -319,7 +319,7 @@ xfs_qm_init_dquot_blk(
 	ASSERT(tp);
 	ASSERT(XFS_BUF_VALUSEMA(bp) <= 0);
 
-	d = (xfs_dqblk_t *)XFS_BUF_PTR(bp);
+	d = bp->b_addr;
 
 	/*
 	 * ID of the first dquot in the block - id's are zero based.
@@ -537,7 +537,7 @@ xfs_qm_dqtobp(
 	/*
 	 * calculate the location of the dquot inside the buffer.
 	 */
-	ddq = (struct xfs_disk_dquot *)(XFS_BUF_PTR(bp) + dqp->q_bufoffset);
+	ddq = bp->b_addr + dqp->q_bufoffset;
 
 	/*
 	 * A simple sanity check in case we got a corrupted dquot...
@@ -1199,7 +1199,7 @@ xfs_qm_dqflush(
 	/*
 	 * Calculate the location of the dquot inside the buffer.
 	 */
-	ddqp = (struct xfs_disk_dquot *)(XFS_BUF_PTR(bp) + dqp->q_bufoffset);
+	ddqp = bp->b_addr + dqp->q_bufoffset;
 
 	/*
 	 * A simple sanity check in case we got a corrupted dquot..
diff --git a/fs/xfs/quota/xfs_qm.c b/fs/xfs/quota/xfs_qm.c
index b94dace..b5967a6 100644
--- a/fs/xfs/quota/xfs_qm.c
+++ b/fs/xfs/quota/xfs_qm.c
@@ -1280,7 +1280,7 @@ xfs_qm_reset_dqcounts(
 	do_div(j, sizeof(xfs_dqblk_t));
 	ASSERT(mp->m_quotainfo->qi_dqperchunk == j);
 #endif
-	ddq = (xfs_disk_dquot_t *)XFS_BUF_PTR(bp);
+	ddq = bp->b_addr;
 	for (j = 0; j < mp->m_quotainfo->qi_dqperchunk; j++) {
 		/*
 		 * Do a sanity check, and if needed, repair the dqblk. Don't
diff --git a/fs/xfs/xfs_ag.h b/fs/xfs/xfs_ag.h
index 6530769..4805f00 100644
--- a/fs/xfs/xfs_ag.h
+++ b/fs/xfs/xfs_ag.h
@@ -103,7 +103,7 @@ typedef struct xfs_agf {
 /* disk block (xfs_daddr_t) in the AG */
 #define XFS_AGF_DADDR(mp)	((xfs_daddr_t)(1 << (mp)->m_sectbb_log))
 #define	XFS_AGF_BLOCK(mp)	XFS_HDR_BLOCK(mp, XFS_AGF_DADDR(mp))
-#define	XFS_BUF_TO_AGF(bp)	((xfs_agf_t *)XFS_BUF_PTR(bp))
+#define	XFS_BUF_TO_AGF(bp)	((xfs_agf_t *)((bp)->b_addr))
 
 extern int xfs_read_agf(struct xfs_mount *mp, struct xfs_trans *tp,
 			xfs_agnumber_t agno, int flags, struct xfs_buf **bpp);
@@ -156,7 +156,7 @@ typedef struct xfs_agi {
 /* disk block (xfs_daddr_t) in the AG */
 #define XFS_AGI_DADDR(mp)	((xfs_daddr_t)(2 << (mp)->m_sectbb_log))
 #define	XFS_AGI_BLOCK(mp)	XFS_HDR_BLOCK(mp, XFS_AGI_DADDR(mp))
-#define	XFS_BUF_TO_AGI(bp)	((xfs_agi_t *)XFS_BUF_PTR(bp))
+#define	XFS_BUF_TO_AGI(bp)	((xfs_agi_t *)((bp)->b_addr))
 
 extern int xfs_read_agi(struct xfs_mount *mp, struct xfs_trans *tp,
 				xfs_agnumber_t agno, struct xfs_buf **bpp);
@@ -168,7 +168,7 @@ extern int xfs_read_agi(struct xfs_mount *mp, struct xfs_trans *tp,
 #define XFS_AGFL_DADDR(mp)	((xfs_daddr_t)(3 << (mp)->m_sectbb_log))
 #define	XFS_AGFL_BLOCK(mp)	XFS_HDR_BLOCK(mp, XFS_AGFL_DADDR(mp))
 #define XFS_AGFL_SIZE(mp)	((mp)->m_sb.sb_sectsize / sizeof(xfs_agblock_t))
-#define	XFS_BUF_TO_AGFL(bp)	((xfs_agfl_t *)XFS_BUF_PTR(bp))
+#define	XFS_BUF_TO_AGFL(bp)	((xfs_agfl_t *)((bp)->b_addr))
 
 typedef struct xfs_agfl {
 	__be32		agfl_bno[1];	/* actually XFS_AGFL_SIZE(mp) */
diff --git a/fs/xfs/xfs_bmap.c b/fs/xfs/xfs_bmap.c
index e546a33..ff40b56 100644
--- a/fs/xfs/xfs_bmap.c
+++ b/fs/xfs/xfs_bmap.c
@@ -3385,8 +3385,7 @@ xfs_bmap_local_to_extents(
 		ASSERT(args.len == 1);
 		*firstblock = args.fsbno;
 		bp = xfs_btree_get_bufl(args.mp, tp, args.fsbno, 0);
-		memcpy((char *)XFS_BUF_PTR(bp), ifp->if_u1.if_data,
-			ifp->if_bytes);
+		memcpy(bp->b_addr, ifp->if_u1.if_data, ifp->if_bytes);
 		xfs_trans_log_buf(tp, bp, 0, ifp->if_bytes - 1);
 		xfs_bmap_forkoff_reset(args.mp, ip, whichfork);
 		xfs_idata_realloc(ip, -ifp->if_bytes, whichfork);
diff --git a/fs/xfs/xfs_btree.h b/fs/xfs/xfs_btree.h
index 82fafc6..202fed0 100644
--- a/fs/xfs/xfs_btree.h
+++ b/fs/xfs/xfs_btree.h
@@ -281,7 +281,7 @@ typedef struct xfs_btree_cur
 /*
  * Convert from buffer to btree block header.
  */
-#define	XFS_BUF_TO_BLOCK(bp)	((struct xfs_btree_block *)XFS_BUF_PTR(bp))
+#define	XFS_BUF_TO_BLOCK(bp)	((struct xfs_btree_block *)((bp)->b_addr))
 
 
 /*
diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index dc7b096..c4f01e0 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -126,9 +126,9 @@ xfs_buf_item_log_check(
 
 	bp = bip->bli_buf;
 	ASSERT(XFS_BUF_COUNT(bp) > 0);
-	ASSERT(XFS_BUF_PTR(bp) != NULL);
+	ASSERT(bp->b_addr != NULL);
 	orig = bip->bli_orig;
-	buffer = XFS_BUF_PTR(bp);
+	buffer = bp->b_addr;
 	for (x = 0; x < XFS_BUF_COUNT(bp); x++) {
 		if (orig[x] != buffer[x] && !btst(bip->bli_logged, x)) {
 			xfs_emerg(bp->b_mount,
@@ -731,7 +731,7 @@ xfs_buf_item_init(
 	 * to have logged.
 	 */
 	bip->bli_orig = (char *)kmem_alloc(XFS_BUF_COUNT(bp), KM_SLEEP);
-	memcpy(bip->bli_orig, XFS_BUF_PTR(bp), XFS_BUF_COUNT(bp));
+	memcpy(bip->bli_orig, bp->b_addr, XFS_BUF_COUNT(bp));
 	bip->bli_logged = (char *)kmem_zalloc(XFS_BUF_COUNT(bp) / NBBY, KM_SLEEP);
 #endif
 
diff --git a/fs/xfs/xfs_da_btree.c b/fs/xfs/xfs_da_btree.c
index 03de079..c4b6fbe 100644
--- a/fs/xfs/xfs_da_btree.c
+++ b/fs/xfs/xfs_da_btree.c
@@ -2266,7 +2266,7 @@ xfs_da_buf_make(int nbuf, xfs_buf_t **bps, inst_t *ra)
 		dabuf->nbuf = 1;
 		bp = bps[0];
 		dabuf->bbcount = (short)BTOBB(XFS_BUF_COUNT(bp));
-		dabuf->data = XFS_BUF_PTR(bp);
+		dabuf->data = bp->b_addr;
 		dabuf->bps[0] = bp;
 	} else {
 		dabuf->nbuf = nbuf;
@@ -2277,7 +2277,7 @@ xfs_da_buf_make(int nbuf, xfs_buf_t **bps, inst_t *ra)
 		dabuf->data = kmem_alloc(BBTOB(dabuf->bbcount), KM_SLEEP);
 		for (i = off = 0; i < nbuf; i++, off += XFS_BUF_COUNT(bp)) {
 			bp = bps[i];
-			memcpy((char *)dabuf->data + off, XFS_BUF_PTR(bp),
+			memcpy((char *)dabuf->data + off, bp->b_addr,
 				XFS_BUF_COUNT(bp));
 		}
 	}
@@ -2317,7 +2317,7 @@ xfs_da_buf_clean(xfs_dabuf_t *dabuf)
 		for (i = off = 0; i < dabuf->nbuf;
 				i++, off += XFS_BUF_COUNT(bp)) {
 			bp = dabuf->bps[i];
-			memcpy(XFS_BUF_PTR(bp), (char *)dabuf->data + off,
+			memcpy(bp->b_addr, (char *)dabuf->data + off,
 				XFS_BUF_COUNT(bp));
 		}
 	}
@@ -2368,7 +2368,7 @@ xfs_da_log_buf(xfs_trans_t *tp, xfs_dabuf_t *dabuf, uint first, uint last)
 
 	ASSERT(dabuf->nbuf && dabuf->data && dabuf->bbcount && dabuf->bps[0]);
 	if (dabuf->nbuf == 1) {
-		ASSERT(dabuf->data == (void *)XFS_BUF_PTR(dabuf->bps[0]));
+		ASSERT(dabuf->data == dabuf->bps[0]->b_addr);
 		xfs_trans_log_buf(tp, dabuf->bps[0], first, last);
 		return;
 	}
diff --git a/fs/xfs/xfs_dinode.h b/fs/xfs/xfs_dinode.h
index dffba9b..a372163 100644
--- a/fs/xfs/xfs_dinode.h
+++ b/fs/xfs/xfs_dinode.h
@@ -148,7 +148,7 @@ typedef enum xfs_dinode_fmt {
 		be32_to_cpu((dip)->di_nextents) : \
 		be16_to_cpu((dip)->di_anextents))
 
-#define	XFS_BUF_TO_DINODE(bp)	((xfs_dinode_t *)XFS_BUF_PTR(bp))
+#define	XFS_BUF_TO_DINODE(bp)	((xfs_dinode_t *)((bp)->b_addr))
 
 /*
  * For block and character special files the 32bit dev_t is stored at the
diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 721a63d..23158a5 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1414,7 +1414,7 @@ xlog_sync(xlog_t		*log,
 		bp->b_flags |= XBF_LOG_BUFFER;
 		if (log->l_mp->m_flags & XFS_MOUNT_BARRIER)
 			XFS_BUF_ORDERED(bp);
-		dptr = XFS_BUF_PTR(bp);
+		dptr = bp->b_addr;
 		/*
 		 * Bump the cycle numbers at the start of each block
 		 * since this part of the buffer is at the start of
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 87d7d95..01b5417 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -143,7 +143,7 @@ xlog_align(
 	xfs_daddr_t	offset = blk_no & ((xfs_daddr_t)log->l_sectBBsize - 1);
 
 	ASSERT(BBTOB(offset + nbblks) <= XFS_BUF_SIZE(bp));
-	return XFS_BUF_PTR(bp) + BBTOB(offset);
+	return bp->b_addr + BBTOB(offset);
 }
 
 
@@ -215,7 +215,7 @@ xlog_bread_offset(
 	xfs_buf_t	*bp,
 	xfs_caddr_t	offset)
 {
-	xfs_caddr_t	orig_offset = XFS_BUF_PTR(bp);
+	xfs_caddr_t	orig_offset = bp->b_addr;
 	int		orig_len = bp->b_buffer_length;
 	int		error, error2;
 
@@ -1256,7 +1256,7 @@ xlog_write_log_records(
 		 */
 		ealign = round_down(end_block, sectbb);
 		if (j == 0 && (start_block + endcount > ealign)) {
-			offset = XFS_BUF_PTR(bp) + BBTOB(ealign - start_block);
+			offset = bp->b_addr + BBTOB(ealign - start_block);
 			error = xlog_bread_offset(log, ealign, sectbb,
 							bp, offset);
 			if (error)
@@ -3431,7 +3431,7 @@ xlog_do_recovery_pass(
 			/*
 			 * Check for header wrapping around physical end-of-log
 			 */
-			offset = XFS_BUF_PTR(hbp);
+			offset = hbp->b_addr;
 			split_hblks = 0;
 			wrapped_hblks = 0;
 			if (blk_no + hblks <= log->l_logBBsize) {
@@ -3491,7 +3491,7 @@ xlog_do_recovery_pass(
 			} else {
 				/* This log record is split across the
 				 * physical end of log */
-				offset = XFS_BUF_PTR(dbp);
+				offset = dbp->b_addr;
 				split_bblks = 0;
 				if (blk_no != log->l_logBBsize) {
 					/* some data is before the physical
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 2243cfb..79e0e14 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -168,7 +168,7 @@ error_cancel:
 				xfs_trans_cancel(tp, cancelflags);
 				goto error;
 			}
-			memset(XFS_BUF_PTR(bp), 0, mp->m_sb.sb_blocksize);
+			memset(bp->b_addr, 0, mp->m_sb.sb_blocksize);
 			xfs_trans_log_buf(tp, bp, 0, mp->m_sb.sb_blocksize - 1);
 			/*
 			 * Commit the transaction.
@@ -943,7 +943,7 @@ xfs_rtcheck_range(
 	if (error) {
 		return error;
 	}
-	bufp = (xfs_rtword_t *)XFS_BUF_PTR(bp);
+	bufp = bp->b_addr;
 	/*
 	 * Compute the starting word's address, and starting bit.
 	 */
@@ -994,7 +994,7 @@ xfs_rtcheck_range(
 			if (error) {
 				return error;
 			}
-			b = bufp = (xfs_rtword_t *)XFS_BUF_PTR(bp);
+			b = bufp = bp->b_addr;
 			word = 0;
 		} else {
 			/*
@@ -1040,7 +1040,7 @@ xfs_rtcheck_range(
 			if (error) {
 				return error;
 			}
-			b = bufp = (xfs_rtword_t *)XFS_BUF_PTR(bp);
+			b = bufp = bp->b_addr;
 			word = 0;
 		} else {
 			/*
@@ -1158,7 +1158,7 @@ xfs_rtfind_back(
 	if (error) {
 		return error;
 	}
-	bufp = (xfs_rtword_t *)XFS_BUF_PTR(bp);
+	bufp = bp->b_addr;
 	/*
 	 * Get the first word's index & point to it.
 	 */
@@ -1210,7 +1210,7 @@ xfs_rtfind_back(
 			if (error) {
 				return error;
 			}
-			bufp = (xfs_rtword_t *)XFS_BUF_PTR(bp);
+			bufp = bp->b_addr;
 			word = XFS_BLOCKWMASK(mp);
 			b = &bufp[word];
 		} else {
@@ -1256,7 +1256,7 @@ xfs_rtfind_back(
 			if (error) {
 				return error;
 			}
-			bufp = (xfs_rtword_t *)XFS_BUF_PTR(bp);
+			bufp = bp->b_addr;
 			word = XFS_BLOCKWMASK(mp);
 			b = &bufp[word];
 		} else {
@@ -1333,7 +1333,7 @@ xfs_rtfind_forw(
 	if (error) {
 		return error;
 	}
-	bufp = (xfs_rtword_t *)XFS_BUF_PTR(bp);
+	bufp = bp->b_addr;
 	/*
 	 * Get the first word's index & point to it.
 	 */
@@ -1384,7 +1384,7 @@ xfs_rtfind_forw(
 			if (error) {
 				return error;
 			}
-			b = bufp = (xfs_rtword_t *)XFS_BUF_PTR(bp);
+			b = bufp = bp->b_addr;
 			word = 0;
 		} else {
 			/*
@@ -1429,7 +1429,7 @@ xfs_rtfind_forw(
 			if (error) {
 				return error;
 			}
-			b = bufp = (xfs_rtword_t *)XFS_BUF_PTR(bp);
+			b = bufp = bp->b_addr;
 			word = 0;
 		} else {
 			/*
@@ -1649,7 +1649,7 @@ xfs_rtmodify_range(
 	if (error) {
 		return error;
 	}
-	bufp = (xfs_rtword_t *)XFS_BUF_PTR(bp);
+	bufp = bp->b_addr;
 	/*
 	 * Compute the starting word's address, and starting bit.
 	 */
@@ -1694,7 +1694,7 @@ xfs_rtmodify_range(
 			if (error) {
 				return error;
 			}
-			first = b = bufp = (xfs_rtword_t *)XFS_BUF_PTR(bp);
+			first = b = bufp = bp->b_addr;
 			word = 0;
 		} else {
 			/*
@@ -1734,7 +1734,7 @@ xfs_rtmodify_range(
 			if (error) {
 				return error;
 			}
-			first = b = bufp = (xfs_rtword_t *)XFS_BUF_PTR(bp);
+			first = b = bufp = bp->b_addr;
 			word = 0;
 		} else {
 			/*
@@ -1832,8 +1832,8 @@ xfs_rtmodify_summary(
 	 */
 	sp = XFS_SUMPTR(mp, bp, so);
 	*sp += delta;
-	xfs_trans_log_buf(tp, bp, (uint)((char *)sp - (char *)XFS_BUF_PTR(bp)),
-		(uint)((char *)sp - (char *)XFS_BUF_PTR(bp) + sizeof(*sp) - 1));
+	xfs_trans_log_buf(tp, bp, (uint)((char *)sp - (char *)bp->b_addr),
+		(uint)((char *)sp - (char *)bp->b_addr + sizeof(*sp) - 1));
 	return 0;
 }
 
diff --git a/fs/xfs/xfs_rtalloc.h b/fs/xfs/xfs_rtalloc.h
index 09e1f4f..f7f3a35 100644
--- a/fs/xfs/xfs_rtalloc.h
+++ b/fs/xfs/xfs_rtalloc.h
@@ -47,7 +47,7 @@ struct xfs_trans;
 #define	XFS_SUMOFFSTOBLOCK(mp,s)	\
 	(((s) * (uint)sizeof(xfs_suminfo_t)) >> (mp)->m_sb.sb_blocklog)
 #define	XFS_SUMPTR(mp,bp,so)	\
-	((xfs_suminfo_t *)((char *)XFS_BUF_PTR(bp) + \
+	((xfs_suminfo_t *)((bp)->b_addr + \
 		(((so) * (uint)sizeof(xfs_suminfo_t)) & XFS_BLOCKMASK(mp))))
 
 #define	XFS_BITTOBLOCK(mp,bi)	((bi) >> (mp)->m_blkbit_log)
diff --git a/fs/xfs/xfs_sb.h b/fs/xfs/xfs_sb.h
index 1eb2ba5..cb6ae71 100644
--- a/fs/xfs/xfs_sb.h
+++ b/fs/xfs/xfs_sb.h
@@ -509,7 +509,7 @@ static inline int xfs_sb_version_hasprojid32bit(xfs_sb_t *sbp)
 
 #define XFS_SB_DADDR		((xfs_daddr_t)0) /* daddr in filesystem/ag */
 #define	XFS_SB_BLOCK(mp)	XFS_HDR_BLOCK(mp, XFS_SB_DADDR)
-#define XFS_BUF_TO_SBP(bp)	((xfs_dsb_t *)XFS_BUF_PTR(bp))
+#define XFS_BUF_TO_SBP(bp)	((xfs_dsb_t *)((bp)->b_addr))
 
 #define	XFS_HDR_BLOCK(mp,d)	((xfs_agblock_t)XFS_BB_TO_FSBT(mp,d))
 #define	XFS_DADDR_TO_FSB(mp,d)	XFS_AGB_TO_FSB(mp, \
diff --git a/fs/xfs/xfs_vnodeops.c b/fs/xfs/xfs_vnodeops.c
index 0eb5c48..052947d 100644
--- a/fs/xfs/xfs_vnodeops.c
+++ b/fs/xfs/xfs_vnodeops.c
@@ -518,7 +518,7 @@ xfs_readlink_bmap(
 			byte_cnt = pathlen;
 		pathlen -= byte_cnt;
 
-		memcpy(link, XFS_BUF_PTR(bp), byte_cnt);
+		memcpy(link, bp->b_addr, byte_cnt);
 		xfs_buf_relse(bp);
 	}
 
@@ -2115,7 +2115,7 @@ xfs_symlink(
 			}
 			pathlen -= byte_cnt;
 
-			memcpy(XFS_BUF_PTR(bp), cur_chunk, byte_cnt);
+			memcpy(bp->b_addr, cur_chunk, byte_cnt);
 			cur_chunk += byte_cnt;
 
 			xfs_trans_log_buf(tp, bp, 0, byte_cnt - 1);
@@ -2458,7 +2458,7 @@ xfs_zero_remaining_bytes(
 					  mp, bp, XFS_BUF_ADDR(bp));
 			break;
 		}
-		memset(XFS_BUF_PTR(bp) +
+		memset(bp->b_addr +
 			(offset - XFS_FSB_TO_B(mp, imap.br_startoff)),
 		      0, lastoffset - offset + 1);
 		XFS_BUF_UNDONE(bp);
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
