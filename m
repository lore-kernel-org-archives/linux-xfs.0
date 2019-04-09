Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:58036 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726333AbfDIUoK (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 9 Apr 2019 16:44:10 -0400
Subject: Re: [PATCH 23/36] xfs_repair: reinitialize the root directory nlink
 correctly
References: <155259742281.31886.17157720770696604377.stgit@magnolia>
 <155259757149.31886.6730311002359408147.stgit@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <0d722931-d965-67cd-7a75-bcd41bb33d86@sandeen.net>
Date: Tue, 9 Apr 2019 15:44:09 -0500
MIME-Version: 1.0
In-Reply-To: <155259757149.31886.6730311002359408147.stgit@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org



On 3/14/19 4:06 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> In mk_root_dir, we reinitialize the root directory inode with a link
> count of 1.  This differs from mkfs parseproto, which initializes the
> root to have a link count of 2.  The nlink discrepancy in repair is
> caught and corrected during phase 7, but this is unnecessary since we
> should set it properly in the first place.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

aaand review the most recent one.  o_O

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
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
