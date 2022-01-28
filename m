Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E735C433EF
	for <linux-xfs@archiver.kernel.org>; Fri, 28 Jan 2022 20:53:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236318AbiA1UxE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 28 Jan 2022 15:53:04 -0500
Received: from sandeen.net ([63.231.237.45]:41366 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239970AbiA1UxD (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 28 Jan 2022 15:53:03 -0500
Received: from [10.0.0.147] (liberator.sandeen.net [10.0.0.147])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 2B13178FD;
        Fri, 28 Jan 2022 14:52:50 -0600 (CST)
Message-ID: <217c0998-4795-c85c-54cb-45b47ba99ac8@sandeen.net>
Date:   Fri, 28 Jan 2022 14:53:02 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.1
Content-Language: en-US
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
References: <164263784199.860211.7509808171577819673.stgit@magnolia>
 <164263807467.860211.13040036268013928337.stgit@magnolia>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH 42/45] libxfs: replace XFS_BUF_SET_ADDR with a function
In-Reply-To: <164263807467.860211.13040036268013928337.stgit@magnolia>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 1/19/22 6:21 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Replace XFS_BUF_SET_ADDR with a new function that will set the buffer
> block number correctly, then port the two users to it.

Ok, this is in preparation for later adding more to the
function (saying "set it correctly" confused me a little, because
the function looks equivalent to the macro....)

...
   
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index 63895f28..057b3b09 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -3505,8 +3505,8 @@ alloc_write_buf(
>   				error);
>   		exit(1);
>   	}
> -	bp->b_bn = daddr;
> -	bp->b_maps[0].bm_bn = daddr;
> +
> +	xfs_buf_set_daddr(bp, daddr);

This *looks* a little like a functional change, since you dropped
setting of the bp->b_maps[0].bm_bn. But since we get here with a
single buffer, not a map of buffers, I ... think that at this point,
nobody will be looking at b_maps[0].bm_bn anyway?

But I'm not quite sure. I also notice xfs_get_aghdr_buf() in the kernel
setting both b_bn and b_maps[0].bm_bn upstream, for similar purposes.

Can you sanity-check me a little here?

Thanks,
-Eric

>   	return bp;
>   }
>   
> 
