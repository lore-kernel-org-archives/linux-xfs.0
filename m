Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA459195;
	Wed, 11 Dec 2024 22:57:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733957848; cv=none; b=LapJyUY4Wjf59Lzb37O0s6gw99ph8j2LiW3817DDQRA1beawNlcKOy1TcfLImCxrPTQgVQa42N5bE7Nf4pyAlC9xrx1UOAqt9df/vGrglCh6U9DNsaN3GPBIGy5hfjQ/n8xHMF4Kg8HZlfuFS+WvJ/WdjdibXEUOg1EEgRER/vw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733957848; c=relaxed/simple;
	bh=AhG1dZqSn4OdTVZXqiAmtpsoZGAPXio6wJK1pRFaBv4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BQ2JlVDaFeJtny4jNWPTehswmzI5+MBYBDstkVWwdHW1dETMKjZAJz94EwyzDv8il5ByC57GC9HlaMwIVJKrdfB+WE3b8MGfzKGz4h4z5oC/4of0MGSBSZU6XDGk/0VUA/DB1xjrtEYv9aYixebxBmRg2J7x6i3c3ORAZlvK7l8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Nyn4XWb7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Nyn4XWb7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FAFDC4CED2;
	Wed, 11 Dec 2024 22:57:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733957847;
	bh=AhG1dZqSn4OdTVZXqiAmtpsoZGAPXio6wJK1pRFaBv4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Nyn4XWb7xB9FmGz2yi+kwE8ra/hI4lGra7x66nGmUcwRcTlArPbi1DRaXZBjr0Igh
	 K4mMIa13zSlyIiF2i8PZK6QdP2BVujmZ6miutgggguLhqUj0Heifv2lunlitOrm5OV
	 z6dpby/D3WysUiQXhdq5i6woijHw+b9BOpFAQr9DhsWBVsCeppFxQKf1hwbBlYglsJ
	 uDtj2otIBbg2TLA+bV00XJ1Bgdb1y9tTeLMGd/sJ8D1zM64T2ucK7SXPonlxI31AQj
	 3eNabSywFzeXHSF3nzrMtGeHUwhwkxZbPOHRlyfuYnI4JbopmlRpzklpIYVJ/5DcWF
	 F6JjcaGGoIwPA==
Date: Wed, 11 Dec 2024 12:57:26 -1000
From: Tejun Heo <tj@kernel.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [6.13-rc0 regression] workqueue throwing cpu affinity warnings
 during CPU hotplug
Message-ID: <Z1oY1qk-eWU8IcH3@slm.duckdns.org>
References: <Zz_Sex6G6IKernao@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zz_Sex6G6IKernao@dread.disaster.area>

Hello, Dave.

Sorry about the really late reply.

On Fri, Nov 22, 2024 at 11:38:19AM +1100, Dave Chinner wrote:
> Hi Tejun,
> 
> I just upgraded my test VMs from 6.12.0 to a current TOT kernel and
> I got several of these warnings whilst running fstests whilst
> running CPU hotplug online/offline concurrently with various tests:
> 
> [ 2508.109594] ------------[ cut here ]------------
> [ 2508.115669] WARNING: CPU: 23 PID: 133 at kernel/kthread.c:76 kthread_set_per_cpu+0x33/0x50
...
> [ 2508.253909]  <TASK>
> [ 2508.311972]  unbind_worker+0x1b/0x70
> [ 2508.315444]  workqueue_offline_cpu+0xd8/0x1f0
> [ 2508.319554]  cpuhp_invoke_callback+0x13e/0x4f0
> [ 2508.328936]  cpuhp_thread_fun+0xda/0x120
> [ 2508.332746]  smpboot_thread_fn+0x132/0x1d0
> [ 2508.336645]  kthread+0x147/0x170
> [ 2508.347646]  ret_from_fork+0x3e/0x50
> [ 2508.353845]  ret_from_fork_asm+0x1a/0x30
> [ 2508.357773]  </TASK>
> [ 2508.357776] ---[ end trace 0000000000000000 ]---

So, this is kthread saying that the thread passed to it doesn't have
PF_KTHREAD set. There hasn't been any related changes and the flag is never
cleared once set, so I don't see how that could be for a kworker.

> I have also seen similar traces from the CPUs coming on-line:
> 
> [ 2535.818771] WARNING: CPU: 23 PID: 133 at kernel/kthread.c:76 kthread_set_per_cpu+0x33/0x50
> ....
> [ 2535.969004] RIP: 0010:kthread_set_per_cpu+0x33/0x50
> ....
> [ 2508.249599] Call Trace:
> [ 2508.253909]  <TASK>
> [ 2535.969029]  workqueue_online_cpu+0xe6/0x2f0
> [ 2535.969032]  cpuhp_invoke_callback+0x13e/0x4f0
> [ 2535.969044]  cpuhp_thread_fun+0xda/0x120
> [ 2535.969047]  smpboot_thread_fn+0x132/0x1d0
> [ 2535.969053]  kthread+0x147/0x170
> [ 2535.969066]  ret_from_fork+0x3e/0x50
> [ 2535.969076]  ret_from_fork_asm+0x1a/0x30
> [ 2508.357773]  </TASK>

Yeah, this is the same.

> I didn't see these on 6.12.0, so I'm guessing that there is
> something in the merge window that has started triggering this.

I tried a few mixtures of stress-ng + continuous hot [un]plugging but can't
reproduce in the current linus#master. Do you still see this happening?

Thanks.

-- 
tejun
