Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4B0C34F46F;
	Mon,  7 Sep 2026 22:54:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788821643; cv=none; b=J85ofdkDs3/7SRcKAOMCKnov6Q6wHinMKxsp+FV4T4JY3pwlnwOr6eHcOUVDYq8hcIZgoR/9+fWzrROSOeY2htYsScUbI5EJu4vqGE9vtoNug6fyEJSQ+hAAvykwxBvm1KwVB09rg0Gy7n+RF/f7q267Q2JnChQ6fUCnQuCVcpU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788821643; c=relaxed/simple;
	bh=eSFdUlDLf2GZqgNMTJLFYHhvCCl+0x38KjNsNQw87jU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Cjvam5aWb858zsVKBiMA86E48rBo2GkA04vwD7dDIck9Ee+QC5Wllu5k7BWMpwvRqpErKt53S5lXFkcGV/oP932i8tvUh/TIRZ21InkwElWLpRfYc75jswB/r9BG2uNA9+w+5J+ypcN3L2Uy2Rj6BhzEfc5uW4dKs1EtLxm8/lQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=D1vhTQZ9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="D1vhTQZ9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08E601F00A3A;
	Mon,  7 Sep 2026 22:53:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788821641;
	bh=Ika8T9omcjuRCfkjDk2wfiEqxdav9REiF7ZEPsYL/ww=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=D1vhTQZ9Mf2DnBAECm8J/ixfQdoCnlML5UnK1toL+ClxpkmrtJzLVqEPl5kfraNUZ
	 6H8M+C59wDgspGpPEvrako4uCKn4YzuiJZNxfcFugmWYwdk+eolahbKpCcd3ptW77t
	 onE+kbgGJG5AHChLEdJk5ugcOM4Q8ptjfqxffa6BsXMtig3NJQS0ieMBA+x0Y1tQaE
	 Is+ecuW9GAuCQAijVsUnmdKk6G8mPrOqb2QlSrfST2Bpw3ff7oJ6Aag3u8wWwICEaN
	 Pp0joc0I1zuHssNhO5vGk9WhVrhs+0Zni5i/IRa86Boh9cUTPCTxUsaInVuh/i5vU2
	 4cX3YxisAlP8g==
Date: Tue, 8 Sep 2026 08:53:52 +1000
From: Dave Chinner <dgc@kernel.org>
To: Eric Peterson <linuxinstalled@gmail.com>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, eric.peterson@hpe.com
Subject: Re: [PATCH] xfs: add per-mount read/write I/O completion counters
Message-ID: <ap9AgBQXDMM7UhYe@dread>
References: <20260828033429.4070267-1-linuxinstalled@gmail.com>
 <apSgHPl4er6Jy9xi@dread>
 <20260902053230.4073608-1-linuxinstalled@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260902053230.4073608-1-linuxinstalled@gmail.com>

On Tue, Sep 01, 2026 at 11:32:30PM -0600, Eric Peterson wrote:
> On Mon, Aug 31, 2026 at 09:38 UTC, Dave Chinner wrote:
> > Hence I'm asking how this new metric is supposed to be used and
> > correlated to observed/measured application behaviour. i.e. what
> > insight does it give you into application performance that can only
> > be derived from this point in time snapshot?
> 
> My apologies - it wasn't my intention to come across as patronizing.
> I was unsure what background was or wasn't common ground, so I erred on
> the side of more detail.
> 
> You're right about the sampling limitation: a slowly-sampled
> point-in-time queue depth value cannot characterize bursty,
> sub-interval concurrency. If the goal is to resolve what happens inside
> a 10ms burst, this is the wrong tool - per-op tooling (tracepoints,
> histograms) is the right one, and this is not meant to replace it.
> 
> The important part is that this is a property of the sampling rate, not
> of the counters. Nyquist-Shannon says that to observe a phenomenon at
> timescale T you have to sample at >= 2/T; if you sample slower than the
> behavior you care about, it will be missed. This is true of any sampled
> counter, including the existing submission counter - in your 10Hz pmval
> example, xfs.read has exactly the same property. The sampling rate is a
> policy choice for the user to match to what they're trying to observe.

I know what nyquist sampling implies - that's exactly why I gave
that example to demonstrate how point in time sampling of
instantaneous values is not representative.

In more detail, the nyquist sampling theorem only holds when -every
sample is representative of the overall waveform-. You also need to
know what the highest frequency of the waveform is to be able to
reconstruct the behaviour.

The problem with using nyquist here is that the queue depth is an
instantaneous value metric - it is not a repeating waveform. Hence
nyquist says it is impossible to recover a valid signal from the
metric because the sample rate must be 2x instantaneous.

Something like a summing value (i.e. read count) does allow nyquist
theorem to be applied, because the delta between samples leads to a
meaningful waveform - the read rate per sample period. But you
cannot convert an instantaneous value calculated from summing
variables into a rate metric - it is always an instantaneous value
and that means the delta between samples is meaningless when placed
in a time series. i.e. there is no frequency component that nyquist
sampling theorem can recover from it.

Let's go further. Last email I said "ignoring per-cpu summing
jitter". Did you think about that at all?

Look at how the samples are presented to userspace:

	for each counter group {
		for each counter in group {
			for each cpu {
				sum counter
			}
			print counter val
		}
	}

Think about that for a moment. What happens when you have hundreds
of CPUs (just call it N)?

Yeah, summing each counter is an expensive operation, involving
accessing N cachelines for each counter. If each of those stats is
being actively modified whilst the sum is in progress, we take cache
miss on each CPU for each counter. Let's be charitable and call that
100ns per CPU. For a thousand CPUs, that means it takes 100us to
sample that counter.

Now, read completion was placed directly after reads, so there is a
window of 100us between the sampling of each per cpu value.

Consider that a buffered read could take as little as a few
microseconds to run. That means that across the sampling of read +
read completion, each CPU could start and complete multiple buffered
IOs.

In that situation, we have on a single CPU:

read 1 ....
sample read		X
read 1 complete
read 2 ....
read 2 complete
read 3 ....
read 3 complete
....
read N ....
sample read_complete	X + (N - 1)

In this situation, the "queue depth" on this CPU which is (read -
read_complete) returns -(N - 1). What does a -negative queue depth-
mean?

And what happens when there is sufficient other read/read_complete
differences on other CPUs that this negative sample cancels out all
the other positive "queue depths"?

IOWs, we can't even trust the instantaneous value of the queue depth
calculation to be a valid representation of the state of the
filesystem at a single point in time. Hence any downstream use of
the value (regardless of the sample rate) is not going to be any
more trustworthy than the instantaneous value....

> Answering your question, it lets userspace characterize filesystem
> queue depth over time. The places where this is useful are the ones
> where the desired signal persists across multiple sample periods,
> leading to a representative measurement:
....

All of these use cases are based on the assumption that the
underlying metric and the sampling method produces a valid and/or
meaningful representation of the current filesystem state.

I am not convinced that this is a valid assumption because of the
nature of the sampling - an instantaneous value sample cannot be
representative of overall behaviour, regardless of the sampling
rate.

However, if you really, really want this counter added then I won't
oppose it based on the fact I think it cannot be used the way you
want to use it - I'll just ignore it like I do all the other useless
stats we still keep around from the days of Irix for userspace
compatibility reasons.

Cheers,

Dave.
-- 
Dave Chinner
dgc@kernel.org
