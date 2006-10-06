Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 05 Oct 2006 20:27:24 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k963RFaG031894
	for <xfs@oss.sgi.com>; Thu, 5 Oct 2006 20:27:17 -0700
Date: Fri, 6 Oct 2006 13:26:17 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: [patch] Fix xfs_iunpin() sets I_DIRTY_SYNC after clear_inode().
Message-ID: <20061006032617.GC11034@melbourne.sgi.com>
References: <45237CCE.4010007@ah.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45237CCE.4010007@ah.jp.nec.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Takenori Nagano <t-nagano@ah.jp.nec.com>
Cc: xfs@oss.sgi.com

On Wed, Oct 04, 2006 at 06:20:14PM +0900, Takenori Nagano wrote:
> Hi,
> 
> The patch attached to this mail is a fix for a race of xfs_iunpin()
> and generic_delete_inode().

Ahh, that problem, still. :/

> If __mark_inode_dirty() is running simultaneously between
> clear_inode() and BUG_ON() in generic_delete_inode(), BUG_ON() is
> called. We think this is a cause of this bug.

*nod*

> xfs_fs_clear_inode() calls xfs_reclaim(). We think the recent fixes to
> xfs_iunpin() were not correct. With those patches, xfs_iunpin() now
> can determine whether xfs_inode is recycled or not, but it is not
> essential way to fix this bug.

Agreed - it was always a pretty ugly way to fix the problem.

> xfs_iunpin() must never touch xfs_inode
> which is already freed.

It must never touch the linux inode, not the xfs_inode....

> If try_to_free_page() collects some slabs
> including pinned inode, it is possible to result in memory corruption.

It's the linux inode that gets used after it's been freed, not the
xfs_inode (which doesn't get freed until after it is unpinned
and the async reclaim is run).

> We come up with three possible solutions:
> 1. xfs_fs_clear_inode() waits for i_pincount to become 0.
> 2. xfs_fs_clear_inode() syncs in-core log if i_pincount is not 0.
> 3. xfs_fs_clear_inode() invalidates in-core log that relates to the
> deleted inode.
> 
> We chose 2, because the frequency of sync is almost same to as that of
> BUG(), and it is the same way to sync in-core log in xfs_fsync() when
> inode is still pinned. It has very very little effect for xfs performance.

Option 1 is the correct solution and we already have a function for
doing that - xfs_iunpin_wait(). This also forces the log in the
most optimal manner (i.e. only up to the LSN of the pinned log item)
before waiting for the pin count to fall to zero so it does
option 2 as well.

> This patch fixes to sync in-core log if i_pincount is not 0 in
> xfs_fs_clear_inode(). We think this is essential.

The fix should go into xfs_reclaim rather than xfs_fs_clear_inode
as this is where it is important to wait.

I think this is a much better way of fixing the problem, but it needs
a little tweaking. Also, it indicates that we can probably revert
some of the previous changes made in attempting to fix this bug.
I'll put together a new patch with this fix and as much of the
other fixes removed as possible and run some tests on it here.
It'l be a day or two before I have a tested patch ready....

Thanks for persisting with this, Takenori - this looks like
it will be a good, robust solution to the problem.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
