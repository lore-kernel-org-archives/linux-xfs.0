Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2TCOLTk092071 for <xfs@oss.sgi.com>; Thu, 29 Mar 2012 07:24:21 -0500
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	I6ur0StKbJKL26YW for <xfs@oss.sgi.com>;
	Thu, 29 Mar 2012 05:24:20 -0700 (PDT)
Received: from [192.168.1.2] (helo=disappointment)
	by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1SDEOj-0003fG-JF
	for xfs@oss.sgi.com; Thu, 29 Mar 2012 23:24:13 +1100
Received: from dave by disappointment with local (Exim 4.77)
	(envelope-from <dave@disappointment.disaster>) id 1SDEOT-0003NX-Ll
	for xfs@oss.sgi.com; Thu, 29 Mar 2012 23:23:57 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 3/8] xfs: use kmem_zone_zalloc for buffers
Date: Thu, 29 Mar 2012 23:23:50 +1100
Message-Id: <1333023835-12856-4-git-send-email-david@fromorbit.com>
In-Reply-To: <1333023835-12856-1-git-send-email-david@fromorbit.com>
References: <1333023835-12856-1-git-send-email-david@fromorbit.com>
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
---
 fs/xfs/xfs_buf.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 9063461..d1ba21d 100644
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
1.7.9

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
