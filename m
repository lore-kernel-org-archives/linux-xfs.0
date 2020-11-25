Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DED8C56202
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Nov 2020 15:55:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 32DB9205CB
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Nov 2020 15:55:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730602AbgKYPz3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 25 Nov 2020 10:55:29 -0500
Received: from sandeen.net ([63.231.237.45]:49388 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730591AbgKYPz3 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 25 Nov 2020 10:55:29 -0500
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id DBFEA323C1C;
        Wed, 25 Nov 2020 09:55:21 -0600 (CST)
To:     Qinglang Miao <miaoqinglang@huawei.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org
References: <20201125065036.154312-1-miaoqinglang@huawei.com>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH] xfs: check the return value of krealloc() in
 xfs_uuid_mount
Message-ID: <365b952c-7fea-3bc2-55ea-3f6b1c9f9142@sandeen.net>
Date:   Wed, 25 Nov 2020 09:55:27 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20201125065036.154312-1-miaoqinglang@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 11/25/20 12:50 AM, Qinglang Miao wrote:
> krealloc() may fail to expand the memory space.

Even with __GFP_NOFAIL?

  * ``GFP_KERNEL | __GFP_NOFAIL`` - overrides the default allocator behavior
    and all allocation requests will loop endlessly until they succeed.
    This might be really dangerous especially for larger orders.

> Add sanity checks to it,
> and WARN() if that really happened.

As aside, there is no WARN added in this patch for a memory failure.

> Fixes: 771915c4f688 ("xfs: remove kmem_realloc()")
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Qinglang Miao <miaoqinglang@huawei.com>
> ---
>  fs/xfs/xfs_mount.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> index 150ee5cb8..c07f48c32 100644
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -80,9 +80,13 @@ xfs_uuid_mount(
>  	}
>  
>  	if (hole < 0) {
> -		xfs_uuid_table = krealloc(xfs_uuid_table,
> +		uuid_t *if_xfs_uuid_table;
> +		if_xfs_uuid_table = krealloc(xfs_uuid_table,
>  			(xfs_uuid_table_size + 1) * sizeof(*xfs_uuid_table),
>  			GFP_KERNEL | __GFP_NOFAIL);
> +		if (!if_xfs_uuid_table)
> +			goto out_duplicate;

And this would emit "Filesystem has duplicate UUID" which is not correct.

But anyway, the __GFP_NOFAIL in the call makes this all moot AFAICT.

-Eric

> +		xfs_uuid_table = if_xfs_uuid_table;
>  		hole = xfs_uuid_table_size++;
>  	}
>  	xfs_uuid_table[hole] = *uuid;
> 
