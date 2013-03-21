Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cthulhu.engr.sgi.com (cthulhu.engr.sgi.com [150.166.39.100])
	by oss.sgi.com (Postfix) with ESMTP id 734D67F53
	for <xfs@oss.sgi.com>; Thu, 21 Mar 2013 18:52:08 -0500 (CDT)
Received: from caliban.engr.sgi.com ([150.166.2.131])
	by cthulhu.engr.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id
	r2LNq7Wh029313 for <xfs@oss.sgi.com>; Thu, 21 Mar 2013 16:52:08 -0700
Date: Thu, 21 Mar 2013 16:52:07 -0700
From: Phil White <pwhite@sgi.com>
Subject: Re: [PATCH 02/25] xfstests: remove bench infrastructure
Message-ID: <20130321235207.GK2025@caliban.engr.sgi.com>
References: <1363350489-22257-1-git-send-email-david@fromorbit.com>
	<1363350489-22257-3-git-send-email-david@fromorbit.com>
	<20130315193635.GA2025@caliban.engr.sgi.com>
	<20130319223149.GA17758@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130319223149.GA17758@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

On Wed, Mar 20, 2013 at 09:31:49AM +1100, Dave Chinner wrote:
> I understand why you see value in a benchmark infrastructure, but
> that's not the issue here. The issue at hand is whether we should be
> trying to maintain arbitrary abstractions that are made redundant by
> the cleanup patch in the hope they are useful in the future.
> 
> There are solid technical reasons for what I've done, but you
> haven't provided any to advocate why we should accept your version
> as a better solution. "personal interest" is a good thing to have,
> but it's not a convincing technical argument....

Let me be clear:

Personal interest is why I took it upon myself to move this along,
rather than letting it moulder away even further than it has while
we wait for you to respond to our feedback.

Personal interest is why I reposted your patch series without the
change in the hopes of moving along.

Personal interest is *not* the argument I gave for why you should remove
those changes.

The technical argument -- apart from the one which was given at the time
of the series -- is a much simpler one.  The whole change is a difference
of putting adjustments directly into check or directly into common.  It
is by no means a centerpiece to this series -- even with the extra
patches you added in your reposting.

I always thought the point of a patch series was focus.  It makes it
easier on your reviewer and avoids unintended side effects.  Apparently,
you have different thoughts here for some reason.

It makes me wonder what your motives are.  Did you swear some sort of
vendetta against bench and remake?  Is there a blood oath between the
houses of Chinner and common?

> FWIW, there's an example of this remove/re-implement process I
> advocate for cleanups in this patchset.  I removed the expunged file
> support because it makes infrastructure modifications simpler. I
> then re-introduce an enhanced version of the same functionality
> later in the series after all the structural changes have been made.

Notably, this *was* related to the reorganization in tests.  It needed
to be changed in order to adapt the new directory structure.

The change I'm talking about is a mere difference of changing the
appropriate code in either common (maybe it was common.rc? -- I don't
recall just now) or check.

That's the sum total of the difference here.

> Hence what I'm asking you is this: why you can't follow this same
> process for your new benchmarking infrastructure? i.e. What makes the
> existing abstaction so compelling that we need to keep it?

It's unnecessary code churn.  It's code which you are taking out for an
unclear reason other than a personal distaste for it.

As for my work, there's an advertising slogan which I'm adapting for you
here: "One oughtn't post a whine before its time".  I have not posted
that work yet.  What I do know is that you're making extra work for us.
We've mentioned we have an interest in it.  I've mentioned that the
intent of pulling it out is orthogonal to the intent of the patch.  I've

But for some reason, you seem determined to hold up xfstests in order to
make this happen.

Look, my interest in continuing to point out the things which I already
have pointed out is waning.  It seems abundantly clear that Carlos isn't
going to continue reviewing my set -- I wonder why?

So my choices are simple here:
1) I could give up -- as everyone else has -- and let this linger forever,
2) You could accept that this is a change which you have no real reason to
   make, or
3) I can do what I set out to do:  Get this patch series into xfstests and
   write extra code to bring my stuff in.

The timeframe in which xfstests can move forward in cases 1 or 2 are
unacceptable to me.  So I'm going to do 3, review your March 15th series,
and move this forward.

Thanks for working with me here, Dave.

-Phil

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
