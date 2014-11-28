Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 90E837F4E
	for <xfs@oss.sgi.com>; Thu, 27 Nov 2014 19:38:43 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 548498F8033
	for <xfs@oss.sgi.com>; Thu, 27 Nov 2014 17:38:40 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	QJdWl4dhaM8FnQAM for <xfs@oss.sgi.com>;
	Thu, 27 Nov 2014 17:38:37 -0800 (PST)
Date: Fri, 28 Nov 2014 12:38:30 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/2] Add support to RENAME_EXCHANGE flag V8
Message-ID: <20141128013830.GA16151@dastard>
References: <1416923368-28322-1-git-send-email-cmaiolino@redhat.com>
	<1416923368-28322-3-git-send-email-cmaiolino@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1416923368-28322-3-git-send-email-cmaiolino@redhat.com>
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

On Tue, Nov 25, 2014 at 11:49:28AM -0200, Carlos Maiolino wrote:
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
> 	V8: - Replace src/target names for better variable names
> 	    - Log and timestamp updates done in different places
> 	    - Fix missing space in comments
> 	    - get rid of {src,tgt}_is_directory and new_parent variables

FYI, Changelog should be in the cover patch 0, not in the commit
message for the individual patch.

> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> ---
>  fs/xfs/xfs_inode.c | 112 ++++++++++++++++++++++++++++++++++++++++++++++++++++-
>  fs/xfs/xfs_inode.h |   2 +-
>  fs/xfs/xfs_iops.c  |  15 +++++--
>  3 files changed, 123 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 8ed049d..5c5ed99 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -2668,6 +2668,102 @@ xfs_sort_for_rename(
>  	}
>  }
>  
> +/* xfs_cross_rename()
> + *
> + * responsible to handle RENAME_EXCHANGE flag
> + * in renameat2() sytemcall

Comments can use all 80 columns. And the first line of the comment
is "/*" by itself.

> + */
> +STATIC int
> +xfs_cross_rename(
> +	struct xfs_trans	*tp,
> +	struct xfs_inode	*dp1,
> +	struct xfs_name		*name1,
> +	struct xfs_inode	*ip1,
> +	struct xfs_inode	*dp2,
> +	struct xfs_name		*name2,
> +	struct xfs_inode	*ip2,
> +	struct xfs_bmap_free	*free_list,
> +	xfs_fsblock_t		*first_block,
> +	int			spaceres)
> +{
> +	int		error = 0;
> +
> +	/* Replace source inode */

still got source/target in comments that don't make sense. "Swap
inode number for dirent in first parent" might be better...

> +	error = xfs_dir_replace(tp, dp1, name1,
> +				ip2->i_ino,
> +				first_block, free_list, spaceres);
> +	if (error)
> +		goto out;
> +
> +	/* Replace target inode */

	/* Swap inode number for dirent in second parent */

> +	error = xfs_dir_replace(tp, dp2, name2,
> +				ip1->i_ino,
> +				first_block, free_list, spaceres);
> +	if (error)
> +		goto out;
> +	/*
> +	 * If we're renaming one or more directories across different parents,
> +	 * update the respective ".." entries (and link counts) to match the new
> +	 * parents.
> +	 */
> +	if (dp1 != dp2) {
> +
> +		if (S_ISDIR(ip2->i_d.di_mode)) {
> +			error = xfs_dir_replace(tp, ip2, &xfs_name_dotdot,
> +						dp1->i_ino, first_block,
> +						free_list, spaceres);
> +			if (error)
> +				goto out;

now ip2 is modified, so it ctime/mtime dirty.

> +
> +			/* transfer target ".." reference to dp1 */
> +			if (!S_ISDIR(ip1->i_d.di_mode)) {
> +				error = xfs_droplink(tp, dp2);
> +				if (error)
> +					goto out;
> +				error = xfs_bumplink(tp, dp1);
> +				if (error)
> +					goto out;
> +			}
> +			xfs_trans_ichgtime(tp, ip1, XFS_ICHGTIME_CHG);
> +			xfs_trans_ichgtime(tp, ip2,
> +					   XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
> +			xfs_trans_log_inode(tp, ip2, XFS_ILOG_CORE);

But now you're unconditionally changing ctime on ip1 without it
having been modified and you aren't logging the change. Why is the
ctime changing (comments, please!)?


> +		}
> +
> +		if (S_ISDIR(ip1->i_d.di_mode)) {
> +			error = xfs_dir_replace(tp, ip1, &xfs_name_dotdot,
> +						dp2->i_ino, first_block,
> +						free_list, spaceres);
> +			if (error)
> +				goto out;

here ip2 is modified

> +
> +			/* transfer src ".." reference to dp2 */
> +			if (!S_ISDIR(ip2->i_d.di_mode)) {
> +				error = xfs_droplink(tp, dp1);
> +				if (error)
> +					goto out;
> +				error = xfs_bumplink(tp, dp2);
> +				if (error)
> +					goto out;
> +			}
> +			xfs_trans_ichgtime(tp, ip1,
> +					   XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
> +			xfs_trans_ichgtime(tp, ip2, XFS_ICHGTIME_CHG);
> +			xfs_trans_log_inode(tp, ip1, XFS_ILOG_CORE);

and same again - changing ctime on ip2 without logging it.

> +		}
> +		xfs_trans_ichgtime(tp, dp2,
> +				   XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
> +		xfs_trans_log_inode(tp, dp2, XFS_ILOG_CORE);
> +	}
> +	xfs_trans_ichgtime(tp, dp1, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
> +	xfs_trans_log_inode(tp, dp1, XFS_ILOG_CORE);

perhaps:

	int	ip1_flags = 0;
	int	ip2_flags = 0;
	int	dp2_flags = 0;

	if (dp1 != dp2)
		dp2_flags = XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG;

		if (S_ISDIR(ip1)) {
			ip1_flags |= XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG;
			ip2_flags |= XFS_ICHGTIME_CHG; /* because ... */
			.....
		}

		if (S_ISDIR(ip2)) {
			ip1_flags |= XFS_ICHGTIME_CHG; /* because ... */
			ip2_flags |= XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG;
			.....
		}
	}

	if (ip1_flags) {
		xfs_trans_ichgtime(tp, ip1, ip1_flags);
		xfs_trans_log_inode(tp, ip1);
	}
	if (ip2_flags) {
		xfs_trans_ichgtime(tp, ip2, ip2_flags);
		xfs_trans_log_inode(tp, ip2);
	}
	if (dp2_flags) {
		xfs_trans_ichgtime(tp, dp2, ip2_flags);
		xfs_trans_log_inode(tp, dp2);
	}
	xfs_trans_ichgtime(tp, dp2, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
	xfs_trans_log_inode(tp, dp2);
> +
> +out:
> +	return error;
> +}
> +
>  /*
>   * xfs_rename
>   */
> @@ -2678,7 +2774,8 @@ xfs_rename(
>  	xfs_inode_t	*src_ip,
>  	xfs_inode_t	*target_dp,
>  	struct xfs_name	*target_name,
> -	xfs_inode_t	*target_ip)
> +	xfs_inode_t	*target_ip,
> +	unsigned int	flags)
>  {
>  	xfs_trans_t	*tp = NULL;
>  	xfs_mount_t	*mp = src_dp->i_mount;
> @@ -2706,6 +2803,7 @@ xfs_rename(
>  	cancel_flags = XFS_TRANS_RELEASE_LOG_RES;
>  	spaceres = XFS_RENAME_SPACE_RES(mp, target_name->len);
>  	error = xfs_trans_reserve(tp, &M_RES(mp)->tr_rename, spaceres, 0);
> +
>  	if (error == -ENOSPC) {

Stray new line.

>  		spaceres = 0;
>  		error = xfs_trans_reserve(tp, &M_RES(mp)->tr_rename, 0, 0);
> @@ -2756,6 +2854,17 @@ xfs_rename(
>  	}
>  
>  	/*
> +	 * Handle RENAME_EXCHANGE flags
> +	*/

Comment whitespace still needs fixing.

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

Put an empty line between the "}" and the start of the comment.

>  	if (target_ip == NULL) {
> @@ -2894,6 +3003,7 @@ xfs_rename(
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

Comments can use all 80 characters of the line. Also, s/should/need
to/.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
