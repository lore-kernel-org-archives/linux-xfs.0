Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0DADC433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 10 Nov 2021 17:12:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A5CA661241
	for <linux-xfs@archiver.kernel.org>; Wed, 10 Nov 2021 17:12:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231487AbhKJRPd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 10 Nov 2021 12:15:33 -0500
Received: from sandeen.net ([63.231.237.45]:52332 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229531AbhKJRPd (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 10 Nov 2021 12:15:33 -0500
Received: from [10.0.0.146] (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 2C0814918;
        Wed, 10 Nov 2021 11:12:43 -0600 (CST)
Message-ID: <880e9a71-0f4d-ab3a-f3ca-23b494b21a13@sandeen.net>
Date:   Wed, 10 Nov 2021 11:12:44 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.0
Content-Language: en-US
To:     "Darrick J. Wong" <djwong@kernel.org>,
        Eric Sandeen <esandeen@redhat.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
References: <a98ed48b-7297-34af-2a2a-795b15b35f12@redhat.com>
 <20211110023405.GY24307@magnolia>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH 4/3] xfs: sync xfs_btree_split macros with userspace
 libxfs
In-Reply-To: <20211110023405.GY24307@magnolia>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 11/9/21 8:34 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Sync this one last bit of discrepancy between kernel and userspace
> libxfs.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

I was #ifdef before #ifdef was cool, man.

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

(tiny thing see below, use your discretion)

> ---
>   fs/xfs/libxfs/xfs_btree.c |    4 ++++
>   1 file changed, 4 insertions(+)
> 
> diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
> index b4e19aacb9de..d8a859bc797a 100644
> --- a/fs/xfs/libxfs/xfs_btree.c
> +++ b/fs/xfs/libxfs/xfs_btree.c
> @@ -2785,6 +2785,7 @@ __xfs_btree_split(
>   	return error;
>   }
>   
> +#ifdef __KERNEL__
>   struct xfs_btree_split_args {
>   	struct xfs_btree_cur	*cur;
>   	int			level;
> @@ -2870,6 +2871,9 @@ xfs_btree_split(
>   	destroy_work_on_stack(&args.work);
>   	return args.result;
>   }
> +#else /* !KERNEL */

If you wanted to change this to /* !__KERNEL__ */ to be spot-on, I wouldn't
complain, and could just sync that up in userspace.

> +#define xfs_btree_split		__xfs_btree_split
> +#endif

and maybe #endif	/* __KERNEL__ */

Up to you.

>   
>   
>   /*
> 
