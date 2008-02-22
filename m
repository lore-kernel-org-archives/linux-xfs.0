Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 21 Feb 2008 20:07:46 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m1M47fGR001522
	for <xfs@oss.sgi.com>; Thu, 21 Feb 2008 20:07:44 -0800
Date: Thu, 21 Feb 2008 23:08:07 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [patch, debug, 2/2] Use power-of-2 size ktrace buffers
Message-ID: <20080222040806.GB16993@infradead.org>
References: <20080218230112.GU155407@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080218230112.GU155407@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Tue, Feb 19, 2008 at 10:01:12AM +1100, David Chinner wrote:
> Now that the ktrace_enter() code is using atomics,
> the non-power-of-2 buffer sizes - which require modulus
> operations to get the index - are showing up as using
> substantial CPU in the profiles.
> 
> Force the buffer sizes to be rounded up to the nearest
> power of two and use masking rather than modulus operations
> to convert the index counter to the buffer index. This
> reduces ktrace_enter overhead to 8% of a CPU time, and
> again almost halves the trace intensive test runtime.

Looks fine aswell.  You might aswell kill this zentries stuff and always
use kmalloc instead of caches as the power of two multiples of
sizeof(u64) should always have matching caches available.

While we're at it the ktrace stuff should simply go away mid-term
with all the tracing stuff in mainline now.  As a start all macros
calling into ktrace should become markers which allow always bulding
them in with almost zero overhead (a single no-op instruction at their
callsite) and allowing to load the actual tracing module later.  As
a second step ktrace should be replaced with something based on the
various trace thingies floating around allowing to read out the trace
buffer from userspace instead of having to rely on kdb.
