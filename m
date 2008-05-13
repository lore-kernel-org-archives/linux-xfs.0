Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 13 May 2008 01:57:01 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m4D8uc3Z012914
	for <xfs@oss.sgi.com>; Tue, 13 May 2008 01:56:42 -0700
Date: Tue, 13 May 2008 04:57:24 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/4] XFS: Return case-insensitive match for dentry cache
Message-ID: <20080513085724.GC21919@infradead.org>
References: <20080513075749.477238845@chook.melbourne.sgi.com> <20080513080152.911303131@chook.melbourne.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080513080152.911303131@chook.melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Barry Naujok <bnaujok@sgi.com>
Cc: xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org, aia21@cantab.net

First please Cc Anton on this as he wrote the original version of
what's now d_add_ci, I suspect he might have some useful comments.


On Tue, May 13, 2008 at 05:57:52PM +1000, Barry Naujok wrote:
> Another unusual interaction with the dcache is not storing 
> negative dentries like other filesystems doing a d_add(dentry, NULL)
> when an ENOENT is returned. During the VFS lookup, if a dentry
> returned has no inode, dput is called and ENOENT is returned.
> By not doing a d_add, this actually removes it completely from
> the dcache to be reused.

That is a way to implement this correctly, but I suspect not creating
negative dentries will degrade performance quite badly on some
workloads.  Then again CI is useful only for samba serving where the
namecache on the client side should mitigate that effect.

We'd probably be better off long-term implementing Anton's earlier
suggestion to have a routine that purges all ci aliased negative
dentries on a successfull lookup.


> create/rename have to be modified to
> support unhashed dentries being passed in.




> +	if (ci_sfep)
> +		return XFS_ERROR(xfs_dir_cilookup_result(args,
> +					ci_sfep->name, ci_sfep->namelen));

Putting a function call inside XFS_ERROR is quite unreadable.  Should be
easy to fix as there's already an error variable in scope.


> @@ -1646,15 +1653,18 @@ xfs_lookup(
>  		return XFS_ERROR(EIO);
>  
>  	lock_mode = xfs_ilock_map_shared(dp);
> -	error = xfs_dir_lookup(NULL, dp, name, &inum);
> +	error = xfs_dir_lookup(NULL, dp, name, &inum, ci_match);
>  	xfs_iunlock_map_shared(dp, lock_mode);
>  
>  	if (error)
>  		goto out;
>  
>  	error = xfs_iget(dp->i_mount, NULL, inum, 0, 0, ipp, 0);
> -	if (error)
> +	if (error) {
> +		if (ci_match && *ci_match)
> +			kmem_free(name->name, name->len);
>  		goto out;

normal style would be to add a out_free_name label for this one to move
the error handling code into one place at the end of the function.
