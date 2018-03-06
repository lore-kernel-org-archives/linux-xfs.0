Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43848 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750897AbeCFMb5 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 6 Mar 2018 07:31:57 -0500
Date: Tue, 6 Mar 2018 07:31:56 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs: handle inconsistent log item formatting state
 correctly
Message-ID: <20180306123155.GB10982@bfoster.bfoster>
References: <20180301223527.28626-1-david@fromorbit.com>
 <20180305144001.GA6135@bfoster.bfoster>
 <20180305221857.GF18129@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180305221857.GF18129@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Mar 06, 2018 at 09:18:57AM +1100, Dave Chinner wrote:
> On Mon, Mar 05, 2018 at 09:40:01AM -0500, Brian Foster wrote:
> > On Fri, Mar 02, 2018 at 09:35:27AM +1100, Dave Chinner wrote:
> > > From: Dave Chinner <dchinner@redhat.com>
> > > 
> > > Brian Foster reported an oops like:
> > > 
> > > BUG: unable to handle kernel NULL pointer dereference at 0000000000000008
> > > IP: xlog_cil_push+0x184/0x400 [xfs]
> > > ....
> > > Workqueue: xfs-cil/dm-3 xlog_cil_push_work [xfs]
> > > RIP: 0010:xlog_cil_push+0x184/0x400 [xfs]
> > > ....
> > > 
> > > This was caused by the log item size calculation return that there
> > > were no log vectors to write on a normal buffer. This should only
> > > occur for ordered buffers - the exception handling had never been
> > > executed for a non-ordered buffer. This mean we ended up with
> > > a log item marked dirty (XFS_LID_DIRTY) but with no log vectors
> > > attached that got added to the CIL. When the CIL was pushed, it
> > > tripped over the null log vector on the dirty log item when trying
> > > to chain the log vectors that needed to be written to the log.
> > > 
> > > Fix this by clearing the XFS_LID_DIRTY flag on the log item if
> > > nothing gets formatted. This will prevent the log item from being
> > > added incorrectly to the CIL, and hence avoid the crash
> > > 
> > > Reported-by: Brian Foster <bfoster@redhat.com>
> > > Signed-Off-By: Dave Chinner <dchinner@redhat.com>
> > > ---
> > 
> > Refamiliarizing myself with the problem... we commit a dirty buffer
> > without any logged ranges, the commit time code manages to skip through
> > the formatting and whatnot, yet still inserts the item because it is
> > dirty. A push occurs sometime later and expects to find a log vector,
> > but runs into a NULL deref because the associated item wasn't prepared.
> > 
> > >  fs/xfs/xfs_log_cil.c | 27 ++++++++++++++++++++-------
> > >  1 file changed, 20 insertions(+), 7 deletions(-)
> > > 
> > > diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> > > index 61ab5c0a4c45..c1ecd7698100 100644
> > > --- a/fs/xfs/xfs_log_cil.c
> > > +++ b/fs/xfs/xfs_log_cil.c
> > > @@ -345,9 +345,16 @@ xlog_cil_insert_format_items(
> > >  		if (shadow->lv_buf_len == XFS_LOG_VEC_ORDERED)
> > >  			ordered = true;
> > >  
> > > -		/* Skip items that do not have any vectors for writing */
> > > -		if (!shadow->lv_niovecs && !ordered)
> > > +		/*
> > > +		 * Skip items that do not have any vectors for writing. These
> > > +		 * log items must now be considered clean in this transaction,
> > > +		 * so clear the XFS_LID_DIRTY flag to ensure it doesn't get
> > > +		 * added to the CIL by mistake.
> > > +		 */
> > > +		if (!shadow->lv_niovecs && !ordered) {
> > > +			lidp->lid_flags &= ~XFS_LID_DIRTY;
> > >  			continue;
> > > +		}
> > 
> > So to address the problem, we clear the dirty bit at format time and
> > thus prevent it from being added to the CIL. That looks effective to me
> > wrt to avoiding the crash, but I'm not sure it sufficiently addresses
> > the root problem of not logging a dirty item...
> 
> I don't think there's a problem we need to solve with clean objects
> that are marked dirty in the transaction.  I'm just fixing an
> obvious (now) logic bug in the original code that did not handle
> objects that were incorrectly marked dirty safely.
> 
> > Hitting this state in this context means the transaction either set the
> > dirty state incorrectly or failed to log any data for an item that was
> > legitimately dirty (the latter being the variant we actually hit via the
> > buffer dirty range tracking patch). If we do nothing else here (but not
> > crash), what state have we left the filesystem in?
> 
> A perfectly fine state. It's no different to having a clean object
> attached to a transaction, and having the transaction commit release
> it.
> 

We don't allocate log vectors for items that aren't dirty in the
transaction, we disallow release of buffers that are dirty in
transactions and AFAICT anywhere we set LID_DIRTY on a lidp we also
dirty the associated transaction, which means we shut down if the
transaction cancels.

> > We've presumably
> > modified the buffer,
> 
> Not according to the log item, which says there is nothing to write
> to the log. It's clean, so treat it that way.
> 

Pretty much any code I refer to suggests XFS_LID_DIRTY is indicative of
a modified object.

> > but will it ever be written back (unless some other
> > transaction modifies/commits it) if it doesn't make it to the AIL? ISTM
> > that this is a corruption vector with at least a couple different
> > interesting paths (e.g. unmount losing data or a crash -> log recovery
> > inconsistency).
> > 
> > Unless I'm mistaken in the above, I think we need to be a bit more
> > aggressive in handling this condition. We could obviously assert/warn,
> > but IMO a shutdown is appropriate given that we may have to assume that
> > clearing the dirty state made the fs inconsistent (and we already
> > shutdown for slightly more innocuous things, like tx overrun, in
> > comparison). The problem is that we need to make sure the current
> > transaction is not partially committed so we don't actually corrupt the
> > fs by shutting down, which leads to one last thought...
> > 
> > AFAICT the transaction commit path expects to handle items that are
> > either not dirty or otherwise must be logged. It looks like the earliest
> > we identify this problem is xlog_cil_alloc_shadow_bufs() after we've
> > called ->iop_size(). Any reason we couldn't handle this problem there?
> 
> Because that code can validly be passed a dirty object that ends up
> with no logged regions. IMO, shadow buffer allocation is the wrong
> place to be determining if a dirty item needs to be added to the CIL
> or not - that's the job of the formatting code....
> 

I don't think the lidp dirty state necessarily means an item has logged
regions or not (and so lack of dirty regions doesn't necessarily justify
clearing the dirty flag). We still log for an invalidated buffer, for
example, and/or an item may have been dirtied by a previous transaction
and end up clean in a subsequent one.

FWIW, I think it would make sense to handle this case at format time if
it were a valid state, not so much if it isn't. I'm simply not following
how it is a valid state. AFAICT we have the following valid states at
transaction commit time:

- lid not dirty, lip state is a 'don't care'
- lid dirty, lip ordered, niovecs == 0
- lid dirty, lip !ordered, niovecs != 0

... and anything else is essentially a bug. Am I missing some other
case?

> > There's no reason to allocate a vector we already know we aren't going
> > to use (and that is clearly based on invalid parameters), after all.
> 
> Such objects still need a log vector attached to them so they can be
> processed through the CIL and entered into the AIL via the log
> vector chain.
> 

Confused. This patch prevents that from happening on such objects (which
you just noted above wrt to the appropriate place to determine whether
to insert into the CIL). Hm?

Brian

> > Given both of the above, a clean way to handle the error may be to allow
> > the lv allocation code to return an error up through xfs_trans_commit()
> > and let the caller abort the transaction, since we haven't committed any
> > part of it at that point. Thoughts?
> 
> I don't think there's any problem at all with marking an object that
> is dirty in a transaction but otherwise unmodified as "clean" in the
> transaction and treating it as a clean object....
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
