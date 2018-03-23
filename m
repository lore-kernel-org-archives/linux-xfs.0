Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:45875 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751776AbeCWMzj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 23 Mar 2018 08:55:39 -0400
Received: by mail-wr0-f196.google.com with SMTP id h2so12029566wre.12
        for <linux-xfs@vger.kernel.org>; Fri, 23 Mar 2018 05:55:39 -0700 (PDT)
Date: Fri, 23 Mar 2018 13:55:35 +0100
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH 1/2] xfs: catch inode allocation state mismatch corruption
Message-ID: <20180323125535.4gqkbcmzwjurzkoz@odin.usersys.redhat.com>
References: <20180321075248.7677-1-david@fromorbit.com>
 <20180321075248.7677-2-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180321075248.7677-2-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

> 
> Note that this crash is only possible on v4 filesystemsi or v5
> filesystems mounted with the ikeep mount option. For all other V5
> filesystems, this problem cannot occur because we don't read inodes
> we are allocating from disk - we simply overwrite them with the new
> inode information.
> 
> Signed-Off-By: Dave Chinner <dchinner@redhat.com>

I could reproduce this problem by manually setting an inode as free in the
inobt, and the patch fixes the bug.

The patch looks good too.

xfstests should hit the list soon.

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Tested-by: Carlos Maiolino <cmaiolino@redhat.com>


> ---
>  fs/xfs/xfs_icache.c | 23 ++++++++++++++++++++++-
>  1 file changed, 22 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index 1dc37b72b6ea..98b7a4ae15e4 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -484,7 +484,28 @@ xfs_iget_cache_miss(
>  
>  	trace_xfs_iget_miss(ip);
>  
> -	if ((VFS_I(ip)->i_mode == 0) && !(flags & XFS_IGET_CREATE)) {
> +
> +	/*
> +	 * If we are allocating a new inode, then check what was returned is
> +	 * actually a free, empty inode. If we are not allocating an inode,
> +	 * the check we didn't find a free inode.
> +	 */
> +	if (flags & XFS_IGET_CREATE) {
> +		if (VFS_I(ip)->i_mode != 0) {
> +			xfs_warn(mp,
> +"Corruption detected! Free inode 0x%llx not marked free on disk",
> +				ino);
> +			error = -EFSCORRUPTED;
> +			goto out_destroy;
> +		}
> +		if (ip->i_d.di_nblocks != 0) {
> +			xfs_warn(mp,
> +"Corruption detected! Free inode 0x%llx has blocks allocated!",
> +				ino);
> +			error = -EFSCORRUPTED;
> +			goto out_destroy;
> +		}
> +	} else if (VFS_I(ip)->i_mode == 0) {
>  		error = -ENOENT;
>  		goto out_destroy;
>  	}
> -- 
> 2.16.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Carlos
