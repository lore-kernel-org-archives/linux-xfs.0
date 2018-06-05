Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:44608 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751442AbeFEKAQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 5 Jun 2018 06:00:16 -0400
Received: by mail-wr0-f193.google.com with SMTP id y15-v6so1703097wrg.11
        for <linux-xfs@vger.kernel.org>; Tue, 05 Jun 2018 03:00:15 -0700 (PDT)
Date: Tue, 5 Jun 2018 12:00:12 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH 3/6] xfs: verify COW extent size hint is valid in inode
 verifier
Message-ID: <20180605100012.fwwd5y6u6pufzo34@odin.usersys.redhat.com>
References: <20180605062423.4877-1-david@fromorbit.com>
 <20180605062423.4877-4-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180605062423.4877-4-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Jun 05, 2018 at 04:24:20PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> There are rules for vald extent size hints. We enforce them when
> applications set them, but fuzzers violate those rules and that
> screws us over. Validate COW extent size hint rules in the inode
> verifier to catch this.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_inode_buf.c | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
> 

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
> index be197c91307b..ea64be7cbd98 100644
> --- a/fs/xfs/libxfs/xfs_inode_buf.c
> +++ b/fs/xfs/libxfs/xfs_inode_buf.c
> @@ -504,7 +504,7 @@ xfs_dinode_verify(
>  
>  	/* extent size hint validation */
>  	fa = xfs_inode_validate_extsize(mp, be32_to_cpu(dip->di_extsize),
> -					mode, be32_to_cpu(dip->di_flags));
> +					mode, flags);
>  	if (fa)
>  		return fa;
>  
> @@ -516,7 +516,7 @@ xfs_dinode_verify(
>  
>  	/* don't allow reflink/cowextsize if we don't have reflink */
>  	if ((flags2 & (XFS_DIFLAG2_REFLINK | XFS_DIFLAG2_COWEXTSIZE)) &&
> -            !xfs_sb_version_hasreflink(&mp->m_sb))
> +	     !xfs_sb_version_hasreflink(&mp->m_sb))
>  		return __this_address;
>  
>  	/* only regular files get reflink */
> @@ -531,6 +531,12 @@ xfs_dinode_verify(
>  	if ((flags2 & XFS_DIFLAG2_REFLINK) && (flags2 & XFS_DIFLAG2_DAX))
>  		return __this_address;
>  
> +	/* COW extent size hint validation */
> +	fa = xfs_inode_validate_cowextsize(mp, be32_to_cpu(dip->di_cowextsize),
> +					mode, flags, flags2);
> +	if (fa)
> +		return fa;
> +
>  	return NULL;
>  }
>  
> -- 
> 2.17.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Carlos
