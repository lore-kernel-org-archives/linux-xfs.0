Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42384 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754240AbeCVOeh (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 22 Mar 2018 10:34:37 -0400
Date: Thu, 22 Mar 2018 10:34:35 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 11/9] xfs: flag inode corruption if parent ptr doesn't
 get us a real inode
Message-ID: <20180322143435.GG16617@bfoster.bfoster>
References: <152107377037.19571.8618901963505842632.stgit@magnolia>
 <20180321032158.GR1757@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180321032158.GR1757@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Mar 20, 2018 at 08:21:58PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> If a directory's parent inode pointer doesn't point to an inode, flag
> the directory as corrupt.  Enable IGET_UNTRUSTED here so that we
> can confirm with the inobt that the inode is present and allocated.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/scrub/parent.c |    9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/scrub/parent.c b/fs/xfs/scrub/parent.c
> index 0d38514..d1547ca 100644
> --- a/fs/xfs/scrub/parent.c
> +++ b/fs/xfs/scrub/parent.c
> @@ -167,9 +167,14 @@ xfs_scrub_parent_validate(
>  	 * if the parent pointer erroneously points to a file, we
>  	 * can't use DONTCACHE here because DONTCACHE inodes can trigger
>  	 * immediate inactive cleanup of the inode.
> +	 *
> +	 * If _iget returns -EINVAL then the parent inode number is garbage
> +	 * and the directory is corrupt.
>  	 */
> -	error = xfs_iget(mp, sc->tp, dnum, 0, 0, &dp);
> -	if (!xfs_scrub_fblock_xref_process_error(sc, XFS_DATA_FORK, 0, &error))
> +	error = xfs_iget(mp, sc->tp, dnum, XFS_IGET_UNTRUSTED, 0, &dp);
> +	if (error == -EINVAL)
> +		error = -EFSCORRUPTED;
> +	if (!xfs_scrub_fblock_process_error(sc, XFS_DATA_FORK, 0, &error))

Ok, but it looks like we're also changing the error semantics here
(xref_process_error() -> process_error()). Could you comment on that in
the commit log as well?

With that, looks fine:

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  		goto out;
>  	if (dp == sc->ip || !S_ISDIR(VFS_I(dp)->i_mode)) {
>  		xfs_scrub_fblock_set_corrupt(sc, XFS_DATA_FORK, 0);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
