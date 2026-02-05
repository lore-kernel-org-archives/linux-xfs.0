Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C748330100D
	for <linux-xfs@vger.kernel.org>; Thu,  5 Feb 2026 20:28:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770323280; cv=none; b=jOxjGyTPTO6Ikwk4LTgYDJHD4fmeRypChaFe1ZXybazoOGz4ncpMwyRAW9WDcIdcWCqNYE5cqz0JaG6rKqCyWtJH1qpojdD0NA0j17pkKIavEqwA2XPJEw63VJSkE206bENuH7Dwvlhypeh1oGUht1CYa2jz8i50eUyyTMUgHxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770323280; c=relaxed/simple;
	bh=niia58yHuSNHoSzxwYiho2gi/3KaKxCtnoPFWqsCLwc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iZnvfVJh0+xLS/DySy5ImJ0QocZNKWT0mLUmnY/XRRvGyZ+RvUTe2fTuk5fQAIObcine3xGuy4v28hTIhCQw2Eb73UtA7brVbpuWdK+if1AL65vt4Gfl2Tc2yZ9J2WrMOEtTUL2iEf+irJmhKfj/rAz42bM9Cro1ooOBQTOtKtw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=eckfZvbm; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="eckfZvbm"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2a0d52768ccso8747835ad.1
        for <linux-xfs@vger.kernel.org>; Thu, 05 Feb 2026 12:28:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1770323280; x=1770928080; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=McVms00cAviRg0OClqcs3WN2EKZ9Ahl14CHN4GvqWtk=;
        b=eckfZvbmciamjt2bED/IWzvB0MAcrYTwdjw1m09FY3B6bMOccb5gGljwY+OkGznt5y
         xZlnfEEkM+5oFr4xXstE4/U3Ui4lnU5VJc6XeboDc+hdlV+p/2AImROlxeb/77cdxRTx
         Jc8Pph3PnvKXPQt2z/F9NcyhHUTaFxPTJY0T7u3UxIVUYquoApPBfYl/1ChhlqjoYsbh
         pkLhpqpsIHqyaSJU3PvTJVqc3XBhDKHXmMQgOtMVXle4bADLggBEGH6zUD15L8dYofAg
         Sp2lXwpdYJQaOIOaFHVN8JASrEErprzTvHpDAb+TZ9f1UWCFO+PJr2h8/DZBUtoxz51y
         iKVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770323280; x=1770928080;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=McVms00cAviRg0OClqcs3WN2EKZ9Ahl14CHN4GvqWtk=;
        b=COA+WNj5y/E0abQtSko1N/YHPLP2zoTOB9tz5c4aIjx8Kds1sDuTyzN3HeOpwvbtcN
         pHA0r5QVSlMKZNZfrY4mLKjGFAQriJR8PYJeK6mh+sawV4rD+UMmNw4rq0WeKDLwTgXt
         Qr9N+WTN/qEV1jVNWyJg2lRtOUDmyfnGsyjcGy/gjkQZYrDAutv27CP8aRghies8p8k2
         h6+xyFvlWO5FRW2cKeE0cGUAAb8HOP7cW+1w9L5yA31cQqucDx/qQpMpcCsKkJziynPy
         sLX5PXA+4u/FtYevPr9n/6gQFqo4HVe6smJFzUmYwiPOtQjIKZeUj26mVpQRr/jAUeY3
         lSiQ==
X-Forwarded-Encrypted: i=1; AJvYcCV4NfzktDINyZ/WXHH7sJDD441VcWc0TAd1HLDrKZYoA7Q+T61ZoW95Wj8+5R+2H2E3GgGdyfSTOks=@vger.kernel.org
X-Gm-Message-State: AOJu0YwIbcCGdf6t1y0/D+m9lpmlzAvqi4kJjO7xITX1j6z6ftZ91Abr
	BHf0qLYCy5Z1B4hikbkRyYAUxOFUNalof52yGI61N2+g3YW+XVFIfGhOH8WZ70f7nPg=
X-Gm-Gg: AZuq6aLDpDVIios/79eTbQakwNja1f8Z4QlXbhS5JDBr01EH5brAY9vTNfRGHcj3NKP
	9hsOxBuc5m9/aR3rGHmrzu4NE2yhqpRIQuB+gaBvDmYkZFsONSDidJ3fOIIV2EXxUdm2qb7Vms2
	eiqO6Q/piY9nFD+8dm253dg5FkLWCRTzAF2yZbqBJmitDh+s/U8twuG/B1wnfbd1WeOiiwIDdSt
	Uq4ao2mFYf19TksQpoYIxUF74N/5QtlTuYWg9iETyaTKqgWPGq9Eu53Dsb174hCMC9ztHEqI4RH
	8Z6lpQLn+XIZUsKSvAAIxP5MaczSEP/82tEX1fyOgQiGV8tbMiijkAhmVjchycsR/gXLeiiESqj
	w+uwXyqC1tgw5qOBEYInZNvadD6fpb7rboT5l46AqftYyWnCxbAttCqcSoPVD4NQ7SbjOutPfeB
	P52H8kW/fJay2oaTsSrOiwSgzi6Zy4M70Qc6eR9UqHdeYyw2/XuDlDC+dVBDb+6Qk=
X-Received: by 2002:a17:902:fc43:b0:2a9:4c2:e53 with SMTP id d9443c01a7336-2a95192e01emr5075975ad.48.1770323279995;
        Thu, 05 Feb 2026 12:27:59 -0800 (PST)
Received: from dread.disaster.area (pa49-180-164-75.pa.nsw.optusnet.com.au. [49.180.164.75])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a951c940besm2818045ad.38.2026.02.05.12.27.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Feb 2026 12:27:59 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.99.1)
	(envelope-from <david@fromorbit.com>)
	id 1vo5xD-0000000DOVU-32Ei;
	Fri, 06 Feb 2026 07:27:55 +1100
Date: Fri, 6 Feb 2026 07:27:55 +1100
From: Dave Chinner <david@fromorbit.com>
To: Jinliang Zheng <alexjlzheng@gmail.com>
Cc: alexjlzheng@tencent.com, cem@kernel.org, linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: take a breath in xlog_ioend_work()
Message-ID: <aYT9SyPV0GGaeRvG@dread.disaster.area>
References: <aYR2-Y-Fe2Chh5if@dread.disaster.area>
 <20260205124940.2323931-1-alexjlzheng@tencent.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260205124940.2323931-1-alexjlzheng@tencent.com>

On Thu, Feb 05, 2026 at 08:49:38PM +0800, Jinliang Zheng wrote:
> On Thu, 5 Feb 2026 21:54:49 +1100, david@fromorbit.com wrote:
> > On Thu, Feb 05, 2026 at 04:26:20PM +0800, alexjlzheng@gmail.com wrote:
> > > From: Jinliang Zheng <alexjlzheng@tencent.com>
> > > 
> > > The xlog_ioend_work() function contains several nested loops with
> > > fairly complex operations, which may leads to:
> > > 
> > >   PID: 2604722  TASK: ffff88c08306b1c0  CPU: 263  COMMAND: "kworker/263:0H"
> > >    #0 [ffffc9001cbf8d58] machine_kexec at ffffffff9d086081
> > >    #1 [ffffc9001cbf8db8] __crash_kexec at ffffffff9d20817a
> > >    #2 [ffffc9001cbf8e78] panic at ffffffff9d107d8f
> > >    #3 [ffffc9001cbf8ef8] watchdog_timer_fn at ffffffff9d243511
> > >    #4 [ffffc9001cbf8f28] __hrtimer_run_queues at ffffffff9d1e62ff
> > >    #5 [ffffc9001cbf8f80] hrtimer_interrupt at ffffffff9d1e73d4
> > >    #6 [ffffc9001cbf8fd8] __sysvec_apic_timer_interrupt at ffffffff9d07bb29
> > >    #7 [ffffc9001cbf8ff0] sysvec_apic_timer_interrupt at ffffffff9dd689f9
> > >   --- <IRQ stack> ---
> > >    #8 [ffffc900460a7c28] asm_sysvec_apic_timer_interrupt at ffffffff9de00e86
> > >       [exception RIP: slab_free_freelist_hook.constprop.0+107]
> > >       RIP: ffffffff9d3ef74b  RSP: ffffc900460a7cd0  RFLAGS: 00000286
> > >       RAX: ffff89ea4de06b00  RBX: ffff89ea4de06a00  RCX: ffff89ea4de06a00
> > >       RDX: 0000000000000100  RSI: ffffc900460a7d28  RDI: ffff888100044c80
> > >       RBP: ffff888100044c80   R8: 0000000000000000   R9: ffffffffc21e8500
> > >       R10: ffff88c867e93200  R11: 0000000000000001  R12: ffff89ea4de06a00
> > >       R13: ffffc900460a7d28  R14: ffff89ea4de06a00  R15: ffffc900460a7d30
> > >       ORIG_RAX: ffffffffffffffff  CS: 0010  SS: 0018
> > >    #9 [ffffc900460a7d18] __kmem_cache_free at ffffffff9d3f65a0
> > >   #10 [ffffc900460a7d70] xlog_cil_committed at ffffffffc21e85af [xfs]
> > >   #11 [ffffc900460a7da0] xlog_cil_process_committed at ffffffffc21e9747 [xfs]
> > >   #12 [ffffc900460a7dd0] xlog_state_do_iclog_callbacks at ffffffffc21e41eb [xfs]
> > >   #13 [ffffc900460a7e28] xlog_state_do_callback at ffffffffc21e436f [xfs]
> > >   #14 [ffffc900460a7e50] xlog_ioend_work at ffffffffc21e6e1c [xfs]
> > >   #15 [ffffc900460a7e70] process_one_work at ffffffff9d12de69
> > >   #16 [ffffc900460a7ea8] worker_thread at ffffffff9d12e79b
> > >   #17 [ffffc900460a7ef8] kthread at ffffffff9d1378fc
> > >   #18 [ffffc900460a7f30] ret_from_fork at ffffffff9d042dd0
> > >   #19 [ffffc900460a7f50] ret_from_fork_asm at ffffffff9d007e2b
> > > 
> > > This patch adds cond_resched() to avoid softlockups similar to the one
> > > described above.
> > 
> > You've elided the soft lockup messages that tell us how long this
> > task was holding the CPU. What is the soft lockup timer set to?
> > What workload causes this to happen? How do we reproduce it?
> 
> Thanks for your reply. :)
> 
> The soft lockup timer is set to 20s, and the cpu was holding 22s.

Yep, something else must be screwed up here - an iclog completion
should never have enough items attched to it that is takes this long
to process them without yeilding the CPU.

We can only loop once around the iclogs in this path these days,
because the iclog we we are completing runs xlog_ioend_work() with
the iclog->ic_sema held. This locks out new IO being issued on that
iclog whilst we are processing the completion, and hence the
iclogbuf ring will stall trying to write new items to this iclog.

Hence whilst we are processing an iclog completion, the entire
journal (and hence filesystem) can stall waiting for the completion
to finish and release the iclog->ic_sema.

This also means we can have, at most, 8 iclogs worth of journal
writes to complete in xlog_ioend_work(). That greatly limits the
number of items we are processing in the xlog_state_do_callback()
loops. Yes, it can be tens of thousands of items, but it is bound by
journal size and the checkpoint pipeline depth (maximum of 4
checkpoints in flight at once).

So I don't see how the number of items that we are asking to be
processed during journal completion, by itself, can cause such a
long processing time. We typically process upwards of a thousand
items per millisecond here...

> The workload is a test suite combining stress-ng, LTP, and fio,
> executed concurrently. I believe reproducing the issue requires a
> certain probability.
> 
> thanks,
> Jinliang Zheng. :)
> 
> > 
> > FWIW, yes, there might be several tens of thousands of objects to
> > move to the AIL in this journal IO completion path, but if this
> > takes more than a couple of hundred milliseconds of processing time
> > then there is something else going wrong....
> 
> Is it possible that the kernel’s CPU and memory were under high load,
> causing each iteration of the loop to take more time and eventually
> accumulating to over 20 seconds?

That's a characteristic behaviour of catastrophic spin lock
contention...

-Dave.
-- 
Dave Chinner
david@fromorbit.com
