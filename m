Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-it1-f195.google.com ([209.85.166.195]:36776 "EHLO
        mail-it1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729199AbfC2Oru (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 29 Mar 2019 10:47:50 -0400
Received: by mail-it1-f195.google.com with SMTP id y10so2310892itc.1
        for <linux-xfs@vger.kernel.org>; Fri, 29 Mar 2019 07:47:50 -0700 (PDT)
Subject: Re: [PATCH v3 2/3] block: verify data when endio
References: <20190329142346.1677-1-bob.liu@oracle.com>
 <20190329142346.1677-3-bob.liu@oracle.com>
 <41c8688a-65bd-96ac-9b23-4facd0ade4a7@kernel.dk>
 <73ecbb57-fd99-5df3-8859-e218b830363b@oracle.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <c3caf423-99e7-8c47-684f-1b0ca32e627c@kernel.dk>
Date: Fri, 29 Mar 2019 08:47:47 -0600
MIME-Version: 1.0
In-Reply-To: <73ecbb57-fd99-5df3-8859-e218b830363b@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Bob Liu <bob.liu@oracle.com>, linux-block@vger.kernel.org
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, martin.petersen@oracle.com, shirley.ma@oracle.com, allison.henderson@oracle.com, david@fromorbit.com, darrick.wong@oracle.com, hch@infradead.org, adilger@dilger.ca, tytso@mit.edu

On 3/29/19 8:40 AM, Bob Liu wrote:
> On 3/29/19 10:28 PM, Jens Axboe wrote:
>> On 3/29/19 8:23 AM, Bob Liu wrote:
>>> diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
>>> index d66bf5f32610..e9f25f162138 100644
>>> --- a/include/linux/blk_types.h
>>> +++ b/include/linux/blk_types.h
>>> @@ -18,6 +18,7 @@ struct block_device;
>>>  struct io_context;
>>>  struct cgroup_subsys_state;
>>>  typedef void (bio_end_io_t) (struct bio *);
>>> +typedef int (bio_verifier_t) (struct bio *);
>>>  
>>>  /*
>>>   * Block error status values.  See block/blk-core:blk_errors for the details.
>>> @@ -187,6 +188,8 @@ struct bio {
>>>  		struct bio_integrity_payload *bi_integrity; /* data integrity */
>>>  #endif
>>>  	};
>>> +	bio_verifier_t		*bi_verifier;	/* verify callback when endio */
>>> +	struct work_struct      bi_work;	/* I/O completion */
>>>  
>>>  	unsigned short		bi_vcnt;	/* how many bio_vec's */
>>
>> I told you this for the initial posting, and the objection still stands.
>> Adding 40 bytes to struct bio is a no-go.
>>
> 
> Yes, I know that.
> Already list in Todo:
> - union with "struct bio_integrity_payload *bi_integrity" to save bio space.

As written in the other email, that solves _nothing_. So in terms of RFC, I'm
letting you know that adding anything to the bio for this issue is going to
be a non-starter.

> This is only a rfc patch, because not sure any other objection of this
> passdown-verify solution..  Will consider more about the bio space if
> there is agreement of the passdown-verify way.

OK, also see other mail on a potential route for the bio space that
doesn't increase the size for the bio at all.

You and Martin keep claiming this isn't an issue, but it is. Hence I'm
just making it as clear as I can that bumping the bio size for this
isn't going to fly.

-- 
Jens Axboe
