Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2EMmv6f004318 for <xfs@OSS.SGI.com>; Wed, 14 Mar 2012 17:48:57 -0500
Received: from woodbine.london.02.net (woodbine.london.02.net
	[87.194.255.145]) by cuda.sgi.com with ESMTP id
	WRc5dFEvJBa02wwv for <xfs@OSS.SGI.com>;
	Wed, 14 Mar 2012 15:48:55 -0700 (PDT)
Received: from ty.sabi.co.UK (87.194.99.40) by woodbine.london.02.net (8.5.140)
	id 4EEB6474058C3AD1 for xfs@OSS.SGI.com; Wed, 14 Mar 2012 22:48:52 +0000
Received: from from [127.0.0.1] (helo=tree.ty.sabi.co.UK)
	by ty.sabi.co.UK with esmtp(Exim 4.71 #1) id 1S7wzk-00032e-JY
	for <xfs@OSS.SGI.com>; Wed, 14 Mar 2012 22:48:36 +0000
MIME-Version: 1.0
Message-ID: <20321.8260.342121.730362@tree.ty.sabi.co.UK>
Date: Wed, 14 Mar 2012 22:48:36 +0000
Subject: Re: How to deal with XFS stripe geometry mismatch with hardware RAID5
In-Reply-To: <33504048.post@talk.nabble.com>
References: <33498437.post@talk.nabble.com>
	<4F605877.2030304@hardwarefreak.com>
	<33504048.post@talk.nabble.com>
From: pg_xf2@xf2.for.sabi.co.UK (Peter Grandi)
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
To: Linux fs XFS <xfs@oss.sgi.com>

>>>> I have a 30TB XFS filesystem created on CentOS 5.4 X86_64,
>>>> kernel 2.6.39, using xfsprogs 2.9.4. The underlying hardware
>>>> is 12 3TB SATA drives on a Dell PERC 700 controller with 1GB
>>>> cache. [ ... ]

>>>> [ ... ] set up the RAID BIOS to use a small stripe element
>>>> of 8KB per drive, [ ... ] The filesystem contains a MongoDB
>>>> installation consisting of roughly 13000 2GB files which are
>>>> already allocated. The application is almost exclusively
>>>> inserting data, there are no updates, and files are written
>>>> pretty much sequentially. [ ... ]

How many of the 13,000 are being written at roughly at the same
time? Because if you are logging 100K to each of them all the
time, that is a heavily random access workload. Each file may be
written sequentially, but the *disk* would be subject to a storm
of seeks.

>>>> When I set up the fstab entry I believed that it would
>>>> inherit the stripe geometry automatically, however now I
>>>> understand that is not the case with XFS version 2.

'mkfs.xfs' asks the kernel about drive geometry. If the kernel
could read it odd the PERC 700 it would have been fine. The
kernel can easily read geometry off MD etc. RAID sets because the
relevant info is already in the system state.

>>>> What I'm seeing now is average request sizes which are about
>>>> 100KB, half the stripe size.

But writes from what to what? From Linux to the PERC 700 cache or
from the PERC 700 cache to the RAID set drives?

>>>> With a typical write volume around 5MB per second I am
>>>> getting wait times around 50ms, which appears to be
>>>> degrading performance. [ ... ]

5MB per second in aggregate is hardly worth worrying about.
What do the 50ms mean as wait times? Again, it matters a great
deal whether it is Linux->PERC or PERC->drives.

If you have barriers enabled, and the MongoDB is 'fsync'ing every
100K, then 100K will be the transaction size.

Also, with a 100K append size, and 5MB/s aggregate, you are doing
50 transactions/s and it matters a great deal whether all are to
the same file, sequentially, or each is to a different file, etc.

>>>> [ ... ] Is there a danger of filesystem corruption if I give
>>>> fstab a mount geometry that doesn't match the values used at
>>>> filesystem creation time?

No, those values are purely advisory.

>>>> I'm unclear on the role of the RAID hardware cache in
>>>> this. Since the writes are sequential, and since the volume
>>>> of data written is such that it would take about 3 minutes
>>>> to actually fill the RAID cache, I would think the data
>>>> would be resident in the cache long enough to assemble a
>>>> full-width stripe at the hardware level and avoid the 4 I/O
>>>> RAID5 penalty.

Sure, if the cache is configured right and barriers are not
invoked every 100KiB.

[ ... ]

> Mongo pre-allocates its datafiles and zero-fills them (there is
> a short header at the start of each, not rewritten as far as I
> know) and then writes to them sequentially, wrapping around
> when it hits the end.

Preallocating is good.

> In this case the entire load is inserts, no updates, hence the
> sequential writes.

So it is not random access, if it is a log-like operation. If it
is a lot of 100K appends, things look a lot better.

> [ ... ] The BBU is functioning and the cache is set to
> write-back.

That's good, check whether XFS has barriers enabled, and it might
help to make sure that the host adapter really knows the geometry
of the RAID set and if there is a parameter as to how much
unwritten data to buffer, to set is high, to maximize the chances
that it will do like it should and issue whole-stripe writes.

> [ ... ] Flushing is done about every 30 seconds and takes
> about 8 seconds.

I usually prefer nearly continuous flushing (and the Linux level
too and in particular), in part to avoid the 8s pauses. Even if
that defeats in part the XFS delayed allocation logic.

However there is a contradiction here between seeing 100K
transactions and flushing taking 8s times a write rate of 5MB/s,
every 30s. The latter would imply 40MB of writes every 30s.

> One thing I'm wondering is whether the incorrect stripe
> structure I specified with mkfs

Probably the incorrect stripe structure here is mostly not
that important, there are bigger factors at play.

> is actually written into the file system structure or
> effectively just a hint to the kernel for what to use for a
> write size.

The stripe parameters have static and dynamic effects:

  static
    - The metadata allocator attempts to interleave metadata at
      chunk ('sunit') boundaries to parallelize access.
    - The data allocator attempts to allocate extents on stripe
      ('swidth') aligned boundaries to maximize the chances of
      doing stripe aligned IO.
    These allocations are aligned according to the stripe
    parameters current when the metadata and data extents were
    allocated.
 
  dynamic
    - The block IO bottom end attempts to generate bulk IO
      requests aligned on stripe boundaries.
    These requests are aligned according to the stripe
    parameters current at the moment the IO occurs. The metadata
    and data extents may well have been allocated with alignment
    different from that on which IO requests are aligned.

> If not, could I specify the correct stripe width in the mount
> options and override the incorrect width used by mkfs?

Sure, but the space already allocated is already on the "wrong"
boundaries, even if XFS supposedly will try to issue IOs on the
as-mounted stripe alignment.

> Since the current average write size is only about half the
> specified stripe size, and since I'm not using md or xfs v.3
> it seems the kernel is ignoring it for now.

All the kernel does is to upload a bunch of blocks to the PERC,
and all the RAID optimization is done by the PERC.

> The choice of RAID5 was a compromise due to the need to store
> 30TB of data on each of 2 systems (a master and a replicated
> slave) - we couldn't afford that much space on our SAN for this
> application, but we could afford a 12-bay system with 3TB SATA
> drives.

Still an 11+1 RAID5 is a bravce option to take.

> My hope was that since the write pattern was expected to be
> large sequential writes with no updates that the RAID5 penalty
> would not be significant.

That was a reasonable hope, but 11+1 RAID5 has other downsides.

> And it's quite possible that would be the case if I had got the
> stripe width right.

Uh, I suspect that stripe alignment here is not that important.
That 50ms after 100k sounds much much worse than RMW. On 15k
drives 50ms are about 4-6 seek times, which is way more than RMW
would take.

> The 8K element size was chosen because the actual average
> request size I was seeing on previous installations of the
> database was around 60K, which is still smaller than the stripe
> width over 12 drives even using 8K.

That is not necessarily the right logic, but for bulk sequential
transfers a small chunk size is a good idea, in general other
things equal the smaller the chunk and the stripe size the better.

> I did try btrfs early on to take advantage of compression, but
> it failed. This was about six months ago, though.

"failed" sounds a bit strange, and note that BTRFS has much
larger overheads than other filesystems. But your applications
seems ideal for XFS. Instead of using some weird kernel like
2.6.39 with EL5, you might want to try an "official" EL5 kernel
like the Oracle 2.6.32 one, or switch to EL6/CentOS6.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
