Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-it0-f67.google.com ([209.85.214.67]:54185 "EHLO
        mail-it0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752803AbeEUQUv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 21 May 2018 12:20:51 -0400
Received: by mail-it0-f67.google.com with SMTP id n64-v6so21699874itb.3
        for <linux-xfs@vger.kernel.org>; Mon, 21 May 2018 09:20:50 -0700 (PDT)
Subject: Re: [PATCH 00/13] convert block layer to bioset_init()/mempool_init()
References: <20180521140348.GA19069@redhat.com>
 <686d7df6-c7d1-48a6-b7ff-48dc8aff6a62@kernel.dk>
 <20180521143132.GB19194@redhat.com>
 <2bbeeb1a-8b99-b06a-eb9b-eb8523c16460@kernel.dk>
 <20180521144703.GA19303@redhat.com>
 <4b343aef-e11c-73ba-1d88-7e73ca838cad@kernel.dk>
 <20180521150439.GA19379@redhat.com>
 <61e30dcf-a01c-f47d-087a-12930caf9aef@kernel.dk>
 <20180521151817.GA19454@redhat.com>
 <d01a150a-7752-f6ce-78f2-17a65c1e6fa5@kernel.dk>
 <20180521160907.GA19553@redhat.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <f9e3714c-b7c9-d5f6-4018-2a87dd5babb2@kernel.dk>
Date: Mon, 21 May 2018 10:20:47 -0600
MIME-Version: 1.0
In-Reply-To: <20180521160907.GA19553@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Mike Snitzer <snitzer@redhat.com>
Cc: Kent Overstreet <kent.overstreet@gmail.com>, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, hch@infradead.org, colyli@suse.de, darrick.wong@oracle.com, clm@fb.com, bacik@fb.com, linux-xfs@vger.kernel.org, drbd-dev@lists.linbit.com, linux-btrfs@vger.kernel.org, linux-raid@vger.kernel.org, neilb@suse.com

On 5/21/18 10:09 AM, Mike Snitzer wrote:
> On Mon, May 21 2018 at 11:36am -0400,
> Jens Axboe <axboe@kernel.dk> wrote:
> 
>> On 5/21/18 9:18 AM, Mike Snitzer wrote:
>>> On Mon, May 21 2018 at 11:09am -0400,
>>> Jens Axboe <axboe@kernel.dk> wrote:
>>>
>>>> On 5/21/18 9:04 AM, Mike Snitzer wrote:
>>>>> On Mon, May 21 2018 at 10:52am -0400,
>>>>> Jens Axboe <axboe@kernel.dk> wrote:
>>>>>
> ...
>>>>>> IMHO you're making a big deal out of something that should not be.
>>>>>
>>>>> I raised an issue that had seemingly not been considered at all.  Not
>>>>> making a big deal.  Raising it for others' benefit.
>>>>>
>>>>>> If the dm bits are that sensitive and cache line honed to perfection
>>>>>> already due to previous regressions in that area, then it might
>>>>>> not be a bad idea to have some compile checks for false cacheline
>>>>>> sharing between sensitive members, or spilling of a sub-struct
>>>>>> into multiple cachelines.
>>>>>>
>>>>>> It's not like this was pushed behind your back. It's posted for
>>>>>> review. It's quite possible the net change is a win for dm. Let's
>>>>>> focus on getting it reviewed, rather than pontificate on what
>>>>>> could potentially go all wrong with this.
>>>>>
>>>>> Why are you making this personal?  Or purely about DM?  I'm merely
>>>>> pointing out this change isn't something that can be given a quick
>>>>> blanket "looks good".
>>>>
>>>> I'm not making this personal at all?! You raised a (valid) concern,
>>>> I'm merely stating why I don't think it's a high risk issue. I'm
>>>> assuming your worry is related to dm, as those are the reports
>>>> that would ultimately land on your desk.
>>>
>>> Then we'll just agree to disagree with what this implies: "It's not like
>>> this was pushed behind your back."
>>
>> I'm afraid you've lost me now - it was not pushed behind your back,
>> it was posted for review, with you on the CC list. Not trying to
>> be deliberately dense here, I just don't see what our disagreement is.
> 
> You're having an off day ;)  Mondays and all?
> 
> I just raised an alignment concern that needs to be considered during
> review by all stakeholders.  Wasn't upset at all.  Maybe my email tone
> came off otherwise?
> 
> And then you got confused by me pointing out how it was weird for you to
> suggest I felt this stuff was pushed behind my back.. and went on to
> think I really think that.  It's almost like you're a confused hypnotist
> seeding me with paranoid dilutions. ;)
> 
> /me waits for Jens to snap his fingers so he can just slowly step away
> from this line of discussion that is solidly dead now...

Mike, wtf are you talking about.

>>> Reality is I'm fine with the change.  Just think there is follow-on work
>>> (now or later) that is needed.
>>
>> It's not hard to run the quick struct layout checks or alignment. If
>> there's a concern, that should be done now, instead of being deferred to
>> later. There's no point merging something that we expect to have
>> follow-on work. If that's the case, then it should not be merged. There
>> are no dependencies in the patchset, except that the last patch
>> obviously can't be applied until all of the previous ones are in.
> 
> Cool, sounds good.
> 
>> I took a quick look at the struct mapped_device layout, which I'm
>> assuming is the most important on the dm side. It's pretty big to
>> begin with, obviously this makes it bigger since we're now
>> embedding the bio_sets. On my config, doesn't show any false sharing
>> that would be problematic, or layout changes that would worry me. FWIW.
> 
> Great, thanks, do you happen to have a tree you can push so others can
> get a quick compile and look at the series fully applied?

I do not, I simply ran a quick analysis of the layout, then applied the
full patchset, and repeated that exercise. Literally a 5 minute thing.
I haven't applied the series, so haven't pushed anything out.

> BTW, I'm upstream DM maintainer but I have a role in caring for related
> subsystems (e.g. block core, etc) in downstream releases.. *cough* RHEL.
> So this alignment concern wasn't ever purely about DM.

I tend to care about that too...

-- 
Jens Axboe

