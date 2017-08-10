Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36280 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752091AbdHJOwu (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 10 Aug 2017 10:52:50 -0400
Date: Thu, 10 Aug 2017 10:52:49 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs: hold xfs_buf locked between shortform->leaf
 conversion and the addition of an attribute
Message-ID: <20170810145248.GE3777@bfoster.bfoster>
References: <1502276772-24293-1-git-send-email-alex@zadarastorage.com>
 <20170809213307.GJ21024@dastard>
 <185A1C4516684B439A3711999ABACA79@alyakaslap>
 <20170810113322.GM21024@dastard>
 <63920C3663124B75BC0983A17533395A@alyakaslap>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <63920C3663124B75BC0983A17533395A@alyakaslap>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Alex Lyakas <alex@zadarastorage.com>
Cc: Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org, darrick.wong@oracle.com, libor.klepac@bcom.cz

On Thu, Aug 10, 2017 at 03:09:09PM +0300, Alex Lyakas wrote:
> Hi Dave,
> 
> Thanks for the explanation. So it seems we cannot move forward with this
> fix.
> 

I don't think this completely invalidates the fix.. Dave is pointing out
a flaw that the deferred ops infrastructure doesn't properly handle the
technique we want to use here. IOW, it means there's a dependency that
needs to be implemented first.

FWIW, I also think this means that your approach on the older kernel to
join/hold the buffer to the finished transaction may be the right
approach (depending on whether I follow the perm transaction code
correctly or not, see below), but I think you'd need to relog the buffer
as well.

> Will somebody else in XFS community be working on fixing this issue? As you
> pointed out, it exists for over two decades. Our production systems hit this
> every couple of days, and shutting down the filesystem causes outage.
> 

I'm guessing the defer infrastructure needs to handle relogging a buffer
similar to how it currently handles joining/relogging inodes..?

...
> -----Original Message----- From: Dave Chinner
...
> The problem is that the locked buffer is not joined and logged in
> the rolling transactions run in xfs_defer_ops. Hence it can pin the
> tail of the AIL, and this can prevent the transaction roll from
> regranting the log space necessary to continue rolling the
> transaction for the required number of transactions to complete the
> deferred ops. If this happens, we end up with a log space deadlock.
> 
> Hence if we are holding an item that we logged in a transaction
> locked and we roll the transaction, we have to join, hold and log it
> in each subsequent transaction until we have finished with the item
> and can unlock and release it.
> 
> This is documented in xfs_trans_roll():
> 
>        /*
>         * Reserve space in the log for th next transaction.
>         * This also pushes items in the "AIL", the list of logged items,
>         * out to disk if they are taking up space at the tail of the log
>         * that we want to use.  This requires that either nothing be locked
>         * across this call, or that anything that is locked be logged in
>         * the prior and the next transactions.
>         */
> 

Good catch, though I'm wondering whether it's a real enough problem atm
to block this fix. A few thoughts/questions:

1.) The transaction in this case has a t_log_count of 3, presumably to
cover the commits by the historical bmap_finish, the trans roll and the
final commit. If I'm following the permanent transaction code correctly,
doesn't that mean that we have room for at least 2 rolls (and 3 commits)
before this task would actually block on log reservation? AFAICT it
looks like the commit would dec ticket->t_cnt and replenish the current
log reservation. The subsequent xfs_trans_reserve() would just return if
t_cnt > 0.

This of course doesn't accommodate the fact the xfs_defer_finish() can
now roll a transaction an indeterminate number of times, which probably
needs to be handled in general, but...

2.) It doesn't look like we actually defer any ops in this situation
unless rmapbt is enabled, assuming that we limit holding the buffer to
the empty leaf case, at least (see my comment on the previous version).
I also don't see where a deferred rmapbt update would itself ever roll
the transaction.

3.) The buffer in this case is a new allocation, which I think means the
risk of it pinning the tail and causing a log deadlock here means that
on top of somehow depleting the initial permanent reservation, we'd have
to exhaust the log in the time between the first commit and the last
reservation.

Given the above, it seems reasonably safe enough to me to merge this
change as is and fix up the deferred ops stuff after the fact
(considering we know we need to rework the xattr stuff as such anyways).
This is still a landmine that should be fixed up, but I wouldn't be
against an ASSERT() or something for the time being if we could somehow
verify that the transaction ticket didn't require any extra reservation.

OTOH, just adding deferred ops buffer relogging might not be too much
trouble either. ;) Anyways, thoughts?

Brian

> 
> Cheers,
> 
> Dave.
> 
> -- 
> Dave Chinner
> david@fromorbit.com
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
