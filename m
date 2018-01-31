Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55084 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932095AbeAaXLb (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 31 Jan 2018 18:11:31 -0500
Date: Wed, 31 Jan 2018 17:11:25 -0600
From: Bill O'Donnell <billodo@redhat.com>
Subject: Re: [PATCH] xfs: don't allow DAX on reflink filesystems
Message-ID: <20180131231125.GA5804@redhat.com>
References: <20180131222324.GH4849@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180131222324.GH4849@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: xfs <linux-xfs@vger.kernel.org>, Dave Chinner <david@fromorbit.com>, Eric Sandeen <sandeen@redhat.com>

On Wed, Jan 31, 2018 at 02:23:24PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Now that reflink is no longer experimental, reject attempts to mount
> with DAX until that whole mess gets sorted out.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

nit: Check alignment of the warning message (probably ok?)...

Reviewed-by: Bill O'Donnell <billodo@redhat.com>

> ---
>  fs/xfs/xfs_super.c |    5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index f436eec..fd34cf2 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -1666,9 +1666,12 @@ xfs_fs_fill_super(
>  			"DAX unsupported by block device. Turning off DAX.");
>  			mp->m_flags &= ~XFS_MOUNT_DAX;
>  		}
> -		if (xfs_sb_version_hasreflink(&mp->m_sb))
> +		if (xfs_sb_version_hasreflink(&mp->m_sb)) {
>  			xfs_alert(mp,
>  		"DAX and reflink cannot be used together!");
> +			error = -EINVAL;
> +			goto out_filestream_unmount;
> +		}
>  	}
>  
>  	if (mp->m_flags & XFS_MOUNT_DISCARD) {
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
