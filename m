Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 17 Oct 2006 19:34:32 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k9I2YKaG015428
	for <xfs@oss.sgi.com>; Tue, 17 Oct 2006 19:34:24 -0700
Date: Wed, 18 Oct 2006 12:33:25 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: [patch] Fix xfs_iunpin() sets I_DIRTY_SYNC after clear_inode().
Message-ID: <20061018023325.GL8394166@melbourne.sgi.com>
References: <45237CCE.4010007@ah.jp.nec.com> <20061006032617.GC11034@melbourne.sgi.com> <20061011064357.GN19345@melbourne.sgi.com> <452E32FF.8010109@ah.jp.nec.com> <20061013014651.GC19345@melbourne.sgi.com> <452F83BD.8050501@ah.jp.nec.com> <20061017020218.GE8394166@melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20061017020218.GE8394166@melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com
Cc: Takenori Nagano <t-nagano@ah.jp.nec.com>

On Tue, Oct 17, 2006 at 12:02:18PM +1000, David Chinner wrote:
> In doing the previous patch that removed the igrab/iput, I used the
> log force to provide synchronisation that prevented the unpin from
> ever seeing an invalid state and hence we couldn't ever get a
> use-after-free situation. What I failed to see was that we already
> have this mechanism - the i_flags_lock and the XFS_IRECLAIM* flags.
> 
> If we synchronise the setting of either of the XFS_IRECLAIM* flags
> with the breakage of the bhv_vnode<->xfs_inode link, then we can
> never get the state in xfs_iunpin() where the link has been broken
> and the XFS_IRECLAIM* flags are not set. The current usage of
> the i_flags_lock in xfs_iunpin is sufficient to provide this
> guarantee, but we are breaking the link before setting the
> XFS_IRECLAIMABLE flag in xfs_reclaim()....
> 
> So, here's another patch that doesn't have the performance problems,
> but removes the iput/igrab while still (I think) fixing the use
> after free problem. Can you try this one out, Takenori? I've
> run it through some stress tests and haven't been able to trigger
> problems.

I just hit the BUG_ON(vp == NULL) that I put in xfs_iunpin()
in this patch. The xfs inode had no link to the bhv_vnode, nor
did it have either XFS_IRECLAIM* flag set, and hence it triggered
the BUG.

The problem appears to be  a race with on lookup with an inode that
is getting deleted - xfs_iget_core() finds the xfs_inode in the
cache with the XFS_IRECLAIMABLE flag set, so it removes that flag.
It then removes the inode from the reclaim list. Then it checks to
see if the inode has been unlinked, and if the create flag is not
set we return ENOENT.

Hence if we have transactions still to be written to disk on this
inode, when xfs_iunpin finally gets called there is no reclaim flag
set so it assumes that there's a vnode assoicated with the xfs inode
and we got kaboom.

I think this is a pre-existing bug in xfs_iget_core() that can
result in a memory leak because xfs_iget_core() removes it from
the reclaim list and then forgets about at...

The following patch sits on top of the others - it may not apply
because the tree I just pulled it from has the radix tree
inode cache patches applied earlier in the series.

Comments?

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group


---
 fs/xfs/xfs_iget.c |   28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

Index: 2.6.x-xfs-new/fs/xfs/xfs_iget.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_iget.c	2006-10-18 11:27:04.000000000 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_iget.c	2006-10-18 12:20:20.748107559 +1000
@@ -164,6 +164,34 @@ again:
 
 				goto again;
 			}
+
+			/*
+			 * If IRECLAIMABLE is set on this inode and lookup is
+			 * racing with unlink, then we should return an error
+			 * immediately so we don't remove it from the reclaim
+			 * list and potentially leak the inode.
+			 *
+			 * Also, there may be transactions sitting in the
+			 * incore log buffers or being flushed to disk at this
+			 * time.  We can't clear the XFS_IRECLAIMABLE flag
+			 * until these transactions have hit the disk,
+			 * otherwise we will void the guarantee the flag
+			 * provides xfs_iunpin()
+			 */
+			if (xfs_iflags_test(ip, XFS_IRECLAIMABLE)) {
+				if (ip->i_d.di_mode == 0) &&
+				    !(flags & XFS_IGET_CREATE)) {
+					read_unlock(&ih->ih_lock);
+					return ENOENT;
+				}
+				if (xfs_ipincount(ip)) {
+					read_unlock(&ih->ih_lock);
+					xfs_log_force(mp, 0,
+						XFS_LOG_FORCE|XFS_LOG_SYNC);
+					XFS_STATS_INC(xs_ig_frecycle);
+					goto again;
+				}
+			}
 			vn_trace_exit(vp, "xfs_iget.alloc",
 				(inst_t *)__return_address);
 
