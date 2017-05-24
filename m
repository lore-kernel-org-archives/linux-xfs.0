Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51394 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750909AbdEXRI5 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 24 May 2017 13:08:57 -0400
Date: Wed, 24 May 2017 13:08:55 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 2/2] xfs: Properly retry failed inode items in case of
 error during buffer writeback
Message-ID: <20170524170855.GD13925@bfoster.bfoster>
References: <20170519112659.GB64091@bfoster.bfoster>
 <20170519233900.GT17542@dastard>
 <20170520114654.GA3888@bfoster.bfoster>
 <20170521231906.GU17542@dastard>
 <20170522125110.GA11578@bfoster.bfoster>
 <20170523112318.GX17542@dastard>
 <20170523162202.GB7632@bfoster.bfoster>
 <20170524010601.GX12369@dastard>
 <20170524124244.GA11089@bfoster.bfoster>
 <20170524132604.bsti3quyepmbzjzv@eorzea.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170524132604.bsti3quyepmbzjzv@eorzea.usersys.redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org

On Wed, May 24, 2017 at 03:26:04PM +0200, Carlos Maiolino wrote:
...
> 
> I need to give some more thinking about Dave's suggestion on this new flush
> locking design Dave suggested. This really looks a nice idea that needs some
> polish before the implementation, and I can certainly work on that, but, from my
> POV, I'll agree with Brian here.
> 
> Reworking in the flush lock design will take time, more discussions, more
> patches, etc. In the mean time, we have an increasing number in users hitting
> this bug, with the increasing usage of DM-Thin, this tends to increase quick,
> once, the bug is easily triggered when using dm-thin.
> 
> The unmount hang is just one of the symptoms of the problem, but there are
> several other things that go wrong and might be unnoticed by the user. The
> unmount is the most noticeable symptom an user will see, and I believe we can
> just polish what needed to be polished on my patchset, fix the bug, then move on
> and I'll work on this design Dave suggested.
> 
> My patchset shouldn't introduce any new bug or regression (saving it still needs
> that a successful IO completion clears the LI_FAILED flag), and fixes a bug that
> is appearing more and more often in a reasonable way.
> 
> Then I move on and look over the design Dave mentioned, instead of stick with
> this bug in the code for... who knows how longer.
> 
> Anyway, I'm not trying to 'sell my fish' here saying this patchset is the best
> solution, I'm far away from doing things like that, but this patchset uses the
> approach we took weeks to decide, then, why not use this now, fix the bug and
> improve it when at least users are not hitting the bug anymore?
> 

FWIW, I just posted some review comments to Carlos' v2 that attempt to
explicitly describe how I was thinking we could handle this without the
need for atomic flags and without introducing performance regressions.
Perhaps it would be easier to carry this discussion over there...

If what I was thinking is broken or has deeper problems, then we can
drop it and stick with the atomic flags approach that v2 uses or
otherwise look into something completely different like what Dave
suggests above.

Brian

> Cheers.
> 
> 
> > 
> > > This leaves the rest of the submission code completely unchanged -
> > > including the write clustering.  It also gets rid of all the flush
> > > lock deadlock scenarios because we always unlock the flush lock on
> > > IO completion, regardless of whether the buffer IO succeeded or not.
> > > ANd we don't have to change any infrastructure, either - it all just
> > > works as it is because the LI_FAILED flag is handled at the lowest
> > > levels possible.
> > > 
> > > This, to me, seems like a far cleaner solution than anything we've
> > > discussed so far....
> > > 
> > > Cheers,
> > > 
> > > Dave.
> > > -- 
> > > Dave Chinner
> > > david@fromorbit.com
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> -- 
> Carlos
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
