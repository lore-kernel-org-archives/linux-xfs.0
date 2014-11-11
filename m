Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 4F97F7F6B
	for <xfs@oss.sgi.com>; Tue, 11 Nov 2014 13:29:30 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 3DD0F304064
	for <xfs@oss.sgi.com>; Tue, 11 Nov 2014 11:29:27 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id sfgGAlvTQ7JmKw0V (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 11 Nov 2014 11:29:25 -0800 (PST)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id sABJTOFQ014111
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=FAIL) for <xfs@oss.sgi.com>; Tue, 11 Nov 2014 14:29:25 -0500
Date: Tue, 11 Nov 2014 14:29:23 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 2/2] Add support to RENAME_EXCHANGE flag V3
Message-ID: <20141111192922.GC38867@bfoster.bfoster>
References: <1415725273-5083-1-git-send-email-cmaiolino@redhat.com>
	<1415725273-5083-3-git-send-email-cmaiolino@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1415725273-5083-3-git-send-email-cmaiolino@redhat.com>
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

On Tue, Nov 11, 2014 at 03:01:13PM -0200, Carlos Maiolino wrote:
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
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> ---
>  fs/xfs/xfs_inode.c | 325 +++++++++++++++++++++++++++++++++++------------------
>  fs/xfs/xfs_inode.h |   7 +-
>  fs/xfs/xfs_iops.c  |   4 +-
>  3 files changed, 225 insertions(+), 111 deletions(-)
> 
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 8ed049d..30dc671 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -2678,12 +2678,14 @@ xfs_rename(
>  	xfs_inode_t	*src_ip,
>  	xfs_inode_t	*target_dp,
>  	struct xfs_name	*target_name,
> -	xfs_inode_t	*target_ip)
> +	xfs_inode_t	*target_ip,
> +	unsigned int	flags)
>  {
>  	xfs_trans_t	*tp = NULL;
>  	xfs_mount_t	*mp = src_dp->i_mount;
>  	int		new_parent;		/* moving to a new dir */
>  	int		src_is_directory;	/* src_name is a directory */
> +	int		tgt_is_directory;

There's an unused variable warning for this.

>  	int		error;
>  	xfs_bmap_free_t free_list;
>  	xfs_fsblock_t   first_block;
> @@ -2706,6 +2708,7 @@ xfs_rename(
>  	cancel_flags = XFS_TRANS_RELEASE_LOG_RES;
>  	spaceres = XFS_RENAME_SPACE_RES(mp, target_name->len);
>  	error = xfs_trans_reserve(tp, &M_RES(mp)->tr_rename, spaceres, 0);
> +
>  	if (error == -ENOSPC) {
>  		spaceres = 0;
>  		error = xfs_trans_reserve(tp, &M_RES(mp)->tr_rename, 0, 0);
> @@ -2756,143 +2759,155 @@ xfs_rename(
>  	}
>  
>  	/*
> -	 * Set up the target.
> -	 */
> -	if (target_ip == NULL) {
> +	 * Handle RENAME_EXCHANGE flags
> +	*/
> +	if (flags & RENAME_EXCHANGE) {
> +		error = xfs_cross_rename(tp, src_dp, src_name, src_ip, target_dp,
> +					 target_name, target_ip, &free_list,
> +					 &first_block, spaceres);
> +		if (error)
> +			goto abort_return;
> +	} else {

The factoring of xfs_rename() looks much better, but we could probably
avoid all the extra indentation in the else branch that follows by using
a label. It does look like that indentation creates a bunch of 80+ char
lines in xfs_rename(). E.g., something like:

	if (flags & RENAME_EXCHANGE) {
		...
		goto complete_tp;
	}
	...
complete_tp:
	...
	return xfs_trans_commit(...);

... and then kill the else above and leave the rest of xfs_rename() as
is.

>  		/*
> -		 * If there's no space reservation, check the entry will
> -		 * fit before actually inserting it.
> +		 * Set up the target.
>  		 */
> -		if (!spaceres) {
> -			error = xfs_dir_canenter(tp, target_dp, target_name);
> -			if (error)
> +		if (target_ip == NULL) {
> +			/*
> +			 * If there's no space reservation, check the entry will
> +			 * fit before actually inserting it.
> +			 */
> +			if (!spaceres) {
> +				error = xfs_dir_canenter(tp, target_dp, target_name);
> +				if (error)
> +					goto error_return;
> +			}
> +			/*
> +			 * If target does not exist and the rename crosses
> +			 * directories, adjust the target directory link count
> +			 * to account for the ".." reference from the new entry.
> +			 */
> +			error = xfs_dir_createname(tp, target_dp, target_name,
> +							src_ip->i_ino, &first_block,
> +							&free_list, spaceres);
> +			if (error == -ENOSPC)
>  				goto error_return;
> -		}
> -		/*
> -		 * If target does not exist and the rename crosses
> -		 * directories, adjust the target directory link count
> -		 * to account for the ".." reference from the new entry.
> -		 */
> -		error = xfs_dir_createname(tp, target_dp, target_name,
> -						src_ip->i_ino, &first_block,
> -						&free_list, spaceres);
> -		if (error == -ENOSPC)
> -			goto error_return;
> -		if (error)
> -			goto abort_return;
> +			if (error)
> +				goto abort_return;
>  
> -		xfs_trans_ichgtime(tp, target_dp,
> -					XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
> +			xfs_trans_ichgtime(tp, target_dp,
> +						XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
>  
> -		if (new_parent && src_is_directory) {
> -			error = xfs_bumplink(tp, target_dp);
> +			if (new_parent && src_is_directory) {
> +				error = xfs_bumplink(tp, target_dp);
> +				if (error)
> +					goto abort_return;
> +			}
> +		} else { /* target_ip != NULL */
> +			/*
> +			 * If target exists and it's a directory, check that both
> +			 * target and source are directories and that target can be
> +			 * destroyed, or that neither is a directory.
> +			 */
> +			if (S_ISDIR(target_ip->i_d.di_mode)) {
> +				/*
> +				 * Make sure target dir is empty.
> +				 */
> +				if (!(xfs_dir_isempty(target_ip)) ||
> +				    (target_ip->i_d.di_nlink > 2)) {
> +					error = -EEXIST;
> +					goto error_return;
> +				}
> +			}
> +
> +			/*
> +			 * Link the source inode under the target name.
> +			 * If the source inode is a directory and we are moving
> +			 * it across directories, its ".." entry will be
> +			 * inconsistent until we replace that down below.
> +			 *
> +			 * In case there is already an entry with the same
> +			 * name at the destination directory, remove it first.
> +			 */
> +			error = xfs_dir_replace(tp, target_dp, target_name,
> +						src_ip->i_ino,
> +						&first_block, &free_list, spaceres);
>  			if (error)
>  				goto abort_return;
> -		}
> -	} else { /* target_ip != NULL */
> +
> +			xfs_trans_ichgtime(tp, target_dp,
> +						XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
> +
> +			/*
> +			 * Decrement the link count on the target since the target
> +			 * dir no longer points to it.
> +			 */
> +			error = xfs_droplink(tp, target_ip);
> +			if (error)
> +				goto abort_return;
> +
> +			if (src_is_directory) {
> +				/*
> +				 * Drop the link from the old "." entry.
> +				 */
> +				error = xfs_droplink(tp, target_ip);
> +				if (error)
> +					goto abort_return;
> +			}
> +		} /* target_ip != NULL */
> +
>  		/*
> -		 * If target exists and it's a directory, check that both
> -		 * target and source are directories and that target can be
> -		 * destroyed, or that neither is a directory.
> +		 * Remove the source.
>  		 */
> -		if (S_ISDIR(target_ip->i_d.di_mode)) {
> +		if (new_parent && src_is_directory) {
>  			/*
> -			 * Make sure target dir is empty.
> +			 * Rewrite the ".." entry to point to the new
> +			 * directory.
>  			 */
> -			if (!(xfs_dir_isempty(target_ip)) ||
> -			    (target_ip->i_d.di_nlink > 2)) {
> -				error = -EEXIST;
> -				goto error_return;
> -			}
> +			error = xfs_dir_replace(tp, src_ip, &xfs_name_dotdot,
> +						target_dp->i_ino,
> +						&first_block, &free_list, spaceres);
> +			ASSERT(error != -EEXIST);
> +			if (error)
> +				goto abort_return;
>  		}
>  
>  		/*
> -		 * Link the source inode under the target name.
> -		 * If the source inode is a directory and we are moving
> -		 * it across directories, its ".." entry will be
> -		 * inconsistent until we replace that down below.
> +		 * We always want to hit the ctime on the source inode.
>  		 *
> -		 * In case there is already an entry with the same
> -		 * name at the destination directory, remove it first.
> +		 * This isn't strictly required by the standards since the source
> +		 * inode isn't really being changed, but old unix file systems did
> +		 * it and some incremental backup programs won't work without it.
>  		 */
> -		error = xfs_dir_replace(tp, target_dp, target_name,
> -					src_ip->i_ino,
> -					&first_block, &free_list, spaceres);
> -		if (error)
> -			goto abort_return;
> -
> -		xfs_trans_ichgtime(tp, target_dp,
> -					XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
> +		xfs_trans_ichgtime(tp, src_ip, XFS_ICHGTIME_CHG);
> +		xfs_trans_log_inode(tp, src_ip, XFS_ILOG_CORE);
>  
>  		/*
> -		 * Decrement the link count on the target since the target
> -		 * dir no longer points to it.
> +		 * Adjust the link count on src_dp.  This is necessary when
> +		 * renaming a directory, either within one parent when
> +		 * the target existed, or across two parent directories.
>  		 */
> -		error = xfs_droplink(tp, target_ip);
> -		if (error)
> -			goto abort_return;
> +		if (src_is_directory && (new_parent || target_ip != NULL)) {
>  
> -		if (src_is_directory) {
>  			/*
> -			 * Drop the link from the old "." entry.
> +			 * Decrement link count on src_directory since the
> +			 * entry that's moved no longer points to it.
>  			 */
> -			error = xfs_droplink(tp, target_ip);
> +			error = xfs_droplink(tp, src_dp);
>  			if (error)
>  				goto abort_return;
>  		}
> -	} /* target_ip != NULL */
> -
> -	/*
> -	 * Remove the source.
> -	 */
> -	if (new_parent && src_is_directory) {
> -		/*
> -		 * Rewrite the ".." entry to point to the new
> -		 * directory.
> -		 */
> -		error = xfs_dir_replace(tp, src_ip, &xfs_name_dotdot,
> -					target_dp->i_ino,
> -					&first_block, &free_list, spaceres);
> -		ASSERT(error != -EEXIST);
> -		if (error)
> -			goto abort_return;
> -	}
> -
> -	/*
> -	 * We always want to hit the ctime on the source inode.
> -	 *
> -	 * This isn't strictly required by the standards since the source
> -	 * inode isn't really being changed, but old unix file systems did
> -	 * it and some incremental backup programs won't work without it.
> -	 */
> -	xfs_trans_ichgtime(tp, src_ip, XFS_ICHGTIME_CHG);
> -	xfs_trans_log_inode(tp, src_ip, XFS_ILOG_CORE);
> -
> -	/*
> -	 * Adjust the link count on src_dp.  This is necessary when
> -	 * renaming a directory, either within one parent when
> -	 * the target existed, or across two parent directories.
> -	 */
> -	if (src_is_directory && (new_parent || target_ip != NULL)) {
>  
> -		/*
> -		 * Decrement link count on src_directory since the
> -		 * entry that's moved no longer points to it.
> -		 */
> -		error = xfs_droplink(tp, src_dp);
> +		error = xfs_dir_removename(tp, src_dp, src_name, src_ip->i_ino,
> +						&first_block, &free_list, spaceres);
>  		if (error)
>  			goto abort_return;
> -	}
>  
> -	error = xfs_dir_removename(tp, src_dp, src_name, src_ip->i_ino,
> -					&first_block, &free_list, spaceres);
> -	if (error)
> -		goto abort_return;
> +		xfs_trans_ichgtime(tp, src_dp, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
> +		xfs_trans_log_inode(tp, src_dp, XFS_ILOG_CORE);
> +		if (new_parent)
> +			xfs_trans_log_inode(tp, target_dp, XFS_ILOG_CORE);
>  
> -	xfs_trans_ichgtime(tp, src_dp, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
> -	xfs_trans_log_inode(tp, src_dp, XFS_ILOG_CORE);
> -	if (new_parent)
> -		xfs_trans_log_inode(tp, target_dp, XFS_ILOG_CORE);
> +	} /* RENAME_EXCHANGE */
>  
>  	/*
>  	 * If this is a synchronous mount, make sure that the
> @@ -2926,6 +2941,100 @@ xfs_rename(
>  	return error;
>  }
>  
> +/* xfs_cross_rename()
> + *
> + * responsible to handle RENAME_EXCHANGE flag
> + * in renameat2() sytemcall
> + */
> +int
> +xfs_cross_rename(

xfs_cross_rename() is only used by xfs_rename() so it can be defined
static. Somewhat of a nit, but I'd also expect to see it implemented
above xfs_rename() as it is a helper for the latter. That could be a
matter of personal taste, however. Otherwise, just stick a declaration
at the top of the file.

> +	xfs_trans_t	*tp,
> +	xfs_inode_t	*src_dp,
> +	struct xfs_name	*src_name,
> +	xfs_inode_t	*src_ip,
> +	xfs_inode_t	*target_dp,
> +	struct xfs_name	*target_name,
> +	xfs_inode_t	*target_ip,
> +	xfs_bmap_free_t	*free_list,
> +	xfs_fsblock_t	*first_block,
> +	int		spaceres)
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
> +		goto out_abort;
> +
> +	/* Replace target inode */
> +	error = xfs_dir_replace(tp, target_dp, target_name,
> +				src_ip->i_ino,
> +				first_block, free_list, spaceres);
> +	if (error)
> +		goto out_abort;
> +
> +	xfs_trans_ichgtime(tp, src_dp, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
> +
> +	/*
> +	 * Update ".." entry to match the new parents
> +	 *
> +	 * In case we are crossing different file types between different
> +	 * parents, we must update parent's link count to match the ".."
> +	 * entry of the new child (or the removal of it).
> +	 */

The logic of the subsequent block looks Ok to me, but I would probably
split up the comment to be more specific. Something like the following
just as an example:

	/*
	 * If we're renaming one or more directories across different parents,
	 * update the respective ".." entries (and link counts) to match the new
	 * parents.
	 */
> +	if (new_parent) {
> +		xfs_trans_ichgtime(tp, target_dp, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);

Long line.

> +
> +		if (tgt_is_directory) {
> +			error = xfs_dir_replace(tp, target_ip, &xfs_name_dotdot,
> +						src_dp->i_ino, first_block,
> +						free_list, spaceres);
> +			if (error)
> +				goto out_abort;

			/* transfer target ".." reference to src_dp */
> +			if (!src_is_directory) {
> +				error = xfs_droplink(tp, target_dp);
> +				if (error)
> +					goto out_abort;
> +				error = xfs_bumplink(tp, src_dp);
> +				if (error)
> +					goto out_abort;
> +			}
> +		}
> +
> +		if (src_is_directory) {
> +			error = xfs_dir_replace(tp, src_ip, &xfs_name_dotdot,
> +						target_dp->i_ino, first_block,
> +						free_list, spaceres);
> +			if (error)
> +				goto out_abort;

			/* transfer src ".." reference to target_dp */
> +			if (!tgt_is_directory) {
> +				error = xfs_droplink(tp, src_dp);
> +				if (error)
> +					goto out_abort;
> +				error = xfs_bumplink(tp, target_dp);
> +				if (error)
> +					goto out_abort;
> +			}
> +		}
> +		xfs_trans_log_inode(tp, src_dp, XFS_ILOG_CORE);
> +	}
> +	xfs_trans_log_inode(tp, target_dp, XFS_ILOG_CORE);
> +	xfs_trans_log_inode(tp, src_ip, XFS_ILOG_CORE);
> +	xfs_trans_log_inode(tp, target_ip, XFS_ILOG_CORE);
> +
> +out_abort:

The name out_abort doesn't really mean much here. We don't abort
anything. Perhaps just 'out?'

> +	return error;
> +}
> +
>  STATIC int
>  xfs_iflush_cluster(
>  	xfs_inode_t	*ip,
> diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
> index 9af2882..819f487 100644
> --- a/fs/xfs/xfs_inode.h
> +++ b/fs/xfs/xfs_inode.h
> @@ -340,7 +340,12 @@ int		xfs_link(struct xfs_inode *tdp, struct xfs_inode *sip,
>  int		xfs_rename(struct xfs_inode *src_dp, struct xfs_name *src_name,
>  			   struct xfs_inode *src_ip, struct xfs_inode *target_dp,
>  			   struct xfs_name *target_name,
> -			   struct xfs_inode *target_ip);
> +			   struct xfs_inode *target_ip, unsigned int flags);
> +int		xfs_cross_rename(struct xfs_trans *tp, struct xfs_inode *src_dp,
> +				 struct xfs_name *src_name, struct xfs_inode *src_ip,
> +				 struct xfs_inode *target_dp, struct xfs_name *target_name,
> +				 struct xfs_inode *target_ip,struct xfs_bmap_free *free_list,
> +				 xfs_fsblock_t *first_block, int spaceres);

There's no need for this once xfs_cross_rename() is static.

Brian

>  
>  void		xfs_ilock(xfs_inode_t *, uint);
>  int		xfs_ilock_nowait(xfs_inode_t *, uint);
> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index 0b8704c..481ae10 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -391,7 +391,7 @@ xfs_vn_rename(
>  	struct xfs_name	nname;
>  
>  	/* XFS does not support RENAME_EXCHANGE yet */
> -	if (flags & ~RENAME_NOREPLACE)
> +	if (flags & ~(RENAME_NOREPLACE | RENAME_EXCHANGE))
>  		return -EINVAL;
>  
>  	xfs_dentry_to_name(&oname, odentry, 0);
> @@ -399,7 +399,7 @@ xfs_vn_rename(
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
