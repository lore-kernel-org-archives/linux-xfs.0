Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 951AB3DAAB1;
	Mon, 31 Aug 2026 09:38:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788169105; cv=none; b=rgYBGJ9Xe/pxEpXBTyjhcMPvv1ofJKfyM8MTZax/JZ1BrMUjhLJjZ338HMR4OZB3Q5K2FmS2dAm1OcV5vcHuWzutHy/BOJH1X4o8aFvLkr11FgK0NsZiOusSlMJJZTYOBilLw7ic6YDUrFoPlT/mZd69bWiepTy4NtDlQTKbcr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788169105; c=relaxed/simple;
	bh=GKs972raUa9R83lda5wU3KsEd1d9qQMaVryjObJSkbk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ed8F4kTIwDsPrxJu5hyoE+TsYrqIQO68Ncl+lirvJJDdB+qFJ03wc0L+grYqposTHIUrRRfxNxu7Fc4ZI1O0/mzwi/qJLZ8BkaXu0d6rhHjmIxxAP6gSdWOSK9nkHfzQGIzGi/1UCvGhvMxc51QYMlrx+2jU9EtWUxw99p9H4EA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mKs+kdq5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mKs+kdq5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 034901F000E9;
	Mon, 31 Aug 2026 09:38:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788169104;
	bh=RKqPhAZ9xw3NdRQ5uWMTUCn71fcMmY5LEXL0pLWjVzU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=mKs+kdq5UHGfH4ZrlI/c5W/Ge68k7a67c4PVUttuKr3swhPohtWn6VeXEygJUHTVL
	 g6/zW8/16KfSZMoCVxFx0G1FfY5V/yEdumYBGLSJSZNymDxm0AmOQx2J/CEJZz4F65
	 O+l0+w2aqUXipzp6zD59NOIwgJOcg8iwTceVOm8wMJycCaatrvGDVQVeQlMbU9J9Fj
	 fG8vmm1OozawqHJwSXTSgvIx+MbFDKrYq44HNi2jPRt0NizIs4uFlEVFA4WFoOvZgy
	 CS8gVi6DC6OolDbuobZbV9qVL59Rml4RRUUyUCVVHaN9kR9HRCnVNhCarPQaC8URR3
	 I1vuXvCsUXgOQ==
Date: Mon, 31 Aug 2026 19:38:15 +1000
From: Dave Chinner <dgc@kernel.org>
To: Eric Peterson <linuxinstalled@gmail.com>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, Eric Peterson <eric.peterson@hpe.com>
Subject: Re: [PATCH] xfs: add per-mount read/write I/O completion counters
Message-ID: <apVLh7cJ3Zf_aLcd@dread>
References: <20260828033429.4070267-1-linuxinstalled@gmail.com>
 <apSgHPl4er6Jy9xi@dread>
 <20260831004700.4072037-1-linuxinstalled@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260831004700.4072037-1-linuxinstalled@gmail.com>

On Sun, Aug 30, 2026 at 06:47:00PM -0600, Eric Peterson wrote:
> On Mon, Aug 31, 2026 at 07:26:52AM +1000, Dave Chinner wrote:
> > Hence this really doesn't seem like something we should be trying to
> > infer from indirect filesystem stats. Why can't you use the bdev
> > stats to get the actual filesystem wide queue depth information?
> 
> The block device measures the device queue, which is a different
> quantity than filesystem outstanding I/O - not just a lower-layer view
> of the same thing.
> 
> Below are three cases where filesystem queue depth is not what the block
> layer sees:

I do know the difference. Assume I understand what you are saying,
and that you don't need to explain how the IO stack works to me...

> To be clear about scope: I'm not proposing a queue-depth feature in
> the kernel. The change just adds read/write completion counters to pair
> with the existing call (submission) counters, so userspace can compute
> outstanding I/O and derive a response-time estimate itself. The kernel
> side is only exposing the complementary raw signal that's currently
> missing - calls are counted, completions are not.

I know, I just don't see how it can be used for a response time
metric that any way useful for behavioural correlation because of
the sampling method.

> Being upfront: what userspace derives from this is an instantaneous
> approximation, not a precise time-weighted queue length. It's meant as
> a cheap, always-on aggregate, not a replacement for accurate per-op
> tooling.

And that's exactly why I'm having trouble understanding how this
new metric means anything useful. Ignoring temporal sampling jitter
of multiple per-cpu counters, if you sample read + completions
it at some instant, all it tells you is what is happening at that
instant.

What happens the other 999.9ms of that second is not captured by
this new "in-flight" metric?  For example, if I sample read
submissions at 10Hz (annotated manually with rough deltas between
samples):

$ pmval -r -t 0.1 xfs.read

metric:    xfs.read
host:      devoid
semantics: cumulative counter
units:     count
samples:   all
  294454912
  294454912		S (0 IO in flight)
  294454912
  294454912
  294454912
  294454912
  294454912
  294454912
  294454912
  294454912
  294455553	+650
  294455553		S (0 IO in flight)
  294455555	+2
  294455555
  294455555
  294455555
  294455555
  294455555
  294455555
  294455555
  294455559	+4
  294455559		S (0 IO in flight)
  294455559
  294455559
  294455559
  294455559
  294455559
  294455559
  294455559
  294455559
  294455559
  294455559		S (0 IO in flight)
  294455561	+2
  294455561
  294455561
  294455564
  294455564
  294456360	+800
  294457344	+1000
  294457344
  294457346	+2
  294457352	+6	S (at most 6 IO in flight)
  294457352
  294458065	+700
  294458285
  294458285
  294458285
  294458285
  294458285
  294458285
  294458285
  294458285		S (0 IO in flight)

You can see that there are some 100ms periods where nothing happens,
whilst others have 650-1000 buffered reads. In all the cases where
there are periods with no submission, the in-flight calculation will
be zero. In the busy periods, it will likely be some non-zero
number, but it won't give any indication of IO behaviour in that
entire period.

If we pick a 1s sample time (marked with "S" above), only one of
those sample points had any chance of there being IO in flight.
If I pick a sampling pattern that hits one of those high
IO periods, it gives an unrealisticly high in flight value for the
sampling period, given that for most of the rest of the second
around that burst there was almost no read activity.

Hence I don't see how sampling a point in time "in-flight" metric
slowly provides reliable insight into application behaviour. To
address that, one would need to sample and calculate the inflight
metric at high resolution to be able to catch the concurrency of IO
in those high IOPS bursts.

However, the faster you sample to catch bursts, the closer the read
submission rate approaches the in-flight IO rate. i.e. if I sample
at 1000Hz instead of 10Hz, it'll capture the fact that there are
bursts much faster bursts than 8-10 read IOs per millisecond, yet
the in-flight counter still won't reflect that - it might still not
register any IO being in flight at all because at the sample instant
there was no IO in flight....

Hence I'm asking how this new metric is supposed to be used and
correlated to observed/measured application behaviour. i.e. what
insight does it give you into application performance that can only
be derived from this point in time snapshot?

-Dave.
-- 
Dave Chinner
dgc@kernel.org
