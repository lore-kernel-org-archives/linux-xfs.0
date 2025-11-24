Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F5022F363B
	for <linux-xfs@vger.kernel.org>; Mon, 24 Nov 2025 21:18:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764019107; cv=none; b=FhNMeuFhJXEe1tMJWpmOVG84n5O51s+SYBNMmk2+1IsgfJTEoLjkcHLu4ydaXxgvdL6PApmqTfR0tOoHpfKyNgl0nQPnnX9puewcu4507KxWai149Z1pLKaOUn5yXTrdowNtP5Qygq9C/IjJs/iFZjhQi3+rA+5WXEHJYXJVv14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764019107; c=relaxed/simple;
	bh=U/6ijBiZfLKZP4SBJ6gRaszqcpdtccxyVQjPWxwDjFA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IUTMRFVpBWjq4Qvue6WlIRJUWBn0JX98xWwGjdfgwgsD6iNVTBqHAi08ZA3rO+9VQIkoHybI2tw9u1Cox01ftrX//a+qFreU/DKEjgc0TMNn+h/YfkdaAdkZ2Y0WQMz0y9Gq+5DL375bHZz5rir83K2j7l7MsDg9U7EuKX1IDDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=H+bJh8Zj; arc=none smtp.client-ip=209.85.216.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="H+bJh8Zj"
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-340e525487eso3252250a91.3
        for <linux-xfs@vger.kernel.org>; Mon, 24 Nov 2025 13:18:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1764019105; x=1764623905; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=suztNBOgR1T8pGFJFpgqi91g5sMIV7H4wSkwY4vuym4=;
        b=H+bJh8ZjrXiXfD1EBtwQwRxBe/sMINRCp+QedYLjzzsQHV2uPuh7C+DzPh0gIaSgng
         6MveetvXoHSxbu1HeV+tY1fTZgirK0BS1Je74OPOBkr6IE7WshxLPNkFqr31E7rGfD4j
         /5nrC8l/dHICcOzK/YGbr1nANoZ/fLNPpicUpaTtAI2gOMcFqv0guVSkdNYxSZ/2e+Fy
         GWNBAQpw6FAzWA7+3bhPC/SIm7F8gzTTCr2QX6xdfV9yCH7GZC5BDa1g2IfEgo8m/afo
         mM+GGgFSnzIazwkHQ5Le+D9R3TZLhD6XUAkiBqrCkVWChyu1NPRbYblmSmzbQB9k3QWQ
         1Qnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764019105; x=1764623905;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=suztNBOgR1T8pGFJFpgqi91g5sMIV7H4wSkwY4vuym4=;
        b=uQVvRr4FnFwU2U9ZgeXeqWFB2kAuWXTuGvdraFaoRofyfC8Io5ueC16oi9tLUxM61y
         pKosdniYR9s1MnLsN3gif4MEXbqpXBsn2Pgw6DO+PpUivZbp0u25dBsKFTVAk6ATN/Fd
         Rm9pYASYYG0uV8FDKCyPpqB674UKCdNtZEe5X7C7bFu9+OFFIx5nTzJL0hkurYXoClST
         V7JYkifQKfx9uGDEdb98M1dGDKekdkf5ga/OrENkVs41d6Qoy1nT13pmlZEFG3nKLXcj
         32xCu07UuFQDJ6A5oEgPZBhhPsRX+gA+uG05HWEK20h/WGuv0hjxFxtfohI+6z56SXMr
         VoGQ==
X-Gm-Message-State: AOJu0YzadGubOsMHDsqxxn3kb/utJT4hc0+oI8Ud7gjTqW/gegtnwLvA
	Lv1/Y3fEypWBJN5BQNJs8bOMY5ZTi+Bja0NM/vfcD+TINNmGffUaVAfAqvuTspw11TE=
X-Gm-Gg: ASbGncu7pW447VAiAjxINOtO9UD/CrBmPTDJZqu3yWxGcJ6pVIJ5xWzxwGRBEIwZTtL
	T20UwhEJGB6mC6i3ercUW56vqextEcN0i+zllxlsL9bdv5iUl+aLl2RX4X1t8DnXAbktpbILx2R
	nwKO8+wJiQyTD1b0iJRYmB/n+C0V3KqcDJvxMkYqSQq0KSNFzNQFoXXPfz1odL5rFBd6BLz6T1d
	LAAluM1EUkxhAoT7dXlm5sm2mS0TdkGdo6w0xOuoAEIpqcBoXqFbeNP5dqt4kkaA5Cb2w5cFIbD
	cyh/O4x6Jcmvqm6o/D9SiTpajyM2TPkbHCvjJUrV5X9307pRn3HVBTHpicVxkCts9OpzsJUqMQe
	EHTrlH7EbRTcFFwKIayyRYMKel8X7JsH2+1lxluNzxiSf4kiiUHrFi+OIbdnZzj643hdqNX28eN
	hO87wtHEb/dvbc7lKy8Ts5GZ9DSh7bwjIK6K4XNLYczgJTlPT/KbZZAPm1fKWbwQ==
X-Google-Smtp-Source: AGHT+IEoJhtxWwWCry1Cl9aKYTq8PHRYSfTb7Vo8LDGxTV94KMr7Y5QEQlg3C2i0X+fJeHNPli6hIQ==
X-Received: by 2002:a17:90b:3848:b0:32e:4924:6902 with SMTP id 98e67ed59e1d1-34733e54ff1mr11913845a91.3.1764019104368;
        Mon, 24 Nov 2025 13:18:24 -0800 (PST)
Received: from dread.disaster.area (pa49-181-58-136.pa.nsw.optusnet.com.au. [49.181.58.136])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-bd75e4ca0casm13876830a12.10.2025.11.24.13.18.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Nov 2025 13:18:22 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.98.2)
	(envelope-from <david@fromorbit.com>)
	id 1vNdww-0000000FGMR-3BT2;
	Tue, 25 Nov 2025 08:18:18 +1100
Date: Tue, 25 Nov 2025 08:18:18 +1100
From: Dave Chinner <david@fromorbit.com>
To: haoqin huang <haoqinhuang7@gmail.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: fix deadlock between busy flushing and t_busy
Message-ID: <aSTLmuZFNd3n4mKq@dread.disaster.area>
References: <20251114152147.66688-1-haoqinhuang7@gmail.com>
 <aRnLqK_N25LvkSZQ@dread.disaster.area>
 <CAEjiKSmvzr1M-2=5SPA0hQo1-442t-_zLB3zBj1jqWoZ0tMCUQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAEjiKSmvzr1M-2=5SPA0hQo1-442t-_zLB3zBj1jqWoZ0tMCUQ@mail.gmail.com>

[ Please reply on list, added linux-xfs back to cc list. ]

On Sat, Nov 22, 2025 at 05:28:25PM +0800, haoqin huang wrote:
> Hi Dave,
> 
> Thanks for your reviews, and sorry for response lately.
> 
> I’m very agree that deferred frees largely resolved the deadlock issue.
> 
> Maybe I should split two parts of this patch to show my idea:
> Part 1. fix fallback of xfs_refcount_split_extent()
> It seems better to  fix a logic bug in xfs_refcount_split_extent().
> When splitting an extent, we update the existing record before
> inserting the new one. If the insertion fails, we currently return
> without restoring the original record, leaving the btree in an
> inconsistent state.

Yes, because we can't actually recover from such a failure. We have
dirtied the transaction, so when it gets cancelled on an error
return, it will shut down the filesystem. Hence there is no point in
trying to unwind previous modifications in the transaction on
error...

> This part does not seem to be necessarily related to the
> aforementioned deadlock.

It isn't, but it is also unnecessary.

> Part 2. Robustify the rollback path to prevent deadlocks
> The change to xfs_extent_busy_flush() is just added as a secondary
> hardening measure for edge cases.
> I’m not sure, but theoretically, the alloc_flag to be zero, then
> entering a cycle with a high probability of deadlock.

We definitely allow alloc_flags to be zero - this is not a bug or
a behaviour that needs to be worked around. Those callers aren't
likely to also hold overlapping busy extents in the transaction
themselves, so there shouldn't be any deadlocks in those callers.

Really, it's the nature of the btree modifications (multiple record
updates (and hence block free/alloc) per transaction) that leads to
the potential deadlock. Only the BMBT and REFCNTBT trees have this
issue because they require allocation from the free space btrees
rather than the AGFL pool. However, multi-record updates of these
btrees are no longer deadlock prone because of the deferred freeing
of extents.

Hence, in all other contexts, it is generally safe to call
xfs_extent_busy_flush(0) and block waiting on busy extent processing
to complete. There is no reason to force callers like this to
implement an -EAGAIN loop around xfs_extent_busy_flush() in an
attempt to prevent deadlocks. i.e. if there is a deadlock, they'll
now just have to busy-loop trying to flush instead of sleeping
waiting for flush completion...

-Dave.
-- 
Dave Chinner
david@fromorbit.com
