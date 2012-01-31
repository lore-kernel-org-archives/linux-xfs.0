Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0VK6eXr098410 for <xfs@oss.sgi.com>; Tue, 31 Jan 2012 14:06:40 -0600
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	dTbsWY0KhpWwzxyM for <xfs@oss.sgi.com>;
	Tue, 31 Jan 2012 12:06:38 -0800 (PST)
Date: Wed, 1 Feb 2012 07:06:35 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Performance problem - reads slower than writes
Message-ID: <20120131200635.GI9090@dastard>
References: <20120130220019.GA45782@nsrc.org> <20120131020508.GF9090@dastard>
	<20120131103126.GA46170@nsrc.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120131103126.GA46170@nsrc.org>
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
To: Brian Candler <B.Candler@pobox.com>
Cc: xfs@oss.sgi.com

On Tue, Jan 31, 2012 at 10:31:26AM +0000, Brian Candler wrote:
> On Tue, Jan 31, 2012 at 01:05:08PM +1100, Dave Chinner wrote:
> > When you working set is
> > larger than memory (which is definitely true here), read performance
> > will almost always be determined by read IO latency.
> 
> Absolutely.
> 
> > > There are about 270 disk operations per second seen at the time, so
> > > the drive is clearly saturated with seeks.  It seems to be doing about 7
> > > seeks for each stat+read. 
> > 
> > It's actually reading bits of the files, too, as your strace shows,
> > which is where most of the IO comes from.
> 
> It's reading the entire files - I had grepped out the read(...) = 8192
> lines so that the stat/open/read/close pattern could be seen.
> 
> > The big question is whether this bonnie++ workload reflects your
> > real workload?
> 
> Yes it does. The particular application I'm tuning for includes a library of
> some 20M files in the 500-800K size range.  The library is semi-static, i.e. 
> occasionally appended to.  Some clients will be reading individual files at
> random, but from time to time we will need to scan across the whole library
> and process all the files or a large subset of it.
> 
> > you need to optimise your storage
> > architecture for minimising read latency, not write speed. That
> > means either lots of spindles, or high RPM drives or SSDs or some
> > combination of all three. There's nothing the filesystem can really
> > do to make it any faster than it already is...
> 
> I will end up distributing the library across multiple spindles using
> something like Gluster, but first I want to tune the performance on a single
> filesystem.
> 
> It seems to me that reading a file should consist roughly of:
> 
> - seek to inode (if the inode block isn't already in cache)
> - seek to extents table (if all extents don't fit in the inode)
> - seek(s) to the file contents, depending on how they're fragmented.

You forgot the directory IO. If you've got enough entries in the
directory to push it out to leaf/node format, then it could
certainly take 3-4 IOs just to find the directory entry you are
looking for.

> I am currently seeing somewhere between 7 and 8 seeks per file read, and
> this just doesn't seem right to me.

The number of IOs does not equal the number of seeks. Two adjacent,
sequential IOs issued serially will show up as two IOs, even though
there was no seek in between. Especially if the files are large
enough that readahead tops out (500-800k is large enough for this as
readahead maximum is 128k by default).  So it might be taking 3-4
IOs just to read the file data.

> So the next thing I'd have to do is to try to get a trace of the I/O
> operations being performed, and I don't know how to do that.

blktrace/blkparse or seekwatcher.

> > > The filesystem was created like this:
> > > 
> > > # mkfs.xfs -i attr=2,maxpct=1 /dev/sdb
> > 
> > attr=2 is the default, and maxpct is a soft limit so the only reason
> > you would have to change it is if you need more indoes in teh
> > filesystem than it can support by default. Indeed, that's somewhere
> > around 200 million inodes per TB of disk space...
> 
> OK. I saw "df -i" reporting a stupid number of available inodes, over 500
> million, so I decided to reduce it to 100 million.  But df -k didn't show
> any corresponding increase in disk space, so I'm guessing in xfs these are
> allocated on-demand, and the inode limit doesn't really matter?

Right. The "available inodes" number is calculated based on the
current amount of free space, IIRC. It's dynamic, and mostly
meaningless.

> > > P.S. When dd'ing large files ontp XFS I found that bs=8k gave a lower
> > > performance than bs=16k or larger.  So I wanted to rerun bonnie++ with
> > > larger chunk sizes.  Unfortunately that causes it to crash (and fairly
> > > consistently) - see below.
> > 
> > No surprise - twice as many syscalls, twice the overhead.
> 
> I'm not sure that simple explanation works here. I see almost exactly the
> same performance with bs=512m down bs=32k, slightly worse at bs=16k, and a
> sudden degradation at bs=8k.  However the CPU is still massively
> underutilised at that point.
>
> root@storage1:~# time dd iflag=direct if=/dev/sdg of=/dev/null bs=1024k count=1024
                           ^^^^^^^^^^^^

Direct IO is different to buffered IO, which is what bonnie++ does.
For direct IO, the IO size that hits th disk is exactly the bs
value, and you con only have one IO per thread outstanding. All you
are showing is that your disk cache readahead is not magic.


Indeed, look at the system time:

> sys	0m0.100s
> 
> root@storage1:~# time dd iflag=direct if=/dev/sdg of=/dev/null bs=32k count=32768
.....
> sys	0m0.420s
> 
> root@storage1:~# time dd iflag=direct if=/dev/sdg of=/dev/null bs=16k count=65536
.....
> sys	0m0.644s
> 
> root@storage1:~# time dd iflag=direct if=/dev/sdg of=/dev/null bs=8k count=131072
....
> sys	0m1.328s

It scales roughly linearly with the number of IOs that are done.
This means there is more CPU time spent to retreive a given amount
of data, and that time is not being spent doing IO. Put simply, this
is slower:

    Fixed CPU time to issue 8K IO
    IO time
    Fixed CPU time to issue 8K IO
    IO time
    Fixed CPU time to issue 8K IO
    IO time
    Fixed CPU time to issue 8K IO
    IO time

than:

    Fixed CPU time to issue 32K IO
    IO time

because of the CPU time spent between IOs, and the difference in IO
time between an 8k read and a 32k read is only about 5%.

> Also: I can run the same dd on twelve separate drives concurrently, and get
> the same results. This is a two-core (+hyperthreading) processor, but if
> syscall overhead really were the limiting factor I would expect doing it
> twelve times in parallel would amplify the effect.

It's single thread latency that is your limiting factor. All you've
done is demonstrate that threads don't interfere with each other.

> My suspicion is that some other factor is coming into play - read-ahead on
> the drives perhaps - but I haven't nailed it down yet.

It's simply that the amount of CPU spent in syscalls doing IO is
the performance limiting factor for a single thread.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
