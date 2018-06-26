Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:42494 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S933794AbeFZL2K (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 26 Jun 2018 07:28:10 -0400
Date: Tue, 26 Jun 2018 07:28:08 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] [RFC] writeback: fix range_cyclic writeback vs
 writepages deadlock
Message-ID: <20180626112807.GA40537@bfoster>
References: <20180622030941.25544-1-david@fromorbit.com>
 <20180622144109.GA9935@bfoster>
 <20180625222723.GZ19934@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180625222723.GZ19934@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org

On Tue, Jun 26, 2018 at 08:27:23AM +1000, Dave Chinner wrote:
> On Fri, Jun 22, 2018 at 10:41:10AM -0400, Brian Foster wrote:
> > On Fri, Jun 22, 2018 at 01:09:41PM +1000, Dave Chinner wrote:
> > > From: Dave Chinner <dchinner@redhat.com>
> > > 
> > > We've recently seen a workload on XFS filesystems with a repeatable
> > > deadlock between background writeback and a multi-process
> > > application doing concurrent writes and fsyncs to a small range of a
> > > file.
> 
> [...]
> 
> > > #2 is simple, and I don't think it will have any impact on
> > > performance as going back to the start of the file implies an
> > > immediate seek. We'll have exactly the same number of seeks if we
> > > switch writeback to another inode, and then come back to this one
> > > later and restart from index 0.
> > > 
> > > #2a is pretty much "status quo without the deadlock". Moving the
> > > retry loop up into the wcp caller means we can issue IO on the
> > > pending pages before calling wcp again, and so avoid locking or
> > > waiting on pages in the wrong order. I'm not convinced we need to do
> > > this given that we get the same thing from #2 on the next writeback
> > > call from the writeback infrastructure.
> > > 
> > > #3 is really just a band-aid - it doesn't fix the access/wait inversion
> > > problem, just prevents it from becoming a deadlock situation. I'd
> > > prefer we fix the inversion, not sweep it under the carpet like
> > > this.
> > > 
> > > #3a is really an optimisation that just so happens to include the
> > > band-aid fix of #3.
> > > 
> > > So I'm really tending towards #2 as the simplest way to fix this,
> > > and that's what's the patch below implements.
> > > 
> > > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > > ---
> > 
> > FWIW, this seems like a reasonable approach to me. One thing I'm not
> > sure about is whether the higher level plug in wb_writeback() could
> > cause the same problem even with the lower level cycle restart out of
> > the picture.
> 
> Plugging can't cause this because it captures bios that have
> been released from the caller context vi submit_bio(). The plug list
> has hooks in the scheduler that flush it on context switch precisely
> so that we don't get deadlock problems with bios being stuck on the
> plug list when we block for some reason.
> 

Ah, right..

> > It looks to me that if the inode still has dirty pages after the
> > write_cache_pages(), it ends up on wb->b_more_io via
> > writeback_sb_inodes() -> requeue_inode(). The caller (wb_writeback())
> > repopulates ->b_io from ->b_more_io (via queue_io()) if the former is
> > empty (and we haven't otherwise stopped) before finishing the plug.
> > There is a blk_flush_plug() in writeback_sb_inodes(), but that appears
> > to be non-deterministic. That call aside, could that plug effectively
> > hold the page in writeback long enough for background writeback to spin
> > around and sit on the page 1 lock?
> 
> Right, that could happen, but the plug list will be flushed before
> we context switch away and sleep after failng to get the page lock,
> so there's no problem here.
> 

Got it, thanks!

Brian

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
