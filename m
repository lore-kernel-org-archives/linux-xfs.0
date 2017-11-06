Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:48236 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750929AbdKFUQA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 Nov 2017 15:16:00 -0500
Date: Mon, 6 Nov 2017 12:15:54 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 3/8] xfs: mark xfs_errortag_ktype static
Message-ID: <20171106201554.GE6244@magnolia>
References: <20171106143456.13567-1-hch@lst.de>
 <20171106143456.13567-4-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171106143456.13567-4-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Mon, Nov 06, 2017 at 03:34:51PM +0100, Christoph Hellwig wrote:
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

> ---
>  fs/xfs/xfs_error.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
> index 92396d5eb259..4c9f35d983b2 100644
> --- a/fs/xfs/xfs_error.c
> +++ b/fs/xfs/xfs_error.c
> @@ -203,7 +203,7 @@ static struct attribute *xfs_errortag_attrs[] = {
>  	NULL,
>  };
>  
> -struct kobj_type xfs_errortag_ktype = {
> +static struct kobj_type xfs_errortag_ktype = {
>  	.release = xfs_sysfs_release,
>  	.sysfs_ops = &xfs_errortag_sysfs_ops,
>  	.default_attrs = xfs_errortag_attrs,
> -- 
> 2.14.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
