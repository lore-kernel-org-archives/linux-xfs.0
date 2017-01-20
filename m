Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1050.oracle.com ([141.146.126.70]:22346 "EHLO
        aserp1050.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753131AbdATQgp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 20 Jan 2017 11:36:45 -0500
Date: Fri, 20 Jan 2017 08:34:51 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs: do not call xfs_buf_hash_destroy on a NULL pag
Message-ID: <20170120163451.GD12985@birch.djwong.org>
References: <20170120142642.21698-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170120142642.21698-1-colin.king@canonical.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Colin King <colin.king@canonical.com>
Cc: linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org

On Fri, Jan 20, 2017 at 02:26:42PM +0000, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> If pag cannot be allocated, the current error exit path will trip
> a null pointer deference error when calling xfs_buf_hash_destroy
> with a null pag.  Fix this by adding a new error exit lable and
> jumping to this, avoiding the hash destroy and unnecessary kmem_free
> on pag.
> 
> Fixes CoverityScan CID#1397628 ("Dereference after null check")
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

Applied, thanks.

--D

> ---
>  fs/xfs/xfs_mount.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> index 9b9540d..4e66cd19 100644
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -207,7 +207,7 @@ xfs_initialize_perag(
>  
>  		pag = kmem_zalloc(sizeof(*pag), KM_MAYFAIL);
>  		if (!pag)
> -			goto out_unwind;
> +			goto out_unwind_pags;
>  		pag->pag_agno = index;
>  		pag->pag_mount = mp;
>  		spin_lock_init(&pag->pag_ici_lock);
> @@ -242,6 +242,7 @@ xfs_initialize_perag(
>  out_unwind:
>  	xfs_buf_hash_destroy(pag);
>  	kmem_free(pag);
> +out_unwind_pags:
>  	for (; index > first_initialised; index--) {
>  		pag = radix_tree_delete(&mp->m_perag_tree, index);
>  		xfs_buf_hash_destroy(pag);
> -- 
> 2.10.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
