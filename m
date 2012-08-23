Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7N53BD6134964 for <xfs@oss.sgi.com>; Thu, 23 Aug 2012 00:03:11 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	2VFWYxsxa9Ebqtgy for <xfs@oss.sgi.com>;
	Wed, 22 Aug 2012 22:03:56 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1T4Pa0-0003FE-7n
	for xfs@oss.sgi.com; Thu, 23 Aug 2012 15:03:40 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1T4PZq-0003cm-48
	for xfs@oss.sgi.com; Thu, 23 Aug 2012 15:03:30 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 020/102] xfs: warn if direct reclaim tries to writeback pages
Date: Thu, 23 Aug 2012 15:01:38 +1000
Message-Id: <1345698180-13612-21-git-send-email-david@fromorbit.com>
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

From: Mel Gorman <mgorman@suse.de>

Upstream commit: 94054fa3fca1fd78db02cb3d68d5627120f0a1d4

Direct reclaim should never writeback pages.  For now, handle the
situation and warn about it.  Ultimately, this will be a BUG_ON.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Johannes Weiner <jweiner@redhat.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Alex Elder <aelder@sgi.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Cc: Chris Mason <chris.mason@oracle.com>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
---
 fs/xfs/linux-2.6/xfs_aops.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_aops.c b/fs/xfs/linux-2.6/xfs_aops.c
index f16207b..4ff2404 100644
--- a/fs/xfs/linux-2.6/xfs_aops.c
+++ b/fs/xfs/linux-2.6/xfs_aops.c
@@ -943,11 +943,11 @@ xfs_vm_writepage(
 	 * random callers for direct reclaim or memcg reclaim.  We explicitly
 	 * allow reclaim from kswapd as the stack usage there is relatively low.
 	 *
-	 * This should really be done by the core VM, but until that happens
-	 * filesystems like XFS, btrfs and ext4 have to take care of this
-	 * by themselves.
+	 * This should never happen except in the case of a VM regression so
+	 * warn about it.
 	 */
-	if ((current->flags & (PF_MEMALLOC|PF_KSWAPD)) == PF_MEMALLOC)
+	if (WARN_ON_ONCE((current->flags & (PF_MEMALLOC|PF_KSWAPD)) ==
+			PF_MEMALLOC))
 		goto redirty;
 
 	/*
-- 
1.7.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
