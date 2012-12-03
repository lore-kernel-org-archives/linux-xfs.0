Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qB3NegAL067694 for <xfs@oss.sgi.com>; Mon, 3 Dec 2012 17:40:42 -0600
Message-Id: <20121203144310.928951136@sgi.com>
Date: Mon, 03 Dec 2012 17:42:31 -0600
From: Mark Tinguely <tinguely@sgi.com>
Subject: [3.0-stable PATCH 23/36] xfs: fix buffer lookup race on allocation
	failure
References: <20121203144208.143464631@sgi.com>
Content-Disposition: inline; filename=081
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
To: stable@vger.kernel.org
Cc: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

Upstream commit: fe2429b0966a7ec42b5fe3bf96f0f10de0a3b536

When memory allocation fails to add the page array or tht epages to
a buffer during xfs_buf_get(), the buffer is left in the cache in a
partially initialised state. There is enough state left for the next
lookup on that buffer to find the buffer, and for the buffer to then
be used without finishing the initialisation.  As a result, when an
attempt to do IO on the buffer occurs, it fails with EIO because
there are no pages attached to the buffer.

We cannot remove the buffer from the cache immediately and free it,
because there may already be a racing lookup that is blocked on the
buffer lock. Hence the moment we unlock the buffer to then free it,
the other user is woken and we have a use-after-free situation.

To avoid this race condition altogether, allocate the pages for the
buffer before we insert it into the cache.  This then means that we
don't have an allocation  failure case to deal after the buffer is
already present in the cache, and hence avoid the problem
altogether.  In most cases we won't have racing inserts for the same
buffer, and so won't increase the memory pressure allocation before
insertion may entail.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Mark Tinguely <tinguely@sgi.com>
Signed-off-by: Ben Myers <bpm@sgi.com>
---
 fs/xfs/linux-2.6/xfs_buf.c |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

Index: b/fs/xfs/linux-2.6/xfs_buf.c
===================================================================
--- a/fs/xfs/linux-2.6/xfs_buf.c
+++ b/fs/xfs/linux-2.6/xfs_buf.c
@@ -551,18 +551,20 @@ xfs_buf_get(
 	if (unlikely(!new_bp))
 		return NULL;
 
+	error = xfs_buf_allocate_memory(new_bp, flags);
+	if (error) {
+		kmem_zone_free(xfs_buf_zone, new_bp);
+		return NULL;
+	}
+
 	bp = _xfs_buf_find(target, ioff, isize, flags, new_bp);
 	if (!bp) {
-		kmem_zone_free(xfs_buf_zone, new_bp);
+		xfs_buf_free(new_bp);
 		return NULL;
 	}
 
-	if (bp == new_bp) {
-		error = xfs_buf_allocate_memory(bp, flags);
-		if (error)
-			goto no_buffer;
-	} else
-		kmem_zone_free(xfs_buf_zone, new_bp);
+	if (bp != new_bp)
+		xfs_buf_free(new_bp);
 
 	/*
 	 * Now we have a workable buffer, fill in the block number so


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
