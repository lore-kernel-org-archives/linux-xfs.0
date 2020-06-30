Return-Path: <SRS0=3PXQ=AL=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6214C433DF
	for <linux-xfs@archiver.kernel.org>; Tue, 30 Jun 2020 21:51:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 95D052073E
	for <linux-xfs@archiver.kernel.org>; Tue, 30 Jun 2020 21:51:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726362AbgF3VvH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 30 Jun 2020 17:51:07 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:52359 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726242AbgF3VvG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 30 Jun 2020 17:51:06 -0400
Received: from dread.disaster.area (pa49-180-53-24.pa.nsw.optusnet.com.au [49.180.53.24])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 62771820E62;
        Wed,  1 Jul 2020 07:51:03 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jqO9e-0000OK-DB; Wed, 01 Jul 2020 07:51:02 +1000
Date:   Wed, 1 Jul 2020 07:51:02 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 00/30] xfs: rework inode flushing to make inode reclaim
 fully asynchronous
Message-ID: <20200630215102.GM2005@dread.disaster.area>
References: <20200622081605.1818434-1-david@fromorbit.com>
 <20200629230130.GS7606@magnolia>
 <20200630165203.GW7606@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200630165203.GW7606@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=W5xGqiek c=1 sm=1 tr=0
        a=moVtWZxmCkf3aAMJKIb/8g==:117 a=moVtWZxmCkf3aAMJKIb/8g==:17
        a=kj9zAlcOel0A:10 a=_RQrkK6FrEwA:10 a=7-415B0cAAAA:8
        a=h7jDoU0L7_UU2mQYkbgA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 30, 2020 at 09:52:03AM -0700, Darrick J. Wong wrote:
> On Mon, Jun 29, 2020 at 04:01:30PM -0700, Darrick J. Wong wrote:
> > Both of these failure cases have been difficult to reproduce, which is
> > to say that I can't get them to repro reliably.  Turning PREEMPT on
> > seems to make it reproduce faster, which makes me wonder if something in
> > this patchset is screwing up concurrency handling or something?  KASAN
> > and kmemleak have nothing to say.  I've also noticed that the less
> > heavily loaded the underlying VM host's storage system, the less likely
> > it is to happen, though that could be a coincidence.
> > 
> > Anyway, if I figure something out I'll holler, but I thought it was past
> > time to braindump on the mailing list.
> 
> Last night, Dave and I did some live debugging of a failed VM test
> system, and discovered that the xfs_reclaim_inodes() call does not
> actually reclaim all the IRECLAIMABLE inodes.  Because we fail to call
> xfs_reclaim_inode() on all the inodes, there are still inodes in the
> incore inode xarray, and they still have dquots attached.
> 
> This would explain the symptoms I've seen -- since we didn't reclaim the
> inodes, we didn't dqdetach them either, and so the dqpurge_all will spin
> forever on the still-referenced dquots.  This also explains the slub
> complaints about active xfs_inode/xfs_inode_log_item objects if I turn
> off quotas, since we didn't clean those up either.
> 
> Further analysis (aka adding tracepoints) shows xfs_reclaim_inode_grab
> deciding to skip some inodes because IFLOCK is set.  Adding code to
> cycle the i_flags_lock ahead of the unlocked IFLOCK test didn't make the
> symptoms go away, so I instrumented the inode flush "lock" functions to
> see what was going on (full version available here [1]):

[...]

> Bingo!  The xfs_ail_push_all_sync in xfs_unmountfs takes a bunch of
> inode iflocks, starts the inode cluster buffer write, and since the AIL
> is now empty, returns.  The unmount process moves on to calling
> xfs_reclaim_inodes, which as you can see in the last four lines:
> 
>           umount-10409 [001]    44.118882: xfs_reclaim_inode_grab: dev 259:0 ino 0x8a
> 
> This ^^^ is logged at the start of xfs_reclaim_inode_grab.
> 
>           umount-10409 [001]    44.118883: xfs_reclaim_inode_grab_iflock: dev 259:0 ino 0x8a
> 
> This is logged when x_r_i_g observes that the IFLOCK is set and bails out.
> 
>      kworker/2:1-50    [002]    44.118883: xfs_ifunlock:         dev 259:0 ino 0x8a
> 
> And finally this is the inode cluster buffer IO completion calling
> xfs_buf_inode_iodone -> xfs_iflush_done from a workqueue.
> 
> So it seems to me that inode reclaim races with the AIL for the IFLOCK,
> and when unmount inode reclaim loses, it does the wrong thing.

Yeah, that's what I suspected when I finished up yesterday, but I
couldn't quite connect how the AIL wasn't waiting for the inode
completion.

The moment I looked at it again this morning, I realised that it was
simply that xfs_ail_push_all_sync() is woken when the AIL is
emptied, and that happens about 20 lines of code before the flush
lock is dropped, and if the wakeup to the sleeping task is fast
enough, it can be running before the IO completion finishes the
wakeup.

And with a PREEMPT kernel, we might do preempts on wakeup (that was
the path to the scheduler bug we kept hitting), hence increasing the
chance that the unmount task will run before the IO completion
finishes and drops the inode flush lock.

> Questions: Do we need to teach xfs_reclaim_inodes_ag to increment
> @skipped if xfs_reclaim_inode_grab rejects an inode?  xfs_reclaim_inodes
> is the only consumer of the @skipped value, and elevated skipped will
> cause it to rerun the scan, so I think this will work.

No, we just need to get rid of the racy check in
xfs_reclaim_inode_grab(). I'm going to get rid of the whole skipped
thing, too.

> Or, do we need to wait for the ail items to complete after xfsaild does
> its xfs_buf_delwri_submit_nowait thing?

We've already waited for the -AIL items- to complete, and that's
really all we should be doing at the xfs_ail_push_all_sync layer.

The issue is that xfs_ail_push_all_sync() doesn't quite wait for IO
to complete so we've been conflating these two different operations
for a long time (essentially since we moved to logging everything
and tracking all dirty metadata in the AIL). In general, they mean
the same thing, but in this specific corner case the subtle
distinction actually matters.

It's easy enough to avoid - just get rid of what, independently,
this patchset makes a questionable optimisation in
xfs_reclaim_inode_grab(). i.e we no longer block reclaim on locks
and so optimisations to avoid blocking on locks....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
