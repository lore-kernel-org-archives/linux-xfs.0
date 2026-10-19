Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.214.176
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792450474;
	b=Mqnjb1ncuQpy2pALYmC2P4OeS6O4E6+4ufXtq60BXtXo+NXqFQqLTU4byaTciOUeRcyt
	 JuTtvJ60qrG9LsFoDnVITTH7Sg+lWBTrCVFLhQ80yyfvG9IcFEywpWY5FoDX3u/z8kWMZ
	 sSj4IO+VEdZKC88nLdso90i5Lpc+kQHbhQJloUDrkC9aN+b6ykghah0w3hWzI/XOxg4Eu
	 Bx287SU7aTBNZMg1G+6nxIBwadah+HlnR+Tq/IetOmn4oOx7mZz4mGHsyLP0BF1Zs6vGc
	 BUsdJl4XWECeBlgVUZwR1G9ISdgX8fd8YlVSLngYH0bWqdtibkZ5OW+cVfff+TVLdlQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792450474;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:MIME-Version:References:
	 In-Reply-To:From:Date:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type:Content-Transfer-Encoding;
	bh=rCO/lZ2sP8Jz0naL1JPg9LjaGwFq/z1O7c7Gss5nt6o=;
	b=oz8JOY183+k7CacuZohla7v4h6LQBSz+W5q/irx13F26z/pR8X0fHFI87Gwnz6kUW2ux
	 uA5NaZanToywcsF/tYUm7OBH54YDGujFsdnlz4c2XMePuKjyI+kO0QZ2qZjmXPt6SVB82
	 OfMwChuQaCu1fbDfLzpMjx3MsopcKs9hduHTv/rzp8NCSLP5giPaNnqgBggX0lozw4353
	 cvXx0SMkW6QX917AjR7pSow5iRRd+Ea7R1BTqgvIQcI3KofJjjcWHXKh6cFF3S20Mhhyh
	 aMdb+TP1geZtihaFeCHkLYvJFbqPutzMF2hCuc54QS35+bwe19LQNhb1xXvBwJ0SK0Q==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=UKVxmLJ7;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.214.176
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD146606A319
	for <linux-xfs@vger.kernel.org>; Mon, 19 Oct 2026 22:54:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DD146606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=UKVxmLJ7
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2e60f9af6e6so20623185ad.3
        for <linux-xfs@vger.kernel.org>; Mon, 19 Oct 2026 15:54:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792450473; cv=none;
        d=google.com; s=arc-20260327;
        b=S0/Jh0sDYXu/dooNB5mxnspqJuLn03AZUpVzYPFAFc33RUwDDgC7TBusZgoAL92RLo
         rCSPhnGYJhRFnCevG89pJQPObp0yg3i5EdooNSCVqJyAA/qJv4k9MB5TYwQb3C1kGEXT
         xIFWOjmwqfaouLu0s/VDY9Dn+EQOlrhsskhvSLOA9HK662ysGuLr098+1uHoclRTov/F
         0HjJz60trmeaXOjVX3GOX1QR/hkW1DOcR4XSZqOjawNK8Gw8+Asms8ozIaKq3oHsPYRX
         BKU8xnn9rs7qXzdLp9GqZ/Nt8SwjQJAA9z6f5VmYxkgzgbXtTL57xBlkg6a/v2PbIpm7
         lrPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=rCO/lZ2sP8Jz0naL1JPg9LjaGwFq/z1O7c7Gss5nt6o=;
        fh=Ubq8TFiXC7KjvK4hOzQAhEVmIR5KxnbNmU0i16shvwk=;
        b=krrkl2Gesg3WRuftEebPDt2u36PwvDFcJokKhORPX8SOQ8aQ/htb54eP0zmVQfLmOn
         NRxDKH+HscsqYaWn9B7sLrZtm6duqxenqgkQcrHlHKRMIfe/9Ti9s6/zqHElUbobLg3p
         TXcYos/Q4NtuUikF67QJXFWYw0ZTfha2LjEqptRnCXd/7VeXargwELBhAbUd0+aE1JsI
         ZBg/IhEOYgvbzNgTFkXiufhFlnOOJ5iq6GajBV/qu1KJxVKRS1SDZq2jtK+SxQ4Q1qNZ
         WKhM7UU6Jp4OayIY8j8G+13Q939oslMumIthexnh6XBQRlLkqhkF4QmR/SxV/W18vsmH
         Fxog==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792450473; x=1793055273; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=rCO/lZ2sP8Jz0naL1JPg9LjaGwFq/z1O7c7Gss5nt6o=;
        b=UKVxmLJ7m/Yad97SI6U2AZsPWn9yk9XrDcHTVyFq406n0nhHc6l2Pq3/k9o1IGGj0x
         tIrdCHQeHYsuNzK/zMSuQLkAnhOWv+0ibeBOzTzB8W/zM+1L7NnATADx2rcc5pXt+Xeo
         UHG23y2KQbigZO0fHTRt5k9euS2wrlBii+lmXHiN/SSMz6bIq1I5dEsZvDVEjGAzh6J4
         RHjM0VOOVmZZa9bTzzqus+CDPJAeJuI2OaHFv8gfHFXPGQ1Oog0N5dGm1et1JrdWnKdv
         /3Jvn+vS7qFCSSOROsJ9+eJojML9zFQGXc5RL5yMIQ6uJuWnKGK04hDOypN8i2qKRak8
         Ymig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792450473; x=1793055273;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=rCO/lZ2sP8Jz0naL1JPg9LjaGwFq/z1O7c7Gss5nt6o=;
        b=r7Ntt3Vsh1lcseo+F3lxRLeN+QTNaWl/MzKmrugY3RYiaiRyU7dvNHJ+m2pAK8m957
         GE/GhcJ7jh3xTQnady16XWu+5XiW99cHPRvIvooN+3ev72ksDHRg/oPHUG/yUMHglPcS
         DMjQe0eBnLyqmpv3C4w89vmWVKayw5XBDJne/HLuQxigXi/PVMP/XwiiaBIsnQbDvy38
         y1/Ktmj9/dx5FFT86v/LOjlEsn/56WgCISboCHSgPes5IkOyycQtixyph9kJ3NCAh6pR
         dnUwnA2EbfxJtv4cEclUaXwZ3Gddue10FUSZPe4Jy7xklXQs86mX0Q+rU9KlGthORDec
         yADg==
X-Gm-Message-State: AFq9FYKMeDF7Y9eOU5ZcCD6bfknK1/TjERzz00KGEC4lZYjOFQf6loKj
	fnsPWN6qltAy5dGlXCRQRFdWRGEbjHboYdkueuRnwEVHP+Gt6dW0RQ6vf4rp11RbCSNScbBaFs8
	CQLvWFWMchco+gi6udgMfCTd+JrN7cZIDVA1H
X-Gm-Gg: AYBFou1LGaS2CxVTUKv7x4GKSL33+M9kZMRKEIpcgJURS5E1BjBVpCXfhPQwxTXXlOq
	kMwAj+UuRAoSm2SdH27Hs8/5FyY1yFuWUcXh4Rop2pTb4RYSVSKsgQaP9GTNfWBsNrY3RelwpDt
	Zc6uFRpiDSqwS3M8Qi7mBTJqj1mJoa9UzvW5VlScwXS4OiiU4/zMwvmnIBvjAuNu68VGi3Vhndf
	Dj5MkS866SiF+v8jZaLvq15Q8nqdcRSux1/PenDugXgs0UdxVE65UO3QN3HeuWSH6NnzBKxHS/0
	pz/g+5KzNjTUNwKCwnrMQS2707s4XvTa471m9FqEidx9h0mrrjtTAlmIv58VZOc5vpLgAZkFncp
	1szzwvu+eZl9x/hczQJT7xisakGF+deWWU1gPjZqB4Dq+sh5vua1IyMM8Om3d9fAREtETzg==
X-Received: by 2002:a17:903:1a45:b0:2e9:5714:6081 with SMTP id
 d9443c01a7336-2e9a670acd0mr79362205ad.0.1792450472997; Mon, 19 Oct 2026
 15:54:32 -0700 (PDT)
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <CAF8PYMjkpEkoop-Wbk=2oBMdqer-pWh1osPvhSv90D2fwLSv0w@mail.gmail.com>
 <as1HVVUXdMlpXQGT@dread> <CAF8PYMiMZ5uFGsLnms4pNtMHc=TKgzcKvoLtydGXEFS7KM_r5g@mail.gmail.com>
 <as7wb-bdykxSKenP@dread> <CAF8PYMhk202oMMNAdT0yPDD=J8rG5kgKVRSRnf5ix+x6_SJmYQ@mail.gmail.com>
 <atF4rrzDigoX0Zyv@dread> <atF7xJlbck-xA1G3@dread>
In-Reply-To: <atF7xJlbck-xA1G3@dread>
From: Vitali Lovich <vlovich@gmail.com>
Date: Mon, 19 Oct 2026 15:54:21 -0700
X-Gm-Features: AclHuK9LDG4hTH05GTrRVF8QjD0yBFF2pA7ElF6QPHB66EL97x1m0V7aPFVPjrY
Message-ID: <CAF8PYMhboMm+kQnngeZZsmje16qwtyWBzRoqx5J9eKN3NcUbKA@mail.gmail.com>
Subject: Re: Really bad I/O lock contention between non-overlapping reader and writer
To: Dave Chinner <dgc@kernel.org>
Cc: linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I posted the patch set earlier today:
https://lore.kernel.org/linux-xfs/20261019182620.1527591-1-vlovich@gmail.co=
m/T/#md71c09676d5734c03f6af686c5463ad07d906424

It doesn't achieve full performance in the contended scenario, but
it's an important first step.
It has no impact on uncontended reads. My entire patch series builds
on this initial set has readers going at
roughly the same IOPS and P99.9 latency with concurrent hole punches
as the scenario without hole punches.
The uncontended reader scenario even gets ~2-6% faster in some scenarios.

Looking forward to your feedback. I posted this in XFS only for now
for the initial feedback even though it does have some minor changes
to the FS layer to allow the new synchronization mechanism to work.


On Thu, Oct 15, 2026 at 6:20=E2=80=AFPM Dave Chinner <dgc@kernel.org> wrote=
:
>
> On Fri, Oct 16, 2026 at 12:06:54PM +1100, Dave Chinner wrote:
> > On Wed, Oct 14, 2026 at 04:10:30PM -0700, Vitali Lovich wrote:
> > > Ok. I have a patch series I'm happy to share. It has no meaningful
> > > performance degradation / scaling problems and largely fixes the
> > > head-of-line blocking problem without the challenges of range
> > > tracking. Before I post it, some stylistic questions for you:
> > >
> > > * Do you prefer it as a new RFC e-mail chain or continue here
> >
> > New patch series.
> >
> > > * Are there specific benchmarks / workloads you'd like me to gather n=
umbers?
> >
> > FIO exercising random rw 4kB DIO at differing levels of concurrency
> > is the minimum.
> >
> > > * Is a VM with RAM XFS filesystem sufficient or is raw metal w/ an
> > > NVMe drive required?
> >
> > I'd typically test this on a machine with 32+ CPU cores and an IO
> > subsystem that can sustain >2 million random 4kB writes
> > indefinitely. I'd then use fio using pre-written files to hit it
> > with increasing IO concurrency to the same file with either io_uring
> > or AIO with direct IO to exercise shared access scalability.
>
> Oh, I should have mentioned: RAM disks are -slow- compared to a
> single high performance NVMe SSD, let alone a machine with a couple
> of dozen of them.
>
> THe problem is that RAM disks always do synchronous IO and they
> consume CPU time copying the data to/from the RAM disk to/from user
> buffers. Hence you can only have one IO per CPU in flight at a time,
> instead of a few thousand IOs in flight per CPU when using
> asynchronous IO on spread across many NVMe SSDs.
>
> IOWs, never use ram disks for performance testing XFS filesystems -
> the results never reflect real world performance on actual storage
> hardware.
>
> -Dave.
>
> --
> Dave Chinner
> dgc@kernel.org
