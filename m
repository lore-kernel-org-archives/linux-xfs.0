Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:51457 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752017AbdHHQfg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 8 Aug 2017 12:35:36 -0400
Date: Tue, 8 Aug 2017 09:35:30 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: xfs: use kmem_free to free return value of kmem_zalloc
Message-ID: <20170808163530.GP24087@magnolia>
References: <1502194677-28047-1-git-send-email-bianpan2016@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1502194677-28047-1-git-send-email-bianpan2016@163.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Pan Bian <bianpan2016@163.com>
Cc: linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org

On Tue, Aug 08, 2017 at 08:17:57PM +0800, Pan Bian wrote:
> In function xfs_test_remount_options(), kfree() is used to free memory
> allocated by kmem_zalloc(). But it is better to use kmem_free().

Looks fine (for 4.14),
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

> Signed-off-by: Pan Bian <bianpan2016@163.com>
> ---
>  fs/xfs/xfs_super.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 38aaacd..c1c4c2e 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -1220,7 +1220,7 @@ struct proc_xfs_info {
>  	tmp_mp->m_super = sb;
>  	error = xfs_parseargs(tmp_mp, options);
>  	xfs_free_fsname(tmp_mp);
> -	kfree(tmp_mp);
> +	kmem_free(tmp_mp);
>  
>  	return error;
>  }
> -- 
> 1.9.1
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
