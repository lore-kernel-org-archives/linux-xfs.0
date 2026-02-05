Received: from mail-dy1-f180.google.com (mail-dy1-f180.google.com [74.125.82.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF73C3ACF1B
	for <linux-xfs@vger.kernel.org>; Thu,  5 Feb 2026 12:50:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770295803; cv=none; b=oqJH5ib+J4o4P1y170QqDYyRo8TXWkNeqB13I0p7OFov9triIUTYodRJmlYpd/gSDtxbKX6Pk/hFxSzczVkpSzM55yAmQ3+7P0Kyw2gxT3K9TH/ZQaZNGTDvwmzJQIp/69WHKqGAEt26nUnemnJgNx8GABPzYe4cbFRdxpTxxPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770295803; c=relaxed/simple;
	bh=/wcS83ZsWZOsVQbQh8LM0Y8KFgttmSmZeiD1Zho0rY8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nrOhYqZiU08W0aeUoj5O7V9BnR0ZVjHZ/SXou2D1u9tgQu4XiF83GKHQiFVnygYNqOJuxpf+mKy5+ygoHVEEJLKRM6J0Xe5OdYjLGXNu78pYkslqjfslpuQ/o7vkM5OdvIYPXPWrQpjejZlZ4ILlB9tGC3i4F70thrHwTgE/wrc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=c4vbENRv; arc=none smtp.client-ip=74.125.82.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="c4vbENRv"
Received: by mail-dy1-f180.google.com with SMTP id 5a478bee46e88-2b834e17c3fso801805eec.0
        for <linux-xfs@vger.kernel.org>; Thu, 05 Feb 2026 04:50:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770295802; x=1770900602; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=s8OHXt1DBlZKhPSOqM7M0cNvv5P+P/azwmoJ5fiMxWk=;
        b=c4vbENRvdWJlcWcuZFwRaz4m5/2ERBnXLJ+xUyBAhEDqZnvr/S+GarH/fIk+e3I2a4
         9o77CAsRdFcLulbQRHs1hEm3wy6XAE3dgIuY2lWBNq7q6Fhllg+3q/xorZXqzn6pDBFY
         BmP9pS4+tU1rvtHTysjaPChwoSu+PdR0bi3Ock3+l0vYVRVxsVd5fyaEC2GU7QkN9yS6
         /yohygv4U3iA0bjRyItEgjzP/jICAjrm5oBiogoF5x62s3FA5NjLk/XpD3M9mbfkaYlq
         z9j0kLcEyqhJqAZOBMAX9XcjPIwuYZZIreSrMd/XvCArg+iKlOWhqARJHHHs04qtjF7z
         H7Mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770295802; x=1770900602;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=s8OHXt1DBlZKhPSOqM7M0cNvv5P+P/azwmoJ5fiMxWk=;
        b=Fhm726et3K5qbnmyI5RqwuBWAz8JlR76VZU7rh8440xGpVeUWVuLGA1wkjNZ+9xjWI
         6rE8+3VS40imbqzL3F02xLlXaOQyKS9lEEwHQpkve3yGePGfF+Mz6PuOL6yOJjqbpMni
         z3f5ODm7UOYFXj6nAWQw/1dt5025rSgL/VmSv9FIt3dhcJ3Fl2lu1/GAafwlC+8UzZA9
         l00ijfVhw1oTEQgfPj/pF1q9+0ULjPfU19899b+CdLjVSwCse3C3mP8+vXRBE5o9lRk5
         0vepskw8s/U6y/WxLvjrZGmOYuoc3lbzcgP21iptm9CiULdVK0IzbhM/6CA3j+bsqehv
         Xv7Q==
X-Forwarded-Encrypted: i=1; AJvYcCVpkEH0ilCTMF8TuEagcD00+BU8IkUNpJDwBwS2eu5v98Z+avkyKrmu+hrL3WK8tQDVNITmfVgePDM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz6xXh89gQnCUZW4eF0k85S8NDfyiJaYa+4CiZrHACnYt7nmz7B
	8PE4ZAGYICcLVUSL+I+SBJ+LBLxH8JlAvagBSbWjjgaU6aQeFd1AVFhxTKPFZw==
X-Gm-Gg: AZuq6aIfa36W221SQQ8LYr/Q8XQCpv0spi8cJAtNsNpLqZAJjGwOIpfBqedZQ+geVTN
	dy6UsVhAepkIODEke9Ro1OIXyhNFE7Hf8Ys4I3LBh8pPBw81va8K3jgzh6qQM4MYhkHRX/NCCe+
	bRJf0KrIJhcQWRqUEhcUBLl1pWD74uicLgQROFNrCT463xLeuYD5tF6LxwKFwokoMrxxG4+hy1Q
	mJ40qryVnx3LcverOeTk86sf5xrx6llAPFDnwkDDWnjYnItsBPKjacwvTDBPBPUKCb+T5dDE4Pq
	YdfACorYRAJOmufp0yhTDecC4JOOiCWAUkSTb/gcez6NQlzXEW5fyEvbqrMxHEmVcCWUF7OUu+N
	r58YMMAHzRl7IyVt/dxryrsJvNiLZ34NjoYvsFQhTTGpM2aqJJALXV+RTcjm7HgzvRnlQpz9geX
	wRzZjvLMF81MnUpfMN0OAofBaPfOO+5guXLQ==
X-Received: by 2002:a05:7301:ea2:b0:2b7:9b6e:b1d2 with SMTP id 5a478bee46e88-2b832727c03mr2170638eec.0.1770295801653;
        Thu, 05 Feb 2026 04:50:01 -0800 (PST)
Received: from VM-16-24-fedora.. ([43.153.32.141])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2b832fafc2fsm3153986eec.24.2026.02.05.04.50.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Feb 2026 04:50:01 -0800 (PST)
From: Jinliang Zheng <alexjlzheng@gmail.com>
X-Google-Original-From: Jinliang Zheng <alexjlzheng@tencent.com>
To: david@fromorbit.com
Cc: alexjlzheng@gmail.com,
	alexjlzheng@tencent.com,
	cem@kernel.org,
	linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: take a breath in xfsaild()
Date: Thu,  5 Feb 2026 20:49:59 +0800
Message-ID: <20260205125000.2324010-1-alexjlzheng@tencent.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <aYSCs6kyIZJS5MW4@dread.disaster.area>
References: <aYSCs6kyIZJS5MW4@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On Thu, 5 Feb 2026 22:44:51 +1100, david@fromorbit.com wrote:
> On Thu, Feb 05, 2026 at 04:26:21PM +0800, alexjlzheng@gmail.com wrote:
> > From: Jinliang Zheng <alexjlzheng@tencent.com>
> > 
> > We noticed a softlockup like:
> > 
> >   crash> bt
> >   PID: 5153     TASK: ffff8960a7ca0000  CPU: 115  COMMAND: "xfsaild/dm-4"
> >    #0 [ffffc9001b1d4d58] machine_kexec at ffffffff9b086081
> >    #1 [ffffc9001b1d4db8] __crash_kexec at ffffffff9b20817a
> >    #2 [ffffc9001b1d4e78] panic at ffffffff9b107d8f
> >    #3 [ffffc9001b1d4ef8] watchdog_timer_fn at ffffffff9b243511
> >    #4 [ffffc9001b1d4f28] __hrtimer_run_queues at ffffffff9b1e62ff
> >    #5 [ffffc9001b1d4f80] hrtimer_interrupt at ffffffff9b1e73d4
> >    #6 [ffffc9001b1d4fd8] __sysvec_apic_timer_interrupt at ffffffff9b07bb29
> >    #7 [ffffc9001b1d4ff0] sysvec_apic_timer_interrupt at ffffffff9bd689f9
> >   --- <IRQ stack> ---
> >    #8 [ffffc90031cd3a18] asm_sysvec_apic_timer_interrupt at ffffffff9be00e86
> >       [exception RIP: part_in_flight+47]
> >       RIP: ffffffff9b67960f  RSP: ffffc90031cd3ac8  RFLAGS: 00000282
> >       RAX: 00000000000000a9  RBX: 00000000000c4645  RCX: 00000000000000f5
> >       RDX: ffffe89fffa36fe0  RSI: 0000000000000180  RDI: ffffffff9d1ae260
> >       RBP: ffff898083d30000   R8: 00000000000000a8   R9: 0000000000000000
> >       R10: ffff89808277d800  R11: 0000000000001000  R12: 0000000101a7d5be
> >       R13: 0000000000000000  R14: 0000000000001001  R15: 0000000000001001
> >       ORIG_RAX: ffffffffffffffff  CS: 0010  SS: 0018
> >    #9 [ffffc90031cd3ad8] update_io_ticks at ffffffff9b6602e4
> >   #10 [ffffc90031cd3b00] bdev_start_io_acct at ffffffff9b66031b
> >   #11 [ffffc90031cd3b20] dm_io_acct at ffffffffc18d7f98 [dm_mod]
> >   #12 [ffffc90031cd3b50] dm_submit_bio_remap at ffffffffc18d8195 [dm_mod]
> >   #13 [ffffc90031cd3b70] dm_split_and_process_bio at ffffffffc18d9799 [dm_mod]
> >   #14 [ffffc90031cd3be0] dm_submit_bio at ffffffffc18d9b07 [dm_mod]
> >   #15 [ffffc90031cd3c20] __submit_bio at ffffffff9b65f61c
> >   #16 [ffffc90031cd3c38] __submit_bio_noacct at ffffffff9b65f73e
> >   #17 [ffffc90031cd3c80] xfs_buf_ioapply_map at ffffffffc23df4ea [xfs]
> 
> This isn't from a TOT kernel. xfs_buf_ioapply_map() went away a year
> ago. What kernel is this occurring on?

Thanks for your reply. :)

It's based on v6.6.

> 
> >   #18 [ffffc90031cd3ce0] _xfs_buf_ioapply at ffffffffc23df64f [xfs]
> >   #19 [ffffc90031cd3d50] __xfs_buf_submit at ffffffffc23df7b8 [xfs]
> >   #20 [ffffc90031cd3d70] xfs_buf_delwri_submit_buffers at ffffffffc23dffbd [xfs]
> >   #21 [ffffc90031cd3df8] xfsaild_push at ffffffffc24268e5 [xfs]
> >   #22 [ffffc90031cd3eb8] xfsaild at ffffffffc2426f88 [xfs]
> >   #23 [ffffc90031cd3ef8] kthread at ffffffff9b1378fc
> >   #24 [ffffc90031cd3f30] ret_from_fork at ffffffff9b042dd0
> >   #25 [ffffc90031cd3f50] ret_from_fork_asm at ffffffff9b007e2b
> > 
> > This patch adds cond_resched() to avoid softlockups similar to the one
> > described above.
> 
> Again: how do this softlock occur?

[28089.641309] watchdog: BUG: soft lockup - CPU#115 stuck for 26s! [xfsaild/dm-4:5153] 

> 
> xfsaild_push() pushes at most 1000 items at a time for IO.  It would
> have to be a fairly fast device not to block on the request queues
> filling as we submit batches of 1000 buffers at a time.
> 
> Then the higher level AIL traversal loop would also have to be
> making continuous progress without blocking. Hence it must not hit
> the end of the AIL, nor ever hit pinned, stale, flushing or locked
> items in the AIL for as long as it takes for the soft lookup timer
> to fire.  This seems ... highly unlikely.
> 
> IOWs, if we are looping in this path without giving up the CPU for
> seconds at a time, then it is not behaving as I'd expect it to
> behave. We need to understand why is this code apparently behaving
> in an unexpected way, not just silence the warning....
> 
> Can you please explain how the softlockup timer is being hit here so we
> can try to understand the root cause of the problem? Workload,

Again, a testsuite combining stress-ng, LTP, and fio, executed concurrently.

> hardware, filesystem config, storage stack, etc all matter here,


================================= CPU ======================================
Architecture:                            x86_64
CPU op-mode(s):                          32-bit, 64-bit
Address sizes:                           45 bits physical, 48 bits virtual
Byte Order:                              Little Endian
CPU(s):                                  384
On-line CPU(s) list:                     0-383

================================= MEM ======================================
[root@localhost ~]# free -h
               total        used        free      shared  buff/cache   available
Mem:           1.5Ti       479Gi       1.0Ti       2.0Gi       6.2Gi       1.0Ti
Swap:             0B          0B          0B


================================= XFS ======================================
[root@localhost ~]# xfs_info /dev/ts/home 
meta-data=/dev/mapper/ts-home    isize=512    agcount=4, agsize=45875200 blks
         =                       sectsz=4096  attr=2, projid32bit=1
         =                       crc=1        finobt=1, sparse=1, rmapbt=1
         =                       reflink=1    bigtime=1 inobtcount=1 nrext64=1
data     =                       bsize=4096   blocks=183500800, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
log      =internal log           bsize=4096   blocks=89600, version=2
         =                       sectsz=4096  sunit=1 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0


================================= IOS ======================================
sdb                                                                                                
├─sdb1        vfat        FAT32              EE62-ACF4                               591.3M     1% /boot/efi
├─sdb2        xfs                            95e0a12a-ed33-45b7-abe1-640c4e334468      1.6G    17% /boot
└─sdb3        LVM2_member LVM2 001           fSTN7x-BNcZ-w67a-gZBf-Vlps-7gtv-KAreS7                
  ├─ts-root   xfs                            f78c147c-86d7-4675-b9bd-ed0d512f37f4     84.5G    50% /
  └─ts-home   xfs                            01677289-32f2-41b0-ab59-3c5d14a1eefa    668.6G     4% /home

> because they all play a part in these paths never blocking on
> a lock, a full queue, a pinned buffer, etc, whilst processing
> hundreds of thousands of dirty objects for IO.

And, there's another softlockup, which is similar:

watchdog: BUG: soft lockup - CPU#342 stuck for 22s! [xfsaild/dm-4:5045]

  crash> bt
  PID: 5045     TASK: ffff89e0a0150000  CPU: 342  COMMAND: "xfsaild/dm-4"
   #0 [ffffc9001d98cd58] machine_kexec at ffffffffa8086081
   #1 [ffffc9001d98cdb8] __crash_kexec at ffffffffa820817a
   #2 [ffffc9001d98ce78] panic at ffffffffa8107d8f
   #3 [ffffc9001d98cef8] watchdog_timer_fn at ffffffffa8243511
   #4 [ffffc9001d98cf28] __hrtimer_run_queues at ffffffffa81e62ff
   #5 [ffffc9001d98cf80] hrtimer_interrupt at ffffffffa81e73d4
   #6 [ffffc9001d98cfd8] __sysvec_apic_timer_interrupt at ffffffffa807bb29
   #7 [ffffc9001d98cff0] sysvec_apic_timer_interrupt at ffffffffa8d689f9
  --- <IRQ stack> ---
   #8 [ffffc900351efa48] asm_sysvec_apic_timer_interrupt at ffffffffa8e00e86
      [exception RIP: kernel_fpu_begin_mask+66]
      RIP: ffffffffa8044f52  RSP: ffffc900351efaf8  RFLAGS: 00000206
      RAX: 0000000000000000  RBX: 0000000000000002  RCX: 0000000000000000
      RDX: 0000000000000000  RSI: ffff899f8f9ee000  RDI: ffff89e0a0150000
      RBP: 0000000000001000   R8: 0000000000000000   R9: 0000000000001000
      R10: 0000000000000000  R11: ffff899f8f9ee030  R12: ffffc900351efb38
      R13: ffff899f8f9ee000  R14: ffff88e084624158  R15: ffff88e083828000
      ORIG_RAX: ffffffffffffffff  CS: 0010  SS: 0018
   #9 [ffffc900351efb10] crc32c_pcl_intel_update at ffffffffc199b390 [crc32c_intel]
  #10 [ffffc900351efb30] crc32c at ffffffffc196d03f [libcrc32c]
  #11 [ffffc900351efcb8] xfs_dir3_data_write_verify at ffffffffc250cfd9 [xfs]
  #12 [ffffc900351efce0] _xfs_buf_ioapply at ffffffffc253d5cd [xfs]
  #13 [ffffc900351efd50] __xfs_buf_submit at ffffffffc253d7b8 [xfs]
  #14 [ffffc900351efd70] xfs_buf_delwri_submit_buffers at ffffffffc253dfbd [xfs]
  #15 [ffffc900351efdf8] xfsaild_push at ffffffffc25848e5 [xfs]
  #16 [ffffc900351efeb8] xfsaild at ffffffffc2584f88 [xfs]
  #17 [ffffc900351efef8] kthread at ffffffffa81378fc
  #18 [ffffc900351eff30] ret_from_fork at ffffffffa8042dd0
  #19 [ffffc900351eff50] ret_from_fork_asm at ffffffffa8007e2b

Thanks,
Jinliang Zheng. :)

> 
> At least, I'm assuming we're talking about hundreds of thousands of
> objects, because I know the AIL can push a hundred thousand dirty
> buffers to disk every second when it is close to being CPU bound. So
> if it's not giving up the CPU for long enough to fire the soft
> lockup timer, we must be talking about processing millions of
> objects without blocking even once....
> 
> -Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
