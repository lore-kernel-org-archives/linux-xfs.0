Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7N52wQA134882 for <xfs@oss.sgi.com>; Thu, 23 Aug 2012 00:02:58 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	7cX2PQzCS4u17Qch for <xfs@oss.sgi.com>;
	Wed, 22 Aug 2012 22:03:43 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1T4Pa0-0003Fl-Fc
	for xfs@oss.sgi.com; Thu, 23 Aug 2012 15:03:40 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1T4Pa0-0003dO-DG
	for xfs@oss.sgi.com; Thu, 23 Aug 2012 15:03:40 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 027/102] xfs: mark the xfssyncd workqueue as non-reentrant
Date: Thu, 23 Aug 2012 15:01:45 +1000
Message-Id: <1345698180-13612-28-git-send-email-david@fromorbit.com>
In-Reply-To: <1345698180-13612-1-git-send-email-david@fromorbit.com>
References: <1345698180-13612-1-git-send-email-david@fromorbit.com>
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

From: Christoph Hellwig <hch@infradead.org>

Upstream commit: 40d344ec5ee440596b1f3ae87556e20c7197757a

On a system with lots of memory pressure that is stuck on synchronous inode
reclaim the workqueue code will run one instance of the inode reclaim work
item on every CPU. which is not what we want.  Make sure to mark the
xfssyncd workqueue as non-reentrant to make sure there only is one instace
of each running globally.  Also stop using special paramater for the
workqueue; now that we guarantee each fs has only running one of each works
at a time there is no need to artificially lower max_active and compensate
for that by setting the WQ_CPU_INTENSIVE flag.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Ben Myers <bpm@sgi.com>
---
 fs/xfs/linux-2.6/xfs_super.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_super.c b/fs/xfs/linux-2.6/xfs_super.c
index e6ac98c..04dd4d4 100644
--- a/fs/xfs/linux-2.6/xfs_super.c
+++ b/fs/xfs/linux-2.6/xfs_super.c
@@ -1617,12 +1617,12 @@ STATIC int __init
 xfs_init_workqueues(void)
 {
 	/*
-	 * max_active is set to 8 to give enough concurency to allow
-	 * multiple work operations on each CPU to run. This allows multiple
-	 * filesystems to be running sync work concurrently, and scales with
-	 * the number of CPUs in the system.
+	 * We never want to the same work item to run twice, reclaiming inodes
+	 * or idling the log is not going to get any faster by multiple CPUs
+	 * competing for ressources.  Use the default large max_active value
+	 * so that even lots of filesystems can perform these task in parallel.
 	 */
-	xfs_syncd_wq = alloc_workqueue("xfssyncd", WQ_CPU_INTENSIVE, 8);
+	xfs_syncd_wq = alloc_workqueue("xfssyncd", WQ_NON_REENTRANT, 0);
 	if (!xfs_syncd_wq)
 		return -ENOMEM;
 	return 0;
-- 
1.7.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
