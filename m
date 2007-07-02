Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 02 Jul 2007 06:02:04 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l62D1xtL024696
	for <xfs@oss.sgi.com>; Mon, 2 Jul 2007 06:02:01 -0700
Date: Mon, 2 Jul 2007 23:01:50 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: After reboot fs with barrier faster deletes then fs with nobarrier
Message-ID: <20070702130150.GK989688@sgi.com>
References: <op.tuldjrzef7nho5@sunset.cpc.wmin.ac.uk> <20070629001648.GD31489@sgi.com> <op.tuomcyagf7nho5@project1.cpc.wmin.ac.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <op.tuomcyagf7nho5@project1.cpc.wmin.ac.uk>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Szabolcs Illes <S.Illes@westminster.ac.uk>
Cc: xfs@oss.sgi.com

On Fri, Jun 29, 2007 at 01:01:36PM +0100, Szabolcs Illes wrote:
> on my desktop pc:
> 
> WCE=1

hot-cache/cold cache nobarrier is faster. same results as I got.
After reboot, nobarrier is way slow.

> WCE=0

hot-cache/cold-cache is pretty much identical. Same results I got.
After reboot, nobarrier is way slow.

> for cold cache I used: echo 3 > /proc/sys/vm/drop_caches

Same here.

> it looks like this machine is only affected after reboot, maybe the hdd  
> has more cache, then the hdd in my 3 years old laptop.
> on my laptop it was enought to clear the kernel cache.
> 
> How did you do your "cold" tests? reboot or drop_caches?

drop_caches.

So there definitely appears to be something about a reboot that is
causing an issue here. I'll see if I can reproduce it here.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
