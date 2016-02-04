Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 8DD6B29E03
	for <xfs@oss.sgi.com>; Thu,  4 Feb 2016 17:07:38 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 7CE72304059
	for <xfs@oss.sgi.com>; Thu,  4 Feb 2016 15:07:38 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	QMoB6DDbRGZqs9OP for <xfs@oss.sgi.com>;
	Thu, 04 Feb 2016 15:07:36 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1aRSxa-0000Ee-CJ
	for xfs@oss.sgi.com; Fri, 05 Feb 2016 10:05:10 +1100
Received: from dave by disappointment with local (Exim 4.86)
	(envelope-from <dave@disappointment.disaster>) id 1aRSxa-0004zB-Bp
	for xfs@oss.sgi.com; Fri, 05 Feb 2016 10:05:10 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 5/7] libxfs: don't repeatedly shake unwritable buffers
Date: Fri,  5 Feb 2016 10:05:06 +1100
Message-Id: <1454627108-19036-6-git-send-email-david@fromorbit.com>
In-Reply-To: <1454627108-19036-1-git-send-email-david@fromorbit.com>
References: <1454627108-19036-1-git-send-email-david@fromorbit.com>
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

now that we try to write dirty buffers before we release them, we
can get buildup of unwritable dirty buffers on the LRU lists, This
results in the cache shaker repeatedly trying to write out these
buffers every time the cache fills up. This results in more
corruption warnings, and takes up a lot of time doing reclaiming
nothing. This can effectively livelock the processing parts of phase
4.

Fix this by not trying to write buffers with corruption errors on
them. These errors will get cleared when the buffer is re-read and
fixed and them marked dirty again. At which point, we'll be able to
write them and so the cache can reclaim them successfully.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 libxfs/rdwr.c | 27 ++++++++++++++++-----------
 1 file changed, 16 insertions(+), 11 deletions(-)

diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
index 37162cd..2e298c2 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -1103,7 +1103,6 @@ int
 libxfs_writebufr(xfs_buf_t *bp)
 {
 	int	fd = libxfs_device_to_fd(bp->b_target->dev);
-	int	error = 0;
 
 	/*
 	 * we never write buffers that are marked stale. This indicates they
@@ -1134,7 +1133,7 @@ libxfs_writebufr(xfs_buf_t *bp)
 	}
 
 	if (!(bp->b_flags & LIBXFS_B_DISCONTIG)) {
-		error = __write_buf(fd, bp->b_addr, bp->b_bcount,
+		bp->b_error = __write_buf(fd, bp->b_addr, bp->b_bcount,
 				    LIBXFS_BBTOOFF64(bp->b_bn), bp->b_flags);
 	} else {
 		int	i;
@@ -1144,11 +1143,10 @@ libxfs_writebufr(xfs_buf_t *bp)
 			off64_t	offset = LIBXFS_BBTOOFF64(bp->b_map[i].bm_bn);
 			int len = BBTOB(bp->b_map[i].bm_len);
 
-			error = __write_buf(fd, buf, len, offset, bp->b_flags);
-			if (error) {
-				bp->b_error = error;
+			bp->b_error = __write_buf(fd, buf, len, offset,
+						  bp->b_flags);
+			if (bp->b_error)
 				break;
-			}
 			buf += len;
 		}
 	}
@@ -1157,14 +1155,14 @@ libxfs_writebufr(xfs_buf_t *bp)
 	printf("%lx: %s: wrote %u bytes, blkno=%llu(%llu), %p, error %d\n",
 			pthread_self(), __FUNCTION__, bp->b_bcount,
 			(long long)LIBXFS_BBTOOFF64(bp->b_bn),
-			(long long)bp->b_bn, bp, error);
+			(long long)bp->b_bn, bp, bp->b_error);
 #endif
-	if (!error) {
+	if (!bp->b_error) {
 		bp->b_flags |= LIBXFS_B_UPTODATE;
 		bp->b_flags &= ~(LIBXFS_B_DIRTY | LIBXFS_B_EXIT |
 				 LIBXFS_B_UNCHECKED);
 	}
-	return error;
+	return bp->b_error;
 }
 
 int
@@ -1266,15 +1264,22 @@ libxfs_bulkrelse(
 	return count;
 }
 
+/*
+ * When a buffer is marked dirty, the error is cleared. Hence if we are trying
+ * to flush a buffer prior to cache reclaim that has an error on it it means
+ * we've already tried to flush it and it failed. Prevent repeated corruption
+ * errors from being reported by skipping such buffers - when the corruption is
+ * fixed the buffer will be marked dirty again and we can write it again.
+ */
 static int
 libxfs_bflush(
 	struct cache_node	*node)
 {
 	struct xfs_buf		*bp = (struct xfs_buf *)node;
 
-	if (bp->b_flags & LIBXFS_B_DIRTY)
+	if (!bp->b_error && bp->b_flags & LIBXFS_B_DIRTY)
 		return libxfs_writebufr(bp);
-	return 0;
+	return bp->b_error;
 }
 
 void
-- 
2.5.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
