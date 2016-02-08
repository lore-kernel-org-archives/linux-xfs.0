Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 3BFF029E09
	for <xfs@oss.sgi.com>; Sun,  7 Feb 2016 22:24:37 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 2CF658F8033
	for <xfs@oss.sgi.com>; Sun,  7 Feb 2016 20:24:34 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	ODKrOxqNNxovE4jh for <xfs@oss.sgi.com>;
	Sun, 07 Feb 2016 20:24:32 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1aSdN9-00072M-Ot
	for xfs@oss.sgi.com; Mon, 08 Feb 2016 15:24:23 +1100
Received: from dave by disappointment with local (Exim 4.86)
	(envelope-from <dave@disappointment.disaster>) id 1aSdN9-0000m7-O2
	for xfs@oss.sgi.com; Mon, 08 Feb 2016 15:24:23 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 5/9] xfs: reinitialise recycled VFS inode correctly
Date: Mon,  8 Feb 2016 15:24:17 +1100
Message-Id: <1454905461-2773-6-git-send-email-david@fromorbit.com>
In-Reply-To: <1454905461-2773-1-git-send-email-david@fromorbit.com>
References: <1454905461-2773-1-git-send-email-david@fromorbit.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

Now that we keep certain on-disk information in the VFS inode rather
than in a separate XFS specific stucture, we have to be careful of
the VFS code clearing that information when we re-initialise
reclaimable cached inodes during lookup. If we don't do this, then
we lose critical information from the inode and that results in
corruption being detected.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_icache.c | 22 +++++++++++++++++++++-
 1 file changed, 21 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 7c26f86..9ca28655 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -135,6 +135,26 @@ xfs_inode_free(
 }
 
 /*
+ * When we recycle a reclaimable inode, we need to re-initialise the VFS inode
+ * part of the structure. This is made more complex by the fact we store
+ * information about the on-disk values in the VFS inode and so we can't just
+ * overwrite it's values unconditionally. Hence we save the parameters we
+ * need to retain across reinitialisation, and rewrite them into the VFS inode
+ * after resetting it's state even if resetting fails.
+ */
+static int
+xfs_reinit_inode(
+	struct xfs_mount	*mp,
+	struct inode		*inode)
+{
+	int		error;
+
+	error = inode_init_always(mp->m_super, inode);
+
+	return error;
+}
+
+/*
  * Check the validity of the inode we just found it the cache
  */
 static int
@@ -208,7 +228,7 @@ xfs_iget_cache_hit(
 		spin_unlock(&ip->i_flags_lock);
 		rcu_read_unlock();
 
-		error = inode_init_always(mp->m_super, inode);
+		error = xfs_reinit_inode(mp, inode);
 		if (error) {
 			/*
 			 * Re-initializing the inode failed, and we are in deep
-- 
2.5.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
