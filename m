Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q47KCMZu150450 for <xfs@oss.sgi.com>; Mon, 7 May 2012 15:12:22 -0500
Received: from mail-qc0-f181.google.com (mail-qc0-f181.google.com
	[209.85.216.181]) by cuda.sgi.com with ESMTP id
	vGQoa65N4RUShbOe (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 07 May 2012 13:12:21 -0700 (PDT)
Received: by qcsk26 with SMTP id k26so4436945qcs.26
	for <xfs@oss.sgi.com>; Mon, 07 May 2012 13:12:20 -0700 (PDT)
From: Peter Watkins <treestem@gmail.com>
Subject: [PATCH] xfs: fix memory reclaim deadlock on agi buffer
Date: Mon,  7 May 2012 16:11:37 -0400
Message-Id: <1336421497-1554-1-git-send-email-treestem@gmail.com>
In-Reply-To: <CAH4wwdHb0=9UtTiwz-fAYovXGO6J8soda31S+dgCGNKBA3j5sw@mail.gmail.com>
References: <CAH4wwdHb0=9UtTiwz-fAYovXGO6J8soda31S+dgCGNKBA3j5sw@mail.gmail.com>
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
To: david@fromorbit.com
Cc: Peter Watkins <treestem@gmail.com>, xfs@oss.sgi.com

Note xfs_iget can be called while holding a locked agi buffer. If
it goes into memory reclaim then inode teardown may try to lock the
same buffer. Prevent the deadlock by calling radix_tree_preload
with GFP_NOFS.

Signed-off-by: Peter Watkins <treestem@gmail.com>
---
 fs/xfs/xfs_iget.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_iget.c b/fs/xfs/xfs_iget.c
index bcc6c24..8c6f806 100644
--- a/fs/xfs/xfs_iget.c
+++ b/fs/xfs/xfs_iget.c
@@ -334,9 +334,10 @@ xfs_iget_cache_miss(
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
1.7.0.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
