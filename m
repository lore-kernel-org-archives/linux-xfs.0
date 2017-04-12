Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49446 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752401AbdDLSbw (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 12 Apr 2017 14:31:52 -0400
Subject: Re: [PATCH 5/9] nowait aio: return on congested block device
References: <20170411142619.27205-1-rgoldwyn@suse.de>
 <20170411142619.27205-6-rgoldwyn@suse.de>
 <20170412083625.GB22363@infradead.org>
From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Message-ID: <7fba3538-8c91-20e5-63f1-6e063caaaffb@suse.de>
Date: Wed, 12 Apr 2017 13:31:43 -0500
MIME-Version: 1.0
In-Reply-To: <20170412083625.GB22363@infradead.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, jack@suse.com, linux-block@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, sagi@grimberg.me, avi@scylladb.com, axboe@kernel.dk, linux-api@vger.kernel.org, willy@infradead.org, tom.leiming@gmail.com, Goldwyn Rodrigues <rgoldwyn@suse.com>



On 04/12/2017 03:36 AM, Christoph Hellwig wrote:
> As mentioned last time around, this should be a REQ_NOWAIT flag so
> that it can be easily passed dow? n to the request layer.
> 
>> +static inline void bio_wouldblock_error(struct bio *bio)
>> +{
>> +	bio->bi_error = -EAGAIN;
>> +	bio_endio(bio);
>> +}
> 
> Please skip this helper..

Why? It is being called three times?
I am incorporating all the rest of the comments, besides this one. Thanks.

> 
>> +#define QUEUE_FLAG_NOWAIT      28	/* queue supports BIO_NOWAIT */
> 
> Please make the flag name a little more descriptive, this sounds like
> it will never wait.
> 

-- 
Goldwyn
