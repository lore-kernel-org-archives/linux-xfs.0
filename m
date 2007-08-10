Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 10 Aug 2007 16:49:50 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l7ANnhbm017980
	for <xfs@oss.sgi.com>; Fri, 10 Aug 2007 16:49:46 -0700
Date: Sat, 11 Aug 2007 09:49:41 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: XFS thread inflation in 2.6.23rc
Message-ID: <20070810234940.GO12413810@sgi.com>
References: <200708081240.21548.ak@suse.de> <200708081422.10373.ak@suse.de> <20070808131404.GQ52011508@sgi.com> <200708081526.06860.ak@suse.de> <20070809110322.GA12413810@sgi.com> <46BCBDB2.6070703@sandeen.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46BCBDB2.6070703@sandeen.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: David Chinner <dgc@sgi.com>, Andi Kleen <ak@suse.de>, xfs@oss.sgi.com

On Fri, Aug 10, 2007 at 02:34:10PM -0500, Eric Sandeen wrote:
> David Chinner wrote:
> 
> > Andi, you are complaining to the wrong person about thread counts. I
> > live in the world of excessive parallelism and multithreaded I/O. I
> > regularly see 4-8p boxes running hundreds to thousands of I/O
> > threads on a single filesystem. These are the workloads XFS is
> > designed for and we optimise for. A single extra thread is noise....
> 
> 
> The other thing this is doing, though, is having an impact on power
> usage, I think.  Fedora is trying to identify things which wake the CPU
> in an effort to reduce power usage if possible.

Sure, but an idle thread doesn't use any power, and the workqueue
is now only used when there are streams active.

> and here are the results w/ xfs mounted:
> 
> < Detailed C-state information is only available on Mobile CPUs (laptops) >
> P-states (frequencies)
>   2.21 Ghz     0.0%
>   2.00 Ghz     0.0%
>   1.80 Ghz   100.0%
> Wakeups-from-idle per second : 31.7
> no ACPI power usage estimate available
> Top causes for wakeups:
>   37.0% ( 20.0)             mount : xfs_mru_cache_create

http://oss.sgi.com/archives/xfs/2007-08/msg00009.html

"On-demand reaping of the MRU cache

Instead of running the mru cache reaper all the time based on a
timeout, we should only run it when the cache has active objects.
This allows CPUs to sleep when there is no activity rather than
be woken repeatedly just to check if there is anything to do."

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
