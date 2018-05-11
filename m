Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53526 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751048AbeEKPTl (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 11 May 2018 11:19:41 -0400
Date: Fri, 11 May 2018 11:19:39 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 4/8] xfs: scrub the data fork of the realtime inodes
Message-ID: <20180511151939.GE105683@bfoster.bfoster>
References: <152597988038.25215.9276761144353662866.stgit@magnolia>
 <152597990586.25215.6135406269069566239.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <152597990586.25215.6135406269069566239.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Thu, May 10, 2018 at 12:18:25PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> The realtime bitmap and summary inodes live on the metadata device, so
> we can scrub their data forks with the regular scrubbers.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/scrub/rtbitmap.c |   34 +++++++++++++++++++++++++++++++++-
>  1 file changed, 33 insertions(+), 1 deletion(-)
> 
> 
> diff --git a/fs/xfs/scrub/rtbitmap.c b/fs/xfs/scrub/rtbitmap.c
> index 8b048f107af2..abc885dab122 100644
> --- a/fs/xfs/scrub/rtbitmap.c
> +++ b/fs/xfs/scrub/rtbitmap.c
> @@ -82,6 +82,11 @@ xfs_scrub_rtbitmap(
>  {
>  	int				error;
>  
> +	/* Invoke the fork scrubber. */
> +	error = xfs_scrub_metadata_inode_forks(sc);
> +	if (error || (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT))
> +		return error;
> +
>  	error = xfs_rtalloc_query_all(sc->tp, xfs_scrub_rtbitmap_rec, sc);
>  	if (!xfs_scrub_fblock_process_error(sc, XFS_DATA_FORK, 0, &error))
>  		goto out;
> @@ -95,8 +100,35 @@ int
>  xfs_scrub_rtsummary(
>  	struct xfs_scrub_context	*sc)
>  {
> +	struct xfs_inode		*rsumip = sc->mp->m_rsumip;
> +	uint				old_ilock_flags;
> +	int				error = 0;
> +
> +	/*
> +	 * We ILOCK'd the rt bitmap ip in the setup routine, now lock the
> +	 * rt summary ip in compliance with the rt inode locking rules.
> +	 *
> +	 * Since we switch sc->ip to rsumip we have to save the old ilock
> +	 * flags so that we don't mix up the inode state that @sc tracks.
> +	 */
> +	old_ilock_flags = sc->ilock_flags;
> +	sc->ip = rsumip;
> +	sc->ilock_flags = XFS_ILOCK_EXCL | XFS_ILOCK_RTSUM;
> +	xfs_ilock(sc->ip, sc->ilock_flags);
> +
> +	/* Invoke the fork scrubber. */
> +	error = xfs_scrub_metadata_inode_forks(sc);
> +	if (error || (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT))
> +		goto out;
> +
>  	/* XXX: implement this some day */
> -	return -ENOENT;
> +	xfs_scrub_set_incomplete(sc);
> +out:
> +	/* Switch back to the rtbitmap inode and lock flags. */
> +	xfs_iunlock(sc->ip, sc->ilock_flags);
> +	sc->ilock_flags = old_ilock_flags;
> +	sc->ip = sc->mp->m_rbmip;

I'd use an old_ip here as well just to avoid hardcoding against some
other function. With that, looks fine:

Reviewed-by: Brian Foster <bfoster@redhat.com>

> +	return error;
>  }
>  
>  
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
