Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p462owtm173104 for <xfs@oss.sgi.com>; Thu, 5 May 2011 21:50:58 -0500
Received: from ipmail07.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3929E1E1F002
	for <xfs@oss.sgi.com>; Thu,  5 May 2011 19:54:31 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	lVOBCqhQ4AhvBqQ9 for <xfs@oss.sgi.com>;
	Thu, 05 May 2011 19:54:31 -0700 (PDT)
Received: from chute ([192.168.1.1] helo=disappointment)
	by dastard with esmtp (Exim 4.72)
	(envelope-from <dave@fromorbit.com>) id 1QIBBV-00017x-NL
	for xfs@oss.sgi.com; Fri, 06 May 2011 12:54:29 +1000
Received: from dave by disappointment with local (Exim 4.75)
	(envelope-from <dave@disappointment.disaster>) id 1QIBBO-0007PM-Hg
	for xfs@oss.sgi.com; Fri, 06 May 2011 12:54:22 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 1/5] xfs: ensure reclaim cursor is reset correctly at end of AG
Date: Fri,  6 May 2011 12:54:04 +1000
Message-Id: <1304650448-28438-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1304650448-28438-1-git-send-email-david@fromorbit.com>
References: <1304650448-28438-1-git-send-email-david@fromorbit.com>
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

On a 32 bit highmem PowerPC machine, the XFS inode cache was growing
without bound and exhausting low memory causing the OOM killer to be
triggered. After some effort, the problem was reproduced on a 32 bit
x86 highmem machine.

The problem is that the per-ag inode reclaim index cursor was not
getting reset to the start of the AG if the radix tree tag lookup
found no more reclaimable inodes. Hence every further reclaim
attempt started at the same index beyond where any reclaimable
inodes lay, and no further background reclaim ever occurred from the
AG.

Without background inode reclaim the VM driven cache shrinker
simply cannot keep up with cache growth, and OOM is the result.

While the change that exposed the problem was the conversion of the
inode reclaim to use work queues for background reclaim, it was not
the cause of the bug. The bug was introduced when the cursor code
was added, just waiting for some weird configuration to strike....

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Tested-By: Christian Kujau <lists@nerdbynature.de>
---
 fs/xfs/linux-2.6/xfs_sync.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_sync.c b/fs/xfs/linux-2.6/xfs_sync.c
index e0da841..cb1bb20 100644
--- a/fs/xfs/linux-2.6/xfs_sync.c
+++ b/fs/xfs/linux-2.6/xfs_sync.c
@@ -936,6 +936,7 @@ restart:
 					XFS_LOOKUP_BATCH,
 					XFS_ICI_RECLAIM_TAG);
 			if (!nr_found) {
+				done = 1;
 				rcu_read_unlock();
 				break;
 			}
-- 
1.7.4.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
