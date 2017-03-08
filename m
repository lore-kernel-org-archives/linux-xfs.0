Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-it0-f51.google.com ([209.85.214.51]:36797 "EHLO
        mail-it0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753818AbdCHQRi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Mar 2017 11:17:38 -0500
Received: by mail-it0-f51.google.com with SMTP id h10so104342671ith.1
        for <linux-xfs@vger.kernel.org>; Wed, 08 Mar 2017 08:17:37 -0800 (PST)
Subject: Re: [PATCH 5/8] nowait aio: return on congested block device
References: <20170228233610.25456-1-rgoldwyn@suse.de>
 <20170228233610.25456-6-rgoldwyn@suse.de>
 <0d1ba678-69c0-16ce-6c3e-475cd8da203c@grimberg.me>
 <44cc02b1-f7ac-cbc6-6f09-726ae8225358@suse.de>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <a661cdc7-4859-4a39-3037-8036cc8c4712@kernel.dk>
Date: Wed, 8 Mar 2017 09:17:04 -0700
MIME-Version: 1.0
In-Reply-To: <44cc02b1-f7ac-cbc6-6f09-726ae8225358@suse.de>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Goldwyn Rodrigues <rgoldwyn@suse.de>, Sagi Grimberg <sagi@grimberg.me>, jack@suse.com
Cc: hch@infradead.org, linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, Goldwyn Rodrigues <rgoldwyn@suse.com>

On 03/08/2017 08:00 AM, Goldwyn Rodrigues wrote:
> 
> 
> On 03/08/2017 01:03 AM, Sagi Grimberg wrote:
>>
>>> -        if (likely(blk_queue_enter(q, false) == 0)) {
>>> +        if (likely(blk_queue_enter(q, bio_flagged(bio, BIO_NOWAIT))
>>> == 0)) {
>>>              ret = q->make_request_fn(q, bio);
>>
>> I think that for ->make_request to not block we'd need to set
>> BLK_MQ_REQ_NOWAIT in blk_mq_alloc_data to avoid blocking on a tag
>> allocation.
>>
>> Something like the untested addition below:
> 
> I did that in the first series, but there are too many reasons to block
> in blk-mq [1]. I dropped blk-mq work in v2.

That's complete nonsense, there are no more places in blk-mq that will
block that in the legacy path. Most of the examples from your URL:

> [1] https://patchwork.kernel.org/patch/9571051/

are not blk-mq, but writeback throttling, and drivers that explicitly
hook into ->make_request_fn.

As others have mentioned, it's a total non-starter to focus on the
deprecated IO path and just ignore the new one. Back to the drawing
board.

-- 
Jens Axboe

