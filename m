Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E30C4170A30;
	Wed, 22 Jan 2025 07:02:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737529334; cv=none; b=IrueUvSTs82RLXrpPMdYv3ExFWifTqwilCACRcY2jHpa9+uGXDn/mVIafVrRafkdCCMeV9vEkAGWbCYfom4sMYMAVdUowIdcE9yW5iWHiG3AZBHgbTiKOCV3kfht4F1Ulu68Ctx8/mBuA3pLJmeDZn0a/pyE43RmCyp+vPZpWY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737529334; c=relaxed/simple;
	bh=E8DKODeyKKi8YQv0D18OmMB6E9G1CrG2xBoE1zyCAXE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AKreA/09BYvbmLo/BnQWrxpBMlwhGB/6px8INrgEg0xx2XgkC7k6+wKlzozBgfCbDv4YdDEtJM+AWl96/by33C46lRHyfvqLxTDGuKz8lQthMQ5QxAWIGFCKw/qkDXaAfCEXyZ6O2Jk8fN+aF0/weld3DJ9C2oPWwO1QbGGKGEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iLQkn1m+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iLQkn1m+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53E76C4CED6;
	Wed, 22 Jan 2025 07:02:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737529333;
	bh=E8DKODeyKKi8YQv0D18OmMB6E9G1CrG2xBoE1zyCAXE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=iLQkn1m+IXD/UcwHAxXykVjpnZC1tagNPHzqTTVLXEmbD+fOLBNkQqQMt0f2Lks1v
	 MPG3aUgTFSTatnV/ISznzUcA9CyWOJEBjIoRMvFxrxEKSsiiNeg6K3/5imXqbDbhQw
	 MMOTO33UZdKJbI41NHZmEbcd9N3wSksmB2BehMOR9UKOQiBSnsWk4mncvzG9gT8+9h
	 Z6EsWDS4pOG9Qm8dppvSVs2lIYsOE2+6QXA/l7DJU574LUmG9GsGUC2tDy6iwxgThn
	 qQNrGZwN0OzbY1oyW9ocqDH6SmFkY6NCMHeXy3N6i4XMV61p5hKinLW0RoCe8SdIcH
	 jR3pppWYJLRcg==
Date: Tue, 21 Jan 2025 23:02:12 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Dave Chinner <david@fromorbit.com>
Cc: Theodore Ts'o <tytso@mit.edu>, zlang@redhat.com, hch@lst.de,
	fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 13/23] generic/650: revert SOAK DURATION changes
Message-ID: <20250122070212.GC1611770@frogsfrogsfrogs>
References: <173706974044.1927324.7824600141282028094.stgit@frogsfrogsfrogs>
 <173706974273.1927324.11899201065662863518.stgit@frogsfrogsfrogs>
 <Z48pM9GEhp9P_VLX@dread.disaster.area>
 <20250121130027.GB3809348@mit.edu>
 <Z5AclEe71PIikAnH@dread.disaster.area>
 <20250122040839.GD3761769@mit.edu>
 <Z5CJy195Fh36NNHN@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z5CJy195Fh36NNHN@dread.disaster.area>

On Wed, Jan 22, 2025 at 05:01:47PM +1100, Dave Chinner wrote:
> On Tue, Jan 21, 2025 at 11:08:39PM -0500, Theodore Ts'o wrote:
> > On Wed, Jan 22, 2025 at 09:15:48AM +1100, Dave Chinner wrote:
> > > check-parallel on my 64p machine runs the full auto group test in
> > > under 10 minutes.
> > > 
> > > i.e. if you have a typical modern server (64-128p, 256GB RAM and a
> > > couple of NVMe SSDs), then check-parallel allows a full test run in
> > > the same time that './check -g smoketest' will run....
> > 
> > Interesting.  I would have thought that even with NVMe SSD's, you'd be
> > I/O speed constrained, especially given that some of the tests
> > (especially the ENOSPC hitters) can take quite a lot of time to fill
> > the storage device, even if they are using fallocate.
> 
> You haven't looked at how check-parallel works, have you? :/
> 
> > How do you have your test and scratch devices configured?
> 
> Please go and read the check-parallel script. It does all the
> per-runner process test and scratch device configuration itself
> using loop devices.
> 
> > > Yes, and I've previously made the point about how check-parallel
> > > changes the way we should be looking at dev-test cycles. We no
> > > longer have to care that auto group testing takes 4 hours to run and
> > > have to work around that with things like smoketest groups. If you
> > > can run the whole auto test group in 10-15 minutes, then we don't
> > > need "quick", "smoketest", etc to reduce dev-test cycle time
> > > anymore...
> > 
> > Well, yes, if the only consideration is test run time latency.
> 
> Sure.
> 
> > I can think of two off-setting considerations.  The first is if you
> > care about cost.
> 
> Which I really don't care about.
> 
> That's something for a QE organisation to worry about, and it's up
> to them to make the best use of the tools they have within the
> budget they have.
> 
> > The second concern is that for certain class of failures (UBSAN,
> > KCSAN, Lockdep, RCU soft lockups, WARN_ON, BUG_ON, and other
> > panics/OOPS), if you are runnig 64 tests in parllel it might not be
> > obvious which test caused the failure.
> 
> Then multiple tests will fail with the same dmesg error, but it's
> generally pretty clear which of the tests caused it. Yes, it's a bit
> more work to isolate the specific test, but it's not hard or any
> different to how a test failure is debugged now.
> 
> If you want to automate such failures, then my process is to grep
> the log files for all the tests that failed with a dmesg error then
> run them again using check instead of check-parallel.  Then I get
> exactly which test generated the dmesg output without having to put
> time into trying to work out which test triggered the failure.
> 
> > Today, even if the test VM
> > crashes or hangs, I can have test manager (which runs on a e2-small VM
> > costing $0.021913 USD/hour and can manage dozens of test VM's all at the
> > same time), can restart the test VM, and we know which test is at at
> > fault, and we mark that a particular test with the Junit XML status of
> > "error" (as distinct from "success" or "failure").  If there are 64
> > test runs in parallel, if I wanted to have automated recovery if the
> > test appliance hangs or crashes, life gets a lot more complicated.....
> 
> Not really. Both dmesg and the results files will have tracked all
> the tests inflight when the system crashes, so it's just an extra
> step to extract all those tests and run them again using check
> and/or check-parallel to further isolate which test caused the
> failure....

That reminds me to go see if ./check actually fsyncs the state and
report files and whatnot between tests, so that we have a better chance
of figuring out where exactly fstests blew up the machine.

(Luckily xfs is stable enough I haven't had a machine explode in quite
some time, good job everyone! :))

--D

> I'm sure this could be automated eventually, but that's way down my
> priority list right now.
> 
> > I suppose we could have the human (or test automation) try run each
> > individual test that had been running at the time of the crash but
> > that's a lot more complicated, and what if the tests pass when run
> > once at a time?  I guess we should happen that check-parallel found a
> > bug that plain check didn't find, but the human being still has to
> > root cause the failure.
> 
> Yes. This is no different to a test that is flakey or compeltely
> fails when run serially by check multiple times. You still need a
> human to find the root cause of the failure.
> 
> Nobody is being forced to change their tooling or processes to use
> check-parallel if they don't want or need to. It is an alternative
> method for running the tests within the fstests suite - if using
> check meets your needs, there is no reason to use check-parallel or
> even care that it exists...
> 
> -Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 
