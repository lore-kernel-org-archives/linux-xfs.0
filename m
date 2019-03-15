Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43392 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728067AbfCOMbV (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 15 Mar 2019 08:31:21 -0400
Date: Fri, 15 Mar 2019 08:31:18 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 4/4] xfs: avoid reflink end cow deadlock
Message-ID: <20190315123118.GD5182@bfoster>
References: <155259893433.30230.6566995969675098053.stgit@magnolia>
 <155259895820.30230.97674228109532637.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <155259895820.30230.97674228109532637.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Mar 14, 2019 at 02:29:18PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> xfs/347 occasionally deadlocks while running.  Analysis of the D state
> processes shows that there are a large number of workqueue threads all
> trying to reserve transaction space to call xfs_reflink_end_cow_extent
> and a single workqueue thread stuck in the same function trying to add
> space as part of a regrant because we underestimate the number of times
> that the remap operation needs to roll.  That rolling thread is stuck
> because all the other threads are ahead of it in line waiting for space.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Seems reasonable, but is this going to be in addition to a higher level
change along the lines of Dave's suggestion to minimize parallel
allocated I/O completion transactions on the same inode? If so, it might
be worth doing that first with a commit log description that documents
the deadlock problem and fix and then include this one as a separate
update to avoid blocking regrants in the common remap case.

Also, it would be helpful to include the analysis that goes into
calculating the logcount in the commit log as well (I think you
mentioned deferred agfl frees adding another roll or two to the
originally expected roll count, but it's not immediately clear to me
where the original value came from..).

Brian

>  fs/xfs/libxfs/xfs_trans_resv.c |    7 +++++++
>  fs/xfs/libxfs/xfs_trans_resv.h |    2 ++
>  fs/xfs/xfs_reflink.c           |    2 +-
>  3 files changed, 10 insertions(+), 1 deletion(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_trans_resv.c b/fs/xfs/libxfs/xfs_trans_resv.c
> index 477c67f1faa7..06e213ae1bd6 100644
> --- a/fs/xfs/libxfs/xfs_trans_resv.c
> +++ b/fs/xfs/libxfs/xfs_trans_resv.c
> @@ -851,6 +851,13 @@ xfs_trans_resv_calc(
>  		resp->tr_write.tr_logcount = XFS_WRITE_LOG_COUNT;
>  	resp->tr_write.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
>  
> +	resp->tr_remap.tr_logres = xfs_calc_write_reservation(mp);
> +	if (xfs_sb_version_hasreflink(&mp->m_sb))
> +		resp->tr_remap.tr_logcount = XFS_REMAP_LOG_COUNT_REFLINK;
> +	else
> +		resp->tr_remap.tr_logcount = 0;
> +	resp->tr_remap.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
> +
>  	resp->tr_itruncate.tr_logres = xfs_calc_itruncate_reservation(mp);
>  	if (xfs_sb_version_hasreflink(&mp->m_sb))
>  		resp->tr_itruncate.tr_logcount =
> diff --git a/fs/xfs/libxfs/xfs_trans_resv.h b/fs/xfs/libxfs/xfs_trans_resv.h
> index 7f7d86671319..a685654adf21 100644
> --- a/fs/xfs/libxfs/xfs_trans_resv.h
> +++ b/fs/xfs/libxfs/xfs_trans_resv.h
> @@ -20,6 +20,7 @@ struct xfs_trans_res {
>  
>  struct xfs_trans_resv {
>  	struct xfs_trans_res	tr_write;	/* extent alloc trans */
> +	struct xfs_trans_res	tr_remap;	/* extent remap trans */
>  	struct xfs_trans_res	tr_itruncate;	/* truncate trans */
>  	struct xfs_trans_res	tr_rename;	/* rename trans */
>  	struct xfs_trans_res	tr_link;	/* link trans */
> @@ -88,6 +89,7 @@ struct xfs_trans_resv {
>  #define	XFS_RENAME_LOG_COUNT		2
>  #define	XFS_WRITE_LOG_COUNT		2
>  #define	XFS_WRITE_LOG_COUNT_REFLINK	8
> +#define	XFS_REMAP_LOG_COUNT_REFLINK	10
>  #define	XFS_ADDAFORK_LOG_COUNT		2
>  #define	XFS_ATTRINVAL_LOG_COUNT		1
>  #define	XFS_ATTRSET_LOG_COUNT		3
> diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> index 680ae7662a78..6c84956ea833 100644
> --- a/fs/xfs/xfs_reflink.c
> +++ b/fs/xfs/xfs_reflink.c
> @@ -630,7 +630,7 @@ xfs_reflink_end_cow_extent(
>  	}
>  
>  	resblks = XFS_EXTENTADD_SPACE_RES(mp, XFS_DATA_FORK);
> -	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, resblks, 0,
> +	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_remap, resblks, 0,
>  			XFS_TRANS_RESERVE | XFS_TRANS_NOFS, &tp);
>  	if (error)
>  		return error;
> 
