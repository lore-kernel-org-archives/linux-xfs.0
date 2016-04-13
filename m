Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 597047CB0
	for <xfs@oss.sgi.com>; Wed, 13 Apr 2016 00:32:25 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 05DDD8F8033
	for <xfs@oss.sgi.com>; Tue, 12 Apr 2016 22:32:18 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	6fE5cfEBExS2Q868 for <xfs@oss.sgi.com>;
	Tue, 12 Apr 2016 22:32:16 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1aqDPP-0003p1-QU
	for xfs@oss.sgi.com; Wed, 13 Apr 2016 15:32:11 +1000
Received: from dave by disappointment with local (Exim 4.86)
	(envelope-from <dave@disappointment.disaster>) id 1aqDOq-0000bd-Aq
	for xfs@oss.sgi.com; Wed, 13 Apr 2016 15:31:36 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 01/11] xfs: we don't need no steekin ->evict_inode
Date: Wed, 13 Apr 2016 15:31:22 +1000
Message-Id: <1460525492-1170-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1460525492-1170-1-git-send-email-david@fromorbit.com>
References: <1460525492-1170-1-git-send-email-david@fromorbit.com>
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

Joe Lawrence reported a list_add corruption with 4.6-rc1 when
testing some custom md administration code that made it's own
block device nodes for the md array. The simple test loop of:

for i in {0..100}; do
	mknod --mode=0600 $tmp/tmp_node b $MAJOR $MINOR
	mdadm --detail --export $tmp/tmp_node > /dev/null
	rm -f $tmp/tmp_node
done


Would produce this warning in bd_acquire() when mdadm opened the
device node:

list_add double add: new=ffff88043831c7b8, prev=ffff8804380287d8, next=ffff88043831c7b8.

And then produce this from bd_forget from kdevtmpfs evicting a block
dev inode:

list_del corruption. prev->next should be ffff8800bb83eb10, but was ffff88043831c7b8

This is a regression caused by commit c19b3b05 ("xfs: mode di_mode
to vfs inode"). The issue is that xfs_inactive() frees the
unlinked inode, and the above commit meant that this freeing zeroed
the mode in the struct inode. The problem is that after evict() has
called ->evict_inode, it expects the i_mode to be intact so that it
can call bd_forget() or cd_forget() to drop the reference to the
block device inode attached to the XFS inode.

In reality, the only thing we do in xfs_fs_evict_inode() that is not
generic is call xfs_inactive(). We can move the xfs_inactive() call
to xfs_fs_destroy_inode() without any problems at all, and this
will leave the VFS inode intact until it is completely done with it.

So, remove xfs_fs_evict_inode(), and do the work it used to do in
->destroy_inode instead.

Reported-by: Joe Lawrence <joe.lawrence@stratus.com>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_super.c | 28 +++++++---------------------
 1 file changed, 7 insertions(+), 21 deletions(-)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index e2f0f52..416421d 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -928,7 +928,7 @@ xfs_fs_alloc_inode(
 
 /*
  * Now that the generic code is guaranteed not to be accessing
- * the linux inode, we can reclaim the inode.
+ * the linux inode, we can inactivate and reclaim the inode.
  */
 STATIC void
 xfs_fs_destroy_inode(
@@ -938,9 +938,14 @@ xfs_fs_destroy_inode(
 
 	trace_xfs_destroy_inode(ip);
 
-	XFS_STATS_INC(ip->i_mount, vn_reclaim);
+	ASSERT(!rwsem_is_locked(&ip->i_iolock.mr_lock));
+	XFS_STATS_INC(ip->i_mount, vn_rele);
+	XFS_STATS_INC(ip->i_mount, vn_remove);
+
+	xfs_inactive(ip);
 
 	ASSERT(XFS_FORCED_SHUTDOWN(ip->i_mount) || ip->i_delayed_blks == 0);
+	XFS_STATS_INC(ip->i_mount, vn_reclaim);
 
 	/*
 	 * We should never get here with one of the reclaim flags already set.
@@ -987,24 +992,6 @@ xfs_fs_inode_init_once(
 		     "xfsino", ip->i_ino);
 }
 
-STATIC void
-xfs_fs_evict_inode(
-	struct inode		*inode)
-{
-	xfs_inode_t		*ip = XFS_I(inode);
-
-	ASSERT(!rwsem_is_locked(&ip->i_iolock.mr_lock));
-
-	trace_xfs_evict_inode(ip);
-
-	truncate_inode_pages_final(&inode->i_data);
-	clear_inode(inode);
-	XFS_STATS_INC(ip->i_mount, vn_rele);
-	XFS_STATS_INC(ip->i_mount, vn_remove);
-
-	xfs_inactive(ip);
-}
-
 /*
  * We do an unlocked check for XFS_IDONTCACHE here because we are already
  * serialised against cache hits here via the inode->i_lock and igrab() in
@@ -1673,7 +1660,6 @@ xfs_fs_free_cached_objects(
 static const struct super_operations xfs_super_operations = {
 	.alloc_inode		= xfs_fs_alloc_inode,
 	.destroy_inode		= xfs_fs_destroy_inode,
-	.evict_inode		= xfs_fs_evict_inode,
 	.drop_inode		= xfs_fs_drop_inode,
 	.put_super		= xfs_fs_put_super,
 	.sync_fs		= xfs_fs_sync_fs,
-- 
2.7.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
