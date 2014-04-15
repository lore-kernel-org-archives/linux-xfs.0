Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id D6ECE7F52
	for <xfs@oss.sgi.com>; Tue, 15 Apr 2014 03:25:12 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 629AFAC006
	for <xfs@oss.sgi.com>; Tue, 15 Apr 2014 01:25:12 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	eXqSxvarsAODOSoY for <xfs@oss.sgi.com>;
	Tue, 15 Apr 2014 01:25:10 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1WZyfv-0003WO-86
	for xfs@oss.sgi.com; Tue, 15 Apr 2014 18:25:03 +1000
Received: from dave by disappointment with local (Exim 4.82)
	(envelope-from <dave@disappointment.disaster>) id 1WZyfv-0008Pu-7I
	for xfs@oss.sgi.com; Tue, 15 Apr 2014 18:25:03 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 3/9] repair: ensure prefetched buffers have CRCs validated
Date: Tue, 15 Apr 2014 18:24:55 +1000
Message-Id: <1397550301-31883-4-git-send-email-david@fromorbit.com>
In-Reply-To: <1397550301-31883-1-git-send-email-david@fromorbit.com>
References: <1397550301-31883-1-git-send-email-david@fromorbit.com>
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
 include/libxfs.h  |  1 +
 libxfs/rdwr.c     | 36 +++++++++++++++++++++++++++++++-----
 repair/prefetch.c |  3 +++
 3 files changed, 35 insertions(+), 5 deletions(-)

diff --git a/include/libxfs.h b/include/libxfs.h
index 6bc6c94..6b1e276 100644
--- a/include/libxfs.h
+++ b/include/libxfs.h
@@ -333,6 +333,7 @@ enum xfs_buf_flags_t {	/* b_flags bits */
 	LIBXFS_B_STALE		= 0x0004,	/* buffer marked as invalid */
 	LIBXFS_B_UPTODATE	= 0x0008,	/* buffer is sync'd to disk */
 	LIBXFS_B_DISCONTIG	= 0x0010,	/* discontiguous buffer */
+	LIBXFS_B_UNCHECKED	= 0x0020,	/* needs verification */
 };
 
 #define XFS_BUF_DADDR_NULL		((xfs_daddr_t) (-1LL))
diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
index 7208a2f..a8f06aa 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -718,12 +718,25 @@ libxfs_readbuf(struct xfs_buftarg *btp, xfs_daddr_t blkno, int len, int flags,
 	bp = libxfs_getbuf(btp, blkno, len);
 	if (!bp)
 		return NULL;
-	if ((bp->b_flags & (LIBXFS_B_UPTODATE|LIBXFS_B_DIRTY)))
+
+	/*
+	 * if the buffer was prefetched, it is likely that it was not
+	 * validated. Hence if we are supplied an ops function and the
+	 * buffer is marked as unchecked, we need to validate it now.
+	 */
+	if ((bp->b_flags & (LIBXFS_B_UPTODATE|LIBXFS_B_DIRTY))) {
+		if (ops && (bp->b_flags & LIBXFS_B_UNCHECKED)) {
+			bp->b_error = 0;
+			bp->b_ops = ops;
+			bp->b_ops->verify_read(bp);
+			bp->b_flags &= ~LIBXFS_B_UNCHECKED;
+		}
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
@@ -733,8 +746,10 @@ libxfs_readbuf(struct xfs_buftarg *btp, xfs_daddr_t blkno, int len, int flags,
 	error = libxfs_readbufr(btp, blkno, bp, len, flags);
 	if (error)
 		bp->b_error = error;
-	else if (bp->b_ops)
+	else if (bp->b_ops) {
 		bp->b_ops->verify_read(bp);
+		bp->b_flags &= ~LIBXFS_B_UNCHECKED;
+	}
 	return bp;
 }
 
@@ -786,6 +801,14 @@ libxfs_readbuf_map(struct xfs_buftarg *btp, struct xfs_buf_map *map, int nmaps,
 		return NULL;
 
 	bp->b_error = 0;
+	if ((bp->b_flags & (LIBXFS_B_UPTODATE|LIBXFS_B_DIRTY))) {
+		if (ops && (bp->b_flags & LIBXFS_B_UNCHECKED)) {
+			bp->b_ops = ops;
+			bp->b_ops->verify_read(bp);
+			bp->b_flags &= ~LIBXFS_B_UNCHECKED;
+		}
+		return bp;
+	}
 	bp->b_ops = ops;
 	if ((bp->b_flags & (LIBXFS_B_UPTODATE|LIBXFS_B_DIRTY)))
 		return bp;
@@ -793,8 +816,10 @@ libxfs_readbuf_map(struct xfs_buftarg *btp, struct xfs_buf_map *map, int nmaps,
 	error = libxfs_readbufr_map(btp, bp, flags);
 	if (!error) {
 		bp->b_flags |= LIBXFS_B_UPTODATE;
-		if (bp->b_ops)
+		if (bp->b_ops) {
 			bp->b_ops->verify_read(bp);
+			bp->b_flags &= ~LIBXFS_B_UNCHECKED;
+		}
 	}
 #ifdef IO_DEBUG
 	printf("%lx: %s: read %lu bytes, error %d, blkno=%llu(%llu), %p\n",
@@ -889,6 +914,7 @@ libxfs_writebufr(xfs_buf_t *bp)
 	if (!error) {
 		bp->b_flags |= LIBXFS_B_UPTODATE;
 		bp->b_flags &= ~(LIBXFS_B_DIRTY | LIBXFS_B_EXIT);
+		bp->b_flags &= ~LIBXFS_B_UNCHECKED;
 	}
 	return error;
 }
diff --git a/repair/prefetch.c b/repair/prefetch.c
index 6d6d344..d794ba3 100644
--- a/repair/prefetch.c
+++ b/repair/prefetch.c
@@ -389,6 +389,7 @@ pf_read_inode_dirs(
 
 	bp->b_ops = &xfs_inode_buf_ops;
 	bp->b_ops->verify_read(bp);
+	bp->b_flags &= ~LIBXFS_B_UNCHECKED;
 	if (bp->b_error)
 		return;
 
@@ -460,6 +461,7 @@ pf_read_discontig(
 
 	pthread_mutex_unlock(&args->lock);
 	libxfs_readbufr_map(mp->m_ddev_targp, bp, 0);
+	bp->b_flags |= LIBXFS_B_UNCHECKED;
 	libxfs_putbuf(bp);
 	pthread_mutex_lock(&args->lock);
 }
@@ -583,6 +585,7 @@ pf_batch_read(
 					break;
 				memcpy(XFS_BUF_PTR(bplist[i]), pbuf, size);
 				bplist[i]->b_flags |= LIBXFS_B_UPTODATE;
+				bplist[i]->b_flags |= LIBXFS_B_UNCHECKED;
 				len -= size;
 				if (B_IS_INODE(XFS_BUF_PRIORITY(bplist[i])))
 					pf_read_inode_dirs(args, bplist[i]);
-- 
1.9.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
