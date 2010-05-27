Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4R1u27x103844 for <xfs@oss.sgi.com>; Wed, 26 May 2010 20:56:03 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 71ABE37A2B5
	for <xfs@oss.sgi.com>; Wed, 26 May 2010 18:58:25 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail14.adl6.internode.on.net
	[150.101.137.99]) by cuda.sgi.com with ESMTP id
	m2thSSzC91D3DwNH for <xfs@oss.sgi.com>;
	Wed, 26 May 2010 18:58:25 -0700 (PDT)
Received: from dastard (unverified [121.45.174.97])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	26002374-1927428
	for <xfs@oss.sgi.com>; Thu, 27 May 2010 11:28:23 +0930 (CST)
Received: from disturbed ([192.168.1.9]) by dastard with esmtp (Exim 4.71)
	(envelope-from <dave@fromorbit.com>) id 1OHSMZ-0001n9-3A
	for xfs@oss.sgi.com; Thu, 27 May 2010 11:58:23 +1000
Received: from dave by disturbed with local (Exim 4.71)
	(envelope-from <dave@disturbed.disaster>) id 1OHSMQ-0008Ar-0E
	for xfs@oss.sgi.com; Thu, 27 May 2010 11:58:14 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH] xfs: fix might_sleep() warning when initialising per-ag tree
Date: Thu, 27 May 2010 11:58:13 +1000
Message-Id: <1274925493-31401-1-git-send-email-david@fromorbit.com>
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

The use of radix_tree_preload() only works if the radix tree was initialised
without the __GFP_WAIT flag. The per-ag tree uses GFP_NOFS, so does not trigger
allocation of new tree nodes from the preloaded array. Hence it enters the
allocator with a spinlock held and triggers the might_sleep() warnings.

Reported-by; Chris Mason <chris.mason@oracle.com>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_mount.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index ace795f..c901283 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -1251,7 +1251,7 @@ xfs_mountfs(
 	 * Allocate and initialize the per-ag data.
 	 */
 	spin_lock_init(&mp->m_perag_lock);
-	INIT_RADIX_TREE(&mp->m_perag_tree, GFP_NOFS);
+	INIT_RADIX_TREE(&mp->m_perag_tree, GFP_ATOMIC);
 	error = xfs_initialize_perag(mp, sbp->sb_agcount, &mp->m_maxagi);
 	if (error) {
 		cmn_err(CE_WARN, "XFS: Failed per-ag init: %d", error);
-- 
1.5.6.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
