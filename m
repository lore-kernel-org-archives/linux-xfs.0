Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id BE1D37F37
	for <xfs@oss.sgi.com>; Wed,  7 Oct 2015 23:28:38 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B030D304039
	for <xfs@oss.sgi.com>; Wed,  7 Oct 2015 21:28:38 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	YSDIVgyZfA027gKc for <xfs@oss.sgi.com>;
	Wed, 07 Oct 2015 21:28:35 -0700 (PDT)
Date: Thu, 8 Oct 2015 15:28:32 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Question about non asynchronous aio calls.
Message-ID: <20151008042831.GU27164@dastard>
References: <20151007141833.GB11716@scylladb.com>
	<56152B0F.2040809@sandeen.net>
	<20151007150833.GB30191@bfoster.bfoster>
	<56153685.3040401@sandeen.net> <561560B2.1080902@scylladb.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <561560B2.1080902@scylladb.com>
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
Cc: Brian Foster <bfoster@redhat.com>, Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

On Wed, Oct 07, 2015 at 09:13:06PM +0300, Avi Kivity wrote:
> On 07/10/15 18:13, Eric Sandeen wrote:
> >
> >On 10/7/15 10:08 AM, Brian Foster wrote:
> >>On Wed, Oct 07, 2015 at 09:24:15AM -0500, Eric Sandeen wrote:
> >>>
> >>>On 10/7/15 9:18 AM, Gleb Natapov wrote:
> >>>>Hello XFS developers,
> >>>>
> >>>>We are working on scylladb[1] database which is written using seastar[2]
> >>>>- highly asynchronous C++ framework. The code uses aio heavily: no
> >>>>synchronous operation is allowed at all by the framework otherwise
> >>>>performance drops drastically. We noticed that the only mainstream FS
> >>>>in Linux that takes aio seriously is XFS. So let me start by thanking
> >>>>you guys for the great work! But unfortunately we also noticed that
> >>>>sometimes io_submit() is executed synchronously even on XFS.
> >>>>
> >>>>Looking at the code I see two cases when this is happening: unaligned
> >>>>IO and write past EOF. It looks like we hit both. For the first one we
> >>>>make special afford to never issue unaligned IO and we use XFS_IOC_DIOINFO
> >>>>to figure out what alignment should be, but it does not help. Looking at the
> >>>>code though xfs_file_dio_aio_write() checks alignment against m_blockmask which
> >>>>is set to be sbp->sb_blocksize - 1, so aio expects buffer to be aligned to
> >>>>filesystem block size not values that DIOINFO returns. Is it intentional? How
> >>>>should our code know what it should align buffers to?
> >>>         /* "unaligned" here means not aligned to a filesystem block */
> >>>         if ((pos & mp->m_blockmask) || ((pos + count) & mp->m_blockmask))
> >>>                 unaligned_io = 1;
> >>>
> >>>It should be aligned to the filesystem block size.
> >>>
> >>I'm not sure exactly what kinds of races are opened if the above locking
> >>were absent, but I'd guess it's related to the buffer/block state
> >>management, block zeroing and whatnot that is buried in the depths of
> >>the generic dio code.
> >Yep:
> >
> >commit eda77982729b7170bdc9e8855f0682edf322d277
> >Author: Dave Chinner <dchinner@redhat.com>
> >Date:   Tue Jan 11 10:22:40 2011 +1100
> >
> >     xfs: serialise unaligned direct IOs

[...]

> >I fixed something similar in ext4 at the time, FWIW.
> 
> Makes sense.
> 
> Is there a way to relax this for reads?

The above mostly only applies to writes. Reads don't modify data so
racing unaligned reads against other reads won't given unexpected
results and so aren't serialised.

i.e. serialisation will only occur when:
	- unaligned write IO will serialise until sub-block zeroing
	  is complete.
	- write IO extending EOF will serialis until post-EOF
	  zeroing is complete
	- cached pages are found on the inode (i.e. mixing
	  buffered/mmap access with direct IO).
	- truncate/extent manipulation syscall is run

All other DIO will be issued and run concurrently, reads and writes.

Realistically, if you are care about performance (which obviously
you are) then you do not do unaligned IO, and you try hard to
minimise operations that extend the file...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
