Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFA8C32FA3F
	for <linux-xfs@vger.kernel.org>; Thu,  5 Feb 2026 21:18:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770326282; cv=none; b=DaUOYu6HNsoOFMomkxzWNIb/99gzlzs3S/VkkgPmZpP2/eBKSg5veko8E6qJjZfGKtBUNJYPLIs06Jcu+zvd5plxK6NHoLSztzcnEBPws9bCWCuaEGnmwCfmojaKseYvu9Q7C27V9BCR04xggWdsz5VXppsqKQS6zgqg8rFyITA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770326282; c=relaxed/simple;
	bh=azW+Er9DVWyfLE4RxzMCv6BNZ8bp0rt83hTE3gEkO+g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gNDbhWXh7RNZKbkgdF+7vCnws/GYTc+2d325r8NvIBEeflXRvUlbRkodqz52rqjT0r72QrxYbipALUzKsJaR/Q3QSYhCrzyGjr8Fvm3ZfAG02WXpCrURZjaTUUR2B12Yr7s8nvqlEL0im/TcdVoOg1kCFHheY/yY1SxCg0Kz4g0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=y+p9/Hal; arc=none smtp.client-ip=209.85.216.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="y+p9/Hal"
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-34be2be4b7cso750142a91.3
        for <linux-xfs@vger.kernel.org>; Thu, 05 Feb 2026 13:18:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1770326281; x=1770931081; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=na2GFQeCH4nfrXfEZgtguqNxC9+KQ+7DBpsjE1+E+0c=;
        b=y+p9/Halh4nvHhyYanofkzxZhPFibYSqab7SnjQPn/P2GOJJK2DNrE9HXXEE2SLs45
         d+Y/A3jRyQ0JiwxskSKQ/RmnnDfEgmTxcUlz/wHdFq+7zTFH47qMRH9A1LPgNJsI63LZ
         f0Cuezm0NvOw9/izhf3H2kIxoQPvFgo5wwyJkeqXoRxlZOUztjj11uHYa9WPDGyMagNH
         pffbTIiHiXxhystuSpOqVAmHQMTy8YetdU6n9GkLkz70CSHZG/NMdLriL3D7TKNENltL
         hqOe2fAflxyeMFjYolee90TBKHiQ+OD0Gz2h+B3+hM9DA8gE2BAxUJfLtMO4iizNUCGx
         4NzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770326281; x=1770931081;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=na2GFQeCH4nfrXfEZgtguqNxC9+KQ+7DBpsjE1+E+0c=;
        b=tyuE/A6ub5fYqTcgMrtWl2GA87NpNkFDshV9Ivxu5VOVcKPPX8ESeM8hUcot+2yfC1
         c75YxdFXmnucpTf8vdtgihCHxI0xJFg4PdmUGvN+GCHqZxLqt8/HiYiWUlnMGHaly85U
         /P4EOQyzES18K4uWuOF5otgR2X+VlxK4XzzqN6mxjTHP9/licw5cGOaKMLhSP5QkRL/7
         QWSLJvLYfJZ3kayf2mQhKhdpfE2HWJsd2brMtsDfdetwsMdgWVCsQIthmEAMdmisi1Mo
         hszrcuqF0vjSpuAIzFcbExWjJgNfny6TjJa7c20+O4E4vA6o/qFvU9s2TZuYMG0rWepF
         Sa4A==
X-Forwarded-Encrypted: i=1; AJvYcCUesVbVc4mebttEr/hKsFD7c6dzvjLYYmuMN/UuIaa6a+0tzp2WPfAp8ezFed7Uyz4hsnC4nIKc5To=@vger.kernel.org
X-Gm-Message-State: AOJu0YxtQ4TR+QDwXJ/3Np4ymLDkG0tFQNhAv4TTHn8a1/4zLRch5M+N
	CqMQDIDENAMPJ3qFW8GICTnLh+D1PTeibVtStoKrdLq60PEJtu4JRcH2ftpKB1wiJ6WdZ4FqDeg
	0L4x3
X-Gm-Gg: AZuq6aJRkdtQXYEJRBLHGkgHZAzSEJsPXkRoTTBivWcBBu7Nbmep9Ouf9eDHHNd6G4r
	MAmj3x4ZLhv1YflaviON8UsS85NDjRRk7TBOQJaPNa15yZFgQ0EsMmCktHtsWLl/zN8inH2SxEe
	vURk5vPPLwbFsqLFyGZa6eFuwZklRRgag43DzeaNh9YrfBuhr20Hd9NenbFO3Uf2gYn0mmE6fPB
	kKbemG02bOBgfF766mHp+uJr3PMOW3xVkLPJ6Uj+CsmzCu+ztpwPd0ibkgguWeU3wdRohptLg5S
	JUJHG1/jkqi7L5NT+f5ZFq0ZSH4h1O5JFepq8NdYaGmlJKDIdrblaK6rX1Q0zBzyHlsy0HENX+G
	xa89ptWn+AKYNUp4RcXwYd4SKAJBvLaX86644eMWVF9MtB1diBi4X7YxfxcDtt5uj/g8OyFdBMO
	LNN0pdA7/2tTxhg3T3oLVDByI0bKoQ0XhWEAelw9QUInnbTj2qm6rE2UTIX743yYQ=
X-Received: by 2002:a17:90b:2d86:b0:341:134:a962 with SMTP id 98e67ed59e1d1-354b3e4c3f3mr230761a91.28.1770326281112;
        Thu, 05 Feb 2026 13:18:01 -0800 (PST)
Received: from dread.disaster.area (pa49-180-164-75.pa.nsw.optusnet.com.au. [49.180.164.75])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c6dcb64a103sm318515a12.30.2026.02.05.13.18.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Feb 2026 13:18:00 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.99.1)
	(envelope-from <david@fromorbit.com>)
	id 1vo6jc-0000000DPLm-2pNm;
	Fri, 06 Feb 2026 08:17:56 +1100
Date: Fri, 6 Feb 2026 08:17:56 +1100
From: Dave Chinner <david@fromorbit.com>
To: Jinliang Zheng <alexjlzheng@gmail.com>
Cc: alexjlzheng@tencent.com, cem@kernel.org, linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: take a breath in xfsaild()
Message-ID: <aYUJBChyWi3WdOIR@dread.disaster.area>
References: <aYSCs6kyIZJS5MW4@dread.disaster.area>
 <20260205125000.2324010-1-alexjlzheng@tencent.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260205125000.2324010-1-alexjlzheng@tencent.com>

On Thu, Feb 05, 2026 at 08:49:59PM +0800, Jinliang Zheng wrote:
> On Thu, 5 Feb 2026 22:44:51 +1100, david@fromorbit.com wrote:
> > On Thu, Feb 05, 2026 at 04:26:21PM +0800, alexjlzheng@gmail.com wrote:
> > > From: Jinliang Zheng <alexjlzheng@tencent.com>
> > > 
> > > We noticed a softlockup like:
> > > 
> > >   crash> bt
> > >   PID: 5153     TASK: ffff8960a7ca0000  CPU: 115  COMMAND: "xfsaild/dm-4"
> > >    #0 [ffffc9001b1d4d58] machine_kexec at ffffffff9b086081
> > >    #1 [ffffc9001b1d4db8] __crash_kexec at ffffffff9b20817a
> > >    #2 [ffffc9001b1d4e78] panic at ffffffff9b107d8f
> > >    #3 [ffffc9001b1d4ef8] watchdog_timer_fn at ffffffff9b243511
> > >    #4 [ffffc9001b1d4f28] __hrtimer_run_queues at ffffffff9b1e62ff
> > >    #5 [ffffc9001b1d4f80] hrtimer_interrupt at ffffffff9b1e73d4
> > >    #6 [ffffc9001b1d4fd8] __sysvec_apic_timer_interrupt at ffffffff9b07bb29
> > >    #7 [ffffc9001b1d4ff0] sysvec_apic_timer_interrupt at ffffffff9bd689f9
> > >   --- <IRQ stack> ---
> > >    #8 [ffffc90031cd3a18] asm_sysvec_apic_timer_interrupt at ffffffff9be00e86
> > >       [exception RIP: part_in_flight+47]
> > >       RIP: ffffffff9b67960f  RSP: ffffc90031cd3ac8  RFLAGS: 00000282
> > >       RAX: 00000000000000a9  RBX: 00000000000c4645  RCX: 00000000000000f5
> > >       RDX: ffffe89fffa36fe0  RSI: 0000000000000180  RDI: ffffffff9d1ae260
> > >       RBP: ffff898083d30000   R8: 00000000000000a8   R9: 0000000000000000
> > >       R10: ffff89808277d800  R11: 0000000000001000  R12: 0000000101a7d5be
> > >       R13: 0000000000000000  R14: 0000000000001001  R15: 0000000000001001
> > >       ORIG_RAX: ffffffffffffffff  CS: 0010  SS: 0018
> > >    #9 [ffffc90031cd3ad8] update_io_ticks at ffffffff9b6602e4
> > >   #10 [ffffc90031cd3b00] bdev_start_io_acct at ffffffff9b66031b
> > >   #11 [ffffc90031cd3b20] dm_io_acct at ffffffffc18d7f98 [dm_mod]
> > >   #12 [ffffc90031cd3b50] dm_submit_bio_remap at ffffffffc18d8195 [dm_mod]
> > >   #13 [ffffc90031cd3b70] dm_split_and_process_bio at ffffffffc18d9799 [dm_mod]
> > >   #14 [ffffc90031cd3be0] dm_submit_bio at ffffffffc18d9b07 [dm_mod]
> > >   #15 [ffffc90031cd3c20] __submit_bio at ffffffff9b65f61c
> > >   #16 [ffffc90031cd3c38] __submit_bio_noacct at ffffffff9b65f73e
> > >   #17 [ffffc90031cd3c80] xfs_buf_ioapply_map at ffffffffc23df4ea [xfs]
> > 
> > This isn't from a TOT kernel. xfs_buf_ioapply_map() went away a year
> > ago. What kernel is this occurring on?
> 
> Thanks for your reply. :)
> 
> It's based on v6.6.

v6.6 was released in late 2023. I think we largely fixed this
problem with this series that was merged into 6.11 in mid 2024:

https://lore.kernel.org/linux-xfs/20220809230353.3353059-1-david@fromorbit.com/

In more detail...

> > Can you please explain how the softlockup timer is being hit here so we
> > can try to understand the root cause of the problem? Workload,
> 
> Again, a testsuite combining stress-ng, LTP, and fio, executed concurrently.
> 
> > hardware, filesystem config, storage stack, etc all matter here,
> 
> 
> ================================= CPU ======================================
> Architecture:                            x86_64
> CPU op-mode(s):                          32-bit, 64-bit
> Address sizes:                           45 bits physical, 48 bits virtual
> Byte Order:                              Little Endian
> CPU(s):                                  384

... 384 CPUs banging on a single filesystem....

> ================================= XFS ======================================
> [root@localhost ~]# xfs_info /dev/ts/home 
> meta-data=/dev/mapper/ts-home    isize=512    agcount=4, agsize=45875200 blks

... that has very limited parallelism, and ...
>          =                       sectsz=4096  attr=2, projid32bit=1
>          =                       crc=1        finobt=1, sparse=1, rmapbt=1
>          =                       reflink=1    bigtime=1 inobtcount=1 nrext64=1
> data     =                       bsize=4096   blocks=183500800, imaxpct=25
>          =                       sunit=0      swidth=0 blks
> naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
> log      =internal log           bsize=4096   blocks=89600, version=2

... a relatively small log (350MB) compared to the size of the
system that is hammering on it.

i.e. This is exactly the sort of system architecture that will push
heaps of concurrency into the filesystem's transaction reservation
slow path and keep it there for long periods of time. Especially
under sustained, highly concurrent, modification heavy stress
workloads.

Exposing any kernel spin lock to unbound user controlled
concurrency will eventually result in a workload that causes
catastrophic spin lock contention breakdown. Then everything that
uses said lock will spend excessive amounts of time spinning and not
making progress.

This is one of the scalability problems the patchset I linked above
addressed. Prior to that patchset, the transaction reservation slow
path (the "journal full" path) exposed the AIL lock to unbound
userspace concurrency via the "update the AIL push target"
mechanism. Both journal IO completion and the xfsaild are heavy
users of the AIL lock, but don't normally contend with each other
because internal filesystem concurrency is tightly bounded. Once
userspace starts banging on it, however....

Silencing soft lockups with cond_resched() is almost never the right
thing to do - they are generally indicative of some other problem
occurring. We need to understand what that "some other problem" is
before we do anything else...

-Dave.
-- 
Dave Chinner
david@fromorbit.com
