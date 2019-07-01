Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-io1-f67.google.com ([209.85.166.67]:42940 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729437AbfGAOUQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 1 Jul 2019 10:20:16 -0400
Received: by mail-io1-f67.google.com with SMTP id u19so20654676ior.9
        for <linux-xfs@vger.kernel.org>; Mon, 01 Jul 2019 07:20:16 -0700 (PDT)
Subject: Re: [PATCH V2] block: fix .bi_size overflow
From: Jens Axboe <axboe@kernel.dk>
References: <20190701071446.22028-1-ming.lei@redhat.com>
 <8db73c5d-a0e2-00c9-59ab-64314097db26@kernel.dk>
 <bd45842a-e0fd-28a7-ac79-96f7cb9b66e4@kernel.dk>
Message-ID: <8b8dc953-e663-e3d8-b991-9d8dba9270be@kernel.dk>
Date: Mon, 1 Jul 2019 08:20:13 -0600
MIME-Version: 1.0
In-Reply-To: <bd45842a-e0fd-28a7-ac79-96f7cb9b66e4@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Ming Lei <ming.lei@redhat.com>
Cc: linux-block@vger.kernel.org, Liu Yiding <liuyd.fnst@cn.fujitsu.com>, kernel test robot <rong.a.chen@intel.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@lst.de>, stable@vger.kernel.org

On 7/1/19 8:14 AM, Jens Axboe wrote:
> On 7/1/19 8:05 AM, Jens Axboe wrote:
>> On 7/1/19 1:14 AM, Ming Lei wrote:
>>> 'bio->bi_iter.bi_size' is 'unsigned int', which at most hold 4G - 1
>>> bytes.
>>>
>>> Before 07173c3ec276 ("block: enable multipage bvecs"), one bio can
>>> include very limited pages, and usually at most 256, so the fs bio
>>> size won't be bigger than 1M bytes most of times.
>>>
>>> Since we support multi-page bvec, in theory one fs bio really can
>>> be added > 1M pages, especially in case of hugepage, or big writeback
>>> with too many dirty pages. Then there is chance in which .bi_size
>>> is overflowed.
>>>
>>> Fixes this issue by using bio_full() to check if the added segment may
>>> overflow .bi_size.
>>
>> Any objections to queuing this up for 5.3? It's not a new regression
>> this series.
> 
> I took a closer look, and applied for 5.3 and removed the stable tag.
> We'll need to apply your patch for stable, and I added an adapted
> one for 5.3. I don't want a huge merge hassle because of this.

OK, so we still get conflicts with that, due to both the same page
merge fix, and Christophs 5.3 changes.

I ended up pulling in 5.2-rc6 in for-5.3/block, which resolves at
least most of it, and kept the stable tag since now it's possible
to backport without too much trouble.

-- 
Jens Axboe
