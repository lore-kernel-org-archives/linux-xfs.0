Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-io0-f196.google.com ([209.85.223.196]:33423 "EHLO
        mail-io0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753056AbeEUPgY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 21 May 2018 11:36:24 -0400
Received: by mail-io0-f196.google.com with SMTP id e78-v6so14784944iod.0
        for <linux-xfs@vger.kernel.org>; Mon, 21 May 2018 08:36:23 -0700 (PDT)
Subject: Re: [PATCH 00/13] convert block layer to bioset_init()/mempool_init()
References: <20180520222558.7053-1-kent.overstreet@gmail.com>
 <20180521140348.GA19069@redhat.com>
 <686d7df6-c7d1-48a6-b7ff-48dc8aff6a62@kernel.dk>
 <20180521143132.GB19194@redhat.com>
 <2bbeeb1a-8b99-b06a-eb9b-eb8523c16460@kernel.dk>
 <20180521144703.GA19303@redhat.com>
 <4b343aef-e11c-73ba-1d88-7e73ca838cad@kernel.dk>
 <20180521150439.GA19379@redhat.com>
 <61e30dcf-a01c-f47d-087a-12930caf9aef@kernel.dk>
 <20180521151817.GA19454@redhat.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <d01a150a-7752-f6ce-78f2-17a65c1e6fa5@kernel.dk>
Date: Mon, 21 May 2018 09:36:20 -0600
MIME-Version: 1.0
In-Reply-To: <20180521151817.GA19454@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Mike Snitzer <snitzer@redhat.com>
Cc: Kent Overstreet <kent.overstreet@gmail.com>, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, hch@infradead.org, colyli@suse.de, darrick.wong@oracle.com, clm@fb.com, bacik@fb.com, linux-xfs@vger.kernel.org, drbd-dev@lists.linbit.com, linux-btrfs@vger.kernel.org, linux-raid@vger.kernel.org, neilb@suse.com

On 5/21/18 9:18 AM, Mike Snitzer wrote:
> On Mon, May 21 2018 at 11:09am -0400,
> Jens Axboe <axboe@kernel.dk> wrote:
> 
>> On 5/21/18 9:04 AM, Mike Snitzer wrote:
>>> On Mon, May 21 2018 at 10:52am -0400,
>>> Jens Axboe <axboe@kernel.dk> wrote:
>>>
>>>> On 5/21/18 8:47 AM, Mike Snitzer wrote:
>>>>> On Mon, May 21 2018 at 10:36am -0400,
>>>>> Jens Axboe <axboe@kernel.dk> wrote:
>>>>>
>>>>>> On 5/21/18 8:31 AM, Mike Snitzer wrote:
>>>>>>> On Mon, May 21 2018 at 10:19am -0400,
>>>>>>> Jens Axboe <axboe@kernel.dk> wrote:
>>>>>>>
>>>>>>>> On 5/21/18 8:03 AM, Mike Snitzer wrote:
>>>>>>>>> On Sun, May 20 2018 at  6:25pm -0400,
>>>>>>>>> Kent Overstreet <kent.overstreet@gmail.com> wrote:
>>>>>>>>>
>>>>>>>>>> Jens - this series does the rest of the conversions that Christoph wanted, and
>>>>>>>>>> drops bioset_create().
>>>>>>>>>>
>>>>>>>>>> Only lightly tested, but the changes are pretty mechanical. Based on your
>>>>>>>>>> for-next tree.
>>>>>>>>>
>>>>>>>>> By switching 'mempool_t *' to 'mempool_t' and 'bio_set *' to 'bio_set'
>>>>>>>>> you've altered the alignment of members in data structures.  So I'll
>>>>>>>>> need to audit all the data structures you've modified in DM.
>>>>>>>>>
>>>>>>>>> Could we get the backstory on _why_ you're making this change?
>>>>>>>>> Would go a long way to helping me appreciate why this is a good use of
>>>>>>>>> anyone's time.
>>>>>>>>
>>>>>>>> Yeah, it's in the first series, it gets rid of a pointer indirection.
>>>>>>>
>>>>>>> "Allows mempools to be embedded in other structs, getting rid of a
>>>>>>> pointer indirection from allocation fastpaths."
>>>>>>>
>>>>>>> So this is about using contiguous memory or avoiding partial allocation
>>>>>>> failure?  Or both?
>>>>>>>
>>>>>>> Or more to it?  Just trying to fully appreciate the theory behind the
>>>>>>> perceived associated benefit.
>>>>>>
>>>>>> It's about avoiding a pointer indirection. Instead of having to
>>>>>> follow a pointer to get to that struct, it's simple offset math off
>>>>>> your main structure.
>>>>>>
>>>>>>> I do think the increased risk of these embedded bio_set and mempool_t
>>>>>>> themselves crossing cachelines, or struct members that follow them doing
>>>>>>> so, really detracts from these types of changes.
>>>>>>
>>>>>> Definitely something to look out for, though most of them should be
>>>>>> per-dev structures and not in-flight structures. That makes it a bit
>>>>>> less sensitive. But can't hurt to audit the layouts and adjust if
>>>>>> necessary. This is why it's posted for review :-)
>>>>>
>>>>> This isn't something that is easily caught upfront.  Yes we can all be
>>>>> busy little beavers with pahole to audit alignment.  But chances are
>>>>> most people won't do it.
>>>>>
>>>>> Reality is there is potential for a regression due to false sharing to
>>>>> creep in if a hot struct member suddenly starts straddling a cacheline.
>>>>> That type of NUMA performance killer is pretty insidious and somewhat
>>>>> tedious to hunt down even when looking for it with specialized tools:
>>>>> https://joemario.github.io/blog/2016/09/01/c2c-blog/
>>>>
>>>> IMHO you're making a big deal out of something that should not be.
>>>
>>> I raised an issue that had seemingly not been considered at all.  Not
>>> making a big deal.  Raising it for others' benefit.
>>>
>>>> If the dm bits are that sensitive and cache line honed to perfection
>>>> already due to previous regressions in that area, then it might
>>>> not be a bad idea to have some compile checks for false cacheline
>>>> sharing between sensitive members, or spilling of a sub-struct
>>>> into multiple cachelines.
>>>>
>>>> It's not like this was pushed behind your back. It's posted for
>>>> review. It's quite possible the net change is a win for dm. Let's
>>>> focus on getting it reviewed, rather than pontificate on what
>>>> could potentially go all wrong with this.
>>>
>>> Why are you making this personal?  Or purely about DM?  I'm merely
>>> pointing out this change isn't something that can be given a quick
>>> blanket "looks good".
>>
>> I'm not making this personal at all?! You raised a (valid) concern,
>> I'm merely stating why I don't think it's a high risk issue. I'm
>> assuming your worry is related to dm, as those are the reports
>> that would ultimately land on your desk.
> 
> Then we'll just agree to disagree with what this implies: "It's not like
> this was pushed behind your back."

I'm afraid you've lost me now - it was not pushed behind your back,
it was posted for review, with you on the CC list. Not trying to
be deliberately dense here, I just don't see what our disagreement is.

> Reality is I'm fine with the change.  Just think there is follow-on work
> (now or later) that is needed.

It's not hard to run the quick struct layout checks or alignment. If
there's a concern, that should be done now, instead of being deferred to
later. There's no point merging something that we expect to have
follow-on work. If that's the case, then it should not be merged. There
are no dependencies in the patchset, except that the last patch
obviously can't be applied until all of the previous ones are in.

I took a quick look at the struct mapped_device layout, which I'm
assuming is the most important on the dm side. It's pretty big to
begin with, obviously this makes it bigger since we're now
embedding the bio_sets. On my config, doesn't show any false sharing
that would be problematic, or layout changes that would worry me. FWIW.

-- 
Jens Axboe

