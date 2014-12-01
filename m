Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 5C08E29DF9
	for <xfs@oss.sgi.com>; Mon,  1 Dec 2014 16:34:58 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 49E8D304081
	for <xfs@oss.sgi.com>; Mon,  1 Dec 2014 14:34:55 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	mNQar373m5biM3Wf for <xfs@oss.sgi.com>;
	Mon, 01 Dec 2014 14:34:53 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1XvZY6-0003nP-7F
	for xfs@oss.sgi.com; Tue, 02 Dec 2014 09:34:30 +1100
Received: from dave by disappointment with local (Exim 4.82_1-5b7a7c0-XX)
	(envelope-from <dave@disappointment.disaster>) id 1XvZY6-0004YL-5y
	for xfs@oss.sgi.com; Tue, 02 Dec 2014 09:34:30 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH] xfs: active inodes stat is broken
Date: Tue,  2 Dec 2014 09:34:30 +1100
Message-Id: <1417473270-17467-1-git-send-email-david@fromorbit.com>
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

vn_active only ever gets decremented, so it has a very large
negative number.  Make it track the inode count we currently have
allocated properly so we can easily track the size of the inode
cache via tools like PCP.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_icache.c | 3 +++
 fs/xfs/xfs_super.c  | 1 -
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 92ca910..8bc3d78 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -128,6 +128,7 @@ xfs_inode_free(
 	/* asserts to verify all state is correct here */
 	ASSERT(atomic_read(&ip->i_pincount) == 0);
 	ASSERT(!xfs_isiflocked(ip));
+	XFS_STATS_DEC(vn_active);
 
 	call_rcu(&VFS_I(ip)->i_rcu, xfs_inode_free_callback);
 }
@@ -287,6 +288,8 @@ xfs_iget_cache_miss(
 	if (!ip)
 		return -ENOMEM;
 
+	XFS_STATS_INC(vn_active);
+
 	error = xfs_iread(mp, tp, ip, flags);
 	if (error)
 		goto out_destroy;
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index fee11c8..6b95851 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1005,7 +1005,6 @@ xfs_fs_evict_inode(
 	clear_inode(inode);
 	XFS_STATS_INC(vn_rele);
 	XFS_STATS_INC(vn_remove);
-	XFS_STATS_DEC(vn_active);
 
 	xfs_inactive(ip);
 }
-- 
2.0.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
