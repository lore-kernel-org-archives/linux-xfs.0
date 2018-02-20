Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:47120 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751672AbeBTQjN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 20 Feb 2018 11:39:13 -0500
Date: Tue, 20 Feb 2018 08:39:07 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs: Remove duplicated check
Message-ID: <20180220163907.GC27629@magnolia>
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

Looks ok, will test...
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

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
>  	fields = in_f->ilf_fields;
>  	if (fields & XFS_ILOG_DEV)
> -- 
> 2.7.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
