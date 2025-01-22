Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCF3E8467
	for <linux-xfs@vger.kernel.org>; Wed, 22 Jan 2025 04:09:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737518944; cv=none; b=cUkWkf3nps2RDdytSzaXLMZGYSHAsLANrxQ++/zy2jkv3G9TSlVMzHw4nKOqUqEfh/GZ1skH+zr9ofBKQfdctk6MMlEVBuC7kh/x55BJdiuRe99kRt5FIUPFme6LRy+d/fmkHX2NP6HzYSVmgND4cf9+2Rm6Yz9Uwt/YReW/BKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737518944; c=relaxed/simple;
	bh=IVrSh50+C0FBL/f3KxRmJuxRgxVx3mZs/eYAgvcY8fg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gLJIbky9UoiIVPZJq/UwU6iqPbCu4LCKkuJybk7mH6odXUpDlBTbmGtj0TUYv0pQh/uM+7ro7x4RCpLy22Rvm18XHDKh+PcjxnLJyHTGVu83dkifavAznbYhn/j9MxrayrkKHKAD0NMP2cyw+0Q+ztp840iHPeNv0KvS6Z+ntx8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=FG8wH0O7; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="FG8wH0O7"
Received: from cwcc.thunk.org (pool-173-48-114-200.bstnma.fios.verizon.net [173.48.114.200])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 50M48dRY014584
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 21 Jan 2025 23:08:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1737518921; bh=RjDEG3m3fQmhCtSZSRO4bvePvCBpsgjy3qwcNmtv9Hk=;
	h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
	b=FG8wH0O7TIX3RA2+OmNS8sntMkqI7JSAjc+Nvws8IflhF68qEWwTv28M17lgiAooO
	 D7a8I0GBqUzlc/tt8jJRNES3qv66CU1wPROjHGLZcQC6omR2nchP9B+tJeL54XraHs
	 pgcT+2fWiGKekfnvEsGEVqSZRKX2SVe8jbKGa2/UJn2zclhQB3TBx3JrA2WwoxpCFg
	 EpQhoduvnDc5uJmQ7ucCp+d/MMvU+d7zJBvpYItBRILTcOuBntUnQ0ud32wATxcvA3
	 aR/6EJ6xk2x2OKNO74SG4f0mT5Lg9ynkImXrBNWELAUoXS8Y+2V5KFxI0uRKe+hEMp
	 C8EE2X36uWpFQ==
Received: by cwcc.thunk.org (Postfix, from userid 15806)
	id 6615115C01A1; Tue, 21 Jan 2025 23:08:39 -0500 (EST)
Date: Tue, 21 Jan 2025 23:08:39 -0500
From: "Theodore Ts'o" <tytso@mit.edu>
To: Dave Chinner <david@fromorbit.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>, zlang@redhat.com, hch@lst.de,
        fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 13/23] generic/650: revert SOAK DURATION changes
Message-ID: <20250122040839.GD3761769@mit.edu>
References: <173706974044.1927324.7824600141282028094.stgit@frogsfrogsfrogs>
 <173706974273.1927324.11899201065662863518.stgit@frogsfrogsfrogs>
 <Z48pM9GEhp9P_VLX@dread.disaster.area>
 <20250121130027.GB3809348@mit.edu>
 <Z5AclEe71PIikAnH@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z5AclEe71PIikAnH@dread.disaster.area>

On Wed, Jan 22, 2025 at 09:15:48AM +1100, Dave Chinner wrote:
> check-parallel on my 64p machine runs the full auto group test in
> under 10 minutes.
> 
> i.e. if you have a typical modern server (64-128p, 256GB RAM and a
> couple of NVMe SSDs), then check-parallel allows a full test run in
> the same time that './check -g smoketest' will run....

Interesting.  I would have thought that even with NVMe SSD's, you'd be
I/O speed constrained, especially given that some of the tests
(especially the ENOSPC hitters) can take quite a lot of time to fill
the storage device, even if they are using fallocate.

How do you have your test and scratch devices configured?

> Yes, and I've previously made the point about how check-parallel
> changes the way we should be looking at dev-test cycles. We no
> longer have to care that auto group testing takes 4 hours to run and
> have to work around that with things like smoketest groups. If you
> can run the whole auto test group in 10-15 minutes, then we don't
> need "quick", "smoketest", etc to reduce dev-test cycle time
> anymore...

Well, yes, if the only consideration is test run time latency.

I can think of two off-setting considerations.  The first is if you
care about cost.  The cheapest you can get a 64 CPU, 24 GiB VM on
Google Cloud is $3.04 USD/hour (n1-stndard-64 in a Iowa data center),
so ten minutes of run time is about 51 cents USD (ignoring the storage
costs).  Not bad.  But running xfs/4k on the auto group on an
e2-standard-2 VM takes 3.2 hours; but the e2-standard-2 VM is much
cheaper, coming in at $0.087651 USD/ hour.  So that translates to 28
cents for the VM, and that's not taking into account the fact you
almost certainly much more expensive, high-performance storge to
support the 64 CPU VM.  So if you don't care about time to run
completion (for example, if I'm monitoring the 5.15, 6.1, 6.6, and
6.12 LTS LTS rc git trees, and kicking off a build whenever Greg or
Sasha updates them), using a serialized xfstests is going to be
cheaper because you can use less expensive cloud resources.

The second concern is that for certain class of failures (UBSAN,
KCSAN, Lockdep, RCU soft lockups, WARN_ON, BUG_ON, and other
panics/OOPS), if you are runnig 64 tests in parllel it might not be
obvious which test caused the failure.  Today, even if the test VM
crashes or hangs, I can have test manager (which runs on a e2-small VM
costing $0.021913 USD/hour and can manage dozens of test VM's all at the
same time), can restart the test VM, and we know which test is at at
fault, and we mark that a particular test with the Junit XML status of
"error" (as distinct from "success" or "failure").  If there are 64
test runs in parallel, if I wanted to have automated recovery if the
test appliance hangs or crashes, life gets a lot more complicated.....
I suppose we could have the human (or test automation) try run each
individual test that had been running at the time of the crash but
that's a lot more complicated, and what if the tests pass when run
once at a time?  I guess we should happen that check-parallel found a
bug that plain check didn't find, but the human being still has to
root cause the failure.

Cheers,

						- Ted
