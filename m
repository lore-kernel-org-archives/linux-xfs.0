Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58018 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751364AbdGSNUY (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 19 Jul 2017 09:20:24 -0400
Date: Wed, 19 Jul 2017 09:20:22 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 2/3] xfs: set firstfsb to NULLFSBLOCK before feeding it
 to _bmapi_write
Message-ID: <20170719132022.GB54534@bfoster.bfoster>
References: <150040225662.1216.16823172616535217786.stgit@magnolia>
 <150040226271.1216.6697100927248768726.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <150040226271.1216.6697100927248768726.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Jul 18, 2017 at 11:24:22AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> We must initialize the firstfsb parameter to _bmapi_write so that it
> doesn't incorrectly treat stack garbage as a restriction on which AGs
> it can search for free space.
> 
> Fixes-coverity-id: 1402025
> Fixes-coverity-id: 1415167
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_bmap.c |    2 +-
>  fs/xfs/xfs_reflink.c     |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 935adde..8c4ee60 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -6508,7 +6508,7 @@ xfs_bmap_finish_one(
>  	xfs_filblks_t			*blockcount,
>  	xfs_exntst_t			state)
>  {
> -	xfs_fsblock_t			firstfsb;
> +	xfs_fsblock_t			firstfsb = NULLFSBLOCK;
>  	int				error = 0;
>  

Shouldn't firstfsb be tied to the transaction lifetime in (at least)
this case? It is used in the allocator to control things like AG locking
order. Here, it looks like we could potentially do multiple unmaps in a
single transaction without carrying the firstfsb state across..?

FWIW this patch still looks fine either way:

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  	trace_xfs_bmap_deferred(tp->t_mountp,
> diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> index ab2270a..d9b3d57 100644
> --- a/fs/xfs/xfs_reflink.c
> +++ b/fs/xfs/xfs_reflink.c
> @@ -329,7 +329,7 @@ xfs_reflink_convert_cow_extent(
>  	xfs_filblks_t			count_fsb,
>  	struct xfs_defer_ops		*dfops)
>  {
> -	xfs_fsblock_t			first_block;
> +	xfs_fsblock_t			first_block = NULLFSBLOCK;
>  	int				nimaps = 1;
>  
>  	if (imap->br_state == XFS_EXT_NORM)
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
