Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:42878 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726585AbfBDTTY (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 4 Feb 2019 14:19:24 -0500
Subject: Re: [PATCH 6/8] xfs_repair: reinitialize the root directory nlink
 correctly
References: <154524776457.28646.3004453037075812416.stgit@magnolia>
 <154524781113.28646.8112653175487549499.stgit@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <de29a582-be99-bddd-0b7c-c31360da043f@sandeen.net>
Date: Mon, 4 Feb 2019 13:19:22 -0600
MIME-Version: 1.0
In-Reply-To: <154524781113.28646.8112653175487549499.stgit@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, sandeen@redhat.com
Cc: linux-xfs@vger.kernel.org

On 12/19/18 1:30 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> In mk_root_dir, we reinitialize the root directory inode with a link
> count of 1.  This differs from mkfs parseproto, which initializes the
> root to have a link count of 2.  The nlink discrepancy in repair is
> caught and corrected during phase 7, but this is unnecessary since we
> should set it properly in the first place.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

I have this nagging feeling that played whackamole with root dir counts
but can't find any real evidence of that now.  Seems ok.

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
