Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-it0-f48.google.com ([209.85.214.48]:36917 "EHLO
        mail-it0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756692AbdCXOjq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 24 Mar 2017 10:39:46 -0400
Received: by mail-it0-f48.google.com with SMTP id 190so2786656itm.0
        for <linux-xfs@vger.kernel.org>; Fri, 24 Mar 2017 07:39:45 -0700 (PDT)
Subject: Re: [PATCH 5/8] nowait aio: return on congested block device
References: <20170315215107.5628-1-rgoldwyn@suse.de>
 <20170315215107.5628-6-rgoldwyn@suse.de>
 <eee4683d-9f44-434f-b97f-b0b24c7b3dab@kernel.dk>
 <47d742e9-1343-ef5b-f7d4-29a6e22bef84@suse.de>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <65504798-90c0-6abe-30ea-2faf3824eed8@kernel.dk>
Date: Fri, 24 Mar 2017 08:39:42 -0600
MIME-Version: 1.0
In-Reply-To: <47d742e9-1343-ef5b-f7d4-29a6e22bef84@suse.de>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Goldwyn Rodrigues <rgoldwyn@suse.de>, linux-fsdevel@vger.kernel.org
Cc: jack@suse.com, hch@infradead.org, linux-block@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, sagi@grimberg.me, avi@scylladb.com, linux-api@vger.kernel.org, willy@infradead.org, Goldwyn Rodrigues <rgoldwyn@suse.com>

On 03/24/2017 05:32 AM, Goldwyn Rodrigues wrote:
> 
> 
> On 03/16/2017 09:33 AM, Jens Axboe wrote:
>> On 03/15/2017 03:51 PM, Goldwyn Rodrigues wrote:
>>> diff --git a/block/blk-core.c b/block/blk-core.c
>>> index 0eeb99e..2e5cba2 100644
>>> --- a/block/blk-core.c
>>> +++ b/block/blk-core.c
>>> @@ -2014,7 +2019,7 @@ blk_qc_t generic_make_request(struct bio *bio)
>>>  	do {
>>>  		struct request_queue *q = bdev_get_queue(bio->bi_bdev);
>>>  
>>> -		if (likely(blk_queue_enter(q, false) == 0)) {
>>> +		if (likely(blk_queue_enter(q, bio_flagged(bio, BIO_NOWAIT)) == 0)) {
>>>  			struct bio_list hold;
>>>  			struct bio_list lower, same;
>>>  
>>> @@ -2040,7 +2045,10 @@ blk_qc_t generic_make_request(struct bio *bio)
>>>  			bio_list_merge(&bio_list_on_stack, &same);
>>>  			bio_list_merge(&bio_list_on_stack, &hold);
>>>  		} else {
>>> -			bio_io_error(bio);
>>> +			if (unlikely(bio_flagged(bio, BIO_NOWAIT)))
>>> +				bio_wouldblock_error(bio);
>>> +			else
>>> +				bio_io_error(bio);
>>
>> This doesn't look right. What if the queue is dying, and BIO_NOWAIT just
>> happened to be set?
>>
> 
> Yes, I need to add a condition here to check for blk_queue_dying(). Thanks.
> 
>> And you're missing wbt_wait() as well as a blocking point. Ditto in
>> blk-mq.
> 
> wbt_wait() does not apply to WRITE_ODIRECT

It doesn't _currently_ block for it, but that could change. It should
have an explicit check.

Additionally, the more weird assumptions you make, the more half assed
this will be. The other assumption made here is that only direct IO
would set nonblock. We have to assume that any IO can have NONBLOCK set,
and not make any assumptions about the caller.

-- 
Jens Axboe

