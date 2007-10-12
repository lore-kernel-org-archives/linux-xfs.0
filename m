Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 12 Oct 2007 09:44:43 -0700 (PDT)
Received: from smtp.aaisp.net.uk (smtp.aaisp.net.uk [81.187.81.51])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id l9CGiRFD000597
	for <xfs@oss.sgi.com>; Fri, 12 Oct 2007 09:44:28 -0700
Date: Fri, 12 Oct 2007 12:36:01 +0100
From: Andrew Clayton <andrew@digital-domain.net>
Subject: Re: XFS regression?
Message-ID: <20071012123601.291fee8a@zeus.pccl.info>
In-Reply-To: <20071012002613.GL23367404@sgi.com>
References: <20071010152742.1b2a7bce@zeus.pccl.info>
	<20071011010139.GT995458@sgi.com>
	<20071011151512.69f19419@zeus.pccl.info>
	<20071011215352.GX995458@sgi.com>
	<20071012002613.GL23367404@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com

On Fri, 12 Oct 2007 10:26:13 +1000, David Chinner wrote:
 
> You can breath again. Here's a test patch (warning - may harm

heh

> kittens - not fully tested or verified) that solves both
> the use-after-free issue (by avoiding it altogether) as well the
> unlink/create latency because the log force is no longer there.
> 
> (yay! xfsqa test 016 passes again ;)
> 
> It does have other possible side effects triggering extra
> log forces elsewhere on inode writeback and affects sync behaviour
> so it's only a proof of concept at this point.

What kernel is that against?. I got rejects with 2.6.23 

However I tried a 2.6.18 on the file server and ran my test, it didn't
show the problem. I then made a 2.6.23 but with the patch from my git
bisect reverted.

Doing the test with that kernel, while writing a 1GB file I saw only
one > 1 second latency (1.2) and only a few ~ 0.5 second latencies.

However over the longer term I'm still seeing latencies > 1 second.
Just leaving my strace test running (no dd) on the raid filesystem I see
the
latencies come when the raid5 stripe cache fills up. So I think I'm
perhaps seeing another problem here.

Running the strace (again no dd) on the system disk (not raided) I'm not
seeing any latencies.

In fact the latencies on the raid array seem to be generally greater
than the system disk (all identical disks, all XFS).

raid array

open("test", O_WRONLY|O_CREAT|O_EXCL|O_TRUNC, 0600) = 3 <0.122943>
open("test", O_WRONLY|O_CREAT|O_EXCL|O_TRUNC, 0600) = 3 <0.021620>
open("test", O_WRONLY|O_CREAT|O_EXCL|O_TRUNC, 0600) = 3 <0.014963>
open("test", O_WRONLY|O_CREAT|O_EXCL|O_TRUNC, 0600) = 3 <0.023264>
open("test", O_WRONLY|O_CREAT|O_EXCL|O_TRUNC, 0600) = 3 <0.011368>
open("test", O_WRONLY|O_CREAT|O_EXCL|O_TRUNC, 0600) = 3 <0.002561>
open("test", O_WRONLY|O_CREAT|O_EXCL|O_TRUNC, 0600) = 3 <0.012623>

system disk

open("test", O_WRONLY|O_CREAT|O_EXCL|O_TRUNC, 0600) = 3 <0.000190>
open("test", O_WRONLY|O_CREAT|O_EXCL|O_TRUNC, 0600) = 3 <0.000039>
open("test", O_WRONLY|O_CREAT|O_EXCL|O_TRUNC, 0600) = 3 <0.000191>
open("test", O_WRONLY|O_CREAT|O_EXCL|O_TRUNC, 0600) = 3 <0.000268>
open("test", O_WRONLY|O_CREAT|O_EXCL|O_TRUNC, 0600) = 3 <0.000188>
open("test", O_WRONLY|O_CREAT|O_EXCL|O_TRUNC, 0600) = 3 <0.000233>
open("test", O_WRONLY|O_CREAT|O_EXCL|O_TRUNC, 0600) = 3 <0.000279>


Maybe that's to be expected?

> Cheers,
> 
> Dave.

Thanks for looking at this.

Andrew
