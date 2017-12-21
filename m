Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:55161 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752884AbdLUVVk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 21 Dec 2017 16:21:40 -0500
Date: Thu, 21 Dec 2017 13:21:36 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 1/2] xfs: quota: fix missed destroy of qi_tree_lock
Message-ID: <20171221212136.GY12613@magnolia>
References: <20171221201743.18016-1-akaraliou.dev@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171221201743.18016-1-akaraliou.dev@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Aliaksei Karaliou <akaraliou.dev@gmail.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Dec 21, 2017 at 11:17:42PM +0300, Aliaksei Karaliou wrote:
> xfs_qm_destroy_quotainfo() does not destroy quotainfo->qi_tree_lock
> while destroys quotainfo->qi_quotaofflock.
> 
> Signed-off-by: Aliaksei Karaliou <akaraliou.dev@gmail.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

> ---
>  fs/xfs/xfs_qm.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
> index ec952dfad359..d0053115427f 100644
> --- a/fs/xfs/xfs_qm.c
> +++ b/fs/xfs/xfs_qm.c
> @@ -736,6 +736,7 @@ xfs_qm_destroy_quotainfo(
>  		IRELE(qi->qi_pquotaip);
>  		qi->qi_pquotaip = NULL;
>  	}
> +	mutex_destroy(&qi->qi_tree_lock);
>  	mutex_destroy(&qi->qi_quotaofflock);
>  	kmem_free(qi);
>  	mp->m_quotainfo = NULL;
> -- 
> 2.11.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
