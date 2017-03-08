Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43992 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751394AbdCHPEP (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 8 Mar 2017 10:04:15 -0500
Subject: Re: [PATCH 5/8] nowait aio: return on congested block device
References: <20170228233610.25456-1-rgoldwyn@suse.de>
 <20170228233610.25456-6-rgoldwyn@suse.de>
 <0d1ba678-69c0-16ce-6c3e-475cd8da203c@grimberg.me>
From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Message-ID: <44cc02b1-f7ac-cbc6-6f09-726ae8225358@suse.de>
Date: Wed, 8 Mar 2017 09:00:09 -0600
MIME-Version: 1.0
In-Reply-To: <0d1ba678-69c0-16ce-6c3e-475cd8da203c@grimberg.me>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Sagi Grimberg <sagi@grimberg.me>, jack@suse.com
Cc: hch@infradead.org, linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, Goldwyn Rodrigues <rgoldwyn@suse.com>



On 03/08/2017 01:03 AM, Sagi Grimberg wrote:
> 
>> -        if (likely(blk_queue_enter(q, false) == 0)) {
>> +        if (likely(blk_queue_enter(q, bio_flagged(bio, BIO_NOWAIT))
>> == 0)) {
>>              ret = q->make_request_fn(q, bio);
> 
> I think that for ->make_request to not block we'd need to set
> BLK_MQ_REQ_NOWAIT in blk_mq_alloc_data to avoid blocking on a tag
> allocation.
> 
> Something like the untested addition below:

I did that in the first series, but there are too many reasons to block
in blk-mq [1]. I dropped blk-mq work in v2.

[1] https://patchwork.kernel.org/patch/9571051/

-- 
Goldwyn
