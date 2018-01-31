Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48922 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752479AbeAaXdD (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 31 Jan 2018 18:33:03 -0500
Date: Wed, 31 Jan 2018 17:32:57 -0600
From: Bill O'Donnell <billodo@redhat.com>
Subject: Re: [PATCH] xfs: remove experimental tag for reverse mapping
Message-ID: <20180131233257.GA20639@redhat.com>
References: <20180131174913.GE4849@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180131174913.GE4849@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: xfs <linux-xfs@vger.kernel.org>, Dave Chinner <david@fromorbit.com>, Eric Sandeen <sandeen@redhat.com>

On Wed, Jan 31, 2018 at 09:49:13AM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Reverse mapping has had a while to soak, so remove the experimental tag.
> Now that we've landed space metadata cross-referencing in scrub, the
> feature actually has a purpose.
> 
> Reject rmap filesystems with an rt device until the code to support it
> is actually implemented.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Reviewed-by: Bill O'Donnell <billodo@redhat.com>

> ---
>  fs/xfs/xfs_super.c |    4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index f3e0001..f436eec 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -1684,12 +1684,10 @@ xfs_fs_fill_super(
>  	if (xfs_sb_version_hasrmapbt(&mp->m_sb)) {
>  		if (mp->m_sb.sb_rblocks) {
>  			xfs_alert(mp,
> -	"EXPERIMENTAL reverse mapping btree not compatible with realtime device!");
> +	"reverse mapping btree not compatible with realtime device!");
>  			error = -EINVAL;
>  			goto out_filestream_unmount;
>  		}
> -		xfs_alert(mp,
> -	"EXPERIMENTAL reverse mapping btree feature enabled. Use at your own risk!");
>  	}
>  
>  	error = xfs_mountfs(mp);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
