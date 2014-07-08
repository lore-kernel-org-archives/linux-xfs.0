Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 0DF707F5A
	for <xfs@oss.sgi.com>; Tue,  8 Jul 2014 18:41:51 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 9A538AC003
	for <xfs@oss.sgi.com>; Tue,  8 Jul 2014 16:41:47 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	NO9rCI22qd0qqNhk for <xfs@oss.sgi.com>;
	Tue, 08 Jul 2014 16:41:46 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1X4f14-0006T2-Kv
	for xfs@oss.sgi.com; Wed, 09 Jul 2014 09:41:42 +1000
Received: from dave by disappointment with local (Exim 4.82_1-5b7a7c0-XX)
	(envelope-from <dave@disappointment.disaster>) id 1X4f14-0000t4-K3
	for xfs@oss.sgi.com; Wed, 09 Jul 2014 09:41:42 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 1/2] libxfs: clear the buffer error while the buffer is locked
Date: Wed,  9 Jul 2014 09:41:39 +1000
Message-Id: <1404862900-3369-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1404862900-3369-1-git-send-email-david@fromorbit.com>
References: <1404862900-3369-1-git-send-email-david@fromorbit.com>
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

When releasing a buffer, the error shoul dbe cleared while the lock
is still held on the buffer to avoid racing with a new user of the
buffer.

This was pointed out in review of commit 6af7c1e ("libxfs: reused
invalidated buffers leak state and data") but the version committed
didn't have the fix. Thanks to Christoph Hellwig for checking and
pointing out the oversight.

Reported-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 libxfs/rdwr.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
index 0294c98..9ee89d3 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -648,6 +648,12 @@ libxfs_getbuf_map(struct xfs_buftarg *btp, struct xfs_buf_map *map,
 void
 libxfs_putbuf(xfs_buf_t *bp)
 {
+	/*
+	 * ensure that any errors on this use of the buffer don't carry
+	 * over to the next user.
+	 */
+	bp->b_error = 0;
+
 #ifdef XFS_BUF_TRACING
 	pthread_mutex_lock(&libxfs_bcache->c_mutex);
 	lock_buf_count--;
@@ -663,11 +669,6 @@ libxfs_putbuf(xfs_buf_t *bp)
 			pthread_mutex_unlock(&bp->b_lock);
 		}
 	}
-	/*
-	 * ensure that any errors on this use of the buffer don't carry
-	 * over to the next user.
-	 */
-	bp->b_error = 0;
 
 	cache_node_put(libxfs_bcache, (struct cache_node *)bp);
 }
-- 
2.0.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
