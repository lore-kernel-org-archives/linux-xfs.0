Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 637AB7F37
	for <xfs@oss.sgi.com>; Wed,  7 Oct 2015 13:13:17 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 44735304043
	for <xfs@oss.sgi.com>; Wed,  7 Oct 2015 11:13:14 -0700 (PDT)
Received: from mail-wi0-f178.google.com (mail-wi0-f178.google.com
	[209.85.212.178]) by cuda.sgi.com with ESMTP id
	hyFe73zgMHI6YjY9 (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 07 Oct 2015 11:13:11 -0700 (PDT)
Received: by wicgb1 with SMTP id gb1so223168693wic.1
	for <xfs@oss.sgi.com>; Wed, 07 Oct 2015 11:13:10 -0700 (PDT)
Subject: Re: Question about non asynchronous aio calls.
References: <20151007141833.GB11716@scylladb.com>
	<56152B0F.2040809@sandeen.net> <20151007150833.GB30191@bfoster.bfoster>
	<56153685.3040401@sandeen.net>
From: Avi Kivity <avi@scylladb.com>
Message-ID: <561560B2.1080902@scylladb.com>
Date: Wed, 7 Oct 2015 21:13:06 +0300
MIME-Version: 1.0
In-Reply-To: <56153685.3040401@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>, Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On 07/10/15 18:13, Eric Sandeen wrote:
>
> On 10/7/15 10:08 AM, Brian Foster wrote:
>> On Wed, Oct 07, 2015 at 09:24:15AM -0500, Eric Sandeen wrote:
>>>
>>> On 10/7/15 9:18 AM, Gleb Natapov wrote:
>>>> Hello XFS developers,
>>>>
>>>> We are working on scylladb[1] database which is written using seastar[2]
>>>> - highly asynchronous C++ framework. The code uses aio heavily: no
>>>> synchronous operation is allowed at all by the framework otherwise
>>>> performance drops drastically. We noticed that the only mainstream FS
>>>> in Linux that takes aio seriously is XFS. So let me start by thanking
>>>> you guys for the great work! But unfortunately we also noticed that
>>>> sometimes io_submit() is executed synchronously even on XFS.
>>>>
>>>> Looking at the code I see two cases when this is happening: unaligned
>>>> IO and write past EOF. It looks like we hit both. For the first one we
>>>> make special afford to never issue unaligned IO and we use XFS_IOC_DIOINFO
>>>> to figure out what alignment should be, but it does not help. Looking at the
>>>> code though xfs_file_dio_aio_write() checks alignment against m_blockmask which
>>>> is set to be sbp->sb_blocksize - 1, so aio expects buffer to be aligned to
>>>> filesystem block size not values that DIOINFO returns. Is it intentional? How
>>>> should our code know what it should align buffers to?
>>>          /* "unaligned" here means not aligned to a filesystem block */
>>>          if ((pos & mp->m_blockmask) || ((pos + count) & mp->m_blockmask))
>>>                  unaligned_io = 1;
>>>
>>> It should be aligned to the filesystem block size.
>>>
>> I'm not sure exactly what kinds of races are opened if the above locking
>> were absent, but I'd guess it's related to the buffer/block state
>> management, block zeroing and whatnot that is buried in the depths of
>> the generic dio code.
> Yep:
>
> commit eda77982729b7170bdc9e8855f0682edf322d277
> Author: Dave Chinner <dchinner@redhat.com>
> Date:   Tue Jan 11 10:22:40 2011 +1100
>
>      xfs: serialise unaligned direct IOs
>      
>      When two concurrent unaligned, non-overlapping direct IOs are issued
>      to the same block, the direct Io layer will race to zero the block.
>      The result is that one of the concurrent IOs will overwrite data
>      written by the other IO with zeros. This is demonstrated by the
>      xfsqa test 240.
>      
>      To avoid this problem, serialise all unaligned direct IOs to an
>      inode with a big hammer. We need a big hammer approach as we need to
>      serialise AIO as well, so we can't just block writes on locks.
>      Hence, the big hammer is calling xfs_ioend_wait() while holding out
>      other unaligned direct IOs from starting.
>      
>      We don't bother trying to serialised aligned vs unaligned IOs as
>      they are overlapping IO and the result of concurrent overlapping IOs
>      is undefined - the result of either IO is a valid result so we let
>      them race. Hence we only penalise unaligned IO, which already has a
>      major overhead compared to aligned IO so this isn't a major problem.
>      
>      Signed-off-by: Dave Chinner <dchinner@redhat.com>
>      Reviewed-by: Alex Elder <aelder@sgi.com>
>      Reviewed-by: Christoph Hellwig <hch@lst.de>
>
> I fixed something similar in ext4 at the time, FWIW.

Makes sense.

Is there a way to relax this for reads?  It's pretty easy to saturate 
the disk read bandwidth with 4K reads, and there shouldn't be a race 
there, at least for reads targeting already-written blocks.  For us at 
least small reads would be sufficient.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
