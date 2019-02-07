Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49200 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726780AbfBGISe (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 7 Feb 2019 03:18:34 -0500
Subject: Re: bcache on XFS: metadata I/O (dirent I/O?) not getting cached at
 all?
References: <87h8dgefee.fsf@esperi.org.uk> <20190206234328.GH14116@dastard>
 <20190207002425.GX24140@tuebingen.mpg.de> <20190207022657.GI14116@dastard>
 <438851ef-ef77-b5f2-d46d-05762b6330b2@suse.de>
 <20190207031008.GJ14116@dastard>
From: Coly Li <colyli@suse.de>
Message-ID: <db79b5a2-e50b-880e-8ee1-da482a02088e@suse.de>
Date: Thu, 7 Feb 2019 16:18:25 +0800
MIME-Version: 1.0
In-Reply-To: <20190207031008.GJ14116@dastard>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Andre Noll <maan@tuebingen.mpg.de>, Nix <nix@esperi.org.uk>, linux-bcache@vger.kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>, axboe@kernel.dk

On 2019/2/7 11:10 上午, Dave Chinner wrote:
> On Thu, Feb 07, 2019 at 10:38:58AM +0800, Coly Li wrote:
>> On 2019/2/7 10:26 上午, Dave Chinner wrote:
>>> On Thu, Feb 07, 2019 at 01:24:25AM +0100, Andre Noll wrote:
>>>> On Thu, Feb 07, 10:43, Dave Chinner wrote
>>>>> File data readahead: REQ_RAHEAD
>>>>> Metadata readahead: REQ_META | REQ_RAHEAD
>>>>>
>>>>> drivers/md/bcache/request.c::check_should_bypass():
>>>>>
>>>>>         /*
>>>>>          * Flag for bypass if the IO is for read-ahead or background,
>>>>>          * unless the read-ahead request is for metadata (eg, for gfs2).
>>>>>          */
>>>>>         if (bio->bi_opf & (REQ_RAHEAD|REQ_BACKGROUND) &&
>>>>>             !(bio->bi_opf & REQ_PRIO))
>>>>>                 goto skip;
>>>>>
>>>>> bcache needs fixing - it thinks REQ_PRIO means metadata IO. That's
>>>>> wrong - REQ_META means it's metadata IO, and so this is a bcache
>>>>> bug.
>>>>
>>>> Do you think 752f66a75abad is bad (ha!) and should be reverted?
>>>
>>> Yes, that change is just broken. From include/linux/blk_types.h:
>>>
>>> 	__REQ_META,             /* metadata io request */
>>> 	__REQ_PRIO,             /* boost priority in cfq */
>>>
>>>
>>
>> Hi Dave,
>>
>>> i.e. REQ_META means that it is a metadata request, REQ_PRIO means it
>>> is a "high priority" request. Two completely different things, often
>>> combined, but not interchangeable.
>>
>> I found in file system metadata IO, most of time REQ_META and REQ_PRIO
>> are tagged together for bio, but XFS seems not use REQ_PRIO.
> 
> Yes, that's correct, because we don't specifically prioritise
> metadata IO over data IO.
> 
>> Is there any basic principle for when should these tags to be used or
>> not ?
> 
> Yes.
> 
>> e.g. If REQ_META is enough for meta data I/O, why REQ_PRIO is used
>> too.
> 
> REQ_META is used for metadata. REQ_PRIO is used to communicate to
> the lower layers that the submitter considers this IO to be more
> important that non REQ_PRIO IO and so dispatch should be expedited.
> 
> IOWs, if the filesystem considers metadata IO to be more important
> that user data IO, then it will use REQ_PRIO | REQ_META rather than
> just REQ_META.
> 
> Historically speaking, REQ_PRIO was a hack for CFQ to get it to
> dispatch journal IO from a different thread without waiting for a
> time slice to expire. In the XFs world, we just said "don't use CFQ,
> it's fundametnally broken for highly concurrent applications" and
> didn't bother trying to hack around the limitations of CFQ.
> 
> These days REQ_PRIO is only used by the block layer writeback
> throttle, but unlike bcache it considers both REQ_META and REQ_PRIO
> to mean the same thing.
> 
> REQ_META, OTOH, is used by BFQ and blk-cgroup to detect metadata
> IO and don't look at REQ_PRIO at all. So, really, REQ_META is for
> metadata, not REQ_PRIO. REQ_PRIO looks like it should just go away.
> 
>> And if REQ_PRIO is necessary, why it is not used in fs/xfs/ code ?
> 
> It's not necessary, it's just an /optimisation/ that some
> filesystems make and some IO schedulers used to pay attention to. It
> looks completely redundant now.

Hi Dave,

Thanks for your detailed explanation. This is great hint from view of
file system developer :-)

I just compose a fix, hope it makes better.

-- 

Coly Li
