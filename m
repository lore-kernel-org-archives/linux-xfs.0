Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF8CA2D0629
	for <linux-xfs@vger.kernel.org>; Fri, 16 Oct 2026 01:20:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792113614; cv=none; b=l0n4f9le2Z15DVLA0cyWM6oFyYNh4OgU30aebrfcUlxRNVICrSoJckV0oDpnKhDjxMMT4NlzBOT+lcSSVAsP/gsbzKuEpWAfaTlqYDAWTlMoIQ5M4Dq1LwCzuLMMQtSy5WmEGW6YspEF777IreRBvi6NFtPzMwU3SUoOYLFH4Mk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792113614; c=relaxed/simple;
	bh=IpRnU2RQw5GSRK3wfyzOuiQRM7t8i9MAsO8gLoexm34=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=a4+IfuLeH7bX81jqxW41OtV7kmQepbJarF2l2lvBJ40NyhBr4HSRJI4NSurKdNrJMg4u3qS88GNbuBVGBC3bzypOP9jBLrUn1KjP2kge+J8m25BtPz0OPfblw9oRyKDHoRih0069zA0oirq3/91lulYo1BQ5xfZ0z69ulTSKMFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FnJrfxge; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FnJrfxge"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACE5A1F000C4;
	Fri, 16 Oct 2026 01:20:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792113612;
	bh=RwRukaZDZO84uj06NdEUATXmFYMD6o6rUoG+NLULtA4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=FnJrfxgeG03w1EYUKAgh5aqVTJhVK8fBKPgN4AurztVsPk96TRQdLms/oiuluyB7G
	 W8zKtMH5eFdv0nJMpSR1cDQm7zfYPf9zNHKs5KFLIIx/CCnc3UlG+o5PiG7F8iD9wW
	 I2K3S+ayn1mGNxVTA5rhlm58oPonURhNIUMSsBtmfSwwE7FNSoBrQzTmVM1Ssk4Qkl
	 KWTZ8WQr4JQSDxL/erEHk6attLn3EfTOstf3J9e9oYBnPviIpcNt93KGeAAJNShkRQ
	 iyQtUAIsCPrgDfMxPgdk6I8gRwy3t+JnT0vMSJjlZHvrtfXigRmbEF/Wh/plwV5A9D
	 Ht4wy1BDEOl+A==
Date: Fri, 16 Oct 2026 12:20:04 +1100
From: Dave Chinner <dgc@kernel.org>
To: Vitali Lovich <vlovich@gmail.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: Really bad I/O lock contention between non-overlapping reader
 and writer
Message-ID: <atF7xJlbck-xA1G3@dread>
References: <CAF8PYMjkpEkoop-Wbk=2oBMdqer-pWh1osPvhSv90D2fwLSv0w@mail.gmail.com>
 <as1HVVUXdMlpXQGT@dread>
 <CAF8PYMiMZ5uFGsLnms4pNtMHc=TKgzcKvoLtydGXEFS7KM_r5g@mail.gmail.com>
 <as7wb-bdykxSKenP@dread>
 <CAF8PYMhk202oMMNAdT0yPDD=J8rG5kgKVRSRnf5ix+x6_SJmYQ@mail.gmail.com>
 <atF4rrzDigoX0Zyv@dread>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <atF4rrzDigoX0Zyv@dread>

On Fri, Oct 16, 2026 at 12:06:54PM +1100, Dave Chinner wrote:
> On Wed, Oct 14, 2026 at 04:10:30PM -0700, Vitali Lovich wrote:
> > Ok. I have a patch series I'm happy to share. It has no meaningful
> > performance degradation / scaling problems and largely fixes the
> > head-of-line blocking problem without the challenges of range
> > tracking. Before I post it, some stylistic questions for you:
> > 
> > * Do you prefer it as a new RFC e-mail chain or continue here
> 
> New patch series.
> 
> > * Are there specific benchmarks / workloads you'd like me to gather numbers?
> 
> FIO exercising random rw 4kB DIO at differing levels of concurrency
> is the minimum.
> 
> > * Is a VM with RAM XFS filesystem sufficient or is raw metal w/ an
> > NVMe drive required?
> 
> I'd typically test this on a machine with 32+ CPU cores and an IO
> subsystem that can sustain >2 million random 4kB writes
> indefinitely. I'd then use fio using pre-written files to hit it
> with increasing IO concurrency to the same file with either io_uring
> or AIO with direct IO to exercise shared access scalability.

Oh, I should have mentioned: RAM disks are -slow- compared to a
single high performance NVMe SSD, let alone a machine with a couple
of dozen of them.

THe problem is that RAM disks always do synchronous IO and they
consume CPU time copying the data to/from the RAM disk to/from user
buffers. Hence you can only have one IO per CPU in flight at a time,
instead of a few thousand IOs in flight per CPU when using
asynchronous IO on spread across many NVMe SSDs.

IOWs, never use ram disks for performance testing XFS filesystems -
the results never reflect real world performance on actual storage
hardware.

-Dave.

-- 
Dave Chinner
dgc@kernel.org
