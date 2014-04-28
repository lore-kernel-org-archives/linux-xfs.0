Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B2E5529DFE
	for <xfs@oss.sgi.com>; Mon, 28 Apr 2014 16:05:13 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 39BCEAC003
	for <xfs@oss.sgi.com>; Mon, 28 Apr 2014 14:05:13 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	ZCkqU7DTTuhnbl7J for <xfs@oss.sgi.com>;
	Mon, 28 Apr 2014 14:05:11 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1WesjV-00050w-IZ
	for xfs@oss.sgi.com; Tue, 29 Apr 2014 07:05:01 +1000
Received: from dave by disappointment with local (Exim 4.82)
	(envelope-from <dave@disappointment.disaster>) id 1WesjV-00050k-Hm
	for xfs@oss.sgi.com; Tue, 29 Apr 2014 07:05:01 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 3/9] repair: ensure prefetched buffers have CRCs validated
Date: Tue, 29 Apr 2014 07:04:53 +1000
Message-Id: <1398719099-19194-4-git-send-email-david@fromorbit.com>
In-Reply-To: <1398719099-19194-1-git-send-email-david@fromorbit.com>
References: <1398719099-19194-1-git-send-email-david@fromorbit.com>
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

Prefetch currently does not do CRC validation when the IO completes
due to the optimisation it performs and the fact that it does not
know what the type of metadata into the buffer is supposed to be.
Hence, mark all prefetched buffers as "suspect" so that when the
end user tries to read it with a supplied validation function the
validation is run even though the buffer was already in the cache.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 include/libxfs.h  |  2 ++
 libxfs/rdwr.c     | 58 ++++++++++++++++++++++++++++++++++++++++---------------
 repair/prefetch.c |  7 ++++---
 3 files changed, 48 insertions(+), 19 deletions(-)

diff --git a/include/libxfs.h b/include/libxfs.h
index 6b1e276..9c10957 100644
--- a/include/libxfs.h
+++ b/include/libxfs.h
@@ -436,6 +436,8 @@ extern void	libxfs_putbuf (xfs_buf_t *);
 
 #endif
 
+extern void	libxfs_readbuf_verify(struct xfs_buf *bp,
+			const struct xfs_buf_ops *ops);
 extern xfs_buf_t *libxfs_getsb(xfs_mount_t *, int);
 extern void	libxfs_bcache_purge(void);
 extern void	libxfs_bcache_flush(void);
diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
index 7208a2f..ea4bdfd 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -708,6 +708,17 @@ libxfs_readbufr(struct xfs_buftarg *btp, xfs_daddr_t blkno, xfs_buf_t *bp,
 	return error;
 }
 
+void
+libxfs_readbuf_verify(struct xfs_buf *bp, const struct xfs_buf_ops *ops)
+{
+	if (!ops)
+		return;
+	bp->b_ops = ops;
+	bp->b_ops->verify_read(bp);
+	bp->b_flags &= ~LIBXFS_B_UNCHECKED;
+}
+
+
 xfs_buf_t *
 libxfs_readbuf(struct xfs_buftarg *btp, xfs_daddr_t blkno, int len, int flags,
 		const struct xfs_buf_ops *ops)
@@ -718,23 +729,38 @@ libxfs_readbuf(struct xfs_buftarg *btp, xfs_daddr_t blkno, int len, int flags,
 	bp = libxfs_getbuf(btp, blkno, len);
 	if (!bp)
 		return NULL;
-	if ((bp->b_flags & (LIBXFS_B_UPTODATE|LIBXFS_B_DIRTY)))
+
+	/*
+	 * if the buffer was prefetched, it is likely that it was not validated.
+	 * Hence if we are supplied an ops function and the buffer is marked as
+	 * unchecked, we need to validate it now.
+	 *
+	 * We do this verification even if the buffer is dirty - the
+	 * verification is almost certainly going to fail the CRC check in this
+	 * case as a dirty buffer has not had the CRC recalculated. However, we
+	 * should not be dirtying unchecked buffers and therefore failing it
+	 * here because it's dirty and unchecked indicates we've screwed up
+	 * somewhere else.
+	 */
+	bp->b_error = 0;
+	if ((bp->b_flags & (LIBXFS_B_UPTODATE|LIBXFS_B_DIRTY))) {
+		if (bp->b_flags & LIBXFS_B_UNCHECKED)
+			libxfs_readbuf_verify(bp, ops);
 		return bp;
+	}
 
 	/*
-	 * only set the ops on a cache miss (i.e. first physical read) as the
-	 * verifier may change the ops to match the typ eof buffer it contains.
+	 * Set the ops on a cache miss (i.e. first physical read) as the
+	 * verifier may change the ops to match the type of buffer it contains.
 	 * A cache hit might reset the verifier to the original type if we set
 	 * it again, but it won't get called again and set to match the buffer
 	 * contents. *cough* xfs_da_node_buf_ops *cough*.
 	 */
-	bp->b_error = 0;
-	bp->b_ops = ops;
 	error = libxfs_readbufr(btp, blkno, bp, len, flags);
 	if (error)
 		bp->b_error = error;
-	else if (bp->b_ops)
-		bp->b_ops->verify_read(bp);
+	else
+		libxfs_readbuf_verify(bp, ops);
 	return bp;
 }
 
@@ -786,16 +812,15 @@ libxfs_readbuf_map(struct xfs_buftarg *btp, struct xfs_buf_map *map, int nmaps,
 		return NULL;
 
 	bp->b_error = 0;
-	bp->b_ops = ops;
-	if ((bp->b_flags & (LIBXFS_B_UPTODATE|LIBXFS_B_DIRTY)))
+	if ((bp->b_flags & (LIBXFS_B_UPTODATE|LIBXFS_B_DIRTY))) {
+		if (bp->b_flags & LIBXFS_B_UNCHECKED)
+			libxfs_readbuf_verify(bp, ops);
 		return bp;
-
-	error = libxfs_readbufr_map(btp, bp, flags);
-	if (!error) {
-		bp->b_flags |= LIBXFS_B_UPTODATE;
-		if (bp->b_ops)
-			bp->b_ops->verify_read(bp);
 	}
+	error = libxfs_readbufr_map(btp, bp, flags);
+	if (!error)
+		libxfs_readbuf_verify(bp, ops);
+
 #ifdef IO_DEBUG
 	printf("%lx: %s: read %lu bytes, error %d, blkno=%llu(%llu), %p\n",
 		pthread_self(), __FUNCTION__, buf - (char *)bp->b_addr, error,
@@ -888,7 +913,8 @@ libxfs_writebufr(xfs_buf_t *bp)
 #endif
 	if (!error) {
 		bp->b_flags |= LIBXFS_B_UPTODATE;
-		bp->b_flags &= ~(LIBXFS_B_DIRTY | LIBXFS_B_EXIT);
+		bp->b_flags &= ~(LIBXFS_B_DIRTY | LIBXFS_B_EXIT |
+				 LIBXFS_B_UNCHECKED);
 	}
 	return error;
 }
diff --git a/repair/prefetch.c b/repair/prefetch.c
index 6d6d344..65fedf5 100644
--- a/repair/prefetch.c
+++ b/repair/prefetch.c
@@ -387,8 +387,7 @@ pf_read_inode_dirs(
 	int			hasdir = 0;
 	int			isadir;
 
-	bp->b_ops = &xfs_inode_buf_ops;
-	bp->b_ops->verify_read(bp);
+	libxfs_readbuf_verify(bp, &xfs_inode_buf_ops);
 	if (bp->b_error)
 		return;
 
@@ -460,6 +459,7 @@ pf_read_discontig(
 
 	pthread_mutex_unlock(&args->lock);
 	libxfs_readbufr_map(mp->m_ddev_targp, bp, 0);
+	bp->b_flags |= LIBXFS_B_UNCHECKED;
 	libxfs_putbuf(bp);
 	pthread_mutex_lock(&args->lock);
 }
@@ -582,7 +582,8 @@ pf_batch_read(
 				if (len < size)
 					break;
 				memcpy(XFS_BUF_PTR(bplist[i]), pbuf, size);
-				bplist[i]->b_flags |= LIBXFS_B_UPTODATE;
+				bplist[i]->b_flags |= (LIBXFS_B_UPTODATE |
+						       LIBXFS_B_UNCHECKED);
 				len -= size;
 				if (B_IS_INODE(XFS_BUF_PRIORITY(bplist[i])))
 					pf_read_inode_dirs(args, bplist[i]);
-- 
1.9.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
