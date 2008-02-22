Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 21 Feb 2008 20:30:08 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m1M4U0IR010057
	for <xfs@oss.sgi.com>; Thu, 21 Feb 2008 20:30:03 -0800
Date: Fri, 22 Feb 2008 15:30:20 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: [patch, debug, 2/2] Use power-of-2 size ktrace buffers
Message-ID: <20080222043020.GN155407@sgi.com>
References: <20080218230112.GU155407@sgi.com> <20080222040806.GB16993@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080222040806.GB16993@infradead.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: David Chinner <dgc@sgi.com>, xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Thu, Feb 21, 2008 at 11:08:07PM -0500, Christoph Hellwig wrote:
> On Tue, Feb 19, 2008 at 10:01:12AM +1100, David Chinner wrote:
> > Now that the ktrace_enter() code is using atomics,
> > the non-power-of-2 buffer sizes - which require modulus
> > operations to get the index - are showing up as using
> > substantial CPU in the profiles.
> > 
> > Force the buffer sizes to be rounded up to the nearest
> > power of two and use masking rather than modulus operations
> > to convert the index counter to the buffer index. This
> > reduces ktrace_enter overhead to 8% of a CPU time, and
> > again almost halves the trace intensive test runtime.
> 
> Looks fine aswell.  You might aswell kill this zentries stuff and always
> use kmalloc instead of caches as the power of two multiples of
> sizeof(u64) should always have matching caches available.

Ok, I'll cook up another patch for that and send it out.

> While we're at it the ktrace stuff should simply go away mid-term
> with all the tracing stuff in mainline now.  As a start all macros
> calling into ktrace should become markers which allow always bulding
> them in with almost zero overhead (a single no-op instruction at their
> callsite) and allowing to load the actual tracing module later.

Sure, that could be done.

> As
> a second step ktrace should be replaced with something based on the
> various trace thingies floating around allowing to read out the trace
> buffer from userspace instead of having to rely on kdb.

Yeah, that make sense for tracing from userspace. But most of the
time I find a need for the tracing is when the machine has crashed
or assert failed. Hence I don't see that we can really remove the
kdb side of things. Perhaps two different tracing modules could
be done.....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
