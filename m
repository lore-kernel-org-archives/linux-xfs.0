Return-Path: <SRS0=0zz6=4T=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEE3EC3F2D1
	for <linux-xfs@archiver.kernel.org>; Mon,  2 Mar 2020 23:25:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 96FE22173E
	for <linux-xfs@archiver.kernel.org>; Mon,  2 Mar 2020 23:25:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726785AbgCBXZe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 2 Mar 2020 18:25:34 -0500
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:50691 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726728AbgCBXZe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 2 Mar 2020 18:25:34 -0500
Received: from dread.disaster.area (pa49-195-202-68.pa.nsw.optusnet.com.au [49.195.202.68])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id DD47B7E9704;
        Tue,  3 Mar 2020 10:25:30 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1j8uRF-0004kJ-6F; Tue, 03 Mar 2020 10:25:29 +1100
Date:   Tue, 3 Mar 2020 10:25:29 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [RFC v5 PATCH 3/9] xfs: automatic relogging reservation
 management
Message-ID: <20200302232529.GN10776@dread.disaster.area>
References: <20200227134321.7238-1-bfoster@redhat.com>
 <20200227134321.7238-4-bfoster@redhat.com>
 <20200302030750.GH10776@dread.disaster.area>
 <20200302180650.GB10946@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200302180650.GB10946@bfoster>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=LYdCFQXi c=1 sm=1 tr=0
        a=mqTaRPt+QsUAtUurwE173Q==:117 a=mqTaRPt+QsUAtUurwE173Q==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=SS2py6AdgQ4A:10
        a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8 a=cMEe5PK96xiLAkGOkgYA:9
        a=OwyHi1tDngxE75CS:21 a=94A2Ehli9vbZLNFD:21 a=CjuIK1q_8ugA:10
        a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Mar 02, 2020 at 01:06:50PM -0500, Brian Foster wrote:
> On Mon, Mar 02, 2020 at 02:07:50PM +1100, Dave Chinner wrote:
> > On Thu, Feb 27, 2020 at 08:43:15AM -0500, Brian Foster wrote:
> > > Automatic item relogging will occur from xfsaild context. xfsaild
> > > cannot acquire log reservation itself because it is also responsible
> > > for writeback and thus making used log reservation available again.
> > > Since there is no guarantee log reservation is available by the time
> > > a relogged item reaches the AIL, this is prone to deadlock.

.....

> > > @@ -284,15 +289,25 @@ xfs_trans_alloc(
> > >  	tp->t_firstblock = NULLFSBLOCK;
> > >  
> > >  	error = xfs_trans_reserve(tp, resp, blocks, rtextents);
> > > -	if (error) {
> > > -		xfs_trans_cancel(tp);
> > > -		return error;
> > > +	if (error)
> > > +		goto error;
> > > +
> > > +	if (flags & XFS_TRANS_RELOG) {
> > > +		error = xfs_trans_ail_relog_reserve(&tp);
> > > +		if (error)
> > > +			goto error;
> > >  	}
> > 
> > Hmmmm. So we are putting the AIL lock directly into the transaction
> > reserve path? xfs_trans_reserve() goes out of it's way to be
> > lockless in the fast paths, so if you want this to be a generic
> > mechanism that any transaction can use, the reservation needs to be
> > completely lockless.
> > 
> 
> Yeah, this is one of those warts mentioned in the cover letter. I wasn't
> planning to make it lockless as much as using an independent lock, but I
> can take a closer look at that if it still looks like a contention point
> after getting through the bigger picture feedback..

If relogging ends up getting widely used, then a filesystem global
lock in the transaction reserve path is guaranteed to be a
contention point. :)

> > > +	/* release the relog ticket reference if this transaction holds one */
> > > +	if (tp->t_flags & XFS_TRANS_RELOG)
> > > +		xfs_trans_ail_relog_put(mp);
> > > +
> > 
> > That looks ... interesting. xfs_trans_ail_relog_put() can call
> > xfs_log_done(), which means it can do a log write, which means the
> > commit lsn for this transaction could change. Hence to make a relog
> > permanent as a result of a sync transaction, we'd need the
> > commit_lsn of the AIL relog ticket write here, not that of the
> > original transaction that was written.
> > 
> 
> Hmm.. xfs_log_done() is eventually called for every transaction ticket,
> so I don't think it should be doing log writes based on that.

  xfs_log_done()
    xlog_commit_record()
      xlog_write(XLOG_COMMIT_TRANS)
        xlog_state_release_iclog()
	  xlog_sync()
	    xlog_write_iclog()
	      submit_bio()
>
> The
> _ail_relog_put() path is basically just intended to properly terminate
> the relog ticket based on the existing transaction completion path. I'd
> have to dig a bit further into the code here, but e.g. we don't pass an
> iclog via this path so if we were attempting to write I'd probably have
> seen assert failures (or worse) by now.

xlog_write() code handles a missing commit iclog pointer just fine.
Indeed, that's the reason xlog_write() may issue log IO itself:

....
        spin_lock(&log->l_icloglock);
        xlog_state_finish_copy(log, iclog, record_cnt, data_cnt);
        if (commit_iclog) {
                ASSERT(flags & XLOG_COMMIT_TRANS);
                *commit_iclog = iclog;
        } else {
                error = xlog_state_release_iclog(log, iclog);
        }
        spin_unlock(&log->l_icloglock);

i.e. if you don't provide xlog_write with a commit_iclog pointer
then you are saying "caller does not call xfs_log_release_iclog()
itself, so please release the iclog once the log iovec has been
written to the iclog. Hence the way you've written this code
explicitly tells xlog_write() to issue log IO on you behalf if it is
necessary....

> Indeed, this is similar to a
> cancel of a clean transaction, the difference being this is open-coded
> because we only have the relog ticket in this context.

A clean transaction has XLOG_TIC_INITED set, so xfs_log_done() will
never call xlog_commit_record() on it. XLOG_TIC_INITED is used to
indicate a start record has been written to the log for a permanent
transaction so it doesn't get written again when it is relogged.....

.... Hmmmm .....

You might be right.

It looks like delayed logging made XLOG_TIC_INITED completely
redundant. xfs_trans_commit() no longer writes directly to iclogs,
so the normal transaction tickets will never have XLOG_TIC_INITED
cleared. Hence on any kernel since delayed logging was the only
option, we will never get log writes from the xfs_trans* interfaces.

And we no longer do an xlog_write() call for every item in the
transaction after we format them into a log iovec. Instead, the CIL
just passes one big list of iovecs to a singel xlog_write() call,
so all callers only make a single xlog_write call per physical log
transaction.

OK, XLOG_TIC_INITED is redundant, and should be removed. And
xfs_log_done() needs to be split into two, one for releasing the
ticket, one for completing the xlog_write() call. Compile tested
only patch below for you :P

> > <GRRRRIIINNNNDDDD>
> > 
> > <CLUNK>
> > 
> > Ahhhhh.
> > 
> 
> Heh. :P
> 
> > This is the reason why the CIL ended up using a reservation stealing
> > mechanism for it's ticket. Every log reservation takes into account
> > the worst case log overhead for that single transaction - that means
> > there are no special up front hooks or changes to the log
> > reservation to support the CIL, and it also means that the CIL can
> > steal what it needs from the current ticket at commit time. Then the
> > CIL can commit at any time, knowing it has enough space to write all
> > the items it tracks to the log.
> > 
> > This avoided the transaction reservation mechanism from needing to
> > know anything about the CIL or that it was stealing space from
> > committing transactions for it's own private ticket. It greatly
> > simplified everything, and it's the reason that the CIL succeeded
> > where several other attempts to relog items in memory failed....
> > 
> > So....
> > 
> > Why can't the AIL steal the reservation it needs from the current
> > transaction when the item that needs relogging is being committed?
> 
> I think we can. My first proposal[1] implemented something like this.
> The broader design was much less fleshed out, so it was crudely
> implemented as more of a commit time hook to relog pending items based
> on the currently committing transaction as opposed to reservation
> stealing for an independent relog ticket. This was actually based on the
> observation that the CIL already did something similar (though I didn't
> have all of the background as to why that approach was used for the
> CIL).
> 
> The feedback at the time was to consider moving in a different direction
> that didn't involve stealing reservation from transactions, which gave
> me the impression that approach wasn't going to be acceptable. Granted,

I don't recall that discussion steering away from stealing
reservations; it was more about mechanics like using transaction
callbacks and other possible mechanisms for enabling relogging.

> the first few variations of this were widely different in approach and I
> don't think there was any explicit objection to reservation stealing
> itself, it just seemed a better development approach to work out an
> ideal design based on fundamentals as opposed to limiting the scope to
> contexts that might facilitate reservation stealing.

Right, it wasn't clear how to best implement this at the time,
because we were all just struggling to get our heads around the
problem scope. :)

> Despite the fact
> that this code is hairy, the fundamental approach is rather
> straightforward and simplistic. The hairiness mostly comes from
> attempting to make things generic and dynamic and could certainly use
> some cleanup.
> 
> Now that this is at a point where I'm reasonably confident it is
> fundamentally correct, I'm quite happy to revisit a reservation stealing
> approach if that improves functional operation. This can serve a decent
> reference/baseline implementation for that, I think.

*nod*

> 
> [1] https://lore.kernel.org/linux-xfs/20191024172850.7698-1-bfoster@redhat.com/
> 
> > i.e. we add the "relog overhead" to the permanent transaction that
> > requires items to be relogged by the AIL, and when that item is
> > formatted into the CIL we also check to see if it is currently
> > marked as "reloggable". If it's not, we steal the relogging
> > reservation from the transaction (essentially the item's formatted
> > size) and pass it to the AIL's private relog ticket, setting the log
> > item to be "reloggable" so the reservation isn't stolen over and
> > over again as the object is relogged in the CIL.
> > 
> 
> Ok, so this implies to me we'd update the per-transaction reservation
> calculations to incorporate worst case relog overhead for each
> transaction. E.g., the quotaoff transaction would x2 the intent size,
> a transaction that might relog a buffer adds a max buffer size overhead,
> etc. Right?

Essentially, yes.

And the reloggable items and reservation can be clearly documented
in the per-transaction reservation explanation comments like we
already do for all the structures that are modified in a
transaction.

> > Hence as we commit reloggable items to the CIL, the AIL ticket
> > reservation grows with each of those items marked as reloggable.
> > As we relog items to the CIL and the CIL grows it's reservation via
> > the size delta, the AIL reservation can also be updated with the
> > same delta.
> > 
> > Hence the AIL will always know exactly how much space it needs to relog all
> > the items it holds for relogging, and because it's been stolen from
> > the original transaction it is, like the CIL tciket reservation,
> > considered used space in the log. Hence the log space required for
> > relogging items via the AIL is correctly accounted for without
> > needing up front static, per-item reservations.
> > 
> 
> By this I assume you're referring to avoiding the need to reserve ->
> donate -> roll in the current scheme. Instead, we'd acquire the larger
> reservation up front and only steal if it necessary, which is less
> overhead because we don't need to always replenish the full transaction.

Yes - we acquire the initial relog reservation by stealing it
from the current transaction. This gives the AIL ticket the reserved
space (both reserve and write grant space) it needs to relog the
item once.

When the item is relogged by the AIL, the transaction commit
immediately regrants the reservation space that was just consumed,
and the trans_roll regrants the write grant space the commit just
consumed from the ticket via it's call to xfs_trans_reserve(). Hence
we only need to steal the space necessary to do the first relogging
of the item as the AIL will hold that reservation until the high
level code turns off relogging for that log item.

> > Thoughts?
> 
> <thinking out loud from here on..>
> 
> One thing that comes to mind thinking about this is dealing with
> batching (relog multiple items per roll). This code doesn't handle that
> yet, but I anticipate it being a requirement and it's fairly easy to
> update the current scheme to support a fixed item count per relog-roll.
> 
> A stealing approach potentially complicates things when it comes to
> batching because we have per-item reservation granularity to consider.
> For example, consider if we had a variety of different relog item types
> active at once, a subset are being relogged while another subset are
> being disabled (before ever needing to be relogged).

So concurrent "active relogging" + "start relogging" + "stop
relogging"?

> For one, we'd have
> to be careful to not release reservation while it might be accounted to
> an active relog transaction that is currently rolling with some other
> items, etc. There's also a potential quirk in handling reservation of a
> relogged item that is cancelled while it's being relogged, but that
> might be more of an implementation detail.

Right, did you notice the ail->ail_relog_lock rwsem that I wrapped
my example relog transaction item add loop + commit function in?

i.e. while we are building and committing a relog transaction, we
hold off the transactions that are trying to add/remove their items
to/from the relog list. Hence the reservation stealing accounting in
the ticket can be be serialised against the transactional use of the
ticket.

It's basically the same method we use for serialising addition to
the CIL in transaction commit against CIL pushes draining the
current list for log writes (rwsem for add/push serialisation, spin
lock for concurrent add serialisation under the rwsem).

> I don't think that's a show stopper, but rather just something I'd like
> to have factored into the design from the start. One option could be to

*nod*

> maintain a separate counter of active relog reservation aside from the
> actual relog ticket. That way the relog ticket could just pull from this
> relog reservation pool based on the current item(s) being relogged
> asynchronously from different tasks that might add or remove reservation
> from the pool for separate items. That might get a little wonky when we
> consider the relog ticket needs to pull from the pool and then put
> something back if the item is still reloggable after the relog
> transaction rolls.

RIght, that's the whole problem that we solve via a) stealing the
initial reserve/write grant space at commit time and b) serialising
stealing vs transactional use of the ticket.

That is, after the roll, the ticket has a full reserve and grant
space reservation for all the items accounted to the relog ticket.
Every new relog item added to the ticket (or is relogged in the CIL
and uses more space) adds the full required reserve/write grant
space to the the relog ticket. Hence the relog ticket always has
current log space reserved to commit the entire set of items tagged
as reloggable. And by avoiding modifying the ticket while we are
actively processing the relog transaction, we don't screw up the
ticket accounting in the middle of the transaction....

> Another problem is that reloggable items are still otherwise usable once
> they are unlocked. So for example we'd have to account for a situation
> where one transaction dirties a buffer, enables relogging, commits and
> then some other transaction dirties more of the buffer and commits
> without caring whether the buffer was relog enabled or not.

yup, that's the delta size updates from the CIL commit. i.e. if we
relog an item to the CIL that has the XFS_LI_RELOG flag already set
on it, the change in size that we steal for the CIL ticket also
needs to be stolen for the AIL ticket. i.e. we already do almost all
the work we need to handle this.

> Unless
> runtime relog reservation is always worst case, that's a subtle path to
> reservation overrun in the relog transaction.

Yes, but it's a problem the CIL already solves for us :P

> I'm actually wondering if a more simple approach to tracking stolen
> reservation is to add a new field that tracks active relog reservation
> to each supported log item.  Then the initial transaction enables
> relogging with a simple transfer from the transaction to the item. The
> relog transaction knows how much reservation it can assign based on the
> current population of items and requires no further reservation
> accounting because it rolls and thus automatically reacquires relog
> reservation for each associated item. The path that clears relog state
> transfers res from the item back to a transaction simply so the
> reservation can be released back to the pool of unused log space. Note
> that clearing relog state doesn't require a transaction in the current
> implementation, but we could easily define a helper to allocate an empty
> transaction, clear relog and reclaim relog reservation and then cancel
> for those contexts.

I don't think we need any of that - the AIL ticket only needs to be
kept up to date with the changes to the formatted size of the item
marked for relogging. It's no different to the CIL ticket
reservation accounting from that perspective.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
