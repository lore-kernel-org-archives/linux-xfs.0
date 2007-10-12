Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 11 Oct 2007 17:26:30 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id l9C0QG9h008280
	for <xfs@oss.sgi.com>; Thu, 11 Oct 2007 17:26:20 -0700
Date: Fri, 12 Oct 2007 10:26:13 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: XFS regression?
Message-ID: <20071012002613.GL23367404@sgi.com>
References: <20071010152742.1b2a7bce@zeus.pccl.info> <20071011010139.GT995458@sgi.com> <20071011151512.69f19419@zeus.pccl.info> <20071011215352.GX995458@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071011215352.GX995458@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Andrew Clayton <andrew@digital-domain.net>, linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com

On Fri, Oct 12, 2007 at 07:53:53AM +1000, David Chinner wrote:
> On Thu, Oct 11, 2007 at 03:15:12PM +0100, Andrew Clayton wrote:
> > On Thu, 11 Oct 2007 11:01:39 +1000, David Chinner wrote:
> > 
> > > So it's almost certainly pointing at an elevator or driver change, not an
> > > XFS change.
> > 
> > heh, git bisect begs to differ :)
> > 
> > 4c60658e0f4e253cf275f12b7c76bf128515a774 is first bad commit commit
> > 4c60658e0f4e253cf275f12b7c76bf128515a774 Author: David Chinner <dgc@sgi.com>
> > Date:   Sat Nov 11 18:05:00 2006 +1100
> > 
> >     [XFS] Prevent a deadlock when xfslogd unpins inodes.
> 
> Oh, of course - I failed to notice the significance of
> this loop in your test:
> 
> 	while [foo]; do
> 		touch fred
> 		rm fred
> 	done
> 
> The inode allocator keeps reusing the same inode.  If the
> transaction that did the unlink has not hit the disk before we
> allocate the inode again, we have to force the log to get the unlink
> transaction to disk to get the xfs inode unpinned (i.e. able to be
> modified in memory again).
> 
> It's the log force I/O that's introducing the latency.
> 
> If we don't force the log, then we have a possible use-after free
> of the linux inode because of a fundamental mismatch between
> the XFS inode life cycle and the linux inode life cycle. The
> use-after free only occurs on large machines under heavy, heavy
> metadata load to many disks and filesystems (requires enough
> traffic to overload an xfslogd) and is very difficult to
> reproduce (large machine, lots of disks and 20-30 hours MTTF).
> 
> I'll have a look at other ways to solve this problem, but it
> took 6 months to find a solution to the race in the first place
> so don't hold your breath.

You can breath again. Here's a test patch (warning - may harm
kittens - not fully tested or verified) that solves both
the use-after-free issue (by avoiding it altogether) as well the
unlink/create latency because the log force is no longer there.

(yay! xfsqa test 016 passes again ;)

It does have other possible side effects triggering extra
log forces elsewhere on inode writeback and affects sync behaviour
so it's only a proof of concept at this point.

The latency output looks like:

<idle>

open("/mnt/scratch/testfile", O_WRONLY|O_CREAT|O_TRUNC|O_EXCL, 0600) = 3 <0.000281>
open("/mnt/scratch/testfile", O_WRONLY|O_CREAT|O_TRUNC|O_EXCL, 0600) = 3 <0.000184>
open("/mnt/scratch/testfile", O_WRONLY|O_CREAT|O_TRUNC|O_EXCL, 0600) = 3 <0.000188>
open("/mnt/scratch/testfile", O_WRONLY|O_CREAT|O_TRUNC|O_EXCL, 0600) = 3 <0.000182>
open("/mnt/scratch/testfile", O_WRONLY|O_CREAT|O_TRUNC|O_EXCL, 0600) = 3 <0.000225>
open("/mnt/scratch/testfile", O_WRONLY|O_CREAT|O_TRUNC|O_EXCL, 0600) = 3 <0.000182>
open("/mnt/scratch/testfile", O_WRONLY|O_CREAT|O_TRUNC|O_EXCL, 0600) = 3 <0.000185>

<start dd>

open("/mnt/scratch/testfile", O_WRONLY|O_CREAT|O_TRUNC|O_EXCL, 0600) = 3 <0.000405>
open("/mnt/scratch/testfile", O_WRONLY|O_CREAT|O_TRUNC|O_EXCL, 0600) = 3 <0.000224>
open("/mnt/scratch/testfile", O_WRONLY|O_CREAT|O_TRUNC|O_EXCL, 0600) = 3 <0.000199>
open("/mnt/scratch/testfile", O_WRONLY|O_CREAT|O_TRUNC|O_EXCL, 0600) = 3 <0.000163>

<writeback starts>

open("/mnt/scratch/testfile", O_WRONLY|O_CREAT|O_TRUNC|O_EXCL, 0600) = 3 <0.000145>
open("/mnt/scratch/testfile", O_WRONLY|O_CREAT|O_TRUNC|O_EXCL, 0600) = 3 <0.817704>
open("/mnt/scratch/testfile", O_WRONLY|O_CREAT|O_TRUNC|O_EXCL, 0600) = 3 <0.000148>
open("/mnt/scratch/testfile", O_WRONLY|O_CREAT|O_TRUNC|O_EXCL, 0600) = 3 <0.000143>
open("/mnt/scratch/testfile", O_WRONLY|O_CREAT|O_TRUNC|O_EXCL, 0600) = 3 <0.000154>
open("/mnt/scratch/testfile", O_WRONLY|O_CREAT|O_TRUNC|O_EXCL, 0600) = 3 <0.000147>
open("/mnt/scratch/testfile", O_WRONLY|O_CREAT|O_TRUNC|O_EXCL, 0600) = 3 <0.000158>
open("/mnt/scratch/testfile", O_WRONLY|O_CREAT|O_TRUNC|O_EXCL, 0600) = 3 <0.000144>
open("/mnt/scratch/testfile", O_WRONLY|O_CREAT|O_TRUNC|O_EXCL, 0600) = 3 <0.000379>
open("/mnt/scratch/testfile", O_WRONLY|O_CREAT|O_TRUNC|O_EXCL, 0600) = 3 <0.000151>
open("/mnt/scratch/testfile", O_WRONLY|O_CREAT|O_TRUNC|O_EXCL, 0600) = 3 <0.000190>
open("/mnt/scratch/testfile", O_WRONLY|O_CREAT|O_TRUNC|O_EXCL, 0600) = 3 <0.000191>
open("/mnt/scratch/testfile", O_WRONLY|O_CREAT|O_TRUNC|O_EXCL, 0600) = 3 <0.000150>
open("/mnt/scratch/testfile", O_WRONLY|O_CREAT|O_TRUNC|O_EXCL, 0600) = 3 <0.797099>
open("/mnt/scratch/testfile", O_WRONLY|O_CREAT|O_TRUNC|O_EXCL, 0600) = 3 <0.000139>
open("/mnt/scratch/testfile", O_WRONLY|O_CREAT|O_TRUNC|O_EXCL, 0600) = 3 <0.000163>

<writeback ends>

So we still see some operations show high latency - that will most likely
be due to the allocation transaction filling a log buffer and pushing it
to disk, then having to wait because I/O is in progress on all other log
buffers.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group


---
 fs/xfs/linux-2.6/xfs_iops.c |   16 ++++++++++++++++
 fs/xfs/xfs_iget.c           |   18 ------------------
 fs/xfs/xfs_inode.c          |   34 +---------------------------------
 fs/xfs/xfs_inode.h          |    1 +
 fs/xfs/xfs_inode_item.c     |    5 +++++
 5 files changed, 23 insertions(+), 51 deletions(-)

Index: 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_iops.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/linux-2.6/xfs_iops.c	2007-10-02 16:01:47.000000000 +1000
+++ 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_iops.c	2007-10-12 09:54:12.466194814 +1000
@@ -71,6 +71,22 @@ xfs_synchronize_atime(
 }
 
 /*
+ * If the linux inode exists, mark it dirty.
+ * Used when commiting a dirty inode into a transaction so that
+ * the inode will get written back by the linux code
+ */
+void
+xfs_mark_inode_dirty_sync(
+	xfs_inode_t	*ip)
+{
+	bhv_vnode_t	*vp;
+
+	vp = XFS_ITOV_NULL(ip);
+	if (vp)
+		mark_inode_dirty_sync(vn_to_inode(vp));
+}
+
+/*
  * Change the requested timestamp in the given inode.
  * We don't lock across timestamp updates, and we don't log them but
  * we do record the fact that there is dirty information in core.
Index: 2.6.x-xfs-new/fs/xfs/xfs_iget.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_iget.c	2007-10-02 16:01:48.000000000 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_iget.c	2007-10-12 09:58:38.263910771 +1000
@@ -140,27 +140,9 @@ again:
 				return ENOENT;
 			}
 
-			/*
-			 * There may be transactions sitting in the
-			 * incore log buffers or being flushed to disk
-			 * at this time.  We can't clear the
-			 * XFS_IRECLAIMABLE flag until these
-			 * transactions have hit the disk, otherwise we
-			 * will void the guarantee the flag provides
-			 * xfs_iunpin()
-			 */
-			if (xfs_ipincount(ip)) {
-				read_unlock(&pag->pag_ici_lock);
-				xfs_log_force(mp, 0,
-					XFS_LOG_FORCE|XFS_LOG_SYNC);
-				XFS_STATS_INC(xs_ig_frecycle);
-				goto again;
-			}
-
 			xfs_itrace_exit_tag(ip, "xfs_iget.alloc");
 
 			XFS_STATS_INC(xs_ig_found);
-
 			xfs_iflags_clear(ip, XFS_IRECLAIMABLE);
 			read_unlock(&pag->pag_ici_lock);
 
Index: 2.6.x-xfs-new/fs/xfs/xfs_inode.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_inode.c	2007-10-11 09:53:53.000000000 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_inode.c	2007-10-12 09:56:49.721912637 +1000
@@ -2807,40 +2807,8 @@ xfs_iunpin(
 {
 	ASSERT(atomic_read(&ip->i_pincount) > 0);
 
-	if (atomic_dec_and_lock(&ip->i_pincount, &ip->i_flags_lock)) {
-
-		/*
-		 * If the inode is currently being reclaimed, the link between
-		 * the bhv_vnode and the xfs_inode will be broken after the
-		 * XFS_IRECLAIM* flag is set. Hence, if these flags are not
-		 * set, then we can move forward and mark the linux inode dirty
-		 * knowing that it is still valid as it won't freed until after
-		 * the bhv_vnode<->xfs_inode link is broken in xfs_reclaim. The
-		 * i_flags_lock is used to synchronise the setting of the
-		 * XFS_IRECLAIM* flags and the breaking of the link, and so we
-		 * can execute atomically w.r.t to reclaim by holding this lock
-		 * here.
-		 *
-		 * However, we still need to issue the unpin wakeup call as the
-		 * inode reclaim may be blocked waiting for the inode to become
-		 * unpinned.
-		 */
-
-		if (!__xfs_iflags_test(ip, XFS_IRECLAIM|XFS_IRECLAIMABLE)) {
-			bhv_vnode_t	*vp = XFS_ITOV_NULL(ip);
-			struct inode *inode = NULL;
-
-			BUG_ON(vp == NULL);
-			inode = vn_to_inode(vp);
-			BUG_ON(inode->i_state & I_CLEAR);
-
-			/* make sync come back and flush this inode */
-			if (!(inode->i_state & (I_NEW|I_FREEING)))
-				mark_inode_dirty_sync(inode);
-		}
-		spin_unlock(&ip->i_flags_lock);
+	if (atomic_dec_and_test(&ip->i_pincount))
 		wake_up(&ip->i_ipin_wait);
-	}
 }
 
 /*
Index: 2.6.x-xfs-new/fs/xfs/xfs_inode.h
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_inode.h	2007-10-02 16:01:48.000000000 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_inode.h	2007-10-12 10:00:10.979948827 +1000
@@ -532,6 +532,7 @@ xfs_fsize_t	xfs_file_last_byte(xfs_inode
 void		xfs_lock_inodes(xfs_inode_t **, int, int, uint);
 
 void		xfs_synchronize_atime(xfs_inode_t *);
+void		xfs_mark_inode_dirty_sync(xfs_inode_t *);
 
 xfs_bmbt_rec_host_t *xfs_iext_get_ext(xfs_ifork_t *, xfs_extnum_t);
 void		xfs_iext_insert(xfs_ifork_t *, xfs_extnum_t, xfs_extnum_t,
Index: 2.6.x-xfs-new/fs/xfs/xfs_inode_item.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_inode_item.c	2007-10-02 16:01:48.000000000 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_inode_item.c	2007-10-12 09:54:18.053474268 +1000
@@ -274,6 +274,11 @@ xfs_inode_item_format(
 	 */
 	xfs_synchronize_atime(ip);
 
+	/*
+	 * make sure the linux inode is dirty
+	 */
+	xfs_mark_inode_dirty_sync(ip);
+
 	vecp->i_addr = (xfs_caddr_t)&ip->i_d;
 	vecp->i_len  = sizeof(xfs_dinode_core_t);
 	XLOG_VEC_SET_TYPE(vecp, XLOG_REG_TYPE_ICORE);
