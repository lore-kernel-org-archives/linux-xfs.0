Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qB3NehOY067725 for <xfs@oss.sgi.com>; Mon, 3 Dec 2012 17:40:43 -0600
Message-Id: <20121203144311.392460893@sgi.com>
Date: Mon, 03 Dec 2012 17:42:36 -0600
From: Mark Tinguely <tinguely@sgi.com>
Subject: [3.0-stable PATCH 28/36] xfs: fix memory reclaim deadlock on agi
	buffer
References: <20121203144208.143464631@sgi.com>
Content-Disposition: inline; filename=089
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

Index: b/fs/xfs/xfs_iget.c
===================================================================
--- a/fs/xfs/xfs_iget.c
+++ b/fs/xfs/xfs_iget.c
@@ -340,9 +340,10 @@ xfs_iget_cache_miss(
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


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
