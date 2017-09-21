Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40952 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751629AbdIUOgY (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 21 Sep 2017 10:36:24 -0400
Date: Thu, 21 Sep 2017 10:36:23 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 01/27] xfs: return a distinct error code value for
 IGET_INCORE cache misses
Message-ID: <20170921143622.GC58956@bfoster.bfoster>
References: <150595305131.18473.16572195821331601191.stgit@magnolia>
 <150595305764.18473.14307181577961479811.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <150595305764.18473.14307181577961479811.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Sep 20, 2017 at 05:17:37PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> For an XFS_IGET_INCORE iget operation, if the inode isn't in the cache,
> return ENODATA so that we don't confuse it with the pre-existing ENOENT
> cases (inode is in cache, but freed).
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_icache.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> 
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index 3422711..43005fb 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -610,7 +610,7 @@ xfs_iget(
>  	} else {
>  		rcu_read_unlock();
>  		if (flags & XFS_IGET_INCORE) {
> -			error = -ENOENT;
> +			error = -ENODATA;
>  			goto out_error_or_again;
>  		}
>  		XFS_STATS_INC(mp, xs_ig_missed);
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
