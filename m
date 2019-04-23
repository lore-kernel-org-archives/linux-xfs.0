Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pg1-f195.google.com ([209.85.215.195]:38927 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728075AbfDWN5j (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 23 Apr 2019 09:57:39 -0400
Received: by mail-pg1-f195.google.com with SMTP id l18so7524106pgj.6
        for <linux-xfs@vger.kernel.org>; Tue, 23 Apr 2019 06:57:38 -0700 (PDT)
Subject: Re: [PATCH V3] block: clarify that bio_add_page() and related helpers
 can add multi pages
References: <20190423025104.3843-1-ming.lei@redhat.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <8257f229-30e1-4eb9-ff77-ef0e57b8e77c@kernel.dk>
Date: Tue, 23 Apr 2019 07:57:36 -0600
MIME-Version: 1.0
In-Reply-To: <20190423025104.3843-1-ming.lei@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Ming Lei <ming.lei@redhat.com>
Cc: linux-block@vger.kernel.org, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>

On 4/22/19 8:51 PM, Ming Lei wrote:
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

Applied, thanks.

-- 
Jens Axboe
