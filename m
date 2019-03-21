Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40208 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727878AbfCUMLz (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 21 Mar 2019 08:11:55 -0400
Date: Thu, 21 Mar 2019 08:11:52 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: generic/475 deadlock?
Message-ID: <20190321121152.GA33001@bfoster>
References: <20190320050408.GA24923@magnolia>
 <20190320170305.GA29010@bfoster>
 <20190320174551.GA1186@magnolia>
 <20190320175922.GB29010@bfoster>
 <20190320214938.GU23020@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190320214938.GU23020@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, xfs <linux-xfs@vger.kernel.org>

On Thu, Mar 21, 2019 at 08:49:38AM +1100, Dave Chinner wrote:
> On Wed, Mar 20, 2019 at 01:59:22PM -0400, Brian Foster wrote:
> > On Wed, Mar 20, 2019 at 10:45:51AM -0700, Darrick J. Wong wrote:
> > > On Wed, Mar 20, 2019 at 01:03:05PM -0400, Brian Foster wrote:
> > > > On Tue, Mar 19, 2019 at 10:04:08PM -0700, Darrick J. Wong wrote:
> > > > And unmount is doing a log force as well..
> > > > 
> > > > Hmm.. yeah, I think we need to figure out how/why the buffer is locked.
> > > 
> > > AFAICT it's xfs_inode_item_push -> xfs_iflush -> xfs_imap_to_bp that
> > > returns the locked cluster buffer (code extract from xfs_iflush):
> ....
> > > ...but if the buffer is also pinned then we kick the log (while holding
> > > the buffer lock) to unpin the buffer.  Since the fs is shutdown, the cil
> > > will just be trying to remove everything, but it needs to lock the
> > > buffer to simulate EIO.
> > > 
> > 
> > Yeah, makes sense.
> 
> Yup, and this same problem means any buffer we hold locked when we
> issue a blocking log force can deadlock in the same way. If it's a
> non-blocking log force (i.e. a log flush we don't wait for) then we
> can move onwards and eventually we unlock the buffer and the log can
> make progress.
> 
> > > A naive fix to the deadlock is to see if the inode buf ops are attached
> > > and downgrade to a trylock and go ahead even if we can't lock it, but ick.
> > > It resolves the deadlock so the umount can proceed but we also trigger a
> > > lot of unlocked buffer asserts.
> 
> Yuck!
> 
> > > I'm not sure what "too long" means in that code chunk.  It was added to
> > > reduce stalls in pdflush, which these days I think translates to trying
> > > to reduce the amount of time reclaim can stall while flushing inodes...?
> 
> "too long" means that if there is no log pressure, it might be the
> next periodic log work that forces the log and unpins the buffer.
> i.e. it could be several seconds before the buffer gets unpinned.
> This is the same reason we have the log force in xfs_buf_lock() - if
> we have to wait for the next log force to unlock/unpin a stale
> buffer, we can stall for several seconds.
> 

Ok.. so it kind of looks to me that this particular instance of the log
force is a historical artifact of xfsaild. The latter used to use
separate ->trylock() and ->push() log item callbacks where the former
would either lock the object or return LOCKED, PINNED, etc. So a pinned
buffer or inode would return pinned here and xfsaild does the log force
on its behalf once it's through the current cycle.

An unpinned inode with a pinned cluster buffer didn't communicate this
state because the inode ->trylock() callout grabbed the ilock and iflock
and returned success. The iflush doesn't occur until ->push(), which
means if the cluster buffer is pinned and we wanted to force the log
than xfs_iflush() is the last chance to do it.

(For reference, I'm looking at the code as of v2.6.33).

The current xfsaild() log force logic is still tied to PINNED objects,
but it has additional logic to detect skipped buffers at delwri queue
submit time (i.e., due to being pinned) that should cover the pinned
inode cluster buffer case.

> > I'm not sure either. I was wondering why we'd need that given that
> > xfsaild() has its own log force logic in cases where the delwri submit
> > didn't fully complete (i.e., for pinned buffers). Relying on that seems
> > more appropriate since we'd force the log per delwri submission for
> > multiple potential buffers as opposed to per inode cluster buffer.
> > Perhaps we could just kill this log force?
> 
> If the writeback is coming from the AIL, then we could check if the
> buffer is pinned and then return EDEADLOCK or something like that to
> get the item push return value set to XFS_ITEM_PINNED, in which case
> the AIL will then do the log force that will unpin the object. This
> will happen after we have added the buffer to the AIL delwri list
> and unlocked the buffer, so everything should work just fine in that
> case. Similar for dquot flushing from the AIL.
> 

Sounds plausible, though I'd probably just lift the pinned check into
the inode item callout after the xfs_iflush() since it already has a
reference to the buffer.

But given the above, couldn't we just remove the log force from
xfs_iflush() and let the existing xfsaild_push() logic handle it? It
should detect any pinned buffers after the delwri queue submit and do
the log force. It might require a closer look at the existing logic to
ensure the log force is timely enough, but ISTM that the purpose of this
logic is cover this case. AFAICT nothing prevents the buffer from
becoming pinned again once it's added to the queue anyways, even if we
just forced the log. Hm?

Brian

> If the writeback is coming from inode reclaim, we've already
> guaranteed the inode is unpinned, so we'll never hit this case
> through there.
> 
> As for the busy extent code, I'll need to look at that much more
> closely to determine if there's a way around this....
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
