Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 7C8CB7F37
	for <xfs@oss.sgi.com>; Thu,  8 Oct 2015 06:46:58 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 06D02AC00A
	for <xfs@oss.sgi.com>; Thu,  8 Oct 2015 04:46:51 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	0ZHHCYHDKmRdtPXU for <xfs@oss.sgi.com>;
	Thu, 08 Oct 2015 04:46:49 -0700 (PDT)
Date: Thu, 8 Oct 2015 22:46:22 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Question about non asynchronous aio calls.
Message-ID: <20151008114622.GV27164@dastard>
References: <20151007141833.GB11716@scylladb.com>
	<56152B0F.2040809@sandeen.net>
	<20151007150833.GB30191@bfoster.bfoster>
	<56153685.3040401@sandeen.net> <561560B2.1080902@scylladb.com>
	<20151008042831.GU27164@dastard> <5615FD76.1090309@scylladb.com>
	<20151008082307.GE11716@scylladb.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20151008082307.GE11716@scylladb.com>
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
To: Gleb Natapov <gleb@scylladb.com>
Cc: Avi Kivity <avi@scylladb.com>, Brian Foster <bfoster@redhat.com>, Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

On Thu, Oct 08, 2015 at 11:23:07AM +0300, Gleb Natapov wrote:
> On Thu, Oct 08, 2015 at 08:21:58AM +0300, Avi Kivity wrote:
> > >>>I fixed something similar in ext4 at the time, FWIW.
> > >>Makes sense.
> > >>
> > >>Is there a way to relax this for reads?
> > >The above mostly only applies to writes. Reads don't modify data so
> > >racing unaligned reads against other reads won't given unexpected
> > >results and so aren't serialised.
> > >
> > >i.e. serialisation will only occur when:
> > >	- unaligned write IO will serialise until sub-block zeroing
> > >	  is complete.
> > >	- write IO extending EOF will serialis until post-EOF
> > >	  zeroing is complete
> > 
> > 
> > By "complete" here, do you mean that a call to truncate() returned, or that
> > its results reached the disk an unknown time later?
> > 

No, I'm talking purely about DIO here. If you do write that
starts beyond the existing EOF, there is a region between the
current EOF and the offset the write starts at. i.e.

   0             EOF            offset     new EOF
   +dddddddddddddd+..............+nnnnnnnnnnn+

It is the region between EOF and offset that we must ensure is made
up of either holes, unwritten extents or fully zeroed blocks before
allowing the write to proceed. If we have to zero allocated blocks,
then we have to ensure that completes before the write can start.
This means that when we update the EOF on completion of the write,
we don't expose stale data in blocks that were between EOF and
offset...

> I think Brian already answered that one with:
> 
>   There are no such pitfalls as far as I'm aware. The entire AIO
>   submission synchronization sequence triggers off an in-memory i_size
>   check in xfs_file_aio_write_checks(). The in-memory i_size is updated in
>   the truncate path (xfs_setattr_size()) via truncate_setsize(), so at
>   that point the new size should be visible to subsequent AIO writers.

Different situation as truncate serialises all IO. Extending the file
via truncate also runs the same "EOF zeroing" that the DIO code runs
above, for the same reasons.

> 
> > >	- truncate/extent manipulation syscall is run
> > 
> > Actually, we do call fallocate() ahead of io_submit() (in a worker thread,
> > in non-overlapping ranges) to optimize file layout and also in the belief
> > that it would reduce the amount of blocking io_submit() does.

fallocate serialises all IO submission - including reads. Unlike
truncate, however, it doesn't drain the queue of IO for
preallocation so the impact on AIO is somewhat limited.

Ideally you want to limit fallocate calls to large chunks at a time.
If you have a 1:1 mapping of fallocate calls to write calls, then
you're likely making things worse for the AIO submission path
because you'll block reads as well as writes. Doing the allocation
in the write submission path will not block reads, and only writes
that are attempting to do concurrent allocations to the same file
will serialise...

If you want to limit fragmentation without adding and overhead on
XFS for non-sparse files (which it sounds like your case), then the
best thing to use in XFS is the per-inode extent size hints. You set
it on the file when first creating it (or the parent directory so
all children inherit it at create), and then the allocator will
round out allocations to the size hint alignment and size, including
beyond EOF so appending writes can take advantage of it....

> > A final point is discoverability.  There is no way to discover safe
> > alignment for reads and writes, and which operations block io_submit(),
> > except by asking here, which cannot be done at runtime.  Interfaces that
> > provide a way to query these attributes are very important to us.
> As Brian pointed statfs() can be use to get f_bsize which is defined as
> "optimal transfer block size".

Well, that's what posix calls it. It's not really the optimal IO
size, though, it's just the IO size that avoids page cache RMW
cycles. For direct IO, larger tends to be better, and IO aligned to
the underlying geometry of the storage is even better. See, for
example, the "largeio" mount option, which will make XFS report the
stripe width in f_bsize rather than the PAGE_SIZE of the machine....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
