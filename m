Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 14 Oct 2007 16:19:37 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id l9ENJQdJ026190
	for <xfs@oss.sgi.com>; Sun, 14 Oct 2007 16:19:28 -0700
Date: Mon, 15 Oct 2007 09:19:23 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: XFS regression?
Message-ID: <20071014231923.GP23367404@sgi.com>
References: <20071010152742.1b2a7bce@zeus.pccl.info> <20071011010139.GT995458@sgi.com> <20071011151512.69f19419@zeus.pccl.info> <20071011215352.GX995458@sgi.com> <20071012002613.GL23367404@sgi.com> <20071012123601.291fee8a@zeus.pccl.info>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071012123601.291fee8a@zeus.pccl.info>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Andrew Clayton <andrew@digital-domain.net>
Cc: David Chinner <dgc@sgi.com>, linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com

On Fri, Oct 12, 2007 at 12:36:01PM +0100, Andrew Clayton wrote:
> On Fri, 12 Oct 2007 10:26:13 +1000, David Chinner wrote:
>  
> > You can breath again. Here's a test patch (warning - may harm
> 
> heh
> 
> > kittens - not fully tested or verified) that solves both
> > the use-after-free issue (by avoiding it altogether) as well the
> > unlink/create latency because the log force is no longer there.
> > 
> > (yay! xfsqa test 016 passes again ;)
> > 
> > It does have other possible side effects triggering extra
> > log forces elsewhere on inode writeback and affects sync behaviour
> > so it's only a proof of concept at this point.
> 
> What kernel is that against?. I got rejects with 2.6.23 

The xfs-dev tree - i.e. the XFS that will be in 2.6.25 ;)

> However I tried a 2.6.18 on the file server and ran my test, it didn't
> show the problem. I then made a 2.6.23 but with the patch from my git
> bisect reverted.
> 
> Doing the test with that kernel, while writing a 1GB file I saw only
> one > 1 second latency (1.2) and only a few ~ 0.5 second latencies.
> 
> However over the longer term I'm still seeing latencies > 1 second.

Sure - you've got a busy disk. If the truncate has to flush the log
and wait for space, then it's going to take some time for I/Os
to complete. Full queue + busy disk == unpredictable latency for all
operations.

> Just leaving my strace test running (no dd) on the raid filesystem I see
> the
> latencies come when the raid5 stripe cache fills up. So I think I'm
> perhaps seeing another problem here.

Software raid isn't good for latency, either ;)

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
