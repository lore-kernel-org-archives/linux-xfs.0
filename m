Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41740 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754181AbdJIOYo (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 9 Oct 2017 10:24:44 -0400
Date: Mon, 9 Oct 2017 10:24:42 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 3/4] xfs: don't change inode mode if ACL update fails
Message-ID: <20171009142442.GD18663@bfoster.bfoster>
References: <20171008235414.13866-1-david@fromorbit.com>
 <20171008235414.13866-4-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171008235414.13866-4-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Oct 09, 2017 at 10:54:13AM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> If we get ENOSPC half way through setting the ACL, the inode mode
> can still be changed even though the ACL does not exist. Reorder the
> operation to only change the mode of the inode if the ACL is set
> correctly.
> 
> Whilst this does not fix the problem with crash consistency (that requires
> attribute addition to be a deferred op) it does prevent ENOSPC and other
> non-fatal errors setting an xattr to be handled sanely.
> 
> This fixes xfstests generic/449.
> 
> Signed-Off-By: Dave Chinner <dchinner@redhat.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_acl.c | 22 ++++++++++++++++------
>  1 file changed, 16 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/xfs/xfs_acl.c b/fs/xfs/xfs_acl.c
> index 7034e17535de..3354140de07e 100644
> --- a/fs/xfs/xfs_acl.c
> +++ b/fs/xfs/xfs_acl.c
> @@ -247,6 +247,8 @@ xfs_set_mode(struct inode *inode, umode_t mode)
>  int
>  xfs_set_acl(struct inode *inode, struct posix_acl *acl, int type)
>  {
> +	umode_t mode;
> +	bool set_mode = false;
>  	int error = 0;
>  
>  	if (!acl)
> @@ -257,16 +259,24 @@ xfs_set_acl(struct inode *inode, struct posix_acl *acl, int type)
>  		return error;
>  
>  	if (type == ACL_TYPE_ACCESS) {
> -		umode_t mode;
> -
>  		error = posix_acl_update_mode(inode, &mode, &acl);
>  		if (error)
>  			return error;
> -		error = xfs_set_mode(inode, mode);
> -		if (error)
> -			return error;
> +		set_mode = true;
>  	}
>  
>   set_acl:
> -	return __xfs_set_acl(inode, acl, type);
> +	error =  __xfs_set_acl(inode, acl, type);
> +	if (error)
> +		return error;
> +
> +	/*
> +	 * We set the mode after successfully updating the ACL xattr because the
> +	 * xattr update can fail at ENOSPC and we don't want to change the mode
> +	 * if the ACL update hasn't been applied.
> +	 */
> +	if (set_mode)
> +		error = xfs_set_mode(inode, mode);
> +
> +	return error;
>  }
> -- 
> 2.14.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
