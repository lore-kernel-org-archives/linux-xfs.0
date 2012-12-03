Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qB3NehjC067726 for <xfs@oss.sgi.com>; Mon, 3 Dec 2012 17:40:43 -0600
Message-Id: <20121203144309.060574472@sgi.com>
Date: Mon, 03 Dec 2012 17:42:11 -0600
From: Mark Tinguely <tinguely@sgi.com>
Subject: [3.0-stable PATCH 03/36] xfs: mark the xfssyncd workqueue as
	non-reentrant
References: <20121203144208.143464631@sgi.com>
Content-Disposition: inline; filename=027
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


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
