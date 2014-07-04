Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id CFEA67F37
	for <xfs@oss.sgi.com>; Fri,  4 Jul 2014 00:57:33 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 4A8C6AC001
	for <xfs@oss.sgi.com>; Thu,  3 Jul 2014 22:57:33 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	gY9ycpOLRIOckyzA for <xfs@oss.sgi.com>;
	Thu, 03 Jul 2014 22:57:31 -0700 (PDT)
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 4/6] libxfs: reused invalidated buffers leak state and data
Date: Fri,  4 Jul 2014 15:57:13 +1000
Message-Id: <1404453435-1915-5-git-send-email-david@fromorbit.com>
In-Reply-To: <1404453435-1915-1-git-send-email-david@fromorbit.com>
References: <1404453435-1915-1-git-send-email-david@fromorbit.com>
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

When rebuilding a bad directory, repair first truncates away all the
blocks in the directory, good or bad. This removes blocks from the
bmap btree, and when those blocks are freed the bmap btree code
invalidates them. This marks the buffers LIBXFS_B_STALE so that we
don't try to write stale data from that buffer at a later time.

However, when rebuilding the directory, blocks may get reallocated
and we reuse the underlying buffers. This has two problems.

The first is that if the buffer was previously detected as having a
verifier error (i.e. an error that is leading to the block being
freed and the buffer being invalidated) then the error might still
be held in b_error. Hence the libxfs code needs to ensure that
b_error does not leak from one buffer usage context to another
after invalidation.

The second problem is that when new data is written into a buffer,
it no longer has stale contents. Hence when we write the buffer, we
need to clear the LIBXFS_B_STALE flag to ensure that the new data
gets written.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 libxfs/rdwr.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
index 981f2ba..c81c82f 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -632,6 +632,12 @@ libxfs_putbuf(xfs_buf_t *bp)
 			pthread_mutex_unlock(&bp->b_lock);
 		}
 	}
+	/*
+	 * ensure that any errors on this use of the buffer don't carry
+	 * over to the next user.
+	 */
+	bp->b_error = 0;
+
 	cache_node_put(libxfs_bcache, (struct cache_node *)bp);
 }
 
@@ -928,6 +934,7 @@ libxfs_writebuf_int(xfs_buf_t *bp, int flags)
 	 * subsequent reads after this write from seeing stale errors.
 	 */
 	bp->b_error = 0;
+	bp->b_flags &= ~LIBXFS_B_STALE;
 	bp->b_flags |= (LIBXFS_B_DIRTY | flags);
 	return 0;
 }
@@ -946,6 +953,7 @@ libxfs_writebuf(xfs_buf_t *bp, int flags)
 	 * subsequent reads after this write from seeing stale errors.
 	 */
 	bp->b_error = 0;
+	bp->b_flags &= ~LIBXFS_B_STALE;
 	bp->b_flags |= (LIBXFS_B_DIRTY | flags);
 	libxfs_putbuf(bp);
 	return 0;
-- 
2.0.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
