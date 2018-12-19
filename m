Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57330 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728688AbeLSUYw (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 19 Dec 2018 15:24:52 -0500
Date: Wed, 19 Dec 2018 14:24:47 -0600
From: Bill O'Donnell <billodo@redhat.com>
Subject: Re: [PATCH 6/8] xfs_repair: reinitialize the root directory nlink
 correctly
Message-ID: <20181219202447.GA22276@redhat.com>
References: <154524776457.28646.3004453037075812416.stgit@magnolia>
 <154524781113.28646.8112653175487549499.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <154524781113.28646.8112653175487549499.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: sandeen@redhat.com, linux-xfs@vger.kernel.org

On Wed, Dec 19, 2018 at 11:30:11AM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> In mk_root_dir, we reinitialize the root directory inode with a link
> count of 1.  This differs from mkfs parseproto, which initializes the
> root to have a link count of 2.  The nlink discrepancy in repair is
> caught and corrected during phase 7, but this is unnecessary since we
> should set it properly in the first place.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Looks fine.
Reviewed-by: Bill O'Donnell <billodo@redhat.com>

>  repair/phase6.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> 
> diff --git a/repair/phase6.c b/repair/phase6.c
> index 9477bc25..8a50b350 100644
> --- a/repair/phase6.c
> +++ b/repair/phase6.c
> @@ -891,7 +891,7 @@ mk_root_dir(xfs_mount_t *mp)
>  	ip->i_d.di_format = XFS_DINODE_FMT_EXTENTS;
>  	ip->i_d.di_aformat = XFS_DINODE_FMT_EXTENTS;
>  
> -	set_nlink(VFS_I(ip), 1);	/* account for . */
> +	set_nlink(VFS_I(ip), 2);	/* account for . and .. */
>  
>  	times = XFS_ICHGTIME_CHG | XFS_ICHGTIME_MOD;
>  	if (ip->i_d.di_version == 3) {
> 
