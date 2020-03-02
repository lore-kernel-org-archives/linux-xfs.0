Return-Path: <SRS0=0zz6=4T=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DB85C3F2D1
	for <linux-xfs@archiver.kernel.org>; Mon,  2 Mar 2020 18:07:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E6E7422B48
	for <linux-xfs@archiver.kernel.org>; Mon,  2 Mar 2020 18:07:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BckTn6xH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727093AbgCBSHC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 2 Mar 2020 13:07:02 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:40279 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726451AbgCBSHC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 2 Mar 2020 13:07:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583172419;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=H+yNBeC4I9sSK9EkhWfcz0n1zKJKLazNxQgQbBiuoeQ=;
        b=BckTn6xHGI16Xzoa6mkCnM/M1lXS6HZ+Fuws2O+iwQ5Rzmrnb+Dpyfy0dnXPAtMuRPXGH6
        fN64owK8hqoLtpFZES7W1SANQC9+X736xSzr0cR7+wqceqhK/okalTSl67gyW/uCjNoHO8
        vNGh/scSZJg8NCRb1YBCvQdot19of28=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-301-Pr8dUzzUOQaETZBBfq_k0w-1; Mon, 02 Mar 2020 13:06:54 -0500
X-MC-Unique: Pr8dUzzUOQaETZBBfq_k0w-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 39573189F765;
        Mon,  2 Mar 2020 18:06:53 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 87BAF60BF3;
        Mon,  2 Mar 2020 18:06:52 +0000 (UTC)
Date:   Mon, 2 Mar 2020 13:06:50 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [RFC v5 PATCH 3/9] xfs: automatic relogging reservation
 management
Message-ID: <20200302180650.GB10946@bfoster>
References: <20200227134321.7238-1-bfoster@redhat.com>
 <20200227134321.7238-4-bfoster@redhat.com>
 <20200302030750.GH10776@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200302030750.GH10776@dread.disaster.area>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Mar 02, 2020 at 02:07:50PM +1100, Dave Chinner wrote:
> On Thu, Feb 27, 2020 at 08:43:15AM -0500, Brian Foster wrote:
> > Automatic item relogging will occur from xfsaild context. xfsaild
> > cannot acquire log reservation itself because it is also responsible
> > for writeback and thus making used log reservation available again.
> > Since there is no guarantee log reservation is available by the time
> > a relogged item reaches the AIL, this is prone to deadlock.
> > 
> > To guarantee log reservation for automatic relogging, implement a
> > reservation management scheme where a transaction that is capable of
> > enabling relogging of an item must contribute the necessary
> > reservation to the relog mechanism up front. Use reference counting
> > to associate the lifetime of pending relog reservation to the
> > lifetime of in-core log items with relogging enabled.
> > 
> > The basic log reservation sequence for a relog enabled transaction
> > is as follows:
> > 
> > - A transaction that uses relogging specifies XFS_TRANS_RELOG at
> >   allocation time.
> > - Once initialized, RELOG transactions check for the existence of
> >   the global relog log ticket. If it exists, grab a reference and
> >   return. If not, allocate an empty ticket and install into the relog
> >   subsystem. Seed the relog ticket from reservation of the current
> >   transaction. Roll the current transaction to replenish its
> >   reservation and return to the caller.
> > - The transaction is used as normal. If an item is relogged in the
> >   transaction, that item acquires a reference on the global relog
> >   ticket currently held open by the transaction. The item's reference
> >   persists until relogging is disabled on the item.
> > - The RELOG transaction commits and releases its reference to the
> >   global relog ticket. The global relog ticket is released once its
> >   reference count drops to zero.
> > 
> > This provides a central relog log ticket that guarantees reservation
> > availability for relogged items, avoids log reservation deadlocks
> > and is allocated and released on demand.
> 
> Hi Brain,
> 
> I've held off commenting immediately on this while I tried to get
> the concept of dynamic relogging straight in my head. I couldn't put
> my finger on what I thought was wrong - just a nagging feeling that
> I'd gone down this path before and it ended in somethign that didn't
> work.
> 

No problem..

> It wasn't until a couple of hours ago that a big cogs clunked into
> place and I realised this roughly mirrored a path I went down 12 or
> 13 years ago trying to implement what turned into the CIL. I failed
> at least 4 times over 5 years trying to implement delayed logging...
> 
> THere's a couple of simple code comments below before what was in my
> head seemed to gel together into something slightly more coherent
> than "it seems inside out"....
> 
> > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > ---
> >  fs/xfs/libxfs/xfs_shared.h |  1 +
> >  fs/xfs/xfs_trans.c         | 37 +++++++++++++---
> >  fs/xfs/xfs_trans.h         |  3 ++
> >  fs/xfs/xfs_trans_ail.c     | 89 ++++++++++++++++++++++++++++++++++++++
> >  fs/xfs/xfs_trans_priv.h    |  1 +
> >  5 files changed, 126 insertions(+), 5 deletions(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_shared.h b/fs/xfs/libxfs/xfs_shared.h
> > index c45acbd3add9..0a10ca0853ab 100644
> > --- a/fs/xfs/libxfs/xfs_shared.h
> > +++ b/fs/xfs/libxfs/xfs_shared.h
> > @@ -77,6 +77,7 @@ void	xfs_log_get_max_trans_res(struct xfs_mount *mp,
> >   * made then this algorithm will eventually find all the space it needs.
> >   */
> >  #define XFS_TRANS_LOWMODE	0x100	/* allocate in low space mode */
> > +#define XFS_TRANS_RELOG		0x200	/* enable automatic relogging */
> >  
> >  /*
> >   * Field values for xfs_trans_mod_sb.
> > diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> > index 3b208f9a865c..8ac05ed8deda 100644
> > --- a/fs/xfs/xfs_trans.c
> > +++ b/fs/xfs/xfs_trans.c
> > @@ -107,9 +107,14 @@ xfs_trans_dup(
> >  
> >  	ntp->t_flags = XFS_TRANS_PERM_LOG_RES |
> >  		       (tp->t_flags & XFS_TRANS_RESERVE) |
> > -		       (tp->t_flags & XFS_TRANS_NO_WRITECOUNT);
> > -	/* We gave our writer reference to the new transaction */
> > +		       (tp->t_flags & XFS_TRANS_NO_WRITECOUNT) |
> > +		       (tp->t_flags & XFS_TRANS_RELOG);
> > +	/*
> > +	 * The writer reference and relog reference transfer to the new
> > +	 * transaction.
> > +	 */
> >  	tp->t_flags |= XFS_TRANS_NO_WRITECOUNT;
> > +	tp->t_flags &= ~XFS_TRANS_RELOG;
> >  	ntp->t_ticket = xfs_log_ticket_get(tp->t_ticket);
> >  
> >  	ASSERT(tp->t_blk_res >= tp->t_blk_res_used);
> > @@ -284,15 +289,25 @@ xfs_trans_alloc(
> >  	tp->t_firstblock = NULLFSBLOCK;
> >  
> >  	error = xfs_trans_reserve(tp, resp, blocks, rtextents);
> > -	if (error) {
> > -		xfs_trans_cancel(tp);
> > -		return error;
> > +	if (error)
> > +		goto error;
> > +
> > +	if (flags & XFS_TRANS_RELOG) {
> > +		error = xfs_trans_ail_relog_reserve(&tp);
> > +		if (error)
> > +			goto error;
> >  	}
> 
> Hmmmm. So we are putting the AIL lock directly into the transaction
> reserve path? xfs_trans_reserve() goes out of it's way to be
> lockless in the fast paths, so if you want this to be a generic
> mechanism that any transaction can use, the reservation needs to be
> completely lockless.
> 

Yeah, this is one of those warts mentioned in the cover letter. I wasn't
planning to make it lockless as much as using an independent lock, but I
can take a closer look at that if it still looks like a contention point
after getting through the bigger picture feedback..

> >  
> >  	trace_xfs_trans_alloc(tp, _RET_IP_);
> >  
> >  	*tpp = tp;
> >  	return 0;
> > +
> > +error:
> > +	/* clear relog flag if we haven't acquired a ref */
> > +	tp->t_flags &= ~XFS_TRANS_RELOG;
> > +	xfs_trans_cancel(tp);
> > +	return error;
> 
> seems like a case of "only set the flags once you have a reference"?
> Then xfs_trans_cancel() can clean up without special cases being
> needed anywhere...
> 

Yeah, I suppose that might be a bit more readable.

> >  }
> >  
> >  /*
> > @@ -973,6 +988,10 @@ __xfs_trans_commit(
> >  
> >  	xfs_log_commit_cil(mp, tp, &commit_lsn, regrant);
> >  
> > +	/* release the relog ticket reference if this transaction holds one */
> > +	if (tp->t_flags & XFS_TRANS_RELOG)
> > +		xfs_trans_ail_relog_put(mp);
> > +
> 
> That looks ... interesting. xfs_trans_ail_relog_put() can call
> xfs_log_done(), which means it can do a log write, which means the
> commit lsn for this transaction could change. Hence to make a relog
> permanent as a result of a sync transaction, we'd need the
> commit_lsn of the AIL relog ticket write here, not that of the
> original transaction that was written.
> 

Hmm.. xfs_log_done() is eventually called for every transaction ticket,
so I don't think it should be doing log writes based on that. The
_ail_relog_put() path is basically just intended to properly terminate
the relog ticket based on the existing transaction completion path. I'd
have to dig a bit further into the code here, but e.g. we don't pass an
iclog via this path so if we were attempting to write I'd probably have
seen assert failures (or worse) by now. Indeed, this is similar to a
cancel of a clean transaction, the difference being this is open-coded
because we only have the relog ticket in this context.

> 
> >  	current_restore_flags_nested(&tp->t_pflags, PF_MEMALLOC_NOFS);
> >  	xfs_trans_free(tp);
> >  
> > @@ -1004,6 +1023,10 @@ __xfs_trans_commit(
> >  			error = -EIO;
> >  		tp->t_ticket = NULL;
> >  	}
> > +	/* release the relog ticket reference if this transaction holds one */
> > +	/* XXX: handle RELOG items on transaction abort */
> > +	if (tp->t_flags & XFS_TRANS_RELOG)
> > +		xfs_trans_ail_relog_put(mp);
> 
> This has the potential for log writes to be issued from a
> transaction abort context, right?
> 
> >  	current_restore_flags_nested(&tp->t_pflags, PF_MEMALLOC_NOFS);
> >  	xfs_trans_free_items(tp, !!error);
> >  	xfs_trans_free(tp);
> > @@ -1064,6 +1087,10 @@ xfs_trans_cancel(
> >  		tp->t_ticket = NULL;
> >  	}
> >  
> > +	/* release the relog ticket reference if this transaction holds one */
> > +	if (tp->t_flags & XFS_TRANS_RELOG)
> > +		xfs_trans_ail_relog_put(mp);
> 
> And log writes from a cancel seems possible here, too. I don't think
> we do this at all right now, so this could have some interesting
> unexpected side-effects during error handling. (As if that wasn't
> complex enough to begin with!)
> 

I'm not quite sure I follow your comments here, though I do still need
to work through all of the error paths and make sure everything is
correct. I've been putting details like that off in favor of getting a
high level design approach worked out first.

> > @@ -818,6 +819,93 @@ xfs_trans_ail_delete(
> >  		xfs_log_space_wake(ailp->ail_mount);
> >  }
> >  
> > +bool
> > +xfs_trans_ail_relog_get(
> > +	struct xfs_mount	*mp)
> > +{
> > +	struct xfs_ail		*ailp = mp->m_ail;
> > +	bool			ret = false;
> > +
> > +	spin_lock(&ailp->ail_lock);
> > +	if (ailp->ail_relog_tic) {
> > +		xfs_log_ticket_get(ailp->ail_relog_tic);
> > +		ret = true;
> > +	}
> > +	spin_unlock(&ailp->ail_lock);
> > +	return ret;
> > +}
> > +
> > +/*
> > + * Reserve log space for the automatic relogging ->tr_relog ticket. This
> > + * requires a clean, permanent transaction from the caller. Pull reservation
> > + * for the relog ticket and roll the caller's transaction back to its fully
> > + * reserved state. If the AIL relog ticket is already initialized, grab a
> > + * reference and return.
> > + */
> > +int
> > +xfs_trans_ail_relog_reserve(
> > +	struct xfs_trans	**tpp)
> > +{
> > +	struct xfs_trans	*tp = *tpp;
> > +	struct xfs_mount	*mp = tp->t_mountp;
> > +	struct xfs_ail		*ailp = mp->m_ail;
> > +	struct xlog_ticket	*tic;
> > +	uint32_t		logres = M_RES(mp)->tr_relog.tr_logres;
> > +
> > +	ASSERT(tp->t_flags & XFS_TRANS_PERM_LOG_RES);
> > +	ASSERT(!(tp->t_flags & XFS_TRANS_DIRTY));
> > +
> > +	if (xfs_trans_ail_relog_get(mp))
> > +		return 0;
> > +
> > +	/* no active ticket, fall into slow path to allocate one.. */
> > +	tic = xlog_ticket_alloc(mp->m_log, logres, 1, XFS_TRANSACTION, true, 0);
> > +	if (!tic)
> > +		return -ENOMEM;
> > +	ASSERT(tp->t_ticket->t_curr_res >= tic->t_curr_res);
> > +
> > +	/* check again since we dropped the lock for the allocation */
> > +	spin_lock(&ailp->ail_lock);
> > +	if (ailp->ail_relog_tic) {
> > +		xfs_log_ticket_get(ailp->ail_relog_tic);
> > +		spin_unlock(&ailp->ail_lock);
> > +		xfs_log_ticket_put(tic);
> > +		return 0;
> > +	}
> > +
> > +	/* attach and reserve space for the ->tr_relog ticket */
> > +	ailp->ail_relog_tic = tic;
> > +	tp->t_ticket->t_curr_res -= tic->t_curr_res;
> > +	spin_unlock(&ailp->ail_lock);
> > +
> > +	return xfs_trans_roll(tpp);
> > +}
> 
> Hmmm.
> 
> So before we've even returned from xfs_trans_alloc(), we may have
> committed the transaction and burnt and entire transaction entire
> log space reservations?
> 

Yep.

> IOWs, to support relogging of a single item in a permanent
> transaction, we have to increase the log count of the transaction so
> that we don't end up running out of reservation space one
> transaction before the end of the normal fast path behaviour of the
> change being made?
> 

Right.

> And we do that up front because we're not exactly sure of how much
> space the item that needs relogging is going to require, but the AIL
> is going to need to hold on to it from as long as it needs to relog
> the item.
> 

*nod*

> <GRRRRIIINNNNDDDD>
> 
> <CLUNK>
> 
> Ahhhhh.
> 

Heh. :P

> This is the reason why the CIL ended up using a reservation stealing
> mechanism for it's ticket. Every log reservation takes into account
> the worst case log overhead for that single transaction - that means
> there are no special up front hooks or changes to the log
> reservation to support the CIL, and it also means that the CIL can
> steal what it needs from the current ticket at commit time. Then the
> CIL can commit at any time, knowing it has enough space to write all
> the items it tracks to the log.
> 
> This avoided the transaction reservation mechanism from needing to
> know anything about the CIL or that it was stealing space from
> committing transactions for it's own private ticket. It greatly
> simplified everything, and it's the reason that the CIL succeeded
> where several other attempts to relog items in memory failed....
> 
> So....
> 
> Why can't the AIL steal the reservation it needs from the current
> transaction when the item that needs relogging is being committed?

I think we can. My first proposal[1] implemented something like this.
The broader design was much less fleshed out, so it was crudely
implemented as more of a commit time hook to relog pending items based
on the currently committing transaction as opposed to reservation
stealing for an independent relog ticket. This was actually based on the
observation that the CIL already did something similar (though I didn't
have all of the background as to why that approach was used for the
CIL).

The feedback at the time was to consider moving in a different direction
that didn't involve stealing reservation from transactions, which gave
me the impression that approach wasn't going to be acceptable. Granted,
the first few variations of this were widely different in approach and I
don't think there was any explicit objection to reservation stealing
itself, it just seemed a better development approach to work out an
ideal design based on fundamentals as opposed to limiting the scope to
contexts that might facilitate reservation stealing. Despite the fact
that this code is hairy, the fundamental approach is rather
straightforward and simplistic. The hairiness mostly comes from
attempting to make things generic and dynamic and could certainly use
some cleanup.

Now that this is at a point where I'm reasonably confident it is
fundamentally correct, I'm quite happy to revisit a reservation stealing
approach if that improves functional operation. This can serve a decent
reference/baseline implementation for that, I think.

[1] https://lore.kernel.org/linux-xfs/20191024172850.7698-1-bfoster@redhat.com/

> i.e. we add the "relog overhead" to the permanent transaction that
> requires items to be relogged by the AIL, and when that item is
> formatted into the CIL we also check to see if it is currently
> marked as "reloggable". If it's not, we steal the relogging
> reservation from the transaction (essentially the item's formatted
> size) and pass it to the AIL's private relog ticket, setting the log
> item to be "reloggable" so the reservation isn't stolen over and
> over again as the object is relogged in the CIL.
> 

Ok, so this implies to me we'd update the per-transaction reservation
calculations to incorporate worst case relog overhead for each
transaction. E.g., the quotaoff transaction would x2 the intent size,
a transaction that might relog a buffer adds a max buffer size overhead,
etc. Right?

> Hence as we commit reloggable items to the CIL, the AIL ticket
> reservation grows with each of those items marked as reloggable.
> As we relog items to the CIL and the CIL grows it's reservation via
> the size delta, the AIL reservation can also be updated with the
> same delta.
> 
> Hence the AIL will always know exactly how much space it needs to relog all
> the items it holds for relogging, and because it's been stolen from
> the original transaction it is, like the CIL tciket reservation,
> considered used space in the log. Hence the log space required for
> relogging items via the AIL is correctly accounted for without
> needing up front static, per-item reservations.
> 

By this I assume you're referring to avoiding the need to reserve ->
donate -> roll in the current scheme. Instead, we'd acquire the larger
reservation up front and only steal if it necessary, which is less
overhead because we don't need to always replenish the full transaction.

Do note that I don't consider the current approach high overhead overall
because the roll only needs to happen when (and if) the first
transaction enables the relog ticket. There is no additional overhead
from that point forward. The "relog overhead" approach sounds fine to me
as well, I'm just noting that there are still some tradeoffs to either
approach.

> When the item is logged the final time and the reloggable flag is
> removed (e.g. when the quotaoff completes) then we can remove the
> reservation from AIL ticket and add it back to the current
> transaction. Hence when the final transaction is committed and the
> ticket for that transaction is released via xfs_log_done(), the
> space the AIL held for relogging the item is also released.
> 

Makes sense.

> This doesn't require any modifications to the transaction
> reservation subsystem, nor the itransaction commit/cancel code,
> no changes to the log space accounting, etc. All we need to do is
> tag items when we log them as reloggable, and in the CIL formatting
> of the item pass the formatted size differences to the AIL so it can
> steal the reservation it needs.
> 
> Then the AIL doesn't need a dynamic relogging ticket. It can just
> hold a single ticket from init to teardown by taking an extra
> reference to the ticket. When it is running a relog, it can build it
> as though it's just a normal permanent transaction without needing
> to get a new reservation, and when it rolls the write space consumed
> is regranted automatically.
> 
> AFAICT, that gets rid of the need for all this ticket reference counting,
> null pointer checking, lock juggling and rechecking, etc. It does
> not require modification to the transaction reservation path, and we
> can account for the relogging on an item by item basis in each
> individual transaction reservation....
> 

Yep, I think there's potential for some nice cleanup there. I'd be very
happy to rip out some of guts of the current patch, particularly the
reference counting bits.

> Thoughts?
> 

<thinking out loud from here on..>

One thing that comes to mind thinking about this is dealing with
batching (relog multiple items per roll). This code doesn't handle that
yet, but I anticipate it being a requirement and it's fairly easy to
update the current scheme to support a fixed item count per relog-roll.

A stealing approach potentially complicates things when it comes to
batching because we have per-item reservation granularity to consider.
For example, consider if we had a variety of different relog item types
active at once, a subset are being relogged while another subset are
being disabled (before ever needing to be relogged). For one, we'd have
to be careful to not release reservation while it might be accounted to
an active relog transaction that is currently rolling with some other
items, etc. There's also a potential quirk in handling reservation of a
relogged item that is cancelled while it's being relogged, but that
might be more of an implementation detail.

I don't think that's a show stopper, but rather just something I'd like
to have factored into the design from the start. One option could be to
maintain a separate counter of active relog reservation aside from the
actual relog ticket. That way the relog ticket could just pull from this
relog reservation pool based on the current item(s) being relogged
asynchronously from different tasks that might add or remove reservation
from the pool for separate items. That might get a little wonky when we
consider the relog ticket needs to pull from the pool and then put
something back if the item is still reloggable after the relog
transaction rolls.

Another problem is that reloggable items are still otherwise usable once
they are unlocked. So for example we'd have to account for a situation
where one transaction dirties a buffer, enables relogging, commits and
then some other transaction dirties more of the buffer and commits
without caring whether the buffer was relog enabled or not. Unless
runtime relog reservation is always worst case, that's a subtle path to
reservation overrun in the relog transaction.

I'm actually wondering if a more simple approach to tracking stolen
reservation is to add a new field that tracks active relog reservation
to each supported log item. Then the initial transaction enables
relogging with a simple transfer from the transaction to the item. The
relog transaction knows how much reservation it can assign based on the
current population of items and requires no further reservation
accounting because it rolls and thus automatically reacquires relog
reservation for each associated item. The path that clears relog state
transfers res from the item back to a transaction simply so the
reservation can be released back to the pool of unused log space. Note
that clearing relog state doesn't require a transaction in the current
implementation, but we could easily define a helper to allocate an empty
transaction, clear relog and reclaim relog reservation and then cancel
for those contexts.

Thoughts on any of the above appreciated. I need to think about this
some more but otherwise I'll attempt some form of a res stealing
approach for the next iteration...

Brian

> -Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 

