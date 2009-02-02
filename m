Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n12I8hJX001232 for <xfs@oss.sgi.com>; Mon, 2 Feb 2009 12:08:43 -0600
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CD2A2DA33D
	for <xfs@oss.sgi.com>; Mon,  2 Feb 2009 10:08:03 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [66.187.233.31]) by cuda.sgi.com
	with ESMTP id mDBn1oAwICUQUxUb for <xfs@oss.sgi.com>;
	Mon, 02 Feb 2009 10:08:03 -0800 (PST)
Date: Mon, 2 Feb 2009 12:36:40 -0500 (EST)
From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: spurious -ENOSPC on XFS
In-Reply-To: <20090131235725.GA24173@disturbed>
Message-ID: <Pine.LNX.4.64.0902021214310.15622@hs20-bc2-1.build.redhat.com>
References: <20090113214949.GN8071@disturbed>
	<Pine.LNX.4.64.0901132324070.16396@hs20-bc2-1.build.redhat.com>
	<20090118173144.GA1999@infradead.org>
	<Pine.LNX.4.64.0901201430250.4603@hs20-bc2-1.build.redhat.com>
	<20090120232422.GF10158@disturbed>
	<20090122205913.GA30859@infradead.org>
	<20090122224347.GA18751@infradead.org>
	<Pine.LNX.4.64.0901231509010.5179@hs20-bc2-1.build.redhat.com>
	<20090124071249.GF32390@disturbed>
	<Pine.LNX.4.64.0901291136050.19368@hs20-bc2-1.build.redhat.com>
	<20090131235725.GA24173@disturbed>
MIME-Version: 1.0
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com



On Sun, 1 Feb 2009, Dave Chinner wrote:

> On Thu, Jan 29, 2009 at 11:39:00AM -0500, Mikulas Patocka wrote:
> > On Sat, 24 Jan 2009, Dave Chinner wrote:
> > > On Fri, Jan 23, 2009 at 03:14:30PM -0500, Mikulas Patocka wrote:
> > > > If I placed
> > > > xfs_sync_inodes(ip->i_mount, SYNC_DELWRI);
> > > > xfs_sync_inodes(ip->i_mount, SYNC_DELWRI | SYNC_IOWAIT);
> > > > directly to xfs_flush_device, I got lock dependency warning (though not a 
> > > > real deadlock).
> > > 
> > > Same reason memory reclaim gives lockdep warnings on XFS - we're
> > > recursing into operations that take inode locks while we currently
> > > hold an inode lock.  However, it shouldn't deadlock because
> > > we should ever try to take the iolock on the inode that we current
> > > hold it on.
> > > 
> > > > So synchronous flushing definitely needs some thinking and lock 
> > > > rearchitecting.
> > > 
> > > No, not at all. At most the grabbing of the iolock in
> > > xfs_sync_inodes_ag() needs to become a trylock....
> > 
> > You are wrong, the comments in the code are right. It really
> > deadlocks if it is modified to use synchronous wait for the end of
> > the flush and if the flush is done with xfs_sync_inodes:
> > 
> > xfssyncd      D 0000000000606808     0  4819      2
> > Call Trace:
> >  [0000000000606788] rwsem_down_failed_common+0x1ac/0x1d8
> >  [0000000000606808] rwsem_down_read_failed+0x24/0x34
> >  [0000000000606848] __down_read+0x30/0x40
> >  [0000000000468a64] down_read_nested+0x48/0x58
> >  [00000000100e6cc8] xfs_ilock+0x48/0x8c [xfs]
> >  [000000001011018c] xfs_sync_inodes_ag+0x17c/0x2dc [xfs]
> >  [000000001011034c] xfs_sync_inodes+0x60/0xc4 [xfs]
> >  [00000000101103c4] xfs_flush_device_work+0x14/0x2c [xfs]
> >  [000000001010ff1c] xfssyncd+0x110/0x174 [xfs]
> >  [000000000046556c] kthread+0x54/0x88
> >  [000000000042b2a0] kernel_thread+0x3c/0x54
> >  [00000000004653b8] kthreadd+0xac/0x160
> 
> So it is stuck:
> 
> 127                 /*
> 128                  * If we have to flush data or wait for I/O completion
> 129                  * we need to hold the iolock.
> 130                  */
> 131                 if ((flags & SYNC_DELWRI) && VN_DIRTY(inode)) {
> 132     >>>>>>>>            xfs_ilock(ip, XFS_IOLOCK_SHARED);
> 133                         lock_flags |= XFS_IOLOCK_SHARED;
> 134                         error = xfs_flush_pages(ip, 0, -1, fflag, FI_NONE);
> 135                         if (flags & SYNC_IOWAIT)
> 136                                 xfs_ioend_wait(ip);
> 137                 }
> 
> Given that we are stuck on the iolock in xfs_sync_inodes_ag(), I
> suspect you should re-read my comments above about "lock
> re-architecting" ;).

No, if you turn it into a trylock, it will randomly fail if any other 
process is holding the lock for whatever reason. So you will still get 
spurious -ENOSPCs, although with lower probability.

> If you make the xfs_ilock() there xfs_ilock_nowait() and avoid data
> writeback if we don't get the lock the deadlock goes away, right?

But that premature ENOSPC possibility will still exist.

The only right solution that I see is to drop this flushing code at all 
(because it's unfixable), catch -ENOSPCs exactly before you are about to 
return them to Linux VFS, flush at this point (you are not holding any 
locks here) and retry.

There seems to be more bugs with forgetting to flush delayed allocation 
--- you should flush delayed allocation after *every* failed allocate 
attempt, but the code flushes it only after failed delayed allocate 
attempt --- i.e. nondelayed allocators, such as xfs_iomap_write_direct 
(and maybe other places) will still return -ENOSPC without attempting to 
flush other inodes with delayed allocation.

Syncing should be really moved at the topmost place.

Mikulas

> BTW, can you post the patch you are working on?
> 
> Cheers,
> 
> Dave.

This is what I tried: I turned that 500ms wait into a completion:


Use xfs_sync_inodes and not sync_blockdev. sync_blockdev writes dirty 
metadata buffers, it doesn't touch inodes and pages at all.

Also, change that 500ms delay to a wait for completion, so that the
behavior is not dependent on magic timeout values. XFS developers insist
that it can't deadlock (I hope they're right).

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 fs/xfs/linux-2.6/xfs_sync.c |   25 +++++++++++++++++++------
 fs/xfs/linux-2.6/xfs_sync.h |    1 +
 2 files changed, 20 insertions(+), 6 deletions(-)

Index: linux-2.6.29-rc3-devel/fs/xfs/linux-2.6/xfs_sync.c
===================================================================
--- linux-2.6.29-rc3-devel.orig/fs/xfs/linux-2.6/xfs_sync.c	2009-01-29 15:49:25.000000000 +0100
+++ linux-2.6.29-rc3-devel/fs/xfs/linux-2.6/xfs_sync.c	2009-01-29 16:57:53.000000000 +0100
@@ -389,12 +389,15 @@ xfs_quiesce_attr(
  * - It saves on stack space, which is tight in certain situations
  * - It can be used (with care) as a mechanism to avoid deadlocks.
  * Flushing while allocating in a full filesystem requires both.
+ *
+ * Dave Chinner claims that the deadlock can't happen. -- mikulas
  */
 STATIC void
 xfs_syncd_queue_work(
 	struct xfs_mount *mp,
 	void		*data,
-	void		(*syncer)(struct xfs_mount *, void *))
+	void		(*syncer)(struct xfs_mount *, void *),
+	struct completion *completion)
 {
 	struct bhv_vfs_sync_work *work;
 
@@ -403,6 +406,7 @@ xfs_syncd_queue_work(
 	work->w_syncer = syncer;
 	work->w_data = data;
 	work->w_mount = mp;
+	work->w_completion = completion;
 	spin_lock(&mp->m_sync_lock);
 	list_add_tail(&work->w_list, &mp->m_sync_list);
 	spin_unlock(&mp->m_sync_lock);
@@ -415,6 +419,7 @@ xfs_syncd_queue_work(
  * has failed with ENOSPC and we are in the process of scratching our
  * heads, looking about for more room...
  */
+#if 0
 STATIC void
 xfs_flush_inode_work(
 	struct xfs_mount *mp,
@@ -424,16 +429,20 @@ xfs_flush_inode_work(
 	filemap_flush(inode->i_mapping);
 	iput(inode);
 }
+#endif
 
 void
 xfs_flush_inode(
 	xfs_inode_t	*ip)
 {
+#if 0
 	struct inode	*inode = VFS_I(ip);
+	DECLARE_COMPLETION_ONSTACK(completion);
 
 	igrab(inode);
-	xfs_syncd_queue_work(ip->i_mount, inode, xfs_flush_inode_work);
-	delay(msecs_to_jiffies(500));
+	xfs_syncd_queue_work(ip->i_mount, inode, xfs_flush_inode_work, &completion);
+	wait_for_completion(&completion);
+#endif
 }
 
 /*
@@ -446,7 +455,7 @@ xfs_flush_device_work(
 	void		*arg)
 {
 	struct inode	*inode = arg;
-	sync_blockdev(mp->m_super->s_bdev);
+	xfs_sync_inodes(mp, SYNC_DELWRI | SYNC_IOWAIT);
 	iput(inode);
 }
 
@@ -455,10 +464,11 @@ xfs_flush_device(
 	xfs_inode_t	*ip)
 {
 	struct inode	*inode = VFS_I(ip);
+	DECLARE_COMPLETION_ONSTACK(completion);
 
 	igrab(inode);
-	xfs_syncd_queue_work(ip->i_mount, inode, xfs_flush_device_work);
-	delay(msecs_to_jiffies(500));
+	xfs_syncd_queue_work(ip->i_mount, inode, xfs_flush_device_work, &completion);
+	wait_for_completion(&completion);
 	xfs_log_force(ip->i_mount, (xfs_lsn_t)0, XFS_LOG_FORCE|XFS_LOG_SYNC);
 }
 
@@ -526,6 +536,8 @@ xfssyncd(
 		list_for_each_entry_safe(work, n, &tmp, w_list) {
 			(*work->w_syncer)(mp, work->w_data);
 			list_del(&work->w_list);
+			if (work->w_completion)
+				complete(work->w_completion);
 			if (work == &mp->m_sync_work)
 				continue;
 			kmem_free(work);
@@ -541,6 +553,7 @@ xfs_syncd_init(
 {
 	mp->m_sync_work.w_syncer = xfs_sync_worker;
 	mp->m_sync_work.w_mount = mp;
+	mp->m_sync_work.w_completion = NULL;
 	mp->m_sync_task = kthread_run(xfssyncd, mp, "xfssyncd");
 	if (IS_ERR(mp->m_sync_task))
 		return -PTR_ERR(mp->m_sync_task);
Index: linux-2.6.29-rc3-devel/fs/xfs/linux-2.6/xfs_sync.h
===================================================================
--- linux-2.6.29-rc3-devel.orig/fs/xfs/linux-2.6/xfs_sync.h	2009-01-29 15:52:28.000000000 +0100
+++ linux-2.6.29-rc3-devel/fs/xfs/linux-2.6/xfs_sync.h	2009-01-29 15:52:56.000000000 +0100
@@ -25,6 +25,7 @@ typedef struct bhv_vfs_sync_work {
 	struct xfs_mount	*w_mount;
 	void			*w_data;	/* syncer routine argument */
 	void			(*w_syncer)(struct xfs_mount *, void *);
+	struct completion	*w_completion;
 } bhv_vfs_sync_work_t;
 
 #define SYNC_ATTR		0x0001	/* sync attributes */

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
