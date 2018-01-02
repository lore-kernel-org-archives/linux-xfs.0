Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:38207 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750745AbeABUnX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 Jan 2018 15:43:23 -0500
Date: Tue, 2 Jan 2018 12:38:19 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs: destroy mutex qi_tree_lock before free
 xfs_quotainfo_t object
Message-ID: <20180102203819.GF4857@magnolia>
References: <20171224123447.2998-1-sxwjean@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171224123447.2998-1-sxwjean@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Xiongwei Song <sxwjean@gmail.com>
Cc: linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org

On Sun, Dec 24, 2017 at 08:34:47PM +0800, Xiongwei Song wrote:
> The mutex qi_tree_lock of xfs_quotainfo_t object was initialized when
> calling xfs_qm_init_quotainfo, but it was not destroyed before free
> xfs_quotainfo_t object when calling xfs_qm_destroy_quotainfo, this was
> incorrect, so destroy it in function xfs_qm_destroy_quotainfo.

Already in for-next, but thank you for catching this.

https://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git/commit/?h=for-next&id=2196881566225f3c3428d1a5f847a992944daa5b

--D

> Signed-off-by: Xiongwei Song <sxwjean@gmail.com>
> ---
>  fs/xfs/xfs_qm.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
> index ec952dfad359..deceef5cbbf3 100644
> --- a/fs/xfs/xfs_qm.c
> +++ b/fs/xfs/xfs_qm.c
> @@ -737,6 +737,7 @@ xfs_qm_destroy_quotainfo(
>  		qi->qi_pquotaip = NULL;
>  	}
>  	mutex_destroy(&qi->qi_quotaofflock);
> +	mutex_destroy(&qi->qi_tree_lock);
>  	kmem_free(qi);
>  	mp->m_quotainfo = NULL;
>  }
> -- 
> 2.15.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
