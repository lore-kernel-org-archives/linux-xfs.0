Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm0-f44.google.com ([74.125.82.44]:46660 "EHLO
        mail-wm0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751626AbdITLLy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 20 Sep 2017 07:11:54 -0400
Received: by mail-wm0-f44.google.com with SMTP id i189so6164455wmf.1
        for <linux-xfs@vger.kernel.org>; Wed, 20 Sep 2017 04:11:53 -0700 (PDT)
Subject: Re: io_submit() blocks for writes for substantial amount of time
References: <CAO2XSW6cctUGx18AdQQ29zHpjPiJ2vVJ-MHxrGcmoeMxzMvbbA@mail.gmail.com>
 <20170919122704.GA3487@bfoster.bfoster>
 <20170919145827.GA21523@infradead.org>
 <04cb3ee7-e7d5-6bba-6adb-8ac1c28e68dc@scylladb.com>
 <20170919173955.GB8139@dhcp-41-131.bos.redhat.com>
 <ba7a108e-733e-419d-9839-545bc04e0caf@scylladb.com>
 <20170920105021.GA16036@bfoster.bfoster>
From: Avi Kivity <avi@scylladb.com>
Message-ID: <8b7b0822-9d57-4fc9-d55f-b0f94d8a5cbd@scylladb.com>
Date: Wed, 20 Sep 2017 14:11:49 +0300
MIME-Version: 1.0
In-Reply-To: <20170920105021.GA16036@bfoster.bfoster>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, Tomasz Grabiec <tgrabiec@scylladb.com>, linux-xfs@vger.kernel.org



On 09/20/2017 01:50 PM, Brian Foster wrote:
> On Wed, Sep 20, 2017 at 09:17:25AM +0300, Avi Kivity wrote:
>> On 09/19/2017 08:39 PM, Brian Foster wrote:
>>> On Tue, Sep 19, 2017 at 07:31:04PM +0300, Avi Kivity wrote:
>>>> On 09/19/2017 05:58 PM, Christoph Hellwig wrote:
>>>>> On Tue, Sep 19, 2017 at 08:27:05AM -0400, Brian Foster wrote:
>>>>>>> Please advise, is this a known bug? When can it happen? Is there a way
>>>>>>> to work it around to avoid blocking?
>>>>>>>
>>>>>> I'm not sure how either could be considered a bug based on the stack
>>>>>> trace information alone. Allocations may require reading metadata and
>>>>>> reads are synchronous. This all seems like pretty basic filesystem
>>>>>> behavior.
>>>>>>
>>>>>> I suppose performance may be a separate question. For the latter issue,
>>>>>> I'd be curious whether leaving more free space available in the
>>>>>> filesystem would help avoid running into busy extents. Perhaps having
>>>>>> more memory and thus a larger buffer cache for btree blocks could help
>>>>>> mitigate the former issue..? The deterministic workaround for both is to
>>>>>> preallocate the associated file. If the file would be too large, another
>>>>>> option may be to set an extent size hint to allocate the file in larger
>>>>>> chunks and amortize the cost of the allocations over multiple writes.
>>>>> Note that Linux 4.13 and later support a RWF_NOWAIT flag, that will
>>>>> return -EAGAIN from io_submit for these conditions so they can be
>>>>> handled by a thread pool.
>>>>>
>>>>> Note that until a few years ago we performed all allocations from
>>>>> a workqueue, this was changed by:
>>>>>
>>>>> commit cf11da9c5d374962913ca5ba0ce0886b58286224
>>>>> Author: Dave Chinner <dchinner@redhat.com>
>>>>> Date:   Tue Jul 15 07:08:24 2014 +1000
>>>>>
>>>>>        xfs: refine the allocation stack switch
>>>>>
>>>>> to only defer btree splits to a workqueue.  With that previous scheme
>>>>> there might have been an option to defer AIO allocations to a workqueue,
>>>>> but the main issue with that is that the worker thread which is then
>>>>> going to do the actual data transfer would have to "borrow" the
>>>>> mm_struct from the submitter.  That's the primary reason why something
>>>>> like that was never implemented in mainline Linux.
>>>> For DIO, does it really need the mm_struct? It can just pin the pages and
>>>> pass them to the workqueue function.
>>>>
>>> I'm not sure what difference it makes regardless. We still have to wait
>>> for an allocation to complete before we can issue an I/O.
>> If io_submit() returns immediately rather than blocking, it makes a huge
>> difference. Waiting in the workqueue can be done in parallel to other I/O
>> and in parallel to cpu work in the caller thread. Blocking means no further
>> I/O is issued and no cpu work is done.
>>
> Sure. I'm just saying that seems orthogonal to how/why we deferred block
> allocations to a wq.

Oh, sorry for misunderstanding. TBH this is beyond my (very weak) 
understanding of the low-level implementation.

>   Even if we went back to that behavior, io_submit()
> will still potentially block as it does today. It sounds like what you
> want is something higher level that defers the entire aio submission to
> a wq (which still may have to use another wq for btree splits, for
> different reasons).

I think it's still preferable to avoid a workqueue and its 
non-deterministic latencies and context switches if we can prove that a 
particular iocb will not require a synchronous operation. If that can be 
done then 4.13 nowait aio also works - the user provides the workqueue 
equivalent. The only problem is if we can't prove in advance that an 
iocb will require blocking.

>   Apparently we had something like that in the past as
> Christoph referred to in his last mail, but I'm not really familiar with
> that.
>
> FWIW, this is not exactly the same, but I think Dave prototyped
> something in the past to wire up aio_fsync() to a basic wq
> implementation and managed to show really good scalability improvements.
> Given that, I suppose it wouldn't be that surprising to get similar
> results for I/O submission if there is some way around the page issue.

I can think of a couple of options:

  1. Short writes - just ignore the tail of a too-large iovec. May cause 
buggy applications to fail, so probably not a good idea.
  2. Global limit - if the number of pinned pages in all currently 
running iocbs is below some limit, allow it, otherwise fail a nowait aio 
(and synchronously execute a non-nowait aio). Few applications will 
overflow the global limit if it is generous enough, since very large 
I/Os induce bad latency and don't gain you much in throughput.
  3. Borrow the mm, and pin from the wq - I gather it was considered and 
rejected, but maybe it can be reconsidered.



