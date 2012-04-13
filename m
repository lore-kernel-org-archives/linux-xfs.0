Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3DCBLHL037922 for <xfs@oss.sgi.com>; Fri, 13 Apr 2012 07:11:22 -0500
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	PIGJeAImaWJmsHJW for <xfs@oss.sgi.com>;
	Fri, 13 Apr 2012 05:11:20 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1SIfLO-00030v-4X
	for xfs@oss.sgi.com; Fri, 13 Apr 2012 22:11:14 +1000
Received: from dave by disappointment with local (Exim 4.77)
	(envelope-from <dave@disappointment.disaster>) id 1SIfLE-0003OG-1w
	for xfs@oss.sgi.com; Fri, 13 Apr 2012 22:11:04 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 09/18] xfs: use kmem_zone_zalloc for buffers
Date: Fri, 13 Apr 2012 22:10:52 +1000
Message-Id: <1334319061-12968-10-git-send-email-david@fromorbit.com>
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

To replace the alloc/memset pair.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Mark Tinguely <tinguely@sgi.com>
---
 fs/xfs/xfs_buf.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index e7dab7d..fb88163 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -172,7 +172,7 @@ xfs_buf_alloc(
 {
 	struct xfs_buf		*bp;
 
-	bp = kmem_zone_alloc(xfs_buf_zone, xb_to_km(flags));
+	bp = kmem_zone_zalloc(xfs_buf_zone, xb_to_km(flags));
 	if (unlikely(!bp))
 		return NULL;
 
@@ -181,7 +181,6 @@ xfs_buf_alloc(
 	 */
 	flags &= ~(XBF_LOCK|XBF_MAPPED|XBF_DONT_BLOCK|XBF_READ_AHEAD);
 
-	memset(bp, 0, sizeof(xfs_buf_t));
 	atomic_set(&bp->b_hold, 1);
 	atomic_set(&bp->b_lru_ref, 1);
 	init_completion(&bp->b_iowait);
-- 
1.7.9.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
