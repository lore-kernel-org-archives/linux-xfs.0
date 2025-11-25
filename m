Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5629F23EAAB
	for <linux-xfs@vger.kernel.org>; Tue, 25 Nov 2025 22:32:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764109925; cv=none; b=U+dj6TmHpIL1EXaL7vt/goX9mjxh1SUyiW4cBshkdGOeIpHWn+SRF35ZNhPuzfroZWoklo3o7CuEVLMT7IkgR/p3utdmueuqTh9nN85nP8kd4hHJiFRm7cp7TCyg0Z4iUsHBNxE8hD8dik2RonCLriGL5ZIbOSCtam5uBa7LOAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764109925; c=relaxed/simple;
	bh=Rc2fSKj/afJDksfHpvKCQkO/06r9s7DxoTkLz3gz4zI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jLNR3vLifYcKtws0cpQPWV5GqRbuvH/agQgWJn5WyKN9EnNpTCzZlHuM0F+pZd5cCsncuOUX2x/QsmDRrfJGc4BsemcTdLwc+bVYobYsLLUis3IO7m/4YHQh17CQ5DOpDYhNC6XCbtAJZ2n16NuUmJPUPv1NaWGp6kmVDDUdpDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=LZIBJVQT; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="LZIBJVQT"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-298287a26c3so70240085ad.0
        for <linux-xfs@vger.kernel.org>; Tue, 25 Nov 2025 14:32:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1764109923; x=1764714723; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=0Y9+kPYFv8ucX2yEpYHlHRyhgJvjtCKMKbzQomdQ8o4=;
        b=LZIBJVQT6ihfxWYhoQe+nzWZvZG8rDLZrf2bfc9/V/echK3hXi5Ivmnc1heFVQy/jc
         0BFZ9lbNj6c1bQZS9aZSfx+kb6jd8Y3ufm1SYrPRjsxQ9+vL7w3ZUuwmf8YgcYminAb8
         7K/mspnu75c8McX/I5tjX9OJTpyUPjETEkTOcIdh4NCdGgmEFqoZGEWAn2816/r2ZQi7
         9NWcXU0HWMSVVpnjk4/EzBRpsbywjtnVHuG82Mbku6aojTdO4z+6qE18gAjoKzv1yQRF
         lvFUNtgUOzu9xzj/thCTnu8hoKaEKWikuMO3Gox7w8lQGiD8788iZRlxCW5/KIj5m5EW
         7nkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764109923; x=1764714723;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0Y9+kPYFv8ucX2yEpYHlHRyhgJvjtCKMKbzQomdQ8o4=;
        b=r7zqIkrh5urtq/lFLThQKwFpB7dRpLKewakx7wa9ZScIK3+fFuj/TW+bjuJ2VuHw2B
         Kh1LeGDjxBmERZTxHNmtwGIJqkvbDOb7l/mvNsKZJ1h6xt4ZLWitf9Pxd9KXuqljgj/z
         WWfK8pxHEeuM09As95MYOvRpXne+8ZH7KPmLlyQqdygZDStQCRlJI/qEgig4Oe4AfI1A
         yvO77/nN/0ry28z0hqrHiJheFMWVyq+KstcMX0YjsX7S6KCaQiPgSOZLnNUk7Q/5H7nD
         8KjllywLUA6cQZUhKo83giQpwEU+k91iEDR61PLGRmzTCjNDAtES5s0p5pAXgOHPf8Qo
         COHg==
X-Forwarded-Encrypted: i=1; AJvYcCUwXP0n8Upzev1C+PZsjItyiDiuj3wIBe1lBdpzehdoYNRtv/XXtUSltRF1xycWTF+JSUEH3hONLV4=@vger.kernel.org
X-Gm-Message-State: AOJu0YwuJFIwCcp55HdisfOA06uMqGxeSt4HhxL6sPo/wbLDzvLo/FzA
	w7Dj2fu83dOzHu99MvXMDib3+PbFLHMaiKhmXWTbdAhf2sLuzhi8zKVy1iRn5PCJlVc=
X-Gm-Gg: ASbGnctVZinx6UZYuNCLwYV13K+7/zYyGcVbLSC/jOJOksc3idcLOkwYBZqfZn44lj2
	kqKWXKJxAiPppcQYFRxra3lRDDP/QDFk71dqgJ2rHQK2hENa2KqKgKnGAmnhdDSRNC4dRqCUM7p
	xfROFraIee9nHif2UCTG3po195lQLgHxXgRu/guk+rjXGVdMv9Ooi9OvEihQt81BK6Wbu1nDCwe
	j8yufdes0dwr0nXCKsSd6btJ3ZW6dRpjNDcYNYrWqXaFbQswPbVrGOkVx1nVxMZ/fG1vBnSOSa2
	jeElEgkzYbSRWXLq0CGPHMvvhkPL+MB3zlD8s07378j6r+fSUIRt+BME2eaPu43mnVLYsvEhtm/
	AK8GRCQnwqIBm7qtt+jzYEzETn+lBkI/0yxUaG1ZsBnjsh4I070INW6C/9CxPzdPcbqn8+I3bed
	hk24v2l0siQJCgS92vQskBtcSfXqg6cVJaurhM5g1u8kOc0Q8qV04vp6ZUs25row==
X-Google-Smtp-Source: AGHT+IHVJBaArcUiHcfGBDNgJ5sM7FipaT41dEFAlDXLKA6CypV693FqSFJaQcUA8/7FA7L54SL/UA==
X-Received: by 2002:a17:903:3845:b0:298:6a79:397b with SMTP id d9443c01a7336-29b6bf80914mr210728855ad.56.1764109922381;
        Tue, 25 Nov 2025 14:32:02 -0800 (PST)
Received: from dread.disaster.area (pa49-181-58-136.pa.nsw.optusnet.com.au. [49.181.58.136])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29b5b00e1fasm175594855ad.0.2025.11.25.14.32.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Nov 2025 14:32:01 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.98.2)
	(envelope-from <david@fromorbit.com>)
	id 1vO1Zn-0000000FjIW-1Ls5;
	Wed, 26 Nov 2025 09:31:59 +1100
Date: Wed, 26 Nov 2025 09:31:59 +1100
From: Dave Chinner <david@fromorbit.com>
To: Karim Manaouil <kmanaouil.dev@gmail.com>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: Too many xfs-conv kworker threads
Message-ID: <aSYuX47uH4zT-FKi@dread.disaster.area>
References: <20251125194942.iphwjfx2a4bw6i7g@wrangler>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251125194942.iphwjfx2a4bw6i7g@wrangler>

On Tue, Nov 25, 2025 at 07:49:42PM +0000, Karim Manaouil wrote:
> Hi folks,
> 
> I have four NVMe SSDs on RAID0 with XFS and upstream Linux kernel 6.15
> with commit id e5f0a698b34ed76002dc5cff3804a61c80233a7a. The setup can
> achieve 25GB/s and more than 2M IOPS. The CPU is a dual socket 24-cores
> AMD EPYC 9224.

The mkfs.xfs (or xfs_info) output for the filesystem is on this
device is?

> I am running thpchallenge-fio from mmtests (its purpose is described
> here [1]). It's a fio job that inefficiently writes a large number of 64K
> files. On a system with 128GiB of RAM, it could create up to 100K files.
> A typical fio config looks like this:
> 
> [global]
> direct=0
> ioengine=sync
> blocksize=4096
> invalidate=0
> fallocate=none
> create_on_open=1
> 
> [writer]
> nrfiles=785988

That's ~800k files, not 100k.

> filesize=65536
> readwrite=write
> numjobs=4
> filename_format=$jobnum/workfile.$filenum
> 
> I noticed that, at some point, top reports around 42650 sleeping tasks,
> example:
> 
> Tasks: 42651 total,   1 running, 42650 sleeping,   0 stopped,   0 zombie
> 
> This is a test machine from a fresh boot running vanilla Debian.
> 
> After checking, it turned out, it was a massive list of xfs-conv
> kworkers. Something like this (truncated):
> 
>   58214 ?        I      0:00 [kworker/47:203-xfs-conv/md127]
>   58215 ?        I      0:00 [kworker/47:204-xfs-conv/md127]
>   58216 ?        I      0:00 [kworker/47:205-xfs-conv/md127]
>   58217 ?        I      0:00 [kworker/47:206-xfs-conv/md127]
>   58219 ?        I      0:00 [kworker/12:539-xfs-conv/md127]
>   58220 ?        I      0:00 [kworker/12:540-xfs-conv/md127]
>   58221 ?        I      0:00 [kworker/12:541-xfs-conv/md127]
>   58222 ?        I      0:00 [kworker/12:542-xfs-conv/md127]
>   58223 ?        I      0:00 [kworker/12:543-xfs-conv/md127]
>   58224 ?        I      0:00 [kworker/12:544-xfs-conv/md127]
>   58225 ?        I      0:00 [kworker/12:545-xfs-conv/md127]
>   58227 ?        I      0:00 [kworker/38:155-xfs-conv/md127]
>   58228 ?        I      0:00 [kworker/38:156-xfs-conv/md127]
>   58230 ?        I      0:00 [kworker/38:158-xfs-conv/md127]
>   58233 ?        I      0:00 [kworker/38:161-xfs-conv/md127]
>   58235 ?        I      0:00 [kworker/8:537-xfs-conv/md127]
>   58237 ?        I      0:00 [kworker/8:539-xfs-conv/md127]
>   58238 ?        I      0:00 [kworker/8:540-xfs-conv/md127]
>   58239 ?        I      0:00 [kworker/8:541-xfs-conv/md127]
>   58240 ?        I      0:00 [kworker/8:542-xfs-conv/md127]
>   58241 ?        I      0:00 [kworker/8:543-xfs-conv/md127]
> 
> It seems like the kernel is creating too many kworkers on each CPU.

Or there are tens of thousands of small random write IOs 
in flight at any given time and this process is serialising on
unwritten extent conversion during IO completion processing. i.e.
so many kworker threads indicates work processing is blocking, so
each new work queued gets a new kworker thread created to process
it.

I suspect that the filesystem is running out of journal space, and
then unwritten extent conversion transactions start lock-stepping
waiting for journal space. Hence the question about mkfs.xfs output.

Also info about IO load (e.g. `iostat -dxm 5` output) whilst the test
is running would be useful, because even fast devices can end up
being really slow when something stupid is being done...

Kernel profiles across all CPUs whilst the workload is running and
in this state would be useful.

> I am not sure if this has any effect on performance, but potentially,
> there is some scheduling overhead?!

It probably does, but a trainsmash of stalled in-progress work like
this is typically a symptom of some other misbehaviour occuring.

FWIW, for a workload intended to produce "inefficient write IO",
this is sort of behaviour is definitely indicating something
"inefficient" is occurring during write IO. So, in the end, there is
a definite possiblity that there may not actually be anything that
can be "fixed" here....

-Dave.
-- 
Dave Chinner
david@fromorbit.com
