Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 3A7AE7F3F
	for <xfs@oss.sgi.com>; Thu,  8 Jan 2015 09:32:15 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id F2444304039
	for <xfs@oss.sgi.com>; Thu,  8 Jan 2015 07:32:11 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id nlOdw3Uyw0KxEgyl (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 08 Jan 2015 07:32:10 -0800 (PST)
Date: Thu, 8 Jan 2015 10:32:05 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs: inodes are new until the dentry cache is set up
Message-ID: <20150108153205.GE33789@bfoster.bfoster>
References: <1420667576-7592-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1420667576-7592-1-git-send-email-david@fromorbit.com>
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

On Thu, Jan 08, 2015 at 08:52:56AM +1100, Dave Chinner wrote:
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
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_icache.c |  4 ++--
>  fs/xfs/xfs_inode.c  |  2 +-
>  fs/xfs/xfs_inode.h  | 22 ++++++++++++++++++++++
>  fs/xfs/xfs_iops.c   | 24 ++++++++++--------------
>  fs/xfs/xfs_iops.h   |  2 --
>  fs/xfs/xfs_qm.c     | 13 +++++++++----
>  6 files changed, 44 insertions(+), 23 deletions(-)
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
> index 9916aef..400791a 100644
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
> diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
> index f772296..de97ccc 100644
> --- a/fs/xfs/xfs_inode.h
> +++ b/fs/xfs/xfs_inode.h
> @@ -381,6 +381,28 @@ int		xfs_zero_eof(struct xfs_inode *, xfs_off_t, xfs_fsize_t);
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

Ok, but what about post-inode-allocation failure conditions down in
xfs_create()? I don't know if there's any real harm in releasing an
I_NEW inode, but iput_final() does throw a warning. Same general
question applies to xfs_create_tmpfile(), etc..

Brian

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
