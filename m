Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 5E1D97F51
	for <xfs@oss.sgi.com>; Wed,  7 Oct 2015 10:13:19 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 4009F8F8050
	for <xfs@oss.sgi.com>; Wed,  7 Oct 2015 08:13:12 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id koRW7Qm4Ww9VtObn for <xfs@oss.sgi.com>;
	Wed, 07 Oct 2015 08:13:10 -0700 (PDT)
Subject: Re: Question about non asynchronous aio calls.
References: <20151007141833.GB11716@scylladb.com>
	<56152B0F.2040809@sandeen.net> <20151007150833.GB30191@bfoster.bfoster>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <56153685.3040401@sandeen.net>
Date: Wed, 7 Oct 2015 10:13:09 -0500
MIME-Version: 1.0
In-Reply-To: <20151007150833.GB30191@bfoster.bfoster>
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
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com



On 10/7/15 10:08 AM, Brian Foster wrote:
> On Wed, Oct 07, 2015 at 09:24:15AM -0500, Eric Sandeen wrote:
>>
>>
>> On 10/7/15 9:18 AM, Gleb Natapov wrote:
>>> Hello XFS developers,
>>>
>>> We are working on scylladb[1] database which is written using seastar[2]
>>> - highly asynchronous C++ framework. The code uses aio heavily: no
>>> synchronous operation is allowed at all by the framework otherwise
>>> performance drops drastically. We noticed that the only mainstream FS
>>> in Linux that takes aio seriously is XFS. So let me start by thanking
>>> you guys for the great work! But unfortunately we also noticed that
>>> sometimes io_submit() is executed synchronously even on XFS.
>>>
>>> Looking at the code I see two cases when this is happening: unaligned
>>> IO and write past EOF. It looks like we hit both. For the first one we
>>> make special afford to never issue unaligned IO and we use XFS_IOC_DIOINFO
>>> to figure out what alignment should be, but it does not help. Looking at the
>>> code though xfs_file_dio_aio_write() checks alignment against m_blockmask which
>>> is set to be sbp->sb_blocksize - 1, so aio expects buffer to be aligned to
>>> filesystem block size not values that DIOINFO returns. Is it intentional? How
>>> should our code know what it should align buffers to?
>>
>>         /* "unaligned" here means not aligned to a filesystem block */
>>         if ((pos & mp->m_blockmask) || ((pos + count) & mp->m_blockmask))
>>                 unaligned_io = 1;
>>
>> It should be aligned to the filesystem block size.
>>
> 
> I'm not sure exactly what kinds of races are opened if the above locking
> were absent, but I'd guess it's related to the buffer/block state
> management, block zeroing and whatnot that is buried in the depths of
> the generic dio code.

Yep:

commit eda77982729b7170bdc9e8855f0682edf322d277
Author: Dave Chinner <dchinner@redhat.com>
Date:   Tue Jan 11 10:22:40 2011 +1100

    xfs: serialise unaligned direct IOs
    
    When two concurrent unaligned, non-overlapping direct IOs are issued
    to the same block, the direct Io layer will race to zero the block.
    The result is that one of the concurrent IOs will overwrite data
    written by the other IO with zeros. This is demonstrated by the
    xfsqa test 240.
    
    To avoid this problem, serialise all unaligned direct IOs to an
    inode with a big hammer. We need a big hammer approach as we need to
    serialise AIO as well, so we can't just block writes on locks.
    Hence, the big hammer is calling xfs_ioend_wait() while holding out
    other unaligned direct IOs from starting.
    
    We don't bother trying to serialised aligned vs unaligned IOs as
    they are overlapping IO and the result of concurrent overlapping IOs
    is undefined - the result of either IO is a valid result so we let
    them race. Hence we only penalise unaligned IO, which already has a
    major overhead compared to aligned IO so this isn't a major problem.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Alex Elder <aelder@sgi.com>
    Reviewed-by: Christoph Hellwig <hch@lst.de>

I fixed something similar in ext4 at the time, FWIW.

> I suspect the dioinfo information describes the capabilities of the
> filesystem (e.g., what kinds of DIO are allowable) as opposed to any
> kind of optimal I/O related values. Something like statfs() can be used
> to determine the filesystem block size. I suppose you could also
> intentionally format the filesystem with a smaller block size if
> concurrent, smaller dio's are a requirement.
> 
>>> Second one is harder. We do need to write past the end of a file, actually
>>> most of our writes are like that, so it would have been great for XFS to
>>> handle this case asynchronously.
>>
>> You didn't say what kernel you're on, but these:
>>
>> 9862f62 xfs: allow appending aio writes
>> 7b7a866 direct-io: Implement generic deferred AIO completions
>>
>> hit kernel v3.15.
>>
>> However, we had a bug report about this, and Brian has sent a fix
>> which has not yet been merged, see:
>>
>> [PATCH 1/2] xfs: always drain dio before extending aio write submission
>>
>> on this list last week.
>>
>> With those 3 patches, things should just work for you I think.
>>
> 
> These fix some problems in that code, but the "beyond EOF" submission is
> still synchronous in nature by virtue of cycling the IOLOCK and draining
> pending dio. This is required to check for EOF zeroing, and we can't do
> that safely without a stable i_size.
> 
> Note that according to the commit Eric referenced above, ordering your
> I/O to always append (rather than start at some point beyond the current
> EOF) might be another option to avoid the synchronization here. Whether
> that is an option is specific to your application, of course.

Thanks for keeping me honest Brian.  :)

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
