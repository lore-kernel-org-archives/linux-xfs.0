Return-Path: <SRS0=TABv=4U=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7317CC3F2D1
	for <linux-xfs@archiver.kernel.org>; Tue,  3 Mar 2020 00:06:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 34F2021D56
	for <linux-xfs@archiver.kernel.org>; Tue,  3 Mar 2020 00:06:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726755AbgCCAGv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 2 Mar 2020 19:06:51 -0500
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:41587 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726752AbgCCAGv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 2 Mar 2020 19:06:51 -0500
Received: from dread.disaster.area (pa49-195-202-68.pa.nsw.optusnet.com.au [49.195.202.68])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id AD46C3A2323;
        Tue,  3 Mar 2020 11:06:45 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1j8v59-0004yV-Md; Tue, 03 Mar 2020 11:06:43 +1100
Date:   Tue, 3 Mar 2020 11:06:43 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [RFC v5 PATCH 5/9] xfs: automatic log item relog mechanism
Message-ID: <20200303000643.GO10776@dread.disaster.area>
References: <20200227134321.7238-1-bfoster@redhat.com>
 <20200227134321.7238-6-bfoster@redhat.com>
 <20200302071843.GK10776@dread.disaster.area>
 <20200302185252.GD10946@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200302185252.GD10946@bfoster>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=LYdCFQXi c=1 sm=1 tr=0
        a=mqTaRPt+QsUAtUurwE173Q==:117 a=mqTaRPt+QsUAtUurwE173Q==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=SS2py6AdgQ4A:10
        a=7-415B0cAAAA:8 a=v0vxgGeCc4EKoY8Tax4A:9 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Mar 02, 2020 at 01:52:52PM -0500, Brian Foster wrote:
> On Mon, Mar 02, 2020 at 06:18:43PM +1100, Dave Chinner wrote:
> > On Thu, Feb 27, 2020 at 08:43:17AM -0500, Brian Foster wrote:
> > > +		spin_unlock(&ailp->ail_lock);
> > > +
> > > +		xfs_trans_add_item(tp, lip);
> > > +		set_bit(XFS_LI_DIRTY, &lip->li_flags);
> > > +		tp->t_flags |= XFS_TRANS_DIRTY;
> > > +		/* XXX: include ticket owner task fix */
> > > +		error = xfs_trans_roll(&tp);
> > 
> > So the reservation for this ticket is going to be regranted over and
> > over again and space reserved repeatedly as we work through the
> > locked relog items one at a time?
> > 
> > Unfortunately, this violates the rule that prevents rolling
> > transactions from deadlocking. That is, any object that is held
> > locked across the transaction commit and regrant that *might pin the
> > tail of the log* must be relogged in the transaction to move the
> > item forward and prevent it from pinning the tail of the log.
> > 
> > IOWs, if one of the items later in the relog list pins the tail of
> > the log we will end up sleeping here:
> > 
> >   xfs_trans_roll()
> >     xfs_trans_reserve
> >       xfs_log_regrant
> >         xlog_grant_head_check(need_bytes)
> > 	  xlog_grant_head_wait()
> > 
> > waiting for the write grant head to move. ANd it never will, because
> > we hold the lock on that item so the AIL can't push it out.
> > IOWs, using a rolling transaction per relog item will not work for
> > processing multiple relog items.
> > 
> 
> Hm, Ok. I must be missing something about the rolling transaction
> guarantees.

Ok, I know you understand some of the rules, but because I don't
know quite which bit of this complex game you are missing, I'll go
over it from the start (sorry for repeating things you know!).

We're not allowed to hold locked items that are in the AIL over a
transaction reservation call because the transaction reservation may
need to push the log to free up space in the log. Writing back
metadata requires locking the item to flush it, and if we hold it
locked the it can't be flushed. Hence if it pins the tail of the log
and prevents the the reservation from making space available, we
deadlock.

Normally, the only thing that is pinned across a transaction roll is
an inode, and the inode is being logged in every transaction. Hence
it is being continually moved to the head of the log and so can't
pin the tail of the log and prevent the reservation making progress.

The problem here is that having a log reservation for a modification
doesn't guarantee you that log space is immediately available - all
it guarantees you is that the log space will be available if the log
tail if free to move forward.

That's why there are two grant heads. The reservation grant head is
the one that guarantees that you have space available in the log for
the rolling transaction. That is always immediately regranted during
transaction commit, hence we guarantee the rolling transaction will
always fit in the log. The reserve head ensures we never overcommit
the available log space.

The second grant head is the write head, and this tracks the space
immediately available to physically write into the log. This is
essentially tracks the space available for physical writes into the
log. When your write reservation runs out (i.e. after the number of
rolls the  log count in the initial transaction reservation
specifies), we have to regrant physical space for the next
transaction in the rolling chain. If the log is physically full, we
have to wait for physical space to be made available.

The only way to increase the amount of physical space available in
the log is to have the tail move forwards. xfs_trans_reserve() does
that by setting a push target for the AIL to flush all the metadata
older than that target. It then blocks waiting for the tail of the
log to move. When the tail of the log moves, the available write
grant space increases because the log head can now physically move
forwards in the log.

Hence when the log is full and we are in a tail pushing situation,
new transactions wait on the reserve grant head to get the log space
guarantee they require. Long duration rolling transactions already
have a log space guarantee from the reserve grant head, so they
end up waiting for the physical log space they require on the write
grant head.

The tail pinning deadlock rolling transactions can trigger is
against the write grant head, not the reserve grant head. If the
tail of the log cannot move, then the write grant space never
increases and xfs_trans_reserve() blocks forever. Hence we cannot
call xfs_trans_roll() whilst holding items locked that have a high
probability of being at the tail of the log.

Given that this relogging functionality is all about preventing
items from either pinning the tail of the log or disappearing off
the tail of the log because they aren't relogged, we have to be very
careful about holding them locked over operations that require
the AIL to be able to make forwards progress....


> > If it's a single transaction, and we join all the locked items
> > for relogging into it in a single transaction commit, then we are
> > fine - we don't try to regrant log space while holding locked items
> > that could pin the tail of the log.
> > 
> > We *can* use a rolling transaction if we do this - the AIL has a
> > permenant transaction (plus ticket!) allocated at mount time with
> > a log count of zero, we can then steal reserve/write grant head
> > space into it that ticket at CIL commit time as I mentioned
> > previously. We do a loop like above, but it's basically:
> > 
> > {
> > 	LIST_HEAD(tmp);
> > 
> > 	spin_lock(&ailp->ail_lock);
> >         if (list_empty(&ailp->ail_relog_list)) {
> > 		spin_unlock(&ailp->ail_lock);
> > 		return;
> > 	}
> > 
> > 	list_splice_init(&ilp->ail_relog_list, &tmp);
> > 	spin_unlock(&ailp->ail_lock);
> > 
> > 	xfs_ail_relog_items(ail, &tmp);
> > }
> > 
> > This allows the AIL to keep working and building up a new relog
> > as it goes along. hence we can work on our list without interruption
> > or needed to repeatedly take the AIL lock just to get items from the
> > list.
> > 
> 
> Yeah, I was planning splicing the list as such to avoid cycling the lock
> so much regardless..
> 
> > And xfs_ail_relog_items() does something like this:
> > 
> > {
> > 	struct xfs_trans	*tp;
> > 
> > 	/*
> > 	 * Make CIL committers trying to change relog status of log
> > 	 * items wait for us to istabilise the relog transaction
> > 	 * again by committing the current relog list and rolling
> > 	 * the transaction.
> > 	 */
> > 	down_write(&ail->ail_relog_lock);
> > 	tp = ail->relog_trans;
> > 
> > 	while ((lip = list_first_entry_or_null(&ailp->ail_relog_list,
> > 					       struct xfs_log_item,
> > 					       li_trans)) != NULL) {
> >         while (!list_empty(&ailp->ail_relog_list)) {
> > 		lip = list_first_entry(&ailp->ail_relog_list,
> > 					struct xfs_log_item, li_trans);
> > 		list_del_init(&lip->li_trans);
> > 
> > 		xfs_trans_add_item(tp, lip);
> > 		set_bit(XFS_LI_DIRTY, &lip->li_flags);
> > 		tp->t_flags |= XFS_TRANS_DIRTY;
> > 	}
> > 
> > 	error = xfs_trans_roll(&tp);
> > 	if (error) {
> > 		SHUTDOWN!
> > 	}
> > 	ail->relog_trans = tp;
> > 	up_write(&ail->ail_relog_lock);
> > }
> > 
> 
> I think I follow.. The fundamental difference here is basically that we
> commit whatever we locked, right? IOW, the current approach _could_
> technically be corrected, but it would have to lock one item at a time
> (ugh) rather than build up a queue of locked items..?
> 
> The reservation stealing approach facilitates this batching because
> instead of only having a guarantee that we can commit one max sized
> relog item at a time, we can commit however many we have queued because
> sufficient reservation has already been acquired.

Yes.

> That does raise another issue in that we presumably want some kind of
> maximum transaction size and/or maximum outstanding relog reservation
> with the above approach. Otherwise it could be possible for a workload
> to go off the rails without any kind of throttling or hueristics
> incorporated in the current (mostly) fixed transaction sizes.

Possibly, though I really don't have any intuition on how big the
relog reservation could possible grow. Right now it doesn't seem
like there's a space problem (single item!), so perhaps this is
something we can defer until we have some further understanding of
how many relog items are active at any given time?

> Perhaps
> it's reasonable enough to cap outstanding relog reservation to the max
> transaction size and return an error to callers that attempt to exceed

Max transaction size the CIL currently uses for large logs is 32MB.
That's an awful lot of relog items....

> it..? It's not clear to me if that would impact the prospective scrub
> use case. Hmmm.. maybe the right thing to do is cap the size of the
> current relog queue so we cap the size of the relog transaction without
> necessarily capping the max outstanding relog reservation. Thoughts on
> that?

Maybe.

Though this seems like an ideal candidate for a relog reservation
grant head. i.e. the transaction reserve structure we pass to
xfs_trans_reserve() has a new field that contains the relog
reservation needed for this transaction, and we use the existing
lockless grant head accounting infrastructure to throttle relogging
to an acceptible bound...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
