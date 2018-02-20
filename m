Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:2102 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750799AbeBTVMY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 20 Feb 2018 16:12:24 -0500
Date: Wed, 21 Feb 2018 08:11:14 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: Remove duplicated check
Message-ID: <20180220211114.GC7000@dastard>
References: <1519134782-10062-1-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1519134782-10062-1-git-send-email-nborisov@suse.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Nikolay Borisov <nborisov@suse.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Feb 20, 2018 at 03:53:02PM +0200, Nikolay Borisov wrote:
> The check performed before the memcpy responsible for copying the rest
> of the inode is already performed before we call xfs_log_dinode_to_disk.
> So let's remove the 2nd instance of the check. No functional changes.
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
> Reported-by: Jeff Mahoney <jeffm@suse.com>
> ---
>  fs/xfs/xfs_log_recover.c | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index 00240c9ee72e..88dccfb1de96 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -3174,11 +3174,8 @@ xlog_recover_inode_pass2(
>  	xfs_log_dinode_to_disk(ldip, dip);
>  
>  	/* the rest is in on-disk format */
> -	if (item->ri_buf[1].i_len > isize) {
> -		memcpy((char *)dip + isize,
> -			item->ri_buf[1].i_addr + isize,
> +	memcpy((char *)dip + isize, item->ri_buf[1].i_addr + isize,
>  			item->ri_buf[1].i_len - isize);
> -	}
>  

This looks wrong.

The previous check is:

	if (unlikely(item->ri_buf[1].i_len > isize)) {
		CORRUPTION_ERROR
		....
		error = -EFSCORRUPTED;
		goto out_release;
	}

So after this item->ri_buf[1].i_len is always <= isize. IOWs, the
memcpy() is currently dead code that is never executed, not code we
want to execute in every inode recovery.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
