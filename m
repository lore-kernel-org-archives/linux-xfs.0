Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42141 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755198AbeDWNyk (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 23 Apr 2018 09:54:40 -0400
Date: Mon, 23 Apr 2018 09:54:30 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 03/13] xfs: delegate dqget input checks to helper function
Message-ID: <20180423135429.GC43600@bfoster.bfoster>
References: <152440954198.29601.14390250048915099607.stgit@magnolia>
 <152440957121.29601.1360188076802956985.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <152440957121.29601.1360188076802956985.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, hch@lst.de

On Sun, Apr 22, 2018 at 08:06:11AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Move the dqget input checks to a separate function in preparation for
> splitting up the dqget functionality.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_dquot.c |   39 ++++++++++++++++++++++++++++++---------
>  1 file changed, 30 insertions(+), 9 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
> index 43b0b32..9a3a05e 100644
> --- a/fs/xfs/xfs_dquot.c
> +++ b/fs/xfs/xfs_dquot.c
> @@ -753,6 +753,33 @@ xfs_qm_dqget_cache_insert(
>  	return 0;
>  }
>  
> +/* Check our input parameters. */
> +static int
> +xfs_qm_dqget_checks(
> +	struct xfs_mount	*mp,
> +	uint			type)
> +{
> +	if (!XFS_IS_QUOTA_RUNNING(mp)) {
> +		ASSERT(0);
> +		return -ESRCH;
> +	}
> +
> +	if ((!XFS_IS_UQUOTA_ON(mp) && type == XFS_DQ_USER) ||
> +	    (!XFS_IS_PQUOTA_ON(mp) && type == XFS_DQ_PROJ) ||
> +	    (!XFS_IS_GQUOTA_ON(mp) && type == XFS_DQ_GROUP)) {
> +		return -ESRCH;
> +	}
> +
> +	if (type != XFS_DQ_USER &&
> +	    type != XFS_DQ_PROJ &&
> +	    type != XFS_DQ_GROUP) {
> +		ASSERT(0);
> +		return -EINVAL;
> +	}
> +
> +	return 0;
> +}
> +
>  /*
>   * Given the file system, inode OR id, and type (UDQUOT/GDQUOT), return a
>   * a locked dquot, doing an allocation (if requested) as needed.
> @@ -775,16 +802,10 @@ xfs_qm_dqget(
>  	struct xfs_dquot	*dqp;
>  	int			error;
>  
> -	ASSERT(XFS_IS_QUOTA_RUNNING(mp));
> -	if ((! XFS_IS_UQUOTA_ON(mp) && type == XFS_DQ_USER) ||
> -	    (! XFS_IS_PQUOTA_ON(mp) && type == XFS_DQ_PROJ) ||
> -	    (! XFS_IS_GQUOTA_ON(mp) && type == XFS_DQ_GROUP)) {
> -		return -ESRCH;
> -	}
> +	error = xfs_qm_dqget_checks(mp, type);
> +	if (error)
> +		return error;
>  
> -	ASSERT(type == XFS_DQ_USER ||
> -	       type == XFS_DQ_PROJ ||
> -	       type == XFS_DQ_GROUP);
>  	if (ip) {
>  		ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
>  		ASSERT(xfs_inode_dquot(ip, type) == NULL);
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
