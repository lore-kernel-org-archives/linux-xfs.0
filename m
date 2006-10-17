Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 16 Oct 2006 19:03:25 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k9H23DaG003136
	for <xfs@oss.sgi.com>; Mon, 16 Oct 2006 19:03:16 -0700
Date: Tue, 17 Oct 2006 12:02:18 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: [patch] Fix xfs_iunpin() sets I_DIRTY_SYNC after clear_inode().
Message-ID: <20061017020218.GE8394166@melbourne.sgi.com>
References: <45237CCE.4010007@ah.jp.nec.com> <20061006032617.GC11034@melbourne.sgi.com> <20061011064357.GN19345@melbourne.sgi.com> <452E32FF.8010109@ah.jp.nec.com> <20061013014651.GC19345@melbourne.sgi.com> <452F83BD.8050501@ah.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <452F83BD.8050501@ah.jp.nec.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Takenori Nagano <t-nagano@ah.jp.nec.com>
Cc: xfs@oss.sgi.com

On Fri, Oct 13, 2006 at 09:17:01PM +0900, Takenori Nagano wrote:
> Hi David,
> 
> David Chinner wrote:
> >> Block I/O performance degradation was very serious.
> > 
> > That was unexpected. :/
> > 
> >> Now, I am trying to ease the degradation.
> >> Do you have any idea for resolving the degradation?
> > 
> > Did you see a degradation with your original fix? I suspect
> > not.
> 
> No, I don't see any degradation with my patch.
> But my patch is not perfect.

It still needs the iput() in xfs_iunpin() to do pushed off to an
external thread because we can deadlock in xfslogd:

Stack traceback for pid 123
0xe00000b9edda0000      123       19  0    0   D  0xe00000b9edda02f0  xfslogd/0
0xa0000001008352c0 schedule+0xf00
0xa000000100838650 schedule_timeout+0x110
0xa0000001003d55a0 xlog_state_sync_all+0x380
0xa0000001003d5d90 _xfs_log_force+0x210
0xa0000001004200f0 xfs_fs_clear_inode+0x2b0
0xa0000001001c9a20 clear_inode+0x200
0xa0000001001c9f60 generic_delete_inode+0x300
0xa0000001001ca320 generic_drop_inode+0x300
0xa0000001001c8e80 iput+0x180
0xa0000001003c99b0 xfs_iunpin+0x190
0xa0000001003cdb40 xfs_inode_item_unpin+0x20
0xa0000001003ee4c0 xfs_trans_chunk_committed+0x280
0xa0000001003ee730 xfs_trans_committed+0xd0
0xa0000001003d3e80 xlog_state_do_callback+0x520
0xa0000001003d4420 xlog_iodone+0x160
0xa0000001004274c0 xfs_buf_iodone_work+0x60
0xa0000001000eb640 run_workqueue+0x180
0xa0000001000eda00 worker_thread+0x260
0xa0000001000f6340 kthread+0x260
0xa0000001000121d0 kernel_thread_helper+0xd0
0xa0000001000094c0 start_kernel_thread+0x20

The patch I sent does not deadlock because it removed the igrab/iput
in xfs_iunpin().

In my testing the performance penalty is identical for the patch you
wrote and the one I wrote.  In both cases performance is limited by
the maximum number of log forces that can be issued, This results in
about a 70% degradation in single threaded sequential deletes (from
about 7,500/s to 2,500/s)....

So, unconditional log forces are not the solution here - the code is
neat, but the performance tradeoff is unacceptible. IOWs, to
maintain performance we cannot do an unconditional log force in the
->clear_inode() path.

Hmmm.....

In doing the previous patch that removed the igrab/iput, I used the
log force to provide synchronisation that prevented the unpin from
ever seeing an invalid state and hence we couldn't ever get a
use-after-free situation. What I failed to see was that we already
have this mechanism - the i_flags_lock and the XFS_IRECLAIM* flags.

If we synchronise the setting of either of the XFS_IRECLAIM* flags
with the breakage of the bhv_vnode<->xfs_inode link, then we can
never get the state in xfs_iunpin() where the link has been broken
and the XFS_IRECLAIM* flags are not set. The current usage of
the i_flags_lock in xfs_iunpin is sufficient to provide this
guarantee, but we are breaking the link before setting the
XFS_IRECLAIMABLE flag in xfs_reclaim()....

So, here's another patch that doesn't have the performance problems,
but removes the iput/igrab while still (I think) fixing the use
after free problem. Can you try this one out, Takenori? I've
run it through some stress tests and haven't been able to trigger
problems.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group


---
 fs/xfs/xfs_inode.c    |   44 +++++++++++++++++++++-----------------------
 fs/xfs/xfs_vnodeops.c |   21 ++++++++++++++-------
 2 files changed, 35 insertions(+), 30 deletions(-)

Index: 2.6.x-xfs-new/fs/xfs/xfs_inode.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_inode.c	2006-10-16 15:55:18.000000000 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_inode.c	2006-10-17 10:03:19.586174311 +1000
@@ -2739,41 +2739,39 @@ xfs_iunpin(
 	ASSERT(atomic_read(&ip->i_pincount) > 0);
 
 	if (atomic_dec_and_test(&ip->i_pincount)) {
+
 		/*
-		 * If the inode is currently being reclaimed, the
-		 * linux inode _and_ the xfs vnode may have been
-		 * freed so we cannot reference either of them safely.
-		 * Hence we should not try to do anything to them
-		 * if the xfs inode is currently in the reclaim
-		 * path.
+		 * If the inode is currently being reclaimed, the link between
+		 * the bhv_vnode and the xfs_inode will be broken after the
+		 * XFS_IRECLAIM* flag is set. Hence, if these flags are not
+		 * set, then we can move forward and mark the linux inode dirty
+		 * knowing that it is still valid as it won't freed until after
+		 * the bhv_vnode<->xfs_inode link is broken in xfs_reclaim. The
+		 * i_flags_lock is used to synchronise the setting of the
+		 * XFS_IRECLAIM* flags and the breaking of the link, and so we
+		 * can execute atomically w.r.t to reclaim by holding this lock
+		 * here.
 		 *
-		 * However, we still need to issue the unpin wakeup
-		 * call as the inode reclaim may be blocked waiting for
-		 * the inode to become unpinned.
+		 * However, we still need to issue the unpin wakeup call as the
+		 * inode reclaim may be blocked waiting for the inode to become
+		 * unpinned.
 		 */
-		struct inode *inode = NULL;
 
 		spin_lock(&ip->i_flags_lock);
 		if (!__xfs_iflags_test(ip, XFS_IRECLAIM|XFS_IRECLAIMABLE)) {
 			bhv_vnode_t	*vp = XFS_ITOV_NULL(ip);
+			struct inode *inode = NULL;
 
-			/* make sync come back and flush this inode */
-			if (vp) {
-				inode = vn_to_inode(vp);
+			BUG_ON(vp == NULL);
+			inode = vn_to_inode(vp);
+			BUG_ON(inode->i_state & I_CLEAR);
 
-				if (!(inode->i_state &
-						(I_NEW|I_FREEING|I_CLEAR))) {
-					inode = igrab(inode);
-					if (inode)
-						mark_inode_dirty_sync(inode);
-				} else
-					inode = NULL;
-			}
+			/* make sync come back and flush this inode */
+			if (!(inode->i_state & (I_NEW|I_FREEING)))
+				mark_inode_dirty_sync(inode);
 		}
 		spin_unlock(&ip->i_flags_lock);
 		wake_up(&ip->i_ipin_wait);
-		if (inode)
-			iput(inode);
 	}
 }
 
Index: 2.6.x-xfs-new/fs/xfs/xfs_vnodeops.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_vnodeops.c	2006-10-16 15:55:18.000000000 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_vnodeops.c	2006-10-17 10:27:38.447315865 +1000
@@ -3827,11 +3827,16 @@ xfs_reclaim(
 	 */
 	xfs_synchronize_atime(ip);
 
-	/* If we have nothing to flush with this inode then complete the
-	 * teardown now, otherwise break the link between the xfs inode
-	 * and the linux inode and clean up the xfs inode later. This
-	 * avoids flushing the inode to disk during the delete operation
-	 * itself.
+	/*
+	 * If we have nothing to flush with this inode then complete the
+	 * teardown now, otherwise break the link between the xfs inode and the
+	 * linux inode and clean up the xfs inode later. This avoids flushing
+	 * the inode to disk during the delete operation itself.
+	 *
+	 * When breaking the link, we need to set the XFS_IRECLAIMABLE flag
+	 * first to ensure that xfs_iunpin() will never see an xfs inode
+	 * that has a linux inode being reclaimed. Synchronisation is provided
+	 * by the i_flags_lock.
 	 */
 	if (!ip->i_update_core && (ip->i_itemp == NULL)) {
 		xfs_ilock(ip, XFS_ILOCK_EXCL);
@@ -3840,11 +3845,13 @@ xfs_reclaim(
 	} else {
 		xfs_mount_t	*mp = ip->i_mount;
 
-		/* Protect sync from us */
+		/* Protect sync and unpin from us */
 		XFS_MOUNT_ILOCK(mp);
+		spin_lock(&ip->i_flags_lock);
+		__xfs_iflags_set(ip, XFS_IRECLAIMABLE);
 		vn_bhv_remove(VN_BHV_HEAD(vp), XFS_ITOBHV(ip));
+		spin_unlock(&ip->i_flags_lock);
 		list_add_tail(&ip->i_reclaim, &mp->m_del_inodes);
-		xfs_iflags_set(ip, XFS_IRECLAIMABLE);
 		XFS_MOUNT_IUNLOCK(mp);
 	}
 	return 0;
