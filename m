Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:38632 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388414AbeGXTSr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 Jul 2018 15:18:47 -0400
Date: Tue, 24 Jul 2018 11:10:52 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs: properly handle free inodes in extent hint
 validators
Message-ID: <20180724181052.GV4813@magnolia>
References: <4203c670-0064-8735-0931-573fdbeeaa67@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4203c670-0064-8735-0931-573fdbeeaa67@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On Tue, Jul 24, 2018 at 11:00:39AM -0700, Eric Sandeen wrote:
> When inodes are freed in xfs_ifree(), di_flags is cleared (so extent size
> hints are removed) but the actual extent size fields are left intact.
> This causes the extent hint validators to fail on freed inodes which once
> had extent size hints. 
> 
> This can be observed (for example) by running xfs/229 twice on a
> non-crc xfs filesystem, or presumably on V5 with ikeep.

I couldn't get it to reproduce by running x/229 twice, but I did see
x/242 blow up on the same problem overnight.  Which is funny since it
hadn't blown up until now.

> Fixes: 7d71a67 ("xfs: verify extent size hint is valid in inode verifier")
> Fixes: 02a0fda ("xfs: verify COW extent size hint is valid in inode verifier")
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Separate patch, but can you also modify xfs_ifree to zero the
extsize/cowextsize fields so that 4.16-4.17 kernels without this patch
are less likely to trip over this?

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
> 
> diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
> index 33dc34655ac3..30d1d60f1d46 100644
> --- a/fs/xfs/libxfs/xfs_inode_buf.c
> +++ b/fs/xfs/libxfs/xfs_inode_buf.c
> @@ -731,7 +731,8 @@ xfs_inode_validate_extsize(
>  	if ((hint_flag || inherit_flag) && extsize == 0)
>  		return __this_address;
>  
> -	if (!(hint_flag || inherit_flag) && extsize != 0)
> +	/* free inodes get flags set to zero but extsize remains */
> +	if (mode && !(hint_flag || inherit_flag) && extsize != 0)
>  		return __this_address;
>  
>  	if (extsize_bytes % blocksize_bytes)
> @@ -777,7 +778,8 @@ xfs_inode_validate_cowextsize(
>  	if (hint_flag && cowextsize == 0)
>  		return __this_address;
>  
> -	if (!hint_flag && cowextsize != 0)
> +	/* free inodes get flags set to zero but cowextsize remains */
> +	if (mode && !hint_flag && cowextsize != 0)
>  		return __this_address;
>  
>  	if (hint_flag && rt_flag)
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
