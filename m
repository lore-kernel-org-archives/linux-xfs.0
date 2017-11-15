Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:48353 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753465AbdKOBKZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 14 Nov 2017 20:10:25 -0500
Date: Tue, 14 Nov 2017 17:10:22 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs: remove experimental tag for reflinks
Message-ID: <20171115011022.GC5119@magnolia>
References: <20170830145400.3681-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170830145400.3681-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Wed, Aug 30, 2017 at 04:54:00PM +0200, Christoph Hellwig wrote:
> But reject reflink + DAX file systems for now until the code to
> support reflinks on DAX is actually implemented.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_super.c | 8 +++-----
>  1 file changed, 3 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 38aaacdbb8b3..92521032468e 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -1634,7 +1634,9 @@ xfs_fs_fill_super(
>  		}
>  		if (xfs_sb_version_hasreflink(&mp->m_sb))
>  			xfs_alert(mp,
> -		"DAX and reflink have not been tested together!");
> +		"DAX and reflink can not be used together!");
> +			error = -EINVAL;
> +			goto out_filestream_unmount;
>  	}
>  
>  	if (xfs_sb_version_hasrmapbt(&mp->m_sb)) {
> @@ -1648,10 +1650,6 @@ xfs_fs_fill_super(
>  	"EXPERIMENTAL reverse mapping btree feature enabled. Use at your own risk!");
>  	}
>  
> -	if (xfs_sb_version_hasreflink(&mp->m_sb))
> -		xfs_alert(mp,
> -	"EXPERIMENTAL reflink feature enabled. Use at your own risk!");

Ok, now that the incore extent map rework has landed upstream, can we
please get everyone's QA to stress the reflink/cow code vigorously
during this release cycle so that we can re-consider this patch for
4.16?

(And if you're particularly mean, force cowextsize = 1fsb to age the
filesystem prematurely?)

Right now I think the only problem I know about is that log recovery bug
where the defer ops of replayed defer ops get logged in the wrong order,
but that's it.

--D

> -
>  	error = xfs_mountfs(mp);
>  	if (error)
>  		goto out_filestream_unmount;
> -- 
> 2.11.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
