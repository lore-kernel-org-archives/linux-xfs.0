Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9114186A;
	Wed, 22 Jan 2025 03:40:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737517249; cv=none; b=fEuue60cwbgzfiq97Pw6oeu+Xz696wYtKqE0AjuUU153iXpEK9Q6fEZYie4OgLCThKiDpdbHAHI+Y6IZgM/FwP2M2S+IvKAgU322QHCVkGKYBNTookKOozk1manOlM/LP193quHXI8Tnrgpzk6l+MzBAoNraqiWnWoGlTOiEWV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737517249; c=relaxed/simple;
	bh=l48y5pTDsq0ihHtCSmwLAHbcttaQIWX3WIEci+Y547w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZeiGwTOo7SYUaR60x8wDr6Ydw05NhQFzTDl7gVXBHNW7PmVjO1DikF+0zCeyXzqcvwA0OjB+6ERMa+9rJaXcxbwMfoZGNRFiSz8iklTemjbKkfE515JjLWmQV9M+Fy/FZPKwtCfcMKYxvPLpexLZ5qZIqy+IVvyCRHI9LM/c9+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NuIpkUy4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NuIpkUy4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40EEAC4CED6;
	Wed, 22 Jan 2025 03:40:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737517249;
	bh=l48y5pTDsq0ihHtCSmwLAHbcttaQIWX3WIEci+Y547w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=NuIpkUy4vq1I89U4RY9fF24YYPtRrs08236Og45rNztzR+IfZDzX+yJlX4tUC7pBK
	 fcl6100Bv3Jh4GfVJ40EG29pwUOq6I7scrR2PzyrEfda4bQqeaSjFhdovgzbyiEBSd
	 wWQx+utwLYSO8biN2ZQLHdo06QroC6UKoIEdDza+wRPAQKlzPR8fHilehaYZayqgWK
	 yUKwDiTjN+0ytczZBvVhCVpyYFL6qQij/oX1Yfvv76yuF+qZYaGVMce0ISxj7dArGj
	 1ksoR1LY5s483E7tYEMhmps1n8u+FoUBNVD+omDZSHgsyCQIPEoo1NFRRo0BS1GRXR
	 WqlCZgnW3ixTA==
Date: Tue, 21 Jan 2025 19:40:48 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Dave Chinner <david@fromorbit.com>
Cc: Theodore Ts'o <tytso@mit.edu>, zlang@redhat.com, hch@lst.de,
	fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 10/23] mkfs: don't hardcode log size
Message-ID: <20250122034048.GR1611770@frogsfrogsfrogs>
References: <173706974044.1927324.7824600141282028094.stgit@frogsfrogsfrogs>
 <173706974228.1927324.17714311358227511791.stgit@frogsfrogsfrogs>
 <Z48bYVRvWt-wPmUz@dread.disaster.area>
 <20250121124430.GA3809348@mit.edu>
 <Z5AaHkvdwqHKpPyO@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z5AaHkvdwqHKpPyO@dread.disaster.area>

On Wed, Jan 22, 2025 at 09:05:18AM +1100, Dave Chinner wrote:
> On Tue, Jan 21, 2025 at 07:44:30AM -0500, Theodore Ts'o wrote:
> > On Tue, Jan 21, 2025 at 02:58:25PM +1100, Dave Chinner wrote:
> > > > +# Are there mkfs options to try to improve concurrency?
> > > > +_scratch_mkfs_concurrency_options()
> > > > +{
> > > > +	local nr_cpus="$(( $1 * LOAD_FACTOR ))"
> > > 
> > > caller does not need to pass a number of CPUs. This function can
> > > simply do:
> > > 
> > > 	local nr_cpus=$(getconf _NPROCESSORS_CONF)
> > > 
> > > And that will set concurrency to be "optimal" for the number of CPUs
> > > in the machine the test is going to run on. That way tests don't
> > > need to hard code some number that is going to be too large for
> > > small systems and to small for large systems...
> > 
> > Hmm, but is this the right thing if you are using check-parallel?
> 
> Yes. The whole point of check-parallel is to run the tests in such a
> way as to max out the resources of the test machine for the entire
> test run. Everything that can be run concurrently should be run
> concurrently, and we should not be cutting down on the concurrency
> just because we are running check-parallel.
> 
> > If
> > you are running multiple tests that are all running some kind of load
> > or stress-testing antagonist at the same time, then having 3x to 5x
> > the number of necessary antagonist threads is going to unnecessarily
> > slow down the test run, which goes against the original goal of what
> > we were hoping to achieve with check-parallel.
> 
> There are tests that run a thousand concurrent fsstress processes -
> check-parallel still runs all those thousand fsstress processes.
> 
> > How many tests are you currently able to run in parallel today,
> 
> All of them if I wanted. Default is to run one test per CPU at a
> time, but also to allow tests that use concurrency to maximise it.
> 
> > and
> > what's the ultimate goal?
> 
> My initial goal was to maximise the utilisation of the machine when
> testing XFS. If I can't max out a 64p server with 1.5 million
> IOPS/7GB/s IO and 64GB RAM with check-parallel, then check-parallel
> is not running enough tests in parallel.
> 
> Right now with 64 runner threads (one per CPU), I'm seeing an
> average utilisation across the whole auto group XFS test run of:
> 
> -50 CPUs
> - 2.5GB/s IO @ 30k IOPS
> - 40GB RAM
> 
> The utilisation on ext4 is much lower and runtimes are much longer
> for (as yet) unknown reasons. Concurrent fsstress loads, in
> particular, appear to run much slower on ext4 than XFS...
> 
> > We could have some kind of antagonist load
> > which is shared across multiple tests, but it's not clear to me that
> > it's worth the complexity.
> 
> Yes, that's the plan further down the track - stuff like background
> CPU hotplug (instead of a test that specifically runs hotplug with
> fsstress that takes about 5 minutes to run), cache dropping to add
> memory reclaim during tests, etc
> 
> > (And note that it's not just fs and cpu
> > load antagonistsw; there could also be memory stress antagonists, where
> > having multiple antagonists could lead to OOM kills...)
> 
> Yes, I eventually plan to use the src/usemem.c memory locker to
> create changing levels of background memory stress to the test
> runs...
> 
> Right now "perturbations" are exercised as a side effect of random
> tests performing these actions. I want to make them controllable by
> check-parallel so we can exercise the system functionality across
> the entire range of correctness tests we have, not just an isolated
> test case.
> 
> IOWs, the whole point of check-parallel is to make use of large
> machines to stress the whole OS at the same time as we are testing
> for filesystem behavioural correctness.
> 
> I also want to do it in as short a time period as possible - outside
> of dedicated QE environments, I don't beleive that long running
> stress tests actually provide value for the machine time they
> consume. i.e. returns rapidly diminish because stress tests
> cover 99.99% of the code paths they are going to exercise in the
> first few minutes of running.
> 
> Yes, letting them run for longer will -eventually- cover rarely
> travelled code paths, but for developers, CI systems and
> first/second level QE verification of bug fixes we don't need
> extended stress tests.

Admittedly the long soak tests probably don't add much once the scratch
device has filled up and been cleaned out a few times.  Maybe that
sacrificial usemem would be useful sooner than later.

ATM the online repair vs fsstress soak test is still pretty useful for
probing just how bad things can get in terms of system stress and
stalling, but that's only because repairs are resource intensive. :)

--D

> Further, when we run fstests in the normal way, we never cover
> things like memory reclaim racing against unmount, freeze, sync,
> etc. And we never cover them when the system is under extremely
> heavy load running multiple GB/s of IO whilst CPU hotplug is running
> whilst the scheduler is running at nearly a million context
> switches/s, etc.
> 
> That's exactly the sort of loads that check-parallel is generating
> on a machine just running the correctness tests in parallel. It
> combines correctness testing with a dynamic, stressful environment,
> and it runs the tests -fast-. The coverage I get in a single 10
> minute auto-group run of check-parallel is -much higher- than I get
> in a single auto-group run of check that takes 4 hours on the same
> hardware to complete....
> 
> -Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 
