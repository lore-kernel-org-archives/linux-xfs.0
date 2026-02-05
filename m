Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35A1E3A9D95
	for <linux-xfs@vger.kernel.org>; Thu,  5 Feb 2026 11:44:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770291895; cv=none; b=D2KdONaU6eap/sb+nspQG9tbHTrahFndnoUeBNQAvbTDkdcypuZVyvHvO4pfTmuWbKNggVv57Hoe+96YEEvRk+n0JRnP7Bq5rP1Vy636sRbetNUYRccRjK/taPXgxQB0X4zbucIlyKA4boLpmBJ3YIL5ox/CpVv97/rdk6qFAH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770291895; c=relaxed/simple;
	bh=1lNatJR2SYFVLbfXZirFZ5akx5mDCJb8Tw5bxbVdXRo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=g7F4XQxJP8UJplvrsd93xcdI3tB/Bl6c5vUMipr4x75o8WydGsbjjMwY2uj7jO10F3Ea7vwKMW2cieczE7JoEgqXcXaLsHxdkaz+/1menfmWEPwUPxBXBtbpMY0SHt2oVXXnzz4hL2ebNwYRwPzT2xLnXaWweVmu5l4NN7QjlYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=kV4CiZaC; arc=none smtp.client-ip=209.85.210.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="kV4CiZaC"
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-81ed3e6b8e3so485601b3a.2
        for <linux-xfs@vger.kernel.org>; Thu, 05 Feb 2026 03:44:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1770291894; x=1770896694; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=YNJJmjjwH4WesXwwgCZTndZdkLq0ZFDrKeS7/wVaJeI=;
        b=kV4CiZaC2qGaz+9wNXkRvk7N1cgiccjkvRjDTqzV5AfctrY9GFWCyBhh8zEXZnbfp9
         r9fKjoloBZFlLrEV2m0SQepK1tvMR8beBkjbKq+scxyz8+s2b906F7aORH9E1ZpiokCE
         XHM+hI4z3uIgw4lShUDup0Bha3IVd8OTlz1ypXDRx7PFvJiRVzqRSS0WCmLYBxGGXHcz
         n11SzHqhkWsHWBNUyaIkJqjn9+QfZXdxTibIiUB8gMezPBWbIui/CrMHJwu8GlrT3tXK
         KYiMREgXcXtIvZO27f2NVIXYk6nQhrOSboS9FzLAyv/obdtXDrwqdMIICTxd6JyoNjX5
         EURA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770291894; x=1770896694;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YNJJmjjwH4WesXwwgCZTndZdkLq0ZFDrKeS7/wVaJeI=;
        b=cKXOU+VkkD7u5WllXlcFXqzzb5l/vWBnvN1feuG156fNmwdWzN6/fce01vHa0/stCX
         tsCasJtcAiS5FHMTeB2qOfGndhvFczPxHcYVcW5UdWgXjc2ETVxfm388XWFLFp5UV1lP
         YNu3Ln4+5OBUbVkNJXQnScv+hScssJjFejfU0yIzhVCCWj/MsSKBkzf7F48C8ms+cmJm
         mcQujmUoxWbnpKS/n2mBq66qrbjC47YVKuQ+eOnF6XRyhduLI3yzUYIWPRy1bimuAEmt
         u3BKHzNY5/+oa8czMl/Y1IVHCsGnfKudtxO2PAif1X1Q8EjCey+iJ9nVntVcdhjsALM0
         Adyw==
X-Forwarded-Encrypted: i=1; AJvYcCU+cwFxuIWFARM26GMhZV4sw8PnGSHXyI5jgeMhG+oa1+On8BUmbRwTkrPsa8gOIJcRd+XUwszs3dg=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyo/iRHDmdBLLFPKEtp6/sJeaN9JBZ6FI9sCQNSvgCd1zZF1u3M
	ZFbIezLglbWPjVxXKSoYdKk1ITRvyFcCZh82M6K5BsNaPoIpG4SKnTi1RvByI2izTT+LCg0ithy
	csC+G
X-Gm-Gg: AZuq6aIlWW326gM9FIr6pk6Am8JIz7t4N/DcnuNEpp2mxPsUJwff794jTLqYWMWo7cK
	HLF+akIyZxu0grsxo4/whiAf1c1L8/O8bYcOa/pYp+cI6v/aIva/DCvhc/B0MkodQqiSGS9zlqg
	FP2OH7LqmIr5JOD3YbOUXAZVZRRDeQ4u29SXHUfvjuZ8ET8tojrSZoBDaONeDmEjg1ME6VLdrpR
	RHrvbCFK1t6G8PHXT24Ltf8wOyiKh0TOHcU+2rdj6dUflayGmaCYAKmQCTJ18qA1qY9dp80WXwZ
	hf7+3H3HLWsBYeMZ9Yp868kFqjcj/uxT+RAy3vVAGs//lDlKWL42iga/vCpLEpnosFAkwDPScjB
	BM5EVR1zcQDmCT12gXxEfSKX+QV1Q1N43TZYeDLV/Mrofu/lhJqXta84kzZYjpEfUDFo8WulCxS
	onZ4HwGG9j8dYqOU6SxESLcJP/gQlbJISNs+N5FOOD3F8vDyKmjLeSPq9yNSgXN5E=
X-Received: by 2002:a05:6a20:43a7:b0:37e:8eea:3e3f with SMTP id adf61e73a8af0-393725d7bcemr6640682637.80.1770291894341;
        Thu, 05 Feb 2026 03:44:54 -0800 (PST)
Received: from dread.disaster.area (pa49-180-164-75.pa.nsw.optusnet.com.au. [49.180.164.75])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c6c8515df49sm4744333a12.28.2026.02.05.03.44.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Feb 2026 03:44:54 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.99.1)
	(envelope-from <david@fromorbit.com>)
	id 1vnxn1-0000000DE1D-1Nzg;
	Thu, 05 Feb 2026 22:44:51 +1100
Date: Thu, 5 Feb 2026 22:44:51 +1100
From: Dave Chinner <david@fromorbit.com>
To: alexjlzheng@gmail.com
Cc: cem@kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	Jinliang Zheng <alexjlzheng@tencent.com>
Subject: Re: [PATCH 2/2] xfs: take a breath in xfsaild()
Message-ID: <aYSCs6kyIZJS5MW4@dread.disaster.area>
References: <20260205082621.2259895-1-alexjlzheng@tencent.com>
 <20260205082621.2259895-3-alexjlzheng@tencent.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260205082621.2259895-3-alexjlzheng@tencent.com>

On Thu, Feb 05, 2026 at 04:26:21PM +0800, alexjlzheng@gmail.com wrote:
> From: Jinliang Zheng <alexjlzheng@tencent.com>
> 
> We noticed a softlockup like:
> 
>   crash> bt
>   PID: 5153     TASK: ffff8960a7ca0000  CPU: 115  COMMAND: "xfsaild/dm-4"
>    #0 [ffffc9001b1d4d58] machine_kexec at ffffffff9b086081
>    #1 [ffffc9001b1d4db8] __crash_kexec at ffffffff9b20817a
>    #2 [ffffc9001b1d4e78] panic at ffffffff9b107d8f
>    #3 [ffffc9001b1d4ef8] watchdog_timer_fn at ffffffff9b243511
>    #4 [ffffc9001b1d4f28] __hrtimer_run_queues at ffffffff9b1e62ff
>    #5 [ffffc9001b1d4f80] hrtimer_interrupt at ffffffff9b1e73d4
>    #6 [ffffc9001b1d4fd8] __sysvec_apic_timer_interrupt at ffffffff9b07bb29
>    #7 [ffffc9001b1d4ff0] sysvec_apic_timer_interrupt at ffffffff9bd689f9
>   --- <IRQ stack> ---
>    #8 [ffffc90031cd3a18] asm_sysvec_apic_timer_interrupt at ffffffff9be00e86
>       [exception RIP: part_in_flight+47]
>       RIP: ffffffff9b67960f  RSP: ffffc90031cd3ac8  RFLAGS: 00000282
>       RAX: 00000000000000a9  RBX: 00000000000c4645  RCX: 00000000000000f5
>       RDX: ffffe89fffa36fe0  RSI: 0000000000000180  RDI: ffffffff9d1ae260
>       RBP: ffff898083d30000   R8: 00000000000000a8   R9: 0000000000000000
>       R10: ffff89808277d800  R11: 0000000000001000  R12: 0000000101a7d5be
>       R13: 0000000000000000  R14: 0000000000001001  R15: 0000000000001001
>       ORIG_RAX: ffffffffffffffff  CS: 0010  SS: 0018
>    #9 [ffffc90031cd3ad8] update_io_ticks at ffffffff9b6602e4
>   #10 [ffffc90031cd3b00] bdev_start_io_acct at ffffffff9b66031b
>   #11 [ffffc90031cd3b20] dm_io_acct at ffffffffc18d7f98 [dm_mod]
>   #12 [ffffc90031cd3b50] dm_submit_bio_remap at ffffffffc18d8195 [dm_mod]
>   #13 [ffffc90031cd3b70] dm_split_and_process_bio at ffffffffc18d9799 [dm_mod]
>   #14 [ffffc90031cd3be0] dm_submit_bio at ffffffffc18d9b07 [dm_mod]
>   #15 [ffffc90031cd3c20] __submit_bio at ffffffff9b65f61c
>   #16 [ffffc90031cd3c38] __submit_bio_noacct at ffffffff9b65f73e
>   #17 [ffffc90031cd3c80] xfs_buf_ioapply_map at ffffffffc23df4ea [xfs]

This isn't from a TOT kernel. xfs_buf_ioapply_map() went away a year
ago. What kernel is this occurring on?

>   #18 [ffffc90031cd3ce0] _xfs_buf_ioapply at ffffffffc23df64f [xfs]
>   #19 [ffffc90031cd3d50] __xfs_buf_submit at ffffffffc23df7b8 [xfs]
>   #20 [ffffc90031cd3d70] xfs_buf_delwri_submit_buffers at ffffffffc23dffbd [xfs]
>   #21 [ffffc90031cd3df8] xfsaild_push at ffffffffc24268e5 [xfs]
>   #22 [ffffc90031cd3eb8] xfsaild at ffffffffc2426f88 [xfs]
>   #23 [ffffc90031cd3ef8] kthread at ffffffff9b1378fc
>   #24 [ffffc90031cd3f30] ret_from_fork at ffffffff9b042dd0
>   #25 [ffffc90031cd3f50] ret_from_fork_asm at ffffffff9b007e2b
> 
> This patch adds cond_resched() to avoid softlockups similar to the one
> described above.

Again: how do this softlock occur?

xfsaild_push() pushes at most 1000 items at a time for IO.  It would
have to be a fairly fast device not to block on the request queues
filling as we submit batches of 1000 buffers at a time.

Then the higher level AIL traversal loop would also have to be
making continuous progress without blocking. Hence it must not hit
the end of the AIL, nor ever hit pinned, stale, flushing or locked
items in the AIL for as long as it takes for the soft lookup timer
to fire.  This seems ... highly unlikely.

IOWs, if we are looping in this path without giving up the CPU for
seconds at a time, then it is not behaving as I'd expect it to
behave. We need to understand why is this code apparently behaving
in an unexpected way, not just silence the warning....

Can you please explain how the softlockup timer is being hit here so we
can try to understand the root cause of the problem? Workload,
hardware, filesystem config, storage stack, etc all matter here,
because they all play a part in these paths never blocking on
a lock, a full queue, a pinned buffer, etc, whilst processing
hundreds of thousands of dirty objects for IO.

At least, I'm assuming we're talking about hundreds of thousands of
objects, because I know the AIL can push a hundred thousand dirty
buffers to disk every second when it is close to being CPU bound. So
if it's not giving up the CPU for long enough to fire the soft
lockup timer, we must be talking about processing millions of
objects without blocking even once....

-Dave.
-- 
Dave Chinner
david@fromorbit.com
