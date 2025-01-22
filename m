Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECCE71FAA;
	Wed, 22 Jan 2025 03:49:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737517787; cv=none; b=J5deAufesXjFuOEl3flVh57O0MTKEptsCmbhWvajvgjDXM6yN2Gu46yaZEt73a1bRkkcddFBWw8jJzbY11d3eylFI8pBbDzeY6kbfjc9Y7P+iCEadUK25K1H7Z/vw5v9bhR9/yP97sbpCscIkQeJYyGgPyHvIjhXJVkFa8fGlG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737517787; c=relaxed/simple;
	bh=Xyuwsh8LxjPsfSf7uVZyhYeH68qMHdsUPPWpHC8TukU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=enXf7jV8Lq6lHiPYBUOCqsrBdXES6ajM/I0BTvVy0HwA//A0jg1dybLaa9HO5697bgQm0jXguP2j7EwneugMJ0rdT2XpmooiIBFPFmp8dAA7KDFwkV0qgPtxm2VXOyAN04XeAcLu+aEAxRs61U5Sp5Z5clBdR/d2mffCcBIdmgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PGa9Aqxq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PGa9Aqxq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EC0CC4CED6;
	Wed, 22 Jan 2025 03:49:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737517785;
	bh=Xyuwsh8LxjPsfSf7uVZyhYeH68qMHdsUPPWpHC8TukU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=PGa9AqxqXKbNlx0XN/xc9vkObWq5NvWv7BUyQ0ao5/hJEfWGPrXgDYdYWgW+ev15a
	 +lpI8uzcwhL2JffaSlgDdHz1OiEFEQtU/8l8/lHMkeQDXmYZ03dsz2z3jxb1egCN+m
	 3qkzBZDqQhd0WVYPQ1naWLlHYQaX0kRVGNtFnpYDfm4OqLTEFnj6+caddS1VfemkxF
	 M6OvJzQihDwVUzwhCF/nEt2pWBwR4t5bYEz78IOudZ/f0yXH6TUltNuOExputd3gl/
	 VdSGWlUtJ4sG3E5HhWDVi9/I1SGn/k+SbICe25h+RKPC+7cnRcwbtNHtG4kBeRyK+C
	 u0NQZaXUrJVzA==
Date: Tue, 21 Jan 2025 19:49:44 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Dave Chinner <david@fromorbit.com>
Cc: zlang@redhat.com, hch@lst.de, fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 13/23] generic/650: revert SOAK DURATION changes
Message-ID: <20250122034944.GS1611770@frogsfrogsfrogs>
References: <173706974044.1927324.7824600141282028094.stgit@frogsfrogsfrogs>
 <173706974273.1927324.11899201065662863518.stgit@frogsfrogsfrogs>
 <Z48pM9GEhp9P_VLX@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z48pM9GEhp9P_VLX@dread.disaster.area>

On Tue, Jan 21, 2025 at 03:57:23PM +1100, Dave Chinner wrote:
> On Thu, Jan 16, 2025 at 03:28:33PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Prior to commit 8973af00ec21, in the absence of an explicit
> > SOAK_DURATION, this test would run 2500 fsstress operations each of ten
> > times through the loop body.  On the author's machines, this kept the
> > runtime to about 30s total.  Oddly, this was changed to 30s per loop
> > body with no specific justification in the middle of an fsstress process
> > management change.
> 
> I'm pretty sure that was because when you run g/650 on a machine
> with 64p, the number of ops performed on the filesystem is
> nr_cpus * 2500 * nr_loops.

Where does that happen?

Oh, heh.  -n is the number of ops *per process*.

> In that case, each loop was taking over 90s to run, so the overall
> runtime was up in the 15-20 minute mark. I wanted to cap the runtime
> of each loop to min(nr_ops, SOAK_DURATION) so that it ran in about 5
> minutes in the worst case i.e. (nr_loops * SOAK_DURATION).
> 
> I probably misunderstood how -n nr_ops vs --duration=30 interact;
> I expected it to run until either were exhausted, not for duration
> to override nr_ops as implied by this:

Yeah, SOAK_DURATION overrides pretty much everything.

> > On the author's machine, this explodes the runtime from ~30s to 420s.
> > Put things back the way they were.
> 
> Yeah, OK, that's exactly waht keep_running() does - duration
> overrides nr_ops.
> 
> Ok, so keeping or reverting the change will simply make different
> people unhappy because of the excessive runtime the test has at
> either ends of the CPU count spectrum - what's the best way to go
> about providing the desired min(nr_ops, max loop time) behaviour?
> Do we simply cap the maximum process count to keep the number of ops
> down to something reasonable (e.g. 16), or something else?

How about running fsstress with --duration=3 if SOAK_DURATION isn't set?
That should keep the runtime to 30 seconds or so even on larger
machines:

if [ -n "$SOAK_DURATION" ]; then
	test "$SOAK_DURATION" -lt 10 && SOAK_DURATION=10
	fsstress_args+=(--duration="$((SOAK_DURATION / 10))")
else
	# run for 3s per iteration max for a default runtime of ~30s.
	fsstress_args+=(--duration=3)
fi

--D

> -Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 
