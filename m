Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 25 Jul 2006 15:22:41 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k6PMM0DW019211
	for <xfs@oss.sgi.com>; Tue, 25 Jul 2006 15:22:12 -0700
Date: Wed, 26 Jul 2006 08:21:12 +1000
From: Nathan Scott <nathans@sgi.com>
Subject: Re: review: fix remount vs barrier options
Message-ID: <20060726082112.A2118045@wobbly.melbourne.sgi.com>
References: <20060721152807.D1998769@wobbly.melbourne.sgi.com> <20060723190650.GA22180@infradead.org> <20060724100147.F2083275@wobbly.melbourne.sgi.com> <20060724112737.D2085715@wobbly.melbourne.sgi.com> <20060725094438.GD29615@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20060725094438.GD29615@infradead.org>; from hch@infradead.org on Tue, Jul 25, 2006 at 10:44:38AM +0100
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com, jeremy@sgi.com

Hi Christoph,

On Tue, Jul 25, 2006 at 10:44:38AM +0100, Christoph Hellwig wrote:
> ...
> The flag clearing changes look good.  But why is it okay to skip the
> ordered flag on the first block?  We want to make sure all previous I/O
> is finished before even doing the first log block write, don't we?

No, thats not necessary - Tim and I looked into this at length - the
way the split log write happens, we keep a count in the iclog struct
for this write (its initially 2); once the first write completes (and
this is guaranteed to be before the final write by the final write's
barrier), we atomically decrement that counter.  Once it reaches zero
(i.e. only one buffer completion was remaining, which is also the non-
split log write case) only then will we do any callback processing,
metadata unpinning, etc, etc.

So, its a safe and valid optimisation - otherwise we do an extra write
with barrier whenever we wrap around the physical log end.

Thanks for the reviews!

cheers.

-- 
Nathan
