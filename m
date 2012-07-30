Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6U33odn240454 for <xfs@oss.sgi.com>; Sun, 29 Jul 2012 22:03:50 -0500
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	p8L5E76SmBSZ3Mfn for <xfs@oss.sgi.com>;
	Sun, 29 Jul 2012 20:03:47 -0700 (PDT)
Date: Mon, 30 Jul 2012 13:03:33 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: realtime section bugs still around
Message-ID: <20120730030333.GE2877@dastard>
References: <CAGou9MgezsS=2+SngGWBJv5Npsuqacx1VPJwvMuf0FS+XnXt8A@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAGou9MgezsS=2+SngGWBJv5Npsuqacx1VPJwvMuf0FS+XnXt8A@mail.gmail.com>
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
To: Jason Newton <nevion@gmail.com>
Cc: xfs@oss.sgi.com

On Fri, Jul 27, 2012 at 01:14:17AM -0700, Jason Newton wrote:
> Hi,
> 
> I think the following bug is still around:
> 
> http://oss.sgi.com/archives/xfs/2011-11/msg00179.html
> 
> I get the same stack trace.

Not surprising, I doubt anyone has looked at it much. Indeed,
xfs/090 assert fails immediately in the rt allocator for me....

> There's another report out there somewhere
> with another similar stack trace.  I know the realtime code is not
> maintained so much but it seems to be a waste to let it fall out of
> maintenance when it's the only thing on linux that seems to fill the
> realtime io niche.

The XFS "realtime" device has nothing to do with "realtime IO".

If anything, it's probably much worse at "realtime IO" than the
normal data device, especially at scale, because it is bitmap rather
than btree based. And it is single threaded.

That's why it really isn't maintained - the data device is as good
or better in RT workloads as the "realtime" device....

> So this email is mainly about the null pointer deref on the spinlock in
> _xfs_buf_find on realtime files, but I figure I might also ask a few more
> questions.
> 
> What kind of differences should one expect between GRIO and realtime files?

Linux doesn't support GRIO. It's an Irix only thing, and that
required special hardware support for bandwidth reservation, special
frame schedulers in the IO path, etc. The XFS realtime device was
just one part of the whole GRIO framework. Anyway, if you don't have
15 year old SGI hardware you can't use GRIO.

If you are talking about GRIOv2, then, well, you aren't running
CXFS...

> What kind of on latencies of writes should one expect for realtime files vs
> normal?

How long is a piece of string?

> raw video to disk (3 high res 10bit video streams, 5.7MB per frame, at 20hz
> so effectively 60fps total).   I use 2 512GB OCZ vertex 4 SSDs which
> support ~450MB/s each.  I've soft-raided them together (raid 0) with a 4k
> chunksize

There's your first problem. You are storing 5.7MB files, so why
would you use a 4k chunk size? You'd do better with something on the
order of 1MB chunk size (2MB stripe width) so that you are forming
as large IOs as possible with the minimum of software overhead (i.e
no merging of 4k IOs into larger IOs in the IO scheduler).

Note that you are also writing hundreds of GB to the SSDs, which
will be triggering internal garbage collection, and that will have
significant impact on Io completion latency. It's not uncommon to
see 500ms IO latencies occur on consumer level SSDs when garbage
collect kicks in. If you are going to use SATA SSDs, then you're
going to have to design your application to be able to handle such
write latencies...

> and I get about 900MB/s avg in a benchmark program I wrote to
> simulate my videostream logging needs.  I only save one file per
> videostream (only 1 videostream modeled in simulation), which I append to
> in a loop with a single write call, which records the frame, over and over
> while keeping track of timing.

The typical format for high bandwidth video stream is file per
frame. That's exactly what the filestreams allocator is designed for
- ingest of multiple streams and keeping them in separate locations
(AGs) on disk. This means allocation remains concurrent and doesn't
serialise, causing excess, unpredicatble latencies.

Indeed, if you use file per frame, and a RAID0 chunk size of 3MB
(6MB stripe width), then XFs will align the data in each file to the
same stripe unit boundary for all files. There will be 300kb of free
space between them, but having everything nicely aligned to the
underlying geometry tends to help maintain allocation determinism
until the filesystem is 5.7/6 * 100% = 95% full.....

> The frame is in memory and nonzero with
> some interesting pattern to defeat compression if its in the pipeline
> anywhere.  I get 180-300MB/s with O_DIRECT, so better performance without
> O_DIRECT (maybe because it's soft-raid?).

It sounds like you are using in line write(2) calls, which means the
IO is synchronous (i.e. occurs within the write syscall), which
means throughput is bound by IO completion latency. AIO+DIO solves
this problem as it implies application level frame buffering - this
is a common way of ensuring that IO latencies don't cause dropped
frames

Using buffered IO means the write(2) operates at memory speed, but
you then have no control over allocation and writeback, and memory
allocation and reclaim becomes a major source of latency that direct
IO does not have. Doing buffered IO to the realtime device is, well,
even less well tested than the realtime device, as historically the
RT device only supported direct IO. It's supposed to work, but it's
never really been well tested, and I don't know anyone who uses it
in production....

> The problem is that I
> occationally get hickups in latency... there's nothing else using the disk
> (embedded system, no other pid's running + root is RO).  I use the deadline
> io scheduler on both my SSDs.

Yep, that'll be because you are using buffered IO. It'll be faster
than a naive Direct IO implementation, but you'll have latency
issues that cannot be avoided or predicted.

> xfs_info of my video raid:
> meta-data=/dev/md2               isize=256    agcount=32, agsize=7380047

Lots of little AGs - that will stress the freespace management of
the filesystem pretty quickly.....

> blks
>          =                       sectsz=512   attr=2
> data     =                       bsize=4096   blocks=236161504, imaxpct=25
>          =                       sunit=1      swidth=2 blks
> naming   =version 2              bsize=4096   ascii-ci=0
> log      =internal               bsize=4096   blocks=115313, version=2
>          =                       sectsz=512   sunit=1 blks, lazy-count=1
> realtime =none                   extsz=4096   blocks=0, rtextents=0

And no realtime device. It doesn't look like you're testing what you
think you are testing....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
