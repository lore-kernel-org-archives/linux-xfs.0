Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oAT09fgI068040 for <xfs@oss.sgi.com>; Sun, 28 Nov 2010 18:09:41 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3AAF81ACAEB
	for <xfs@oss.sgi.com>; Sun, 28 Nov 2010 16:11:20 -0800 (PST)
Received: from mail.internode.on.net (bld-mail17.adl2.internode.on.net
	[150.101.137.102]) by cuda.sgi.com with ESMTP id
	UUqCxsDLbP5uzlwG for <xfs@oss.sgi.com>;
	Sun, 28 Nov 2010 16:11:20 -0800 (PST)
Date: Mon, 29 Nov 2010 11:11:12 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS: performance
Message-ID: <20101129001112.GA28672@dastard>
References: <AANLkTi=u8dX0ehPN3Rv3FQ+84htY3AYEv0eboGgC7_qi@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <AANLkTi=u8dX0ehPN3Rv3FQ+84htY3AYEv0eboGgC7_qi@mail.gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Yclept Nemo <orbisvicis@gmail.com>
Cc: xfs@oss.sgi.com

On Sun, Nov 28, 2010 at 10:51:04PM +0000, Yclept Nemo wrote:
> After 3-4 years of using one XFS partition for every mount point
> (/,/usr,/etc,/home,/tmp...) I started noticing a rapid performance
> degradation. Subjectively I now feel my XFS partition is 5-10x slower
> ... while other partitions (ntfs,ext3) remain the same.

Can you run some benchmarks to show this non-subjectively? Aged
filesystems will be slower than new filesytsems, and it should be
measurable. Also, knowing what you filesystem contains (number of
files, used capacity, whether you have run it near ENOSPC for
extended periods of time, etc) would help us understand the way the
filesytesm has aged as well.

> Now I just purchased a new hard-drive and I'm going to be copying all
> my original files over onto a *new* XFS partition. When using mkfs.xfs
> I'd like to optimize and avoid whatever it was that made my old XFS
> partition slower than a snail.

Nobody can give definite advice without first quantifying and then
understanding the aging slowdown you've been seeing.

....

> I was considering running "mkfs.xfs -d agcount=32 -i attr=2 -l
> version=2,lazy-count=1,size=256m /dev/sda5".
> 
> Yes, I know that in xfs_progs 3.1.3 "-i attr=2 -l
> version=2,lazy-count=1" are already default options. However I think I
> should tweak the log size, blocksize, and data allocation group counts
> beyond the default values and I'm looking for some recommendations or
> input.

Why do you think you should tweak them?

> I assume mkfs.xfs automatically selects optimal values, but I *have*
> space to spare for a larger log section... and perhaps my old XFS
> partition became sluggish when the log section had filled up, if this
> is even possible.

Well, you had a very small log (20MB) on the original filesystem,
and so as the filesystems ages (e.g. free space fragments), each
allocation/free transaction would be larger than on a new filesytsem
because of the larger btrees that need to be manipulated. With such
a small log, that could be part of the reason for the slowdown you
were seeing.  However, without knowing what you filesystem looks
like physically, this is only speculation.

That being said, the larger log (50MB) that the new filesystem has
shouldn't have the same degree of degradation under the same aging
characteristics. It's probably not necesary to go larger than ~100MB
for partition of 100GB on a single spindle...

> Similarly a larger agcount should always give better performance,
> right?

No.

> Some resources claim that agcount should never fall below
> eight.

If those resources are right, then why would we default to 4 AGs for
filesystems on single spindles?

> I'm also hesitant about reducing the blocksize from a maximum of 4096
> bytes, but since XFS manages my entire file-system tree, a blocksize
> of 512, 1024,or even 2048 bytes might squeeze out some extra
> performance. [I assume] the performance w.r.t. blocksize is:
>  . a larger blocksize dramatically increases large file performance,

No, it doesn't - maybe a few percent difference when you've got
multiple GB/s throughput, but it's mostly noise for single spindles.
Extent based allocation makes block size  pretty much irrelevant for
sequential write performance...

> but also increases space usage when dealing with small files.

Not significantly enough to matter for modern disks.

> . a smaller blocksize dramatically decreases performance for large
> files,

See above.

> and somewhat increases performance for small files,

Not really.

> while also
> slightly increasing space usage with extra inodes(?)

????

> I want to make it clear that I prefer performance over space efficiency.

That's what the defaults are biased towards.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
