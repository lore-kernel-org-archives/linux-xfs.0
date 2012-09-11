Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8BKxpQw153565 for <xfs@oss.sgi.com>; Tue, 11 Sep 2012 15:59:51 -0500
Received: from youngberry.canonical.com (youngberry.canonical.com
	[91.189.89.112]) by cuda.sgi.com with ESMTP id mMIEzGglAQMzmTOv
	for <xfs@oss.sgi.com>; Tue, 11 Sep 2012 14:00:55 -0700 (PDT)
Message-ID: <504FA682.8010905@canonical.com>
Date: Tue, 11 Sep 2012 22:00:50 +0100
From: Colin Ian King <colin.king@canonical.com>
MIME-Version: 1.0
Subject: Re: slow xfs writes on loopback mounted xfs with dd + seek
References: <504F08E8.6020500@canonical.com> <504F5027.9080503@redhat.com>
	<20120911205029.GC11511@dastard>
In-Reply-To: <20120911205029.GC11511@dastard>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

On 11/09/12 21:50, Dave Chinner wrote:
> On Tue, Sep 11, 2012 at 10:52:23AM -0400, Brian Foster wrote:
>> On 09/11/2012 05:48 AM, Colin Ian King wrote:
>>> Hi,
>>>
>>> I've seeing really slow I/O writes on xfs when doing a dd with a seek
>>> offset to a file on an xfs file system which is loop mounted.
>>>
>>> Reproduced on Linux 3.6.0-rc5 and 3.4
>>>
>>> How to reproduce:
>>>
>>> dd if=/dev/zero of=xfs.img bs=1M count=1024
>>> mkfs.xfs -f xfs.img
>>> sudo mount -o loop -t xfs xfs.img /mnt/test
>>>
>>> First create a large file, write performance is excellent:
>>>
>>> sudo dd if=/dev/zero of=/mnt/test/big bs=1M count=500
>>> 500+0 records in
>>> 500+0 records out
>>> 524288000 bytes (524 MB) copied, 1.69451 s, 309 MB/s
>>>
>>> ..next seek and write some more blocks, write performance is poor:
>>>
>>> sudo dd if=/dev/zero of=/mnt/test/big obs=4K count=8192 seek=131072
>>> 8192+0 records in
>>> 1024+0 records out
>>> 4194304 bytes (4.2 MB) copied, 47.0644 s, 89.1 kB/s
>>>
>>
>> Hi Colin,
>>
>> I reproduced this behavior with a 1GB filesystem on a loop device. I
>> think the problem you're seeing could be circumstantial to the fact that
>> you're writing to a point where you are close to filling the fs.
>>
>> Taking a look at the tracepoint data when running your second dd alone
>> vs. in succession to the first, I see a fairly clean
>> buffered_write->get_blocks pattern vs. a
>> buffered_write->enospc->log_force->get_blocks pattern.
>>
>> In other words, you're triggering an internal space allocation failure
>> and flush sequence intended to free up space. Somebody else might be
>> able to chime in and more ably explain why that occurs following a
>> truncate (perhaps the space isn't freed until the change hits the log),
>> but regardless this doesn't seem to occur if you increase the size of
>> the fs.
>
> The space is considered "busy" and won't be reused until the
> truncate transaction hits the log and the space is free on disk. See
> xfs_busy_extent.c
>
> Basically, testing XFS performance on tiny filesystems is going to
> show false behaviours. XFS is optimised for large filesystems and
> will typically shows low space artifacts on small filesystems,
> especially when you are doing things like filling most of the free
> filesystem space with 1 file.
>
> e.g.  1GB free on at 100TB filesystem will throttle behaviours (say
> speculative preallocation) much more effectively because itis within
> 1% of ENOSPC. That same 1GB free on a 1GB filesystem won't throttle
> preallocation at all, and so that one file when it reaches a little
> over 500MB will try to preallocate half the remaining space in the
> filesystem because the filesystem is only 50% full....
>

That's a really useful explanation. Thanks!
> Cheers,
>
> Dave.
>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
