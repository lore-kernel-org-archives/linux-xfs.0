Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3DCBGe2037870 for <xfs@oss.sgi.com>; Fri, 13 Apr 2012 07:11:16 -0500
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	8jDbjy22dBufemIu for <xfs@oss.sgi.com>;
	Fri, 13 Apr 2012 05:11:15 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1SIfLO-00031K-1v
	for xfs@oss.sgi.com; Fri, 13 Apr 2012 22:11:14 +1000
Received: from dave by disappointment with local (Exim 4.77)
	(envelope-from <dave@disappointment.disaster>) id 1SIfLD-0003O7-VQ
	for xfs@oss.sgi.com; Fri, 13 Apr 2012 22:11:03 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 06/18] xfs: fix buffer lookup race on allocation failure
Date: Fri, 13 Apr 2012 22:10:49 +1000
Message-Id: <1334319061-12968-7-git-send-email-david@fromorbit.com>
In-Reply-To: <1334319061-12968-1-git-send-email-david@fromorbit.com>
References: <1334319061-12968-1-git-send-email-david@fromorbit.com>
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
---
 fs/xfs/xfs_buf.c |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 193e1de..1578721 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -546,18 +546,20 @@ xfs_buf_get(
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
-- 
1.7.9.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
