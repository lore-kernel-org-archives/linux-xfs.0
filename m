Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54660 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932389AbeAIS4x (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 9 Jan 2018 13:56:53 -0500
Date: Tue, 9 Jan 2018 13:56:52 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH v2] xfs: harden directory integrity checks some more
Message-ID: <20180109185652.GC888@bfoster.bfoster>
References: <20180109071336.GD5602@magnolia>
 <20180109184729.GF5602@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180109184729.GF5602@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: xfs <linux-xfs@vger.kernel.org>

On Tue, Jan 09, 2018 at 10:47:29AM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> If a malicious filesystem image contains a block+ format directory
> wherein the directory inode's core.mode is set such that
> S_ISDIR(core.mode) == 0, and if there are subdirectories of the
> corrupted directory, an attempt to traverse up the directory tree will
> crash the kernel in __xfs_dir3_data_check.  Running the online scrub's
> parent checks will tend to do this.
> 
> The crash occurs because the directory inode's d_ops get set to
> xfs_dir[23]_nondir_ops (it's not a directory) but the parent pointer
> scrubber's indiscriminate call to xfs_readdir proceeds past the ASSERT
> if we have non fatal asserts configured.
> 
> Fix the null pointer dereference crash in __xfs_dir3_data_check by
> looking for S_ISDIR or wrong d_ops; and teach the parent scrubber
> to bail out if it is fed a non-directory "parent".
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
> v2: check for wrong d_ops, not individual function pointers
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/libxfs/xfs_dir2_data.c |    8 ++++++++
>  fs/xfs/scrub/parent.c         |    2 +-
>  2 files changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_dir2_data.c b/fs/xfs/libxfs/xfs_dir2_data.c
> index 3237812..853d9ab 100644
> --- a/fs/xfs/libxfs/xfs_dir2_data.c
> +++ b/fs/xfs/libxfs/xfs_dir2_data.c
> @@ -73,6 +73,14 @@ __xfs_dir3_data_check(
>  	 */
>  	ops = xfs_dir_get_ops(mp, dp);
>  
> +	/*
> +	 * If this isn't a directory, or we don't get handed the dir ops,
> +	 * something is seriously wrong.  Bail out.
> +	 */
> +	if ((dp && !S_ISDIR(VFS_I(dp)->i_mode)) ||
> +	    ops != xfs_dir_get_ops(mp, NULL))
> +		return __this_address;
> +
>  	hdr = bp->b_addr;
>  	p = (char *)ops->data_entry_p(hdr);
>  
> diff --git a/fs/xfs/scrub/parent.c b/fs/xfs/scrub/parent.c
> index dd704fd..0d38514 100644
> --- a/fs/xfs/scrub/parent.c
> +++ b/fs/xfs/scrub/parent.c
> @@ -171,7 +171,7 @@ xfs_scrub_parent_validate(
>  	error = xfs_iget(mp, sc->tp, dnum, 0, 0, &dp);
>  	if (!xfs_scrub_fblock_xref_process_error(sc, XFS_DATA_FORK, 0, &error))
>  		goto out;
> -	if (dp == sc->ip) {
> +	if (dp == sc->ip || !S_ISDIR(VFS_I(dp)->i_mode)) {
>  		xfs_scrub_fblock_set_corrupt(sc, XFS_DATA_FORK, 0);
>  		goto out_rele;
>  	}
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
