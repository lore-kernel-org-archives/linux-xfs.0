Return-Path: <SRS0=1kUG=AT=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0107AC433DF
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Jul 2020 23:33:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D627F20772
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Jul 2020 23:33:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725978AbgGHXdS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 8 Jul 2020 19:33:18 -0400
Received: from mail110.syd.optusnet.com.au ([211.29.132.97]:56430 "EHLO
        mail110.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725903AbgGHXdS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Jul 2020 19:33:18 -0400
Received: from dread.disaster.area (pa49-180-53-24.pa.nsw.optusnet.com.au [49.180.53.24])
        by mail110.syd.optusnet.com.au (Postfix) with ESMTPS id E6AD610952E;
        Thu,  9 Jul 2020 09:33:12 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jtJYt-0001E3-3p; Thu, 09 Jul 2020 09:33:11 +1000
Date:   Thu, 9 Jul 2020 09:33:11 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Gao Xiang <hsiangkao@redhat.com>
Cc:     linux-xfs@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Brian Foster <bfoster@redhat.com>
Subject: Re: [RFC PATCH 2/2] xfs: don't access AGI on unlinked inodes if it
 can
Message-ID: <20200708233311.GP2005@dread.disaster.area>
References: <20200707135741.487-1-hsiangkao@redhat.com>
 <20200707135741.487-3-hsiangkao@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200707135741.487-3-hsiangkao@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=W5xGqiek c=1 sm=1 tr=0
        a=moVtWZxmCkf3aAMJKIb/8g==:117 a=moVtWZxmCkf3aAMJKIb/8g==:17
        a=kj9zAlcOel0A:10 a=_RQrkK6FrEwA:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=sc2a0R8DroK2ncfLlO8A:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jul 07, 2020 at 09:57:41PM +0800, Gao Xiang wrote:
> Currently, we use AGI buffer lock to protect in-memory linked list for
> unlinked inodes but since it's not necessary to modify AGI unless the
> head of the unlinked list is modified. So let's removing the AGI buffer
> modification dependency if possible, including 1) adding another per-AG
> dedicated lock to protect the whole list and 2) inserting unlinked
> inodes from tail.
> 
> For 2), the tail of bucket 0 is now recorded in perag for xfs_iunlink()
> to use. xfs_iunlink_remove() still support old multiple short bucket
> lists for recovery code.

I would split this into two separate patches. One to move to a perag
based locking strategy, another to change from head to tail
addition as they are largely independent algorithmic changes.

> Note that some paths take AGI lock in its transaction in advance,
> so the proper locking order is only AGI lock -> unlinked list lock.

These paths should be documented in the commit message as well
as in code comments so the reviewer is aware of those code paths
and can verify that your assumptions about locking order are
correct.

> 
> Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
> ---
>  fs/xfs/xfs_inode.c       | 251 ++++++++++++++++++++-------------------
>  fs/xfs/xfs_log_recover.c |   6 +
>  fs/xfs/xfs_mount.c       |   3 +
>  fs/xfs/xfs_mount.h       |   3 +
>  4 files changed, 144 insertions(+), 119 deletions(-)
> 
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 10565fa5ace4..d33e5b198534 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -1994,182 +1994,195 @@ xfs_iunlink_update_bucket(
>  }
>  
>  /*
> - * Always insert at the head, so we only have to do a next inode lookup to
> - * update it's prev pointer. The AGI bucket will point at the one we are
> - * inserting.
> + * This is called when the inode's link count has gone to 0 or we are creating
> + * a tmpfile via O_TMPFILE.  The inode @ip must have nlink == 0.
> + *
> + * We place the on-disk inode on a list in the AGI.  It will be pulled from this
> + * list when the inode is freed.
>   */
> -static int
> -xfs_iunlink_insert_inode(

Hmmm. Flattening the code also make the patch harder to follow as it
combines code movement/rearrangement with algorithmic changes.  We
try to separate out code movement/rearrangement into their own
patches so that the movement is easy to verify by itself.

Also, the helper functions help document the separation of the
unlinked list manipulations from the from setup and locking
requirements for the list manipulations, and this largely undoes all
that. I added these helpers because it completely untangled the mess
that was present before the RFC patchset I posted. THat is, I
couldn't easily modify the existing code because it interleaved
the locking, the backref hash manipulations and
the on-disk list manipulations in ways I found difficult to
understand and manage. Short, simple, clear functions are much
better than long, multiple operation functions...

i.e. this:

xfs_iunlink()
{

	get locks
	do list insert
	drop locks
}

Is better for understanding, maintenance and future modification
than:

xfs_iunlink()
{

	get perag
	lock perag
	look at tail of list
	if (empty) {
		unlock perag
		read/lock AGI
		lock perag
		look at tail of list
		if (empty)
			do head insert
			goto out
	}
	do tail insert
out:
	update inode/pag tails
	unlock
	drop perag
}

It's trivial for a reader to understand what the first version of
xfs_iunlink() is going to do without needing to understand the
intraccies of the locking strategies. However, it takes time and
effort to undestand exactly waht the second one is doing because
it's not clear where lock ends and list modifications start, nor
what the locking rules are for the different modifications that are
being made. Essentially, it goes back to the complex
locking-intertwined-with-modification-algorithm problem the current
TOT code has.

I'd much prefer to see something like this:

/*
 * Inode allocation in the O_TMPFILE path defines the AGI/unlinked
 * list lock order as being AGI->perag unlinked list lock. We are
 * inverting it here as the fast path tail addition does not need to
 * modify the AGI at all. Hence we only need the AGI lock if the
 * tail is empty, but if we fail to get it without blocking then we
 * need to fall back to the slower, correct lock order.
 */
xfs_iunlink_insert_lock()
{
	get perag;
	lock_perag();
	if (!tail empty)
		return;
	if (trylock AGI)
		return;

	/*
	 * Slow path, need to lock AGI first. Don't even bother
	 * rechecking tail pointers or trying to optimise for
	 * minimal AGI lock hold time as racing unlink list mods
	 * will all block on the perag lock once we take that. They
	 * will then hit the !tail empty fast path and not require
	 * the AGI lock at all.
	 */
	lock AGI
	lock_perag()
	return;
}

The non-AGI locking fast path is slightly different in the remove
case, so we'll have a slightly different helper function in that
case which checks where the inode being removed is in the list.

In both cases, though, the unlock should be the same:

xfs_iunlink_unlock()
{
	/* Does not unlock AGI, ever. commit does that. */
	unlock perag
	put perag
}

This keeps the list locking completely separate from the list
manipulations and allows us to document the locking constraints and
reasons for why it is or isn't optimised for specific conditions
without cluttering up the list manipulations code.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
