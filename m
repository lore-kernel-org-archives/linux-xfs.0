Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33640 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725888AbfDWHQh (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 23 Apr 2019 03:16:37 -0400
Subject: Re: [PATCH V3] block: clarify that bio_add_page() and related helpers
 can add multi pages
References: <20190423025104.3843-1-ming.lei@redhat.com>
From: Hannes Reinecke <hare@suse.de>
Message-ID: <09668d6f-7e5b-d19a-4e20-f209c11eaa19@suse.de>
Date: Tue, 23 Apr 2019 09:16:35 +0200
MIME-Version: 1.0
In-Reply-To: <20190423025104.3843-1-ming.lei@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>

On 4/23/19 4:51 AM, Ming Lei wrote:
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
> 
> Cc: linux-xfs@vger.kernel.org
> Cc: linux-fsdevel@vger.kernel.org
> Cc: Christoph Hellwig <hch@infradead.org>
> Reviewed-by: Christoph Hellwig <hch@infradead.org>
> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> ---
> V3:
> 	- fix build failure caused by rebase via 'patch -p1 <'
> V2:
> 	- add Reviewed-by tag
> 	- rebase on latest for-5.2/block
>   block/bio.c | 26 +++++++++++++++-----------
>   1 file changed, 15 insertions(+), 11 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Mary Higgins, Sri Rasiah
HRB 21284 (AG Nürnberg)
