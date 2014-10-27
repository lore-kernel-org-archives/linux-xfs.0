Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C94707F92
	for <xfs@oss.sgi.com>; Mon, 27 Oct 2014 18:23:55 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 547C4AC006
	for <xfs@oss.sgi.com>; Mon, 27 Oct 2014 16:23:55 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id xqCekCOydQJwalAU
	for <xfs@oss.sgi.com>; Mon, 27 Oct 2014 16:23:54 -0700 (PDT)
Message-ID: <544ED42A.2090108@hardwarefreak.com>
Date: Mon, 27 Oct 2014 18:24:26 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: file streams allocator behavior
References: <544BE820.6040905@hardwarefreak.com>
	<20141026235624.GC6880@dastard>
In-Reply-To: <20141026235624.GC6880@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 10/26/2014 06:56 PM, Dave Chinner wrote:
> On Sat, Oct 25, 2014 at 01:12:48PM -0500, Stan Hoeppner wrote:
>> I recall reading a while back something about disabling the filestreams
>> allocator, or at least changing its behavior, but I'm unable to find that.
>>
>> What I'm trying to do is use parallel dd w/O_DIRECT to write 44 files in
>> parallel to 44 directories, thus all 44 AGs, in one test, then write 44
>> files to one dir, one AG, in another test.  The purpose of this
>> quick/dirty exercise is to demonstrate throughput differences due to
>> full platter seeking in the former case and localized seeking in the
>> latter case.
>>
>> But of course the problem I'm running into in the single directory case
>> is that the filestreams allocator starts writing all of the 44 files
>> into the appropriate AG, but then begins allocating extents for each
>> file in other AGs.  This is of course defeating the purpose of the tests.
> 
> That's caused by allocator contention. When you try to write 44
> files to the same dir in parallel, they'll all start with the same
> target AG, but then when one thread is allocating into AG 43 and has
> the AG locked, a second attempt to allocate to than AG will see the
> AG locked and so it will move to find the next AG that is not
> locked.

That's what I suspected given what I was seeing.

> Remember, AGs were not originally designed for confining physical
> locality - they are designed to allow allocator parallelism. Hence

Right.  But they sure do come in handy when used this way with
preallocated files.  I suspect we'll make heavy use of this when they
have me back to implement my recommendations.

> once the file has jumped to a new AG it will try to allocate
> sequentially from that point onwards in that same AG, until either
> ENOSPC or further contention.
> 
> Hence with a workload like this, if the writes continue for long
> enough each file will end up finding it's own uncontended AG and
> hence mostly end up contiguous on disk and not getting blocked
> waiting for allocation on other files. When you have as many writers
> as there are AGs, however, such a steady state is generally not
> possible as there will always be files trying to write into the same
> AG.

Yep.  That's exactly what xfs_bmap was showing.  Some files had extents
in 3-4 AGs, some in 8 or more AGs.

> As it is, filestreams is not designed for this sort of parallel
> workload. filestreams is designed to separate single threaded
> streams of IO into different locations, not handle concurrent writes
> into multiple files in the same directory.

Right.  I incorrectly refered to the filestreams allocator as I didn't
know of the inode64 congestion control mechanism at that time.  I simply
had recalled one of your emails where you and Christoph were discussing
mods to the filestreams allocator, and the file pattern to the AGs
looked familiar.

> As it is, the inode64 will probably demonstrate exactly the same
> behaviour because it will start by trying to write all the files to
> the same AG and hence hit allocator contention, too.

I was using the inode64 allocator, and yes, it did.  Brian saved my
bacon as I wanted to use preallocated files but didn't know exactly how.
 I knew all their extents would be in the AG I wanted them in, given the
way I intended to do it.

And doing this demonstrated what I anticipated.  Writing 2GB into each
of 132 files with 132 parallel dd processes with O_DIRECT, 264GB total,
I achieved:

AG0 only	1377 MB/s
AGs 0-43	 767 MB/s

Due to the nature of the application, we should be able to distribute
the files in such a manner that only 1 or 2 adjacent AGs are being
accesses concurrently.  This will greatly reduce head seeking,
increasing throughput, as demonstrated above.  All thanks to the
allocation group architecture of XFS.  We'd not be able to do this with
any other filesystem AFAIK.

Thanks,
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
