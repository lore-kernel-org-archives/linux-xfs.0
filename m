Return-Path: <SRS0=TABv=4U=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBF10C3F2C6
	for <linux-xfs@archiver.kernel.org>; Tue,  3 Mar 2020 14:13:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9B64B20838
	for <linux-xfs@archiver.kernel.org>; Tue,  3 Mar 2020 14:13:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YM7g7KD3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727909AbgCCON0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 3 Mar 2020 09:13:26 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:21219 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725932AbgCCON0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 Mar 2020 09:13:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583244803;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=OJjzGtOnXnxCv9OyAae22p4IJ2klJ7cOdUo2gI6yYDo=;
        b=YM7g7KD3izgIQH1HeVMg2ZbDf9AguiyH7ZWKhVP1gWdhQUEnnK7Z90ehkeB0pmXsZtfdOa
        YEQ7sq2kPJnxbuENCAa+S0WNyOKv/z7kxn32jyQRJ91LxZcp0xSEHHvj11CexJ8k4Yv1OG
        /sML7KIb9Fr+wmoFygx4xwxi0DErQ5E=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-200-R1x1SdzuMVCab_rPJjY6wA-1; Tue, 03 Mar 2020 09:13:20 -0500
X-MC-Unique: R1x1SdzuMVCab_rPJjY6wA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 248B6101FC6B;
        Tue,  3 Mar 2020 14:13:19 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A1222272B4;
        Tue,  3 Mar 2020 14:13:18 +0000 (UTC)
Date:   Tue, 3 Mar 2020 09:13:16 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [RFC v5 PATCH 3/9] xfs: automatic relogging reservation
 management
Message-ID: <20200303141316.GA15955@bfoster>
References: <20200227134321.7238-1-bfoster@redhat.com>
 <20200227134321.7238-4-bfoster@redhat.com>
 <20200302030750.GH10776@dread.disaster.area>
 <20200302180650.GB10946@bfoster>
 <20200302232529.GN10776@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200302232529.GN10776@dread.disaster.area>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 03, 2020 at 10:25:29AM +1100, Dave Chinner wrote:
> On Mon, Mar 02, 2020 at 01:06:50PM -0500, Brian Foster wrote:
> > On Mon, Mar 02, 2020 at 02:07:50PM +1100, Dave Chinner wrote:
> > > On Thu, Feb 27, 2020 at 08:43:15AM -0500, Brian Foster wrote:
> > > > Automatic item relogging will occur from xfsaild context. xfsaild
> > > > cannot acquire log reservation itself because it is also responsible
> > > > for writeback and thus making used log reservation available again.
> > > > Since there is no guarantee log reservation is available by the time
> > > > a relogged item reaches the AIL, this is prone to deadlock.
> 
> .....
> 
> > > > @@ -284,15 +289,25 @@ xfs_trans_alloc(
> > > >  	tp->t_firstblock = NULLFSBLOCK;
> > > >  
> > > >  	error = xfs_trans_reserve(tp, resp, blocks, rtextents);
> > > > -	if (error) {
> > > > -		xfs_trans_cancel(tp);
> > > > -		return error;
> > > > +	if (error)
> > > > +		goto error;
> > > > +
> > > > +	if (flags & XFS_TRANS_RELOG) {
> > > > +		error = xfs_trans_ail_relog_reserve(&tp);
> > > > +		if (error)
> > > > +			goto error;
> > > >  	}
> > > 
> > > Hmmmm. So we are putting the AIL lock directly into the transaction
> > > reserve path? xfs_trans_reserve() goes out of it's way to be
> > > lockless in the fast paths, so if you want this to be a generic
> > > mechanism that any transaction can use, the reservation needs to be
> > > completely lockless.
> > > 
> > 
> > Yeah, this is one of those warts mentioned in the cover letter. I wasn't
> > planning to make it lockless as much as using an independent lock, but I
> > can take a closer look at that if it still looks like a contention point
> > after getting through the bigger picture feedback..
> 
> If relogging ends up getting widely used, then a filesystem global
> lock in the transaction reserve path is guaranteed to be a
> contention point. :)
> 

I was thinking yesterday that I had implemented a fast path there.  I
intended to, but looking at the code I realize I hadn't got to that yet.
So... I see your point and this will need to be addressed if it doesn't
fall away via the relog res rework.

> > > > +	/* release the relog ticket reference if this transaction holds one */
> > > > +	if (tp->t_flags & XFS_TRANS_RELOG)
> > > > +		xfs_trans_ail_relog_put(mp);
> > > > +
> > > 
> > > That looks ... interesting. xfs_trans_ail_relog_put() can call
> > > xfs_log_done(), which means it can do a log write, which means the
> > > commit lsn for this transaction could change. Hence to make a relog
> > > permanent as a result of a sync transaction, we'd need the
> > > commit_lsn of the AIL relog ticket write here, not that of the
> > > original transaction that was written.
> > > 
> > 
> > Hmm.. xfs_log_done() is eventually called for every transaction ticket,
> > so I don't think it should be doing log writes based on that.
> 
>   xfs_log_done()
>     xlog_commit_record()
>       xlog_write(XLOG_COMMIT_TRANS)
>         xlog_state_release_iclog()
> 	  xlog_sync()
> 	    xlog_write_iclog()
> 	      submit_bio()

Yeah, I know that we _can_ issue writes from this path because it's
shared between the CIL log ticket path and the per-transaction log
ticket path. I'm just not convinced that happens from the transaction
path simply because if it did, it would seem like a potentially
noticeable bug.

> >
> > The
> > _ail_relog_put() path is basically just intended to properly terminate
> > the relog ticket based on the existing transaction completion path. I'd
> > have to dig a bit further into the code here, but e.g. we don't pass an
> > iclog via this path so if we were attempting to write I'd probably have
> > seen assert failures (or worse) by now.
> 
> xlog_write() code handles a missing commit iclog pointer just fine.
> Indeed, that's the reason xlog_write() may issue log IO itself:
> 
> ....
>         spin_lock(&log->l_icloglock);
>         xlog_state_finish_copy(log, iclog, record_cnt, data_cnt);
>         if (commit_iclog) {
>                 ASSERT(flags & XLOG_COMMIT_TRANS);
>                 *commit_iclog = iclog;
>         } else {
>                 error = xlog_state_release_iclog(log, iclog);
>         }
>         spin_unlock(&log->l_icloglock);
> 
> i.e. if you don't provide xlog_write with a commit_iclog pointer
> then you are saying "caller does not call xfs_log_release_iclog()
> itself, so please release the iclog once the log iovec has been
> written to the iclog. Hence the way you've written this code
> explicitly tells xlog_write() to issue log IO on you behalf if it is
> necessary....
> 

xlog_commit_record(), which is the xlog_write() caller in this case,
expects a valid iclog and (unconditionally) asserts otherwise. I would
expect to have seen that assert had this happened.

> > Indeed, this is similar to a
> > cancel of a clean transaction, the difference being this is open-coded
> > because we only have the relog ticket in this context.
> 
> A clean transaction has XLOG_TIC_INITED set, so xfs_log_done() will
> never call xlog_commit_record() on it. XLOG_TIC_INITED is used to
> indicate a start record has been written to the log for a permanent
> transaction so it doesn't get written again when it is relogged.....
> 
> .... Hmmmm .....
> 
> You might be right.
> 

I figured it was related to the _INITED flag since that obviously gates
the call to xlog_commit_record(), but when I've taken a quick look at
that code in the past I wasn't really able to make much sense of its
purpose (i.e. why the behavior differs between CIL and transaction log
tickets) and didn't dig any further than that.

> It looks like delayed logging made XLOG_TIC_INITED completely
> redundant. xfs_trans_commit() no longer writes directly to iclogs,
> so the normal transaction tickets will never have XLOG_TIC_INITED
> cleared. Hence on any kernel since delayed logging was the only
> option, we will never get log writes from the xfs_trans* interfaces.
> 
> And we no longer do an xlog_write() call for every item in the
> transaction after we format them into a log iovec. Instead, the CIL
> just passes one big list of iovecs to a singel xlog_write() call,
> so all callers only make a single xlog_write call per physical log
> transaction.
> 
> OK, XLOG_TIC_INITED is redundant, and should be removed. And
> xfs_log_done() needs to be split into two, one for releasing the
> ticket, one for completing the xlog_write() call. Compile tested
> only patch below for you :P
> 

Heh, Ok. Will take a look.

> > > <GRRRRIIINNNNDDDD>
> > > 
> > > <CLUNK>
> > > 
> > > Ahhhhh.
> > > 
> > 
> > Heh. :P
> > 
> > > This is the reason why the CIL ended up using a reservation stealing
> > > mechanism for it's ticket. Every log reservation takes into account
> > > the worst case log overhead for that single transaction - that means
> > > there are no special up front hooks or changes to the log
> > > reservation to support the CIL, and it also means that the CIL can
> > > steal what it needs from the current ticket at commit time. Then the
> > > CIL can commit at any time, knowing it has enough space to write all
> > > the items it tracks to the log.
> > > 
> > > This avoided the transaction reservation mechanism from needing to
> > > know anything about the CIL or that it was stealing space from
> > > committing transactions for it's own private ticket. It greatly
> > > simplified everything, and it's the reason that the CIL succeeded
> > > where several other attempts to relog items in memory failed....
> > > 
> > > So....
> > > 
> > > Why can't the AIL steal the reservation it needs from the current
> > > transaction when the item that needs relogging is being committed?
> > 
> > I think we can. My first proposal[1] implemented something like this.
> > The broader design was much less fleshed out, so it was crudely
> > implemented as more of a commit time hook to relog pending items based
> > on the currently committing transaction as opposed to reservation
> > stealing for an independent relog ticket. This was actually based on the
> > observation that the CIL already did something similar (though I didn't
> > have all of the background as to why that approach was used for the
> > CIL).
> > 
> > The feedback at the time was to consider moving in a different direction
> > that didn't involve stealing reservation from transactions, which gave
> > me the impression that approach wasn't going to be acceptable. Granted,
> 
> I don't recall that discussion steering away from stealing
> reservations; it was more about mechanics like using transaction
> callbacks and other possible mechanisms for enabling relogging.
> 
> > the first few variations of this were widely different in approach and I
> > don't think there was any explicit objection to reservation stealing
> > itself, it just seemed a better development approach to work out an
> > ideal design based on fundamentals as opposed to limiting the scope to
> > contexts that might facilitate reservation stealing.
> 
> Right, it wasn't clear how to best implement this at the time,
> because we were all just struggling to get our heads around the
> problem scope. :)
> 
> > Despite the fact
> > that this code is hairy, the fundamental approach is rather
> > straightforward and simplistic. The hairiness mostly comes from
> > attempting to make things generic and dynamic and could certainly use
> > some cleanup.
> > 
> > Now that this is at a point where I'm reasonably confident it is
> > fundamentally correct, I'm quite happy to revisit a reservation stealing
> > approach if that improves functional operation. This can serve a decent
> > reference/baseline implementation for that, I think.
> 
> *nod*
> 
> > 
> > [1] https://lore.kernel.org/linux-xfs/20191024172850.7698-1-bfoster@redhat.com/
> > 
> > > i.e. we add the "relog overhead" to the permanent transaction that
> > > requires items to be relogged by the AIL, and when that item is
> > > formatted into the CIL we also check to see if it is currently
> > > marked as "reloggable". If it's not, we steal the relogging
> > > reservation from the transaction (essentially the item's formatted
> > > size) and pass it to the AIL's private relog ticket, setting the log
> > > item to be "reloggable" so the reservation isn't stolen over and
> > > over again as the object is relogged in the CIL.
> > > 
> > 
> > Ok, so this implies to me we'd update the per-transaction reservation
> > calculations to incorporate worst case relog overhead for each
> > transaction. E.g., the quotaoff transaction would x2 the intent size,
> > a transaction that might relog a buffer adds a max buffer size overhead,
> > etc. Right?
> 
> Essentially, yes.
> 
> And the reloggable items and reservation can be clearly documented
> in the per-transaction reservation explanation comments like we
> already do for all the structures that are modified in a
> transaction.
> 

Ok.

> > > Hence as we commit reloggable items to the CIL, the AIL ticket
> > > reservation grows with each of those items marked as reloggable.
> > > As we relog items to the CIL and the CIL grows it's reservation via
> > > the size delta, the AIL reservation can also be updated with the
> > > same delta.
> > > 
> > > Hence the AIL will always know exactly how much space it needs to relog all
> > > the items it holds for relogging, and because it's been stolen from
> > > the original transaction it is, like the CIL tciket reservation,
> > > considered used space in the log. Hence the log space required for
> > > relogging items via the AIL is correctly accounted for without
> > > needing up front static, per-item reservations.
> > > 
> > 
> > By this I assume you're referring to avoiding the need to reserve ->
> > donate -> roll in the current scheme. Instead, we'd acquire the larger
> > reservation up front and only steal if it necessary, which is less
> > overhead because we don't need to always replenish the full transaction.
> 
> Yes - we acquire the initial relog reservation by stealing it
> from the current transaction. This gives the AIL ticket the reserved
> space (both reserve and write grant space) it needs to relog the
> item once.
> 
> When the item is relogged by the AIL, the transaction commit
> immediately regrants the reservation space that was just consumed,
> and the trans_roll regrants the write grant space the commit just
> consumed from the ticket via it's call to xfs_trans_reserve(). Hence
> we only need to steal the space necessary to do the first relogging
> of the item as the AIL will hold that reservation until the high
> level code turns off relogging for that log item.
> 

Yep.

> > > Thoughts?
> > 
> > <thinking out loud from here on..>
> > 
> > One thing that comes to mind thinking about this is dealing with
> > batching (relog multiple items per roll). This code doesn't handle that
> > yet, but I anticipate it being a requirement and it's fairly easy to
> > update the current scheme to support a fixed item count per relog-roll.
> > 
> > A stealing approach potentially complicates things when it comes to
> > batching because we have per-item reservation granularity to consider.
> > For example, consider if we had a variety of different relog item types
> > active at once, a subset are being relogged while another subset are
> > being disabled (before ever needing to be relogged).
> 
> So concurrent "active relogging" + "start relogging" + "stop
> relogging"?
> 

Yeah..

> > For one, we'd have
> > to be careful to not release reservation while it might be accounted to
> > an active relog transaction that is currently rolling with some other
> > items, etc. There's also a potential quirk in handling reservation of a
> > relogged item that is cancelled while it's being relogged, but that
> > might be more of an implementation detail.
> 
> Right, did you notice the ail->ail_relog_lock rwsem that I wrapped
> my example relog transaction item add loop + commit function in?
> 

Yes, but the side effects didn't quite register..

> i.e. while we are building and committing a relog transaction, we
> hold off the transactions that are trying to add/remove their items
> to/from the relog list. Hence the reservation stealing accounting in
> the ticket can be be serialised against the transactional use of the
> ticket.
> 

Hmm, so this changes relog item/state management as well as the
reservation management. That's probably why it wasn't clear to me from
the code example.

> It's basically the same method we use for serialising addition to
> the CIL in transaction commit against CIL pushes draining the
> current list for log writes (rwsem for add/push serialisation, spin
> lock for concurrent add serialisation under the rwsem).
> 

Ok. The difference with the CIL is that in that context we're processing
a single, constantly maintained list of items. As of right now, there is
no such list for relog enabled items. If I'm following correctly, that's
still not necessary here, we're just talking about wrapping a rw lock
around the state management (+ res accounting) and the actual res
consumption such that a relog cancel doesn't steal reservation from an
active relog transaction, for example.

> > I don't think that's a show stopper, but rather just something I'd like
> > to have factored into the design from the start. One option could be to
> 
> *nod*
> 
> > maintain a separate counter of active relog reservation aside from the
> > actual relog ticket. That way the relog ticket could just pull from this
> > relog reservation pool based on the current item(s) being relogged
> > asynchronously from different tasks that might add or remove reservation
> > from the pool for separate items. That might get a little wonky when we
> > consider the relog ticket needs to pull from the pool and then put
> > something back if the item is still reloggable after the relog
> > transaction rolls.
> 
> RIght, that's the whole problem that we solve via a) stealing the
> initial reserve/write grant space at commit time and b) serialising
> stealing vs transactional use of the ticket.
> 
> That is, after the roll, the ticket has a full reserve and grant
> space reservation for all the items accounted to the relog ticket.
> Every new relog item added to the ticket (or is relogged in the CIL
> and uses more space) adds the full required reserve/write grant
> space to the the relog ticket. Hence the relog ticket always has
> current log space reserved to commit the entire set of items tagged
> as reloggable. And by avoiding modifying the ticket while we are
> actively processing the relog transaction, we don't screw up the
> ticket accounting in the middle of the transaction....
> 

Yep, Ok.

> > Another problem is that reloggable items are still otherwise usable once
> > they are unlocked. So for example we'd have to account for a situation
> > where one transaction dirties a buffer, enables relogging, commits and
> > then some other transaction dirties more of the buffer and commits
> > without caring whether the buffer was relog enabled or not.
> 
> yup, that's the delta size updates from the CIL commit. i.e. if we
> relog an item to the CIL that has the XFS_LI_RELOG flag already set
> on it, the change in size that we steal for the CIL ticket also
> needs to be stolen for the AIL ticket. i.e. we already do almost all
> the work we need to handle this.
> 
> > Unless
> > runtime relog reservation is always worst case, that's a subtle path to
> > reservation overrun in the relog transaction.
> 
> Yes, but it's a problem the CIL already solves for us :P
> 

Ok, I think we're pretty close to the same page here. I was thinking
about the worst case relog reservation being pulled off the committing
transaction unconditionally, where I think you're thinking about it as
the transaction (i.e. reservation calculation) would have the worst case
reservation, but we'd only pull off the delta as needed at commit time
(i.e. exactly how the CIL works wrt to transaction reservation
consumption). Let me work through a simple example to try and
(in)validate my concern:

- Transaction A is relog enabled, dirties 50% of a buffer and enables
  auto relogging. On commit, the CIL takes buffer/2 reservation for the
  log vector and the relog mechanism takes the same amount for
  subsequent relogs.
- Transaction B is not relog enabled (so no extra relog reservation),
  dirties another 40% of the (already relog enabled) buffer and commits.
  The CIL takes 90% of the transaction buffer reservation. The relog
  ticket now needs an additional 40% (since the original 50% is
  maintained by the relog system), but afaict there is no guarantee that
  res is available if trans B is not relog enabled.

So IIUC, the CIL scheme works because every transaction automatically
includes worst case reservation for every possible item supported by the
transaction. Relog transactions are presumably more selective, however,
so we need to either have some rule where only relog enabled
transactions can touch relog enabled items (it's not clear to me how
realistic that is for things like buffers etc., but it sounds
potentially delicate) or we simplify the relog reservation consumption
calculation to consume worst case reservation for the relog ticket in
anticipation of unrelated transactions dirtying more of the associated
object since it was originally committed for relog. Thoughts?

Note that carrying worst case reservation also potentially simplifies
accounting between multiple dirty+relog increments and a single relog
cancel, particularly if a relog cancelling transaction also happens to
dirty more of a buffer before it commits. I'd prefer to avoid subtle
usage landmines like that as much as possible. Hmm.. even if we do
ultimately want a more granular and dynamic relog res accounting, I
might start with the simple worst-case approach since 1.) it probably
doesn't matter for intents, 2.) it's easier to reason about the isolated
reservation calculation changes in an independent patch from the rest of
the mechanism and 3.) I'd rather get the basics nailed down and solid
before potentially fighting with granular reservation accounting
accuracy bugs. ;)

Brian

> > I'm actually wondering if a more simple approach to tracking stolen
> > reservation is to add a new field that tracks active relog reservation
> > to each supported log item.  Then the initial transaction enables
> > relogging with a simple transfer from the transaction to the item. The
> > relog transaction knows how much reservation it can assign based on the
> > current population of items and requires no further reservation
> > accounting because it rolls and thus automatically reacquires relog
> > reservation for each associated item. The path that clears relog state
> > transfers res from the item back to a transaction simply so the
> > reservation can be released back to the pool of unused log space. Note
> > that clearing relog state doesn't require a transaction in the current
> > implementation, but we could easily define a helper to allocate an empty
> > transaction, clear relog and reclaim relog reservation and then cancel
> > for those contexts.
> 
> I don't think we need any of that - the AIL ticket only needs to be
> kept up to date with the changes to the formatted size of the item
> marked for relogging. It's no different to the CIL ticket
> reservation accounting from that perspective.
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 

