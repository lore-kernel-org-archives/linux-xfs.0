Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 88C0F7F51
	for <xfs@oss.sgi.com>; Mon, 12 Oct 2015 07:37:13 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 78BDD8F8033
	for <xfs@oss.sgi.com>; Mon, 12 Oct 2015 05:37:10 -0700 (PDT)
Received: from mail-wi0-f173.google.com (mail-wi0-f173.google.com
	[209.85.212.173]) by cuda.sgi.com with ESMTP id
	Ov7A7091CTIBPJ0U (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 12 Oct 2015 05:37:08 -0700 (PDT)
Received: by wicge5 with SMTP id ge5so15798258wic.0
	for <xfs@oss.sgi.com>; Mon, 12 Oct 2015 05:37:07 -0700 (PDT)
Subject: Re: Question about non asynchronous aio calls.
References: <20151007141833.GB11716@scylladb.com>
	<56152B0F.2040809@sandeen.net> <20151007150833.GB30191@bfoster.bfoster>
	<56153685.3040401@sandeen.net> <561560B2.1080902@scylladb.com>
	<20151008042831.GU27164@dastard> <5615FD76.1090309@scylladb.com>
	<20151008082307.GE11716@scylladb.com> <20151008114622.GV27164@dastard>
From: Avi Kivity <avi@scylladb.com>
Message-ID: <561BA970.8080504@scylladb.com>
Date: Mon, 12 Oct 2015 15:37:04 +0300
MIME-Version: 1.0
In-Reply-To: <20151008114622.GV27164@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>, Gleb Natapov <gleb@scylladb.com>
Cc: Brian Foster <bfoster@redhat.com>, Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

On 10/08/2015 02:46 PM, Dave Chinner wrote:
> On Thu, Oct 08, 2015 at 11:23:07AM +0300, Gleb Natapov wrote:
>> On Thu, Oct 08, 2015 at 08:21:58AM +0300, Avi Kivity wrote:
>>>>>> I fixed something similar in ext4 at the time, FWIW.
>>>>> Makes sense.
>>>>>
>>>>> Is there a way to relax this for reads?
>>>> The above mostly only applies to writes. Reads don't modify data so
>>>> racing unaligned reads against other reads won't given unexpected
>>>> results and so aren't serialised.
>>>>
>>>> i.e. serialisation will only occur when:
>>>> 	- unaligned write IO will serialise until sub-block zeroing
>>>> 	  is complete.
>>>> 	- write IO extending EOF will serialis until post-EOF
>>>> 	  zeroing is complete
>>>
>>> By "complete" here, do you mean that a call to truncate() returned, or that
>>> its results reached the disk an unknown time later?
>>>
> No, I'm talking purely about DIO here. If you do write that
> starts beyond the existing EOF, there is a region between the
> current EOF and the offset the write starts at. i.e.
>
>     0             EOF            offset     new EOF
>     +dddddddddddddd+..............+nnnnnnnnnnn+
>
> It is the region between EOF and offset that we must ensure is made
> up of either holes, unwritten extents or fully zeroed blocks before
> allowing the write to proceed. If we have to zero allocated blocks,
> then we have to ensure that completes before the write can start.
> This means that when we update the EOF on completion of the write,
> we don't expose stale data in blocks that were between EOF and
> offset...

Thanks.  We found, experimentally, that io_submit(write_at_eof) followed 
by (without waiting) io_submit(write_at_what_would_be_the_new_eof) 
occasionally blocks.

So I guess we have to employ a train algorithm here and keep at most one 
aio in flight for append loads (which are very common for us).

>
>> I think Brian already answered that one with:
>>
>>    There are no such pitfalls as far as I'm aware. The entire AIO
>>    submission synchronization sequence triggers off an in-memory i_size
>>    check in xfs_file_aio_write_checks(). The in-memory i_size is updated in
>>    the truncate path (xfs_setattr_size()) via truncate_setsize(), so at
>>    that point the new size should be visible to subsequent AIO writers.
> Different situation as truncate serialises all IO. Extending the file
> via truncate also runs the same "EOF zeroing" that the DIO code runs
> above, for the same reasons.

Does that mean that truncate() will wait for inflight aios, or that new 
aios will wait for the truncate() to complete, or both?

>
>>>> 	- truncate/extent manipulation syscall is run
>>> Actually, we do call fallocate() ahead of io_submit() (in a worker thread,
>>> in non-overlapping ranges) to optimize file layout and also in the belief
>>> that it would reduce the amount of blocking io_submit() does.
> fallocate serialises all IO submission - including reads. Unlike
> truncate, however, it doesn't drain the queue of IO for
> preallocation so the impact on AIO is somewhat limited.
>
> Ideally you want to limit fallocate calls to large chunks at a time.
> If you have a 1:1 mapping of fallocate calls to write calls, then
> you're likely making things worse for the AIO submission path
> because you'll block reads as well as writes. Doing the allocation
> in the write submission path will not block reads, and only writes
> that are attempting to do concurrent allocations to the same file
> will serialise...

We have a 1:8 ratio (128K:1M), but that's just random numbers we guessed.

Again, not only for reduced xfs metadata, but also to reduce the amount 
of write amplification done by the FTL. We have a concurrent append 
workload on many files, and files are reclaimed out of order, so larger 
extends means less fragmentation for the FTL later on.

>
> If you want to limit fragmentation without adding and overhead on
> XFS for non-sparse files (which it sounds like your case), then the
> best thing to use in XFS is the per-inode extent size hints. You set
> it on the file when first creating it (or the parent directory so
> all children inherit it at create), and then the allocator will
> round out allocations to the size hint alignment and size, including
> beyond EOF so appending writes can take advantage of it....

We'll try that out.  That's fsxattr::fsx_extsize?

What about small files that are eventually closed, do I need to do 
anything to reclaim the preallocated space?

>
>>> A final point is discoverability.  There is no way to discover safe
>>> alignment for reads and writes, and which operations block io_submit(),
>>> except by asking here, which cannot be done at runtime.  Interfaces that
>>> provide a way to query these attributes are very important to us.
>> As Brian pointed statfs() can be use to get f_bsize which is defined as
>> "optimal transfer block size".
> Well, that's what posix calls it. It's not really the optimal IO
> size, though, it's just the IO size that avoids page cache RMW
> cycles. For direct IO, larger tends to be better, and IO aligned to
> the underlying geometry of the storage is even better. See, for
> example, the "largeio" mount option, which will make XFS report the
> stripe width in f_bsize rather than the PAGE_SIZE of the machine....
>

Well, random reads will still be faster with 512 byte alignment, yes? 
and for random writes, you can't just make those I/Os larger, you'll 
overwrite something.

So I read "optimal" here to mean "smallest I/O size that doesn't incur a 
penalty; but if you really need more data, making it larger will help".

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
