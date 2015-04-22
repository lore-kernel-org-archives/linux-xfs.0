Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 5CD227F37
	for <xfs@oss.sgi.com>; Wed, 22 Apr 2015 18:18:15 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 4C87E304039
	for <xfs@oss.sgi.com>; Wed, 22 Apr 2015 16:18:12 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	plqcaK8y50IKHBYK for <xfs@oss.sgi.com>;
	Wed, 22 Apr 2015 16:18:08 -0700 (PDT)
Date: Thu, 23 Apr 2015 09:17:58 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: call xfs_idestroy_fork() in xfs_ilock() critical
	section
Message-ID: <20150422231758.GQ21261@dastard>
References: <1429724021-7675-1-git-send-email-Waiman.Long@hp.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1429724021-7675-1-git-send-email-Waiman.Long@hp.com>
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
To: Waiman Long <Waiman.Long@hp.com>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Wed, Apr 22, 2015 at 01:33:41PM -0400, Waiman Long wrote:
> The commit f7be2d7f594cbc ("xfs: push down inactive transaction
> mgmt for truncate") refactored the xfs_inactive() function
> in fs/xfs/xfs_inode.c.  However, it also moved the call to
> xfs_idestroy_fork() from inside the xfs_ilock() critical section to
> outside. That was causing memory corruption and strange failures like
> deferencing NULL pointers in some circumstances.

Interesting.

However, while locking may fix the problem, it is not sufficient
just to add locking without first understanding what problem the
locking is fixing.

> This patch moves the xfs_idestroy_fork() call back into an xfs_ilock()
> critical section to avoid memory corruption problem.
> 
> Signed-off-by: Waiman Long <Waiman.Long@hp.com>
> ---
>  fs/xfs/xfs_inode.c |    5 ++++-
>  1 files changed, 4 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 6163767..31850fb 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -1900,8 +1900,11 @@ xfs_inactive(
>  			return;
>  	}
>  
> -	if (ip->i_afp)
> +	if (ip->i_afp) {
> +		xfs_ilock(ip, XFS_ILOCK_EXCL);
>  		xfs_idestroy_fork(ip, XFS_ATTR_FORK);
> +		xfs_iunlock(ip, XFS_ILOCK_EXCL);
> +	}

The inode, at this point, is not referencable by the VFS because it
is in the ->evict path, and it's not reclaimable by XFS because we
don't set the XFS_IRECLAIMABLE flag until the VFS eviction path
calls ->destroy_inode.  Hence the inode cannot be _actively_
referenced by anything else at this point in it's life cycle - if
there is a race it's with a passive reference somewhere unexpected.
It may be that the locking is just altering the timing of whatever
the underlying bug triggers.

/me digs deeper

By this stage we will have called xfs_attr_inactive() which means
there shouldn't be an attribute fork on the inode anymore.  Hence it
/should/ be safe to remove the in-core structures referencing it.
Going back to the original problem report, it indicated that
ip->i_d.di_forkoff was not zero and so we were trying to flush on
attribute fork.

If we assume that it raced with the above code in xfs_inactive(),
that tells me that perhaps xfs_attr_inactive() is not doing
everything it should:

        /*
         * Decide on what work routines to call based on the inode size.
         */
        if (!xfs_inode_hasattr(dp) ||
            dp->i_d.di_aformat == XFS_DINODE_FMT_LOCAL) {
                error = 0;
                goto out;
        }

Ok, it leaves the attribute fork present in the inode if it is in
local format, of if it is in extent format and has no extents. IOWs,
it leaves ip->i_d.di_forkoff > 0 and in the crash case:

3409        if (XFS_IFORK_Q(ip))
   0x0000000000000345 <+261>:    cmpb   $0x0,0x14a(%r12)
   0x000000000000034e <+270>:    jne    0x420 <xfs_iflush_int+480>

3410            xfs_iflush_fork(ip, dip, iip, XFS_ATTR_FORK);

And:

#define XFS_IFORK_Q(ip)                 ((ip)->i_d.di_forkoff != 0)

We use the di_forkoff to determine if we need to flush the attribute
fork. However, we should end up triggering this code in
xfs_iflush_fork() on the attribute fork:

        ifp = XFS_IFORK_PTR(ip, whichfork);
        /*
         * This can happen if we gave up in iformat in an error path,
         * for the attribute fork.
         */
        if (!ifp) {
                ASSERT(whichfork == XFS_ATTR_FORK);
                return;
        }

i.e. the !ifp case, and so not accessing anything in the attribute
fork that is being freed by xfs_inactive().

To make matters more complex, this inode should not be being written
back right now - we've just issued transactions on it that pin the
inode in memory until the CIL is forced and the journal IO has
completed and unpinned the inode. There must be some significant
pre-emption delay occurring on your test for this to occur between
committing the inode in xfs_inactive() and the attribute fork being
removed.

However, writeback is holding the XFS_ILOCK_SHARED when it calls
xfs_iflush_fork(), so this would appear to be the race condition the
locking is avoiding, however unlikely the timing of it is.

IOWs, the issue here is that we are removing the in-core attribute
fork but leaving attributes in the on-disk inode and hoping that
other code doesn't step on the landmine of inconsistent
on-disk/in-memory state. Which it clearly did in this case here.

The patch below removes the landmine from xfs_inactive and
xfs_attr_inactive. It's a lot more than adding locking, but solves
the underlying problem rather than working around it. It smoke tests
fine, and I'm now running it through xfstests.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

xfs: xfs_attr_inactive leaves inconsistent attr fork state behind

From: Dave Chinner <dchinner@redhat.com>

xfs_attr_inactive() is supposed to clean up the attribute fork when
the inode is being freed. While it removes attribute fork extents,
it completely ignores attributes in local format, which means that
there can still be active attributes on the inode after
xfs_attr_inactive() has run.

This leads to problems with concurrent inode writeback - the in-core
inode attribute fork is removed without locking on the assumption
that nothing will be attempting to access the attribute fork after a
call to xfs_attr_inactive() because it isn't supposed to exist on
disk any more.

To fix this, make xfs_attr_inactive() completely remove all traces
of the attribute fork from the inode, regardless of it's state.
Further, also remove the in-core attribute fork structure safely so
that there is nothing further that needs to be done by callers to
clean up the attribute fork. This means we can remove the in-core
and on-disk attribute forks atomically.

Also, on error simply remove the in-memory attribute fork. There's
nothing that can be done with it once we have failed to remove the
on-disk attribute fork, so we may as well just blow it away here
anyway.

cc: <stable@vger.kernel.org> # 3.12 to 4.0
Reported-by: Waiman Long <waiman.long@hp.com>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_attr_leaf.c |  2 +-
 fs/xfs/libxfs/xfs_attr_leaf.h |  2 +-
 fs/xfs/xfs_attr_inactive.c    | 81 ++++++++++++++++++++++++++-----------------
 fs/xfs/xfs_inode.c            | 12 +++----
 4 files changed, 55 insertions(+), 42 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index 04e79d5..36b354e 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -574,7 +574,7 @@ xfs_attr_shortform_add(xfs_da_args_t *args, int forkoff)
  * After the last attribute is removed revert to original inode format,
  * making all literal area available to the data fork once more.
  */
-STATIC void
+void
 xfs_attr_fork_reset(
 	struct xfs_inode	*ip,
 	struct xfs_trans	*tp)
diff --git a/fs/xfs/libxfs/xfs_attr_leaf.h b/fs/xfs/libxfs/xfs_attr_leaf.h
index 025c4b8..6478627 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.h
+++ b/fs/xfs/libxfs/xfs_attr_leaf.h
@@ -53,7 +53,7 @@ int	xfs_attr_shortform_remove(struct xfs_da_args *args);
 int	xfs_attr_shortform_list(struct xfs_attr_list_context *context);
 int	xfs_attr_shortform_allfit(struct xfs_buf *bp, struct xfs_inode *dp);
 int	xfs_attr_shortform_bytesfit(xfs_inode_t *dp, int bytes);
-
+void	xfs_attr_fork_reset(struct xfs_inode *ip, struct xfs_trans *tp);
 
 /*
  * Internal routines when attribute fork size == XFS_LBSIZE(mp).
diff --git a/fs/xfs/xfs_attr_inactive.c b/fs/xfs/xfs_attr_inactive.c
index f9c1c64..6b1bc9a 100644
--- a/fs/xfs/xfs_attr_inactive.c
+++ b/fs/xfs/xfs_attr_inactive.c
@@ -380,23 +380,31 @@ xfs_attr3_root_inactive(
 	return error;
 }
 
+/*
+ * xfs_attr_inactive kills all traces of an attribute fork on an inode. It
+ * removes both the on-disk and in-memory inode fork. Note that this also has to
+ * handle the condition of inodes without attributes but with an attribute fork
+ * configured, so we can't use xfs_inode_hasattr() here.
+ *
+ * The in-memory attribute fork is removed even on error.
+ */
 int
-xfs_attr_inactive(xfs_inode_t *dp)
+xfs_attr_inactive(
+	struct xfs_inode	*dp)
 {
-	xfs_trans_t *trans;
-	xfs_mount_t *mp;
-	int error;
+	struct xfs_trans	*trans;
+	struct xfs_mount	*mp;
+	int			cancel_flags = 0;
+	int			lock_mode = XFS_ILOCK_SHARED;
+	int			error = 0;
 
 	mp = dp->i_mount;
 	ASSERT(! XFS_NOT_DQATTACHED(mp, dp));
 
-	xfs_ilock(dp, XFS_ILOCK_SHARED);
-	if (!xfs_inode_hasattr(dp) ||
-	    dp->i_d.di_aformat == XFS_DINODE_FMT_LOCAL) {
-		xfs_iunlock(dp, XFS_ILOCK_SHARED);
-		return 0;
-	}
-	xfs_iunlock(dp, XFS_ILOCK_SHARED);
+	xfs_ilock(dp, lock_mode);
+	if (!XFS_IFORK_Q(dp))
+		goto out_destroy_fork;
+	xfs_iunlock(dp, lock_mode);
 
 	/*
 	 * Start our first transaction of the day.
@@ -410,11 +418,12 @@ xfs_attr_inactive(xfs_inode_t *dp)
 	 */
 	trans = xfs_trans_alloc(mp, XFS_TRANS_ATTRINVAL);
 	error = xfs_trans_reserve(trans, &M_RES(mp)->tr_attrinval, 0, 0);
-	if (error) {
-		xfs_trans_cancel(trans, 0);
-		return error;
-	}
-	xfs_ilock(dp, XFS_ILOCK_EXCL);
+	if (error)
+		goto out_cancel;
+
+	lock_mode = XFS_ILOCK_EXCL;
+	cancel_flags = XFS_TRANS_RELEASE_LOG_RES | XFS_TRANS_ABORT;
+	xfs_ilock(dp, lock_mode);
 
 	/*
 	 * No need to make quota reservations here. We expect to release some
@@ -423,28 +432,36 @@ xfs_attr_inactive(xfs_inode_t *dp)
 	xfs_trans_ijoin(trans, dp, 0);
 
 	/*
-	 * Decide on what work routines to call based on the inode size.
+	 * It's unlikely we've raced with an attribute fork creation, but check
+	 * anyway just in case.
 	 */
-	if (!xfs_inode_hasattr(dp) ||
-	    dp->i_d.di_aformat == XFS_DINODE_FMT_LOCAL) {
-		error = 0;
-		goto out;
+	if (!XFS_IFORK_Q(dp))
+		goto out_cancel;
+
+	/* invalidate and truncate the attribute fork extents */
+	if (dp->i_d.di_aformat != XFS_DINODE_FMT_LOCAL) {
+		error = xfs_attr3_root_inactive(&trans, dp);
+		if (error)
+			goto out_cancel;
+
+		error = xfs_itruncate_extents(&trans, dp, XFS_ATTR_FORK, 0);
+		if (error)
+			goto out_cancel;
 	}
-	error = xfs_attr3_root_inactive(&trans, dp);
-	if (error)
-		goto out;
 
-	error = xfs_itruncate_extents(&trans, dp, XFS_ATTR_FORK, 0);
-	if (error)
-		goto out;
+	/* Reset the attribute fork - this also destroys the in-core fork */
+	xfs_attr_fork_reset(dp, trans);
 
 	error = xfs_trans_commit(trans, XFS_TRANS_RELEASE_LOG_RES);
-	xfs_iunlock(dp, XFS_ILOCK_EXCL);
-
+	xfs_iunlock(dp, lock_mode);
 	return error;
 
-out:
-	xfs_trans_cancel(trans, XFS_TRANS_RELEASE_LOG_RES|XFS_TRANS_ABORT);
-	xfs_iunlock(dp, XFS_ILOCK_EXCL);
+out_cancel:
+	xfs_trans_cancel(trans, cancel_flags);
+out_destroy_fork:
+	/* kill the in-core attr fork before we drop the inode lock */
+	if (dp->i_afp)
+		xfs_idestroy_fork(dp, XFS_ATTR_FORK);
+	xfs_iunlock(dp, lock_mode);
 	return error;
 }
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index d6ebc85..1117dd3 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1946,21 +1946,17 @@ xfs_inactive(
 	/*
 	 * If there are attributes associated with the file then blow them away
 	 * now.  The code calls a routine that recursively deconstructs the
-	 * attribute fork.  We need to just commit the current transaction
-	 * because we can't use it for xfs_attr_inactive().
+	 * attribute fork. If also blows away the in-core attribute fork.
 	 */
-	if (ip->i_d.di_anextents > 0) {
-		ASSERT(ip->i_d.di_forkoff != 0);
-
+	if (XFS_IFORK_Q(ip)) {
 		error = xfs_attr_inactive(ip);
 		if (error)
 			return;
 	}
 
-	if (ip->i_afp)
-		xfs_idestroy_fork(ip, XFS_ATTR_FORK);
-
+	ASSERT(!ip->i_afp);
 	ASSERT(ip->i_d.di_anextents == 0);
+	ASSERT(ip->i_d.di_forkoff == 0);
 
 	/*
 	 * Free the inode.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
