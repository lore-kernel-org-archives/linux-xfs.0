Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:28236 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754738AbdDSCqx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Apr 2017 22:46:53 -0400
Date: Wed, 19 Apr 2017 12:46:49 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/3] xfs: push buffer of flush locked dquot to avoid
 quotacheck deadlock
Message-ID: <20170419024649.GG12369@dastard>
References: <1487966001-63263-1-git-send-email-bfoster@redhat.com>
 <1487966001-63263-3-git-send-email-bfoster@redhat.com>
 <20170410050001.GI23007@dastard>
 <20170410141521.GB3991@bfoster.bfoster>
 <20170410235525.GA12369@dastard>
 <20170411145300.GA12111@bfoster.bfoster>
 <20170418023548.GX17542@dastard>
 <20170418135529.GA46764@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170418135529.GA46764@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org, Martin Svec <martin.svec@zoner.cz>

On Tue, Apr 18, 2017 at 09:55:31AM -0400, Brian Foster wrote:
> On Tue, Apr 18, 2017 at 12:35:48PM +1000, Dave Chinner wrote:
> > On Tue, Apr 11, 2017 at 10:53:03AM -0400, Brian Foster wrote:
> > > On Tue, Apr 11, 2017 at 09:55:25AM +1000, Dave Chinner wrote:
> > > > So why can't we just modify the dquot in the buffer?  We already
> > > > hold all the locks needed to guarantee exclusive access to the dquot
> > > > and buffer, and they are all we hold when we do the initial flush to
> > > > the buffer. So why do we need to do IO to unlock the dquot flush
> > > > lock when we could just rewrite before we submit the buffer for IO?
> > > > 
> > > 
> > > Are you suggesting to essentially ignore the flush lock? I suppose we
> > > could get away with this in dq_flush_one() since it is only called from
> > > quotacheck, but we may have to kill off any assertions that expect the
> > > flush lock in xfs_dqflush(), and perhaps refactor that code to accept a
> > > locked buffer as a param.
> > 
> > No, I'm not suggesting we ignore the flush lock. What the flush
> > "lock" does is prevent higher layer attempts to flush the dquot to
> > the backing buffer whilst IO may be in progress. It's higher level
> > function is to allows async log item state updates to be done
> > correctly w.r.t. relogging and flushing, as we allow transactional
> > modifications to inodes and dquots while they are under IO.
> > 
> 
> Ok. What I was trying to recall previously was some discussion around
> the flush lock retry problem where it was noted that we can't unlock the
> flush lock until the currently flushed state makes it to disk[1]. Is the
> conceptual difference here that we are not proposing to unlock the flush
> lock, but rather co-opt it to perform another flush?

I wouldn't use that wording, but you've got the idea.

[...]

> > > I don't see anything that would break off hand, but my first reaction is
> > > it sounds more hackish than this patch or the previous patch that just
> > > disabled reclaim during quotacheck.
> > 
> > I thought we'd done that discussion. i.e. we can't disable reclaim
> > in quotacheck because that can set off the OOM killer...
> > 
> 
> Huh? The only reason disabling of dquot reclaim during quotacheck was
> proposed in the first place is because it is 100% superfluous.

ISTR that we broke dquot reclaim during quotacheck by moving to
private delwri lists. I'm working under the impression that dquot
reclaim during quotacheck used to work just fine. maybe I'm wrong,
but ....

> Quotacheck, by design, does not allow reclaim to free memory. Therefore
> reclaim does not and afaict never has prevented or even mitigated OOM
> during quotacheck.

.... the intent has always been to allow dquot reclaim to run when
quotacheck is active because we've had our fair share of OOM
problems in quotacheck over the past 10 years. Bugs notwithstanding,
we really should be trying to ensure the code fulfils that intent
rather than sweep it under the carpet and tell users "too bad, so
sad" when quotacheck OOMs...

[...]

> P.S., To be completely clear of my position on this issue at this
> point... given the amount of time I've already spent responding to
> handwavy arguments (ultimately resulting in discussing trailing off
> until a repost occurs), or experimenting with a known bogus quotacheck
> rework (which is still left without feedback, I believe), etc.,
> clarification on the correctness of this alternate approach (while
> interesting) is not nearly convincing enough for me to start over on
> this bug. I don't mind handwavy questions if the "caller" is receptive
> to or attempting to process (or debate) clarification, but I don't get
> the impression that is the case here.
> 
> If you feel strongly enough about a certain approach, feel free to just
> send a patch. At this point, I'm happy to help review anything from the
> sole perspective of technical correctness (regardless of whether the I
> think the approach is ugly), but I'm not personally wasting any more
> time than I already have to implement and test such an approach without
> a more logical and convincing argument. IMO, the feedback to this patch
> doesn't fairly or reasonably justify the level of pushback.

I just responded to the code that was posted, pointing out a
list of things that concerned me and, I thought, we've been working
through that quite amicably.

Really, it is up to the maintainer whether to merge the code or not.
That's not me - I'm now just someone who knows the code and it's
history.  This is where the maintainer needs to step in and make a
decision one way or the other....

-Dave.
-- 
Dave Chinner
david@fromorbit.com
