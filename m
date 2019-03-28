Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-io1-f65.google.com ([209.85.166.65]:41415 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725875AbfC1OV5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 28 Mar 2019 10:21:57 -0400
Received: by mail-io1-f65.google.com with SMTP id v10so6706240iom.8
        for <linux-xfs@vger.kernel.org>; Thu, 28 Mar 2019 07:21:57 -0700 (PDT)
Subject: Re: [PATCH] block: clarify that bio_add_page() and related helpers
 can add multi pages
References: <20190328035001.26276-1-ming.lei@redhat.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <5258cad3-b324-660f-589f-73eb7fb8fa04@kernel.dk>
Date: Thu, 28 Mar 2019 08:21:55 -0600
MIME-Version: 1.0
In-Reply-To: <20190328035001.26276-1-ming.lei@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Ming Lei <ming.lei@redhat.com>
Cc: linux-block@vger.kernel.org, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>

On 3/27/19 9:50 PM, Ming Lei wrote:
> bio_add_page() and __bio_add_page() are capable of adding pages into
> bio, and now we have at least two such usages alreay:
> 
> 	- __bio_iov_bvec_add_pages()
> 	- nvmet_bdev_execute_rw().
> 
> So update comments on these two helpers.
> 
> The thing is a bit special for __bio_try_merge_page(), given the caller
> needs to know if the new added page is same with the last added page,
> then it isn't safe to pass multi-page in case that 'same_page' is true,
> so adds warning on potential misuse, and updates comment on
> __bio_try_merge_page().

This is going to create a needless conflict between 5.1 and the 5.2
block tree. I haven't pushed the 5.2 tree out yet, plan to do so
this week after I've pushed the current 5.1 patches. Can you respin
this one on top of for-5.2/block when it comes out?

-- 
Jens Axboe
