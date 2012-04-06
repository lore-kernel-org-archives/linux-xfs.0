Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q36NSdc1095206 for <xfs@oss.sgi.com>; Fri, 6 Apr 2012 18:28:40 -0500
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id z5z5wt7LjDs6q7VM
	for <xfs@oss.sgi.com>; Fri, 06 Apr 2012 16:28:38 -0700 (PDT)
Message-ID: <4F7F7C25.8040605@hardwarefreak.com>
Date: Fri, 06 Apr 2012 18:28:37 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: XFS: Abysmal write performance because of excessive seeking
	(allocation groups to blame?)
References: <CAAxjCEwBMbd0x7WQmFELM8JyFu6Kv_b+KDe3XFqJE6shfSAfyQ@mail.gmail.com>
	<20350.9643.379841.771496@tree.ty.sabi.co.UK>
	<20350.13616.901974.523140@tree.ty.sabi.co.UK>
	<CAAxjCEzkemiYin4KYZX62Ei6QLUFbgZESdwS8krBy0dSqOn6aA@mail.gmail.com>
In-Reply-To: <CAAxjCEzkemiYin4KYZX62Ei6QLUFbgZESdwS8krBy0dSqOn6aA@mail.gmail.com>
Reply-To: stan@hardwarefreak.com
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Stefan Ring <stefanrin@gmail.com>
Cc: Linux fs XFS <xfs@oss.sgi.com>

On 4/6/2012 2:27 AM, Stefan Ring wrote:
>> As to this, in theory even having split the files among 4 AGs,
>> the upload from system RAM to host adapter RAM and then to disk
>> could happen by writing first all the dirty blocks for one AG,
>> then a long seek to the next AG, and so on, and the additional
>> cost of 3 long seeks would be negligible.
> =

> Yes, that=92s exactly what I had in mind, and what prompted me to write
> this post. It would be about 10 times as fast. That=92s what bothers me
> so much.

XFS is still primarily a "lots and large" filesystem.  Its allocation
group based design is what facilitates this.  Very wide stripe arrays
have horrible performance for most workloads, especially random IOPS
heavy workloads, and you won't see hardware that will allow arrays of
hundreds, let alone dozens of spindles in a RAID stripe set.  Say one
needs a high IOPS single 50TB filesystem.  We could use 4 Nexsan E60
arrays each containing 60 15k SAS drives of 450GB each, 240 drives
total.  Creating four 60 drive RAID10 arrays, let alone 60 drive RAID6
arrays, would be silly.

Instead, a far more optimal solution would be to set aside 4 spares per
chassis and create 14 four drive RADI10 arrays.  This would yield ~600
seeks/sec and ~400MB/s sequential throughput performance per 2 spindle
array.  We'd stitch the resulting 56 hardware RAID10 arrays together in
an mdraid linear (concatenated) array.  Then we'd format this 112
effective spindle linear array with simply:

$ mkfs.xfs -d agcount=3D56 /dev/md0

Since each RAID10 is 900GB capacity, we have 56 AGs of just under the
1TB limit, 1 AG per 2 physical spindles.  Due to the 2 stripe spindle
nature of the constituent hardware RAID10 arrays, we don't need to worry
about aligning XFS writes to the RAID stripe width.  The hardware cache
will take care of filling the small stripes.  Now we're in the opposite
situation of having too many AGs per spindle.  We've put 2 spindles in a
single AG and turned the seek starvation issues on its head.

Given a workload with at least 56 threads, we can write 56 files in
parallel at ~400MB/s each, one to each AG, 22.4GB/s aggregate
throughput.  With this particular hardware, the 16x8Gb FC ports limit
total one way bandwidth to 12.8GB/s aggregate, or "only" 228MB/s per AG.
 Not too shabby.  But streaming bandwidth isn't the workload here.  This
setup will allow for ~30,000 random write IOPS with 56 writers. Not that
impressive compared to SSD, but you've got 50TB of space instead of a
few hundred gigs.

The moral of this story is this:  If XFS behaved the way you opine
above, each of these 56 AGs would be written in a serial fashion,
basically limiting the throughput of 112 effective 15k SAS spindles to
something along the lines of only ~400MB/s and ~600 random IOPS.  Note
that this hypothetical XFS storage system is tiny compared to some of
those in the wild.  NASA's Advanced Supercomputing Division alone has
deployed 500TB+ XFS filesystems on nested concatenated/striped arrays.

So while the XFS AG architecture may not be perfectly suited to your
single 6 drive RAID6 array, it still gives rather remarkable performance
given that the same architecture can scale pretty linearly to the
heights above, and far beyond.  Something EXTx and others could never
dream of.  Some of the SGI guys might be able to confirm deployed single
XFS filesystems spanning 1000+ drives in the past.  Today we'd probably
only see that scale with CXFS.

-- =

Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
