Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57016 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725894AbfCLOXJ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 12 Mar 2019 10:23:09 -0400
Date: Tue, 12 Mar 2019 09:23:05 -0500
From: Bill O'Donnell <billodo@redhat.com>
Subject: Re: [PATCH 2/2] xfs: clean up xfs_dir2_leaf_addname
Message-ID: <20190312142305.GB28037@redhat.com>
References: <20190311161948.GC4359@magnolia>
 <20190311162232.GD4359@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190311162232.GD4359@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, Nathan Chancellor <natechancellor@gmail.com>, linux-kernel@vger.kernel.org, Nick Desaulniers <ndesaulniers@google.com>, clang-built-linux@googlegroups.com

On Mon, Mar 11, 2019 at 09:22:32AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Remove typedefs and consolidate local variable initialization.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Reviewed-by: Bill O'Donnell <billodo@redhat.com>

> ---
>  fs/xfs/libxfs/xfs_dir2_leaf.c |   33 +++++++++++++++------------------
>  1 file changed, 15 insertions(+), 18 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_dir2_leaf.c b/fs/xfs/libxfs/xfs_dir2_leaf.c
> index 2abf945e5844..9c2a0a13ed61 100644
> --- a/fs/xfs/libxfs/xfs_dir2_leaf.c
> +++ b/fs/xfs/libxfs/xfs_dir2_leaf.c
> @@ -563,43 +563,40 @@ xfs_dir3_leaf_find_entry(
>   */
>  int						/* error */
>  xfs_dir2_leaf_addname(
> -	xfs_da_args_t		*args)		/* operation arguments */
> +	struct xfs_da_args	*args)		/* operation arguments */
>  {
> +	struct xfs_dir3_icleaf_hdr leafhdr;
> +	struct xfs_trans	*tp = args->trans;
>  	__be16			*bestsp;	/* freespace table in leaf */
> -	int			compact;	/* need to compact leaves */
> -	xfs_dir2_data_hdr_t	*hdr;		/* data block header */
> +	__be16			*tagp;		/* end of data entry */
>  	struct xfs_buf		*dbp;		/* data block buffer */
> -	xfs_dir2_data_entry_t	*dep;		/* data block entry */
> -	xfs_inode_t		*dp;		/* incore directory inode */
> -	xfs_dir2_data_unused_t	*dup;		/* data unused entry */
> +	struct xfs_buf		*lbp;		/* leaf's buffer */
> +	struct xfs_dir2_leaf	*leaf;		/* leaf structure */
> +	struct xfs_inode	*dp = args->dp;	/* incore directory inode */
> +	struct xfs_dir2_data_hdr *hdr;		/* data block header */
> +	struct xfs_dir2_data_entry *dep;	/* data block entry */
> +	struct xfs_dir2_leaf_entry *lep;	/* leaf entry table pointer */
> +	struct xfs_dir2_leaf_entry *ents;
> +	struct xfs_dir2_data_unused *dup;	/* data unused entry */
> +	struct xfs_dir2_leaf_tail *ltp;		/* leaf tail pointer */
> +	struct xfs_dir2_data_free *bf;		/* bestfree table */
> +	int			compact;	/* need to compact leaves */
>  	int			error;		/* error return value */
>  	int			grown;		/* allocated new data block */
>  	int			highstale = 0;	/* index of next stale leaf */
>  	int			i;		/* temporary, index */
>  	int			index;		/* leaf table position */
> -	struct xfs_buf		*lbp;		/* leaf's buffer */
> -	xfs_dir2_leaf_t		*leaf;		/* leaf structure */
>  	int			length;		/* length of new entry */
> -	xfs_dir2_leaf_entry_t	*lep;		/* leaf entry table pointer */
>  	int			lfloglow;	/* low leaf logging index */
>  	int			lfloghigh;	/* high leaf logging index */
>  	int			lowstale = 0;	/* index of prev stale leaf */
> -	xfs_dir2_leaf_tail_t	*ltp;		/* leaf tail pointer */
>  	int			needbytes;	/* leaf block bytes needed */
>  	int			needlog;	/* need to log data header */
>  	int			needscan;	/* need to rescan data free */
> -	__be16			*tagp;		/* end of data entry */
> -	xfs_trans_t		*tp;		/* transaction pointer */
>  	xfs_dir2_db_t		use_block;	/* data block number */
> -	struct xfs_dir2_data_free *bf;		/* bestfree table */
> -	struct xfs_dir2_leaf_entry *ents;
> -	struct xfs_dir3_icleaf_hdr leafhdr;
>  
>  	trace_xfs_dir2_leaf_addname(args);
>  
> -	dp = args->dp;
> -	tp = args->trans;
> -
>  	error = xfs_dir3_leaf_read(tp, dp, args->geo->leafblk, -1, &lbp);
>  	if (error)
>  		return error;
