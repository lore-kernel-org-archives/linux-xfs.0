Return-Path: <SRS0=0zz6=4T=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BB1EC3F2D2
	for <linux-xfs@archiver.kernel.org>; Mon,  2 Mar 2020 07:18:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 15EAC24699
	for <linux-xfs@archiver.kernel.org>; Mon,  2 Mar 2020 07:18:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725446AbgCBHSt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 2 Mar 2020 02:18:49 -0500
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:38139 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726694AbgCBHSt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 2 Mar 2020 02:18:49 -0500
Received: from dread.disaster.area (pa49-195-202-68.pa.nsw.optusnet.com.au [49.195.202.68])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 3E51F3A1B09;
        Mon,  2 Mar 2020 18:18:45 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1j8fLf-0007Oo-Tv; Mon, 02 Mar 2020 18:18:43 +1100
Date:   Mon, 2 Mar 2020 18:18:43 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [RFC v5 PATCH 5/9] xfs: automatic log item relog mechanism
Message-ID: <20200302071843.GK10776@dread.disaster.area>
References: <20200227134321.7238-1-bfoster@redhat.com>
 <20200227134321.7238-6-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200227134321.7238-6-bfoster@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=X6os11be c=1 sm=1 tr=0
        a=mqTaRPt+QsUAtUurwE173Q==:117 a=mqTaRPt+QsUAtUurwE173Q==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=SS2py6AdgQ4A:10
        a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8 a=Ba8hIoYWSrzRx4XFcvIA:9
        a=CjuIK1q_8ugA:10 a=Grnb8HPFGUAA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Feb 27, 2020 at 08:43:17AM -0500, Brian Foster wrote:
> Now that relog reservation is available and relog state tracking is
> in place, all that remains to automatically relog items is the relog
> mechanism itself. An item with relogging enabled is basically pinned
> from writeback until relog is disabled. Instead of being written
> back, the item must instead be periodically committed in a new
> transaction to move it in the physical log. The purpose of moving
> the item is to avoid long term tail pinning and thus avoid log
> deadlocks for long running operations.
> 
> The ideal time to relog an item is in response to tail pushing
> pressure. This accommodates the current workload at any given time
> as opposed to a fixed time interval or log reservation heuristic,
> which risks performance regression. This is essentially the same
> heuristic that drives metadata writeback. XFS already implements
> various log tail pushing heuristics that attempt to keep the log
> progressing on an active fileystem under various workloads.
> 
> The act of relogging an item simply requires to add it to a
> transaction and commit. This pushes the already dirty item into a
> subsequent log checkpoint and frees up its previous location in the
> on-disk log. Joining an item to a transaction of course requires
> locking the item first, which means we have to be aware of
> type-specific locks and lock ordering wherever the relog takes
> place.
> 
> Fundamentally, this points to xfsaild as the ideal location to
> process relog enabled items. xfsaild already processes log resident
> items, is driven by log tail pushing pressure, processes arbitrary
> log item types through callbacks, and is sensitive to type-specific
> locking rules by design. The fact that automatic relogging
> essentially diverts items between writeback or relog also suggests
> xfsaild as an ideal location to process items one way or the other.
> 
> Of course, we don't want xfsaild to process transactions as it is a
> critical component of the log subsystem for driving metadata
> writeback and freeing up log space. Therefore, similar to how
> xfsaild builds up a writeback queue of dirty items and queues writes
> asynchronously, make xfsaild responsible only for directing pending
> relog items into an appropriate queue and create an async
> (workqueue) context for processing the queue. The workqueue context
> utilizes the pre-reserved relog ticket to drain the queue by rolling
> a permanent transaction.
> 
> Update the AIL pushing infrastructure to support a new RELOG item
> state. If a log item push returns the relog state, queue the item
> for relog instead of writeback. On completion of a push cycle,
> schedule the relog task at the same point metadata buffer I/O is
> submitted. This allows items to be relogged automatically under the
> same locking rules and pressure heuristics that govern metadata
> writeback.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
>  fs/xfs/xfs_trace.h      |   1 +
>  fs/xfs/xfs_trans.h      |   1 +
>  fs/xfs/xfs_trans_ail.c  | 103 +++++++++++++++++++++++++++++++++++++++-
>  fs/xfs/xfs_trans_priv.h |   3 ++
>  4 files changed, 106 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index a066617ec54d..df0114ec66f1 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -1063,6 +1063,7 @@ DEFINE_LOG_ITEM_EVENT(xfs_ail_push);
>  DEFINE_LOG_ITEM_EVENT(xfs_ail_pinned);
>  DEFINE_LOG_ITEM_EVENT(xfs_ail_locked);
>  DEFINE_LOG_ITEM_EVENT(xfs_ail_flushing);
> +DEFINE_LOG_ITEM_EVENT(xfs_ail_relog);
>  DEFINE_LOG_ITEM_EVENT(xfs_relog_item);
>  DEFINE_LOG_ITEM_EVENT(xfs_relog_item_cancel);
>  
> diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
> index fc4c25b6eee4..1637df32c64c 100644
> --- a/fs/xfs/xfs_trans.h
> +++ b/fs/xfs/xfs_trans.h
> @@ -99,6 +99,7 @@ void	xfs_log_item_init(struct xfs_mount *mp, struct xfs_log_item *item,
>  #define XFS_ITEM_PINNED		1
>  #define XFS_ITEM_LOCKED		2
>  #define XFS_ITEM_FLUSHING	3
> +#define XFS_ITEM_RELOG		4
>  
>  /*
>   * Deferred operation item relogging limits.
> diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
> index a3fb64275baa..71a47faeaae8 100644
> --- a/fs/xfs/xfs_trans_ail.c
> +++ b/fs/xfs/xfs_trans_ail.c
> @@ -144,6 +144,75 @@ xfs_ail_max_lsn(
>  	return lsn;
>  }
>  
> +/*
> + * Relog log items on the AIL relog queue.
> + */
> +static void
> +xfs_ail_relog(
> +	struct work_struct	*work)
> +{
> +	struct xfs_ail		*ailp = container_of(work, struct xfs_ail,
> +						     ail_relog_work);
> +	struct xfs_mount	*mp = ailp->ail_mount;
> +	struct xfs_trans_res	tres = {};
> +	struct xfs_trans	*tp;
> +	struct xfs_log_item	*lip;
> +	int			error;
> +
> +	/*
> +	 * The first transaction to submit a relog item contributed relog
> +	 * reservation to the relog ticket before committing. Create an empty
> +	 * transaction and manually associate the relog ticket.
> +	 */
> +	error = xfs_trans_alloc(mp, &tres, 0, 0, 0, &tp);

I suspect deadlocks on filesystems in the process of being frozen
when the log is full and relogging is required to make progress.

> +	ASSERT(!error);
> +	if (error)
> +		return;
> +	tp->t_log_res = M_RES(mp)->tr_relog.tr_logres;
> +	tp->t_log_count = M_RES(mp)->tr_relog.tr_logcount;
> +	tp->t_flags |= M_RES(mp)->tr_relog.tr_logflags;
> +	tp->t_ticket = xfs_log_ticket_get(ailp->ail_relog_tic);

So this assumes you've stolen the log reservation for this ticket
from somewhere else, because otherwise the transaction log
reservation and the ticket don't match.

FWIW, I'm having trouble real keeping all the ail relog ticket
references straight. Code seems to be
arbitratily taking and dropping references to that ticket, and I
can't see a pattern or set of rules for usage.

Why does this specific transaction need a reference to the ticket,
when the ail_relog_list has a reference, every item that has been
marked as XFS_LI_RELOG already has a reference, etc?

> +	spin_lock(&ailp->ail_lock);
> +	while ((lip = list_first_entry_or_null(&ailp->ail_relog_list,
> +					       struct xfs_log_item,
> +					       li_trans)) != NULL) {

I dislike the way the "swiss army knife" list macro makes this
code unreadable.

        while (!list_empty(&ailp->ail_relog_list)) {
		lip = list_first_entry(...)

is much neater and easier to read.

> +		/*
> +		 * Drop the AIL processing ticket reference once the relog list
> +		 * is emptied. At this point it's possible for our transaction
> +		 * to hold the only reference.
> +		 */
> +		list_del_init(&lip->li_trans);
> +		if (list_empty(&ailp->ail_relog_list))
> +			xfs_log_ticket_put(ailp->ail_relog_tic);

This seems completely arbitrary.

> +		spin_unlock(&ailp->ail_lock);
> +
> +		xfs_trans_add_item(tp, lip);
> +		set_bit(XFS_LI_DIRTY, &lip->li_flags);
> +		tp->t_flags |= XFS_TRANS_DIRTY;
> +		/* XXX: include ticket owner task fix */
> +		error = xfs_trans_roll(&tp);

So the reservation for this ticket is going to be regranted over and
over again and space reserved repeatedly as we work through the
locked relog items one at a time?

Unfortunately, this violates the rule that prevents rolling
transactions from deadlocking. That is, any object that is held
locked across the transaction commit and regrant that *might pin the
tail of the log* must be relogged in the transaction to move the
item forward and prevent it from pinning the tail of the log.

IOWs, if one of the items later in the relog list pins the tail of
the log we will end up sleeping here:

  xfs_trans_roll()
    xfs_trans_reserve
      xfs_log_regrant
        xlog_grant_head_check(need_bytes)
	  xlog_grant_head_wait()

waiting for the write grant head to move. ANd it never will, because
we hold the lock on that item so the AIL can't push it out.
IOWs, using a rolling transaction per relog item will not work for
processing multiple relog items.

If it's a single transaction, and we join all the locked items
for relogging into it in a single transaction commit, then we are
fine - we don't try to regrant log space while holding locked items
that could pin the tail of the log.

We *can* use a rolling transaction if we do this - the AIL has a
permenant transaction (plus ticket!) allocated at mount time with
a log count of zero, we can then steal reserve/write grant head
space into it that ticket at CIL commit time as I mentioned
previously. We do a loop like above, but it's basically:

{
	LIST_HEAD(tmp);

	spin_lock(&ailp->ail_lock);
        if (list_empty(&ailp->ail_relog_list)) {
		spin_unlock(&ailp->ail_lock);
		return;
	}

	list_splice_init(&ilp->ail_relog_list, &tmp);
	spin_unlock(&ailp->ail_lock);

	xfs_ail_relog_items(ail, &tmp);
}

This allows the AIL to keep working and building up a new relog
as it goes along. hence we can work on our list without interruption
or needed to repeatedly take the AIL lock just to get items from the
list.

And xfs_ail_relog_items() does something like this:

{
	struct xfs_trans	*tp;

	/*
	 * Make CIL committers trying to change relog status of log
	 * items wait for us to istabilise the relog transaction
	 * again by committing the current relog list and rolling
	 * the transaction.
	 */
	down_write(&ail->ail_relog_lock);
	tp = ail->relog_trans;

	while ((lip = list_first_entry_or_null(&ailp->ail_relog_list,
					       struct xfs_log_item,
					       li_trans)) != NULL) {
        while (!list_empty(&ailp->ail_relog_list)) {
		lip = list_first_entry(&ailp->ail_relog_list,
					struct xfs_log_item, li_trans);
		list_del_init(&lip->li_trans);

		xfs_trans_add_item(tp, lip);
		set_bit(XFS_LI_DIRTY, &lip->li_flags);
		tp->t_flags |= XFS_TRANS_DIRTY;
	}

	error = xfs_trans_roll(&tp);
	if (error) {
		SHUTDOWN!
	}
	ail->relog_trans = tp;
	up_write(&ail->ail_relog_lock);
}

> @@ -426,6 +495,23 @@ xfsaild_push(
>  			ailp->ail_last_pushed_lsn = lsn;
>  			break;
>  
> +		case XFS_ITEM_RELOG:
> +			/*
> +			 * The item requires a relog. Add to the pending relog
> +			 * list and set the relogged bit to prevent further
> +			 * relog requests. The relog bit and ticket reference
> +			 * can be dropped from the item at any point, so hold a
> +			 * relog ticket reference for the pending relog list to
> +			 * ensure the ticket stays around.
> +			 */
> +			trace_xfs_ail_relog(lip);
> +			ASSERT(list_empty(&lip->li_trans));
> +			if (list_empty(&ailp->ail_relog_list))
> +				xfs_log_ticket_get(ailp->ail_relog_tic);
> +			list_add_tail(&lip->li_trans, &ailp->ail_relog_list);
> +			set_bit(XFS_LI_RELOGGED, &lip->li_flags);
> +			break;

So the XFS_LI_RELOGGED bit indicates that the item is locked on the
relog list? That means nothing else in the transaction subsystem
will set that until the item is unlocked, right? Which is when it
ends up back on the CIL. This then gets cleared by the CIL being
forced and the item moved forward in the AIL.

IOWs, a log force clears this flag until the AIL relogs it again.
Why do we need this flag to issue wakeups when the wait loop does
blocking log forces? i.e. it will have already waited for the flag
to be cleared by waiting for the log force....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
