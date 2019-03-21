Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:6913 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726093AbfCUVK6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 21 Mar 2019 17:10:58 -0400
Date: Fri, 22 Mar 2019 08:10:51 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: generic/475 deadlock?
Message-ID: <20190321211051.GV23020@dastard>
References: <20190320050408.GA24923@magnolia>
 <20190320170305.GA29010@bfoster>
 <20190320174551.GA1186@magnolia>
 <20190320175922.GB29010@bfoster>
 <20190320214938.GU23020@dastard>
 <20190321121152.GA33001@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190321121152.GA33001@bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, xfs <linux-xfs@vger.kernel.org>

On Thu, Mar 21, 2019 at 08:11:52AM -0400, Brian Foster wrote:
> On Thu, Mar 21, 2019 at 08:49:38AM +1100, Dave Chinner wrote:
> > On Wed, Mar 20, 2019 at 01:59:22PM -0400, Brian Foster wrote:
> > > On Wed, Mar 20, 2019 at 10:45:51AM -0700, Darrick J. Wong wrote:
> > > > On Wed, Mar 20, 2019 at 01:03:05PM -0400, Brian Foster wrote:
> > > > > On Tue, Mar 19, 2019 at 10:04:08PM -0700, Darrick J. Wong wrote:
> > > > > And unmount is doing a log force as well..
> > > > > 
> > > > > Hmm.. yeah, I think we need to figure out how/why the buffer is locked.
> > > > 
> > > > AFAICT it's xfs_inode_item_push -> xfs_iflush -> xfs_imap_to_bp that
> > > > returns the locked cluster buffer (code extract from xfs_iflush):
> > ....
> > > > ...but if the buffer is also pinned then we kick the log (while holding
> > > > the buffer lock) to unpin the buffer.  Since the fs is shutdown, the cil
> > > > will just be trying to remove everything, but it needs to lock the
> > > > buffer to simulate EIO.
> > > > 
> > > 
> > > Yeah, makes sense.
> > 
> > Yup, and this same problem means any buffer we hold locked when we
> > issue a blocking log force can deadlock in the same way. If it's a
> > non-blocking log force (i.e. a log flush we don't wait for) then we
> > can move onwards and eventually we unlock the buffer and the log can
> > make progress.
> > 
> > > > A naive fix to the deadlock is to see if the inode buf ops are attached
> > > > and downgrade to a trylock and go ahead even if we can't lock it, but ick.
> > > > It resolves the deadlock so the umount can proceed but we also trigger a
> > > > lot of unlocked buffer asserts.
> > 
> > Yuck!
> > 
> > > > I'm not sure what "too long" means in that code chunk.  It was added to
> > > > reduce stalls in pdflush, which these days I think translates to trying
> > > > to reduce the amount of time reclaim can stall while flushing inodes...?
> > 
> > "too long" means that if there is no log pressure, it might be the
> > next periodic log work that forces the log and unpins the buffer.
> > i.e. it could be several seconds before the buffer gets unpinned.
> > This is the same reason we have the log force in xfs_buf_lock() - if
> > we have to wait for the next log force to unlock/unpin a stale
> > buffer, we can stall for several seconds.
> > 
> 
> Ok.. so it kind of looks to me that this particular instance of the log
> force is a historical artifact of xfsaild. The latter used to use
> separate ->trylock() and ->push() log item callbacks where the former
> would either lock the object or return LOCKED, PINNED, etc. So a pinned
> buffer or inode would return pinned here and xfsaild does the log force
> on its behalf once it's through the current cycle.

Sure. that's no different to now. The only thing that is different
is that we combined ->trylock, ->push and ->pushbuf into one
function. The actual semantics and behaviour is unchanged.

i.e. if you look at xfs_iflush(ip, ASYNC) back then, it did:

        /*
         * If the buffer is pinned then push on the log now so we won't
         * get stuck waiting in the write for too long.
         */
        if (XFS_BUF_ISPINNED(bp))
                xfs_log_force(mp, (xfs_lsn_t)0, XFS_LOG_FORCE);

<snip iflush_cluster to pull in all other dirty inodes>

        if (flags & INT_DELWRI) {
                xfs_bdwrite(mp, bp);
        } else if (flags & INT_ASYNC) {
                error = xfs_bawrite(mp, bp);
        } else {
                error = xfs_bwrite(mp, bp);
        }

And then it would write the inode buffer directly with an async write
via xfs_bawrite(). i.e. there was no delwri list or anything like
that - the inode flush controlled the inode buffer writeback and
hence the unpinning of the inode buffer. The only difference now is
that the caller controls how the buffer is written, not
xfs_iflush...

> An unpinned inode with a pinned cluster buffer didn't communicate this
> state because the inode ->trylock() callout grabbed the ilock and iflock
> and returned success. The iflush doesn't occur until ->push(), which
> means if the cluster buffer is pinned and we wanted to force the log
> than xfs_iflush() is the last chance to do it.
> 
> (For reference, I'm looking at the code as of v2.6.33).

Again, that's no different to what we have now - the push is for the
inode, not the backing buffer. If we can't lock the inode because
it's pinned or already flushing, then we return that info to AIL
loop.  The acutal state of the backing buffer is still completely
hidden from the caller and so that's why I left the unpin in that
code.

> The current xfsaild() log force logic is still tied to PINNED objects,
> but it has additional logic to detect skipped buffers at delwri queue
> submit time (i.e., due to being pinned) that should cover the pinned
> inode cluster buffer case.

And it's not skipped buffers, either. Skipped buffers are only for
determining timeouts - it's the ail->ail_log_flush counter that
determines whether a log flush should be done or not, and that's
only incremented on ITEM_PINNED objects. This is why I was
suggesting returning that if the backing buffer is pinned, but I
forgot all about how we already handle this case...

> But given the above, couldn't we just remove the log force from
> xfs_iflush() and let the existing xfsaild_push() logic handle it?

We can, but not for the reasons you are suggesting.

> It
> should detect any pinned buffers after the delwri queue submit and do
> the log force.

And this is what we already do with this code:

	if (xfs_buf_delwri_submit_nowait(&ailp->ail_buf_list))
		ailp->ail_log_flush++;

Which falls down to this code when we try to flush a pinned delwri
buffer:

	list_for_each_entry_safe(bp, n, buffer_list, b_list) {
		if (!wait_list) {
			if (xfs_buf_ispinned(bp)) {
				pinned++;
				continue;
			}
....
	return pinned;

Basically, we leave pinned buffers on the delwri list rather than
remove them and issue IO on them, and tell the caller that we left
pinned/locked buffers on the list that still need to be submitted.
The AIL takes this as an indication it needs to flush the log to
unpin the buffers it can't flush, and because they are still on it's
delwri list, it will attempt to submit them again next time around
after the log has been forced.

So given that inode reclaim already waits for inodes to be unpinned
and there is a xfs_buf_unpin_wait() call in
xfs_bwrite()->xfs_buf_submit() path that will issue a log force on
the buffer from the inode reclaim path, we don't actually need the
log force in xfs_iflush() at all. i.e.  the AIL will capture the
buffer state and unpin inode and dquot buffers automatically, and so
we can simply remove the pinned-buffer log forces from the
inode/dquot flush code....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
