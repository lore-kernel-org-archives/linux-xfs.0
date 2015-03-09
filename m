Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C279B7F4E
	for <xfs@oss.sgi.com>; Mon,  9 Mar 2015 13:13:26 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 81DD38F8068
	for <xfs@oss.sgi.com>; Mon,  9 Mar 2015 11:13:23 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 20eVaOvgToBCr7Vb (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 09 Mar 2015 11:13:21 -0700 (PDT)
Date: Mon, 9 Mar 2015 15:13:09 -0300
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH] [RFC] xfs: add RENAME_WHITEOUT support
Message-ID: <20150309181309.GA18016@hades.maiolino.org>
References: <1423653330-25297-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1423653330-25297-1-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

Hi Dave,

sorry my delay in take a look into it.

The code doesn't build, due the missing declaration of function
xfs_finish_inode_setup() inside xfs_rename_get_wino().

I couldn't find any reference to this function either. Is there something I'm
missing here?

Cheers.


On Wed, Feb 11, 2015 at 10:15:30PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Add a basic implementation of RENAME_WHITEOUT to the XFS rename
> code. The implementation options considered are documented in the
> code comments; the method chose was "copy ext4" because we are then
> bug-for-bug compatible with the implementation done by the
> overlayfs developers.
> 
> I have a hacky renameat2 test for whiteouts copied from the existing
> renameat2 tests in xfstests, and this code behaves the same as ext4
> in that rename test. I haven't done any testing with overlayfs, so
> who knows whether that explodes or not.
> 
> The rename code is getting pretty spaghetti now - I'll end up
> spliting this patching whiteout support and cleanup, and I'll set
> what possible cleanups I can make that will help make the code a
> little more understandable....
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_inode.c | 261 +++++++++++++++++++++++++++++++++++++++++------------
>  fs/xfs/xfs_iops.c  |   2 +-
>  2 files changed, 205 insertions(+), 58 deletions(-)
> 
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index bf2d2c7..eef5db7 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -2683,17 +2683,20 @@ xfs_remove(
>   */
>  STATIC void
>  xfs_sort_for_rename(
> -	xfs_inode_t	*dp1,	/* in: old (source) directory inode */
> -	xfs_inode_t	*dp2,	/* in: new (target) directory inode */
> -	xfs_inode_t	*ip1,	/* in: inode of old entry */
> -	xfs_inode_t	*ip2,	/* in: inode of new entry, if it
> -				   already exists, NULL otherwise. */
> -	xfs_inode_t	**i_tab,/* out: array of inode returned, sorted */
> -	int		*num_inodes)  /* out: number of inodes in array */
> +	struct xfs_inode	*dp1,	/* in: old (source) directory inode */
> +	struct xfs_inode	*dp2,	/* in: new (target) directory inode */
> +	struct xfs_inode	*ip1,	/* in: inode of old entry */
> +	struct xfs_inode	*ip2,	/* in: inode of new entry */
> +	struct xfs_inode	*wino,	/* in: whiteout inode */
> +	struct xfs_inode	**i_tab,/* out: sorted array of inodes */
> +	int			*num_inodes)  /* out: inodes in array */
>  {
>  	xfs_inode_t		*temp;
>  	int			i, j;
>  
> +	ASSERT(*num_inodes == 5);
> +	memset(i_tab, 0, *num_inodes * sizeof(struct xfs_inode *));
> +
>  	/*
>  	 * i_tab contains a list of pointers to inodes.  We initialize
>  	 * the table here & we'll sort it.  We will then use it to
> @@ -2701,20 +2704,19 @@ xfs_sort_for_rename(
>  	 *
>  	 * Note that the table may contain duplicates.  e.g., dp1 == dp2.
>  	 */
> -	i_tab[0] = dp1;
> -	i_tab[1] = dp2;
> -	i_tab[2] = ip1;
> -	if (ip2) {
> -		*num_inodes = 4;
> -		i_tab[3] = ip2;
> -	} else {
> -		*num_inodes = 3;
> -		i_tab[3] = NULL;
> -	}
> +	i = 0;
> +	i_tab[i++] = dp1;
> +	i_tab[i++] = dp2;
> +	i_tab[i++] = ip1;
> +	if (ip2)
> +		i_tab[i++] = ip2;
> +	if (wino)
> +		i_tab[i++] = wino;
> +	*num_inodes = i;
>  
>  	/*
>  	 * Sort the elements via bubble sort.  (Remember, there are at
> -	 * most 4 elements to sort, so this is adequate.)
> +	 * most 5 elements to sort, so this is adequate.)
>  	 */
>  	for (i = 0; i < *num_inodes; i++) {
>  		for (j = 1; j < *num_inodes; j++) {
> @@ -2846,6 +2848,101 @@ out:
>  }
>  
>  /*
> + * RENAME_WHITEOUT support.
> + *
> + * Whiteouts are used by overlayfs -  it has a convention that a whiteout is a
> + * character device inode with a major:minor of 0:0. Somebody has to be in an
> + * altered state of mind to think this up, so whiteout inodes from this point at
> + * called "wino"s.
> + *
> + * Now, because it's not documented anywhere, here's what RENAME_WHITEOUT does
> + * on ext4:
> +
> +# echo bar > /mnt/scratch/bar
> +# ls -l /mnt/scratch
> +total 24
> +-rw-r--r-- 1 root root     4 Feb 11 20:22 bar
> +-rw-r--r-- 1 root root     4 Feb 11 20:22 foo
> +drwx------ 2 root root 16384 Feb 11 20:18 lost+found
> +# src/renameat2 -w /mnt/scratch/foo /mnt/scratch/bar
> +# ls -l /mnt/scratch
> +total 20
> +-rw-r--r-- 1 root root     4 Feb 11 20:22 bar
> +c--------- 1 root root  0, 0 Feb 11 20:23 foo
> +drwx------ 2 root root 16384 Feb 11 20:18 lost+found
> +# cat /mnt/scratch/bar
> +foo
> +#
> +
> + * In XFS rename terms, the operation that has been done is that source (foo)
> + * has been moved to the target (bar), which is like a nomal rename operation,
> + * but rather than the source being removed, it have been replaced with a wino.
> + *
> + * We can't allocate winos within the rename transaction due to allocation
> + * being a multi-commit transaction, and rename needs to be a single, atomic
> + * commit. Hence we have several options here, form most efficient to least
> + * efficient:
> + *
> + *	- use DT_WHT in the target dirent and do no wino allocation.
> + *	  The main issue with this approach is that we need hooks in
> + *	  lookup to create a virtual chardev inode to present to userspace
> + *	  and in places where we might need to modify the dirent e.g. unlink.
> + *	  Overlayfs also needs to be taught about DT_WHT. Most invasive change,
> + *	  lowest overhead.
> + *
> + *	- create a special wino in the root directory (e.g. a ".wino" dirent and
> + *	  then hardlink every new whiteout to it. This means we only need to
> + *	  create a single wino, and rename simply creates a hardlink to it. We
> + *	  can use DT_WHT for these, though using DT_CHR means we won't have to
> + *	  modify overlayfs, nor anything in userspace. Downside is we have to
> + *	  look up the wino up on every operation and create it if it doesn't
> + *	  exist.
> + *
> + *	- copy ext4: create a special whiteout chardev inode for every whiteout.
> + *	  This is more complex than the above options because of the lack of
> + *	  atomicity between inode creation and the rename operation, requiring
> + *	  us to create a tmpfile inode and then linking it into the directory
> + *	  structure during the rename. At least with a tmpfile inode crashes
> + *	  between the create and rename doesn't leave unreferenced inodes or
> + *	  directory pollution around.
> + *
> + * By far the simplest thing to do is copy ext4. It's also the most
> + * inefficient way of supporting whiteouts, but as an initial implementation we
> + * can simply reuse existing functions and add a small amount of extra code the
> + * the rename operation to handle the *fifth* inode in the transaction.
> + *
> + * Hence that is what is implemented first. When we have time or need we can
> + * come back and implement one of the more efficient whiteout methods, but it's
> + * not necessary for the first implementation.
> + */
> +
> +/*
> + * xfs_rename_get_wino()
> + *
> + * Return a referenced, unlinked, unlocked inode that that can be used as a
> + * whiteout in a rename transaction.
> + */
> +static int
> +xfs_rename_get_wino(
> +	struct xfs_inode	*dp,
> +	struct xfs_inode	**wino)
> +{
> +	struct xfs_inode	*tmpfile;
> +	int			error;
> +
> +	error = xfs_create_tmpfile(dp, NULL, S_IFCHR | WHITEOUT_MODE, &tmpfile);
> +	if (error)
> +		return error;
> +
> +	/* Satisfy xfs_bumplink that this is a real tmpfile */
> +	xfs_finish_inode_setup(tmpfile);
> +	VFS_I(tmpfile)->i_state |= I_LINKABLE;
> +
> +	*wino = tmpfile;
> +	return 0;
> +}
> +
> +/*
>   * xfs_rename
>   */
>  int
> @@ -2867,40 +2964,52 @@ xfs_rename(
>  	xfs_fsblock_t   first_block;
>  	int		cancel_flags;
>  	int		committed;
> -	xfs_inode_t	*inodes[4];
> +	xfs_inode_t	*inodes[5];
> +	int		num_inodes = 5;
>  	int		spaceres;
> -	int		num_inodes;
> +	struct xfs_inode *wino = NULL;
>  
>  	trace_xfs_rename(src_dp, target_dp, src_name, target_name);
>  
> +	/*
> +	 * If we are doing a whiteout operation, get us the wino we will be
> +	 * placing at the target.
> +	 */
> +	if (flags & RENAME_WHITEOUT) {
> +		ASSERT(!(flags & (RENAME_NOREPLACE | RENAME_EXCHANGE)));
> +		error = xfs_rename_get_wino(target_dp, &wino);
> +		if (error)
> +			return error;
> +
> +		/* setup target dirent info as whiteout */
> +		src_name->type = XFS_DIR3_FT_CHRDEV;
> +	}
> +
>  	new_parent = (src_dp != target_dp);
>  	src_is_directory = S_ISDIR(src_ip->i_d.di_mode);
>  
> -	xfs_sort_for_rename(src_dp, target_dp, src_ip, target_ip,
> +	xfs_sort_for_rename(src_dp, target_dp, src_ip, target_ip, wino,
>  				inodes, &num_inodes);
>  
> +	cancel_flags = 0;
>  	xfs_bmap_init(&free_list, &first_block);
>  	tp = xfs_trans_alloc(mp, XFS_TRANS_RENAME);
> -	cancel_flags = XFS_TRANS_RELEASE_LOG_RES;
>  	spaceres = XFS_RENAME_SPACE_RES(mp, target_name->len);
>  	error = xfs_trans_reserve(tp, &M_RES(mp)->tr_rename, spaceres, 0);
>  	if (error == -ENOSPC) {
>  		spaceres = 0;
>  		error = xfs_trans_reserve(tp, &M_RES(mp)->tr_rename, 0, 0);
>  	}
> -	if (error) {
> -		xfs_trans_cancel(tp, 0);
> -		goto std_return;
> -	}
> +	if (error)
> +		goto error_trans_cancel;
> +	cancel_flags = XFS_TRANS_RELEASE_LOG_RES;
>  
>  	/*
>  	 * Attach the dquots to the inodes
>  	 */
>  	error = xfs_qm_vop_rename_dqattach(inodes);
> -	if (error) {
> -		xfs_trans_cancel(tp, cancel_flags);
> -		goto std_return;
> -	}
> +	if (error)
> +		goto error_trans_cancel;
>  
>  	/*
>  	 * Lock all the participating inodes. Depending upon whether
> @@ -2921,6 +3030,8 @@ xfs_rename(
>  	xfs_trans_ijoin(tp, src_ip, XFS_ILOCK_EXCL);
>  	if (target_ip)
>  		xfs_trans_ijoin(tp, target_ip, XFS_ILOCK_EXCL);
> +	if (wino)
> +		xfs_trans_ijoin(tp, wino, XFS_ILOCK_EXCL);
>  
>  	/*
>  	 * If we are using project inheritance, we only allow renames
> @@ -2930,18 +3041,19 @@ xfs_rename(
>  	if (unlikely((target_dp->i_d.di_flags & XFS_DIFLAG_PROJINHERIT) &&
>  		     (xfs_get_projid(target_dp) != xfs_get_projid(src_ip)))) {
>  		error = -EXDEV;
> -		goto error_return;
> +		goto error_trans_cancel;
>  	}
>  
>  	/*
>  	 * Handle RENAME_EXCHANGE flags
>  	 */
>  	if (flags & RENAME_EXCHANGE) {
> +		ASSERT(!wino);
>  		error = xfs_cross_rename(tp, src_dp, src_name, src_ip,
>  					 target_dp, target_name, target_ip,
>  					 &free_list, &first_block, spaceres);
>  		if (error)
> -			goto abort_return;
> +			goto error_trans_abort;
>  		goto finish_rename;
>  	}
>  
> @@ -2956,7 +3068,7 @@ xfs_rename(
>  		if (!spaceres) {
>  			error = xfs_dir_canenter(tp, target_dp, target_name);
>  			if (error)
> -				goto error_return;
> +				goto error_trans_cancel;
>  		}
>  		/*
>  		 * If target does not exist and the rename crosses
> @@ -2967,9 +3079,9 @@ xfs_rename(
>  						src_ip->i_ino, &first_block,
>  						&free_list, spaceres);
>  		if (error == -ENOSPC)
> -			goto error_return;
> +			goto error_trans_cancel;
>  		if (error)
> -			goto abort_return;
> +			goto error_trans_abort;
>  
>  		xfs_trans_ichgtime(tp, target_dp,
>  					XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
> @@ -2977,7 +3089,7 @@ xfs_rename(
>  		if (new_parent && src_is_directory) {
>  			error = xfs_bumplink(tp, target_dp);
>  			if (error)
> -				goto abort_return;
> +				goto error_trans_abort;
>  		}
>  	} else { /* target_ip != NULL */
>  		/*
> @@ -2992,7 +3104,7 @@ xfs_rename(
>  			if (!(xfs_dir_isempty(target_ip)) ||
>  			    (target_ip->i_d.di_nlink > 2)) {
>  				error = -EEXIST;
> -				goto error_return;
> +				goto error_trans_cancel;
>  			}
>  		}
>  
> @@ -3009,7 +3121,7 @@ xfs_rename(
>  					src_ip->i_ino,
>  					&first_block, &free_list, spaceres);
>  		if (error)
> -			goto abort_return;
> +			goto error_trans_abort;
>  
>  		xfs_trans_ichgtime(tp, target_dp,
>  					XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
> @@ -3020,7 +3132,7 @@ xfs_rename(
>  		 */
>  		error = xfs_droplink(tp, target_ip);
>  		if (error)
> -			goto abort_return;
> +			goto error_trans_abort;
>  
>  		if (src_is_directory) {
>  			/*
> @@ -3028,9 +3140,9 @@ xfs_rename(
>  			 */
>  			error = xfs_droplink(tp, target_ip);
>  			if (error)
> -				goto abort_return;
> +				goto error_trans_abort;
>  		}
> -	} /* target_ip != NULL */
> +	}
>  
>  	/*
>  	 * Remove the source.
> @@ -3045,7 +3157,7 @@ xfs_rename(
>  					&first_block, &free_list, spaceres);
>  		ASSERT(error != -EEXIST);
>  		if (error)
> -			goto abort_return;
> +			goto error_trans_abort;
>  	}
>  
>  	/*
> @@ -3071,13 +3183,21 @@ xfs_rename(
>  		 */
>  		error = xfs_droplink(tp, src_dp);
>  		if (error)
> -			goto abort_return;
> +			goto error_trans_abort;
>  	}
>  
> -	error = xfs_dir_removename(tp, src_dp, src_name, src_ip->i_ino,
> +	/*
> +	 * On a whiteout, we only update the source dirent with the wino,
> +	 * otherwise we are removing it.
> +	 */
> +	if (wino) {
> +		error = xfs_dir_replace(tp, src_dp, src_name, wino->i_ino,
> +					&first_block, &free_list, spaceres);
> +	} else
> +		error = xfs_dir_removename(tp, src_dp, src_name, src_ip->i_ino,
>  					&first_block, &free_list, spaceres);
>  	if (error)
> -		goto abort_return;
> +		goto error_trans_abort;
>  
>  	xfs_trans_ichgtime(tp, src_dp, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
>  	xfs_trans_log_inode(tp, src_dp, XFS_ILOG_CORE);
> @@ -3090,31 +3210,58 @@ finish_rename:
>  	 * rename transaction goes to disk before returning to
>  	 * the user.
>  	 */
> -	if (mp->m_flags & (XFS_MOUNT_WSYNC|XFS_MOUNT_DIRSYNC)) {
> +	if (mp->m_flags & (XFS_MOUNT_WSYNC|XFS_MOUNT_DIRSYNC))
>  		xfs_trans_set_sync(tp);
> -	}
>  
>  	error = xfs_bmap_finish(&tp, &free_list, &committed);
> -	if (error) {
> -		xfs_bmap_cancel(&free_list);
> -		xfs_trans_cancel(tp, (XFS_TRANS_RELEASE_LOG_RES |
> -				 XFS_TRANS_ABORT));
> -		goto std_return;
> +	if (error)
> +		goto error_trans_abort;
> +
> +	/*
> +	 * Last thing we do is bump the link count on the wino. This means that
> +	 * failures all the way up to this point leave the wino on the unlinked
> +	 * list and so cleanup is a simple matter of dropping the remaining
> +	 * reference to it. If we fail here after bumping the link count, we're
> +	 * shutting down the filesystem so we'll never see the intermediate
> +	 * state on disk.
> +	 */
> +	if (wino) {
> +		ASSERT(wino->i_d.di_nlink == 0);
> +		error = xfs_bumplink(tp, wino);
> +		if (error)
> +			goto error_trans_abort;
> +		error = xfs_iunlink_remove(tp, wino);
> +		if (error)
> +			goto error_trans_abort;
> +		xfs_trans_log_inode(tp, wino, XFS_ILOG_CORE);
> +
> +		/*
> +		 * now we have a real link, clear the "I'm a tmpfile" state
> +		 * flag from the inode so it doesn't accidentally get misused in
> +		 * future.
> +		 */
> +		VFS_I(wino)->i_state &= ~I_LINKABLE;
>  	}
>  
>  	/*
>  	 * trans_commit will unlock src_ip, target_ip & decrement
>  	 * the vnode references.
>  	 */
> -	return xfs_trans_commit(tp, XFS_TRANS_RELEASE_LOG_RES);
> +	error = xfs_trans_commit(tp, XFS_TRANS_RELEASE_LOG_RES);
> +out_release_wino:
> +	if (wino)
> +		IRELE(wino);
> +	return error;
>  
> - abort_return:
> +
> +error_trans_abort:
>  	cancel_flags |= XFS_TRANS_ABORT;
> - error_return:
>  	xfs_bmap_cancel(&free_list);
> +error_trans_cancel:
>  	xfs_trans_cancel(tp, cancel_flags);
> - std_return:
> -	return error;
> +
> +	/* Dropping the last reference on a tmpfile does the cleanup for us! */
> +	goto out_release_wino;
>  }
>  
>  STATIC int
> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index 6a77ea9..d4442d1 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -393,7 +393,7 @@ xfs_vn_rename(
>  	struct xfs_name	oname;
>  	struct xfs_name	nname;
>  
> -	if (flags & ~(RENAME_NOREPLACE | RENAME_EXCHANGE))
> +	if (flags & ~(RENAME_NOREPLACE | RENAME_EXCHANGE | RENAME_WHITEOUT))
>  		return -EINVAL;
>  
>  	/* if we are exchanging files, we need to set i_mode of both files */
> -- 
> 2.0.0
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

-- 
Carlos

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
