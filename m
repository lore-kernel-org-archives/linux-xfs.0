Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:58024 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726333AbfDIUny (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 9 Apr 2019 16:43:54 -0400
Subject: Re: [PATCH 13/23] xfs_repair: reinitialize the root directory nlink
 correctly
References: <155148280859.16677.6057998944865066232.stgit@magnolia>
 <155148289561.16677.8657255567421403873.stgit@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <16d6af36-c9c0-fb05-2db8-dca0584cac61@sandeen.net>
Date: Tue, 9 Apr 2019 15:43:53 -0500
MIME-Version: 1.0
In-Reply-To: <155148289561.16677.8657255567421403873.stgit@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On 3/1/19 5:28 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> In mk_root_dir, we reinitialize the root directory inode with a link
> count of 1.  This differs from mkfs parseproto, which initializes the
> root to have a link count of 2.  The nlink discrepancy in repair is
> caught and corrected during phase 7, but this is unnecessary since we
> should set it properly in the first place.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>


I have this nagging feeling that we've pingponged some of this back
and forth, but this seems totally legitimate, so ...
embrace the fear ;)

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
