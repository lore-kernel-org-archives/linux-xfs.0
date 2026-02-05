Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEAA23A7825
	for <linux-xfs@vger.kernel.org>; Thu,  5 Feb 2026 10:54:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770288893; cv=none; b=OaaupVDQ8O2SH3Oa4srgpfi6WNkNx4FhjWCi5lgBL1cfp55etjQv1z/FWAs0VbGJYIAyFDDcmJ3dyjdnzwBSjL9add6Tt2W2jubf9NA3AeRGUv0PraBGkNUvGCIRpey8/EJuUH3ZPdwkP0yg2nT71sR2oq5S8M8HW38S0F4g9WE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770288893; c=relaxed/simple;
	bh=UzIJ5uLmy6/QZkt4fUvhxcZm9S704OaZSpcQq971ZZs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ejoHuSeVLPChGsHiSsQ88JAiAx8uyyCbEK2/TShKMzKIxHYzOisnUsqSVEFkkctFqRzNZWcMLpBCdLkgLQkF0e9yTanMt3Pd817lewWBd6aKsiEhTJj2b/v+F6zhFIj4GdAQDoP10vM9blTJtJh7TkDiXhQp79uVv1Ci4CGWAso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=DX+QH964; arc=none smtp.client-ip=209.85.215.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="DX+QH964"
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-c6541e35fc0so477380a12.3
        for <linux-xfs@vger.kernel.org>; Thu, 05 Feb 2026 02:54:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1770288893; x=1770893693; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=R73q+WeQhTVseqbSpyKGYx71Ii0OR2nQn6ZRCzszols=;
        b=DX+QH9648nrjLauuvP7r/zlUDamx4RFL6PYlJGAbun1ljPrgPksQRaDaPs6d526OYU
         eAfZlgJgpy6tEFI6iBHa51gnKFoes0CEt1sp9FgxQYfSybdAY6bGBN2RsPl6GZFvX4vT
         kejsk7mS5/Em+CrxEOzlzYrGWv099qGLuNqJLprlmIlGx3TeoBpdp4Qs4U3I0iGodSc+
         XKXpYmM/4obR5+ul5W3qivkgv7PjweXnECj6tUz1iPms+/hlY35PXGCJfkAYnF0qaZue
         icb8k/qgzT51Tt5sAPgsNn4iITKqQzx5WCF6iAkqMDTLnUJUkgCEAyQrB3TsVj3ztb0M
         x9DA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770288893; x=1770893693;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=R73q+WeQhTVseqbSpyKGYx71Ii0OR2nQn6ZRCzszols=;
        b=S6HH283nzp8kz7sgzOKqYi6JXNHN/bQqwtac9O4MA+ji0RrqcbcM8HmitUtOFOs8g7
         sXXPJUIFrreNvknAcW8zdd4dUmcKZ8blJqlCedLAHkizzpCe9C4anEwwHY33LXtAjI8b
         Plb4xw6J/PxvKWrQLmMIYPof7qzis7HNfACawKoN+k3D4iM7DCgoAvPDrAKxDt+Mu7Mp
         bVzl4Klojx5R2PCWs/Cj7Nb++aLth0XD0ZimJridlb0Olcsc1CFiZTvCQWv4FQ3pg0ED
         7XqSg8nBqdqbrv0w2doZXSTZApOq+haPiTFzTSH+7QI0Zz869IVlKpVMHT3FetCkOkIp
         dwPA==
X-Forwarded-Encrypted: i=1; AJvYcCXF2Wdigri5x1adnedp77IfBXVax2xUOiV4KVmyB/oaxHS7Y+CK2/PXj/u4xHiMA+coSHlGwE5EEsQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzc66cX9cVJVlkKhP0VZDmujWJiKBSii08vrpo+mYRSBSks74Vp
	AuA7htKQk01fEg1o2vQ6D9wbTlshM3L/CWBO4zu4kVQhloVL9Hc1064K8Zg2r2ZRasY=
X-Gm-Gg: AZuq6aK8iWe8iYjsXex5VFcbpRE3s87LuOMn+2kiOG8ab62NBPLxwS3CkhMKHna9trn
	svZ3ZLLYHLYwe+R6rE0bna8+gK6UGdw9OfrxQni6MQ3+W4AopYbWBR+fLgGFpnTi2bFvrry+s99
	7I53PyRUb2YWcn5jtYYN08oVLUbgb8+2fTFjxHLzunNoR3AVafGY8c944u1owhSbEASRa6pTJWY
	Bb7yQ+YiiaF/yVdnSd4RLwGmLuEr59kVpyBUy74WjEkBpSOAa/WlzLnccj2GGmpSPe7xSJrDF5R
	Q7y8/RvrZIEvYO3gKnVr9g2D09gUHXUStW7+TA8EVOFIKK4jL+C/EhE68gRce3ZWdWI6YXwNUS2
	vX1c9yD8kbpaWQhu5KgZ1VAbBiXok/FjO/Q003uVrJq7W5Y/D7jT8vQgxYAXqXGf5mJwAKN4RwN
	wVR7x/GpuLmazhDVv2GqgnNTwlT4gU4YZS2P8MmfSNbJG01RgUvCt940ud81fF4Tw=
X-Received: by 2002:a05:6a21:33a3:b0:38b:dd94:936d with SMTP id adf61e73a8af0-393720d7387mr6307529637.21.1770288893040;
        Thu, 05 Feb 2026 02:54:53 -0800 (PST)
Received: from dread.disaster.area (pa49-180-164-75.pa.nsw.optusnet.com.au. [49.180.164.75])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c6c8581fe1esm4602582a12.35.2026.02.05.02.54.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Feb 2026 02:54:52 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.99.1)
	(envelope-from <david@fromorbit.com>)
	id 1vnx0b-0000000DD9B-32ae;
	Thu, 05 Feb 2026 21:54:49 +1100
Date: Thu, 5 Feb 2026 21:54:49 +1100
From: Dave Chinner <david@fromorbit.com>
To: alexjlzheng@gmail.com
Cc: cem@kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	Jinliang Zheng <alexjlzheng@tencent.com>
Subject: Re: [PATCH 1/2] xfs: take a breath in xlog_ioend_work()
Message-ID: <aYR2-Y-Fe2Chh5if@dread.disaster.area>
References: <20260205082621.2259895-1-alexjlzheng@tencent.com>
 <20260205082621.2259895-2-alexjlzheng@tencent.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260205082621.2259895-2-alexjlzheng@tencent.com>

On Thu, Feb 05, 2026 at 04:26:20PM +0800, alexjlzheng@gmail.com wrote:
> From: Jinliang Zheng <alexjlzheng@tencent.com>
> 
> The xlog_ioend_work() function contains several nested loops with
> fairly complex operations, which may leads to:
> 
>   PID: 2604722  TASK: ffff88c08306b1c0  CPU: 263  COMMAND: "kworker/263:0H"
>    #0 [ffffc9001cbf8d58] machine_kexec at ffffffff9d086081
>    #1 [ffffc9001cbf8db8] __crash_kexec at ffffffff9d20817a
>    #2 [ffffc9001cbf8e78] panic at ffffffff9d107d8f
>    #3 [ffffc9001cbf8ef8] watchdog_timer_fn at ffffffff9d243511
>    #4 [ffffc9001cbf8f28] __hrtimer_run_queues at ffffffff9d1e62ff
>    #5 [ffffc9001cbf8f80] hrtimer_interrupt at ffffffff9d1e73d4
>    #6 [ffffc9001cbf8fd8] __sysvec_apic_timer_interrupt at ffffffff9d07bb29
>    #7 [ffffc9001cbf8ff0] sysvec_apic_timer_interrupt at ffffffff9dd689f9
>   --- <IRQ stack> ---
>    #8 [ffffc900460a7c28] asm_sysvec_apic_timer_interrupt at ffffffff9de00e86
>       [exception RIP: slab_free_freelist_hook.constprop.0+107]
>       RIP: ffffffff9d3ef74b  RSP: ffffc900460a7cd0  RFLAGS: 00000286
>       RAX: ffff89ea4de06b00  RBX: ffff89ea4de06a00  RCX: ffff89ea4de06a00
>       RDX: 0000000000000100  RSI: ffffc900460a7d28  RDI: ffff888100044c80
>       RBP: ffff888100044c80   R8: 0000000000000000   R9: ffffffffc21e8500
>       R10: ffff88c867e93200  R11: 0000000000000001  R12: ffff89ea4de06a00
>       R13: ffffc900460a7d28  R14: ffff89ea4de06a00  R15: ffffc900460a7d30
>       ORIG_RAX: ffffffffffffffff  CS: 0010  SS: 0018
>    #9 [ffffc900460a7d18] __kmem_cache_free at ffffffff9d3f65a0
>   #10 [ffffc900460a7d70] xlog_cil_committed at ffffffffc21e85af [xfs]
>   #11 [ffffc900460a7da0] xlog_cil_process_committed at ffffffffc21e9747 [xfs]
>   #12 [ffffc900460a7dd0] xlog_state_do_iclog_callbacks at ffffffffc21e41eb [xfs]
>   #13 [ffffc900460a7e28] xlog_state_do_callback at ffffffffc21e436f [xfs]
>   #14 [ffffc900460a7e50] xlog_ioend_work at ffffffffc21e6e1c [xfs]
>   #15 [ffffc900460a7e70] process_one_work at ffffffff9d12de69
>   #16 [ffffc900460a7ea8] worker_thread at ffffffff9d12e79b
>   #17 [ffffc900460a7ef8] kthread at ffffffff9d1378fc
>   #18 [ffffc900460a7f30] ret_from_fork at ffffffff9d042dd0
>   #19 [ffffc900460a7f50] ret_from_fork_asm at ffffffff9d007e2b
> 
> This patch adds cond_resched() to avoid softlockups similar to the one
> described above.

You've elided the soft lockup messages that tell us how long this
task was holding the CPU. What is the soft lockup timer set to?
What workload causes this to happen? How do we reproduce it?

FWIW, yes, there might be several tens of thousands of objects to
move to the AIL in this journal IO completion path, but if this
takes more than a couple of hundred milliseconds of processing time
then there is something else going wrong....

-Dave.
-- 
Dave Chinner
david@fromorbit.com
