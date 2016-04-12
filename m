Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 09DB27CB5
	for <xfs@oss.sgi.com>; Tue, 12 Apr 2016 02:54:53 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C195C304053
	for <xfs@oss.sgi.com>; Tue, 12 Apr 2016 00:54:49 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	REnS2uHCcLEegxrR for <xfs@oss.sgi.com>;
	Tue, 12 Apr 2016 00:54:45 -0700 (PDT)
Date: Tue, 12 Apr 2016 17:54:23 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: list_add corruption after "xfs: mode di_mode to vfs inode"
Message-ID: <20160412075423.GG9088@dastard>
References: <56FC9FA6.1080700@stratus.com>
	<20160401024413.GB2072@devil.localdomain>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160401024413.GB2072@devil.localdomain>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <dchinner@redhat.com>
Cc: Joe Lawrence <joe.lawrence@stratus.com>, xfs@oss.sgi.com

On Fri, Apr 01, 2016 at 01:44:13PM +1100, Dave Chinner wrote:
> On Wed, Mar 30, 2016 at 11:55:18PM -0400, Joe Lawrence wrote:
> > Hi Dave,
> > 
> > Upon loading 4.6-rc1, I noticed a few linked list corruption messages in
> > dmesg shortly after boot up.  I bisected the kernel, landing on:
> > 
> >   [c19b3b05ae440de50fffe2ac2a9b27392a7448e9] xfs: mode di_mode to vfs inode
> > 
> > If I revert c19b3b05ae44 from 4.6-rc1, the warnings stop.
> > 
> > WARNING: CPU: 35 PID: 6715 at lib/list_debug.c:29 __list_add+0x65/0xc0
> > list_add corruption. next->prev should be prev (ffff882030928a00), but was ffff88103f00c300. (next=ffff88100fde5ce8).
> .....
> >  [<ffffffff812488f0>] ? bdev_test+0x20/0x20
> >  [<ffffffff813551a5>] __list_add+0x65/0xc0
> >  [<ffffffff81249bd8>] bd_acquire+0xc8/0xd0
> >  [<ffffffff8124aa59>] blkdev_open+0x39/0x70
> >  [<ffffffff8120bc27>] do_dentry_open+0x227/0x320
> >  [<ffffffff8124aa20>] ? blkdev_get_by_dev+0x50/0x50
> >  [<ffffffff8120d057>] vfs_open+0x57/0x60
> >  [<ffffffff8121c9fa>] path_openat+0x1ba/0x1340
> >  [<ffffffff8121eff1>] do_filp_open+0x91/0x100
> >  [<ffffffff8122c806>] ? __alloc_fd+0x46/0x180
> >  [<ffffffff8120d3b4>] do_sys_open+0x124/0x210
> >  [<ffffffff8120d4be>] SyS_open+0x1e/0x20
> >  [<ffffffff81003c12>] do_syscall_64+0x62/0x110
> >  [<ffffffff8169ade1>] entry_SYSCALL64_slow_path+0x25/0x25
> ....
> > According to the bd_acquire+0xc8 offset, we're in bd_acquire()
> > attempting the list add:
> ....
> >  713         bdev = bdget(inode->i_rdev);
> >  714         if (bdev) {
> >  715                 spin_lock(&bdev_lock);
> >  716                 if (!inode->i_bdev) {
> >  717                         /*
> >  718                          * We take an additional reference to bd_inode,
> >  719                          * and it's released in clear_inode() of inode.
> >  720                          * So, we can access it via ->i_mapping always
> >  721                          * without igrab().
> >  722                          */
> >  723                         bdgrab(bdev);
> >  724                         inode->i_bdev = bdev;
> >  725                         inode->i_mapping = bdev->bd_inode->i_mapping;
> >  726                         list_add(&inode->i_devices, &bdev->bd_inodes);
> 
> So the bdev->bd_inodes list is corrupt, and this call trace is
> just the messenger.
....
> > I'm not really sure why the bisect landed on c19b3b05ae44 "xfs: mode
> > di_mode to vfs inode", but as I mentioned, reverting it made the list
> > warnings go away.
> 
> Neither am I at this point as it's the bdev inode (not an xfs
> inode) that has a corrupted list. I'll have to try to reproduce this.

Patch below should fix the problem. Smoke tested only at this point.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

xfs: we don't need no steekin ->evict_inode

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
index b412bb1..d8424f5 100644
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

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
