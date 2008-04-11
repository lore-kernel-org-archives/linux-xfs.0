Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 10 Apr 2008 21:39:26 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m3B4cxpU012868
	for <xfs@oss.sgi.com>; Thu, 10 Apr 2008 21:39:03 -0700
Date: Fri, 11 Apr 2008 14:40:09 +1000
Subject: Re: [PATCH 2/2] simplify xfs_lock_for_rename
From: "Barry Naujok" <bnaujok@sgi.com>
Content-Type: text/plain; format=flowed; delsp=yes; charset=utf-8
MIME-Version: 1.0
References: <20080410184413.GB6771@lst.de>
Message-ID: <op.t9fi87c93jf8g2@pc-bnaujok.melbourne.sgi.com>
In-Reply-To: <20080410184413.GB6771@lst.de>
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

On Fri, 11 Apr 2008 04:44:13 +1000, Christoph Hellwig <hch@lst.de> wrote:

> as with lookup merge what's left of xfs_dir_lookup_int into it, kill
> a useless lock roundtrip left over from IRIX and kill a bunch of useless
> variables.
>
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
>
> Index: linux-2.6-xfs/fs/xfs/xfs_rename.c
> ===================================================================
> --- linux-2.6-xfs.orig/fs/xfs/xfs_rename.c	2008-04-09 20:30:08.000000000  
> +0200
> +++ linux-2.6-xfs/fs/xfs/xfs_rename.c	2008-04-10 08:58:50.000000000 +0200
> @@ -67,10 +67,6 @@ xfs_rename_unlock4(
>  	}
>  }
> -#ifdef DEBUG
> -int xfs_rename_skip, xfs_rename_nskip;
> -#endif
> -
>  /*
>   * The following routine will acquire the locks required for a rename
>   * operation. The code understands the semantics of renames and will
> @@ -92,47 +88,33 @@ xfs_lock_for_rename(
>  	xfs_inode_t	**i_tab,/* out: array of inode returned, sorted */
>  	int		*num_inodes)  /* out: number of inodes in array */
>  {
> -	xfs_inode_t		*ip2 = NULL;
>  	xfs_inode_t		*temp;
> -	xfs_ino_t		inum1, inum2;
> +	xfs_ino_t		inum2;
>  	int			error;
>  	int			i, j;
>  	uint			lock_mode;
> -	int			diff_dirs = (dp1 != dp2);
> -	/*
> -	 * First, find out the current inums of the entries so that we
> -	 * can determine the initial locking order.  We'll have to
> -	 * sanity check stuff after all the locks have been acquired
> -	 * to see if we still have the right inodes, directories, etc.
> -	 */
> -	lock_mode = xfs_ilock_map_shared(dp1);
> +	*ipp2 = NULL;
> +
>  	IHOLD(ip1);
>  	xfs_itrace_ref(ip1);
> -	inum1 = ip1->i_ino;
> -
> -	/*
> -	 * Unlock dp1 and lock dp2 if they are different.
> -	 */
> -	if (diff_dirs) {
> -		xfs_iunlock_map_shared(dp1, lock_mode);
> -		lock_mode = xfs_ilock_map_shared(dp2);
> +	lock_mode = xfs_ilock_map_shared(dp2);
> +	error = xfs_dir_lookup(NULL, dp2, name2, &inum2);
> +	if (!error) {
> +		xfs_iunlock(dp2, lock_mode);
> +		error = xfs_iget(dp2->i_mount, NULL, inum2, 0, 0, ipp2, 0);
> +		xfs_ilock(dp2, lock_mode);


Is this xfs_dir_lookup call actually needed?

It seems that do_rename() in namei.c calls lookup_hash/__lookup_hash
which does an inode->i_op->lookup() to get the dentry. This will do
the xfs_lookup anyway, taking a refernence if the target exists.

	error = do_path_lookup(newdfd, newname, LOOKUP_PARENT, &newnd);
	...
	new_dentry = lookup_hash(&newnd);
	...
	error = vfs_rename(old_dir->d_inode, old_dentry,
				   new_dir->d_inode, new_dentry);

Therefore, target_ip/ipp2 is already known then when xfs_rename/
xfs_lock_for_rename is called.

Barry.
