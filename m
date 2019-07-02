Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pg1-f195.google.com ([209.85.215.195]:33108 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726951AbfGBBym (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 1 Jul 2019 21:54:42 -0400
Received: by mail-pg1-f195.google.com with SMTP id m4so6878490pgk.0
        for <linux-xfs@vger.kernel.org>; Mon, 01 Jul 2019 18:54:42 -0700 (PDT)
Subject: Re: [PATCH V2] block: fix .bi_size overflow
References: <20190701071446.22028-1-ming.lei@redhat.com>
 <8db73c5d-a0e2-00c9-59ab-64314097db26@kernel.dk>
 <bd45842a-e0fd-28a7-ac79-96f7cb9b66e4@kernel.dk>
 <8b8dc953-e663-e3d8-b991-9d8dba9270be@kernel.dk>
 <20190702013829.GB8356@ming.t460p>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <7c3987b1-ac39-276b-da6d-511bfc4485bf@kernel.dk>
Date: Mon, 1 Jul 2019 19:54:38 -0600
MIME-Version: 1.0
In-Reply-To: <20190702013829.GB8356@ming.t460p>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Ming Lei <ming.lei@redhat.com>
Cc: linux-block@vger.kernel.org, Liu Yiding <liuyd.fnst@cn.fujitsu.com>, kernel test robot <rong.a.chen@intel.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@lst.de>, stable@vger.kernel.org

On 7/1/19 7:38 PM, Ming Lei wrote:
> On Mon, Jul 01, 2019 at 08:20:13AM -0600, Jens Axboe wrote:
>> On 7/1/19 8:14 AM, Jens Axboe wrote:
>>> On 7/1/19 8:05 AM, Jens Axboe wrote:
>>>> On 7/1/19 1:14 AM, Ming Lei wrote:
>>>>> 'bio->bi_iter.bi_size' is 'unsigned int', which at most hold 4G - 1
>>>>> bytes.
>>>>>
>>>>> Before 07173c3ec276 ("block: enable multipage bvecs"), one bio can
>>>>> include very limited pages, and usually at most 256, so the fs bio
>>>>> size won't be bigger than 1M bytes most of times.
>>>>>
>>>>> Since we support multi-page bvec, in theory one fs bio really can
>>>>> be added > 1M pages, especially in case of hugepage, or big writeback
>>>>> with too many dirty pages. Then there is chance in which .bi_size
>>>>> is overflowed.
>>>>>
>>>>> Fixes this issue by using bio_full() to check if the added segment may
>>>>> overflow .bi_size.
>>>>
>>>> Any objections to queuing this up for 5.3? It's not a new regression
>>>> this series.
>>>
>>> I took a closer look, and applied for 5.3 and removed the stable tag.
>>> We'll need to apply your patch for stable, and I added an adapted
>>> one for 5.3. I don't want a huge merge hassle because of this.
>>
>> OK, so we still get conflicts with that, due to both the same page
>> merge fix, and Christophs 5.3 changes.
>>
>> I ended up pulling in 5.2-rc6 in for-5.3/block, which resolves at
>> least most of it, and kept the stable tag since now it's possible
>> to backport without too much trouble.
> 
> Thanks for merging it.
> 
> BTW, we need the -stable tag, since Yiding has test case to reproduce
> the issue reliably, which just needs one big machine with enough memory,
> and fast storage, I guess.

Just to be clear, I wasn't saying it shouldn't go to stable. But it's
pointless to mark something for stable if you know it'll reject, and
won't be easily fixable by the person applying it. For that case, it's
better to NOT CC stable, and just send in an appropriate patch instead.

But that's all moot now, as per last section in the email you are
replying to.

-- 
Jens Axboe
