Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:43790 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728474AbeGYMh2 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 25 Jul 2018 08:37:28 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 81DD587AAA
        for <linux-xfs@vger.kernel.org>; Wed, 25 Jul 2018 11:26:13 +0000 (UTC)
Date: Wed, 25 Jul 2018 07:26:12 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs: properly handle free inodes in extent hint
 validators
Message-ID: <20180725112611.GA3601@bfoster>
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
> 
> Fixes: 7d71a67 ("xfs: verify extent size hint is valid in inode verifier")
> Fixes: 02a0fda ("xfs: verify COW extent size hint is valid in inode verifier")
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

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
