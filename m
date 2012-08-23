Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7N559mS136061 for <xfs@oss.sgi.com>; Thu, 23 Aug 2012 00:05:09 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	Yam9qa7JJlZvhNTS for <xfs@oss.sgi.com>;
	Wed, 22 Aug 2012 22:05:55 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1T4Pbp-0003K2-82
	for xfs@oss.sgi.com; Thu, 23 Aug 2012 15:05:33 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1T4Pbp-0003im-4N
	for xfs@oss.sgi.com; Thu, 23 Aug 2012 15:05:33 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 089/102] xfs: fix memory reclaim deadlock on agi buffer
Date: Thu, 23 Aug 2012 15:02:47 +1000
Message-Id: <1345698180-13612-90-git-send-email-david@fromorbit.com>
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

From: Peter Watkins <treestem@gmail.com>

Upstream commit: 3ba316037470bbf98c8a16c2179c02794fb8862e

Note xfs_iget can be called while holding a locked agi buffer. If
it goes into memory reclaim then inode teardown may try to lock the
same buffer. Prevent the deadlock by calling radix_tree_preload
with GFP_NOFS.

Signed-off-by: Peter Watkins <treestem@gmail.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Ben Myers <bpm@sgi.com>
---
 fs/xfs/xfs_iget.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_iget.c b/fs/xfs/xfs_iget.c
index 35b1f7b..a3663a8 100644
--- a/fs/xfs/xfs_iget.c
+++ b/fs/xfs/xfs_iget.c
@@ -337,9 +337,10 @@ xfs_iget_cache_miss(
 	/*
 	 * Preload the radix tree so we can insert safely under the
 	 * write spinlock. Note that we cannot sleep inside the preload
-	 * region.
+	 * region. Since we can be called from transaction context, don't
+	 * recurse into the file system.
 	 */
-	if (radix_tree_preload(GFP_KERNEL)) {
+	if (radix_tree_preload(GFP_NOFS)) {
 		error = EAGAIN;
 		goto out_destroy;
 	}
-- 
1.7.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
