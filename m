Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 850D07F3F
	for <xfs@oss.sgi.com>; Fri, 14 Nov 2014 13:13:05 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 05A1BAC006
	for <xfs@oss.sgi.com>; Fri, 14 Nov 2014 11:13:04 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id PTKH3l7qjZqZRZUr (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 14 Nov 2014 11:13:03 -0800 (PST)
Received: from int-mx13.intmail.prod.int.phx2.redhat.com
	(int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id sAEJD2uA018172
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=FAIL) for <xfs@oss.sgi.com>; Fri, 14 Nov 2014 14:13:02 -0500
Date: Fri, 14 Nov 2014 14:12:59 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 2/2] Add support to RENAME_EXCHANGE flag V7
Message-ID: <20141114191258.GB3390@laptop.bfoster>
References: <1415989940-20004-1-git-send-email-cmaiolino@redhat.com>
	<1415989940-20004-3-git-send-email-cmaiolino@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1415989940-20004-3-git-send-email-cmaiolino@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Carlos Maiolino <cmaiolino@redhat.com>
Cc: xfs@oss.sgi.com

On Fri, Nov 14, 2014 at 04:32:20PM -0200, Carlos Maiolino wrote:
> Adds a new function named xfs_cross_rename(), responsible to handle requests
> from sys_renameat2() using RENAME_EXCHANGE flag.
> 
> Changelog:
> 
> 	V2: - refactor xfs_cross_rename() to not duplicate code from xfs_rename()
> 
> 	V3: - fix indentation to avoid 80 column crossing, decrease the amount of
> 	      arguments passed to xfs_cross_rename()
> 	    - Rebase patches over the latest linux code
> 
> 	v4: - use a label/goto statement instead of an if conditional after
> 	      xfs_cross_rename() return, to finish the rename operation
> 	    - Make xfs_cross_rename() static
> 	    - Fix some comments
> 
> 	V5: - Keep all the code under 80 columns
> 
> 	V6: - Ensure i_mode of both files are updated during exchange
> 
> 	V7: - Use struct names instead of typedefs in the xfs_cross_rename()
> 	      definition
> 
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> ---

Aside from the comment alignment things that Eric pointed out, this one
looks Ok to me:

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_inode.c | 113 ++++++++++++++++++++++++++++++++++++++++++++++++++++-
>  fs/xfs/xfs_inode.h |   2 +-
>  fs/xfs/xfs_iops.c  |  15 +++++--
>  3 files changed, 124 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 8ed049d..3a77254 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -2668,6 +2668,103 @@ xfs_sort_for_rename(
>  	}
>  }
>  
> +/* xfs_cross_rename()
> + *
> + * responsible to handle RENAME_EXCHANGE flag
> + * in renameat2() sytemcall
> + */
> +STATIC int
> +xfs_cross_rename(
> +	struct xfs_trans	*tp,
> +	struct xfs_inode	*src_dp,
> +	struct xfs_name		*src_name,
> +	struct xfs_inode	*src_ip,
> +	struct xfs_inode	*target_dp,
> +	struct xfs_name		*target_name,
> +	struct xfs_inode	*target_ip,
> +	struct xfs_bmap_free	*free_list,
> +	xfs_fsblock_t		*first_block,
> +	int			spaceres)
> +{
> +	int		error = 0;
> +	int		new_parent;
> +	int		src_is_directory;
> +	int		tgt_is_directory;
> +
> +	new_parent = (src_dp != target_dp);
> +	src_is_directory = S_ISDIR(src_ip->i_d.di_mode);
> +	tgt_is_directory = S_ISDIR(target_ip->i_d.di_mode);
> +
> +	/* Replace source inode */
> +	error = xfs_dir_replace(tp, src_dp, src_name,
> +				target_ip->i_ino,
> +				first_block, free_list, spaceres);
> +	if (error)
> +		goto out;
> +
> +	/* Replace target inode */
> +	error = xfs_dir_replace(tp, target_dp, target_name,
> +				src_ip->i_ino,
> +				first_block, free_list, spaceres);
> +	if (error)
> +		goto out;
> +
> +	xfs_trans_ichgtime(tp, src_dp, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
> +
> +	/*
> +	* If we're renaming one or more directories across different parents,
> +	* update the respective ".." entries (and link counts) to match the new
> +	* parents.
> +	*/
> +	if (new_parent) {
> +		xfs_trans_ichgtime(tp, target_dp,
> +				   XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
> +
> +		if (tgt_is_directory) {
> +			error = xfs_dir_replace(tp, target_ip, &xfs_name_dotdot,
> +						src_dp->i_ino, first_block,
> +						free_list, spaceres);
> +			if (error)
> +				goto out;
> +
> +			/* transfer target ".." reference to src_dp */
> +			if (!src_is_directory) {
> +				error = xfs_droplink(tp, target_dp);
> +				if (error)
> +					goto out;
> +				error = xfs_bumplink(tp, src_dp);
> +				if (error)
> +					goto out;
> +			}
> +		}
> +
> +		if (src_is_directory) {
> +			error = xfs_dir_replace(tp, src_ip, &xfs_name_dotdot,
> +						target_dp->i_ino, first_block,
> +						free_list, spaceres);
> +			if (error)
> +				goto out;
> +
> +			/* transfer src ".." reference to target_dp */
> +			if (!tgt_is_directory) {
> +				error = xfs_droplink(tp, src_dp);
> +				if (error)
> +					goto out;
> +				error = xfs_bumplink(tp, target_dp);
> +				if (error)
> +					goto out;
> +			}
> +		}
> +		xfs_trans_log_inode(tp, src_dp, XFS_ILOG_CORE);
> +	}
> +	xfs_trans_log_inode(tp, target_dp, XFS_ILOG_CORE);
> +	xfs_trans_log_inode(tp, src_ip, XFS_ILOG_CORE);
> +	xfs_trans_log_inode(tp, target_ip, XFS_ILOG_CORE);
> +
> +out:
> +	return error;
> +}
> +
>  /*
>   * xfs_rename
>   */
> @@ -2678,7 +2775,8 @@ xfs_rename(
>  	xfs_inode_t	*src_ip,
>  	xfs_inode_t	*target_dp,
>  	struct xfs_name	*target_name,
> -	xfs_inode_t	*target_ip)
> +	xfs_inode_t	*target_ip,
> +	unsigned int	flags)
>  {
>  	xfs_trans_t	*tp = NULL;
>  	xfs_mount_t	*mp = src_dp->i_mount;
> @@ -2706,6 +2804,7 @@ xfs_rename(
>  	cancel_flags = XFS_TRANS_RELEASE_LOG_RES;
>  	spaceres = XFS_RENAME_SPACE_RES(mp, target_name->len);
>  	error = xfs_trans_reserve(tp, &M_RES(mp)->tr_rename, spaceres, 0);
> +
>  	if (error == -ENOSPC) {
>  		spaceres = 0;
>  		error = xfs_trans_reserve(tp, &M_RES(mp)->tr_rename, 0, 0);
> @@ -2756,6 +2855,17 @@ xfs_rename(
>  	}
>  
>  	/*
> +	 * Handle RENAME_EXCHANGE flags
> +	*/
> +	if (flags & RENAME_EXCHANGE) {
> +		error = xfs_cross_rename(tp, src_dp, src_name, src_ip,
> +					 target_dp, target_name, target_ip,
> +					 &free_list, &first_block, spaceres);
> +		if (error)
> +			goto abort_return;
> +		goto finish_rename;
> +	}
> +	/*
>  	 * Set up the target.
>  	 */
>  	if (target_ip == NULL) {
> @@ -2894,6 +3004,7 @@ xfs_rename(
>  	if (new_parent)
>  		xfs_trans_log_inode(tp, target_dp, XFS_ILOG_CORE);
>  
> +finish_rename:
>  	/*
>  	 * If this is a synchronous mount, make sure that the
>  	 * rename transaction goes to disk before returning to
> diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
> index 9af2882..051d9f0 100644
> --- a/fs/xfs/xfs_inode.h
> +++ b/fs/xfs/xfs_inode.h
> @@ -340,7 +340,7 @@ int		xfs_link(struct xfs_inode *tdp, struct xfs_inode *sip,
>  int		xfs_rename(struct xfs_inode *src_dp, struct xfs_name *src_name,
>  			   struct xfs_inode *src_ip, struct xfs_inode *target_dp,
>  			   struct xfs_name *target_name,
> -			   struct xfs_inode *target_ip);
> +			   struct xfs_inode *target_ip, unsigned int flags);
>  
>  void		xfs_ilock(xfs_inode_t *, uint);
>  int		xfs_ilock_nowait(xfs_inode_t *, uint);
> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index 0b8704c..4e5d8ce 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -387,19 +387,26 @@ xfs_vn_rename(
>  	unsigned int	flags)
>  {
>  	struct inode	*new_inode = ndentry->d_inode;
> +	int		omode = 0;
>  	struct xfs_name	oname;
>  	struct xfs_name	nname;
>  
> -	/* XFS does not support RENAME_EXCHANGE yet */
> -	if (flags & ~RENAME_NOREPLACE)
> +	if (flags & ~(RENAME_NOREPLACE | RENAME_EXCHANGE))
>  		return -EINVAL;
>  
> -	xfs_dentry_to_name(&oname, odentry, 0);
> +	/*
> +	 * if we are exchanging files, we should set
> +	 * i_mode of both files
> +	 */
> +	if (flags & RENAME_EXCHANGE)
> +		omode = ndentry->d_inode->i_mode;
> +
> +	xfs_dentry_to_name(&oname, odentry, omode);
>  	xfs_dentry_to_name(&nname, ndentry, odentry->d_inode->i_mode);
>  
>  	return xfs_rename(XFS_I(odir), &oname, XFS_I(odentry->d_inode),
>  			  XFS_I(ndir), &nname,
> -			  new_inode ? XFS_I(new_inode) : NULL);
> +			  new_inode ? XFS_I(new_inode) : NULL, flags);
>  }
>  
>  /*
> -- 
> 2.1.0
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
