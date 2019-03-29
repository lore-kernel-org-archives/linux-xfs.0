Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:50444 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729021AbfC2OlM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 29 Mar 2019 10:41:12 -0400
Subject: Re: [PATCH v3 2/3] block: verify data when endio
References: <20190329142346.1677-1-bob.liu@oracle.com>
 <20190329142346.1677-3-bob.liu@oracle.com>
 <41c8688a-65bd-96ac-9b23-4facd0ade4a7@kernel.dk>
From: Bob Liu <bob.liu@oracle.com>
Message-ID: <73ecbb57-fd99-5df3-8859-e218b830363b@oracle.com>
Date: Fri, 29 Mar 2019 22:40:26 +0800
MIME-Version: 1.0
In-Reply-To: <41c8688a-65bd-96ac-9b23-4facd0ade4a7@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, martin.petersen@oracle.com, shirley.ma@oracle.com, allison.henderson@oracle.com, david@fromorbit.com, darrick.wong@oracle.com, hch@infradead.org, adilger@dilger.ca, tytso@mit.edu

On 3/29/19 10:28 PM, Jens Axboe wrote:
> On 3/29/19 8:23 AM, Bob Liu wrote:
>> diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
>> index d66bf5f32610..e9f25f162138 100644
>> --- a/include/linux/blk_types.h
>> +++ b/include/linux/blk_types.h
>> @@ -18,6 +18,7 @@ struct block_device;
>>  struct io_context;
>>  struct cgroup_subsys_state;
>>  typedef void (bio_end_io_t) (struct bio *);
>> +typedef int (bio_verifier_t) (struct bio *);
>>  
>>  /*
>>   * Block error status values.  See block/blk-core:blk_errors for the details.
>> @@ -187,6 +188,8 @@ struct bio {
>>  		struct bio_integrity_payload *bi_integrity; /* data integrity */
>>  #endif
>>  	};
>> +	bio_verifier_t		*bi_verifier;	/* verify callback when endio */
>> +	struct work_struct      bi_work;	/* I/O completion */
>>  
>>  	unsigned short		bi_vcnt;	/* how many bio_vec's */
> 
> I told you this for the initial posting, and the objection still stands.
> Adding 40 bytes to struct bio is a no-go.
> 

Yes, I know that.
Already list in Todo:
- union with "struct bio_integrity_payload *bi_integrity" to save bio space.

This is only a rfc patch, because not sure any other objection of this passdown-verify solution..
Will consider more about the bio space if there is agreement of the passdown-verify way.

Thanks,
Bob
