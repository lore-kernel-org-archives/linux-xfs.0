Return-Path: <SRS0=0zz6=4T=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E364C3F2CD
	for <linux-xfs@archiver.kernel.org>; Mon,  2 Mar 2020 18:53:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 464E220873
	for <linux-xfs@archiver.kernel.org>; Mon,  2 Mar 2020 18:53:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XmTG6gMl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727360AbgCBSw7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 2 Mar 2020 13:52:59 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:23093 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726451AbgCBSw7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 2 Mar 2020 13:52:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583175177;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=2KTga6yudWsM7oYkr+eSBAIJ5ss2e4Wrp8v7T/qOoRM=;
        b=XmTG6gMlYOQqh9W45ujZu9b8LDVWkgQFT5JPoNUqbUpai8cZLcXmAY3CsfDHDKsR1ak3n/
        vmdE3UQE1C2Wy5a/y93ScbwKH7A4q9fR/uJseXPxuuCXRM4Azv/WwPxx2n5MjEu1kDYCwB
        H2qmi/nnzC9oszPQhxyJJeyEj2pGu7E=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-389-ZOzfTKSLNOGQJ3cn1vz9Gw-1; Mon, 02 Mar 2020 13:52:56 -0500
X-MC-Unique: ZOzfTKSLNOGQJ3cn1vz9Gw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0C4DEA0CBF;
        Mon,  2 Mar 2020 18:52:55 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 770F719C4F;
        Mon,  2 Mar 2020 18:52:54 +0000 (UTC)
Date:   Mon, 2 Mar 2020 13:52:52 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [RFC v5 PATCH 5/9] xfs: automatic log item relog mechanism
Message-ID: <20200302185252.GD10946@bfoster>
References: <20200227134321.7238-1-bfoster@redhat.com>
 <20200227134321.7238-6-bfoster@redhat.com>
 <20200302071843.GK10776@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200302071843.GK10776@dread.disaster.area>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Mar 02, 2020 at 06:18:43PM +1100, Dave Chinner wrote:
> On Thu, Feb 27, 2020 at 08:43:17AM -0500, Brian Foster wrote:
> > Now that relog reservation is available and relog state tracking is
> > in place, all that remains to automatically relog items is the relog
> > mechanism itself. An item with relogging enabled is basically pinned
> > from writeback until relog is disabled. Instead of being written
> > back, the item must instead be periodically committed in a new
> > transaction to move it in the physical log. The purpose of moving
> > the item is to avoid long term tail pinning and thus avoid log
> > deadlocks for long running operations.
> > 
> > The ideal time to relog an item is in response to tail pushing
> > pressure. This accommodates the current workload at any given time
> > as opposed to a fixed time interval or log reservation heuristic,
> > which risks performance regression. This is essentially the same
> > heuristic that drives metadata writeback. XFS already implements
> > various log tail pushing heuristics that attempt to keep the log
> > progressing on an active fileystem under various workloads.
> > 
> > The act of relogging an item simply requires to add it to a
> > transaction and commit. This pushes the already dirty item into a
> > subsequent log checkpoint and frees up its previous location in the
> > on-disk log. Joining an item to a transaction of course requires
> > locking the item first, which means we have to be aware of
> > type-specific locks and lock ordering wherever the relog takes
> > place.
> > 
> > Fundamentally, this points to xfsaild as the ideal location to
> > process relog enabled items. xfsaild already processes log resident
> > items, is driven by log tail pushing pressure, processes arbitrary
> > log item types through callbacks, and is sensitive to type-specific
> > locking rules by design. The fact that automatic relogging
> > essentially diverts items between writeback or relog also suggests
> > xfsaild as an ideal location to process items one way or the other.
> > 
> > Of course, we don't want xfsaild to process transactions as it is a
> > critical component of the log subsystem for driving metadata
> > writeback and freeing up log space. Therefore, similar to how
> > xfsaild builds up a writeback queue of dirty items and queues writes
> > asynchronously, make xfsaild responsible only for directing pending
> > relog items into an appropriate queue and create an async
> > (workqueue) context for processing the queue. The workqueue context
> > utilizes the pre-reserved relog ticket to drain the queue by rolling
> > a permanent transaction.
> > 
> > Update the AIL pushing infrastructure to support a new RELOG item
> > state. If a log item push returns the relog state, queue the item
> > for relog instead of writeback. On completion of a push cycle,
> > schedule the relog task at the same point metadata buffer I/O is
> > submitted. This allows items to be relogged automatically under the
> > same locking rules and pressure heuristics that govern metadata
> > writeback.
> > 
> > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > ---
> >  fs/xfs/xfs_trace.h      |   1 +
> >  fs/xfs/xfs_trans.h      |   1 +
> >  fs/xfs/xfs_trans_ail.c  | 103 +++++++++++++++++++++++++++++++++++++++-
> >  fs/xfs/xfs_trans_priv.h |   3 ++
> >  4 files changed, 106 insertions(+), 2 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> > index a066617ec54d..df0114ec66f1 100644
> > --- a/fs/xfs/xfs_trace.h
> > +++ b/fs/xfs/xfs_trace.h
> > @@ -1063,6 +1063,7 @@ DEFINE_LOG_ITEM_EVENT(xfs_ail_push);
> >  DEFINE_LOG_ITEM_EVENT(xfs_ail_pinned);
> >  DEFINE_LOG_ITEM_EVENT(xfs_ail_locked);
> >  DEFINE_LOG_ITEM_EVENT(xfs_ail_flushing);
> > +DEFINE_LOG_ITEM_EVENT(xfs_ail_relog);
> >  DEFINE_LOG_ITEM_EVENT(xfs_relog_item);
> >  DEFINE_LOG_ITEM_EVENT(xfs_relog_item_cancel);
> >  
> > diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
> > index fc4c25b6eee4..1637df32c64c 100644
> > --- a/fs/xfs/xfs_trans.h
> > +++ b/fs/xfs/xfs_trans.h
> > @@ -99,6 +99,7 @@ void	xfs_log_item_init(struct xfs_mount *mp, struct xfs_log_item *item,
> >  #define XFS_ITEM_PINNED		1
> >  #define XFS_ITEM_LOCKED		2
> >  #define XFS_ITEM_FLUSHING	3
> > +#define XFS_ITEM_RELOG		4
> >  
> >  /*
> >   * Deferred operation item relogging limits.
> > diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
> > index a3fb64275baa..71a47faeaae8 100644
> > --- a/fs/xfs/xfs_trans_ail.c
> > +++ b/fs/xfs/xfs_trans_ail.c
> > @@ -144,6 +144,75 @@ xfs_ail_max_lsn(
> >  	return lsn;
> >  }
> >  
> > +/*
> > + * Relog log items on the AIL relog queue.
> > + */
> > +static void
> > +xfs_ail_relog(
> > +	struct work_struct	*work)
> > +{
> > +	struct xfs_ail		*ailp = container_of(work, struct xfs_ail,
> > +						     ail_relog_work);
> > +	struct xfs_mount	*mp = ailp->ail_mount;
> > +	struct xfs_trans_res	tres = {};
> > +	struct xfs_trans	*tp;
> > +	struct xfs_log_item	*lip;
> > +	int			error;
> > +
> > +	/*
> > +	 * The first transaction to submit a relog item contributed relog
> > +	 * reservation to the relog ticket before committing. Create an empty
> > +	 * transaction and manually associate the relog ticket.
> > +	 */
> > +	error = xfs_trans_alloc(mp, &tres, 0, 0, 0, &tp);
> 
> I suspect deadlocks on filesystems in the process of being frozen
> when the log is full and relogging is required to make progress.
> 

I'll have to look into interactions with fs freeze as well once the
basics are nailed down.

> > +	ASSERT(!error);
> > +	if (error)
> > +		return;
> > +	tp->t_log_res = M_RES(mp)->tr_relog.tr_logres;
> > +	tp->t_log_count = M_RES(mp)->tr_relog.tr_logcount;
> > +	tp->t_flags |= M_RES(mp)->tr_relog.tr_logflags;
> > +	tp->t_ticket = xfs_log_ticket_get(ailp->ail_relog_tic);
> 
> So this assumes you've stolen the log reservation for this ticket
> from somewhere else, because otherwise the transaction log
> reservation and the ticket don't match.
> 
> FWIW, I'm having trouble real keeping all the ail relog ticket
> references straight. Code seems to be
> arbitratily taking and dropping references to that ticket, and I
> can't see a pattern or set of rules for usage.
> 

The reference counting stuff is a mess. I was anticipating needing to
simplify it, perhaps abstract it from the actual log ticket count, but
I'm going to hold off on getting too deep into the weeds of the
reference counting stuff unless the reservation stealing approach
doesn't pan out. Otherwise, this should presumably all go away..

> Why does this specific transaction need a reference to the ticket,
> when the ail_relog_list has a reference, every item that has been
> marked as XFS_LI_RELOG already has a reference, etc?
> 

This transaction has a reference because it uses the log ticket. It will
release a ticket reference on commit. Also note that the relog state
(and thus references) can be cleared from items at any time.

> > +	spin_lock(&ailp->ail_lock);
> > +	while ((lip = list_first_entry_or_null(&ailp->ail_relog_list,
> > +					       struct xfs_log_item,
> > +					       li_trans)) != NULL) {
> 
> I dislike the way the "swiss army knife" list macro makes this
> code unreadable.
> 
>         while (!list_empty(&ailp->ail_relog_list)) {
> 		lip = list_first_entry(...)
> 
> is much neater and easier to read.
> 

Ok.

> > +		/*
> > +		 * Drop the AIL processing ticket reference once the relog list
> > +		 * is emptied. At this point it's possible for our transaction
> > +		 * to hold the only reference.
> > +		 */
> > +		list_del_init(&lip->li_trans);
> > +		if (list_empty(&ailp->ail_relog_list))
> > +			xfs_log_ticket_put(ailp->ail_relog_tic);
> 
> This seems completely arbitrary.
> 

The list holds a reference for when an item is queued for relog but the
relog state cleared before the relog occurs.

> > +		spin_unlock(&ailp->ail_lock);
> > +
> > +		xfs_trans_add_item(tp, lip);
> > +		set_bit(XFS_LI_DIRTY, &lip->li_flags);
> > +		tp->t_flags |= XFS_TRANS_DIRTY;
> > +		/* XXX: include ticket owner task fix */
> > +		error = xfs_trans_roll(&tp);
> 
> So the reservation for this ticket is going to be regranted over and
> over again and space reserved repeatedly as we work through the
> locked relog items one at a time?
> 
> Unfortunately, this violates the rule that prevents rolling
> transactions from deadlocking. That is, any object that is held
> locked across the transaction commit and regrant that *might pin the
> tail of the log* must be relogged in the transaction to move the
> item forward and prevent it from pinning the tail of the log.
> 
> IOWs, if one of the items later in the relog list pins the tail of
> the log we will end up sleeping here:
> 
>   xfs_trans_roll()
>     xfs_trans_reserve
>       xfs_log_regrant
>         xlog_grant_head_check(need_bytes)
> 	  xlog_grant_head_wait()
> 
> waiting for the write grant head to move. ANd it never will, because
> we hold the lock on that item so the AIL can't push it out.
> IOWs, using a rolling transaction per relog item will not work for
> processing multiple relog items.
> 

Hm, Ok. I must be missing something about the rolling transaction
guarantees.

> If it's a single transaction, and we join all the locked items
> for relogging into it in a single transaction commit, then we are
> fine - we don't try to regrant log space while holding locked items
> that could pin the tail of the log.
> 
> We *can* use a rolling transaction if we do this - the AIL has a
> permenant transaction (plus ticket!) allocated at mount time with
> a log count of zero, we can then steal reserve/write grant head
> space into it that ticket at CIL commit time as I mentioned
> previously. We do a loop like above, but it's basically:
> 
> {
> 	LIST_HEAD(tmp);
> 
> 	spin_lock(&ailp->ail_lock);
>         if (list_empty(&ailp->ail_relog_list)) {
> 		spin_unlock(&ailp->ail_lock);
> 		return;
> 	}
> 
> 	list_splice_init(&ilp->ail_relog_list, &tmp);
> 	spin_unlock(&ailp->ail_lock);
> 
> 	xfs_ail_relog_items(ail, &tmp);
> }
> 
> This allows the AIL to keep working and building up a new relog
> as it goes along. hence we can work on our list without interruption
> or needed to repeatedly take the AIL lock just to get items from the
> list.
> 

Yeah, I was planning splicing the list as such to avoid cycling the lock
so much regardless..

> And xfs_ail_relog_items() does something like this:
> 
> {
> 	struct xfs_trans	*tp;
> 
> 	/*
> 	 * Make CIL committers trying to change relog status of log
> 	 * items wait for us to istabilise the relog transaction
> 	 * again by committing the current relog list and rolling
> 	 * the transaction.
> 	 */
> 	down_write(&ail->ail_relog_lock);
> 	tp = ail->relog_trans;
> 
> 	while ((lip = list_first_entry_or_null(&ailp->ail_relog_list,
> 					       struct xfs_log_item,
> 					       li_trans)) != NULL) {
>         while (!list_empty(&ailp->ail_relog_list)) {
> 		lip = list_first_entry(&ailp->ail_relog_list,
> 					struct xfs_log_item, li_trans);
> 		list_del_init(&lip->li_trans);
> 
> 		xfs_trans_add_item(tp, lip);
> 		set_bit(XFS_LI_DIRTY, &lip->li_flags);
> 		tp->t_flags |= XFS_TRANS_DIRTY;
> 	}
> 
> 	error = xfs_trans_roll(&tp);
> 	if (error) {
> 		SHUTDOWN!
> 	}
> 	ail->relog_trans = tp;
> 	up_write(&ail->ail_relog_lock);
> }
> 

I think I follow.. The fundamental difference here is basically that we
commit whatever we locked, right? IOW, the current approach _could_
technically be corrected, but it would have to lock one item at a time
(ugh) rather than build up a queue of locked items..?

The reservation stealing approach facilitates this batching because
instead of only having a guarantee that we can commit one max sized
relog item at a time, we can commit however many we have queued because
sufficient reservation has already been acquired.

That does raise another issue in that we presumably want some kind of
maximum transaction size and/or maximum outstanding relog reservation
with the above approach. Otherwise it could be possible for a workload
to go off the rails without any kind of throttling or hueristics
incorporated in the current (mostly) fixed transaction sizes. Perhaps
it's reasonable enough to cap outstanding relog reservation to the max
transaction size and return an error to callers that attempt to exceed
it..? It's not clear to me if that would impact the prospective scrub
use case. Hmmm.. maybe the right thing to do is cap the size of the
current relog queue so we cap the size of the relog transaction without
necessarily capping the max outstanding relog reservation. Thoughts on
that?

> > @@ -426,6 +495,23 @@ xfsaild_push(
> >  			ailp->ail_last_pushed_lsn = lsn;
> >  			break;
> >  
> > +		case XFS_ITEM_RELOG:
> > +			/*
> > +			 * The item requires a relog. Add to the pending relog
> > +			 * list and set the relogged bit to prevent further
> > +			 * relog requests. The relog bit and ticket reference
> > +			 * can be dropped from the item at any point, so hold a
> > +			 * relog ticket reference for the pending relog list to
> > +			 * ensure the ticket stays around.
> > +			 */
> > +			trace_xfs_ail_relog(lip);
> > +			ASSERT(list_empty(&lip->li_trans));
> > +			if (list_empty(&ailp->ail_relog_list))
> > +				xfs_log_ticket_get(ailp->ail_relog_tic);
> > +			list_add_tail(&lip->li_trans, &ailp->ail_relog_list);
> > +			set_bit(XFS_LI_RELOGGED, &lip->li_flags);
> > +			break;
> 
> So the XFS_LI_RELOGGED bit indicates that the item is locked on the
> relog list? That means nothing else in the transaction subsystem
> will set that until the item is unlocked, right? Which is when it
> ends up back on the CIL. This then gets cleared by the CIL being
> forced and the item moved forward in the AIL.
> 
> IOWs, a log force clears this flag until the AIL relogs it again.
> Why do we need this flag to issue wakeups when the wait loop does
> blocking log forces? i.e. it will have already waited for the flag
> to be cleared by waiting for the log force....
> 

The bit tracks when a relog item has been queued. It's set when first
added to the relog queue and is cleared when the item lands back in the
on-disk log. The primary purpose of the bit is thus to prevent spurious
relogging of an item that's already been dropped back into the CIL and
thus a move in the physical log is pending.

The wait/wake is a secondary usage to isolate the item to the AIL once
relogging is disabled. The wait covers the case where the item is queued
on the relog list but not committed back to the log subsystem. Otherwise
the log force serves no purpose.

Brian

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 

