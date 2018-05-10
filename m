Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53068 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751096AbeEJNzA (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 10 May 2018 09:55:00 -0400
Date: Thu, 10 May 2018 09:54:59 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 07/12] xfs: scrub the data fork of the realtime inodes
Message-ID: <20180510135458.GF69384@bfoster.bfoster>
References: <152537075334.16676.10600900179473864298.stgit@magnolia>
 <152537079876.16676.9808685459752163487.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <152537079876.16676.9808685459752163487.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Thu, May 03, 2018 at 11:06:38AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> The realtime bitmap and summary inodes live on the metadata device, so
> we can scrub their data forks with the regular scrubbers.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/scrub/rtbitmap.c |   26 +++++++++++++++++++++++++-
>  1 file changed, 25 insertions(+), 1 deletion(-)
> 
> 
> diff --git a/fs/xfs/scrub/rtbitmap.c b/fs/xfs/scrub/rtbitmap.c
> index 8b048f107af2..b2b4dff2660d 100644
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
> @@ -95,8 +100,27 @@ int
>  xfs_scrub_rtsummary(
>  	struct xfs_scrub_context	*sc)
>  {
> +	struct xfs_inode		*rsumip = sc->mp->m_rsumip;
> +	int				error = 0;
> +
> +	/*
> +	 * We ILOCK'd the rt bitmap ip in the setup routine, now lock the
> +	 * rt summary ip in compliance with the rt inode locking rules.
> +	 */
> +	xfs_ilock(rsumip, XFS_ILOCK_EXCL | XFS_ILOCK_RTSUM);
> +
> +	/* Invoke the fork scrubber. */
> +	sc->ip = rsumip;

I guess the ->ilock_flags are technically inconsistent at this point.
Does that matter? If not, couldn't hurt to document that in the comment.
;P

I also think this would be a bit easier to follow if we just stored and
restored an old_ip pointer on the stack (and perhaps assert that it
matches ->m_rbmip).

Brian

> +	error = xfs_scrub_metadata_inode_forks(sc);
> +	sc->ip = sc->mp->m_rbmip;
> +	if (error || (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT))
> +		goto out;
> +
>  	/* XXX: implement this some day */
> -	return -ENOENT;
> +	xfs_scrub_set_incomplete(sc);
> +out:
> +	xfs_iunlock(rsumip, XFS_ILOCK_EXCL | XFS_ILOCK_RTSUM);
> +	return error;
>  }
>  
>  
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
