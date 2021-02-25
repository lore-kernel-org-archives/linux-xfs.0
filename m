Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 546E5C433E6
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Feb 2021 22:03:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0F8BA64EBA
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Feb 2021 22:03:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232349AbhBYWD5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 Feb 2021 17:03:57 -0500
Received: from mail107.syd.optusnet.com.au ([211.29.132.53]:45317 "EHLO
        mail107.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230010AbhBYWDv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Feb 2021 17:03:51 -0500
Received: from dread.disaster.area (pa49-179-130-210.pa.nsw.optusnet.com.au [49.179.130.210])
        by mail107.syd.optusnet.com.au (Postfix) with ESMTPS id A6DB8FA6E5D;
        Fri, 26 Feb 2021 09:03:06 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lFOiv-004K44-5u; Fri, 26 Feb 2021 09:03:05 +1100
Date:   Fri, 26 Feb 2021 09:03:05 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3] xfs: AIL needs asynchronous CIL forcing
Message-ID: <20210225220305.GO4662@dread.disaster.area>
References: <20210223053212.3287398-1-david@fromorbit.com>
 <20210223053212.3287398-3-david@fromorbit.com>
 <20210224211058.GA4662@dread.disaster.area>
 <YDeiLOdFhIMJegWZ@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YDeiLOdFhIMJegWZ@bfoster>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0 cx=a_idp_d
        a=JD06eNgDs9tuHP7JIKoLzw==:117 a=JD06eNgDs9tuHP7JIKoLzw==:17
        a=kj9zAlcOel0A:10 a=qa6Q16uM49sA:10 a=7-415B0cAAAA:8
        a=wyrrEKL2HN31nzOLitUA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Feb 25, 2021 at 08:12:12AM -0500, Brian Foster wrote:
> On Thu, Feb 25, 2021 at 08:10:58AM +1100, Dave Chinner wrote:
> > On Tue, Feb 23, 2021 at 04:32:11PM +1100, Dave Chinner wrote:
> > The problem being tripped over here is that we no longer force the
> > final iclogs in a CIL push to disk - we leave the iclog with the
> > commit record in it in ACTIVE state, and by not waiting and forcing
> > all the iclogs to disk, the buffer never gets unpinned because there
> > isn't any more log pressure to force it out because everything is
> > blocked on reservation space.
> > 
> > The solution to this is to have the CIL push change the state of the
> > commit iclog to WANT_SYNC before it is released. This means the CIL
> > push will always flush the iclog to disk and the checkpoint will
> > complete and unpin the buffers.
> > 
> > Right now, we really only want to do this state switch for these
> > async pushes - for small sync transactions and fsync we really want
> > the iclog aggregation that we have now to optimise iclogbuf usage,
> > so I'll have to pass a new flag through the push code and back into
> > xlog_write(). That will make this patch behave the same as we
> > currently do.
> > 
> 
> Unfortunately I've not yet caught up to reviewing your most recently
> posted set of log patches so I can easily be missing some context, but
> when passing through some of the feedback/updates so far this has me
> rather confused. We discussed this pre-existing CIL behavior in the
> previous version, I suggested some similar potential behavior change
> where we would opportunistically send off checkpoint iclogs for I/O a
> bit earlier than normal and you argued [1] against it. Now it sounds
> like not only are we implementing that, but it's actually necessary to
> fix a log hang problem..? What am I missing?

You're talking about this comment?

| > That means there's an increased chance that
| > the next iclog in the ring may be active. Perhaps we could introduce
| > some logic to switch out the commit record iclog before the CIL push
| > returns in those particular cases.  For example, switch out if the
| > current checkpoint hit multiple iclogs..? Or hit multiple iclogs and the
| > next iclog in the ring is clean..?
|
| We could just call xlog_state_switch_iclogs() to mark it WANT_SYNC,
| but then we can't aggregate more changes into it and fill it up. If
| someone starts waiting on that iclog (i.e. a log force), then it
| immediately gets marked WANT_SYNC and submitted to disk when it is
| released. But if there is no-one waiting on it, then we largely
| don't care if an asynchronous checkpoint is committed immediately,
| at the start of the next checkpoint, or at worst, within 30s when
| the log worker next kicks a log force....

I'm arguing against the general case here of submitting iclog
buffers with checkpoints in them early. THere is no reason to do that
because the xfs_log_force() code will kick the iclog to disk if
necessary. That still stands - I have not changed behaviour
unconditionally.

This patch only kicks the commit_iclog to disk if the cause of the
CIL push was an async call to xlog_cil_force_seq(). That can occur
from xfs_iunpin() and, with this patch, the AIL.

In both cases, all they care about is that the CIL checkpoint fully
completes in the near future. For xfs_iunpin(), the log force
doesn't guarantee the inode is actually unpinned, hence it waits on
the pin count and not the log force. So waiting for the CIL push is
unnecessary as long as the CIL push gets the entire checkpoint to
disk.

Similarly, the AIL only needs the log force to guarantee the CIL
commits to disk in the near future, but it does not need to block
waiting for that to occur.

So in these cases, we don't want to block while the CIL is pushing
just so the log force code can iterate the last iclog the CIL wrote
to flush it to disk. Instead, we pass a flag to the CIL to tell it
"you need to push the commit record to disk" so we don't have to
wait for it to then check if it pushed the commit record or not.
This is a special case, not the general case where we are running
lots of fsync or sync transactions.

In the general case, we are trying to aggregate as many sync
transactions/fsync log forces as possible into the current iclog to
batch them up effectively. We'll continue to batch them while there
is space in the current iclog and the previous iclog is in the
WANT_SYNC/SYNCING state indicating it is still being written to
disk.

This automated batching behaviour of the iclog state machine is one
of the reasons XFS has always had excellent performance under
synci transaction/fsync heavy workloads such as NFS/CIFS servers. It
is functionality we need to preserve, and this patch does not
actually change that behaviour.

> The updated iclog behavior does sound more friendly to me than what we
> currently do (obviously, based on my previous comments),

As per above, the conditional behaviour I've added here is actually
less friendly :)

> but I am
> slightly skeptical of how such a change fixes the root cause of a hang.
> Is this a stall/perf issue or an actual log deadlock? If the latter,
> what prevents this deadlock on current upstream?

The problem that I talk about is introduced by this patch and also
fixed by this patch. The problem does not exist until we have code
that depends on an async CIL push guaranteeing that items in the CIL
are unpinned. A stock xfs_log_force_seq(0) call guarantees that the
log reaches disk by waiting on the CIL push then pushing the iclogs.
All it does is elide waiting for the final iclogs to hit the disk.

By eliding the "wait for CIL push" in an async xfs_log_force_seq()
call, we also elide the "push iclogs" part of the log force and
that's what causes the AIL problem. We don't push the iclogs, so the
items committed to the last iclog don't get dispatched and the items
never get unpinned because the checkpoint never completes.

So this "AIL can hang because tail items aren't unpinned" condition
is exposed by async CIL forces. It is also fixed by this patch
passing the async push state to the CIL push and having it ensure
that the commit iclog if written out if the CIL push was triggered
by an async push.

Like all log forces, async pushes are rare, but we have to ensure
tehy behave correctly. There is no bug in the code before this
patch, and there is no bug in the code (that I know of) after this
patch. I've described a condition that we have to handle in this
patch that, if we don't, we end up with broken AIL pushing.

As to the "root cause of the hang" I now know what that is too, but
addressing it is outside the scope of this patchset. It's taken me a
long time to identify this, but I've been seeing symptoms of it for
quite a long time (i.e. years) but until doing this async CIL push
work I've never been able to identify the cause.

That is, the root cause is that the AIL cannot force a pinned buffer
to disk, and a log force (of any kind) does not guarantee a pinned
item is unpinned. That's because the CIL is pipelined, meaning that
an item can be pinned in one CIL context, and while that is being
pushed, the front end can relog that same item and pin it in the
current CIL context. Hence it has two pins, not one. Now when the
original log force completes, the pin from the first CIL context has
been removed, but the pin from the current CIL context is still
present.

Hence when we are relogging buffers over time (e.g. repeatedly
modifying a directory), the AIL always sees the buffer pinned and
cannot flush it. Even if the buffer has been moved to the delwri
list (i.e. had a successful push) we still can't write it out
because the delwri code skips pinned buffers.

This iterative pin continues preventing the AIL from flushing the
buffer until it pins the tail of the log. When the log runs out of
space and blocks the modifying/relogging task(s), the log force the
AIL issues allows the CIL to be pushed without the front end
relogging the item and re-pinning the item. At the completion of the
log force, the AIL can now push the unpinned buffer and hence move
the tail of the log forward which frees up log reservation space.
This then wakes the front end, which goes back to it's relogging
game and the cycle repeats over.

This is really nasty behaviour, and it's only recently that I've got
a handle on it. I found it because my original "async CIL push" code
resulted in long stalls every time the log is filled and the tail is
pinned by a buffer that is being relogged in this manner....

I'm not sure how to fix this yet - the AIL needs to block the front
end relogging to allow the buffer to be unpinned. Essentially, we
need to hold the pinned items locked across a CIL push to guarantee
they are unpinned, but that's the complete opposite of what the AIL
currently does to prevent the front end from seeing long tail lock
latencies when modifying stuff....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
