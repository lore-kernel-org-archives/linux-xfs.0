Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:55100 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751753AbeA3T5K (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 30 Jan 2018 14:57:10 -0500
Subject: Re: [PATCH] xfs: fix u32 type usage in sb validation function
References: <20180130033656.GK9068@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <4a9d6460-3913-eb7c-174d-da55a2d2cb29@sandeen.net>
Date: Tue, 30 Jan 2018 13:57:09 -0600
MIME-Version: 1.0
In-Reply-To: <20180130033656.GK9068@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, xfs <linux-xfs@vger.kernel.org>

On 1/29/18 9:36 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Don't use u32, use uint32_t, because this won't work in xfsprogs.

mmkay :)

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_sb.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
> index 46af6aa..a55f7a4 100644
> --- a/fs/xfs/libxfs/xfs_sb.c
> +++ b/fs/xfs/libxfs/xfs_sb.c
> @@ -118,8 +118,8 @@ xfs_mount_validate_sb(
>  	bool		check_inprogress,
>  	bool		check_version)
>  {
> -	u32		agcount = 0;
> -	u32		rem;
> +	uint32_t	agcount = 0;
> +	uint32_t	rem;
>  
>  	if (sbp->sb_magicnum != XFS_SB_MAGIC) {
>  		xfs_warn(mp, "bad magic number");
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
