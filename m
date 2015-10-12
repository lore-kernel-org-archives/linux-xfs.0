Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id A44517F5F
	for <xfs@oss.sgi.com>; Mon, 12 Oct 2015 17:23:50 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 9374F304053
	for <xfs@oss.sgi.com>; Mon, 12 Oct 2015 15:23:50 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	UFUyrdbDEcECPWi7 for <xfs@oss.sgi.com>;
	Mon, 12 Oct 2015 15:23:14 -0700 (PDT)
Date: Tue, 13 Oct 2015 09:23:11 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Question about non asynchronous aio calls.
Message-ID: <20151012222311.GD31326@dastard>
References: <20151007141833.GB11716@scylladb.com>
	<56152B0F.2040809@sandeen.net>
	<20151007150833.GB30191@bfoster.bfoster>
	<56153685.3040401@sandeen.net> <561560B2.1080902@scylladb.com>
	<20151008042831.GU27164@dastard> <5615FD76.1090309@scylladb.com>
	<20151008082307.GE11716@scylladb.com>
	<20151008114622.GV27164@dastard> <561BA970.8080504@scylladb.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <561BA970.8080504@scylladb.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Avi Kivity <avi@scylladb.com>
Cc: Brian Foster <bfoster@redhat.com>, Eric Sandeen <sandeen@sandeen.net>, Gleb Natapov <gleb@scylladb.com>, xfs@oss.sgi.com

On Mon, Oct 12, 2015 at 03:37:04PM +0300, Avi Kivity wrote:
> On 10/08/2015 02:46 PM, Dave Chinner wrote:
> >On Thu, Oct 08, 2015 at 11:23:07AM +0300, Gleb Natapov wrote:
> >>On Thu, Oct 08, 2015 at 08:21:58AM +0300, Avi Kivity wrote:
> >>>>>>I fixed something similar in ext4 at the time, FWIW.
> >>>>>Makes sense.
> >>>>>
> >>>>>Is there a way to relax this for reads?
> >>>>The above mostly only applies to writes. Reads don't modify data so
> >>>>racing unaligned reads against other reads won't given unexpected
> >>>>results and so aren't serialised.
> >>>>
> >>>>i.e. serialisation will only occur when:
> >>>>	- unaligned write IO will serialise until sub-block zeroing
> >>>>	  is complete.
> >>>>	- write IO extending EOF will serialis until post-EOF
> >>>>	  zeroing is complete
> >>>
> >>>By "complete" here, do you mean that a call to truncate() returned, or that
> >>>its results reached the disk an unknown time later?
> >>>
> >No, I'm talking purely about DIO here. If you do write that
> >starts beyond the existing EOF, there is a region between the
> >current EOF and the offset the write starts at. i.e.
> >
> >    0             EOF            offset     new EOF
> >    +dddddddddddddd+..............+nnnnnnnnnnn+
> >
> >It is the region between EOF and offset that we must ensure is made
> >up of either holes, unwritten extents or fully zeroed blocks before
> >allowing the write to proceed. If we have to zero allocated blocks,
> >then we have to ensure that completes before the write can start.
> >This means that when we update the EOF on completion of the write,
> >we don't expose stale data in blocks that were between EOF and
> >offset...
> 
> Thanks.  We found, experimentally, that io_submit(write_at_eof)
> followed by (without waiting)
> io_submit(write_at_what_would_be_the_new_eof) occasionally blocks.

Yes, that matches up with needing to wait for IO completion to
update the inode size before submitting the next IO.

> So I guess we have to employ a train algorithm here and keep at most
> one aio in flight for append loads (which are very common for us).

Or use prealloc that extends the file and on staartup use and
algorithm that detects the end of data by looking for zeroed area
that hasn't been written.  SEEK_DATA/SEEK_HOLE can be used to do
this efficiently...

> >>I think Brian already answered that one with:
> >>
> >>   There are no such pitfalls as far as I'm aware. The entire AIO
> >>   submission synchronization sequence triggers off an in-memory i_size
> >>   check in xfs_file_aio_write_checks(). The in-memory i_size is updated in
> >>   the truncate path (xfs_setattr_size()) via truncate_setsize(), so at
> >>   that point the new size should be visible to subsequent AIO writers.
> >Different situation as truncate serialises all IO. Extending the file
> >via truncate also runs the same "EOF zeroing" that the DIO code runs
> >above, for the same reasons.
> 
> Does that mean that truncate() will wait for inflight aios, or that
> new aios will wait for the truncate() to complete, or both?

Both.

> >If you want to limit fragmentation without adding and overhead on
> >XFS for non-sparse files (which it sounds like your case), then the
> >best thing to use in XFS is the per-inode extent size hints. You set
> >it on the file when first creating it (or the parent directory so
> >all children inherit it at create), and then the allocator will
> >round out allocations to the size hint alignment and size, including
> >beyond EOF so appending writes can take advantage of it....
> 
> We'll try that out.  That's fsxattr::fsx_extsize?

*nod*

> What about small files that are eventually closed, do I need to do
> anything to reclaim the preallocated space?

Truncate to the current size (i.e. new size = old size) will remove
the extents beyond EOF, so will punching a hole from EOF for a
distance larger than the extent size hint.

> >>>A final point is discoverability.  There is no way to discover safe
> >>>alignment for reads and writes, and which operations block io_submit(),
> >>>except by asking here, which cannot be done at runtime.  Interfaces that
> >>>provide a way to query these attributes are very important to us.
> >>As Brian pointed statfs() can be use to get f_bsize which is defined as
> >>"optimal transfer block size".
> >Well, that's what posix calls it. It's not really the optimal IO
> >size, though, it's just the IO size that avoids page cache RMW
> >cycles. For direct IO, larger tends to be better, and IO aligned to
> >the underlying geometry of the storage is even better. See, for
> >example, the "largeio" mount option, which will make XFS report the
> >stripe width in f_bsize rather than the PAGE_SIZE of the machine....
> >
> 
> Well, random reads will still be faster with 512 byte alignment,
> yes?

Define "faster". :)

If you are talking about minimal latency, then an
individual IO will be marginally faster. If you are worried about
bulk throughput, then you storage will be IOPS bound (hence
destroying latency determinism) and it won't be faster by any metric
you care to measure because you'll end up with blocking in the
request queues during submission...

> and for random writes, you can't just make those I/Os larger,
> you'll overwrite something.
> 
> So I read "optimal" here to mean "smallest I/O size that doesn't
> incur a penalty; but if you really need more data, making it larger
> will help".

You hit the nail on the head. For an asynchornous IO engine like
you seem to be building, I'd be aiming for an IO size that maximises
the bulk throughput to/from the storage devices, rather than one
that aims for minimum latency on any one individiual IO. i.e. aim
for the minimum IO size that acheives >80% of the usable bandwidth
the storage device has...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
