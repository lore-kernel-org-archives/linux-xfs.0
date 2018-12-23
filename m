Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:33840 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725828AbeLWWvd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 23 Dec 2018 17:51:33 -0500
Date: Sun, 23 Dec 2018 14:51:18 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 08/20] xfs: xfs_buf: drop useless LIST_HEAD
Message-ID: <20181223225118.GH27208@magnolia>
References: <1545555435-24576-1-git-send-email-Julia.Lawall@lip6.fr>
 <1545555435-24576-9-git-send-email-Julia.Lawall@lip6.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1545555435-24576-9-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: kernel-janitors@vger.kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org

On Sun, Dec 23, 2018 at 09:57:03AM +0100, Julia Lawall wrote:
> Drop LIST_HEAD where the variable it declares has never
> been used.
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
> Fixes: 26f1fe858f274 ("xfs: reduce lock hold times in buffer writeback")
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

Looks ok; are you planning to push this whole series directly to Linus
or do you want me to take the two xfs patches through?

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> 
> ---
> Successfully 0-day tested on 151 configurations.
> 
>  fs/xfs/xfs_buf.c |    1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index b21ea2ba768d..eedc5e0156ff 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -1992,7 +1992,6 @@ xfs_buf_delwri_submit_buffers(
>  	struct list_head	*wait_list)
>  {
>  	struct xfs_buf		*bp, *n;
> -	LIST_HEAD		(submit_list);
>  	int			pinned = 0;
>  	struct blk_plug		plug;
>  
> 
