Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-io0-f176.google.com ([209.85.223.176]:42475 "EHLO
        mail-io0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752699AbeEGPvG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 May 2018 11:51:06 -0400
Received: by mail-io0-f176.google.com with SMTP id a10-v6so34518047ioc.9
        for <linux-xfs@vger.kernel.org>; Mon, 07 May 2018 08:51:06 -0700 (PDT)
Subject: Re: [PATCH 3/3] blk-wbt: throttle discards like background writes
References: <1525360843-6504-1-git-send-email-axboe@kernel.dk>
 <1525360843-6504-4-git-send-email-axboe@kernel.dk>
 <20180507095746.GC25210@lst.de>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <d2657561-8c24-9a29-6aa1-01e6548a0d31@kernel.dk>
Date: Mon, 7 May 2018 09:51:03 -0600
MIME-Version: 1.0
In-Reply-To: <20180507095746.GC25210@lst.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-block@vger.kernel.org, linux-xfs@vger.kernel.org, dchinner@redhat.com

On 5/7/18 3:57 AM, Christoph Hellwig wrote:
>> -static inline struct rq_wait *get_rq_wait(struct rq_wb *rwb, bool is_kswapd)
>> +static inline struct rq_wait *get_rq_wait(struct rq_wb *rwb, bool is_trim,
>> +					  bool is_kswapd)
>>  {
>> -	return &rwb->rq_wait[is_kswapd];
>> +	if (is_trim)
>> +		return &rwb->rq_wait[WBT_REQ_DISCARD];
>> +	else if (is_kswapd)
>> +		return &rwb->rq_wait[WBT_REQ_KSWAPD];
>> +	else
>> +		return &rwb->rq_wait[WBT_REQ_BG];
>>  }
> 
> Wouldn't it be more useful to pass a enum wbt_flag here?
> 
> Or just have a wbt_flag_to_wait_idx helper and do the array indexing
> in the callers?

It would be cleaner, but we don't have wbt_flag everywhere we need it.
Though I guess we could swap the masking in wbt_wait() and do it
before the __wbt_wait() call, and just use that. Since we only do
the indexing in that one spot, I don't think we should add a helper.

> 
>>  {
>>  	const int op = bio_op(bio);
>>  
>> -	/*
>> -	 * If not a WRITE, do nothing
>> -	 */
>> -	if (op != REQ_OP_WRITE)
>> -		return false;
>> +	if (op == REQ_OP_WRITE) {
>> +		/*
>> +		 * Don't throttle WRITE_ODIRECT
>> +		 */
>> +		if ((bio->bi_opf & (REQ_SYNC | REQ_IDLE)) ==
>> +		    (REQ_SYNC | REQ_IDLE))
>> +			return false;
>>  
>> -	/*
>> -	 * Don't throttle WRITE_ODIRECT
>> -	 */
>> -	if ((bio->bi_opf & (REQ_SYNC | REQ_IDLE)) == (REQ_SYNC | REQ_IDLE))
>> -		return false;
>> +		return true;
>> +	} else if (op == REQ_OP_DISCARD)
>> +		return true;
> 
> what about:
> 
> 	switch (bio_op(bio)) {
> 	case REQ_OP_WRITE:
> 		/*
> 		 * Don't throttle WRITE_ODIRECT
> 		 */
> 		if ((bio->bi_opf & (REQ_SYNC | REQ_IDLE)) ==
> 		    (REQ_SYNC | REQ_IDLE))
> 			return false;
> 		/*FALLTHROUGH*/
> 	case REQ_OP_DISCARD:
> 		return true;
> 	default:
> 		return false;

Sure, I can do that. I'll spin a v2.

-- 
Jens Axboe

