Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85682C77B75
	for <linux-xfs@archiver.kernel.org>; Tue, 23 May 2023 05:05:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230474AbjEWFFj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 23 May 2023 01:05:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229809AbjEWFFi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 23 May 2023 01:05:38 -0400
Received: from out30-124.freemail.mail.aliyun.com (out30-124.freemail.mail.aliyun.com [115.124.30.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7247D10C
        for <linux-xfs@vger.kernel.org>; Mon, 22 May 2023 22:05:36 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046059;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0VjIh0Yc_1684818332;
Received: from 30.97.48.222(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0VjIh0Yc_1684818332)
          by smtp.aliyun-inc.com;
          Tue, 23 May 2023 13:05:33 +0800
Message-ID: <4dd84200-54e2-8cdc-6816-38aed9dada2c@linux.alibaba.com>
Date:   Tue, 23 May 2023 13:05:31 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.10.0
Subject: Re: [PATCH] xfs: don't deplete the reserve pool when trying to shrink
 the fs
To:     "Darrick J. Wong" <djwong@kernel.org>,
        Dave Chinner <david@fromorbit.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
References: <20230523044646.GB11594@frogsfrogsfrogs>
From:   Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <20230523044646.GB11594@frogsfrogsfrogs>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 2023/5/23 21:46, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Every now and then, xfs/168 fails with this logged in dmesg:
> 
> Reserve blocks depleted! Consider increasing reserve pool size.
> EXPERIMENTAL online shrink feature in use. Use at your own risk!
> Per-AG reservation for AG 1 failed.  Filesystem may run out of space.
> Per-AG reservation for AG 1 failed.  Filesystem may run out of space.
> Error -28 reserving per-AG metadata reserve pool.
> Corruption of in-memory data (0x8) detected at xfs_ag_shrink_space+0x23c/0x3b0 [xfs] (fs/xfs/libxfs/xfs_ag.c:1007).  Shutting down filesystem.
> 
> It's silly to deplete the reserved blocks pool just to shrink the
> filesystem, particularly since the fs goes down after that.
> 
> Fixes: fb2fc1720185 ("xfs: support shrinking unused space in the last AG")

Reviewed-by: Gao Xiang <hsiangkao@linux.alibaba.com>

[ These months I have no more slots for XFS, will go back later
   after some ongoing feature development is done. ]

Thanks,
Gao Xiang


> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>   fs/xfs/xfs_fsops.c |   10 +++++++---
>   1 file changed, 7 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
> index 13851c0d640b..5f00527b8065 100644
> --- a/fs/xfs/xfs_fsops.c
> +++ b/fs/xfs/xfs_fsops.c
> @@ -140,9 +140,13 @@ xfs_growfs_data_private(
>   		return -EINVAL;
>   	}
>   
> -	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_growdata,
> -			(delta > 0 ? XFS_GROWFS_SPACE_RES(mp) : -delta), 0,
> -			XFS_TRANS_RESERVE, &tp);
> +	if (delta > 0)
> +		error = xfs_trans_alloc(mp, &M_RES(mp)->tr_growdata,
> +				XFS_GROWFS_SPACE_RES(mp), 0, XFS_TRANS_RESERVE,
> +				&tp);
> +	else
> +		error = xfs_trans_alloc(mp, &M_RES(mp)->tr_growdata, -delta, 0,
> +				0, &tp);
>   	if (error)
>   		return error;
>   
