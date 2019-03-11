Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:42490 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726942AbfCKRMR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 11 Mar 2019 13:12:17 -0400
Subject: Re: [PATCH 2/2] xfs: clean up xfs_dir2_leaf_addname
References: <20190311161948.GC4359@magnolia> <20190311162232.GD4359@magnolia>
From: Allison Henderson <allison.henderson@oracle.com>
Message-ID: <b8f9eb73-f29e-9df1-f885-a630cee01e0c@oracle.com>
Date: Mon, 11 Mar 2019 10:12:08 -0700
MIME-Version: 1.0
In-Reply-To: <20190311162232.GD4359@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org
Cc: Nathan Chancellor <natechancellor@gmail.com>, linux-kernel@vger.kernel.org, Nick Desaulniers <ndesaulniers@google.com>, clang-built-linux@googlegroups.com

Looks ok to me.  Thanks for the clean up.

Reviewed-by: Allison Henderson <allison.henderson@oracle.com>

On 3/11/19 9:22 AM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Remove typedefs and consolidate local variable initialization.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>   fs/xfs/libxfs/xfs_dir2_leaf.c |   33 +++++++++++++++------------------
>   1 file changed, 15 insertions(+), 18 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_dir2_leaf.c b/fs/xfs/libxfs/xfs_dir2_leaf.c
> index 2abf945e5844..9c2a0a13ed61 100644
> --- a/fs/xfs/libxfs/xfs_dir2_leaf.c
> +++ b/fs/xfs/libxfs/xfs_dir2_leaf.c
> @@ -563,43 +563,40 @@ xfs_dir3_leaf_find_entry(
>    */
>   int						/* error */
>   xfs_dir2_leaf_addname(
> -	xfs_da_args_t		*args)		/* operation arguments */
> +	struct xfs_da_args	*args)		/* operation arguments */
>   {
> +	struct xfs_dir3_icleaf_hdr leafhdr;
> +	struct xfs_trans	*tp = args->trans;
>   	__be16			*bestsp;	/* freespace table in leaf */
> -	int			compact;	/* need to compact leaves */
> -	xfs_dir2_data_hdr_t	*hdr;		/* data block header */
> +	__be16			*tagp;		/* end of data entry */
>   	struct xfs_buf		*dbp;		/* data block buffer */
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
>   	int			error;		/* error return value */
>   	int			grown;		/* allocated new data block */
>   	int			highstale = 0;	/* index of next stale leaf */
>   	int			i;		/* temporary, index */
>   	int			index;		/* leaf table position */
> -	struct xfs_buf		*lbp;		/* leaf's buffer */
> -	xfs_dir2_leaf_t		*leaf;		/* leaf structure */
>   	int			length;		/* length of new entry */
> -	xfs_dir2_leaf_entry_t	*lep;		/* leaf entry table pointer */
>   	int			lfloglow;	/* low leaf logging index */
>   	int			lfloghigh;	/* high leaf logging index */
>   	int			lowstale = 0;	/* index of prev stale leaf */
> -	xfs_dir2_leaf_tail_t	*ltp;		/* leaf tail pointer */
>   	int			needbytes;	/* leaf block bytes needed */
>   	int			needlog;	/* need to log data header */
>   	int			needscan;	/* need to rescan data free */
> -	__be16			*tagp;		/* end of data entry */
> -	xfs_trans_t		*tp;		/* transaction pointer */
>   	xfs_dir2_db_t		use_block;	/* data block number */
> -	struct xfs_dir2_data_free *bf;		/* bestfree table */
> -	struct xfs_dir2_leaf_entry *ents;
> -	struct xfs_dir3_icleaf_hdr leafhdr;
>   
>   	trace_xfs_dir2_leaf_addname(args);
>   
> -	dp = args->dp;
> -	tp = args->trans;
> -
>   	error = xfs_dir3_leaf_read(tp, dp, args->geo->leafblk, -1, &lbp);
>   	if (error)
>   		return error;
> 
