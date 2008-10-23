Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 23 Oct 2008 15:19:53 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9NMJjmX012419
	for <xfs@oss.sgi.com>; Thu, 23 Oct 2008 15:19:45 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6D42D536E24
	for <xfs@oss.sgi.com>; Thu, 23 Oct 2008 15:21:30 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id Gx8heJimDw7uB4hC for <xfs@oss.sgi.com>; Thu, 23 Oct 2008 15:21:30 -0700 (PDT)
Date: Fri, 24 Oct 2008 09:21:26 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: assertion failure with latest xfs
Message-ID: <20081023222126.GA18495@disturbed>
References: <49003EFF.4090404@sgi.com> <20081023173149.GA30316@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081023173149.GA30316@infradead.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: Lachlan McIlroy <lachlan@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Thu, Oct 23, 2008 at 01:31:49PM -0400, Christoph Hellwig wrote:
> On Thu, Oct 23, 2008 at 07:08:15PM +1000, Lachlan McIlroy wrote:
> > Just encountered this after pulling in the latest changes.  We are trying to
> > initialise an inode that should have an i_count of 1 but instead it is 2.  I
> > was running XFSQA test 167 when it happened.
> 
> I think the assert is incorrect.  The inode has been added to the radix
> tree in xfs_iget_cache_miss, and starting from that point an igrab can
> kick in from the sync code and bump the refcount.

Actually, it was put there for a reason. The generic code doesn't
allow new inodes to be found in the cache until the I_LOCK flag is
cleared. This is done by calling wait_on_inode() after a successful
lookup (which waits on I_LOCK) and unlock_new_inode() clears the
I_LOCK|I_NEW bits and wakes anyone who was waiting on that inode via
wake_up_inode().  So the assert was put there to catch potential
races in lookup where a second process does a successful igrab()
before the inode is fully initialised.

I think the race is in dealing with cache hits and recycling a
XFS_IRECLAIMABLE inode. We set the XFS_INEW flag there under
the radix tree read lock, which means we can have parallel lookups
on the same inode that goes:

	thread 1				thread 2
	test XFS_INEW
		-> not set
	test XFS_IRECLAIMABLE
		-> set
						test XFS_INEW
							-> not set
	set XFS_INEW
	clear XFS_IRECLAIMABLE
						test XFS_IRECLAIMABLE
							-> not set
	xfs_setup_inode()
		-> i_state = I_NEW|I_LOCK
						igrab(inode)
							-> I_CLEAR not set
							-> refcount = 2
		-> inode_add_to_lists
		-> assert(refcount == 1)
		.....
		-> clear XFS_INEW
		-> unlock_new_inode()
			-> clear I_NEW|I_LOCK

I thought I'd handled this race with the ordering of setting/clearing
XFS_INEW/XFS_IRECLAIMABLE. Clearly not. I'll add a comment to this
ordering because it is key to actually detecting the race condition
so we can handle it.

Hmmmm - there's also another bug in xfs_iget_cache_hit() - we don't
drop the reference we got if we found an unlinked inode after the
igrab() (the ENOENT case). I'll fix that as well.

Patch below that I'm currently running through xfsqa.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

XFS: Fix race when looking up reclaimable inodes

If we get a race looking up a reclaimable inode, we can
end up with the winner proceeding to use the inode before
it has been completely re-initialised. This is a Bad Thing.

Fix the race by checking whether we are still initialising the
inod eonce we have a reference to it, and if so wait for the
initialisation to complete before continuing.

While there, fix a leaked reference count in the same code
when encountering an unlinked inode and we are not doing a
lookup for a create operation.
---
 fs/xfs/linux-2.6/xfs_linux.h |    1 +
 fs/xfs/xfs_iget.c            |   32 ++++++++++++++++++++++----------
 2 files changed, 23 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_linux.h b/fs/xfs/linux-2.6/xfs_linux.h
index cc0f7b3..947dfa1 100644
--- a/fs/xfs/linux-2.6/xfs_linux.h
+++ b/fs/xfs/linux-2.6/xfs_linux.h
@@ -77,6 +77,7 @@
 #include <linux/spinlock.h>
 #include <linux/random.h>
 #include <linux/ctype.h>
+#include <linux/writeback.h>
 
 #include <asm/page.h>
 #include <asm/div64.h>
diff --git a/fs/xfs/xfs_iget.c b/fs/xfs/xfs_iget.c
index 837cae7..bf4dc5e 100644
--- a/fs/xfs/xfs_iget.c
+++ b/fs/xfs/xfs_iget.c
@@ -52,7 +52,7 @@ xfs_iget_cache_hit(
 	int			lock_flags) __releases(pag->pag_ici_lock)
 {
 	struct xfs_mount	*mp = ip->i_mount;
-	int			error = 0;
+	int			error = EAGAIN;
 
 	/*
 	 * If INEW is set this inode is being set up
@@ -60,7 +60,6 @@ xfs_iget_cache_hit(
 	 * Pause and try again.
 	 */
 	if (xfs_iflags_test(ip, (XFS_INEW|XFS_IRECLAIM))) {
-		error = EAGAIN;
 		XFS_STATS_INC(xs_ig_frecycle);
 		goto out_error;
 	}
@@ -73,7 +72,6 @@ xfs_iget_cache_hit(
 		 * error immediately so we don't remove it from the reclaim
 		 * list and potentially leak the inode.
 		 */
-
 		if ((ip->i_d.di_mode == 0) && !(flags & XFS_IGET_CREATE)) {
 			error = ENOENT;
 			goto out_error;
@@ -91,27 +89,42 @@ xfs_iget_cache_hit(
 			error = ENOMEM;
 			goto out_error;
 		}
+
+		/*
+		 * We must set the XFS_INEW flag before clearing the
+		 * XFS_IRECLAIMABLE flag so that if a racing lookup does
+		 * not find the XFS_IRECLAIMABLE above but has the igrab()
+		 * below succeed we can safely check XFS_INEW to detect
+		 * that this inode is still being initialised.
+		 */
 		xfs_iflags_set(ip, XFS_INEW);
 		xfs_iflags_clear(ip, XFS_IRECLAIMABLE);
 
 		/* clear the radix tree reclaim flag as well. */
 		__xfs_inode_clear_reclaim_tag(mp, pag, ip);
-		read_unlock(&pag->pag_ici_lock);
 	} else if (!igrab(VFS_I(ip))) {
 		/* If the VFS inode is being torn down, pause and try again. */
-		error = EAGAIN;
 		XFS_STATS_INC(xs_ig_frecycle);
 		goto out_error;
-	} else {
-		/* we've got a live one */
-		read_unlock(&pag->pag_ici_lock);
+	} else if (xfs_iflags_test(ip, XFS_INEW)) {
+		/*
+		 * We are racing with another cache hit that is
+		 * currently recycling this inode out of the XFS_IRECLAIMABLE
+		 * state. Wait for the initialisation to complete before
+		 * continuing.
+		 */
+		wait_on_inode(VFS_I(ip));
 	}
 
 	if (ip->i_d.di_mode == 0 && !(flags & XFS_IGET_CREATE)) {
 		error = ENOENT;
-		goto out;
+		iput(VFS_I(ip));
+		goto out_error;
 	}
 
+	/* We've got a live one. */
+	read_unlock(&pag->pag_ici_lock);
+
 	if (lock_flags != 0)
 		xfs_ilock(ip, lock_flags);
 
@@ -122,7 +135,6 @@ xfs_iget_cache_hit(
 
 out_error:
 	read_unlock(&pag->pag_ici_lock);
-out:
 	return error;
 }
 
