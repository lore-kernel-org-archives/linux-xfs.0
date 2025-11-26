Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 003151FF7C7
	for <linux-xfs@vger.kernel.org>; Wed, 26 Nov 2025 22:33:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764196418; cv=none; b=AWyRMT0hz7eoXNCpyYzPVW/3UAC3mk1KDLvREM7VAyBVgNE/fyBG2Rwyb6JErdU2E1k0QK3LhYCmAtwnd1ObOkcvhGmd+K9i2SEtPYvT9q39FN4yXGelgM680jPM5kkZqrXauNfSHM/2rPilT90j0l6xaVDmzs0vx1k0R+9ke1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764196418; c=relaxed/simple;
	bh=dufnRkirIxziuqu3T2ICgzA0gTCQjGaasdp0XTVQ4ds=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UtKF87Nu9PwPF78pASB1K7SRTZBLYkoyeMw0JP3SiwewF1Ucvt6dCVfxsufBrtZDZ3uyFmBXRV92BGOl/0oYLDhcECN53xeavVH9iO37SI88zGWZyLsg+6phpRfYOPktIyDKkZq6ld36hKl4BIuzKcY+1Mwf2ODz+RORSNJUxYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=uU7QnuOW; arc=none smtp.client-ip=209.85.216.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="uU7QnuOW"
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-343ee44d89aso297377a91.2
        for <linux-xfs@vger.kernel.org>; Wed, 26 Nov 2025 14:33:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1764196416; x=1764801216; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=nqPhQO34THrJgmVEIO8sYy5j3gs4UhBkUx4+FOQdWPo=;
        b=uU7QnuOWclHeQYylb8U3vs4z4iLV5/PC7FkZRgjTA5nBAlyk/1Wj7lk7qoBUO+duhU
         wg/Etdq5yVEsOoeyFv72N/49rj2ynCp6A2y46TlSFHInHS9O/LefhQNawD2dYHcM/DTk
         NYqgYKbs9A0VEWOisLGuobvE4iiz5VNCrJk9Lyt5H4yb3vdF5J2MjyO53yK5SlXHsXmU
         gBPOBQWIyalv++2SKp4/9hURWtA7J40+FT33w+sF5IMW3PLEPkSpfi6iN/pJiUoQrJg3
         QhnrKemNHgskLG9oZz/AsM8U4APrHvpmGcex40zcL/LGjzv2sHOdRWEd8X+8iGR+VPpi
         JLlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764196416; x=1764801216;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nqPhQO34THrJgmVEIO8sYy5j3gs4UhBkUx4+FOQdWPo=;
        b=RkE7gFqEzQloV5HWqX5kJpO48FSxZFb9CJTeHaLtYyASZJaG52YK/mkySZTmuNLKke
         G1STeWtCtHVoj0D8QhmAWQGqzd94Kn8r8q12Fo5z/zCc+YmDEg/2SJya3OQv6ueQEvF9
         sske93s+yHvPRFTKDWXIbr8OLJKR6o+ccxcj/3axm+5As3e5OZiD13CSFudsnPdXAHNm
         VYIUwLjYC0JTnzauAtvsvwXEmJRa61qigT18qSAPiYMHQo+bch8fW/D896lwGON7WTlh
         RcnBjDWgg+9i43m2mPucC/yMv8eiia4IoZPxFKh9WcCd52Cdzp2lwvLhN7s9Pl5RJe0O
         wjZA==
X-Forwarded-Encrypted: i=1; AJvYcCWa4ZB+w+ILfT3QPaO4YYXlMXMTd4t4kSFFA5mKz0hlhtrZ4QI+noqzO9sObzCllg9HEq8tBtcGy9Y=@vger.kernel.org
X-Gm-Message-State: AOJu0YwuNLZ5g13mvNiVkVulH+71QIg7fPssMYWYJH8Ddh1ugmvyO3Kd
	5N+XPT0w76Cg3BVGHd+knVTmwnJzHpT7lRzbt/kIAPaACcGR50luXl3/zpR19iYRf0niUd85DgT
	Em4KI
X-Gm-Gg: ASbGncuYzXzVq4KC5QZ8RHcQ+SOptBl5MjFFvfTljgdyJnD0eilzKb8W+f0XvVmEVnQ
	9EKPtozDLahTTullZcZrRBR9mDI9WqrFlV/DkRSJruiFfdvAUc6bo12TxBU47tnD+nVEnlwznvK
	k4XnK/3GZPR9fKBwsFYWJusnrrTdIJ14Ek/VNzMatqo3onbhZcOOI0ZMLNUdZXoTzPIqiBm/zwT
	G7EsYu4hhuPrwgTsR5iE/jCxuaehV31anzrQtR2WvuaONlGmEe6XXYcDrqGB5O3YI8mnswcWC1C
	diu99/LQFCoHeuXP7rUEK5oKi24DsMl/XezBhET/RauWU2n5TBZeRcWaTA5/ZpRZyn91RFqKySw
	ODnrNcgC00e723yI8EtN9GYWcCRpta8lb9D8ANevfS3FZEfa7Di4SP3xoG0C5lhqP3EVuI94v3E
	9f0h7L8W5WZTt9ryJiEJutW1lIE55Tmv/nG1eVeCBJFF7QpPdxHmguzPOu7Gxk/A==
X-Google-Smtp-Source: AGHT+IG5c/4rqbd9CtKghqmwzuL49JPva9D26c+l3htbf0pHuEKNyYrgHmzQj13Qt7U1dGxlP8r0ew==
X-Received: by 2002:a17:90b:4b42:b0:343:7714:4cad with SMTP id 98e67ed59e1d1-34733e4588emr19489890a91.5.1764196416071;
        Wed, 26 Nov 2025 14:33:36 -0800 (PST)
Received: from dread.disaster.area (pa49-181-58-136.pa.nsw.optusnet.com.au. [49.181.58.136])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3476a547483sm3629551a91.4.2025.11.26.14.33.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Nov 2025 14:33:35 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.98.2)
	(envelope-from <david@fromorbit.com>)
	id 1vOO4q-0000000GAes-3k3C;
	Thu, 27 Nov 2025 09:33:32 +1100
Date: Thu, 27 Nov 2025 09:33:32 +1100
From: Dave Chinner <david@fromorbit.com>
To: Karim Manaouil <kmanaouil.dev@gmail.com>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: Too many xfs-conv kworker threads
Message-ID: <aSeAPOZpcGaONne9@dread.disaster.area>
References: <20251125194942.iphwjfx2a4bw6i7g@wrangler>
 <aSYuX47uH4zT-FKi@dread.disaster.area>
 <20251126132721.tagdhjs2mcbbkdjr@wrangler>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251126132721.tagdhjs2mcbbkdjr@wrangler>

On Wed, Nov 26, 2025 at 01:27:21PM +0000, Karim Manaouil wrote:
> 
> Hi Dave,
> 
> Thanks for looking at this.
> 
> On Wed, Nov 26, 2025 at 09:31:59AM +1100, Dave Chinner wrote:
> > On Tue, Nov 25, 2025 at 07:49:42PM +0000, Karim Manaouil wrote:
> > > Hi folks,
> > > 
> > > I have four NVMe SSDs on RAID0 with XFS and upstream Linux kernel 6.15
> > > with commit id e5f0a698b34ed76002dc5cff3804a61c80233a7a. The setup can
> > > achieve 25GB/s and more than 2M IOPS. The CPU is a dual socket 24-cores
> > > AMD EPYC 9224.
> > 
> > The mkfs.xfs (or xfs_info) output for the filesystem is on this
> > device is?
> 
> Here is xfs_info
> 
> meta-data=/dev/md127             isize=512    agcount=48, agsize=20346496 blks
>          =                       sectsz=512   attr=2, projid32bit=1
>          =                       crc=1        finobt=1, sparse=1, rmapbt=1

rmapbt is enabled. Important.

> This is the last 20/30s from iostat -dxm5 during the test. It's been the
> same consistently throughput the test at ~80/89% utilization.
> 
> Device              w/s     wMB/s   wrqm/s  %wrqm w_await wareq-sz      aqu-sz  %util
> md127           68713.80   1051.87     0.00   0.00    1.05    15.68       72.14  89.52
> md127           66888.40    943.12     0.00   0.00    0.92    14.44       61.68  88.08
> md127           68453.80    653.24     0.00   0.00    1.23     9.77       84.37  87.12
> md127           82154.80    604.90     0.00   0.00    1.64     7.54      134.87  86.88
> md127           70320.60    295.50     0.00   0.00    1.97     4.30      138.60  87.12
> md127           19574.60     84.99     0.00   0.00    2.27     4.45       44.48  24.96
                                                                 ^^^^

And the average write IO size is between 4-16kB, and it's reaching
hundreds of IO in flight at the block layer at once. So, yeah, the
stress test is definitely resulting in inefficient IO patterns as
intended.

As for the writeback IO rate, this is pretty typical for delayed
allocation - writeback is single threaded and can block. Best case
for delayed allocation is 100-120k allocations per second.  Every IO
in your workload requires allocation, and it's running at about
70-80k allocations a second.

So, yeah, that seems a bit low, but not unexpectedly low.

> In addition, I got the kernel profile with perf record -a -g.
> 
> Please find at the end of this email the output of (~500 lines of) perf report.
> 
> I have also generated the flamegraph here to make life easy.
> 
> https://limewire.com/d/b5lJ1#ZigjlrS9mg

The vast majority of IO completion work is updating the rmapbt
in xfs_rmap_convert(). There  looks to be ~10x the CPU overhead in
updating the rmapbt (5%) vs the bmapbt (0.5%) during unwritten
extent conversion.

And I'd suggest that all the xfs-conv kworker threads are being
created because the rmapbt updates are contending on the AGF lock
to be able to perform the rmapbt update.

i.e. unwritten extent conversion bmbt updates are per-inode (no
global resources needed), whilst the rmapbt updates are per-AG.
Every file that is in the same AG will contend for the same AGF lock
to do rmap updates.

It will also contend with IO submission because it is doing
allocation and that requires holding the AGF locked.

IOWs, the contention point here is AGF locking for the rmapbt
updates during IO submission and IO completion.  If you turn off
rmapbt it will go somewhat faster, but it won't magically run at
device speed because writeback is single threaded.  I have some
ideas on how to reduce contention on the AGF for allocation and
rmapbt updates, but they are just ideas at this point.

> > > I am not sure if this has any effect on performance, but potentially,
> > > there is some scheduling overhead?!
> > 
> > It probably does, but a trainsmash of stalled in-progress work like
> > this is typically a symptom of some other misbehaviour occuring.
> > 
> > FWIW, for a workload intended to produce "inefficient write IO",
> > this is sort of behaviour is definitely indicating something
> > "inefficient" is occurring during write IO. So, in the end, there is
> > a definite possiblity that there may not actually be anything that
> > can be "fixed" here....
> 
> You're right, but having 45k kworker threads still looks questionable to me
> even with the inefficiency in mind.

The explosion of kworker threads is a result of scheduler behaviour.
It moves the writeback thread around because it is unbound and
frequently blocks, whilst other kernel tasks that are bound to a
specific CPU (like xfs-conv processing) takes scheduling priority.

It's not ideal behaviour in this particular corner case, but for a
stress test that is intended to create "inefficient IO patterns",
this is exactly the sort of behaviour it should be exercising.
Rmember, this is an artificial stress test....

-Dave.
-- 
Dave Chinner
david@fromorbit.com
