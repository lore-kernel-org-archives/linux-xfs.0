Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:41350 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725828AbeLWWvk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 23 Dec 2018 17:51:40 -0500
Date: Sun, 23 Dec 2018 14:51:28 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 09/20] xfs: xfs_fsops: drop useless LIST_HEAD
Message-ID: <20181223225128.GI27208@magnolia>
References: <1545555435-24576-1-git-send-email-Julia.Lawall@lip6.fr>
 <1545555435-24576-10-git-send-email-Julia.Lawall@lip6.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1545555435-24576-10-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: kernel-janitors@vger.kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org

On Sun, Dec 23, 2018 at 09:57:04AM +0100, Julia Lawall wrote:
> Drop LIST_HEAD where the variable it declares is never used.
> 
> Commit 0410c3bb2b88 ("xfs: factor ag btree root block
> initialisation") stopped using buffer_list and started using a
> buffer list in an aghdr_init_data structure, but the declaration
> of buffer_list was not removed.
> 
> The semantic patch that fixes this problem is as follows:
> (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> @@
> identifier x;
> @@
> - LIST_HEAD(x);
>   ... when != x
> // </smpl>
> 
> Fixes: 0410c3bb2b88 ("xfs: factor ag btree root block initialisation")
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> 
> ---
> Successfully 0-day tested on 151 configurations.
> 
>  fs/xfs/xfs_fsops.c |    1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
> index ec2e63a7963b..f3ef70c542e1 100644
> --- a/fs/xfs/xfs_fsops.c
> +++ b/fs/xfs/xfs_fsops.c
> @@ -40,7 +40,6 @@ xfs_growfs_data_private(
>  	xfs_rfsblock_t		new;
>  	xfs_agnumber_t		oagcount;
>  	xfs_trans_t		*tp;
> -	LIST_HEAD		(buffer_list);
>  	struct aghdr_init_data	id = {};
>  
>  	nb = in->newblocks;
> 
