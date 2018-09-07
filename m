Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:25245 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726107AbeIGGaU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 7 Sep 2018 02:30:20 -0400
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH] xfs: avoid lockdep false positives in xfs_trans_alloc
Date: Fri,  7 Sep 2018 11:51:55 +1000
Message-Id: <20180907015155.32559-1-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: jeffm@suse.com

From: Dave Chinner <dchinner@redhat.com>

We've had a few reports of lockdep tripping over memory reclaim
context vs filesystem freeze "deadlocks". They all have looked
to be false positives on analysis, but it seems that they are
being tripped because we take freeze references before we run
a GFP_KERNEL allocation for the struct xfs_trans.

We can avoid this false positive vector just by re-ordering the
operations in xfs_trans_alloc(). That is. we need allocate the
structure before we take the freeze reference and enter the GFP_NOFS
allocation context that follows the xfs_trans around. This prevents
lockdep from seeing the GFP_KERNEL allocation inside the transaction
context, and that prevents it from triggering the freeze level vs
alloc context vs reclaim warnings.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_trans.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index bedc5a5133a5..912b42f5fe4a 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -259,6 +259,14 @@ xfs_trans_alloc(
 	struct xfs_trans	*tp;
 	int			error;
 
+	/*
+	 * Allocate the handle before we do our freeze accounting and setting up
+	 * GFP_NOFS allocation context so that we avoid lockdep false positives
+	 * by doing GFP_KERNEL allocations inside sb_start_intwrite().
+	 */
+	tp = kmem_zone_zalloc(xfs_trans_zone,
+		(flags & XFS_TRANS_NOFS) ? KM_NOFS : KM_SLEEP);
+
 	if (!(flags & XFS_TRANS_NO_WRITECOUNT))
 		sb_start_intwrite(mp->m_super);
 
@@ -270,8 +278,6 @@ xfs_trans_alloc(
 		mp->m_super->s_writers.frozen == SB_FREEZE_COMPLETE);
 	atomic_inc(&mp->m_active_trans);
 
-	tp = kmem_zone_zalloc(xfs_trans_zone,
-		(flags & XFS_TRANS_NOFS) ? KM_NOFS : KM_SLEEP);
 	tp->t_magic = XFS_TRANS_HEADER_MAGIC;
 	tp->t_flags = flags;
 	tp->t_mountp = mp;
-- 
2.17.0
