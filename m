Received: from mail-dy1-f176.google.com (mail-dy1-f176.google.com [74.125.82.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0F3E3ACF14
	for <linux-xfs@vger.kernel.org>; Thu,  5 Feb 2026 12:49:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770295782; cv=none; b=I4rLwVARGZzwy31jHhONzifH73j9fU4fiF+xeimUPApwn/Ja/3/0x5c9GMrSdYQPMMQE0BOFqRMsvdX43PgW1+FBsJBAyuUw3hBfTe0/s1xYw2cTa3lfuABHO1lRi3Knq6pSrHgGztY52STOwNd8eJ3hGArvtSU//73AowHo1Vs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770295782; c=relaxed/simple;
	bh=oytmSvtCPM3qifRMuX/zfSbGrdpsFvgsrI0d7RNTHyQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dmTZ3P+bTrkNfY2+xbhXD2OTfT7WZ3KkpjPyINarHL48KyfEUaXaH1v3QGSY0GayzqgD4LFarj0WZMwKgQ4lXzmC4m4eJquVFSHF4KE0IaBhgnf+i/vpGN3H1WKOS7HtSYF+d+QWR3HEml2LW/70+8F63XKnfFBIVjNJI/NZ61U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jZaKVDz3; arc=none smtp.client-ip=74.125.82.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jZaKVDz3"
Received: by mail-dy1-f176.google.com with SMTP id 5a478bee46e88-2b71320f501so1451455eec.1
        for <linux-xfs@vger.kernel.org>; Thu, 05 Feb 2026 04:49:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770295782; x=1770900582; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hDTUfin3ZctpL8en+h8BBKxCDablsd15YdxBYplvmwM=;
        b=jZaKVDz3ZGIh86g7vzCVZngdj13vXSnSbbXRKa8mhomxdj4RXxuRlwYas+RTKiaQ2w
         Ps3erYBs01EaRqKxBW940eoPErQynj9A4w1nplplpvT9p996S0FBKNB4sUb6HoACTr1S
         aUSToYkeiiaTTZM5+2wiDSb+OrXGcL7IjnYuXlvH19Cq7CIRvQwfK1CsNDMfxnJjIhx1
         KB5j8o3Fd7Lv3sKYfAA3FaVBOTrxQd8C47kRKFBckZukrwMOG7CR859MzL1APBYF3lu1
         Q5lT/ZUJcf/QzEVX41pJsBASjwizei3Rifhiyaci655eofHpDuxlYVeC3gqI+CWRO++0
         qSaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770295782; x=1770900582;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=hDTUfin3ZctpL8en+h8BBKxCDablsd15YdxBYplvmwM=;
        b=Ibs9KHKj7kYLV1jTuWQkNKw2CDUfC8PBol9156dG3Ep7rdrYc3e0DVQ0+d10R7ZIfW
         cbjm5N4/3iMSiOSpuWAkVNdCtHjHQVcMHNxa5jkcP8E1qarbsOYHWQv7R5lKyyjAPzLo
         dTL7E/dO8cddkFx6HorMHgds1YOFGVWBHKzjuXoQUVudxakco+wj2O6LR7OGyMsOLuY0
         Krs0vTzAUIGmyOJ16tLldEwETaSS3ZhrEr1Cx2P9VHkaDCsAKlALLxBMJvnyu5fioAg2
         qJaltqRfbCvAabSNfnbvCLg9P2CqnZBu1Jv3hnewZwT0B3OUXtc1x4/b+ZQjySR0rDMs
         H+dw==
X-Forwarded-Encrypted: i=1; AJvYcCU073EVt+LjiIlXt+RJt7S0cWMS3RQtDYlOBCRqyVSzWkL0HY3cWxPVpbNpAjTsPSkm+DpFuVIUVKs=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyfm1l3ji17BQw081DsaSBVm/vjVFqxt7EVjqINi55OdWYM9Qkt
	rRR4W9974ukjRfy9KuT3S1ug3fim1d5p5rk6845dwqn2pX29RtmsvBkG
X-Gm-Gg: AZuq6aK3DT4QyHIhIi2DiDnzpm96VQe3lrQyP3vv3xlPThFJEqB7pP+sw58Iz0Xoa2A
	0LqUUeLkO3rALR+zlmc7aJGcnQQPXPu/o6MpbmL7nzWLiHgfcl4gaOZP4iw6KwrgAqS49PwRQHi
	7CP6NS2bO4G13jerSlNlrzmWPfygs11OatIkDhJje+O+ZPcu+Kbyx/MYcqioP/Ry4eUqY2QmFzv
	mzmP+6RAX51TAQDdmfczedjmjOoUNPJMtP0iGeMJCks9ZbXaf3dkGWXkh6Fq+8j3JyIk95GLugE
	pKdj493xOGdkb6k0wroFUMIWKZWj9wogK3YwNFGAiY/uPzBzG56EeewePDTdGvhsH/v9dt5ej40
	BZO2CrGQ0EwVGlNhbgYV3IYxoiiQgXBA+zbov6DQPbC3MvwanYBQVAGXb2bbZagf562cmSp7rww
	l0cpL3OHXCt5a0DLUudjVGHt0=
X-Received: by 2002:a05:7301:3f16:b0:2b7:2f29:648c with SMTP id 5a478bee46e88-2b83296f0e3mr3449582eec.8.1770295781597;
        Thu, 05 Feb 2026 04:49:41 -0800 (PST)
Received: from VM-16-24-fedora.. ([43.153.32.141])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2b84cc4393fsm618579eec.1.2026.02.05.04.49.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Feb 2026 04:49:41 -0800 (PST)
From: Jinliang Zheng <alexjlzheng@gmail.com>
X-Google-Original-From: Jinliang Zheng <alexjlzheng@tencent.com>
To: david@fromorbit.com
Cc: alexjlzheng@gmail.com,
	alexjlzheng@tencent.com,
	cem@kernel.org,
	linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: take a breath in xlog_ioend_work()
Date: Thu,  5 Feb 2026 20:49:38 +0800
Message-ID: <20260205124940.2323931-1-alexjlzheng@tencent.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <aYR2-Y-Fe2Chh5if@dread.disaster.area>
References: <aYR2-Y-Fe2Chh5if@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On Thu, 5 Feb 2026 21:54:49 +1100, david@fromorbit.com wrote:
> On Thu, Feb 05, 2026 at 04:26:20PM +0800, alexjlzheng@gmail.com wrote:
> > From: Jinliang Zheng <alexjlzheng@tencent.com>
> > 
> > The xlog_ioend_work() function contains several nested loops with
> > fairly complex operations, which may leads to:
> > 
> >   PID: 2604722  TASK: ffff88c08306b1c0  CPU: 263  COMMAND: "kworker/263:0H"
> >    #0 [ffffc9001cbf8d58] machine_kexec at ffffffff9d086081
> >    #1 [ffffc9001cbf8db8] __crash_kexec at ffffffff9d20817a
> >    #2 [ffffc9001cbf8e78] panic at ffffffff9d107d8f
> >    #3 [ffffc9001cbf8ef8] watchdog_timer_fn at ffffffff9d243511
> >    #4 [ffffc9001cbf8f28] __hrtimer_run_queues at ffffffff9d1e62ff
> >    #5 [ffffc9001cbf8f80] hrtimer_interrupt at ffffffff9d1e73d4
> >    #6 [ffffc9001cbf8fd8] __sysvec_apic_timer_interrupt at ffffffff9d07bb29
> >    #7 [ffffc9001cbf8ff0] sysvec_apic_timer_interrupt at ffffffff9dd689f9
> >   --- <IRQ stack> ---
> >    #8 [ffffc900460a7c28] asm_sysvec_apic_timer_interrupt at ffffffff9de00e86
> >       [exception RIP: slab_free_freelist_hook.constprop.0+107]
> >       RIP: ffffffff9d3ef74b  RSP: ffffc900460a7cd0  RFLAGS: 00000286
> >       RAX: ffff89ea4de06b00  RBX: ffff89ea4de06a00  RCX: ffff89ea4de06a00
> >       RDX: 0000000000000100  RSI: ffffc900460a7d28  RDI: ffff888100044c80
> >       RBP: ffff888100044c80   R8: 0000000000000000   R9: ffffffffc21e8500
> >       R10: ffff88c867e93200  R11: 0000000000000001  R12: ffff89ea4de06a00
> >       R13: ffffc900460a7d28  R14: ffff89ea4de06a00  R15: ffffc900460a7d30
> >       ORIG_RAX: ffffffffffffffff  CS: 0010  SS: 0018
> >    #9 [ffffc900460a7d18] __kmem_cache_free at ffffffff9d3f65a0
> >   #10 [ffffc900460a7d70] xlog_cil_committed at ffffffffc21e85af [xfs]
> >   #11 [ffffc900460a7da0] xlog_cil_process_committed at ffffffffc21e9747 [xfs]
> >   #12 [ffffc900460a7dd0] xlog_state_do_iclog_callbacks at ffffffffc21e41eb [xfs]
> >   #13 [ffffc900460a7e28] xlog_state_do_callback at ffffffffc21e436f [xfs]
> >   #14 [ffffc900460a7e50] xlog_ioend_work at ffffffffc21e6e1c [xfs]
> >   #15 [ffffc900460a7e70] process_one_work at ffffffff9d12de69
> >   #16 [ffffc900460a7ea8] worker_thread at ffffffff9d12e79b
> >   #17 [ffffc900460a7ef8] kthread at ffffffff9d1378fc
> >   #18 [ffffc900460a7f30] ret_from_fork at ffffffff9d042dd0
> >   #19 [ffffc900460a7f50] ret_from_fork_asm at ffffffff9d007e2b
> > 
> > This patch adds cond_resched() to avoid softlockups similar to the one
> > described above.
> 
> You've elided the soft lockup messages that tell us how long this
> task was holding the CPU. What is the soft lockup timer set to?
> What workload causes this to happen? How do we reproduce it?

Thanks for your reply. :)

The soft lockup timer is set to 20s, and the cpu was holding 22s.

The workload is a test suite combining stress-ng, LTP, and fio,
executed concurrently. I believe reproducing the issue requires a
certain probability.

thanks,
Jinliang Zheng. :)

> 
> FWIW, yes, there might be several tens of thousands of objects to
> move to the AIL in this journal IO completion path, but if this
> takes more than a couple of hundred milliseconds of processing time
> then there is something else going wrong....

Is it possible that the kernel’s CPU and memory were under high load,
causing each iteration of the loop to take more time and eventually
accumulating to over 20 seconds?

> 
> -Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
