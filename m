Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:34233 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1031527AbeBNWa3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 14 Feb 2018 17:30:29 -0500
Date: Thu, 15 Feb 2018 09:30:27 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2] xfs: byte range buffer dirty region tracking
Message-ID: <20180214223027.GK7000@dastard>
References: <20180201010514.30233-1-david@fromorbit.com>
 <20180205003415.dn6elcqb4kae3xle@destitution>
 <20180206162141.GA3862@bfoster.bfoster>
 <20180212024138.GB6778@dastard>
 <20180212142619.GA33694@bfoster.bfoster>
 <20180212211824.GC6778@dastard>
 <20180213131525.GA38210@bfoster.bfoster>
 <20180213220220.GF6778@dastard>
 <20180214130939.GA42785@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180214130939.GA42785@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Feb 14, 2018 at 08:09:39AM -0500, Brian Foster wrote:
> On Wed, Feb 14, 2018 at 09:02:20AM +1100, Dave Chinner wrote:
> > On Tue, Feb 13, 2018 at 08:15:26AM -0500, Brian Foster wrote:
> > > On Tue, Feb 13, 2018 at 08:18:24AM +1100, Dave Chinner wrote:
> > > > On Mon, Feb 12, 2018 at 09:26:19AM -0500, Brian Foster wrote:
> > > > > :/ So it seems to
> > > > > me this breaks a technically valid case in weird/subtle ways. For
> > > > > example, why assert about last == 0, but then go on to add the range
> > > > > anyways, explicitly not size it correctly, but then format it as if
> > > > > nothing is wrong? If it were really wrong/invalid (which I don't think
> > > > > it is), why not put the check in the log side and skip adding the range
> > > > > rather than add it, skip sizing it, and then format it.
> > > > 
> > > > So what you're really concerned about is that I put asserts into the
> > > > code to catch broken development code, but then allow production
> > > > systems through without caring whether it works correctly because
> > > > that boundary condition will never occur during runtime on
> > > > production systems?
> > > 
> > > No. As already mentioned in my previous mail, I care little about the
> > > asserts. Asserts can easily be removed if they turn out to be bogus.
> > > Wrong asserts tend to have little negative effect on production users
> > > because along with only affecting debug kernels, they'd have to be
> > > fairly rare to slip through our testing. So I'm perfectly _happy_ to be
> > > cautious with regard to asserts.
> > > 
> > > What I care much more about is not leaving latent bugs around in the
> > > code. IMO, there is very rarely good enough justification to knowingly
> > > commit buggy/fragile code to the kernel,
> > 
> > Hold on a minute!
> > 
> > I'm not asking anyone to commit buggy or fragile code. I've already
> > fixed the off-by-one problems you've pointed out, and all I was
> > trying to do was understand what you saw wrong with the asserts to
> > catch a "should never happen" condition so I could change it in a
> > way that you'd find acceptible.
> > 
> > There's no need to shout and rant at me....
> > 
> 
> I pointed out the first-byte logging case looked broken. Rather than
> indicate you're fixing that one way or another (as you had done for the
> other issues we've found), you argued that "nobody does that" or "should
> never happen."

I was simply stating the reason why I'd put the assert there.
Asserts are used to document and runtime check assumptions about the code that
follows, which is why I put them in place - I'd made an assumption
that holds true on v5 filesystems....

But if I don't explain the reason/logic behind the assumption
documented in the assert, then nobody is going to be able to point
out where the mistake or wrong assumption in my reasoning is.

The way I read your comments was "the old code supported it, so the
new code must too" but they did not demonstrate any requirement for
the status quo to be maintained.  All you really needed to add was a
single sentence stating "fragmented v4 symlink buffers need to log a
1 byte range" and it would have been immediately clear (to
everyone!) where my assumptions had gone wrong....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
