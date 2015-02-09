Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 5EF657F9F
	for <xfs@oss.sgi.com>; Mon,  9 Feb 2015 12:18:58 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 4D9BB8F804C
	for <xfs@oss.sgi.com>; Mon,  9 Feb 2015 10:18:54 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 0CZJoiBWBZpVcdLS (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 09 Feb 2015 10:18:53 -0800 (PST)
Date: Mon, 9 Feb 2015 13:18:47 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs: inodes are new until the dentry cache is set up
Message-ID: <20150209181846.GF18336@laptop.bfoster>
References: <1423083409-28362-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1423083409-28362-1-git-send-email-david@fromorbit.com>
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

On Thu, Feb 05, 2015 at 07:56:49AM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Al Viro noticed a generic set of issues to do with filehandle lookup
> racing with dentry cache setup. They involve a filehandle lookup
> occurring while an inode is being created and the filehandle lookup
> racing with the dentry creation for the real file. This can lead to
> multiple dentries for the one path being instantiated. There are a
> host of other issues around this same set of paths.
> 
> The underlying cause is that file handle lookup only waits on inode
> cache instantiation rather than full dentry cache instantiation. XFS
> is mostly immune to the problems discovered due to it's own internal
> inode cache, but there are a couple of corner cases where races can
> happen.
> 
> We currently clear the XFS_INEW flag when the inode is fully set up
> after insertion into the cache. Newly allocated inodes are inserted
> locked and so aren't usable until the allocation transaction
> commits. This, however, occurs before the dentry and security
> information is fully initialised and hence the inode is unlocked and
> available for lookups to find too early.
> 
> To solve the problem, only clear the XFS_INEW flag for newly created
> inodes once the dentry is fully instantiated. This means lookups
> will retry until the XFS_INEW flag is removed from the inode and
> hence avoids the race conditions in questions.
> 
> THis also means that xfs_create(), xfs_create_tmpfile() and
> xfs_symlink() need to finish the setup of the inode in their error
> paths if we had allocated the inode but failed later in the creation
> process. xfs_symlink(), in particular, needed a lot of help to make
> it's error handling match that of xfs_create().
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_icache.c  |  4 ++--
>  fs/xfs/xfs_inode.c   | 22 ++++++++++++--------
>  fs/xfs/xfs_inode.h   | 22 ++++++++++++++++++++
>  fs/xfs/xfs_iops.c    | 24 +++++++++-------------
>  fs/xfs/xfs_iops.h    |  2 --
>  fs/xfs/xfs_qm.c      | 13 ++++++++----
>  fs/xfs/xfs_symlink.c | 58 ++++++++++++++++++++++++++++++----------------------
>  7 files changed, 90 insertions(+), 55 deletions(-)
> 
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index 9771b7e..76a9f27 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -439,11 +439,11 @@ again:
>  	*ipp = ip;
>  
>  	/*
> -	 * If we have a real type for an on-disk inode, we can set ops(&unlock)
> +	 * If we have a real type for an on-disk inode, we can setup the inode
>  	 * now.	 If it's a new inode being created, xfs_ialloc will handle it.
>  	 */
>  	if (xfs_iflags_test(ip, XFS_INEW) && ip->i_d.di_mode != 0)
> -		xfs_setup_inode(ip);
> +		xfs_setup_existing_inode(ip);
>  	return 0;
>  
>  out_error_or_again:
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index daafa1f..d0414f3 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -818,7 +818,7 @@ xfs_ialloc(
>  	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
>  	xfs_trans_log_inode(tp, ip, flags);
>  
> -	/* now that we have an i_mode we can setup inode ops and unlock */
> +	/* now that we have an i_mode we can setup the inode structure */
>  	xfs_setup_inode(ip);
>  
>  	*ipp = ip;
> @@ -1235,12 +1235,14 @@ xfs_create(
>  	xfs_trans_cancel(tp, cancel_flags);
>   out_release_inode:
>  	/*
> -	 * Wait until after the current transaction is aborted to
> -	 * release the inode.  This prevents recursive transactions
> -	 * and deadlocks from xfs_inactive.
> +	 * Wait until after the current transaction is aborted to finish the
> +	 * setup of the inode and release the inode.  This prevents recursive
> +	 * transactions and deadlocks from xfs_inactive.
>  	 */
> -	if (ip)
> +	if (ip) {
> +		xfs_finish_inode_setup(ip);
>  		IRELE(ip);
> +	}
>  
>  	xfs_qm_dqrele(udqp);
>  	xfs_qm_dqrele(gdqp);
> @@ -1345,12 +1347,14 @@ xfs_create_tmpfile(
>  	xfs_trans_cancel(tp, cancel_flags);
>   out_release_inode:
>  	/*
> -	 * Wait until after the current transaction is aborted to
> -	 * release the inode.  This prevents recursive transactions
> -	 * and deadlocks from xfs_inactive.
> +	 * Wait until after the current transaction is aborted to finish the
> +	 * setup of the inode and release the inode.  This prevents recursive
> +	 * transactions and deadlocks from xfs_inactive.
>  	 */
> -	if (ip)
> +	if (ip) {
> +		xfs_finish_inode_setup(ip);
>  		IRELE(ip);
> +	}
>  
>  	xfs_qm_dqrele(udqp);
>  	xfs_qm_dqrele(gdqp);
> diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
> index 86cd6b3..8e82b41 100644
> --- a/fs/xfs/xfs_inode.h
> +++ b/fs/xfs/xfs_inode.h
> @@ -390,6 +390,28 @@ int		xfs_zero_eof(struct xfs_inode *, xfs_off_t, xfs_fsize_t);
>  int		xfs_iozero(struct xfs_inode *, loff_t, size_t);
>  
>  
> +/* from xfs_iops.c */
> +/*
> + * When setting up a newly allocated inode, we need to call
> + * xfs_finish_inode_setup() once the inode is fully instantiated at
> + * the VFS level to prevent the rest of the world seeing the inode
> + * before we've completed instantiation. Otherwise we can do it
> + * the moment the inode lookup is complete.
> + */
> +extern void xfs_setup_inode(struct xfs_inode *ip);
> +static inline void xfs_finish_inode_setup(struct xfs_inode *ip)
> +{
> +	xfs_iflags_clear(ip, XFS_INEW);
> +	barrier();
> +	unlock_new_inode(VFS_I(ip));
> +}
> +
> +static inline void xfs_setup_existing_inode(struct xfs_inode *ip)
> +{
> +	xfs_setup_inode(ip);
> +	xfs_finish_inode_setup(ip);
> +}
> +
>  #define IHOLD(ip) \
>  do { \
>  	ASSERT(atomic_read(&VFS_I(ip)->i_count) > 0) ; \
> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index ce80eeb..8be5bb5 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -186,6 +186,8 @@ xfs_generic_create(
>  	else
>  		d_instantiate(dentry, inode);
>  
> +	xfs_finish_inode_setup(ip);
> +
>   out_free_acl:
>  	if (default_acl)
>  		posix_acl_release(default_acl);
> @@ -194,6 +196,7 @@ xfs_generic_create(
>  	return error;
>  
>   out_cleanup_inode:
> +	xfs_finish_inode_setup(ip);
>  	if (!tmpfile)
>  		xfs_cleanup_inode(dir, inode, dentry);
>  	iput(inode);
> @@ -366,9 +369,11 @@ xfs_vn_symlink(
>  		goto out_cleanup_inode;
>  
>  	d_instantiate(dentry, inode);
> +	xfs_finish_inode_setup(cip);
>  	return 0;
>  
>   out_cleanup_inode:
> +	xfs_finish_inode_setup(cip);
>  	xfs_cleanup_inode(dir, inode, dentry);
>  	iput(inode);
>   out:
> @@ -1231,16 +1236,12 @@ xfs_diflags_to_iflags(
>  }
>  
>  /*
> - * Initialize the Linux inode, set up the operation vectors and
> - * unlock the inode.
> - *
> - * When reading existing inodes from disk this is called directly
> - * from xfs_iget, when creating a new inode it is called from
> - * xfs_ialloc after setting up the inode.
> + * Initialize the Linux inode and set up the operation vectors.
>   *
> - * We are always called with an uninitialised linux inode here.
> - * We need to initialise the necessary fields and take a reference
> - * on it.
> + * When reading existing inodes from disk this is called directly from xfs_iget,
> + * when creating a new inode it is called from xfs_ialloc after setting up the
> + * inode. These callers have different criteria for clearing XFS_INEW, so leave
> + * it up to the caller to deal with unlocking the inode appropriately.
>   */
>  void
>  xfs_setup_inode(
> @@ -1327,9 +1328,4 @@ xfs_setup_inode(
>  		inode_has_no_xattr(inode);
>  		cache_no_acl(inode);
>  	}
> -
> -	xfs_iflags_clear(ip, XFS_INEW);
> -	barrier();
> -
> -	unlock_new_inode(inode);
>  }
> diff --git a/fs/xfs/xfs_iops.h b/fs/xfs/xfs_iops.h
> index 1c34e43..d4bcc29 100644
> --- a/fs/xfs/xfs_iops.h
> +++ b/fs/xfs/xfs_iops.h
> @@ -25,8 +25,6 @@ extern const struct file_operations xfs_dir_file_operations;
>  
>  extern ssize_t xfs_vn_listxattr(struct dentry *, char *data, size_t size);
>  
> -extern void xfs_setup_inode(struct xfs_inode *);
> -
>  /*
>   * Internal setattr interfaces.
>   */
> diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
> index 3e81862..1f9e23c 100644
> --- a/fs/xfs/xfs_qm.c
> +++ b/fs/xfs/xfs_qm.c
> @@ -719,6 +719,7 @@ xfs_qm_qino_alloc(
>  	xfs_trans_t	*tp;
>  	int		error;
>  	int		committed;
> +	bool		need_alloc = true;
>  
>  	*ip = NULL;
>  	/*
> @@ -747,6 +748,7 @@ xfs_qm_qino_alloc(
>  				return error;
>  			mp->m_sb.sb_gquotino = NULLFSINO;
>  			mp->m_sb.sb_pquotino = NULLFSINO;
> +			need_alloc = false;
>  		}
>  	}
>  
> @@ -758,7 +760,7 @@ xfs_qm_qino_alloc(
>  		return error;
>  	}
>  
> -	if (!*ip) {
> +	if (need_alloc) {
>  		error = xfs_dir_ialloc(&tp, NULL, S_IFREG, 1, 0, 0, 1, ip,
>  								&committed);
>  		if (error) {
> @@ -794,11 +796,14 @@ xfs_qm_qino_alloc(
>  	spin_unlock(&mp->m_sb_lock);
>  	xfs_log_sb(tp);
>  
> -	if ((error = xfs_trans_commit(tp, XFS_TRANS_RELEASE_LOG_RES))) {
> +	error = xfs_trans_commit(tp, XFS_TRANS_RELEASE_LOG_RES);
> +	if (error) {
> +		ASSERT(XFS_FORCED_SHUTDOWN(mp));
>  		xfs_alert(mp, "%s failed (error %d)!", __func__, error);
> -		return error;
>  	}
> -	return 0;
> +	if (need_alloc)
> +		xfs_finish_inode_setup(*ip);
> +	return error;
>  }
>  
>  
> diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
> index 25791df..3df411e 100644
> --- a/fs/xfs/xfs_symlink.c
> +++ b/fs/xfs/xfs_symlink.c
> @@ -177,7 +177,7 @@ xfs_symlink(
>  	int			pathlen;
>  	struct xfs_bmap_free	free_list;
>  	xfs_fsblock_t		first_block;
> -	bool			unlock_dp_on_error = false;
> +	bool                    unlock_dp_on_error = false;
>  	uint			cancel_flags;
>  	int			committed;
>  	xfs_fileoff_t		first_fsb;
> @@ -221,7 +221,7 @@ xfs_symlink(
>  			XFS_QMOPT_QUOTALL | XFS_QMOPT_INHERIT,
>  			&udqp, &gdqp, &pdqp);
>  	if (error)
> -		goto std_return;
> +		return error;
>  
>  	tp = xfs_trans_alloc(mp, XFS_TRANS_SYMLINK);
>  	cancel_flags = XFS_TRANS_RELEASE_LOG_RES;
> @@ -241,7 +241,7 @@ xfs_symlink(
>  	}
>  	if (error) {
>  		cancel_flags = 0;
> -		goto error_return;
> +		goto out_trans_cancel;
>  	}
>  
>  	xfs_ilock(dp, XFS_ILOCK_EXCL | XFS_ILOCK_PARENT);
> @@ -252,7 +252,7 @@ xfs_symlink(
>  	 */
>  	if (dp->i_d.di_flags & XFS_DIFLAG_NOSYMLINKS) {
>  		error = -EPERM;
> -		goto error_return;
> +		goto out_trans_cancel;
>  	}
>  
>  	/*
> @@ -261,7 +261,7 @@ xfs_symlink(
>  	error = xfs_trans_reserve_quota(tp, mp, udqp, gdqp,
>  						pdqp, resblks, 1, 0);
>  	if (error)
> -		goto error_return;
> +		goto out_trans_cancel;
>  
>  	/*
>  	 * Check for ability to enter directory entry, if no space reserved.
> @@ -269,7 +269,7 @@ xfs_symlink(
>  	if (!resblks) {
>  		error = xfs_dir_canenter(tp, dp, link_name);
>  		if (error)
> -			goto error_return;
> +			goto out_trans_cancel;
>  	}
>  	/*
>  	 * Initialize the bmap freelist prior to calling either
> @@ -282,15 +282,14 @@ xfs_symlink(
>  	 */
>  	error = xfs_dir_ialloc(&tp, dp, S_IFLNK | (mode & ~S_IFMT), 1, 0,
>  			       prid, resblks > 0, &ip, NULL);
> -	if (error) {
> -		if (error == -ENOSPC)
> -			goto error_return;
> -		goto error1;
> -	}
> +	if (error)
> +		goto out_trans_cancel;
>  
>  	/*
> -	 * An error after we've joined dp to the transaction will result in the
> -	 * transaction cancel unlocking dp so don't do it explicitly in the
> +	 * Now we join the directory inode to the transaction.  We do not do it
> +	 * earlier because xfs_dir_ialloc might commit the previous transaction
> +	 * (and release all the locks).  An error from here on will result in
> +	 * the transaction cancel unlocking dp so don't do it explicitly in the
>  	 * error path.
>  	 */
>  	xfs_trans_ijoin(tp, dp, XFS_ILOCK_EXCL);
> @@ -330,7 +329,7 @@ xfs_symlink(
>  				  XFS_BMAPI_METADATA, &first_block, resblks,
>  				  mval, &nmaps, &free_list);
>  		if (error)
> -			goto error2;
> +			goto out_bmap_cancel;
>  
>  		if (resblks)
>  			resblks -= fs_blocks;
> @@ -348,7 +347,7 @@ xfs_symlink(
>  					       BTOBB(byte_cnt), 0);
>  			if (!bp) {
>  				error = -ENOMEM;
> -				goto error2;
> +				goto out_bmap_cancel;
>  			}
>  			bp->b_ops = &xfs_symlink_buf_ops;
>  
> @@ -378,7 +377,7 @@ xfs_symlink(
>  	error = xfs_dir_createname(tp, dp, link_name, ip->i_ino,
>  					&first_block, &free_list, resblks);
>  	if (error)
> -		goto error2;
> +		goto out_bmap_cancel;
>  	xfs_trans_ichgtime(tp, dp, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
>  	xfs_trans_log_inode(tp, dp, XFS_ILOG_CORE);
>  
> @@ -392,10 +391,13 @@ xfs_symlink(
>  	}
>  
>  	error = xfs_bmap_finish(&tp, &free_list, &committed);
> -	if (error) {
> -		goto error2;
> -	}
> +	if (error)
> +		goto out_bmap_cancel;
> +
>  	error = xfs_trans_commit(tp, XFS_TRANS_RELEASE_LOG_RES);
> +	if (error)
> +		goto out_release_inode;
> +
>  	xfs_qm_dqrele(udqp);
>  	xfs_qm_dqrele(gdqp);
>  	xfs_qm_dqrele(pdqp);
> @@ -403,20 +405,28 @@ xfs_symlink(
>  	*ipp = ip;
>  	return 0;
>  
> - error2:
> -	IRELE(ip);
> - error1:
> +out_bmap_cancel:
>  	xfs_bmap_cancel(&free_list);
>  	cancel_flags |= XFS_TRANS_ABORT;
> - error_return:
> +out_trans_cancel:
>  	xfs_trans_cancel(tp, cancel_flags);
> +out_release_inode:
> +	/*
> +	 * Wait until after the current transaction is aborted to finish the
> +	 * setup of the inode and release the inode.  This prevents recursive
> +	 * transactions and deadlocks from xfs_inactive.
> +	 */
> +	if (ip) {
> +		xfs_finish_inode_setup(ip);
> +		IRELE(ip);
> +	}
> +
>  	xfs_qm_dqrele(udqp);
>  	xfs_qm_dqrele(gdqp);
>  	xfs_qm_dqrele(pdqp);
>  
>  	if (unlock_dp_on_error)
>  		xfs_iunlock(dp, XFS_ILOCK_EXCL);
> - std_return:
>  	return error;
>  }
>  
> -- 
> 2.0.0
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
