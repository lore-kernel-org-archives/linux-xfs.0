Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 4AFE77F4E
	for <xfs@oss.sgi.com>; Sun, 26 Oct 2014 18:56:33 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id BEA2FAC001
	for <xfs@oss.sgi.com>; Sun, 26 Oct 2014 16:56:29 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	wl6SHkp4WKN1R0Hy for <xfs@oss.sgi.com>;
	Sun, 26 Oct 2014 16:56:27 -0700 (PDT)
Date: Mon, 27 Oct 2014 10:56:24 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: file streams allocator behavior
Message-ID: <20141026235624.GC6880@dastard>
References: <544BE820.6040905@hardwarefreak.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <544BE820.6040905@hardwarefreak.com>
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
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: xfs@oss.sgi.com

On Sat, Oct 25, 2014 at 01:12:48PM -0500, Stan Hoeppner wrote:
> I recall reading a while back something about disabling the filestreams
> allocator, or at least changing its behavior, but I'm unable to find that.
> 
> What I'm trying to do is use parallel dd w/O_DIRECT to write 44 files in
> parallel to 44 directories, thus all 44 AGs, in one test, then write 44
> files to one dir, one AG, in another test.  The purpose of this
> quick/dirty exercise is to demonstrate throughput differences due to
> full platter seeking in the former case and localized seeking in the
> latter case.
> 
> But of course the problem I'm running into in the single directory case
> is that the filestreams allocator starts writing all of the 44 files
> into the appropriate AG, but then begins allocating extents for each
> file in other AGs.  This is of course defeating the purpose of the tests.

That's caused by allocator contention. When you try to write 44
files to the same dir in parallel, they'll all start with the same
target AG, but then when one thread is allocating into AG 43 and has
the AG locked, a second attempt to allocate to than AG will see the
AG locked and so it will move to find the next AG that is not
locked.

Remember, AGs were not originally designed for confining physical
locality - they are designed to allow allocator parallelism. Hence
once the file has jumped to a new AG it will try to allocate
sequentially from that point onwards in that same AG, until either
ENOSPC or further contention.

Hence with a workload like this, if the writes continue for long
enough each file will end up finding it's own uncontended AG and
hence mostly end up contiguous on disk and not getting blocked
waiting for allocation on other files. When you have as many writers
as there are AGs, however, such a steady state is generally not
possible as there will always be files trying to write into the same
AG.

As it is, filestreams is not designed for this sort of parallel
workload. filestreams is designed to separate single threaded
streams of IO into different locations, not handle concurrent writes
into multiple files in the same directory.

As it is, the inode64 will probably demonstrate exactly the same
behaviour because it will start by trying to write all the files to
the same AG and hence hit allocator contention, too.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
