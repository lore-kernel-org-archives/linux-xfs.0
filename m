Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:48827 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752322AbdKFURN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 Nov 2017 15:17:13 -0500
Date: Mon, 6 Nov 2017 12:17:09 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 4/8] xfs: remove unused debug counts for xfs_lock_inodes
Message-ID: <20171106201708.GF6244@magnolia>
References: <20171106143456.13567-1-hch@lst.de>
 <20171106143456.13567-5-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171106143456.13567-5-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Mon, Nov 06, 2017 at 03:34:52PM +0100, Christoph Hellwig wrote:
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

> ---
>  fs/xfs/xfs_inode.c | 21 ---------------------
>  1 file changed, 21 deletions(-)
> 
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index edd98353fbeb..d8226f7a5dde 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -385,14 +385,6 @@ xfs_isilocked(
>  }
>  #endif
>  
> -#ifdef DEBUG
> -int xfs_locked_n;
> -int xfs_small_retries;
> -int xfs_middle_retries;
> -int xfs_lots_retries;
> -int xfs_lock_delays;
> -#endif
> -
>  /*
>   * xfs_lockdep_subclass_ok() is only used in an ASSERT, so is only called when
>   * DEBUG or XFS_WARN is set. And MAX_LOCKDEP_SUBCLASSES is then only defined
> @@ -545,24 +537,11 @@ xfs_lock_inodes(
>  
>  		if ((attempts % 5) == 0) {
>  			delay(1); /* Don't just spin the CPU */
> -#ifdef DEBUG
> -			xfs_lock_delays++;
> -#endif
>  		}
>  		i = 0;
>  		try_lock = 0;
>  		goto again;
>  	}
> -
> -#ifdef DEBUG
> -	if (attempts) {
> -		if (attempts < 5) xfs_small_retries++;
> -		else if (attempts < 100) xfs_middle_retries++;
> -		else xfs_lots_retries++;
> -	} else {
> -		xfs_locked_n++;
> -	}
> -#endif
>  }
>  
>  /*
> -- 
> 2.14.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
