Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:47994 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934081AbeALQsK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 12 Jan 2018 11:48:10 -0500
Date: Fri, 12 Jan 2018 08:48:05 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs: destroy mutex pag_ici_reclaim_lock before free
 xfs_perag_t structure
Message-ID: <20180112164805.GX5602@magnolia>
References: <20180111121151.13197-1-sxwjean@me.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180111121151.13197-1-sxwjean@me.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Xiongwei Song <sxwjean@me.com>
Cc: linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org

On Thu, Jan 11, 2018 at 08:11:51PM +0800, Xiongwei Song wrote:
> The mutex pag_ici_reclaim_lock of xfs_perag_t structure is initialized in
> xfs_initialize_perag. If happen errors in xfs_initialize_perag, or free
> resources in xfs_free_perag, wo need to destroy the mutex before free
> perag.
> 
> Signed-off-by: Xiongwei Song <sxwjean@me.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

> ---
>  fs/xfs/xfs_mount.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> index c879b517cc94..98fd41cbb9e1 100644
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -162,6 +162,7 @@ xfs_free_perag(
>  		ASSERT(pag);
>  		ASSERT(atomic_read(&pag->pag_ref) == 0);
>  		xfs_buf_hash_destroy(pag);
> +		mutex_destroy(&pag->pag_ici_reclaim_lock);
>  		call_rcu(&pag->rcu_head, __xfs_free_perag);
>  	}
>  }
> @@ -248,6 +249,7 @@ xfs_initialize_perag(
>  out_hash_destroy:
>  	xfs_buf_hash_destroy(pag);
>  out_free_pag:
> +	mutex_destroy(&pag->pag_ici_reclaim_lock);
>  	kmem_free(pag);
>  out_unwind_new_pags:
>  	/* unwind any prior newly initialized pags */
> @@ -256,6 +258,7 @@ xfs_initialize_perag(
>  		if (!pag)
>  			break;
>  		xfs_buf_hash_destroy(pag);
> +		mutex_destroy(&pag->pag_ici_reclaim_lock);
>  		kmem_free(pag);
>  	}
>  	return error;
> -- 
> 2.15.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
