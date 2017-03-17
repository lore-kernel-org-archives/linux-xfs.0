Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48450 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751018AbdCQMXc (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 17 Mar 2017 08:23:32 -0400
Subject: Re: [PATCH 5/8] nowait aio: return on congested block device
References: <20170315215107.5628-1-rgoldwyn@suse.de>
 <20170315215107.5628-6-rgoldwyn@suse.de>
 <eee4683d-9f44-434f-b97f-b0b24c7b3dab@kernel.dk>
From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Message-ID: <71895eba-771b-c816-88b7-b06e19a8e936@suse.de>
Date: Fri, 17 Mar 2017 07:23:26 -0500
MIME-Version: 1.0
In-Reply-To: <eee4683d-9f44-434f-b97f-b0b24c7b3dab@kernel.dk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jens Axboe <axboe@kernel.dk>, Goldwyn Rodrigues <rgoldwyn@suse.com>, linux-fsdevel@vger.kernel.org
Cc: jack@suse.com, hch@infradead.org, linux-block@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, sagi@grimberg.me, avi@scylladb.com, linux-api@vger.kernel.org, willy@infradead.org



On 03/16/2017 09:33 AM, Jens Axboe wrote:
> On 03/15/2017 03:51 PM, Goldwyn Rodrigues wrote:
>> diff --git a/block/blk-core.c b/block/blk-core.c
>> index 0eeb99e..2e5cba2 100644
>> --- a/block/blk-core.c
>> +++ b/block/blk-core.c
>> @@ -2014,7 +2019,7 @@ blk_qc_t generic_make_request(struct bio *bio)
>>  	do {
>>  		struct request_queue *q = bdev_get_queue(bio->bi_bdev);
>>  
>> -		if (likely(blk_queue_enter(q, false) == 0)) {
>> +		if (likely(blk_queue_enter(q, bio_flagged(bio, BIO_NOWAIT)) == 0)) {
>>  			struct bio_list hold;
>>  			struct bio_list lower, same;
>>  
>> @@ -2040,7 +2045,10 @@ blk_qc_t generic_make_request(struct bio *bio)
>>  			bio_list_merge(&bio_list_on_stack, &same);
>>  			bio_list_merge(&bio_list_on_stack, &hold);
>>  		} else {
>> -			bio_io_error(bio);
>> +			if (unlikely(bio_flagged(bio, BIO_NOWAIT)))
>> +				bio_wouldblock_error(bio);
>> +			else
>> +				bio_io_error(bio);
> 
> This doesn't look right. What if the queue is dying, and BIO_NOWAIT just
> happened to be set?

Yes, need a check for that.
> 
> And you're missing wbt_wait() as well as a blocking point. Ditto in
> blk-mq.

Agree.

> 
>> diff --git a/block/blk-mq.c b/block/blk-mq.c
>> index 159187a..942ce8c 100644
>> --- a/block/blk-mq.c
>> +++ b/block/blk-mq.c
>> @@ -1518,6 +1518,8 @@ static blk_qc_t blk_mq_make_request(struct request_queue *q, struct bio *bio)
>>  	rq = blk_mq_sched_get_request(q, bio, bio->bi_opf, &data);
>>  	if (unlikely(!rq)) {
>>  		__wbt_done(q->rq_wb, wb_acct);
>> +		if (bio && bio_flagged(bio, BIO_NOWAIT))
>> +			bio_wouldblock_error(bio);
>>  		return BLK_QC_T_NONE;
>>  	}
>>  
> 
> This seems a little fragile now, since not both paths free the bio.
> 

bio_put() is handled in dio_bio_complete(). However, I am not sure why
there is no bio_endio() call for !rq. IIRC, it was not meant to be.

-- 
Goldwyn
