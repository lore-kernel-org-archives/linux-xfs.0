Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 058FB24886E
	for <linux-xfs@vger.kernel.org>; Fri, 16 Oct 2026 01:07:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792112823; cv=none; b=t9xjyOpDduq3Yd/GfygDteX3LuU7nx042HBpmzjlMj/jW92SzApIEL3YN7CeiUgoAv+wqPafgF8g4Wp9GOE93gJANnu02tCNjWLqk399j4Hjop85+0ch+PFCvpkW3QWYKtOH0uGy2dqaRcX+4Bdyb+GCphzFwMCUaWg+O/fDlU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792112823; c=relaxed/simple;
	bh=t4NDIIl6mPVmPbRsIaZb1ZwfE5mwPmrXxC7DNe31p3E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YnMKlZB5RZfc2L/qwgIsYQfji4WYHLgp2d/chcOifxSfvmaiCadpP0jjDmQiB7ffw0FF/z4uL4iSy25HZQVF2HGAEZABsaZZCwMaYccEMw8PaKONqLHuzoPnM2nE3MvW7IKW6g0i1xLA44HgfrArPU/+zB2OZJQJb1GNy3EUJx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=j3HvcFHX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="j3HvcFHX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D01561F000C4;
	Fri, 16 Oct 2026 01:07:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792112822;
	bh=OQzEfKikLvbG90/XbvvvFQDwxelGuA8ejVZzhNpMu3A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=j3HvcFHXKAymx2RuXTXYUWENGSX09AVhzf3tYyECEp8Xhkz+op78VpfCtfGZmRVQV
	 HJmkNQx2Z1WEC7wCiIE39YZoXz1+VEIdJhUhRqFQ3yeyq0ptcruLclPof9tzpd4uTU
	 gb3N5fsvRHGUrTXrr8x3W2RU/WCcff3e2yNIFE9HZ/FYLquX++T1OttY1yjMbbit2H
	 /CkdksETHdWuCInJPyebmrRLxDDww3lX1Psxi76u1x+dFN7YVfVaelw1VipvEjcpTk
	 e1i8kjHvUD5lqpIgm8hJkL/sUqbrFbrTPHNGtRPaPYpHNlUlwU1Krlk4Sd8LyxWN6w
	 H8SNRP8w80tUQ==
Date: Fri, 16 Oct 2026 12:06:54 +1100
From: Dave Chinner <dgc@kernel.org>
To: Vitali Lovich <vlovich@gmail.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: Really bad I/O lock contention between non-overlapping reader
 and writer
Message-ID: <atF4rrzDigoX0Zyv@dread>
References: <CAF8PYMjkpEkoop-Wbk=2oBMdqer-pWh1osPvhSv90D2fwLSv0w@mail.gmail.com>
 <as1HVVUXdMlpXQGT@dread>
 <CAF8PYMiMZ5uFGsLnms4pNtMHc=TKgzcKvoLtydGXEFS7KM_r5g@mail.gmail.com>
 <as7wb-bdykxSKenP@dread>
 <CAF8PYMhk202oMMNAdT0yPDD=J8rG5kgKVRSRnf5ix+x6_SJmYQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAF8PYMhk202oMMNAdT0yPDD=J8rG5kgKVRSRnf5ix+x6_SJmYQ@mail.gmail.com>

On Wed, Oct 14, 2026 at 04:10:30PM -0700, Vitali Lovich wrote:
> Ok. I have a patch series I'm happy to share. It has no meaningful
> performance degradation / scaling problems and largely fixes the
> head-of-line blocking problem without the challenges of range
> tracking. Before I post it, some stylistic questions for you:
> 
> * Do you prefer it as a new RFC e-mail chain or continue here

New patch series.

> * Are there specific benchmarks / workloads you'd like me to gather numbers?

FIO exercising random rw 4kB DIO at differing levels of concurrency
is the minimum.

> * Is a VM with RAM XFS filesystem sufficient or is raw metal w/ an
> NVMe drive required?

I'd typically test this on a machine with 32+ CPU cores and an IO
subsystem that can sustain >2 million random 4kB writes
indefinitely. I'd then use fio using pre-written files to hit it
with increasing IO concurrency to the same file with either io_uring
or AIO with direct IO to exercise shared access scalability.

And I'd do this with both the current code (rwsem) and whatever new
locking technique I am testing. The key point here is having enough
CPU cores in the machine to demonstrate the effect of contention on
shared structures.

I also wrote a bunch of micro-benchmarks to stress overlapping IO to
ensure that exclusion occurred correctly, as well as to test
scalability when overlapping range operations are occurring. e.g.
what happens when you have lots of IO in progress, and you do an
operation that needs exclusive access to the entire file (e.g.
FICLONE on an active file).

i.e. demonstration of worst case behaviour is needed because that is
often more important than best case benchmarketing numbers.

-Dave.
-- 
Dave Chinner
dgc@kernel.org
