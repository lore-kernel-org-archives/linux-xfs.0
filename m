Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id E27117F50
	for <xfs@oss.sgi.com>; Fri, 22 Mar 2013 02:37:47 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B22888F8084
	for <xfs@oss.sgi.com>; Fri, 22 Mar 2013 00:37:47 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	ART6qIShYA9rVeSX for <xfs@oss.sgi.com>;
	Fri, 22 Mar 2013 00:37:45 -0700 (PDT)
Date: Fri, 22 Mar 2013 18:37:43 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 02/25] xfstests: remove bench infrastructure
Message-ID: <20130322073743.GS17758@dastard>
References: <1363350489-22257-1-git-send-email-david@fromorbit.com>
	<1363350489-22257-3-git-send-email-david@fromorbit.com>
	<20130315193635.GA2025@caliban.engr.sgi.com>
	<20130319223149.GA17758@dastard>
	<20130321235207.GK2025@caliban.engr.sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130321235207.GK2025@caliban.engr.sgi.com>
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
To: Phil White <pwhite@sgi.com>
Cc: xfs@oss.sgi.com

On Thu, Mar 21, 2013 at 04:52:07PM -0700, Phil White wrote:
> On Wed, Mar 20, 2013 at 09:31:49AM +1100, Dave Chinner wrote:
> > I understand why you see value in a benchmark infrastructure, but
> > that's not the issue here. The issue at hand is whether we should be
> > trying to maintain arbitrary abstractions that are made redundant by
> > the cleanup patch in the hope they are useful in the future.
> > 
> > There are solid technical reasons for what I've done, but you
> > haven't provided any to advocate why we should accept your version
> > as a better solution. "personal interest" is a good thing to have,
> > but it's not a convincing technical argument....
> 
> Let me be clear:
> 
> Personal interest is why I took it upon myself to move this along,
> rather than letting it moulder away even further than it has while
> we wait for you to respond to our feedback.

/me does a double take

Please don't try to rewrite history.  This patchset has been held up
by SGI steadfastly refusing to remove the bench infrastructure
regardless of the technical merits of doing so, not by me failing to
respond to SGI's feedback.

> It makes me wonder what your motives are.  Did you swear some sort of
> vendetta against bench and remake?  Is there a blood oath between the
> houses of Chinner and common?

[...]

> It's unnecessary code churn.

You're calling this code churn and implying it's driven by zealotry.
I'd guess this is the first major cleanup you would have seen in the
XFS code base. We've done many and as a matter of principle they do
not leave unnecessary cruft behind.  This is the way we improve the
quality of the code base.

It's not possible to clean up code properly if you don't remove all
the problematic code and interfces when the opportunity arises.  If
it turns out we need it in future, then we pull it back out of the
revision history and use just the bits we need.  We've been through
this cycle several times before as needs have changed. e.g.  have a
look at the history of the XFS_ISIZE macro in the kernel code.

> As for my work, there's an advertising slogan which I'm adapting for you
> here: "One oughtn't post a whine before its time".  I have not posted
> that work yet.

OSS development motto:

"Release early. Release often."

> What I do know is that you're making extra work for us.

Other people do development, and they are not going to stop making
changes just because it "makes extra work for you".  I have to keep
tens of thousands of lines of patches current at the moment with all
the CRC changes, but I'm not using that as an excuse to stop other
people making changes...

> So my choices are simple here:
> 1) I could give up -- as everyone else has -- and let this linger forever,

It won't linger forever - I'm really not that far away from sticking
a fork in xfstests...

> 2) You could accept that this is a change which you have no real reason to
>    make, or
> 3) I can do what I set out to do:  Get this patch series into xfstests and
>    write extra code to bring my stuff in.
>
> The timeframe in which xfstests can move forward in cases 1 or 2 are
> unacceptable to me.  So I'm going to do 3, review your March 15th series,
> and move this forward.

OK, well lets see how that goes :)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
