Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39994 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1031445AbeBONmO (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 15 Feb 2018 08:42:14 -0500
Date: Thu, 15 Feb 2018 08:42:12 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH v2] xfs: byte range buffer dirty region tracking
Message-ID: <20180215134212.GB48590@bfoster.bfoster>
References: <20180201010514.30233-1-david@fromorbit.com>
 <20180205003415.dn6elcqb4kae3xle@destitution>
 <20180206162141.GA3862@bfoster.bfoster>
 <20180212024138.GB6778@dastard>
 <20180212142619.GA33694@bfoster.bfoster>
 <20180212211824.GC6778@dastard>
 <20180213131525.GA38210@bfoster.bfoster>
 <20180213220220.GF6778@dastard>
 <20180214130939.GA42785@bfoster.bfoster>
 <20180214223027.GK7000@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180214223027.GK7000@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Feb 15, 2018 at 09:30:27AM +1100, Dave Chinner wrote:
> On Wed, Feb 14, 2018 at 08:09:39AM -0500, Brian Foster wrote:
> > On Wed, Feb 14, 2018 at 09:02:20AM +1100, Dave Chinner wrote:
> > > On Tue, Feb 13, 2018 at 08:15:26AM -0500, Brian Foster wrote:
> > > > On Tue, Feb 13, 2018 at 08:18:24AM +1100, Dave Chinner wrote:
> > > > > On Mon, Feb 12, 2018 at 09:26:19AM -0500, Brian Foster wrote:
> > > > > > :/ So it seems to
> > > > > > me this breaks a technically valid case in weird/subtle ways. For
> > > > > > example, why assert about last == 0, but then go on to add the range
> > > > > > anyways, explicitly not size it correctly, but then format it as if
> > > > > > nothing is wrong? If it were really wrong/invalid (which I don't think
> > > > > > it is), why not put the check in the log side and skip adding the range
> > > > > > rather than add it, skip sizing it, and then format it.
> > > > > 
> > > > > So what you're really concerned about is that I put asserts into the
> > > > > code to catch broken development code, but then allow production
> > > > > systems through without caring whether it works correctly because
> > > > > that boundary condition will never occur during runtime on
> > > > > production systems?
> > > > 
> > > > No. As already mentioned in my previous mail, I care little about the
> > > > asserts. Asserts can easily be removed if they turn out to be bogus.
> > > > Wrong asserts tend to have little negative effect on production users
> > > > because along with only affecting debug kernels, they'd have to be
> > > > fairly rare to slip through our testing. So I'm perfectly _happy_ to be
> > > > cautious with regard to asserts.
> > > > 
> > > > What I care much more about is not leaving latent bugs around in the
> > > > code. IMO, there is very rarely good enough justification to knowingly
> > > > commit buggy/fragile code to the kernel,
> > > 
> > > Hold on a minute!
> > > 
> > > I'm not asking anyone to commit buggy or fragile code. I've already
> > > fixed the off-by-one problems you've pointed out, and all I was
> > > trying to do was understand what you saw wrong with the asserts to
> > > catch a "should never happen" condition so I could change it in a
> > > way that you'd find acceptible.
> > > 
> > > There's no need to shout and rant at me....
> > > 
> > 
> > I pointed out the first-byte logging case looked broken. Rather than
> > indicate you're fixing that one way or another (as you had done for the
> > other issues we've found), you argued that "nobody does that" or "should
> > never happen."
> 
> I was simply stating the reason why I'd put the assert there.
> Asserts are used to document and runtime check assumptions about the code that
> follows, which is why I put them in place - I'd made an assumption
> that holds true on v5 filesystems....
> 
> But if I don't explain the reason/logic behind the assumption
> documented in the assert, then nobody is going to be able to point
> out where the mistake or wrong assumption in my reasoning is.
> 
> The way I read your comments was "the old code supported it, so the
> new code must too" but they did not demonstrate any requirement for
> the status quo to be maintained.  All you really needed to add was a
> single sentence stating "fragmented v4 symlink buffers need to log a
> 1 byte range" and it would have been immediately clear (to
> everyone!) where my assumptions had gone wrong....
> 

Just to close the loop on this (since I think we've cleared up our
mutual misunderstanding on irc)...

I had no idea about the symlink buffer case until the point where I
reported the splat. My criteria for review was always the following
invariant for the implementation:

- xfs_trans_log_buf() receives an inclusive byte range in the form of
  [first, last] and logs the corresponding chunk of the buffer

Despite the asserts that confused me, were explained and I eventually
agreed were reasonable, it was also clear on initial review that the
implementation did not satisfy the invariant with input parameters of
[0, 0]. I considered this case not because of the assert, but because
the explicit skip of last == 0 in the ->iop_size() handler set off alarm
bells.

I only began to look for a real bug when it became apparent that if I
were lucky enough to find one, a demonstration would be a more
convenient means to convince you that the implementation still had a bug
that needed fixing. So somehow this all got mixed up into you thinking I
was still arguing about the asserts and me thinking you were arguing
about asserts because you saw the bug but didn't care to fix it.

TBH, when I first saw the symlink code I expected to be able to
reproduce a log recovery symlink corruption. I figured that since
->iop_size() skipped the last == 0 case, we'd fail to log the buffer
entirely and hilarity would ensue in the event of a well-timed shutdown.
Instead, it blew up in my face (due to the other bug that you've already
described) and so I posted the splat.

Brian

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
