Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-io0-f193.google.com ([209.85.223.193]:35445 "EHLO
        mail-io0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751078AbeEBOUD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 2 May 2018 10:20:03 -0400
Received: by mail-io0-f193.google.com with SMTP id g1-v6so8304316iob.2
        for <linux-xfs@vger.kernel.org>; Wed, 02 May 2018 07:20:02 -0700 (PDT)
Subject: Re: [PATCH 2/2] xfs: add 'discard_sync' mount flag
References: <1525102372-8430-1-git-send-email-axboe@kernel.dk>
 <1525102372-8430-3-git-send-email-axboe@kernel.dk>
 <20180430213120.GD13766@dastard>
 <c6e9db38-51d3-ae13-58cb-2b815ddd5891@kernel.dk>
 <20180430222852.GF13766@dastard>
 <87589bc6-e5f5-6247-485f-2237e0c493ad@kernel.dk>
 <799de885-34f0-0cae-ae64-bf7bc194965d@kernel.dk>
 <20180430232319.GV23861@dastard>
 <bacc9dbb-c38b-9258-cd95-7582c27a97f7@kernel.dk> <yq1wowm7oo8.fsf@oracle.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <4f3b8286-7ef3-c8c4-01f2-47508ee5ab16@kernel.dk>
Date: Wed, 2 May 2018 08:20:00 -0600
MIME-Version: 1.0
In-Reply-To: <yq1wowm7oo8.fsf@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org, linux-block@vger.kernel.org, hch@lst.de

On 5/1/18 8:54 PM, Martin K. Petersen wrote:
> 
> Jens,
> 
>> diff --git a/block/blk-wbt.h b/block/blk-wbt.h
>> index a232c98fbf4d..aec5bc82d580 100644
>> --- a/block/blk-wbt.h
>> +++ b/block/blk-wbt.h
>> @@ -14,12 +14,17 @@ enum wbt_flags {
>>  	WBT_TRACKED		= 1,	/* write, tracked for throttling */
>>  	WBT_READ		= 2,	/* read */
>>  	WBT_KSWAPD		= 4,	/* write, from kswapd */
>> +	WBT_TRIM		= 8,
> 
> The term TRIM does not apply to NVMe, nor SCSI. Please call it
> WBT_DISCARD.

Sure, I can do that.

-- 
Jens Axboe

