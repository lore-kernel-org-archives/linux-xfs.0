Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:34231 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753153AbdIRSkk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 Sep 2017 14:40:40 -0400
Date: Mon, 18 Sep 2017 11:40:36 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 1/2] xfs: report zeroed or not correctly in
 xfs_zero_range()
Message-ID: <20170918184036.GK6540@magnolia>
References: <20170907034254.7180-1-eguan@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170907034254.7180-1-eguan@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <eguan@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Sep 07, 2017 at 11:42:53AM +0800, Eryu Guan wrote:
> The 'did_zero' param of xfs_zero_range() was not passed to
> iomap_zero_range() correctly. This was introduced by commit
> 7bb41db3ea16 ("xfs: handle 64-bit length in xfs_iozero"), and found
> by code inspection.
> 
> Signed-off-by: Eryu Guan <eguan@redhat.com>

Both look ok,

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

> ---
>  fs/xfs/xfs_file.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index c4893e226fd8..812cd17b331f 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -58,7 +58,7 @@ xfs_zero_range(
>  	xfs_off_t		count,
>  	bool			*did_zero)
>  {
> -	return iomap_zero_range(VFS_I(ip), pos, count, NULL, &xfs_iomap_ops);
> +	return iomap_zero_range(VFS_I(ip), pos, count, did_zero, &xfs_iomap_ops);
>  }
>  
>  int
> -- 
> 2.13.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
