Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0VAVU6M240346 for <xfs@oss.sgi.com>; Tue, 31 Jan 2012 04:31:31 -0600
Received: from smtp.pobox.com (b-pb-sasl-quonix.pobox.com [208.72.237.35]) by
	cuda.sgi.com with ESMTP id ZGpOsl86I1s56eed for
	<xfs@oss.sgi.com>; Tue, 31 Jan 2012 02:31:29 -0800 (PST)
Date: Tue, 31 Jan 2012 10:31:26 +0000
From: Brian Candler <B.Candler@pobox.com>
Subject: Re: Performance problem - reads slower than writes
Message-ID: <20120131103126.GA46170@nsrc.org>
References: <20120130220019.GA45782@nsrc.org> <20120131020508.GF9090@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120131020508.GF9090@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Tue, Jan 31, 2012 at 01:05:08PM +1100, Dave Chinner wrote:
> When you working set is
> larger than memory (which is definitely true here), read performance
> will almost always be determined by read IO latency.

Absolutely.

> > There are about 270 disk operations per second seen at the time, so
> > the drive is clearly saturated with seeks.  It seems to be doing about 7
> > seeks for each stat+read. 
> 
> It's actually reading bits of the files, too, as your strace shows,
> which is where most of the IO comes from.

It's reading the entire files - I had grepped out the read(...) = 8192
lines so that the stat/open/read/close pattern could be seen.

> The big question is whether this bonnie++ workload reflects your
> real workload?

Yes it does. The particular application I'm tuning for includes a library of
some 20M files in the 500-800K size range.  The library is semi-static, i.e. 
occasionally appended to.  Some clients will be reading individual files at
random, but from time to time we will need to scan across the whole library
and process all the files or a large subset of it.

> you need to optimise your storage
> architecture for minimising read latency, not write speed. That
> means either lots of spindles, or high RPM drives or SSDs or some
> combination of all three. There's nothing the filesystem can really
> do to make it any faster than it already is...

I will end up distributing the library across multiple spindles using
something like Gluster, but first I want to tune the performance on a single
filesystem.

It seems to me that reading a file should consist roughly of:

- seek to inode (if the inode block isn't already in cache)
- seek to extents table (if all extents don't fit in the inode)
- seek(s) to the file contents, depending on how they're fragmented.

I am currently seeing somewhere between 7 and 8 seeks per file read, and
this just doesn't seem right to me.

One thing I can test directly is whether the files are fragmented, using
xfs_bmap, and this shows they clearly are not:

root@storage1:~# xfs_bmap /data/sdc/Bonnie.16388/00449/*
/data/sdc/Bonnie.16388/00449/000000b125QaaLg:
        0: [0..1167]: 2952872392..2952873559
/data/sdc/Bonnie.16388/00449/000000b126:
        0: [0..1087]: 4415131112..4415132199
/data/sdc/Bonnie.16388/00449/000000b1272Mfp:
        0: [0..1255]: 1484828464..1484829719
/data/sdc/Bonnie.16388/00449/000000b128sEYN5:
        0: [0..1319]: 2952873560..2952874879
/data/sdc/Bonnie.16388/00449/000000b129Zs:
        0: [0..1591]: 4415132200..4415133791
/data/sdc/Bonnie.16388/00449/000000b12aIaa3UV:
        0: [0..1527]: 1484829720..1484831247
/data/sdc/Bonnie.16388/00449/000000b12b:
        0: [0..1287]: 2952874880..2952876167
/data/sdc/Bonnie.16388/00449/000000b12c3ze1zN5FfX1i:
        0: [0..1463]: 4415133792..4415135255
... snip rest

So the next thing I'd have to do is to try to get a trace of the I/O
operations being performed, and I don't know how to do that.

> > The filesystem was created like this:
> > 
> > # mkfs.xfs -i attr=2,maxpct=1 /dev/sdb
> 
> attr=2 is the default, and maxpct is a soft limit so the only reason
> you would have to change it is if you need more indoes in teh
> filesystem than it can support by default. Indeed, that's somewhere
> around 200 million inodes per TB of disk space...

OK. I saw "df -i" reporting a stupid number of available inodes, over 500
million, so I decided to reduce it to 100 million.  But df -k didn't show
any corresponding increase in disk space, so I'm guessing in xfs these are
allocated on-demand, and the inode limit doesn't really matter?

> > P.S. When dd'ing large files ontp XFS I found that bs=8k gave a lower
> > performance than bs=16k or larger.  So I wanted to rerun bonnie++ with
> > larger chunk sizes.  Unfortunately that causes it to crash (and fairly
> > consistently) - see below.
> 
> No surprise - twice as many syscalls, twice the overhead.

I'm not sure that simple explanation works here. I see almost exactly the
same performance with bs=512m down bs=32k, slightly worse at bs=16k, and a
sudden degradation at bs=8k.  However the CPU is still massively
underutilised at that point.

root@storage1:~# time dd iflag=direct if=/dev/sdg of=/dev/null bs=1024k count=1024
1024+0 records in
1024+0 records out
1073741824 bytes (1.1 GB) copied, 7.91832 s, 136 MB/s

real	0m7.950s
user	0m0.000s
sys	0m0.100s

root@storage1:~# time dd iflag=direct if=/dev/sdg of=/dev/null bs=32k count=32768
32768+0 records in
32768+0 records out
1073741824 bytes (1.1 GB) copied, 7.92206 s, 136 MB/s

real	0m7.963s
user	0m0.004s
sys	0m0.420s

root@storage1:~# time dd iflag=direct if=/dev/sdg of=/dev/null bs=16k count=65536
65536+0 records in
65536+0 records out
1073741824 bytes (1.1 GB) copied, 8.48255 s, 127 MB/s

real	0m8.496s
user	0m0.096s
sys	0m0.644s

root@storage1:~# time dd iflag=direct if=/dev/sdg of=/dev/null bs=8k count=131072
131072+0 records in
131072+0 records out
1073741824 bytes (1.1 GB) copied, 13.8283 s, 77.6 MB/s

real	0m13.829s
user	0m0.084s
sys	0m1.328s

Also: I can run the same dd on twelve separate drives concurrently, and get
the same results. This is a two-core (+hyperthreading) processor, but if
syscall overhead really were the limiting factor I would expect doing it
twelve times in parallel would amplify the effect.

My suspicion is that some other factor is coming into play - read-ahead on
the drives perhaps - but I haven't nailed it down yet.

Regards,

Brian.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
