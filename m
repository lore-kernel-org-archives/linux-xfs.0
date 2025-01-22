Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE49E1E502;
	Wed, 22 Jan 2025 04:37:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737520654; cv=none; b=DkgJVl2oLyA2R4iJuMZQaPRS22Tgs92chVv7ScZpznSp/AzvCRNUq600RO5uOCaRqpf2WKKW3m0XHmd9j7OluS7bMJUumt4yWfxAWC9xVMxz1coBSVG3t6y1BrhPmZCz0IiVzZzd0sxbYYuvfQnIYDA/Xifqwr81t8p1yNSO6Xg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737520654; c=relaxed/simple;
	bh=LYItRc0FGDvpPH4Jald9un5qcTEgJmKFYLqR8g40yjw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Mf/oodjbY8lEcRjGT6aS4rqTkmuPT80oM7wB/VNi9xPSRV9e+XoVBgRNiWfuW96eU6rDdmKyQv/NiiG5vIme33NM1R2dwULjCImEgmREbOPh9KX0I7DuN6IX0aW+CHuYcb8qmdL8DXP7VfNbysAmaYKCLxu8RM748GA8YF/V5r0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=G+acQBvw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="G+acQBvw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55D2DC4CED6;
	Wed, 22 Jan 2025 04:37:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737520653;
	bh=LYItRc0FGDvpPH4Jald9un5qcTEgJmKFYLqR8g40yjw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=G+acQBvw7TitG6zNtWuJ6pQI3XtDeuFiUg46r7k1AolNOy0bJ/ymWK0I6PAqYkduz
	 dWec+/FluaIG9GeWijc3w6CKH1mXUtLOqTrT9+hsttJRM7vpmgMj1I7ciae2lr/e63
	 MAUOMRIKocr1/GORut09waVSfZjDh+hXXizdOy/1rppSyaarot7oeLntOjhoHV8ZYD
	 +8kBoaGKsg1CoN8P0R+spTlW5ldh9Mpk4Qm2bPximCjbI27dwXbRHfzSfrIBA6n1Bl
	 MIepIAQOJfjxrFx92qKGGtpDLbaqABsmqSKhmC/BiMKl0XGuFzw7iVJWXrktfuQL0c
	 Vb7hLztbqc5ag==
Date: Tue, 21 Jan 2025 20:37:32 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Dave Chinner <david@fromorbit.com>
Cc: zlang@redhat.com, hch@lst.de, fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 13/23] generic/650: revert SOAK DURATION changes
Message-ID: <20250122043732.GY1611770@frogsfrogsfrogs>
References: <173706974044.1927324.7824600141282028094.stgit@frogsfrogsfrogs>
 <173706974273.1927324.11899201065662863518.stgit@frogsfrogsfrogs>
 <Z48pM9GEhp9P_VLX@dread.disaster.area>
 <20250122034944.GS1611770@frogsfrogsfrogs>
 <Z5BwGzOfPaSzXyQ3@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z5BwGzOfPaSzXyQ3@dread.disaster.area>

On Wed, Jan 22, 2025 at 03:12:11PM +1100, Dave Chinner wrote:
> On Tue, Jan 21, 2025 at 07:49:44PM -0800, Darrick J. Wong wrote:
> > On Tue, Jan 21, 2025 at 03:57:23PM +1100, Dave Chinner wrote:
> > > On Thu, Jan 16, 2025 at 03:28:33PM -0800, Darrick J. Wong wrote:
> > > > From: Darrick J. Wong <djwong@kernel.org>
> > > > 
> > > > Prior to commit 8973af00ec21, in the absence of an explicit
> > > > SOAK_DURATION, this test would run 2500 fsstress operations each of ten
> > > > times through the loop body.  On the author's machines, this kept the
> > > > runtime to about 30s total.  Oddly, this was changed to 30s per loop
> > > > body with no specific justification in the middle of an fsstress process
> > > > management change.
> > > 
> > > I'm pretty sure that was because when you run g/650 on a machine
> > > with 64p, the number of ops performed on the filesystem is
> > > nr_cpus * 2500 * nr_loops.
> > 
> > Where does that happen?
> > 
> > Oh, heh.  -n is the number of ops *per process*.
> 
> Yeah, I just noticed another case of this:
> 
> Ten slowest tests - runtime in seconds:
> generic/750 559
> generic/311 486
> .....
> 
> generic/750 does:
> 
> nr_cpus=$((LOAD_FACTOR * 4))
> nr_ops=$((25000 * nr_cpus * TIME_FACTOR))
> fsstress_args=(-w -d $SCRATCH_MNT -n $nr_ops -p $nr_cpus)
> 
> So the actual load factor increase is exponential:
> 
> Load factor	nr_cpus		nr_ops		total ops
> 1		4		100k		400k
> 2		8		200k		1.6M
> 3		12		300k		3.6M
> 4		16		400k		6.4M
> 
> and so on.
> 
> I suspect that there are other similar cpu scaling issues
> lurking across the many fsstress tests...
> 
> > > > On the author's machine, this explodes the runtime from ~30s to 420s.
> > > > Put things back the way they were.
> > > 
> > > Yeah, OK, that's exactly waht keep_running() does - duration
> > > overrides nr_ops.
> > > 
> > > Ok, so keeping or reverting the change will simply make different
> > > people unhappy because of the excessive runtime the test has at
> > > either ends of the CPU count spectrum - what's the best way to go
> > > about providing the desired min(nr_ops, max loop time) behaviour?
> > > Do we simply cap the maximum process count to keep the number of ops
> > > down to something reasonable (e.g. 16), or something else?
> > 
> > How about running fsstress with --duration=3 if SOAK_DURATION isn't set?
> > That should keep the runtime to 30 seconds or so even on larger
> > machines:
> > 
> > if [ -n "$SOAK_DURATION" ]; then
> > 	test "$SOAK_DURATION" -lt 10 && SOAK_DURATION=10
> > 	fsstress_args+=(--duration="$((SOAK_DURATION / 10))")
> > else
> > 	# run for 3s per iteration max for a default runtime of ~30s.
> > 	fsstress_args+=(--duration=3)
> > fi
> 
> Yeah, that works for me.
> 
> As a rainy day project, perhaps we should look to convert all the
> fsstress invocations to be time bound rather than running a specific
> number of ops. i.e. hard code nr_ops=<some huge number> in
> _run_fstress_bg() and the tests only need to define parallelism and
> runtime.

I /think/ the only ones that do that are generic/1220 generic/476
generic/642 generic/750.  I could drop the nr_cpus term from the nr_ops
calculation.

> This would make the test runtimes more deterministic across machines
> with vastly different capabilities and and largely make "test xyz is
> slow on my test machine" reports largely go away.
> 
> Thoughts?

I'm fine with _run_fsstress injecting --duration=30 if no other duration
argument is passed in.

--D

> -Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 
