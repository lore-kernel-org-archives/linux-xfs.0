Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n2FBQItD006415 for <xfs@oss.sgi.com>; Sun, 15 Mar 2009 06:26:38 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1CB331C436A1
	for <xfs@oss.sgi.com>; Sun, 15 Mar 2009 04:25:54 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail09.adl2.internode.on.net
	[203.16.214.73]) by cuda.sgi.com with ESMTP id ZwihiYwFkRvd1ioV
	for <xfs@oss.sgi.com>; Sun, 15 Mar 2009 04:25:54 -0700 (PDT)
Received: from destruction.internal (unverified [203.206.165.193])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	58260909-1927428
	for <xfs@oss.sgi.com>; Sun, 15 Mar 2009 21:55:53 +1030 (CDT)
Received: from dave by destruction.internal with local (Exim 4.69)
	(envelope-from <dave@destruction>) id 1LioTO-0006hC-J8
	for xfs@oss.sgi.com; Sun, 15 Mar 2009 22:25:42 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 2/2] [XFS] Fix double free of inode
Date: Sun, 15 Mar 2009 22:25:42 +1100
Message-Id: <1237116342-25701-3-git-send-email-david@fromorbit.com>
In-Reply-To: <1237116342-25701-1-git-send-email-david@fromorbit.com>
References: <1237116342-25701-1-git-send-email-david@fromorbit.com>
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

If we fail to initialise the VFS inode in inode_init_always(),
it will call ->delete_inode internally resulting in the inode being
freed. Hence we need to delay the call to inode_init_always()
until after the XFS inode is sufficient set up to handle a
call to ->delete_inode, and then if that fails do not touch
the inode again at all as it has been freed.

Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/xfs_iget.c |   23 ++++++++++++++---------
 1 files changed, 14 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/xfs_iget.c b/fs/xfs/xfs_iget.c
index 478e587..89b81ee 100644
--- a/fs/xfs/xfs_iget.c
+++ b/fs/xfs/xfs_iget.c
@@ -69,15 +69,6 @@ xfs_inode_alloc(
 	ASSERT(!spin_is_locked(&ip->i_flags_lock));
 	ASSERT(completion_done(&ip->i_flush));
 
-	/*
-	 * initialise the VFS inode here to get failures
-	 * out of the way early.
-	 */
-	if (!inode_init_always(mp->m_super, VFS_I(ip))) {
-		kmem_zone_free(xfs_inode_zone, ip);
-		return NULL;
-	}
-
 	/* initialise the xfs inode */
 	ip->i_ino = ino;
 	ip->i_mount = mp;
@@ -113,6 +104,20 @@ xfs_inode_alloc(
 #ifdef XFS_DIR2_TRACE
 	ip->i_dir_trace = ktrace_alloc(XFS_DIR2_KTRACE_SIZE, KM_NOFS);
 #endif
+	/*
+	* Now initialise the VFS inode. We do this after the xfs_inode
+	* initialisation as internal failures will result in ->destroy_inode
+	* being called and that will pass down through the reclaim path and
+	* free the XFS inode. This path requires the XFS inode to already be
+	* initialised. Hence if this call fails, the xfs_inode has already
+	* been freed and we should not reference it at all in the error
+	* handling.
+	*/
+	if (!inode_init_always(mp->m_super, VFS_I(ip)))
+		return NULL;
+
+	/* prevent anyone from using this yet */
+	VFS_I(ip)->i_state = I_NEW|I_LOCK;
 
 	return ip;
 }
-- 
1.6.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
