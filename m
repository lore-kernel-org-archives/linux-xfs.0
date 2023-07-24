Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DBBDC001B0
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Jul 2023 22:35:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229907AbjGXWfM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Jul 2023 18:35:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbjGXWfL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Jul 2023 18:35:11 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A8C010D
        for <linux-xfs@vger.kernel.org>; Mon, 24 Jul 2023 15:35:09 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id d9443c01a7336-1bbadf9ed37so1447095ad.0
        for <linux-xfs@vger.kernel.org>; Mon, 24 Jul 2023 15:35:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1690238109; x=1690842909;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=i3boneSxJbiE3qpdBMYJnhFWAC2554MDJ4HCjX1uCfo=;
        b=KT847VrES4C/BVrqSdGvAZ5A4PKNRcwkhp8luP4eqXB6ZWRFAEOo1ZKxSeVRq+gaCM
         mYoCR9NDrzGsFm0RmZndu1uoTCoHXW3DMtHIWkGHLrLIQWqYI1jQO7BTagS9z9YKVf3o
         khiciLIzD3bh53UmFsoJqCIhipVhPrmmYOeNIhQFkHTm8ikATWV5JWaXGUSJo5faEZFX
         o7e8rgRX+irtHvtQBW5WnkjOKzvEskA+Az+/yJWp5TcuT1wrJgbUz4QW4P7rtgF2u8Dd
         h92b9MuLtE8ELoWu5h6dW0MfP4cqILHonTls/oc1+n1mlxVwk4nqklDItM7zOsQOjTS1
         pYJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690238109; x=1690842909;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=i3boneSxJbiE3qpdBMYJnhFWAC2554MDJ4HCjX1uCfo=;
        b=c0sN9yDNzrsFieqjqTEo6sSJ5VWx6cJTy26EvT9XLIc5A8FKfzDCIYiI0umlNDjNP1
         5PoFhwslt5yziouNlde2v5BxQELPfzVKNXhZbl4X1gJ1xv8qgj8B7j92TJ94weXhLMIG
         j8fFjPMa3tpghi9x+J8x9aXbOHAWes3ZIHPOUAyy/qQPn9nuMaJri1kjnY5Xn8B1wMsM
         X1hO2Kb/O8AbezVrZZcxovWPMqVLt3nn5MKwr7HeVYjIlUJJmRSDerE8k5N8MF3S2/uq
         QTURMS3MvtSpQsJArop2mSqQ8VS6TJ/lqFEB5K6uE+oqCgztjtq7qoWztJcReZsBempw
         vhZg==
X-Gm-Message-State: ABy/qLY6dqOYhh+IcA52dbK4WMrOGShFFYc7WL/H/8312vStKNAXC3Lf
        WIi7l98c1LyeHoNwiBW4qk+byw==
X-Google-Smtp-Source: APBJJlEDphr1kKHQVLiXjUCYvpRPSle7C/Th17v4M5bYvHGGlBAV4RMQHlchi3g3Lu532lBN0EUPuw==
X-Received: by 2002:a17:902:e849:b0:1b8:35fa:cdcc with SMTP id t9-20020a170902e84900b001b835facdccmr14915063plg.5.1690238108949;
        Mon, 24 Jul 2023 15:35:08 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id n17-20020a170902d2d100b001b9cb27e07dsm1327569plc.45.2023.07.24.15.35.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Jul 2023 15:35:08 -0700 (PDT)
Message-ID: <bc587f95-3f5b-f323-f530-a7785e08da89@kernel.dk>
Date:   Mon, 24 Jul 2023 16:35:07 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH 4/8] iomap: completed polled IO inline
Content-Language: en-US
To:     Dave Chinner <david@fromorbit.com>
Cc:     io-uring@vger.kernel.org, linux-xfs@vger.kernel.org, hch@lst.de,
        andres@anarazel.de
References: <20230720181310.71589-1-axboe@kernel.dk>
 <20230720181310.71589-5-axboe@kernel.dk>
 <ZLr8D60gYqDrHl21@dread.disaster.area>
 <fe2754d6-04d0-ce69-d7b2-6e6af7cfb140@kernel.dk>
 <ZLxgrnvsVPJYBJ1L@dread.disaster.area>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <ZLxgrnvsVPJYBJ1L@dread.disaster.area>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 7/22/23 5:05?PM, Dave Chinner wrote:
> On Fri, Jul 21, 2023 at 09:10:57PM -0600, Jens Axboe wrote:
>> On 7/21/23 3:43?PM, Dave Chinner wrote:
>>> On Thu, Jul 20, 2023 at 12:13:06PM -0600, Jens Axboe wrote:
>>>> Polled IO is only allowed for conditions where task completion is safe
>>>> anyway, so we can always complete it inline. This cannot easily be
>>>> checked with a submission side flag, as the block layer may clear the
>>>> polled flag and turn it into a regular IO instead. Hence we need to
>>>> check this at completion time. If REQ_POLLED is still set, then we know
>>>> that this IO was successfully polled, and is completing in task context.
>>>>
>>>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>>> ---
>>>>  fs/iomap/direct-io.c | 14 ++++++++++++--
>>>>  1 file changed, 12 insertions(+), 2 deletions(-)
>>>>
>>>> diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
>>>> index 9f97d0d03724..c3ea1839628f 100644
>>>> --- a/fs/iomap/direct-io.c
>>>> +++ b/fs/iomap/direct-io.c
>>>> @@ -173,9 +173,19 @@ void iomap_dio_bio_end_io(struct bio *bio)
>>>>  	}
>>>>  
>>>>  	/*
>>>> -	 * Flagged with IOMAP_DIO_INLINE_COMP, we can complete it inline
>>>> +	 * Flagged with IOMAP_DIO_INLINE_COMP, we can complete it inline.
>>>> +	 * Ditto for polled requests - if the flag is still at completion
>>>> +	 * time, then we know the request was actually polled and completion
>>>> +	 * is called from the task itself. This is why we need to check it
>>>> +	 * here rather than flag it at issue time.
>>>>  	 */
>>>> -	if (dio->flags & IOMAP_DIO_INLINE_COMP) {
>>>> +	if ((dio->flags & IOMAP_DIO_INLINE_COMP) || (bio->bi_opf & REQ_POLLED)) {
>>>
>>> This still smells wrong to me. Let me see if I can work out why...
>>>
>>> <spelunk!>
>>>
>>> When we set up the IO in iomap_dio_bio_iter(), we do this:
>>>
>>>         /*
>>>          * We can only poll for single bio I/Os.
>>>          */
>>>         if (need_zeroout ||
>>>             ((dio->flags & IOMAP_DIO_WRITE) && pos >= i_size_read(inode)))
>>>                 dio->iocb->ki_flags &= ~IOCB_HIPRI;
>>>
>>> The "need_zeroout" covers writes into unwritten regions that require
>>> conversion at IO completion, and the latter check is for writes
>>> extending EOF. i.e. this covers the cases where we have dirty
>>> metadata for this specific write and so may need transactions or
>>> journal/metadata IO during IO completion.
>>>
>>> The only case it doesn't cover is clearing IOCB_HIPRI for O_DSYNC IO
>>> that may require a call to generic_write_sync() in completion. That
>>> is, if we aren't using FUA, will not have IOMAP_DIO_INLINE_COMP set,
>>> but still do polled IO.
>>>
>>> I think this is a bug. We don't want to be issuing more IO in
>>> REQ_POLLED task context during IO completion, and O_DSYNC IO
>>> completion for non-FUA IO requires a journal flush and that can
>>> issue lots of journal IO and wait on it in completion process.
>>>
>>> Hence I think we should only be setting REQ_POLLED in the cases
>>> where IOCB_HIPRI and IOMAP_DIO_INLINE_COMP are both set.  If
>>> IOMAP_DIO_INLINE_COMP is set on the dio, then it doesn't matter what
>>> context we are in at completion time or whether REQ_POLLED was set
>>> or cleared during the IO....
>>>
>>> That means the above check should be:
>>>
>>>         /*
>>>          * We can only poll for single bio I/Os that can run inline
>>> 	 * completion.
>>>          */
>>>         if (need_zeroout ||
>>> 	    (iocb_is_dsync(dio->iocb) && !use_fua) ||
>>>             ((dio->flags & IOMAP_DIO_WRITE) && pos >= i_size_read(inode)))
>>>                 dio->iocb->ki_flags &= ~IOCB_HIPRI;
>>
>> Looks like you are right, it would not be a great idea to handle that
>> off polled IO completion. It'd work just fine, but anything generating
>> more IO should go to a helper. I'll make that change.
>>
>>> or if we change the logic such that calculate IOMAP_DIO_INLINE_COMP
>>> first:
>>>
>>> 	if (!(dio->flags & IOMAP_DIO_INLINE_COMP))
>>> 		dio->iocb->ki_flags &= ~IOCB_HIPRI;
>>>
>>> Then we don't need to care about polled IO on the completion side at
>>> all at the iomap layer because it doesn't change the completion
>>> requirements at all...
>>
>> That still isn't true, because you can still happily issue as polled IO
>> and get it cleared and now have an IRQ based completion. This would work
>> for most cases, but eg xfs dio end_io handler will grab:
>>
>> spin_lock(&ip->i_flags_lock);
>>
>> if the inode got truncated. Maybe that can't happen because we did
>> inode_dio_begin() higher up?
> 
> Yes, truncate, hole punch, etc block on inode_dio_wait() with the
> i_rwsem held which means it blocks new DIO submissions and waits
> until all in-flight DIO before the truncate operation starts.
> inode_dio_complete() does not get called until after the filesystem
> ->endio completion has run, so there's no possibility of
> truncate-like operations actually racing with DIO completion at
> all...

OK so that part is all fine at least. This means we'll never hit that
lock, as we know we'll be within the range.

>> Still seems saner to check for the polled
>> flag at completion to me...
> 
> I disagree. If truncate (or anything that removes extents or reduces
> inode size) is running whilst DIO to that range is still in
> progress, we have a use-after-free situation that will cause data
> and/or filesystem corruption. It's just not a safe thing to allow,
> so we prevent it from occurring at a high level in the filesystem
> and the result is that low level IO code just doesn't need to
> care about races with layout/size changing operations...

I looked at the rest of the completion side, to ensure that writes would
be sane. And one thing that is problematic _without_ checking for POLLED
is invalidating inode pages post IO completion. That can happen if
someone is doing buffered IO on the same file, which arguably is silly
and not really supported, but we need to do it and it needs task context
to do so.

So I think I'll just simplify things a bit - get rid of the inline
completion for writes, and only have them be doable via CALLER_COMP
(which was DEFER_COMP before). Then we always have task context. This
doesn't change the other side, we'll still only do them for the cases
outlined. But it does mean that non-CALLER_COMP can't ever set
INLINE_COMP, and that latter flag just goes away.

-- 
Jens Axboe

