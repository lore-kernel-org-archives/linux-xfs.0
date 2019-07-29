Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:39484 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389134AbfG2V6J (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 29 Jul 2019 17:58:09 -0400
Date: Tue, 30 Jul 2019 07:56:57 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs: garbage file data inclusion bug under memory pressure
Message-ID: <20190729215657.GI7777@dread.disaster.area>
References: <804d24cb-5b7c-4620-5a5f-4ec039472086@i-love.sakura.ne.jp>
 <20190725220726.GW7689@dread.disaster.area>
 <201907290350.x6T3oBpj009459@www262.sakura.ne.jp>
 <20190729112335.GA23942@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190729112335.GA23942@bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, linux-xfs@vger.kernel.org

On Mon, Jul 29, 2019 at 07:23:35AM -0400, Brian Foster wrote:
> On Mon, Jul 29, 2019 at 12:50:11PM +0900, Tetsuo Handa wrote:
> > Dave Chinner wrote:
> > > > > But I have to ask: what is causing the IO to fail? OOM conditions
> > > > > should not cause writeback errors - XFS will retry memory
> > > > > allocations until they succeed, and the block layer is supposed to
> > > > > be resilient against memory shortages, too. Hence I'd be interested
> > > > > to know what is actually failing here...
> > > > 
> > > > Yeah. It is strange that this problem occurs when close-to-OOM.
> > > > But no failure messages at all (except OOM killer messages and writeback
> > > > error messages).
> > > 
> > > Perhaps using things like trace_kmalloc and friends to isolate the
> > > location of memory allocation failures would help....
> > > 
> > 
> > I checked using below diff, and confirmed that XFS writeback failure is triggered by ENOMEM.
> > 
> > When fsync() is called, xfs_submit_ioend() is called. xfs_submit_ioend() invokes
> > xfs_setfilesize_trans_alloc(), but xfs_trans_alloc() fails with -ENOMEM because
> > xfs_log_reserve() from xfs_trans_reserve() fails with -ENOMEM because
> > xlog_ticket_alloc() is using KM_SLEEP | KM_MAYFAIL which is mapped to
> > GFP_NOFS|__GFP_NOWARN|__GFP_RETRY_MAYFAIL|__GFP_COMP which will fail under close-to-OOM.
> > 
> > As a result, bio_endio() is immediately called due to -ENOMEM, and
> > xfs_destroy_ioend() from xfs_end_bio() from bio_endio() is printing
> > writeback error message due to -ENOMEM error.
> > (By the way, why not to print error code when printing writeback error message?)
> > 
> > ----------------------------------------
> 
> Ah, that makes sense. Thanks for tracking that down Tetsuo. For context,
> it looks like that flag goes back to commit eb01c9cd87 ("[XFS] Remove
> the xlog_ticket allocator") that replaces some old internal ticket
> allocation mechanism (that I'm not familiar with) with a standard kmem
> cache.
> 
> ISTM we can just remove that KM_MAYFAIL from ticket allocation. We're
> already in NOFS context in this particular caller (writeback), though
> that's probably not the case for most other transaction allocations. If
> we had a reason to get more elaborate, I suppose we could conditionalize
> use of the KM_MAYFAIL flag and/or lift bits of ticket allocation to
> earlier in xfs_trans_alloc(), but it's not clear to me that's necessary.
> Dave?

That's a long time ago, and it predates the pre-allocation of
transactions for file size updates in IO submission. The log ticket
rework is irrelevant - it was just an open-coded slab allocator - it
was the fact it handled allocation failure that mattered. That was
done at the time because we were slowly reducing the number of
blocking allocations at the time - trying to reduce the reliance on
looping until allocation succeeds - so MAYFAIL was used for quite a
lot of new allocations at the time.

This is perfectly fine for transactions in syscall context - if we
don't have memory available for the log ticket, we may as well give
up now before we really start creating memory demand and getting
into a state where we are half way through a transaction and
completely out of memory and can't go forwards or backwards.

The trans alloc/trans reserve/log reserve code was somewhat
different back then, as was the writeback code. I suspect it dates
back to when we had trylock semantics in writeback and so memory
allocation errors like this would have simply redirtied the page and
it was tried again later. Hence, historically, I don't think this
was an issue, either.

Hence the code has morphed so much since then I don't think we can
"blame" this commit for introducing this problem. I looks more like
we have removed all the protection it had as we've simplified the
writeback and transaction allocation/reservation code over time, and
now it's exposed directly in writeback.

----

As for how to fix it, I'd just remove KM_MAYFAIL. We've just done a
transaction allocation with just KM_SLEEP, so we may as well do the
same for the log ticket....

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com
