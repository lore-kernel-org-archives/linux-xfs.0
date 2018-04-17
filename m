Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:44189 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752632AbeDQJFJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Apr 2018 05:05:09 -0400
Received: by mail-wr0-f196.google.com with SMTP id o15so2286608wro.11
        for <linux-xfs@vger.kernel.org>; Tue, 17 Apr 2018 02:05:09 -0700 (PDT)
Date: Tue, 17 Apr 2018 11:05:05 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH 2/2] xfs: validate allocated inode number
Message-ID: <20180417090505.vsmhszk7klbdqq4b@odin.usersys.redhat.com>
References: <20180417063916.13069-1-david@fromorbit.com>
 <20180417063916.13069-3-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180417063916.13069-3-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, viro@ZenIV.linux.org.uk

On Tue, Apr 17, 2018 at 04:39:16PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> When we have corrupted free inode btrees, we can attempt to
> allocate inodes that we know are already allocated. Catch allocation
> of these inodes and report corruption as early as possible to
> prevent corruption propagation or deadlocks.
> 
> Signed-Off-By: Dave Chinner <dchinner@redhat.com>
> ---

Looks good

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

>  fs/xfs/xfs_inode.c | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
> 
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 7b764f746ff2..12e6c1aec386 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -790,6 +790,19 @@ xfs_ialloc(
>  	}
>  	ASSERT(*ialloc_context == NULL);
>  
> +	/*
> +	 * Protect against obviously corrupt allocation btree records. Later
> +	 * xfs_iget checks will catch re-allocation of other active in-memory
> +	 * and on-disk inodes. If we don't catch reallocating the parent inode
> +	 * here we will deadlock in xfs_iget() so we have to do these checks
> +	 * first.
> +	 */
> +	if ((pip && ino == pip->i_ino) ||
> +	    !xfs_verify_dir_ino(mp, ino)) {
> +		xfs_alert(mp, "Allocated a known in-use inode 0x%llx!", ino);
> +		return -EFSCORRUPTED;
> +	}
> +
>  	/*
>  	 * Get the in-core inode with the lock held exclusively.
>  	 * This is because we're setting fields here we need
> -- 
> 2.16.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Carlos
