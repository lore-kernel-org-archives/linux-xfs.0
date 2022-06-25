Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B7A8C43334
	for <linux-xfs@archiver.kernel.org>; Sat, 25 Jun 2022 01:04:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229912AbiFYBEC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 24 Jun 2022 21:04:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229757AbiFYBEB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 24 Jun 2022 21:04:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 433572725
        for <linux-xfs@vger.kernel.org>; Fri, 24 Jun 2022 18:03:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D0A78B82C96
        for <linux-xfs@vger.kernel.org>; Sat, 25 Jun 2022 01:03:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FFEFC34114;
        Sat, 25 Jun 2022 01:03:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656119036;
        bh=mNlcZvq5ANvGAJ5yqpaulpPux7zj+DlwBskp/3/Mr9g=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tlu9Co7S8zbqMRptRi+K/ER0EJBxu3OGXQxFFm8xBaq03UN1eChzFmOrj2tMAxKU/
         ssDXZJmmBujJl2MUB3QHXv82HnI+aea48QtL+lqUZm6JPaMzz9UzgxyfSE8plB5Mca
         zP9MRnThAXXxwf9ECwTiwh4YETH/NnpLm0JWjEE3oNJIM32b3iJXdZGwvP3kC+8KeR
         7tOxloXSn7Jbx3gwMCiuJIYCIISHFf41gFfZHSxBYdlG2BeuBQsrBBv4IfJd4vnSyZ
         rXk4L4muVJarOjDkcxpWdBxzUjW2tJITO2w80V96DDNn7GTZDE0K2g1aNSse4JOVau
         tEF9Xghr7qkfA==
Date:   Fri, 24 Jun 2022 18:03:55 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: bound maximum wait time for inodegc work
Message-ID: <YrZe+54PN5exLOLZ@magnolia>
References: <20220615220416.3681870-1-david@fromorbit.com>
 <20220615220416.3681870-2-david@fromorbit.com>
 <YqytHuc/sJprFn0K@bfoster>
 <20220617215245.GH227878@dread.disaster.area>
 <YrKmrgJh9+SzT0Gz@magnolia>
 <YrM/woFhObNYQx3b@bfoster>
 <YrOzAPXCcDY9DnCj@magnolia>
 <YrRTWoEZys3DfPW8@bfoster>
 <YrTFePWaarPl8eNP@magnolia>
 <YrWwhGMlXMj6DqsI@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YrWwhGMlXMj6DqsI@bfoster>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jun 24, 2022 at 08:39:32AM -0400, Brian Foster wrote:
> On Thu, Jun 23, 2022 at 12:56:40PM -0700, Darrick J. Wong wrote:
> > On Thu, Jun 23, 2022 at 07:49:46AM -0400, Brian Foster wrote:
> > > On Wed, Jun 22, 2022 at 05:25:36PM -0700, Darrick J. Wong wrote:
> > > > On Wed, Jun 22, 2022 at 12:13:54PM -0400, Brian Foster wrote:
> > > > > On Tue, Jun 21, 2022 at 10:20:46PM -0700, Darrick J. Wong wrote:
> > > > > > On Sat, Jun 18, 2022 at 07:52:45AM +1000, Dave Chinner wrote:
> > > > > > > On Fri, Jun 17, 2022 at 12:34:38PM -0400, Brian Foster wrote:
> > > > > > > > On Thu, Jun 16, 2022 at 08:04:15AM +1000, Dave Chinner wrote:
> > > > > > > > > From: Dave Chinner <dchinner@redhat.com>
> > > > > > > > > 
> > > > > > > > > Currently inodegc work can sit queued on the per-cpu queue until
> > > > > > > > > the workqueue is either flushed of the queue reaches a depth that
> > > > > > > > > triggers work queuing (and later throttling). This means that we
> > > > > > > > > could queue work that waits for a long time for some other event to
> > > > > > > > > trigger flushing.
> > > > > > > > > 
> > > > > > > > > Hence instead of just queueing work at a specific depth, use a
> > > > > > > > > delayed work that queues the work at a bound time. We can still
> > > > > > > > > schedule the work immediately at a given depth, but we no long need
> > > > > > > > > to worry about leaving a number of items on the list that won't get
> > > > > > > > > processed until external events prevail.
> > > > > > > > > 
> > > > > > > > > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > > > > > > > > ---
> > > > > > > > >  fs/xfs/xfs_icache.c | 36 ++++++++++++++++++++++--------------
> > > > > > > > >  fs/xfs/xfs_mount.h  |  2 +-
> > > > > > > > >  fs/xfs/xfs_super.c  |  2 +-
> > > > > > > > >  3 files changed, 24 insertions(+), 16 deletions(-)
> > > > > > > > > 
> > > > > > > > > diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> > > > > > > > > index 374b3bafaeb0..46b30ecf498c 100644
> > > > > > > > > --- a/fs/xfs/xfs_icache.c
> > > > > > > > > +++ b/fs/xfs/xfs_icache.c
> > > > > > > > ...
> > > > > > > > > @@ -2176,7 +2184,7 @@ xfs_inodegc_shrinker_scan(
> > > > > > > > >  			unsigned int	h = READ_ONCE(gc->shrinker_hits);
> > > > > > > > >  
> > > > > > > > >  			WRITE_ONCE(gc->shrinker_hits, h + 1);
> > > > > > > > > -			queue_work_on(cpu, mp->m_inodegc_wq, &gc->work);
> > > > > > > > > +			mod_delayed_work_on(cpu, mp->m_inodegc_wq, &gc->work, 0);
> > > > > > > > >  			no_items = false;
> > > > > > > > >  		}
> > > > > > > > 
> > > > > > > > This all seems reasonable to me, but is there much practical benefit to
> > > > > > > > shrinker infra/feedback just to expedite a delayed work item by one
> > > > > > > > jiffy? Maybe there's a use case to continue to trigger throttling..?
> > > > > > > 
> > > > > > > I haven't really considered doing anything other than fixing the
> > > > > > > reported bug. That just requires an API conversion for the existing
> > > > > > > "queue immediately" semantics and is the safest minimum change
> > > > > > > to fix the issue at hand.
> > > > > > > 
> > > > > > > So, yes, the shrinker code may (or may not) be superfluous now, but
> > > > > > > I haven't looked at it and done analysis of the behaviour without
> > > > > > > the shrinkers enabled. I'll do that in a completely separate
> > > > > > > patchset if it turns out that it is not needed now.
> > > > > > 
> > > > > > I think the shrinker part is still necessary -- bulkstat and xfs_scrub
> > > > > > on a very low memory machine (~560M RAM) opening and closing tens of
> > > > > > millions of files can still OOM the machine if one doesn't have a means
> > > > > > to slow down ->destroy_inode (and hence the next open()) when reclaim
> > > > > > really starts to dig in.  Without the shrinker bits, it's even easier to
> > > > > > trigger OOM storms when xfs has timer-delayed inactivation... which is
> > > > > > something that Brian pointed out a year ago when we were reviewing the
> > > > > > initial inodegc patchset.
> > > > > > 
> > > > > 
> > > > > It wouldn't surprise me if the infrastructure is still necessary for the
> > > > > throttling use case. In that case, I'm more curious about things like
> > > > > whether it's still as effective as intended with such a small scheduling
> > > > > delay, or whether it still might be worth simplifying in various ways
> > > > > (i.e., does the scheduling delay actually make a difference? do we still
> > > > > need a per cpu granular throttle? etc.).
> > > > 
> > > > It can still be useful for certain g*dawful scenarios --
> > > > 
> > > > Let's say you have a horribly misconfigured cloudy system with a tiny
> > > > log, hundreds of CPUs, a memory hogging process, another process with
> > > > many hundreds of threads that are performing small appending synchronous
> > > > writes to a large number of files, and some other process repeatedly
> > > > opens and closes files.  Background writeback completion will create
> > > > enough workers to tie up the log such that writeback and inodegc contend
> > > > for log grant space and make slow progress.  If memory is also tight,
> > > > we want to slow down the file scanning process so that it doesn't shove
> > > > /more/ inodes into the cache and push the system towards OOM behavior.
> > > > 
> > > 
> > > Yeah, I get the general idea/purpose of the throttling. What I'm probing
> > > at here is whether a case like this is still handled effectively with
> > > such a short scheduling delay.
> > 
> > Given the trace_xfs_inodegc_shrinker_* data I've collected on my
> > simulator, I think the 1 jiffy delay is handling this well enough that
> > we only trip that tracepoint about a half dozen times in 2h of trying to
> > exercising the inode caches.  That said, I haven't really had time to
> > try this on (say) a 20CPU machine with ridiculously small memory to see
> > if I get different results.
> > 
> > (Note: I'm still trying to figure out why generic/522 reports
> > corruption, and hoping that willy's folios pull today just fixes it
> > magically...)
> > 
> > > Presumably there is some window before
> > > list size based throttling triggers for which the shrinker is expected
> > > to cover, so that implies the shrinker historically is able to detect
> > > and push populated queues and trigger throttling from the point it is
> > > invoked (whether directly via repeated shrinker invocations or
> > > indirectly via causing larger queue sizes is not clear to me).
> > 
> > Back when I merged the inodegc series, it was fairly easy to get the
> > shrinker to trip dozens of times during a stress run, even when the only
> > throttling criteria was the queue size.  I think the reflink/rmap
> > transaction reservation optimizations have made the log grant
> > bottlenecks much less severe, since I now see a lot less contention on
> > the grant heads.
> > 
> > > The thing that stands out to me as a question wrt to this change is that
> > > the trigger for shrinker induced throttling is the list size at the time
> > > of the callback(s), and that goes from having a lifecycle associated
> > > with the size-oriented scheduling algorithm to a time-based scheduling
> > > lifecycle of one jiffy (also noting that the inodegc worker resets
> > > shrinker_hits before it begins to process inodes). So with that in mind,
> > > how reliable is this lowmem signal based on the list size back to the
> > > tasks creating more work and memory pressure? Once a shrinker invocation
> > > occurs, what are the odds that the callback is able to detect a
> > > populated list and act accordingly?
> > 
> > Hrmmm.  Decent, I think?  If the list is populated but the inactivation
> > worker is not running, then we queue the worker and clear the list; if
> > the worker is already running when the shrinker gets called, we might
> > end up requeuing it unnecessarily, in which case it'll just clear more.
> > 
> 
> Sure, that sounds harmless, but I was thinking more about the likelihood
> of missing throttles than spurious work cycles and such..
> 
> Generally with this change, the worker is pretty much always scheduled
> once an inode is queued. It executes once a tick passes where another
> destroy hasn't otherwise come along to kick it out by another tick. So
> if I run a sustained removal, I see similar batching/scheduling as since
> before this change. If I run something with a mix of removes and
> $something_else, then it doesn't seem to take much to skip batching and
> run a worker cycle per inode.
> 
> So what happens if the shrinker scan sees one or more workers that

Er... by "shrinker scan", do you mean xfs_inodegc_shrinker_count?
And by "scan callback", do you mean xfs_inodegc_shrinker_scan?

> happen to execute before the scan callback is able to actually trigger
> throttling? Is that critical, or is this enough of a fallback mechanism
> that it's unlikely to be important?

I /think/ it's possible to miss throttling opportunities, but I also
suspect it's relatively unimportant because of the low maximum queue
size.

Let's say _count runs, discovers non-empty lists, and triggers the
callback.  If the workers run after _count returns but before _scan gets
a chance to run, then they'll have processed the queued inodes and _scan
won't set shrinker_hits anywhere.  Yes, a _destroy_inode won't get
throttled, but the system is at least making some forward progress
clearing the backlog and (hopefully) freeing memory.

If there are a /lot/ of destroy_inode calls, they'll eventually hit the
queue size limit (32) and throttle on the workers.  If there aren't any
further destroy_inode calls, there's nothing to throttle.  If however
there's some destroy_inode calls but not enough to hit the queue limit,
then I suppose we're reliant on the shrinker to get called again.  This
is of course trivially satisfied if there are other processes that also
enter the shrinker code and trigger more scans.

However, I suppose there /is/ a small hole here -- if there was only
that one process in the shrinker and _scan doesn't find anything, the
shrinker will not call us back.  In that case, the only way we trigger
throttling is if there's enough destroy_inode activity to hit a queue
limit.

Dave and I have talked about closing this hole by queuing the worker
immediately if the inode being destroyed has more than a certain number
of extents or something that acts as a proxy for memory consumption, but
so far as we can tell, shrinker invocations are rare and missed
throttling hasn't shown up in a noticeable way.

> Similarly if one is running a
> workload that results in behavior as described above, is this sort of
> "oneshot shrinker to worker throttle" actually still going to slow down
> the worker tasks? Is shrinker callback frequency high enough to actually
> make an impact? Etc.

It seems to, but with a smallish sample size on a normal system, which
means I've only seen the shrinker throttle show up in the trace output
if I use the insane lowmem scenario or artificially crank up the delay
to 30 seconds.  The good news is that in those scenarios, it /does/ slow
things down enough that we mostly don't OOM.

(Though at this point it's really hard to go back for an apples-apples
comparison with the pre-inodegc code.)

> These are questions I don't really have enough context to answer atm,
> nor can say whether or not may result in problems...
> 
> > > These questions are somewhat rhetorical because this all seems rather
> > > unpredictable when we consider varying resource availability.
> > 
> > Not to mention the shrinker itself undergoing various behavioral changes
> > over the years... :(
> > 
> > > The
> > > relevant question for this patch is probably just that somebody has
> > > tested and confirmed that the shrinker hasn't been subtly or indirectly
> > > broken in cases like the one you describe above (where perhaps we might
> > > not have many shrinker callback opportunities to act on before OOM).
> > 
> > FWIW, the only time I /ever/ saw OOMs (either now with 5.19 or ages ago
> > with 5.9) was with extreme lowmem testing.  On VMs with more than a
> > gigabyte or so of memory, I notice that we usually hit the time/length
> > thresholds without shrinkers getting involved.  Granted, I did try to
> > pick the shrinker values so that we only get called on the *second*
> > level of shrinking, which is after we've freed some but not enough
> > memory.
> > 
> > If my responses seem a bit like handwaving, they are, because (at the
> > moment) this is well off in the weeds.
> > 
> > > > Back in the old days when inodegc was a radix tree tag it was fairly
> > > > easy to get OOMs when the delay interval was long (5 seconds).  The
> > > > OOM probability went down pretty sharply as the interval approached
> > > > zero, but even at 1 jiffy I could still occasionally trip it, whereas
> > > > the pre-deferred-inactivation kernels would never OOM.
> > > > 
> > > > I haven't tested it all that rigorously with Dave's fancy new per-cpu
> > > > list design, but I did throw on my silly test setup (see below) and
> > > > still got it to OOM once in 3 runs with the shrinker bits turned off.
> > > > 
> > > 
> > > Ok.. so that implies we still need throttling, but I'm not sure what
> > > "fancy percpu list design" refers to. If you have a good test case, I
> > 
> > You might recall that the original versions of deferred inode
> > inactivation would set radix tree tags, and a per-AG workqueue function
> > would scan that AG's radix tree for tagged inodes and inactivate them.
> > Dave observed that letting the cpu caches grow cold led to performance
> > problems, and replaced the tagging mechanism with per-cpu lists, which
> > is what we have now.
> > 
> > > think the interesting immediate question is: are those OOMs avoided with
> > > this patch but the shrinker infrastructure still in place?
> > 
> > That's the $64000 question that I don't know definitively yet.
> > 
> 
> Ok. If the answer to the above questions is "don't really know, it might
> be broken, but historical testing shows the shrinker is much less
> important with smaller queuing delays such that it's unlikely to cause
> any new problems on anything but the most pathological workloads," then
> that sounds reasonable to me.

Yep, pretty much. :/

> I don't mean to harp on it. I just want to make sure the
> question/concern gets across clearly enough that somebody who knows this
> system better than I can grok it and make a more intelligent assessment.

Oh, I'm glad you're harping on it -- anything involving shrinkers and
deferred work ought to get a closer look.

--D

> Brian
> 
> > > If not, then I wonder if something is going wonky there. If so, I'm
> > > still a bit curious what the behavior looks like and whether it can be
> > > simplified in light of this change, but that's certainly beyond the
> > > scope of this patch.
> > 
> > <nod> For now I'd like to get this going for 5.19 to fix the original
> > complaint about statfs blocking in D state while waiting for inodegc
> > after deleting a ~100m file extents[1], and defer the decision of
> > whether or not we /really/ need the shrinker to a later time (like
> > 5.20).
> > 
> > [1] https://lore.kernel.org/linux-xfs/20220509024659.GA62606@onthe.net.au/
> > 
> > > 
> > > > > > > > If
> > > > > > > > so, it looks like decent enough overhead to cycle through every cpu in
> > > > > > > > both callbacks that it might be worth spelling out more clearly in the
> > > > > > > > top-level comment.
> > > > > > > 
> > > > > > > I'm not sure what you are asking here - mod_delayed_work_on() has
> > > > > > > pretty much the same overhead and behaviour as queue_work() in this
> > > > > > > case, so... ?
> > > > > > 
> > > > > 
> > > > > I'm just pointing out that the comment around the shrinker
> > > > > infrastructure isn't very informative if the shrinker turns out to still
> > > > > be necessary for reasons other than making the workers run sooner.
> > > > 
> > > > <nod> That comment /does/ need to be updated to note the subtlety that a
> > > > lot of shrinker activity can slow down close()ing a file by making user
> > > > tasks wait for the inodegc workers to clear the backlog.
> > > > 
> > > > > > <shrug> Looks ok to me, since djwong-dev has had some variant of timer
> > > > > > delayed inactivation in it longer than it hasn't:
> > > > > > 
> > > > > 
> > > > > Was that with a correspondingly small delay or something larger (on the
> > > > > order of seconds or so)? Either way, it sounds like you have a
> > > > > predictable enough workload that can actually test this continues to
> > > > > work as expected..?
> > > > 
> > > > Yeah.  I snapshot /home (which has ~20 million inodes) then race
> > > > fsstress and xfs_scrub -n in a VM with 560MB of RAM.
> > > > 
> > > 
> > > Yeah small delay or yeah large delay?
> > 
> > Both -- with large inactivation delays and no shrinker, OOMs happen
> > fairly frequently; with a short delay and no shrinker, they're harder
> > (but still not impossible) to trigger.
> > 
> > Granted ... even the overall frequency of OOMs with large inactivation
> > delays seems to have gone down a bit from when I was more actively
> > testing in the 5.9 era.
> > 
> > --D
> > 
> > > Brian
> > > 
> > > > --D
> > > > 
> > > > > Brian
> > > > > 
> > > > > > Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> > > > > > 
> > > > > > --D
> > > > > > 
> > > > > > > Cheers,
> > > > > > > 
> > > > > > > Dave.
> > > > > > > -- 
> > > > > > > Dave Chinner
> > > > > > > david@fromorbit.com
> > > > > > 
> > > > > 
> > > > 
> > > 
> > 
> 
